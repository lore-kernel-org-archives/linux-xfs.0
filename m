Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:40:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757eDYt014531
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:40:14 -0700
Subject: TAKE 981498 - replace inode flush semaphore with a completion
Message-Id: <20080805074126.7B66358C52A4@chook.melbourne.sgi.com>
Date: Tue,  5 Aug 2008 17:41:26 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

replace inode flush semaphore with a completion

Use the new completion flush code to implement the inode flush lock.  Removes
one of the final users of semaphores in the XFS code base.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Aug  5 17:40:34 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31817a
fs/xfs/xfs_inode_item.c - 1.139 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.139&r2=text&tr2=1.138&f=h
fs/xfs/xfs_iget.c - 1.244 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.244&r2=text&tr2=1.243&f=h
fs/xfs/xfs_inode.c - 1.516 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.516&r2=text&tr2=1.515&f=h
fs/xfs/xfs_inode.h - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
	- replace inode flush semaphore with a completion
