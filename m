Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 19:01:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4Q210Oj027165
	for <xfs@oss.sgi.com>; Sun, 25 May 2008 19:01:02 -0700
Subject: TAKE 981508 - ASCII case-insensitive support for xfsprogs
Message-Id: <20080526020147.9CF7558C4C29@chook.melbourne.sgi.com>
Date: Mon, 26 May 2008 12:01:47 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon May 26 12:01:26 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31229a
xfsprogs/db/sb.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/sb.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
xfsprogs/db/check.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/check.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- ASCII case-insensitive support for xfsprogs

xfsprogs/VERSION - 1.181 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.181&r2=text&tr2=1.180&f=h
	- Bump to 2.10.0

xfsprogs/doc/CHANGES - 1.253 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.253&r2=text&tr2=1.252&f=h
xfsprogs/man/man8/mkfs.xfs.8 - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
xfsprogs/mkfs/xfs_mkfs.c - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
xfsprogs/mkfs/xfs_mkfs.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfsprogs/growfs/xfs_growfs.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_growfs.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsprogs/include/xfs_da_btree.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_da_btree.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/include/xfs_sb.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_sb.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfsprogs/include/xfs_fs.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_fs.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
xfsprogs/include/libxfs.h - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
xfsprogs/repair/phase6.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
xfsprogs/libxfs/xfs_da_btree.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_da_btree.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
xfsprogs/libxfs/xfs_dir2_block.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_block.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsprogs/libxfs/xfs_dir2_data.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2_data.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/libxfs/xfs_dir2.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_dir2.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- ASCII case-insensitive support for xfsprogs
