Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 19:31:23 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N2VGt5016158
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 19:31:16 -0700
Subject: TAKE 987246 - Can't lock inodes in radix tree preload region
Message-Id: <20081023023252.A278258AE1E5@chook.melbourne.sgi.com>
Date: Thu, 23 Oct 2008 13:32:52 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Can't lock inodes in radix tree preload region

When we are inside a radix tree preload region, we cannot
sleep. Recently we moved the inode locking inside the
preload region for the inode radix tree. Fix that,
and fix a missed unlock in another error path in the
same code at the same time.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 23 13:32:28 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32385a
fs/xfs/xfs_iget.c - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
	- Can't lock inodes in radix tree preload region
