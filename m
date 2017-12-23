Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbdLWBIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:08:49 -0500
Subject: [PATCH 16/20] xfs: scrub in-core metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:44 -0800
Message-ID: <151399132410.23543.5262717928101774681.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we load a buffer, explicitly re-call the structure verifier to
ensure that memory isn't corrupting things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/agheader.c |    3 +++
 fs/xfs/scrub/btree.c    |    4 ++++
 fs/xfs/scrub/common.c   |   23 +++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    2 ++
 fs/xfs/scrub/dabtree.c  |   22 ++++++++++++++++++++++
 fs/xfs/scrub/dir.c      |    4 ++++
 6 files changed, 58 insertions(+)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e36ea25..c19d62a 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -587,6 +587,7 @@ xfs_scrub_agf(
 			&sc->sa.agf_bp, &sc->sa.agfl_bp);
 	if (!xfs_scrub_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
 		goto out;
+	xfs_scrub_buffer_recheck(sc, sc->sa.agf_bp);
 
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 
@@ -758,6 +759,7 @@ xfs_scrub_agfl(
 		goto out;
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
+	xfs_scrub_buffer_recheck(sc, sc->sa.agfl_bp);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
@@ -871,6 +873,7 @@ xfs_scrub_agi(
 			&sc->sa.agf_bp, &sc->sa.agfl_bp);
 	if (!xfs_scrub_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
 		goto out;
+	xfs_scrub_buffer_recheck(sc, sc->sa.agi_bp);
 
 	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 2336c84..2d16df4 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -315,6 +315,8 @@ xfs_scrub_btree_block_check_sibling(
 	pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
 	if (!xfs_scrub_btree_ptr_ok(bs, level + 1, pp))
 		goto out;
+	if (pbp)
+		xfs_scrub_buffer_recheck(bs->sc, pbp);
 
 	if (xfs_btree_diff_two_ptrs(cur, pp, sibling))
 		xfs_scrub_btree_set_corrupt(bs->sc, cur, level);
@@ -484,6 +486,8 @@ xfs_scrub_btree_get_block(
 		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
 		return 0;
 	}
+	if (*pbp)
+		xfs_scrub_buffer_recheck(bs->sc, *pbp);
 
 	/*
 	 * Check the block's owner; this function absorbs error codes
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1495b91c..fba4c67 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -753,3 +753,26 @@ xfs_scrub_should_xref(
 	*error = 0;
 	return false;
 }
+
+/* Run the structure verifiers on in-memory buffers to detect bad memory. */
+void
+xfs_scrub_buffer_recheck(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp)
+{
+	xfs_failaddr_t			fa;
+
+	if (bp->b_ops == NULL) {
+		xfs_scrub_block_set_corrupt(sc, bp);
+		return;
+	}
+	if (bp->b_ops->verify_struct == NULL) {
+		xfs_scrub_set_incomplete(sc);
+		return;
+	}
+	fa = bp->b_ops->verify_struct(bp);
+	if (!fa)
+		return;
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xfs_scrub_block_error(sc, bp->b_bn, fa);
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 519f6e8..56dc321 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -171,4 +171,6 @@ static inline __u32 xfs_scrub_process_error_flag(bool xref)
 	return xref ? XFS_SCRUB_OFLAG_XFAIL : XFS_SCRUB_OFLAG_CORRUPT;
 }
 
+void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index d94edd9..bffdb7d 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -233,11 +233,28 @@ xfs_scrub_da_btree_write_verify(
 		return;
 	}
 }
+static void *
+xfs_scrub_da_btree_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_blkinfo	*info = bp->b_addr;
+
+	switch (be16_to_cpu(info->magic)) {
+	case XFS_DIR2_LEAF1_MAGIC:
+	case XFS_DIR3_LEAF1_MAGIC:
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+		return bp->b_ops->verify_struct(bp);
+	default:
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		return bp->b_ops->verify_struct(bp);
+	}
+}
 
 static const struct xfs_buf_ops xfs_scrub_da_btree_buf_ops = {
 	.name = "xfs_scrub_da_btree",
 	.verify_read = xfs_scrub_da_btree_read_verify,
 	.verify_write = xfs_scrub_da_btree_write_verify,
+	.verify_struct = xfs_scrub_da_btree_verify,
 };
 
 /* Check a block's sibling. */
@@ -276,6 +293,9 @@ xfs_scrub_da_btree_block_check_sibling(
 		xfs_scrub_da_set_corrupt(ds, level);
 		return error;
 	}
+	if (ds->state->altpath.blk[level].bp)
+		xfs_scrub_buffer_recheck(ds->sc,
+				ds->state->altpath.blk[level].bp);
 
 	/* Compare upper level pointer to sibling pointer. */
 	if (ds->state->altpath.blk[level].blkno != sibling)
@@ -358,6 +378,8 @@ xfs_scrub_da_btree_block(
 			&xfs_scrub_da_btree_buf_ops);
 	if (!xfs_scrub_da_process_error(ds, level, &error))
 		goto out_nobuf;
+	if (blk->bp)
+		xfs_scrub_buffer_recheck(ds->sc, blk->bp);
 
 	/*
 	 * We didn't find a dir btree root block, which means that
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e75826b..f5a0d17 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -237,6 +237,7 @@ xfs_scrub_dir_rec(
 		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out;
 	}
+	xfs_scrub_buffer_recheck(ds->sc, bp);
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
 	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
@@ -324,6 +325,7 @@ xfs_scrub_directory_data_bestfree(
 	}
 	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
+	xfs_scrub_buffer_recheck(sc, bp);
 
 	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
 
@@ -474,6 +476,7 @@ xfs_scrub_directory_leaf1_bestfree(
 	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
 	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
+	xfs_scrub_buffer_recheck(sc, bp);
 
 	leaf = bp->b_addr;
 	d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
@@ -559,6 +562,7 @@ xfs_scrub_directory_free_bestfree(
 	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
 	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
+	xfs_scrub_buffer_recheck(sc, bp);
 
 	if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
 		struct xfs_dir3_free_hdr	*hdr3 = bp->b_addr;

