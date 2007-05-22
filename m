Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 May 2007 01:42:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M8gCWt024271
	for <xfs@oss.sgi.com>; Tue, 22 May 2007 01:42:14 -0700
Subject: TAKE 964999 - lazy superblock counters for XFS
Message-Id: <20070522084207.AFF6658CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 18:42:07 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Userspace support for lazy superblock counters

libxfs changes to match kernel support
repair, db, growfs and mkfs changes needed to support this feature.


Date:  Tue May 22 18:41:32 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28654a
xfsprogs/db/sb.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/sb.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/db/agf.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/agf.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/db/check.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/man/man8/mkfs.xfs.8 - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
xfsprogs/growfs/xfs_growfs.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_growfs.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/include/xfs_ialloc.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/include/xfs_ag.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ag.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/include/xfs_sb.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_sb.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
xfsprogs/include/xfs_fs.h - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_fs.h.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
xfsprogs/include/libxfs.h - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
xfsprogs/include/xfs_mount.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_mount.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
xfsprogs/include/xfs_trans.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_trans.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_alloc.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_alloc.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/repair/phase5.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase5.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/libxfs/xfs_ialloc.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
xfsprogs/libxfs/xfs.h - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs.h.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
xfsprogs/libxfs/init.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
xfsprogs/libxfs/xfs_mount.c - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_mount.c.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
xfsprogs/libxfs/xfs_alloc.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfsprogs/libxfs/xfs_alloc_btree.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Userspace support for lazy superblock counters
