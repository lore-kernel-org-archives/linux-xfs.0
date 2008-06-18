Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 23:42:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I6gigr010967
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 23:42:45 -0700
Subject: TAKE 981240 - make inode reclaim wait for log I/O to complete
Message-Id: <20080618064338.0CABC58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 18 Jun 2008 16:43:37 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make inode reclaim wait for log I/O to complete

During a forced shutdown a xfs inode can be destroyed before log
I/O involving that inode is complete.  We need to wait for the
inode to be unpinned before tearing it down.  Version 2 cleans up
the code a bit by relying on xfs_iflush() to do the unpinning and
forced shutdown check. 

Date:  Wed Jun 18 16:42:26 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-iunpin
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31326a
fs/xfs/xfs_vnodeops.c - 1.761 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.761&r2=text&tr2=1.760&f=h
fs/xfs/xfs_inode.c - 1.505 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.505&r2=text&tr2=1.504&f=h
	- make inode reclaim wait for log I/O to complete
