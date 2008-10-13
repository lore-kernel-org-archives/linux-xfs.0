Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:35:38 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6ZW9s000468
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:35:32 -0700
Subject: TAKE 988140 - make SYNC_ATTR no longer use xfs_sync
Message-Id: <20081013063712.B795358C52AB@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:37:12 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make SYNC_ATTR no longer use xfs_sync

Continue to de-multiplex xfs_sync be replacing all SYNC_ATTR
callers with direct calls xfs_sync_inodes(). Add an assert
into xfs_sync() to ensure we caught all the SYNC_ATTR callers.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:36:54 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32308a
fs/xfs/xfs_vfsops.c - 1.578 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.578&r2=text&tr2=1.577&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.453 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.453&r2=text&tr2=1.452&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- make SYNC_ATTR no longer use xfs_sync
