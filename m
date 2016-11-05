Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39061 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:23:15 -0400
Subject: [PATCH 38/41] xfs: repair refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:23:11 -0700
Message-ID: <147830539097.2155.15478867424258524868.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c    |   21 ++
 fs/xfs/libxfs/xfs_btree.h    |    1 
 fs/xfs/libxfs/xfs_refcount.c |   19 ++
 fs/xfs/libxfs/xfs_refcount.h |    4 
 fs/xfs/xfs_scrub.c           |  436 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 479 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 3c2ca1f..7fb2946 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4891,3 +4891,24 @@ xfs_btree_has_record(
 
 	return 0;
 }
+
+/* Are there more records in this btree? */
+bool
+xfs_btree_has_more_records(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+	/* There are still records in this block. */
+	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
+		return true;
+
+	/* There are more record blocks. */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
+	else
+		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b088670..5d15e42 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -551,5 +551,6 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
+bool xfs_btree_has_more_records(struct xfs_btree_cur *);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index f63cfdb..1c47671 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -87,6 +87,23 @@ xfs_refcount_lookup_ge(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
+/*
+ * Look up the first record equal to [bno, len] in the btree
+ * given by cur.
+ */
+int
+xfs_refcount_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
@@ -148,7 +165,7 @@ xfs_refcount_update(
  * by [bno, len, refcount].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
-STATIC int
+int
 xfs_refcount_insert(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*irec,
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 5973c56..cad61de 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -24,6 +24,8 @@ extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
+extern int xfs_refcount_lookup_eq(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
@@ -72,5 +74,7 @@ extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
+extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
 
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 814dcc5..d5f430e 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -58,6 +58,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans_space.h"
+#include "xfs_reflink.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -5200,6 +5201,439 @@ xfs_scrub_refcountbt(
 			&oinfo, NULL);
 }
 
+/*
+ * Rebuilding the Reference Count Btree
+ *
+ * This algorithm is "borrowed" from xfs_repair.  Imagine the rmap
+ * entries as rectangles representing extents of physical blocks, and
+ * that the rectangles can be laid down to allow them to overlap each
+ * other; then we know that we must emit a refcnt btree entry wherever
+ * the amount of overlap changes, i.e. the emission stimulus is
+ * level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2
+ * cases because the bnobt tells us which blocks are free; single-use
+ * blocks aren't recorded in the bnobt or the refcntbt.  If the rmapbt
+ * supports storing multiple entries covering a given block we could
+ * theoretically dispense with the refcntbt and simply count rmaps, but
+ * that's inefficient in the (hot) write path, so we'll take the cost of
+ * the extra tree to save time.  Also there's no guarantee that rmap
+ * will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting
+ * physical block (sp), a bag to hold rmaps that cover sp, and the next
+ * physical block where the level changes (np), we can reconstruct the
+ * refcount btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.  This
+ *    is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap)
+ *       and (startblock + len of each rmap in the bag).
+ *
+ * An implementation detail is that because this processing happens
+ * during phase 4, the refcount entries are stored in an array so that
+ * phase 5 can load them into the refcount btree.  The rmaps can be
+ * loaded directly into the rmap btree during phase 5 as well.
+ */
+
+struct xfs_repair_refc_rmap {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+};
+
+struct xfs_repair_refc_extent {
+	struct list_head		list;
+	struct xfs_refcount_irec	refc;
+};
+
+struct xfs_repair_refc {
+	struct list_head		rmap_bag;  /* rmaps we're tracking */
+	struct list_head		rmap_idle; /* idle rmaps */
+	struct list_head		extlist;   /* refcount extents */
+	struct list_head		btlist;    /* old refcountbt blocks */
+	xfs_extlen_t			btblocks;  /* # of refcountbt blocks */
+};
+
+/* Grab the next record from the rmapbt. */
+STATIC int
+xfs_repair_refcountbt_next_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_repair_refc		*rr,
+	struct xfs_rmap_irec		*rec,
+	bool				*have_rec)
+{
+	struct xfs_rmap_irec		rmap;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_repair_refc_extent	*rre;
+	xfs_fsblock_t			fsbno;
+	int				have_gt;
+	int				error;
+
+	*have_rec = false;
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		error = xfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		if (!have_gt)
+			return 0;
+
+		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+
+		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
+			/* Pass CoW staging extents right through. */
+			rre = kmem_alloc(sizeof(*rre), KM_NOFS);
+			if (!rre)
+				goto out_error;
+
+			INIT_LIST_HEAD(&rre->list);
+			rre->refc.rc_startblock = rmap.rm_startblock +
+					XFS_REFC_COW_START;
+			rre->refc.rc_blockcount = rmap.rm_blockcount;
+			rre->refc.rc_refcount = 1;
+			list_add_tail(&rre->list, &rr->extlist);
+		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+			/* refcountbt block, dump it when we're done. */
+			rr->btblocks += rmap.rm_blockcount;
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					rmap.rm_startblock);
+			error = xfs_repair_collect_btree_extent(&rr->btlist,
+					fsbno, rmap.rm_blockcount);
+			if (error)
+				goto out_error;
+		}
+	} while (XFS_RMAP_NON_INODE_OWNER(rmap.rm_owner) ||
+		 xfs_internal_inum(mp, rmap.rm_owner) ||
+		 (rmap.rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+				   XFS_RMAP_UNWRITTEN)));
+
+	*rec = rmap;
+	*have_rec = true;
+	return 0;
+
+out_error:
+	return error;
+}
+
+/* Recycle an idle rmap or allocate a new one. */
+static struct xfs_repair_refc_rmap *
+xfs_repair_refcountbt_get_rmap(
+	struct xfs_repair_refc		*rr)
+{
+	struct xfs_repair_refc_rmap	*rrm;
+
+	if (list_empty(&rr->rmap_idle)) {
+		rrm = kmem_alloc(sizeof(*rrm), KM_NOFS);
+		if (!rrm)
+			return NULL;
+		INIT_LIST_HEAD(&rrm->list);
+		return rrm;
+	}
+
+	rrm = list_first_entry(&rr->rmap_idle, struct xfs_repair_refc_rmap,
+			list);
+	list_del_init(&rrm->list);
+	return rrm;
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_refcount_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_refc_extent	*ap;
+	struct xfs_repair_refc_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_refc_extent, list);
+	bp = container_of(b, struct xfs_repair_refc_extent, list);
+
+	if (ap->refc.rc_startblock > bp->refc.rc_startblock)
+		return 1;
+	else if (ap->refc.rc_startblock < bp->refc.rc_startblock)
+		return -1;
+	return 0;
+}
+
+/* Rebuild the refcount btree. */
+#define RMAP_END(r)	((r).rm_startblock + (r).rm_blockcount)
+STATIC int
+xfs_repair_refcountbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_refc		rr;
+	struct xfs_rmap_irec		rmap;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_repair_refc_rmap	*rrm;
+	struct xfs_repair_refc_rmap	*n;
+	struct xfs_repair_refc_extent	*rre;
+	struct xfs_repair_refc_extent	*o;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*cur;
+	struct xfs_perag		*pag;
+	uint64_t			nr_records;
+	xfs_fsblock_t			btfsb;
+	size_t				old_stack_sz;
+	size_t				stack_sz = 0;
+	xfs_agblock_t			sbno;
+	xfs_agblock_t			cbno;
+	xfs_agblock_t			nbno;
+	bool				have;
+	int				have_gt;
+	int				error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	INIT_LIST_HEAD(&rr.rmap_bag);
+	INIT_LIST_HEAD(&rr.rmap_idle);
+	INIT_LIST_HEAD(&rr.extlist);
+	INIT_LIST_HEAD(&rr.btlist);
+	rr.btblocks = 0;
+	nr_records = 0;
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
+
+	/* Start the rmapbt cursor to the left of all records. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_lookup_le(cur, 0, 0, 0, 0, 0, &have_gt);
+	if (error)
+		return error;
+	ASSERT(have_gt == 0);
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(cur)) {
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap, &have);
+		if (error)
+			goto out;
+		if (!have)
+			break;
+		sbno = cbno = rmap.rm_startblock;
+		while (have && rmap.rm_startblock == sbno) {
+			rrm = xfs_repair_refcountbt_get_rmap(&rr);
+			if (!rrm)
+				goto out;
+			rrm->rmap = rmap;
+			list_add_tail(&rrm->list, &rr.rmap_bag);
+			stack_sz++;
+			error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap,
+					&have);
+			if (error)
+				goto out;
+		}
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt, out);
+
+		/* Set nbno to the bno of the next refcount change */
+		nbno = have ? rmap.rm_startblock : NULLAGBLOCK;
+		list_for_each_entry(rrm, &rr.rmap_bag, list)
+			nbno = min_t(xfs_agblock_t, nbno, RMAP_END(rrm->rmap));
+
+		ASSERT(nbno > sbno);
+		old_stack_sz = stack_sz;
+
+		/* While stack isn't empty... */
+		while (stack_sz) {
+			/* Pop all rmaps that end at nbno */
+			list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+				if (RMAP_END(rrm->rmap) != nbno)
+					continue;
+				stack_sz--;
+				list_del_init(&rrm->list);
+				list_add(&rrm->list, &rr.rmap_idle);
+			}
+
+			/* Push array items that start at nbno */
+			error = xfs_repair_refcountbt_next_rmap(cur, &rr, &rmap,
+					&have);
+			if (error)
+				goto out;
+			while (have && rmap.rm_startblock == nbno) {
+				rrm = xfs_repair_refcountbt_get_rmap(&rr);
+				if (!rrm)
+					goto out;
+				rrm->rmap = rmap;
+				list_add_tail(&rrm->list, &rr.rmap_bag);
+				stack_sz++;
+				error = xfs_repair_refcountbt_next_rmap(cur,
+						&rr, &rmap, &have);
+				if (error)
+					goto out;
+			}
+			error = xfs_btree_decrement(cur, 0, &have_gt);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(mp, have_gt, out);
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (stack_sz != old_stack_sz) {
+				if (old_stack_sz > 1) {
+					rre = kmem_alloc(sizeof(*rre), KM_NOFS);
+					if (!rre)
+						goto out;
+					INIT_LIST_HEAD(&rre->list);
+					rre->refc.rc_startblock = cbno;
+					rre->refc.rc_blockcount = nbno - cbno;
+					rre->refc.rc_refcount = old_stack_sz;
+					list_add_tail(&rre->list, &rr.extlist);
+					nr_records++;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (stack_sz == 0)
+				break;
+			old_stack_sz = stack_sz;
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			nbno = have ? rmap.rm_startblock : NULLAGBLOCK;
+			list_for_each_entry(rrm, &rr.rmap_bag, list)
+				nbno = min_t(xfs_agblock_t, nbno,
+						RMAP_END(rrm->rmap));
+
+			/* Emit reverse mappings, if needed */
+			ASSERT(nbno > sbno);
+		}
+	}
+	ASSERT(list_empty(&rr.rmap_bag));
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Free all the rmap records. */
+	list_for_each_entry_safe(rrm, n, &rr.rmap_idle, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+
+	/* Do we actually have enough space to do this? */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	if (!xfs_repair_ag_has_space(pag,
+			xfs_refcountbt_calc_size(mp, nr_records),
+			XFS_AG_RESV_METADATA)) {
+		xfs_perag_put(pag);
+		error = -ENOSPC;
+		goto out;
+	}
+	xfs_perag_put(pag);
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	/* Initialize a new btree root. */
+	error = xfs_repair_alloc_ag_block(sc, &oinfo, &btfsb,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		goto out;
+	error = xfs_repair_init_btblock(sc, btfsb, &bp, XFS_REFC_CRC_MAGIC,
+			&xfs_refcountbt_buf_ops);
+	if (error)
+		goto out;
+	agf->agf_refcount_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, btfsb));
+	agf->agf_refcount_level = cpu_to_be32(1);
+	agf->agf_refcount_blocks = cpu_to_be32(1);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_REFCOUNT_BLOCKS |
+			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Insert records into the new btree. */
+	list_sort(NULL, &rr.extlist, xfs_repair_refcount_extent_cmp);
+	list_for_each_entry_safe(rre, o, &rr.extlist, list) {
+		/* Insert into the refcountbt. */
+		cur = xfs_refcountbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.agno, NULL);
+		error = xfs_refcount_lookup_eq(cur, rre->refc.rc_startblock,
+				&have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 0, out);
+		error = xfs_refcount_insert(cur, &rre->refc, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out);
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+
+		error = xfs_repair_roll_ag_trans(sc);
+		if (error)
+			goto out;
+
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+
+	/* Free the old refcountbt blocks if they're not in use. */
+	error = xfs_repair_reap_btree_extents(sc, &rr.btlist, &oinfo,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		goto out;
+
+	return error;
+
+out:
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_repair_cancel_btree_extents(sc, &rr.btlist);
+	list_for_each_entry_safe(rrm, n, &rr.rmap_idle, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rrm, n, &rr.rmap_bag, list) {
+		list_del(&rrm->list);
+		kmem_free(rrm);
+	}
+	list_for_each_entry_safe(rre, o, &rr.extlist, list) {
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+	return error;
+}
+
 #define XFS_SCRUB_INODE_CHECK(fs_ok) \
 	XFS_SCRUB_INO_CHECK(sc, NULL, "inode", fs_ok);
 #define XFS_SCRUB_INODE_GOTO(fs_ok, label) \
@@ -6671,7 +7105,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, xfs_repair_iallocbt, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, xfs_repair_iallocbt, xfs_sb_version_hasfinobt},
 	{xfs_scrub_setup_ag_header_freeze, xfs_scrub_rmapbt, xfs_repair_rmapbt, xfs_sb_version_hasrmapbt},
-	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
+	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, xfs_repair_refcountbt, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode, xfs_scrub_inode, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},

