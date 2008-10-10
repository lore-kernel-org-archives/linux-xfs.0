Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:04:02 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A5400I001051
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:04:00 -0700
Subject: TAKE 988139 - remove the mount inode list
Message-Id: <20081010050533.3768B58C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:05:33 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove the mount inode list

Now we've removed all users of the mount inode list,
we can kill it. This reduces the size of the xfs_inode
by 2 pointers.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 16:05:12 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32293a
fs/xfs/xfs_iget.c - 1.247 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.247&r2=text&tr2=1.246&f=h
fs/xfs/xfs_mount.h - 1.279 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.279&r2=text&tr2=1.278&f=h
fs/xfs/xfs_mount.c - 1.449 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.449&r2=text&tr2=1.448&f=h
fs/xfs/xfs_inode.h - 1.261 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.261&r2=text&tr2=1.260&f=h
	- remove the mount inode list
