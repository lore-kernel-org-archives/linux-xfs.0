Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:31:51 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6VliT032044
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:31:48 -0700
Subject: TAKE 988140 - use xfs_sync_inodes rather than xfs_syncsub
Message-Id: <20081013063321.94DC358C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:33:21 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

use xfs_sync_inodes rather than xfs_syncsub

Kill the unused arg in xfs_syncsub() and xfs_sync_inodes().  For
callers of xfs_syncsub() that only want to flush inodes, replace
xfs_syncsub() with direct calls to xfs_sync_inodes() as that is all
that is being done with the specific flags being passed in.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:33:00 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32305a
fs/xfs/xfs_vfsops.c - 1.577 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.577&r2=text&tr2=1.576&f=h
fs/xfs/xfs_mount.h - 1.280 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.280&r2=text&tr2=1.279&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
	- use xfs_sync_inodes rather than xfs_syncsub
