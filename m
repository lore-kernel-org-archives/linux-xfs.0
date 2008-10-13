Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:42:40 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6ga5Q001808
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:42:36 -0700
Subject: TAKE 988140 - Move remaining quiesce code.
Message-Id: <20081013064417.2533558C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:44:17 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Move remaining quiesce code.

With all the other filesystem sync code it in xfs_sync.c
including the data quiesce code, it makes sense to move
the remaining quiesce code to the same place.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:43:56 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32312a
fs/xfs/xfs_vfsops.c - 1.580 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.580&r2=text&tr2=1.579&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.456 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.456&r2=text&tr2=1.455&f=h
fs/xfs/xfs_vfsops.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Move remaining quiesce code.
