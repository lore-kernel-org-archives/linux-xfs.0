Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:11:36 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5BXqS003221
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:11:33 -0700
Subject: TAKE 988142 - mark inodes for reclaim via a tag in the inode radix tree
Message-Id: <20081015051314.9C93E58FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:13:14 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

mark inodes for reclaim via a tag in the inode radix tree

Prepare for removing the deleted inode list by marking inodes
for reclaim in the inode radix trees so that we can use the
radix trees to find reclaimable inodes.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:12:53 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32331a
fs/xfs/xfs_ag.h - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
fs/xfs/xfs_vnodeops.c - 1.780 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.780&r2=text&tr2=1.779&f=h
fs/xfs/xfs_iget.c - 1.251 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.251&r2=text&tr2=1.250&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- mark inodes for reclaim via a tag in the inode radix tree
