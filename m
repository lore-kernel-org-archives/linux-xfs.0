Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 21:31:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBJ5VAqw020375
	for <xfs@oss.sgi.com>; Mon, 18 Dec 2006 21:31:13 -0800
Date: Tue, 19 Dec 2006 16:30:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Fix use after free on forced shutdown
Message-ID: <20061219053012.GY33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

As found earlier today trying to reproduce a different use
after free, a machine with CONFIG_SLAB_DEBUG will panic on
a forced shutdown if the inode has an assocaited item
in the AIL.

Trivial fix is to remove the item from the AIL before
freeing it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_inode.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-12-12 15:40:58.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-12-19 15:44:09.675298719 +1100
@@ -2704,10 +2704,24 @@ xfs_idestroy(
 	ktrace_free(ip->i_dir_trace);
 #endif
 	if (ip->i_itemp) {
-		/* XXXdpd should be able to assert this but shutdown
-		 * is leaving the AIL behind. */
-		ASSERT(((ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL) == 0) ||
-		       XFS_FORCED_SHUTDOWN(ip->i_mount));
+		/*
+		 * Only if we are shutting down the fs will we see an
+		 * inode still in the AIL. If it is there, we should remove
+		 * it to prevent a use-after-free from occurring.
+		 */
+		xfs_mount_t	*mp = ip->i_mount;
+		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+		int		s;
+
+		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
+				       XFS_FORCED_SHUTDOWN(ip->i_mount));
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			AIL_LOCK(mp, s);
+			if (lip->li_flags & XFS_LI_IN_AIL)
+				xfs_trans_delete_ail(mp, lip, s);
+			else
+				AIL_UNLOCK(mp, s);
+		}
 		xfs_inode_item_destroy(ip);
 	}
 	kmem_zone_free(xfs_inode_zone, ip);
