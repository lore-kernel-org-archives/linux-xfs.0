Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeEOWeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:34:15 -0400
Subject: [PATCH 05/22] xfs: recover AG btree roots from rmap data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:34:10 -0700
Message-ID: <152642365045.1556.6221144971800322852.stgit@magnolia>
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper function to help us recover btree roots from the rmap data.
Callers pass in a list of rmap owner codes, buffer ops, and magic
numbers.  We iterate the rmap records looking for owner matches, and
then read the matching blocks to see if the magic number & uuid match.
If so, we then read-verify the block, and if that passes then we retain
a pointer to the block with the highest level, assuming that by the end
of the call we will have found the root.  This will be used to reset the
AGF/AGI btree root fields during their rebuild procedures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   20 ++++++
 2 files changed, 198 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d820e01d1146..06c84f76d7ff 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -766,3 +766,181 @@ xfs_repair_invalidate_blocks(
 
 	return 0;
 }
+
+/* See if our block is in the AGFL. */
+STATIC int
+xfs_repair_findroot_agfl_walk(
+	struct xfs_mount		*mp,
+	xfs_agblock_t			bno,
+	void				*priv)
+{
+	xfs_agblock_t			*agbno = priv;
+
+	return (*agbno == bno) ? XFS_BTREE_QUERY_RANGE_ABORT : 0;
+}
+
+struct xfs_repair_findroot {
+	struct xfs_scrub_context	*sc;
+	struct xfs_buf			*agfl_bp;
+	struct xfs_agf			*agf;
+	struct xfs_repair_find_ag_btree	*btree_info;
+};
+
+/* Does this block match the btree information passed in? */
+STATIC int
+xfs_repair_findroot_block(
+	struct xfs_repair_findroot	*ri,
+	struct xfs_repair_find_ag_btree	*fab,
+	uint64_t			owner,
+	xfs_agblock_t			agbno,
+	bool				*found_it)
+{
+	struct xfs_mount		*mp = ri->sc->mp;
+	struct xfs_buf			*bp;
+	struct xfs_btree_block		*btblock;
+	xfs_daddr_t			daddr;
+	int				error;
+
+	/* rmap owner match? */
+	if (owner != fab->rmap_owner)
+		return 0;
+
+	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
+
+	/*
+	 * Blocks in the AGFL have stale contents that might just happen to
+	 * have a matching magic and uuid.  We don't want to pull these blocks
+	 * in as part of a tree root, so we have to filter out the AGFL stuff
+	 * here.  If the AGFL looks insane we'll just refuse to repair.
+	 */
+	if (owner == XFS_RMAP_OWN_AG) {
+		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
+				xfs_repair_findroot_agfl_walk, &agbno);
+		if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+			return 0;
+		if (error)
+			return error;
+	}
+
+	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
+			mp->m_bsize, 0, &bp, NULL);
+	if (error)
+		return error;
+
+	/*
+	 * Does this look like a block matching our fs and higher than any
+	 * other block we've found so far?  If so, reattach buffer verifiers
+	 * so the AIL won't complain if the buffer is also dirty.
+	 */
+	btblock = XFS_BUF_TO_BLOCK(bp);
+	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
+		goto out;
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
+		goto out;
+	bp->b_ops = fab->buf_ops;
+
+	/* Ignore this block if it's lower in the tree than we've seen. */
+	if (fab->root != NULLAGBLOCK &&
+	    xfs_btree_get_level(btblock) < fab->height)
+		goto out;
+
+	/* Make sure we pass the verifiers. */
+	bp->b_ops->verify_read(bp);
+	if (bp->b_error)
+		goto out;
+	fab->root = agbno;
+	fab->height = xfs_btree_get_level(btblock) + 1;
+	*found_it = true;
+
+	trace_xfs_repair_findroot_block(mp, ri->sc->sa.agno, agbno,
+			be32_to_cpu(btblock->bb_magic), fab->height - 1);
+out:
+	xfs_trans_brelse(ri->sc->tp, bp);
+	return error;
+}
+
+/*
+ * Do any of the blocks in this rmap record match one of the btrees we're
+ * looking for?
+ */
+STATIC int
+xfs_repair_findroot_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_findroot	*ri = priv;
+	struct xfs_repair_find_ag_btree	*fab;
+	xfs_agblock_t			b;
+	bool				found_it;
+	int				error = 0;
+
+	/* Ignore anything that isn't AG metadata. */
+	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner))
+		return 0;
+
+	/* Otherwise scan each block + btree type. */
+	for (b = 0; b < rec->rm_blockcount; b++) {
+		found_it = false;
+		for (fab = ri->btree_info; fab->buf_ops; fab++) {
+			error = xfs_repair_findroot_block(ri, fab,
+					rec->rm_owner, rec->rm_startblock + b,
+					&found_it);
+			if (error)
+				return error;
+			if (found_it)
+				break;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Find the roots of the per-AG btrees described in btree_info.
+ *
+ * The caller provides information about the btrees to look for by passing in
+ * an array (@btree_info) of xfs_repair_find_ag_btree with the (rmap owner,
+ * buf_ops, magic) fields set.  The last element of the array should have a
+ * NULL buf_ops, and the (root, height) fields will be set on return if
+ * anything is found.
+ *
+ * For every rmapbt record matching any of the rmap owners in @btree_info,
+ * read each block referenced by the rmap record.  If the block is a btree
+ * block from this filesystem matching any of the magic numbers and has a
+ * level higher than what we've already seen, remember the block and the
+ * height of the tree required to have such a block.  When the call completes,
+ * we return the highest block we've found for each btree description; those
+ * should be the roots.
+ */
+int
+xfs_repair_find_ag_btree_roots(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*agf_bp,
+	struct xfs_repair_find_ag_btree	*btree_info,
+	struct xfs_buf			*agfl_bp)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_repair_findroot	ri;
+	struct xfs_repair_find_ag_btree	*fab;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	ri.sc = sc;
+	ri.btree_info = btree_info;
+	ri.agf = XFS_BUF_TO_AGF(agf_bp);
+	ri.agfl_bp = agfl_bp;
+	for (fab = btree_info; fab->buf_ops; fab++) {
+		ASSERT(agfl_bp || fab->rmap_owner != XFS_RMAP_OWN_AG);
+		ASSERT(XFS_RMAP_NON_INODE_OWNER(fab->rmap_owner));
+		fab->root = NULLAGBLOCK;
+		fab->height = 0;
+	}
+
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_findroot_rmap, &ri);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e0e7f86d509c..55441774e8e5 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -77,6 +77,26 @@ int xfs_repair_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
 int xfs_repair_invalidate_blocks(struct xfs_scrub_context *sc,
 		struct xfs_repair_extent_list *btlist);
 
+struct xfs_repair_find_ag_btree {
+	/* in: rmap owner of the btree we're looking for */
+	uint64_t			rmap_owner;
+
+	/* in: buffer ops */
+	const struct xfs_buf_ops	*buf_ops;
+
+	/* in: magic number of the btree */
+	uint32_t			magic;
+
+	/* out: the highest btree block found and the tree height */
+	xfs_agblock_t			root;
+	unsigned int			height;
+};
+
+int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
+		struct xfs_buf *agf_bp,
+		struct xfs_repair_find_ag_btree *btree_info,
+		struct xfs_buf *agfl_bp);
+
 /* Metadata repairers */
 
 int xfs_repair_probe(struct xfs_scrub_context *sc);

