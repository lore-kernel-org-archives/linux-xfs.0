Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 22:11:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T5BHtL010587
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 22:11:19 -0700
Subject: TAKE 967035 - lockdep inumorder annotations are busted
Message-Id: <20070629051105.9BA0758C38F1@chook.melbourne.sgi.com>
Date: Fri, 29 Jun 2007 15:11:05 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix lockdep annotations for xfs_lock_inodes


Date:  Fri Jun 29 15:10:33 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29026a
fs/xfs/xfs_vnodeops.c - 1.701 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.701&r2=text&tr2=1.700&f=h
	- Don't double shift the inumorder subclass out of the lock_mode
	  variable.

fs/xfs/xfs_inode.h - 1.221 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.221&r2=text&tr2=1.220&f=h
	- Don't double shift the inumorder subclass out of the lock_mode
	  variable.
