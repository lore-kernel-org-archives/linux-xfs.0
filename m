Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52762 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:23:15 -0400
Subject: [PATCH 2/5] xfs: rename the speculative block allocation reclaim
 toggle functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:21:11 -0700
Message-ID: <155563327108.112668.10133338747548676442.stgit@magnolia>
In-Reply-To: <155563325882.112668.3605935077532891922.stgit@magnolia>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

"reclaim" is used throughout the icache code to mean reclamation of
incore inode structures.  It's also used for two helper functions that
toggle background deletion of speculative preallocations.  Separate
the second of the two uses to make things less confusing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    4 ++--
 fs/xfs/xfs_icache.h |    4 ++--
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_super.c  |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 69ad1f33b67e..a76b27565a18 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1822,7 +1822,7 @@ xfs_inode_clear_cowblocks_tag(
 
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
-xfs_icache_disable_reclaim(
+xfs_stop_block_reaping(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
@@ -1831,7 +1831,7 @@ xfs_icache_disable_reclaim(
 
 /* Enable post-EOF and CoW block auto-reclamation. */
 void
-xfs_icache_enable_reclaim(
+xfs_start_block_reaping(
 	struct xfs_mount	*mp)
 {
 	xfs_queue_eofblocks(mp);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 26c0626f1f75..48f1fd2bb6ad 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -119,7 +119,7 @@ xfs_fs_eofblocks_from_user(
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-void xfs_icache_disable_reclaim(struct xfs_mount *mp);
-void xfs_icache_enable_reclaim(struct xfs_mount *mp);
+void xfs_stop_block_reaping(struct xfs_mount *mp);
+void xfs_start_block_reaping(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4cedf6f8565b..6b2bfe81dc51 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1107,7 +1107,7 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
-	xfs_icache_disable_reclaim(mp);
+	xfs_stop_block_reaping(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3a870a194cd9..86c18f2232ca 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1368,7 +1368,7 @@ xfs_fs_remount(
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			return error;
 		}
-		xfs_icache_enable_reclaim(mp);
+		xfs_start_block_reaping(mp);
 
 		/* Create the per-AG metadata reservation pool .*/
 		error = xfs_fs_reserve_ag_blocks(mp);
@@ -1382,7 +1382,7 @@ xfs_fs_remount(
 		 * Cancel background eofb scanning so it cannot race with the
 		 * final log force+buftarg wait and deadlock the remount.
 		 */
-		xfs_icache_disable_reclaim(mp);
+		xfs_stop_block_reaping(mp);
 
 		/* Get rid of any leftover CoW reservations... */
 		error = xfs_icache_free_cowblocks(mp, NULL);
@@ -1426,7 +1426,7 @@ xfs_fs_freeze(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_icache_disable_reclaim(mp);
+	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	return xfs_sync_sb(mp, true);
@@ -1440,7 +1440,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_icache_enable_reclaim(mp);
+	xfs_start_block_reaping(mp);
 	return 0;
 }
 
