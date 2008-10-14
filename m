Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 21:49:01 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E4mvTq025411
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 21:48:58 -0700
Subject: TAKE 988141 - Never call mark_inode_dirty_sync() directly
Message-Id: <20081014045038.4253258FA1E9@chook.melbourne.sgi.com>
Date: Tue, 14 Oct 2008 15:50:38 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Never call mark_inode_dirty_sync() directly

Once the Linux inode and the XFS inode are combined, we cannot rely
on just check if the linux inode exists as a method of determining
if it is valid or not. Hence we should always call
xfs_mark_inode_dirty_sync() instead as it does the correct checks to
determine if the liinux inode is in a valid state or not.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Oct 14 15:50:14 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32318a
fs/xfs/linux-2.6/xfs_super.c - 1.457 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.457&r2=text&tr2=1.456&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.301 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.301&r2=text&tr2=1.300&f=h
fs/xfs/linux-2.6/xfs_aops.c - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
	- Never call mark_inode_dirty_sync() directly
