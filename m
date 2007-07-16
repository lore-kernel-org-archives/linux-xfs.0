Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 22:25:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G5PMbm017074
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:25:25 -0700
Subject: TAKE 962222 - xfs-repair - Significantly improve nlink / phase 7 performance
Message-Id: <20070716052518.8AE6058C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 15:25:18 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Cache disk nlink values in Phase 3 for Phase 7


Date:  Mon Jul 16 15:24:18 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29142a
xfsprogs/repair/phase6.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- Rename full_backptrs to full_ino_ex_data

xfsprogs/repair/phase7.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Compare disk and counted nlink counts in memory and update
	  on-disk inode if required

xfsprogs/repair/globals.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Rename full_backptrs to full_ino_ex_data

xfsprogs/repair/Makefile - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/Makefile.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Minore cleanup

xfsprogs/repair/xfs_repair.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- Flush dirty data instead of purging all data

xfsprogs/repair/dino_chunks.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dino_chunks.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Store nlink count from disk in inode scan

xfsprogs/repair/incore.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Add disk nlink field and nlink ops for memory optimised counts

xfsprogs/repair/incore_ino.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/incore_ino.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Implementation of nlink ops for memory optimised counts
