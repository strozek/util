#!/bin/tcsh

if ($# == 0) then
    echo "usage: rm file ..."
    echo "       send file to Trash (2004, Lukasz Strozek)"
    exit
endif

if ("$1" == "-r") then
    shift
endif

if ("$1" == "-rf") then
    shift
endif

if ("$1" == "-f") then
    shift
endif

while ($# >= 1)

    # check if the file/directory exists
    #
    if !(-e "$1") then
        echo "rm: ${1}: no such file or directory"
        shift
        continue
    endif

    # remove trailing slash
    #
    set input=`echo $1 | sed 's/\/$//g'`

    set file=`basename "$input"`                # just filename
    set base=`echo $file | sed 's/\.[^.]*$//g'` # base name (no extension)
    set temp=`echo $file | egrep '\.'`          # filename or nothing if no ext
    set ext=`echo $temp | sed 's/.*\.//'`       # extension

    # nonempty extensions get a . prepended
    # 
    if ("$ext" != "") set ext=".$ext"

    # check if such name exists
    #
    set newname="$file"
    if (-e "$HOME/.Trash/$file") then
        set newname="$base copy$ext"
        if(-e "$HOME/.Trash/$newname") then
            set count=1
            while(-e "$HOME/.Trash/$base copy $count$ext")
                @ count++
            end
            set newname="$base copy $count$ext"
        endif
    endif
    mv "$input" "$HOME/.Trash/$newname"
    shift
end
