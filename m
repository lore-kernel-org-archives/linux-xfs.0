Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 19:16:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U2GOAE023151
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 19:16:25 -0700
Message-Id: <20080930021756.44E4C58C52B4@chook.melbourne.sgi.com>
Date: Tue, 30 Sep 2008 12:17:56 +1000 (EST)
From: pleckie@sgi.com (Peter Leckie)
Subject: (no subject)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-bugs-internal@sgi.com, xfs@oss.sgi.com

mod xfs-linux-melb:xfs-kern:32215a TAKE message
================================================
Subject: TAKE 986789 - 

Clean up dquot pincount code.

This is a code cleanup and optimization that removes a per mount point
spinlock from the quota code and cleans up the code.

The patch changes the pincount from being an int protected by a spinlock
to an atomic_t allowing the pincount to be manipulated without holding
the spinlock.

This cleanup also protects against random wakup's of both the aild and
xfssyncd by reevaluating the pincount after been woken. Two latter patches
will address the Spurious wakeups.

Signed-off-by: Peter Leckie <pleckie@sgi.com>

Date:  Fri Sep 26 14:42:30 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/pleckie/2.6.x-xfs
Inspected by:  
donaldd
lachlan
hch@lst.de
david@fromorbit.com
Author:  pleckie

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32215a
fs/xfs/xfsidbg.c - 1.367 - changed
fs/xfs/quota/xfs_dquot_item.c - 1.24 - changed
fs/xfs/quota/xfs_dquot.h - 1.14 - changed
fs/xfs/quota/xfs_dquot.c - 1.39 - changed
fs/xfs/quota/xfs_qm.h - 1.21 - changed
fs/xfs/quota/xfs_qm.c - 1.75 - changed
	- Clean up dquot pincount code.
