Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 23:50:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G6nsbm020582
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 23:49:56 -0700
Subject: TAKE 877955 - xfs_repair: don't handle existing lost+found in a way that seems to cause errors
Message-Id: <20070716064953.3219A58C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 16:49:53 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't trash lost+found in phase 4


Date:  Mon Jul 16 16:49:03 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-patch
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29144a
xfsprogs/repair/phase6.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase6.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Detect existing valid lost+found or create as required

xfsprogs/repair/phase7.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsprogs/repair/dir2.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
xfsprogs/repair/dir.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- No need to handle trashed lost+found dir

xfsprogs/repair/phase4.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase4.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Don't trash lost+found

xfsprogs/repair/globals.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/repair/phase1.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase1.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/repair/dino_chunks.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dino_chunks.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- No need to handle trashed lost+found dir

xfsprogs/libxfs/util.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/util.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Update critical error message
