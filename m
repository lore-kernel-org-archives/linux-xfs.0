Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:03:39 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F23b8k005737
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:03:37 -0700
Subject: TAKE 988141 - Prevent use-after-free caused by synchronous inode reclaim
Message-Id: <20081015020518.15D7058FA1EB@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 13:05:18 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Prevent use-after-free caused by synchronous inode reclaim

With the combined linux and XFS inode, we need to ensure that the
combined structure is not freed before the generic code is finished
with the inode. As it turns out, there is a case where the XFS inode
is freed before the linux inode - when xfs_reclaim() is called from
->clear_inode() on a clean inode, the xfs inode is freed during
that call. The generic code references the inode after the
->clear_inode() call, so this is a use after free situation.

Fix the problem by moving the xfs_reclaim() call to ->destroy_inode()
instead of in ->clear_inode(). This ensures the combined inode
structure is not freed until after the generic code has finished
with it.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 13:04:57 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32324a
fs/xfs/linux-2.6/xfs_super.c - 1.459 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.459&r2=text&tr2=1.458&f=h
	- Prevent use-after-free caused by synchronous inode reclaim
