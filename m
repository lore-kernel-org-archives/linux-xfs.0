Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58212 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbeDRCmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:42:07 -0400
Subject: [PATCH 9/9] xfs: halt auto-reclamation activities while rebuilding
 rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:48 -0700
Message-ID: <152401930817.11792.5003602424787160068.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuilding the reverse-mapping tree requires us to quiesce all inodes in
the filesystem, so we must stop background reclamation of post-EOF and
CoW prealloc blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |   18 ++++++++++++++++++
 fs/xfs/xfs_icache.h |    3 +++
 fs/xfs/xfs_mount.c  |    4 +---
 fs/xfs/xfs_super.c  |   18 +++++++++---------
 4 files changed, 31 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9a18f69..a7dd676 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1802,3 +1802,21 @@ xfs_inode_clear_cowblocks_tag(
 	return __xfs_inode_clear_blocks_tag(ip,
 			trace_xfs_perag_clear_cowblocks, XFS_ICI_COWBLOCKS_TAG);
 }
+
+/* Disable post-EOF and CoW block auto-reclamation. */
+void
+xfs_icache_disable_reclaim(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_eofblocks_work);
+	cancel_delayed_work_sync(&mp->m_cowblocks_work);
+}
+
+/* Enable post-EOF and CoW block auto-reclamation. */
+void
+xfs_icache_enable_reclaim(
+	struct xfs_mount	*mp)
+{
+	xfs_queue_eofblocks(mp);
+	xfs_queue_cowblocks(mp);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d4a7758..d69a0f5 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -131,4 +131,7 @@ xfs_fs_eofblocks_from_user(
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
+void xfs_icache_disable_reclaim(struct xfs_mount *mp);
+void xfs_icache_enable_reclaim(struct xfs_mount *mp);
+
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a901b86..73ed8fe 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1072,9 +1072,7 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
-	cancel_delayed_work_sync(&mp->m_eofblocks_work);
-	cancel_delayed_work_sync(&mp->m_cowblocks_work);
-
+	xfs_icache_disable_reclaim(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d714240..aa641ca 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1372,7 +1372,6 @@ xfs_fs_remount(
 		 */
 		xfs_restore_resvblks(mp);
 		xfs_log_work_queue(mp);
-		xfs_queue_eofblocks(mp);
 
 		/* Recover any CoW blocks that never got remapped. */
 		error = xfs_reflink_recover_cow(mp);
@@ -1382,7 +1381,7 @@ xfs_fs_remount(
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			return error;
 		}
-		xfs_queue_cowblocks(mp);
+		xfs_icache_enable_reclaim(mp);
 
 		/* Create the per-AG metadata reservation pool .*/
 		error = xfs_fs_reserve_ag_blocks(mp);
@@ -1392,8 +1391,13 @@ xfs_fs_remount(
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
+		/*
+		 * Cancel background eofb scanning so it cannot race with the
+		 * final log force+buftarg wait and deadlock the remount.
+		 */
+		xfs_icache_disable_reclaim(mp);
+
 		/* Get rid of any leftover CoW reservations... */
-		cancel_delayed_work_sync(&mp->m_cowblocks_work);
 		error = xfs_icache_free_cowblocks(mp, NULL);
 		if (error) {
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -1416,12 +1420,6 @@ xfs_fs_remount(
 		 */
 		xfs_save_resvblks(mp);
 
-		/*
-		 * Cancel background eofb scanning so it cannot race with the
-		 * final log force+buftarg wait and deadlock the remount.
-		 */
-		cancel_delayed_work_sync(&mp->m_eofblocks_work);
-
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
@@ -1441,6 +1439,7 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	xfs_icache_disable_reclaim(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	return xfs_sync_sb(mp, true);
@@ -1454,6 +1453,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
+	xfs_icache_enable_reclaim(mp);
 	return 0;
 }
 

