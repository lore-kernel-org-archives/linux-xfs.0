Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:37:31 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6bT9R000808
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:37:29 -0700
Subject: TAKE 988140 - make SYNC_DELWRI no longer use xfs_sync
Message-Id: <20081013063909.5B8C358C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:39:09 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make SYNC_DELWRI no longer use xfs_sync

Continue to de-multiplex xfs_sync be replacing all SYNC_DELWRI
callers with direct calls functions that do the work. Isolate the
data quiesce case to a function in xfs_sync.c. Isolate the
FSDATA case with explicit calls to xfs_sync_fsdata().

Version 2:
o Push delwri related log forces into xfs_sync_inodes().

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:38:29 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32309a
fs/xfs/xfs_vfsops.c - 1.579 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.579&r2=text&tr2=1.578&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.454 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.454&r2=text&tr2=1.453&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- make SYNC_DELWRI no longer use xfs_sync
