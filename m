Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:50:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m764nx1U023028
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:50:24 -0700
Subject: TAKE 981498 - optimize xfs_ichgtime
Message-Id: <20080806045111.7E17458C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 14:51:11 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

optimize xfs_ichgtime

Port a little optmization from file_update_time to xfs_ichgtime, and
only update the timestamp and mark the inode dirty if the timestamp
actually changes in the timer tick resultion supported by the running
kernel.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 14:50:29 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31827a
fs/xfs/linux-2.6/xfs_iops.c - 1.298 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.298&r2=text&tr2=1.297&f=h
	- optimize xfs_ichgtime
