Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 23:26:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S6Q85p009114
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 23:26:13 -0700
Subject: TAKE 980654 - Don't double count reserved block changes on UP.
Message-Id: <20080428062646.5FC2658C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 16:26:46 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't double count reserved block changes on UP.

On uniprocessor machines, the incore superblock is used for
all in memory accounting of free blocks. in this situation,
changes to the reserved block count are accounted twice;
once directly and once via xfs_mod_incore_sb(). Seeing as
the modification on SMP is done via xfs_mod_incore_sb(),
make this the only update mechanism that UP uses as well.


Date:  Mon Apr 28 16:26:28 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30997a
fs/xfs/xfs_fsops.c - 1.134 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.134&r2=text&tr2=1.133&f=h
	- Don't double count reserved block changes on UP.
