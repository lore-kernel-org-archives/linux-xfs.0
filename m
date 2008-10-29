Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 20:39:46 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T3dVm6000639
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:39:33 -0700
Subject: TAKE 987246 - Fix race when looking up reclaimable inodes
Message-Id: <20081029033923.0A8A558AE1E9@chook.melbourne.sgi.com>
Date: Wed, 29 Oct 2008 14:39:23 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix race when looking up reclaimable inodes

If we get a race looking up a reclaimable inode, we can
end up with the winner proceeding to use the inode before
it has been completely re-initialised. This is a Bad Thing.

Fix the race by checking whether we are still initialising the
inod eonce we have a reference to it, and if so wait for the
initialisation to complete before continuing.

While there, fix a leaked reference count in the same code
when encountering an unlinked inode and we are not doing a
lookup for a create operation.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Oct 29 14:38:57 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32429a
fs/xfs/xfs_iget.c - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
fs/xfs/linux-2.6/xfs_linux.h - 1.173 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.173&r2=text&tr2=1.172&f=h
	- Fix race when looking up reclaimable inodes
