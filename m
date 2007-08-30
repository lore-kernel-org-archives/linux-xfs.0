Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 09:45:24 -0700 (PDT)
Received: from smtp28.poczta.onet.pl (smtp28.poczta.onet.pl [213.180.130.99])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UGjI4p025375
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 09:45:21 -0700
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:60759 "EHLO
	orion.wszechswiat.org") by ps28.test.onet.pl with ESMTP
	id <S2246104AbXH3Q3o> (ORCPT <rfc822;xfs@oss.sgi.com>);
	Thu, 30 Aug 2007 18:29:44 +0200
Message-ID: <46D6F066.5000009@op.pl>
Date: Thu, 30 Aug 2007 18:29:26 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: About errors in XFS header  files and xfsprogs
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

 Hello.

 The XFS library header files contained in xfsprogs (2.9.3-1) contain
many errors. Run the following command on a Linux system to verify:

gcc -Wall -Wextra -Wfloat-equal -Wbad-function-cast -Wsign-compare
- -Wunreachable-code -Wpointer-arith -Wcast-qual -Wcast-align
- -Wstrict-prototypes -Wformat-security -Wformat-nonliteral
- -Wnested-externs -Wshadow -Wconversion -Wdeclaration-after-statement
- -Wundef -Wpadded -Wredundant-decls -pedantic -c -o xfs_repair.o
xfs_repair.c

(you can use any file which #includes the libxfs.h header). The use of
'long long' is less important. The header files should not only be
ISO-C-compatible, but even ANSI-C-compatible. This will allow anyone
to use them.

 Please, make useful public functions available in header files.
Especially platform_check_ismounted() and platform_check_iswritable()
and other "platform" functions.

 Also, anything that is a part of the public interface, should be in
the "xfs namespace", i.e. start with "xfs_". At least one issue of
this type is known: the list_head structure, declared in other files
from other libraries. Things like these are very important to fix,
because they are making other header files useless.

 You shouldn't handle gettext and internationalization in header
files. Let users do it by themselves. Otherwise, a double-defined
errors occur for the "_" macro.

 Also, a following error occurs in the library:

 gcc -g -O2 -DDEBUG -DVERSION=\"2.9.3\"
- -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\"
- -I./include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char
- -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION=\"2.9.3\"
- -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\"
- -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char
- -fno-strict-aliasing -Wall -c xfs_bmap.c  -fPIC -DPIC -o
.libs/xfs_bmap.o

xfs_bmap.c: In function 'xfs_bmap_add_extent':
xfs_bmap.c:287: warning: implicit declaration of function
'xfs_bmap_check_leaf_extents'

and because of this, we have:

../libxfs/.libs/libxfs.a(xfs_bmap.o)(.text+0x6cf1): In function
`xfs_bmap_add_extent':
xfsprogs-2.9.3/libxfs/xfs_bmap.c:287: undefined reference to
`xfs_bmap_check_leaf_extents'
collect2: ld returned 1 exit status
gmake[1]: *** [xfs_copy] Error 1


- --
Pozdrawiam/Regards - Bogdan                         (Linux & FreeDOS)
Kurs asemblera x86  (DOS & Linux):  http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
Rozmawiaj bezpiecznie: www.JabberPL.org Surfuj anonimowo: tor.eff.org
-----BEGIN PGP SIGNATURE-----

iD8DBQFG1vBmNTrTaBxW2h4RA49wAKCTVaJ47Fp/hAVGbJd+ewVvbeoxLACeOIrL
sslZvDs9bl6QG/W09SwosYw=
=s/eu
-----END PGP SIGNATURE-----
