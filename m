Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 22:05:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L55Rv9001260
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 22:05:29 -0700
Subject: PARTIAL TAKE 976035 - xfs_rename: pass resblks to xfs_dir_removename
Message-Id: <20080421050605.0C02258C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 15:06:04 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfs_rename: pass resblks to xfs_dir_removename

Similar to rmdir and remove - avoids a potential transaction reservation
overrun.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 15:05:29 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30900a
fs/xfs/xfs_vnodeops.c - 1.752 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.752&r2=text&tr2=1.751&f=h
	- xfs_rename: pass resblks to xfs_dir_removename
