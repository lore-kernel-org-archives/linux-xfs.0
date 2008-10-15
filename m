Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:14:10 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5E7hx003949
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:14:08 -0700
Subject: TAKE 988142 - kill deleted inodes list
Message-Id: <20081015051547.CBDFC58FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:15:47 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill deleted inodes list

Now that the deleted inodes list is unused, kill it. This
also removes the i_reclaim list head from the xfs_inode, shrinking
it by two pointers.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:15:14 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32334a
fs/xfs/xfs_vnodeops.c - 1.781 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.781&r2=text&tr2=1.780&f=h
fs/xfs/xfs_iget.c - 1.252 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.252&r2=text&tr2=1.251&f=h
fs/xfs/xfs_mount.h - 1.281 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.281&r2=text&tr2=1.280&f=h
fs/xfs/xfs_mount.c - 1.451 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.451&r2=text&tr2=1.450&f=h
fs/xfs/xfs_inode.c - 1.531 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.531&r2=text&tr2=1.530&f=h
fs/xfs/xfs_inode.h - 1.265 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.265&r2=text&tr2=1.264&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.461 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.461&r2=text&tr2=1.460&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- kill deleted inodes list
