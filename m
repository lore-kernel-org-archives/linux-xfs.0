Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:22:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765MT2H009378
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:22:30 -0700
Subject: TAKE 981498 - xfs_unmountfs should return void
Message-Id: <20080806052341.D436A58C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:23:41 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfs_unmountfs should return void

xfs_unmounts can't and shouldn't return errors so declare it as
returning void.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 15:23:03 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31833a
fs/xfs/xfs_mount.h - 1.274 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.274&r2=text&tr2=1.273&f=h
fs/xfs/xfs_mount.c - 1.442 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.442&r2=text&tr2=1.441&f=h
	- xfs_unmountfs should return void
