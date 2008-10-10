Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:55:15 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4tDTS032383
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:55:14 -0700
Subject: TAKE 988139 - Use the inode tree for finding dirty inodes
Message-Id: <20081010045646.B91B958C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 15:56:46 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use the inode tree for finding dirty inodes

Update xfs_sync_inodes to walk the inode radix tree cache to find
dirty inodes. This removes a huge bunch of nasty, messy code for
traversing the mount inode list safely and removes another user of
the mount inode list.

Version 3
o rediff against new linux-2.6/xfs_sync.c code

Version 2
o add comment explaining use of gang lookups for a single inode
o use IRELE, not VN_RELE
o move check for ag initialisation to caller.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 15:56:17 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32290a
fs/xfs/linux-2.6/xfs_sync.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Use the inode tree for finding dirty inodes
