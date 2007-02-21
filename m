Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 22:56:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1L6tsm7030026
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 22:55:56 -0800
Subject: TAKE 961339 - xfs_repair - phase5 restores corrupted superblock that was fixed in phase2
Message-Id: <20070221065550.572BD58CA547@chook.melbourne.sgi.com>
Date: Wed, 21 Feb 2007 17:55:50 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Copy modified superblock into mountpoint structure in phase 2


Date:  Wed Feb 21 17:55:11 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  Nathan Scott [nscott@aconex.com]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28153a
xfsprogs/repair/scan.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Copy modified superblock into mountpoint structure in phase 2

xfsprogs/libxfs/rdwr.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Fix debug messages when IO_DEBUG is enabled
