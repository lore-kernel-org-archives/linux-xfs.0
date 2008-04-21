Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:04:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L83iQQ021527
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:03:47 -0700
Subject: PARTIAL TAKE 976035 - kill parent == child checks in xfs_remove and xfs_rmdir
Message-Id: <20080421080421.3948458C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 18:04:21 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill parent == child checks in xfs_remove and xfs_rmdir

VFS guaranteed these can't happen.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 18:03:53 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30911a
fs/xfs/xfs_vnodeops.c - 1.756 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.756&r2=text&tr2=1.755&f=h
	- kill parent == child checks in xfs_remove and xfs_rmdir
