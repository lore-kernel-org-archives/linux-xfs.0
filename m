Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:33:13 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6X7lK032369
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:33:07 -0700
Subject: TAKE 988140 - kill xfs_syncsub
Message-Id: <20081013063441.B524458C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:34:41 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_syncsub

Now that the only caller is xfs_sync(), merge the two
together as it makes no sense to keep them separate.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:34:22 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32306a
fs/xfs/linux-2.6/xfs_sync.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- kill xfs_syncsub
