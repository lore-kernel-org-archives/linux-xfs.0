Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 18:50:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E1oD4x028252
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 18:50:15 -0700
Subject: TAKE 977637 - Duplicate sb_features2 into following 4 bytes in superblock due to bug
Message-Id: <20080414015047.BA5C958C4C15@chook.melbourne.sgi.com>
Date: Mon, 14 Apr 2008 11:50:47 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon Apr 14 11:50:24 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30855a
xfsprogs/db/sb.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/sb.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Update xfs_db for extra superblock field

xfsprogs/db/check.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Detect features2 in wrong location in superblock

xfsprogs/mkfs/xfs_mkfs.c - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
	- Make sure features2 is the same in bad and good locations when creating a filesystem

xfsprogs/include/xfs_sb.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_sb.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Add sb_bad_features2 to superblock structure

xfsprogs/repair/phase1.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase1.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Detect and fix features2 in wrong location

xfsprogs/libxfs/xfs_mount.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_mount.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
	- Add sb_bad_features2 to superblock structure
