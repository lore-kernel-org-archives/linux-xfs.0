Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751953AbdK0UYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:24:36 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E81E77CB83
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8F5B5D9C9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 20:24:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/4] xfs: include an allocfree res for inobt modifications
Date: Mon, 27 Nov 2017 15:24:34 -0500
Message-Id: <20171127202434.43125-5-bfoster@redhat.com>
In-Reply-To: <20171127202434.43125-1-bfoster@redhat.com>
References: <20171127202434.43125-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Analysis of recent reports of log reservation overruns and code
inspection has uncovered that the reservations associated with inode
operations may not cover the worst case scenarios. In particular,
many cases only include one allocfree res. for a particular
operation even though said operations may also entail AGFL fixups
and inode btree block allocations in addition to the actual inode
chunk allocation. This can easily turn into two or three block
allocations (or frees) per operation.

In theory, the only way to define the worst case reservation is to
include an allocfree res for each individual allocation in a
transaction. Since that is impractical (we can perform multiple agfl
fixups per tx and not every allocation is going to result in a full
tree operation), implement a reasonable compromise that addresses
the deficiency in practice without blowing out the size of the
transactions.

Refactor the inode transaction reservation code to include one
allocfree res. per inode btree modification to cover allocations
required by the tree itself. This essentially separates the
reservation required to allocate the physical inode chunk from
additional reservation required to perform inobt record
insertion/removal. Apply the same logic to the finobt reservation.
This results in killing off the finobt modify condition because we
no longer assume that the broader transaction reservation will cover
finobt block allocations.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 84 +++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 4cd7cd1e60da..79e4aea74065 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -132,44 +132,43 @@ xfs_calc_inode_res(
 }
 
 /*
- * The free inode btree is a conditional feature and the log reservation
- * requirements differ slightly from that of the traditional inode allocation
- * btree. The finobt tracks records for inode chunks with at least one free
- * inode. A record can be removed from the tree for an inode allocation
- * or free and thus the finobt reservation is unconditional across:
+ * Inode btree record insertion/removal modifies the inode btree and free space
+ * btrees (since the inobt does not use the agfl). This requires the following
+ * reservation:
  *
- * 	- inode allocation
- * 	- inode free
- * 	- inode chunk allocation
+ * the inode btree: max depth * blocksize
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
  *
- * The 'modify' param indicates to include the record modification scenario. The
- * 'alloc' param indicates to include the reservation for free space btree
- * modifications on behalf of finobt modifications. This is required only for
- * transactions that do not already account for free space btree modifications.
+ * The caller must account for SB and AG header modifications, etc.
+ */
+STATIC uint
+xfs_calc_inobt_res(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * The free inode btree is a conditional feature. The behavior differs slightly
+ * from that of the traditional inode btree in that the finobt tracks records
+ * for inode chunks with at least one free inode. A record can be removed from
+ * the tree during individual inode allocation. Therefore the finobt
+ * reservation is unconditional for both the inode chunk allocation and
+ * individual inode allocation (modify) cases.
  *
- * the free inode btree: max depth * block size
- * the allocation btrees: 2 trees * (max depth - 1) * block size
- * the free inode btree entry: block size
+ * Behavior aside, the reservation for finobt modification is equivalent to the
+ * traditional inobt: cover a full finobt shape change plus block allocation.
  */
 STATIC uint
 xfs_calc_finobt_res(
-	struct xfs_mount	*mp,
-	int			alloc,
-	int			modify)
+	struct xfs_mount	*mp)
 {
-	uint res;
-
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return 0;
 
-	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
-	if (alloc)
-		res += xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-					XFS_FSB_TO_B(mp, 1));
-	if (modify)
-		res += (uint)XFS_FSB_TO_B(mp, 1);
-
-	return res;
+	return xfs_calc_inobt_res(mp);
 }
 
 /*
@@ -379,7 +378,7 @@ xfs_calc_create_resv_modify(
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		(uint)XFS_FSB_TO_B(mp, 1) +
 		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 1, 1);
+		xfs_calc_finobt_res(mp);
 }
 
 /*
@@ -387,8 +386,8 @@ xfs_calc_create_resv_modify(
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
  *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
- *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the inode btree (record insertion)
  */
 STATIC uint
 xfs_calc_create_resv_alloc(
@@ -397,9 +396,9 @@ xfs_calc_create_resv_alloc(
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_inobt_res(mp);
 }
 
 STATIC uint
@@ -415,8 +414,8 @@ __xfs_calc_create_reservation(
  * For icreate we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the inobt (record insertion)
  *    the finobt (record insertion)
  */
 STATIC uint
@@ -425,10 +424,10 @@ xfs_calc_icreate_resv_alloc(
 {
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 0, 0);
+		xfs_calc_inobt_res(mp) +
+		xfs_calc_finobt_res(mp);
 }
 
 STATIC uint
@@ -494,9 +493,14 @@ xfs_calc_symlink_reservation(
  *    the agi hash list and counters: sector size
  *    the on disk inode before ours in the agi hash list: inode cluster size
  *    the inode chunk is marked stale (headers only)
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the inode btree
  *    the finobt (record insertion, removal or modification)
+ *
+ * Note that the allocfree res. for the inode chunk itself is not included
+ * because the extent free occurs after a transaction roll. We could take the
+ * maximum of the pre/post roll operations, but the pre-roll reservation already
+ * includes at least one allocfree res. for the inobt and is thus guaranteed to
+ * be larger.
  */
 STATIC uint
 xfs_calc_ifree_reservation(
@@ -508,10 +512,8 @@ xfs_calc_ifree_reservation(
 		xfs_calc_iunlink_remove_reservation(mp) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 0, 1);
+		xfs_calc_inobt_res(mp) +
+		xfs_calc_finobt_res(mp);
 }
 
 /*
-- 
2.13.6

