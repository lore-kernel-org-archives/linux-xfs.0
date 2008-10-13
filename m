Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:39:56 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6dsxb001225
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:39:54 -0700
Subject: TAKE 988140 - Kill SYNC_CLOSE
Message-Id: <20081013064134.7E09658C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:41:34 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Kill SYNC_CLOSE

SYNC_CLOSE is only ever used and checked in conjunction with
SYNC_WAIT, and this only done in one spot. The only thing
this does is make XFS_bflush() calls to the data buftargs.

This will happen very shortly afterwards the xfs_sync() call
anyway in the unmount path via the xfs_close_devices(), so this
code is redundant and can be removed. That only user of SYNC_CLOSE
is now gone, so kill the flag completely.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:41:16 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32310a
fs/xfs/linux-2.6/xfs_super.c - 1.455 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.455&r2=text&tr2=1.454&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Kill SYNC_CLOSE
