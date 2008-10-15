Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:08:26 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F58LaF002224
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:08:21 -0700
Subject: TAKE 988142 - move inode reclaim functions to xfs_sync.c
Message-Id: <20081015050955.D0AFD58FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:09:55 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move inode reclaim functions to xfs_sync.c

Background inode reclaim is run by the xfssyncd. Move the
reclaim worker functions to be close to the sync code as
the are very similar in structure and are both run from
the same background thread.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 15 16:09:34 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32329a
fs/xfs/xfs_vnodeops.c - 1.778 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.778&r2=text&tr2=1.777&f=h
fs/xfs/xfs_inode.h - 1.264 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.264&r2=text&tr2=1.263&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- move inode reclaim functions to xfs_sync.c
