Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDSAVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 20:21:07 -0400
Subject: [PATCH 1/5] xfs: track delayed allocation reservations across
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 18 Apr 2019 17:21:05 -0700
Message-ID: <155563326502.112668.15075629821207212917.stgit@magnolia>
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

Add a percpu counter to track the number of blocks directly reserved for
delayed allocations on the data device.  This counter (in contrast to
i_delayed_blks) does not track allocated CoW staging extents or anything
going on with the realtime device.  It will be used in the upcoming
summary counter scrub function to check the free block counts without
having to freeze the filesystem or walk all the inodes to find the
delayed allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   17 ++++++++++++++---
 fs/xfs/xfs_mount.c       |   21 +++++++++++++++++++++
 fs/xfs/xfs_mount.h       |    7 +++++++
 fs/xfs/xfs_super.c       |    9 +++++++++
 4 files changed, 51 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4637ae1ae91c..356ebd1cbe82 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2009,6 +2009,9 @@ xfs_bmap_add_extent_delay_real(
 			goto done;
 	}
 
+	if (da_new != da_old)
+		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
+
 	if (bma->cur) {
 		da_new += bma->cur->bc_private.b.allocated;
 		bma->cur->bc_private.b.allocated = 0;
@@ -2640,6 +2643,7 @@ xfs_bmap_add_extent_hole_delay(
 		/*
 		 * Nothing to do for disk quota accounting here.
 		 */
+		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
 	}
 }
 
@@ -3352,8 +3356,10 @@ xfs_bmap_btalloc_accounting(
 		 * already have quota reservation and there's nothing to do
 		 * yet.
 		 */
-		if (ap->wasdel)
+		if (ap->wasdel) {
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
 			return;
+		}
 
 		/*
 		 * Otherwise, we've allocated blocks in a hole. The transaction
@@ -3372,8 +3378,10 @@ xfs_bmap_btalloc_accounting(
 	/* data/attr fork only */
 	ap->ip->i_d.di_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-	if (ap->wasdel)
+	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= args->len;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+	}
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
 		args->len);
@@ -3969,6 +3977,7 @@ xfs_bmapi_reserve_delalloc(
 
 
 	ip->i_delayed_blks += alen;
+	xfs_mod_delalloc(ip->i_mount, alen + indlen);
 
 	got->br_startoff = aoff;
 	got->br_startblock = nullstartblock(indlen);
@@ -4840,8 +4849,10 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	if (!isrt)
 		da_diff += del->br_blockcount;
-	if (da_diff)
+	if (da_diff) {
 		xfs_mod_fdblocks(mp, da_diff, false);
+		xfs_mod_delalloc(mp, -da_diff);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index eff8b4c3eb3e..4cedf6f8565b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1451,3 +1451,24 @@ xfs_force_summary_recalc(
 
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 }
+
+/*
+ * Update the in-core delayed block counter.
+ *
+ * We prefer to update the counter without having to take a spinlock for every
+ * counter update (i.e. batching).  Each change to delayed allocation
+ * reservations can change can easily exceed the default percpu counter
+ * batching, so we use a larger batch factor here.
+ *
+ * Note that we don't currently have any callers requiring fast summation
+ * (e.g. percpu_counter_read) so we can use a big batch value here.
+ */
+#define XFS_DELALLOC_BATCH	(4096)
+void
+xfs_mod_delalloc(
+	struct xfs_mount	*mp,
+	int64_t			delta)
+{
+	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
+			XFS_DELALLOC_BATCH);
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 14fba76ab811..c81a5cd7c228 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -81,6 +81,12 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_icount;	/* allocated inodes counter */
 	struct percpu_counter	m_ifree;	/* free inodes counter */
 	struct percpu_counter	m_fdblocks;	/* free block counter */
+	/*
+	 * Count of data device blocks reserved for delayed allocations,
+	 * including indlen blocks.  Does not include allocated CoW staging
+	 * extents or anything related to the rt device.
+	 */
+	struct percpu_counter	m_delalloc_blks;
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
@@ -475,5 +481,6 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
+void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index df917f41ca46..3a870a194cd9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1538,8 +1538,14 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_ifree;
 
+	error = percpu_counter_init(&mp->m_delalloc_blks, 0, GFP_KERNEL);
+	if (error)
+		goto free_fdblocks;
+
 	return 0;
 
+free_fdblocks:
+	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
 	percpu_counter_destroy(&mp->m_ifree);
 free_icount:
@@ -1563,6 +1569,9 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
+	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
+	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
 static struct xfs_mount *
