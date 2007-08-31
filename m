Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 18:14:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7V1EW4p022343
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 18:14:35 -0700
Date: Fri, 31 Aug 2007 11:17:41 +1000
Subject: Re: About errors in XFS header  files and xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <46D6F066.5000009@op.pl>
Message-ID: <op.txwgjrfz3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46D6F066.5000009@op.pl>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bogdan <bogdandr@op.pl>, xfs@oss.sgi.com

On Fri, 31 Aug 2007 02:29:26 +1000, Bogdan <bogdandr@op.pl> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: RIPEMD160
>
>  Hello.
>
>  The XFS library header files contained in xfsprogs (2.9.3-1) contain
> many errors. Run the following command on a Linux system to verify:
>
> gcc -Wall -Wextra -Wfloat-equal -Wbad-function-cast -Wsign-compare
> - -Wunreachable-code -Wpointer-arith -Wcast-qual -Wcast-align
> - -Wstrict-prototypes -Wformat-security -Wformat-nonliteral
> - -Wnested-externs -Wshadow -Wconversion -Wdeclaration-after-statement
> - -Wundef -Wpadded -Wredundant-decls -pedantic -c -o xfs_repair.o
> xfs_repair.c
>
> (you can use any file which #includes the libxfs.h header). The use of
> 'long long' is less important. The header files should not only be
> ISO-C-compatible, but even ANSI-C-compatible. This will allow anyone
> to use them.

I wouldn't call "padding struct to align..." an error either.

I'm guessing (not 100% sure) all the "warning: ISO C forbids
braced-groups within expressions" is from the endian swap calls which
eventually gets to __swabXX() #defines with {} in them in swab.h.

Related is the warning "declaration of '__x' shadows a
previous local" caused by the beXX_add() functions doing a double
__swabXX() call. Can't see an easy solution to these.

"passing argument n of 'func' with different width due to prototype"
doesn't seem to be an issue either. Could add lots of casts to hide it.

Redeclaring optind in platform_getoptreset() in linux.h could be fixed.


>  Also, a following error occurs in the library:
>
>  gcc -g -O2 -DDEBUG -DVERSION=\"2.9.3\"
> - -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\"
> - -I./include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char
> - -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION=\"2.9.3\"
> - -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\"
> - -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char
> - -fno-strict-aliasing -Wall -c xfs_bmap.c  -fPIC -DPIC -o
> .libs/xfs_bmap.o
>
> xfs_bmap.c: In function 'xfs_bmap_add_extent':
> xfs_bmap.c:287: warning: implicit declaration of function
> 'xfs_bmap_check_leaf_extents'
>
> and because of this, we have:
>
> ../libxfs/.libs/libxfs.a(xfs_bmap.o)(.text+0x6cf1): In function
> `xfs_bmap_add_extent':
> xfsprogs-2.9.3/libxfs/xfs_bmap.c:287: undefined reference to
> `xfs_bmap_check_leaf_extents'
> collect2: ld returned 1 exit status
> gmake[1]: *** [xfs_copy] Error 1

It is a known issue that libxfs does not build with DEBUG defined.
In the libxfs Makefile:

# don't try linking xfs_repair with a debug libxfs.
DEBUG = -DNDEBUG

Regards,
Barry.
