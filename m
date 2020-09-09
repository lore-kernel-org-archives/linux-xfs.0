Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C06AC10DAA
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E00E218AC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgIIIT1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39285 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgIIITX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 04:19:23 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A8CB6824447
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 18:19:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-00005P-OV
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kFvJx-004yOC-6S
        for linux-xfs@vger.kernel.org; Wed, 09 Sep 2020 18:19:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: factor free space tree transaciton reservations
Date:   Wed,  9 Sep 2020 18:19:12 +1000
Message-Id: <20200909081912.1185392-4-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909081912.1185392-1-david@fromorbit.com>
References: <20200909081912.1185392-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=bxfpV1sUp7d6p-NBOosA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert all the open coded free space tree modification reservations
to use the new xfs_allocfree_extent_res() function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 116 +++++++++++++--------------------
 1 file changed, 44 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 621ddb277dfa..cb3cddb84d75 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -143,18 +143,16 @@ xfs_calc_inode_res(
  * reservation:
  *
  * the inode btree: max depth * blocksize
- * the allocation btrees: 2 trees * (max depth - 1) * block size
+ * one extent for the AG free space trees
  *
- * The caller must account for SB and AG header modifications, etc.
  */
 STATIC uint
 xfs_calc_inobt_res(
 	struct xfs_mount	*mp)
 {
 	return xfs_calc_buf_res(M_IGEO(mp)->inobt_maxlevels,
-			XFS_FSB_TO_B(mp, 1)) +
-				xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-			XFS_FSB_TO_B(mp, 1));
+				XFS_FSB_TO_B(mp, 1)) +
+		xfs_allocfree_extent_res(mp);
 }
 
 /*
@@ -200,8 +198,7 @@ xfs_calc_inode_chunk_res(
 {
 	uint			res, size = 0;
 
-	res = xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-			       XFS_FSB_TO_B(mp, 1));
+	res = xfs_allocfree_extent_res(mp);
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
 		if (xfs_sb_version_has_v3inode(&mp->m_sb))
@@ -256,22 +253,19 @@ xfs_rtalloc_log_count(
  * extents.  This gives (t1):
  *    the inode getting the new extents: inode size
  *    the inode's bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ *    two extents for the AG free space trees
  * Or, if we're writing to a realtime file (t2):
  *    the inode getting the new extents: inode size
  *    the inode's bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    one extent for the AG free space trees
  *    the superblock free block counter: sector size
  *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
- *    the agfs of the ags containing the blocks: 2 * sector size
  *    the agfls of the ags containing the blocks: 2 * sector size
  *    the super block free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ *    two extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_write_reservation(
@@ -282,8 +276,8 @@ xfs_calc_write_reservation(
 
 	t1 = xfs_calc_inode_res(mp, 1) +
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
-	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	     xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+	     xfs_allocfree_extent_res(mp) * 2;
 
 	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
 		t2 = xfs_calc_inode_res(mp, 1) +
@@ -291,13 +285,13 @@ xfs_calc_write_reservation(
 				     blksz) +
 		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
+		     xfs_allocfree_extent_res(mp);
 	} else {
 		t2 = 0;
 	}
 
-	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+	t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+	     xfs_allocfree_extent_res(mp) * 2;
 
 	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
 }
@@ -307,19 +301,13 @@ xfs_calc_write_reservation(
  *    the inode being truncated: inode size
  *    the inode's bmap btree: (max depth + 1) * block size
  * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    four (XXX: one?) extents for the AG free space trees
  * Or, if it's a realtime file (t3):
- *    the agf for each of the ags: 2 * sector size
- *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
  *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
- *    worst case split in allocation btrees per extent assuming 2 extents:
- *		2 exts * 2 trees * (2 * max depth - 1) * block size
+ *    two extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
@@ -331,13 +319,13 @@ xfs_calc_itruncate_reservation(
 	t1 = xfs_calc_inode_res(mp, 1) +
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
 
-	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
+	t2 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+	     xfs_allocfree_extent_res(mp) * 4;
 
 	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
-		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
+		     xfs_allocfree_extent_res(mp) * 2;
 	} else {
 		t3 = 0;
 	}
@@ -352,10 +340,8 @@ xfs_calc_itruncate_reservation(
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
  *	of bmap blocks) giving:
- *    the agf for the ags in which the blocks live: 3 * sector size
- *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
- *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ *    three extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_rename_reservation(
@@ -365,9 +351,8 @@ xfs_calc_rename_reservation(
 		max((xfs_calc_inode_res(mp, 4) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_allocfree_extent_res(mp) * 3));
 }
 
 /*
@@ -381,20 +366,19 @@ xfs_calc_iunlink_remove_reservation(
 	struct xfs_mount        *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-	       2 * M_IGEO(mp)->inode_cluster_size;
+	       xfs_calc_buf_res(2, M_IGEO(mp)->inode_cluster_size);
 }
 
 /*
  * For creating a link to an inode:
+ *    the inode is removed from the iunlink list (O_TMPFILE)
  *    the parent directory inode: inode size
  *    the linked inode: inode size
  *    the directory btree could split: (max depth + v2) * dir block size
  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
  * And the bmap_finish transaction can free some bmap blocks giving:
- *    the agf for the ag in which the blocks live: sector size
- *    the agfl for the ag in which the blocks live: sector size
  *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ *    one extent for the AG free space trees
  */
 STATIC uint
 xfs_calc_link_reservation(
@@ -405,9 +389,8 @@ xfs_calc_link_reservation(
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_allocfree_extent_res(mp)));
 }
 
 /*
@@ -419,20 +402,19 @@ STATIC uint
 xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-			M_IGEO(mp)->inode_cluster_size;
+	       xfs_calc_buf_res(1, M_IGEO(mp)->inode_cluster_size);
 }
 
 /*
  * For removing a directory entry we can modify:
+ *    the inode is added to the agi unlinked list
  *    the parent directory inode: inode size
  *    the removed inode: inode size
  *    the directory btree could join: (max depth + v2) * dir block size
  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
  * And the bmap_finish transaction can free the dir and bmap blocks giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
  *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ *    two extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_remove_reservation(
@@ -443,9 +425,8 @@ xfs_calc_remove_reservation(
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_allocfree_extent_res(mp) * 2));
 }
 
 /*
@@ -582,15 +563,14 @@ xfs_calc_ichange_reservation(
  * Growing the data section of the filesystem.
  *	superblock
  *	agi and agf
- *	allocation btrees
+ *	growing the last AG requires freeing one extent
  */
 STATIC uint
 xfs_calc_growdata_reservation(
 	struct xfs_mount	*mp)
 {
-	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+	       xfs_allocfree_extent_res(mp);
 }
 
 /*
@@ -598,10 +578,9 @@ xfs_calc_growdata_reservation(
  * In the first set of transactions (ALLOC) we allocate space to the
  * bitmap or summary files.
  *	superblock: sector size
- *	agf of the ag from which the extent is allocated: sector size
  *	bmap btree for bitmap/summary inode: max depth * blocksize
  *	bitmap/summary inode: inode size
- *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
+ *	one extent for the AG free space trees
  */
 STATIC uint
 xfs_calc_growrtalloc_reservation(
@@ -611,8 +590,7 @@ xfs_calc_growrtalloc_reservation(
 		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+		xfs_allocfree_extent_res(mp);
 }
 
 /*
@@ -675,7 +653,7 @@ xfs_calc_writeid_reservation(
  *	agf block and superblock (for block allocation)
  *	the new block (directory sized)
  *	bmap blocks for the new directory block
- *	allocation btrees
+ *	one extent for the AG free space trees
  */
 STATIC uint
 xfs_calc_addafork_reservation(
@@ -687,8 +665,7 @@ xfs_calc_addafork_reservation(
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
 		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
 				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+		xfs_allocfree_extent_res(mp);
 }
 
 /*
@@ -696,11 +673,8 @@ xfs_calc_addafork_reservation(
  *    the inode being truncated: inode size
  *    the inode's bmap btree: max depth * block size
  * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    four (XXX: really? should be one?) extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_attrinval_reservation(
@@ -709,9 +683,8 @@ xfs_calc_attrinval_reservation(
 	return max((xfs_calc_inode_res(mp, 1) +
 		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
 				     XFS_FSB_TO_B(mp, 1))),
-		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
-				     XFS_FSB_TO_B(mp, 1))));
+		   (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		    xfs_allocfree_extent_res(mp) * 4));
 }
 
 /*
@@ -763,7 +736,7 @@ xfs_calc_attrsetrt_reservation(
  *    the agf for the ag in which the blocks live: 2 * sector size
  *    the agfl for the ag in which the blocks live: 2 * sector size
  *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ *    two extents for the AG free space trees
  */
 STATIC uint
 xfs_calc_attrrm_reservation(
@@ -776,9 +749,8 @@ xfs_calc_attrrm_reservation(
 		     (uint)XFS_FSB_TO_B(mp,
 					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
-		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_allocfree_extent_res(mp) * 2));
 }
 
 /*
-- 
2.28.0

