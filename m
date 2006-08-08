Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Aug 2006 00:09:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7879LDW005690
	for <linux-xfs@oss.sgi.com>; Tue, 8 Aug 2006 00:09:32 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA14762 for <linux-xfs@oss.sgi.com>; Tue, 8 Aug 2006 17:08:43 +1000
Subject: TAKE 952342 - xfsprogs
Message-Id: <20060808070843.39DA558C6F7C@chook.melbourne.sgi.com>
Date: Tue,  8 Aug 2006 17:08:43 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Allow tools to use direct IO on Linux when reading from the device,
if the device supports it, and if the tools is OK with that (most are).
Mainly for xfs_repair speedups, now that libxfs caches metadata buffers
internally.

Date:  Tue Aug  8 16:56:28 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  madan,sjv

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26728a
xfsprogs/mkfs/xfs_mkfs.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
xfsprogs/include/libxfs.h - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
xfsprogs/repair/sb.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/sb.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/repair/init.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/init.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/repair/protos.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/protos.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/repair/globals.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/repair/Makefile - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/Makefile.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/repair/phase1.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase1.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/repair/xfs_repair.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/repair/io.c - 1.12 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/io.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/libxfs/rdwr.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
xfsprogs/libxfs/init.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
xfsprogs/libxfs/init.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/libxfs/linux.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/linux.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/po/Makefile - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/po/Makefile.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/libxfs/darwin.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/darwin.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
xfsprogs/libxfs/irix.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/irix.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
xfsprogs/libxfs/freebsd.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/freebsd.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/copy/xfs_copy.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/copy/xfs_copy.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h


Bump xfsprogs version number after recent changes.

Date:  Tue Aug  8 17:07:53 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  nathans

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26733a
xfsprogs/VERSION - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
xfsprogs/doc/CHANGES - 1.216 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.216&r2=text&tr2=1.215&f=h
xfsprogs/debian/changelog - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/debian/changelog.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
