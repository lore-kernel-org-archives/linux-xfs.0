Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Jul 2007 08:05:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6LF51bm006648
	for <xfs@oss.sgi.com>; Sat, 21 Jul 2007 08:05:02 -0700
Message-ID: <46A2209F.2030108@sandeen.net>
Date: Sat, 21 Jul 2007 10:05:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfs-cmds doesn't build... (cvs & 2.9.2...)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, Barry Naujok <bnaujok@sgi.com>

cvs:

[sandeen@sandeen xfs-cmds]$ make
....
== Building xfsprogs
== clean, log is Logs/clean
make: *** [cmds] Error 1
[sandeen@sandeen xfs-cmds]$ cat xfsprogs/Logs/clean
make[1]: Entering directory `/src/cvs/xfs-cmds/xfsprogs'
=== include ===
gmake[2]: *** No rule to make target `mdrestore'.  Stop.
make[1]: *** [mdrestore] Error 2
make[1]: Leaving directory `/src/cvs/xfs-cmds/xfsprogs'
[sandeen@sandeen xfs-cmds]$ grep -B1 mdrestore xfsprogs/Makefile
SUBDIRS = include libxfs libxlog libxcmd libhandle libdisk \
        copy db fsck growfs io logprint mkfs quota mdrestore repair rtcp \
[sandeen@sandeen xfs-cmds]$ ls xfsprogs/mdrestore
ls: xfsprogs/mdrestore: No such file or directory


2.9.2 tarball:
[sandeen@sandeen xfsprogs-2.9.2]$ make
....
metadump.c:28:26: xfs_metadump.h: No such file or directory
metadump.c:50: error: syntax error before '*' token
metadump.c:50: warning: type defaults to `int' in declaration of `metablock'
metadump.c:50: warning: data definition has no type or storage class
metadump.c: In function `write_index':
metadump.c:140: error: request for member `mb_count' in something not a
structure or union
metadump.c: In function `metadump_f':
metadump.c:1481: error: `xfs_metablock_t' undeclared (first use in this
function)
metadump.c:1481: error: (Each undeclared identifier is reported only once
metadump.c:1481: error: for each function it appears in.)
metadump.c:1481: error: syntax error before ')' token
metadump.c:1486: error: request for member `mb_blocklog' in something
not a structure or union
metadump.c:1487: error: request for member `mb_magic' in something not a
structure or union
metadump.c:1487: error: `XFS_MD_MAGIC' undeclared (first use in this
function)
gmake[2]: *** [metadump.o] Error 1
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/xfsprogs-2.9.2'
make: *** [default] Error 2
[sandeen@sandeen xfsprogs-2.9.2]$ find . -name xfs_metadump.h
[sandeen@sandeen xfsprogs-2.9.2]$
