Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfAHUd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:33:29 -0500
Subject: [PATCH 7/7] xfs: consolidate scrub dinode mapping code into a
 single function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:33:18 -0800
Message-ID: <154697959877.2494.10993090686249072444.stgit@magnolia>
In-Reply-To: <154697955494.2494.5221420762912855354.stgit@magnolia>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the confusing dinode mapping code that's split between
xchk_iallocbt_check_cluster and xchk_iallocbt_check_cluster_ifree into
the first function so that it's clearer how we find the dinode for a
given inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 1929d79ea6b3..663cc8a98fc9 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -146,7 +146,7 @@ xchk_iallocbt_freecount(
  *
  * @irec is the inobt record.
  * @cluster_base is the inode offset of the cluster within the @irec.
- * @cluster_bp is the cluster buffer.
+ * @dip is the on-disk inode.
  * @cluster_index is the inode offset within the inode cluster.
  */
 STATIC int
@@ -154,15 +154,12 @@ xchk_iallocbt_check_cluster_ifree(
 	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec,
 	unsigned int			cluster_base,
-	struct xfs_buf			*cluster_bp,
+	struct xfs_dinode		*dip,
 	unsigned int			cluster_index)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_dinode		*dip;
 	xfs_ino_t			fsino;
 	xfs_agino_t			agino;
-	unsigned int			offset;
-	unsigned int			cluster_buf_base;
 	bool				irec_free;
 	bool				ino_inuse;
 	bool				freemask_ok;
@@ -174,23 +171,10 @@ xchk_iallocbt_check_cluster_ifree(
 	/*
 	 * Given an inobt record, an offset of a cluster within the record, and
 	 * an offset of an inode within a cluster, compute which fs inode we're
-	 * talking about and the offset of that inode within the buffer.
-	 *
-	 * Be careful about inobt records that don't align with the start of
-	 * the inode buffer when block sizes are large enough to hold multiple
-	 * inode chunks.  When this happens, cluster_base will be zero but
-	 * ir_startino can be large enough to make cluster_buf_base nonzero.
+	 * talking about.
 	 */
 	agino = irec->ir_startino + cluster_base + cluster_index;
 	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
-	ASSERT(cluster_buf_base == 0 || cluster_base == 0);
-	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
-	if (offset >= BBTOB(cluster_bp->b_length)) {
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-		goto out;
-	}
-	dip = xfs_buf_offset(cluster_bp, offset);
 	irec_free = (irec->ir_free & XFS_INOBT_MASK(cluster_base +
 						    cluster_index));
 
@@ -262,10 +246,23 @@ xchk_iallocbt_check_cluster(
 		cluster_mask |= XFS_INOBT_MASK((cluster_base + cluster_index) /
 				XFS_INODES_PER_HOLEMASK_BIT);
 
+	/*
+	 * Map the first inode of this cluster to a buffer and offset.
+	 * Be careful about inobt records that don't align with the start of
+	 * the inode buffer when block sizes are large enough to hold multiple
+	 * inode chunks.  When this happens, cluster_base will be zero but
+	 * ir_startino can be large enough to make im_boffset nonzero.
+	 */
 	ir_holemask = (irec->ir_holemask & cluster_mask);
 	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
-	imap.im_boffset = 0;
+	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
+
+	if (imap.im_boffset != 0 && cluster_base != 0) {
+		ASSERT(imap.im_boffset == 0 || cluster_base == 0);
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
 	trace_xchk_iallocbt_check_cluster(mp, agno, irec->ir_startino,
 			imap.im_blkno, imap.im_len, cluster_base, nr_inodes,
@@ -298,10 +295,19 @@ xchk_iallocbt_check_cluster(
 
 	/* Check free status of each inode within this cluster. */
 	for (cluster_index = 0; cluster_index < nr_inodes; cluster_index++) {
+		struct xfs_dinode	*dip;
+
+		if (imap.im_boffset >= BBTOB(cluster_bp->b_length)) {
+			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+			break;
+		}
+
+		dip = xfs_buf_offset(cluster_bp, imap.im_boffset);
 		error = xchk_iallocbt_check_cluster_ifree(bs, irec,
-				cluster_base, cluster_bp, cluster_index);
+				cluster_base, dip, cluster_index);
 		if (error)
 			break;
+		imap.im_boffset += mp->m_sb.sb_inodesize;
 	}
 
 	xfs_trans_brelse(bs->cur->bc_tp, cluster_bp);
