Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 00:31:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G7Vcbm013773
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 00:31:40 -0700
Subject: TAKE 962220 - xfs-repair - Perform better read-ahead prefetching for phase 3/6.
Message-Id: <20070716073135.CB8E758C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 17:31:35 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Perform true sequential bulk read prefetching in xfs_repair


Date:  Mon Jul 16 17:31:01 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-patch
Inspected by:  markgw@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29147a
xfsprogs/repair/radix-tree.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/radix-tree.h
xfsprogs/repair/radix-tree.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/radix-tree.c
xfsprogs/man/man8/xfs_repair.8 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_repair.8.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/include/libxfs.h - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
xfsprogs/repair/phase6.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
xfsprogs/repair/phase7.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/repair/dir2.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/repair/dir.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/repair/phase4.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/repair/dinode.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfsprogs/repair/dinode.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/repair/phase5.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase5.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/repair/dir_stack.c - 1.11 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir_stack.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/repair/dir_stack.h - 1.7 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir_stack.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
xfsprogs/repair/init.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/init.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/repair/globals.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/repair/phase3.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase3.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/repair/incore_ext.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_ext.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/repair/Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/repair/xfs_repair.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsprogs/repair/dino_chunks.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dino_chunks.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/repair/incore.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/repair/incore.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/repair/incore_ino.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_ino.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/repair/scan.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/libxfs/rdwr.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
xfsprogs/libxfs/trans.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/trans.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/libxfs/init.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
xfsprogs/libxfs/Makefile - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/Makefile.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/libxfs/init.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/libxfs/linux.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/linux.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/libxfs/darwin.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/darwin.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/libxfs/irix.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/irix.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/libxfs/freebsd.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/freebsd.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/include/linux.h - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/linux.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
xfsprogs/include/cache.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/cache.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/libxfs/cache.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/cache.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/repair/prefetch.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/libxfs/lio.c - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/lio.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/repair/prefetch.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/prefetch.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/repair/threads.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/threads.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/repair/threads.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/threads.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfsprogs/repair/progress.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/progress.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfsprogs/repair/progress.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/progress.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Perform parallel sequential bulk read prefetching in xfs_repair
