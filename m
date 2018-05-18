Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeERDyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 23:54:54 -0400
Date: Thu, 17 May 2018 20:54:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 05/22] xfs: recover AG btree roots from rmap data
Message-ID: <20180518035449.GB23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365045.1556.6221144971800322852.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642365045.1556.6221144971800322852.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, david@fromorbit.com

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
v2: document how we probe for btree roots and dcoument the locking
    requirements for the callers
---
 fs/xfs/scrub/repair.c |  190 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |   20 +++++
 2 files changed, 210 insertions(+)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7daf0120d1bf..877488ce4bc8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -836,3 +836,193 @@ xfs_repair_reap_btree_extents(
 	xfs_repair_cancel_btree_extents(sc, exlist);
 	return error;
 }
+
+/*
+ * Finding per-AG Btree Roots for AGF/AGI Reconstruction
+ *
+ * If the AGF or AGI become slightly corrupted, it may be necessary to rebuild
+ * the AG headers by using the rmap data to rummage through the AG looking for
+ * btree roots.  This is not guaranteed to work if the AG is heavily damaged
+ * or the rmap data are corrupt.
+ *
+ * Callers of xfs_repair_find_ag_btree_roots must lock the AGF and AGFL
+ * buffers if the AGF is being rebuilt; or the AGF and AGI buffers if the
+ * AGI is being rebuilt.  It must maintain these locks until it's safe for
+ * other threads to change the btrees' shapes.  The caller provides
+ * information about the btrees to look for by passing in an array of
+ * xfs_repair_find_ag_btree with the (rmap owner, buf_ops, magic) fields set.
+ * The (root, height) fields will be set on return if anything is found.  The
+ * last element of the array should have a NULL buf_ops to mark the end of the
+ * array.
+ *
+ * For every rmapbt record matching any of the rmap owners in btree_info,
+ * read each block referenced by the rmap record.  If the block is a btree
+ * block from this filesystem matching any of the magic numbers and has a
+ * level higher than what we've already seen, remember the block and the
+ * height of the tree required to have such a block.  When the call completes,
+ * we return the highest block we've found for each btree description; those
+ * should be the roots.
+ */
+
+struct xfs_repair_findroot {
+	struct xfs_scrub_context	*sc;
+	struct xfs_buf			*agfl_bp;
+	struct xfs_agf			*agf;
+	struct xfs_repair_find_ag_btree	*btree_info;
+};
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
+			if (rec->rm_owner != fab->rmap_owner)
+				continue;
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
+/* Find the roots of the per-AG btrees described in btree_info. */
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
+	ASSERT(xfs_buf_islocked(agf_bp));
+	ASSERT(agfl_bp == NULL || xfs_buf_islocked(agfl_bp));
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
index f14aaab7df9e..c922ef06b894 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -77,6 +77,26 @@ int xfs_repair_reap_btree_extents(struct xfs_scrub_context *sc,
 		struct xfs_repair_extent_list *exlist,
 		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
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
