Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:00:09 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F207O2005200
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:00:07 -0700
Subject: TAKE 988141 - Combine the XFS and Linux inodes
Message-Id: <20081015020142.9F8F658FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 13:01:42 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Combine the XFS and Linux inodes

To avoid issues with different lifecycles of XFS and Linux inodes,
embedd the linux inode inside the XFS inode. This means that the
linux inode has the same lifecycle as the XFS inode, even when it
has been released by the OS. XFS inodes don't live much longer than
this (a short stint in reclaim at most), so there isn't significant
memory usage penalties here.

Version 3
o kill xfs_icount()

Version 2
o remove unused commented out code from xfs_iget().
o kill useless cast in VFS_I()

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 13:01:18 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32323a
fs/xfs/xfs_vnodeops.c - 1.777 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.777&r2=text&tr2=1.776&f=h
fs/xfs/xfs_iget.c - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
fs/xfs/xfs_inode.c - 1.530 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.530&r2=text&tr2=1.529&f=h
fs/xfs/xfs_inode.h - 1.263 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.263&r2=text&tr2=1.262&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.458 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.458&r2=text&tr2=1.457&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.302 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.302&r2=text&tr2=1.301&f=h
	- Combine the XFS and Linux inodes
