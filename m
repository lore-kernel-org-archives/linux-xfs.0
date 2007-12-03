Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Dec 2007 23:43:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB37hi1R017708
	for <xfs@oss.sgi.com>; Sun, 2 Dec 2007 23:43:46 -0800
Date: Mon, 3 Dec 2007 18:43:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Fix xfs_ichgtime mainline breakage.
Message-ID: <20071203074345.GW119954183@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Folks,

Just noticed with the mainline merge (2.6.24-rc3) to xfs-dev that
xfs_ichgtime + xfs_ichgtime_fast are broken.

        if (!(inode->i_state & I_SYNC))
		mark_inode_dirty_sync(inode);

that check used to be against I_LOCK, which was arguably broken,
but this one will mean newly created files are not put on the dirty
list and hence not written back by pdflush.

Patch to fix this attached.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_iops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-03 18:39:52.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-12-03 18:40:54.408998073 +1100
@@ -134,7 +134,7 @@ xfs_ichgtime(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_SYNC))
+	if (!(inode->i_state & I_NEW))
 		mark_inode_dirty_sync(inode);
 }
 
@@ -186,7 +186,7 @@ xfs_ichgtime_fast(
 	 */
 	SYNCHRONIZE();
 	ip->i_update_core = 1;
-	if (!(inode->i_state & I_SYNC))
+	if (!(inode->i_state & I_NEW))
 		mark_inode_dirty_sync(inode);
 }
 
