function __fish_print_pacman_packages
    # Caches for 5 minutes
    type -q -f pacman || return 1

    argparse i/installed -- $argv
    or return 1

    # Set up cache directory
    set -l xdg_cache_home $XDG_CACHE_HOME
    if test -z "$xdg_cache_home"
        set xdg_cache_home $HOME/.cache
    end
    mkdir -m 700 -p $xdg_cache_home
    if not set -q only_installed
        set -l cache_file $xdg_cache_home/.pac-cache.$USER
        if test -f $cache_file
            cat $cache_file
            set -l age (math (date +%s) - (stat -c '%Y' $cache_file))
            set -l max_age 250
            if test $age -lt $max_age
                return
            end
        end
        # prints: <package name>	Package
        pacman -Ssq | sed -e 's/$/\t'Package'/' >$cache_file &
        return 0
    else
        pacman -Q | string replace ' ' \t
        return 0
    end
end