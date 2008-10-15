Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:12:41 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5Cbrd003542
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:12:37 -0700
Subject: TAKE 988142 - use the inode radix tree for reclaiming inodes
Message-Id: <20081015051418.B196858FA1EB@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:14:18 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

use the inode radix tree for reclaiming inodes

Use the reclaim tag to walk the radix tree and find
the inodes under reclaim. This was the only user of the
deleted inode list.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:14:00 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32333a
fs/xfs/linux-2.6/xfs_sync.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- use the inode radix tree for reclaiming inodes
