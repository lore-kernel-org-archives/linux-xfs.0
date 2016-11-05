Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18186 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:22:49 -0400
Subject: [PATCH 34/41] xfs: add helper routines for the repair code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:22:45 -0700
Message-ID: <147830536575.2155.7645072612564972931.stgit@birch.djwong.org>
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

Add some helper functions for repair functions that will help us to
allocate and initialize new metadata blocks for btrees that we're
rebuilding.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c  |    9 +
 fs/xfs/libxfs/xfs_alloc_btree.h  |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c   |    9 +
 fs/xfs/libxfs/xfs_bmap_btree.h   |    3 
 fs/xfs/libxfs/xfs_btree.c        |    4 
 fs/xfs/libxfs/xfs_btree.h        |    2 
 fs/xfs/libxfs/xfs_ialloc_btree.c |    9 +
 fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
 fs/xfs/libxfs/xfs_rmap.c         |   51 ++++
 fs/xfs/libxfs/xfs_rmap.h         |    3 
 fs/xfs/xfs_scrub.c               |  522 ++++++++++++++++++++++++++++++++++++++
 11 files changed, 614 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 927f444..3954c2f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -532,3 +532,12 @@ xfs_allocbt_maxrecs(
 		return blocklen / sizeof(xfs_alloc_rec_t);
 	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
 }
+
+/* Calculate the freespace btree size for some records. */
+xfs_extlen_t
+xfs_allocbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_alloc_mnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 45e189e..2fd5472 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -61,5 +61,7 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 54dd7a7..659e41b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -912,3 +912,12 @@ xfs_bmbt_change_owner(
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	return error;
 }
+
+/* Calculate the bmap btree size for some records. */
+unsigned long long
+xfs_bmbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_bmap_dmnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 819a8a4..835f0a3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -140,4 +140,7 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
+extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a6cf8cf..3c2ca1f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4820,7 +4820,7 @@ xfs_btree_query_all(
  * Calculate the number of blocks needed to store a given number of records
  * in a short-format (per-AG metadata) btree.
  */
-xfs_extlen_t
+unsigned long long
 xfs_btree_calc_size(
 	struct xfs_mount	*mp,
 	uint			*limits,
@@ -4828,7 +4828,7 @@ xfs_btree_calc_size(
 {
 	int			level;
 	int			maxrecs;
-	xfs_extlen_t		rval;
+	unsigned long long	rval;
 
 	maxrecs = limits[0];
 	for (level = 0, rval = 0; len > 1; level++) {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 644f953..b088670 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -515,7 +515,7 @@ bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
-xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
+unsigned long long xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
 		unsigned long long len);
 
 /* return codes */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index dbdd532..951dd64 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -498,3 +498,12 @@ xfs_inobt_rec_check_count(
 	return 0;
 }
 #endif	/* DEBUG */
+
+/* Calculate the inobt btree size for some records. */
+xfs_extlen_t
+xfs_iallocbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp, mp->m_inobt_mnr, len);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index bd88453..3046c11 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -72,4 +72,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #define xfs_inobt_rec_check_count(mp, rec)	0
 #endif	/* DEBUG */
 
+extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 4b4d701..ec24e24 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2364,3 +2364,54 @@ xfs_rmap_record_exists(
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
 }
+
+struct xfs_rmap_has_other_keys {
+	uint64_t			owner;
+	uint64_t			offset;
+	bool				*has_rmap;
+	unsigned int			flags;
+};
+
+/* For each rmap given, figure out if it doesn't match the key we want. */
+STATIC int
+xfs_rmap_has_other_keys_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_rmap_has_other_keys	*rhok = priv;
+
+	if (rhok->owner == rec->rm_owner && rhok->offset == rec->rm_offset &&
+	    ((rhok->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rhok->flags)
+		return 0;
+	*rhok->has_rmap = true;
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/*
+ * Given an extent and some owner info, can we find records overlapping
+ * the extent whose owner info does not match the given owner?
+ */
+int
+xfs_rmap_has_other_keys(
+	struct xfs_btree_cur		*cur,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	struct xfs_owner_info		*oinfo,
+	bool				*has_rmap)
+{
+	struct xfs_rmap_irec		low = {0};
+	struct xfs_rmap_irec		high;
+	struct xfs_rmap_has_other_keys	rhok;
+
+	xfs_owner_info_unpack(oinfo, &rhok.owner, &rhok.offset, &rhok.flags);
+	*has_rmap = false;
+	rhok.has_rmap = has_rmap;
+
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	return xfs_rmap_query_range(cur, &low, &high,
+			xfs_rmap_has_other_keys_helper, &rhok);
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index ea359ab..606efe3 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -222,5 +222,8 @@ int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 7e03c54..981f1e3 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -55,6 +55,9 @@
 #include "xfs_attr.h"
 #include "xfs_symlink.h"
 #include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_ag_resv.h"
+#include "xfs_trans_space.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -563,6 +566,446 @@ xfs_scrub_ag_init(
 	return error;
 }
 
+/*
+ * Roll a transaction, keeping the AG headers locked and reinitializing
+ * the btree cursors.
+ */
+STATIC int
+xfs_repair_roll_ag_trans(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_trans		*tp;
+	int				error;
+
+	/* Keep the AG header buffers locked so we can keep going. */
+	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
+
+	/* Roll the transaction. */
+	tp = sc->tp;
+	error = xfs_trans_roll(&sc->tp, NULL);
+	if (error)
+		return error;
+
+	/* Join the buffer to the new transaction or release the hold. */
+	if (sc->tp != tp) {
+		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
+		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
+	} else {
+		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
+		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
+		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
+	}
+
+	return error;
+}
+
+/*
+ * Does the given AG have enough space to rebuild a btree?  Neither AG
+ * reservation can be critical, and we must have enough space (factoring
+ * in AG reservations) to construct a whole btree.
+ */
+static inline bool
+xfs_repair_ag_has_space(
+	struct xfs_perag		*pag,
+	xfs_extlen_t			nr_blocks,
+	enum xfs_ag_resv_type		type)
+{
+	return  !xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) &&
+		!xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA) &&
+		pag->pagf_freeblks - xfs_ag_resv_needed(pag, type) > nr_blocks;
+}
+
+/* Allocate a block in an AG. */
+STATIC int
+xfs_repair_alloc_ag_block(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	xfs_fsblock_t			*fsbno,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_alloc_arg		args = {0};
+	xfs_agblock_t			bno;
+	int				error;
+
+	if (resv == XFS_AG_RESV_AGFL) {
+		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
+		if (error)
+			return error;
+		xfs_extent_busy_reuse(sc->tp->t_mountp, sc->sa.agno, bno,
+				1, false);
+		*fsbno = XFS_AGB_TO_FSB(sc->tp->t_mountp, sc->sa.agno, bno);
+		return 0;
+	}
+
+	args.tp = sc->tp;
+	args.mp = sc->tp->t_mountp;
+	args.oinfo = *oinfo;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);
+	args.minlen = 1;
+	args.maxlen = 1;
+	args.prod = 1;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.resv = resv;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+	if (args.fsbno == NULLFSBLOCK)
+		return -ENOSPC;
+	ASSERT(args.len == 1);
+	*fsbno = args.fsbno;
+
+	return 0;
+}
+
+/* Initialize an AG block to a zeroed out btree header. */
+STATIC int
+xfs_repair_init_btblock(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsb,
+	struct xfs_buf			**bpp,
+	__u32				magic,
+	const struct xfs_buf_ops	*ops)
+{
+	struct xfs_trans		*tp = sc->tp;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_buf			*bp;
+
+	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
+	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
+			XFS_FSB_TO_BB(mp, 1), 0);
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+	xfs_btree_init_block(mp, bp, magic, 0, 0, sc->sa.agno,
+			XFS_BTREE_CRC_BLOCKS);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
+	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
+	bp->b_ops = ops;
+	*bpp = bp;
+
+	return 0;
+}
+
+/* Ensure the freelist is full. */
+static int
+xfs_repair_fix_freelist(
+	struct xfs_scrub_context	*sc,
+	bool				can_shrink)
+{
+	struct xfs_alloc_arg		args = {0};
+	int				error;
+
+	args.mp = sc->tp->t_mountp;
+	args.tp = sc->tp;
+	args.agno = sc->sa.agno;
+	args.alignment = 1;
+	args.pag = xfs_perag_get(args.mp, sc->sa.agno);
+
+	error = xfs_alloc_fix_freelist(&args,
+			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	xfs_perag_put(args.pag);
+
+	return error;
+}
+
+/* Put a block back on the AGFL. */
+static int
+xfs_repair_put_freelist(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_owner_info		oinfo;
+	int				error;
+
+	/*
+	 * Since we're "freeing" a lost block onto the AGFL, we have to
+	 * create an rmap for the block prior to merging it or else other
+	 * parts will break.
+	 */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
+			&oinfo);
+	if (error)
+		return error;
+
+	/* Put the block on the AGFL. */
+	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
+			agbno, 0);
+	if (error)
+		return error;
+	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
+			XFS_EXTENT_BUSY_SKIP_DISCARD);
+
+	/* Make sure the AGFL doesn't overfill. */
+	return xfs_repair_fix_freelist(sc, true);
+}
+
+/*
+ * For a given metadata extent and owner, delete the associated rmap.
+ * If the block has no other owners, free it.
+ */
+STATIC int
+xfs_repair_free_or_unmap_extent(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		resv)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_btree_cur		*rmap_cur;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	bool				has_other_rmap;
+	int				error = 0;
+
+	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	for (; len > 0 && !error; len--, agbno++, fsbno++) {
+		ASSERT(sc->ip != NULL || agno == sc->sa.agno);
+
+		/* Can we find any other rmappings? */
+		if (sc->ip) {
+			error = xfs_alloc_read_agf(mp, sc->tp, agno, 0,
+					&agf_bp);
+			if (error)
+				break;
+		}
+		rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp,
+				agf_bp ? agf_bp : sc->sa.agf_bp, agno);
+		error = xfs_rmap_has_other_keys(rmap_cur, agbno, 1, oinfo,
+				&has_other_rmap);
+		if (error)
+			goto out_cur;
+		xfs_btree_del_cursor(rmap_cur, XFS_BTREE_NOERROR);
+		if (agf_bp)
+			xfs_trans_brelse(sc->tp, agf_bp);
+
+		/*
+		 * If there are other rmappings, this block is cross
+		 * linked and must not be freed.  Remove the reverse
+		 * mapping and move on.  Otherwise, we were the only
+		 * owner of the block, so free the extent, which will
+		 * also remove the rmap.
+		 */
+		if (has_other_rmap)
+			error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
+					oinfo);
+		else if (resv == XFS_AG_RESV_AGFL)
+			error = xfs_repair_put_freelist(sc, agbno);
+		else
+			error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+		if (error)
+			break;
+
+		if (sc->ip)
+			error = xfs_trans_roll(&sc->tp, sc->ip);
+		else
+			error = xfs_repair_roll_ag_trans(sc);
+	}
+
+	return error;
+out_cur:
+	xfs_btree_del_cursor(rmap_cur, XFS_BTREE_ERROR);
+	if (agf_bp)
+		xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+struct xfs_repair_btree_extent {
+	struct list_head		list;
+	xfs_fsblock_t			fsbno;
+	xfs_extlen_t			len;
+};
+
+/* Collect a dead btree extent for later disposal. */
+STATIC int
+xfs_repair_collect_btree_extent(
+	struct list_head		*btlist,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len)
+{
+	struct xfs_repair_btree_extent	*rbe;
+
+	rbe = kmem_alloc(sizeof(*rbe), KM_NOFS);
+	if (!rbe)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&rbe->list);
+	rbe->fsbno = fsbno;
+	rbe->len = len;
+	list_add_tail(&rbe->list, btlist);
+
+	return 0;
+}
+
+/* Dispose of dead btree extents.  If oinfo is NULL, just delete the list. */
+static int
+xfs_repair_reap_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*btlist,
+	struct xfs_owner_info		*oinfo,
+	enum xfs_ag_resv_type		type)
+{
+	struct xfs_repair_btree_extent	*rbe;
+	struct xfs_repair_btree_extent	*n;
+	int				error = 0;
+
+	list_for_each_entry_safe(rbe, n, btlist, list) {
+		if (oinfo) {
+			error = xfs_repair_free_or_unmap_extent(sc, rbe->fsbno,
+					rbe->len, oinfo, type);
+			if (error)
+				oinfo = NULL;
+		}
+		list_del(&rbe->list);
+		kmem_free(rbe);
+	}
+
+	return error;
+}
+
+/* Errors happened, just delete the dead btree extent list. */
+static inline void
+xfs_repair_cancel_btree_extents(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*btlist)
+{
+	xfs_repair_reap_btree_extents(sc, btlist, NULL, XFS_AG_RESV_NONE);
+}
+
+/* Compare two btree extents. */
+static int
+xfs_repair_btree_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_btree_extent	*ap;
+	struct xfs_repair_btree_extent	*bp;
+
+	ap = container_of(a, struct xfs_repair_btree_extent, list);
+	bp = container_of(b, struct xfs_repair_btree_extent, list);
+
+	if (ap->fsbno > bp->fsbno)
+		return 1;
+	else if (ap->fsbno < bp->fsbno)
+		return -1;
+	return 0;
+}
+
+/* Remove all the blocks in sublist from exlist. */
+STATIC int
+xfs_repair_subtract_extents(
+	struct xfs_mount		*mp,
+	struct list_head		*exlist,
+	struct list_head		*sublist)
+{
+	struct xfs_repair_btree_extent	*newrbe;
+	struct xfs_repair_btree_extent	*rbe;
+	struct xfs_repair_btree_extent	*n;
+	struct xfs_repair_btree_extent	*subp;
+	struct xfs_repair_btree_extent	sub;
+	xfs_fsblock_t			fsb;
+	xfs_fsblock_t			newfsb;
+	xfs_extlen_t			newlen;
+
+	list_sort(NULL, exlist, xfs_repair_btree_extent_cmp);
+	list_sort(NULL, sublist, xfs_repair_btree_extent_cmp);
+
+	subp = list_first_entry(sublist, struct xfs_repair_btree_extent, list);
+	if (subp == NULL)
+		return 0;
+
+	sub = *subp;
+	list_for_each_entry_safe(rbe, n, exlist, list) {
+		newfsb = NULLFSBLOCK;
+		newlen = 0;
+		for (fsb = rbe->fsbno; fsb < rbe->fsbno + rbe->len; fsb++) {
+			/*
+			 * If the current location of the extent list is
+			 * beyond the subtract list, move the subtract list
+			 * forward.
+			 */
+			while (fsb > sub.fsbno || sub.len == 0) {
+				if (sub.len) {
+					sub.len--;
+					sub.fsbno++;
+				} else {
+					subp = list_next_entry(subp, list);
+					if (subp == NULL) {
+						rbe->len -= fsb - rbe->fsbno;
+						rbe->fsbno = fsb;
+						goto out_frag;
+					}
+					sub = *subp;
+				}
+			}
+
+			if (fsb != sub.fsbno) {
+				/*
+				 * Block not in the subtract list; stash
+				 * it for later reinsertion in the list.
+				 */
+				if (newfsb == NULLFSBLOCK) {
+					newfsb = fsb;
+					newlen = 1;
+				} else
+					newlen++;
+			} else {
+				/* Match! */
+				if (newfsb != NULLFSBLOCK) {
+					/* Stash the new extent in the list. */
+					if (fsb == rbe->fsbno + rbe->len - 1) {
+						rbe->fsbno = newfsb;
+						rbe->len = newlen;
+						newfsb = NULLFSBLOCK;
+						rbe = NULL;
+						goto out_frag;
+					}
+					newrbe = kmem_alloc(sizeof(*newrbe),
+							KM_NOFS);
+					if (!newrbe)
+						return -ENOMEM;
+					INIT_LIST_HEAD(&newrbe->list);
+					newrbe->fsbno = newfsb;
+					newrbe->len = newlen;
+					list_add_tail(&newrbe->list,
+							&rbe->list);
+				}
+
+				newfsb = NULLFSBLOCK;
+				newlen = 0;
+			}
+		}
+
+out_frag:
+		/* If we have an extent to add back, do that now. */
+		if (newfsb != NULLFSBLOCK) {
+			newrbe = kmem_alloc(sizeof(*newrbe), KM_NOFS);
+			if (!newrbe)
+				return -ENOMEM;
+			INIT_LIST_HEAD(&newrbe->list);
+			newrbe->fsbno = newfsb;
+			newrbe->len = newlen;
+			list_add_tail(&newrbe->list, &rbe->list);
+		}
+		if (rbe) {
+			list_del(&rbe->list);
+			kmem_free(rbe);
+		}
+		if (subp == NULL)
+			break;
+	}
+
+	return 0;
+}
+
 /* Organize locking of multiple AGs for a scrub. */
 
 /* Initialize the AG lock handler. */
@@ -1531,6 +1974,85 @@ xfs_scrub_teardown(
 	return error;
 }
 
+/* Figure out how many blocks to reserve for an AG repair. */
+STATIC xfs_extlen_t
+xfs_scrub_calc_ag_resblks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_agi			*agi;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*bp;
+	xfs_agino_t			icount;
+	xfs_extlen_t			aglen;
+	xfs_extlen_t			usedlen;
+	xfs_extlen_t			freelen;
+	xfs_extlen_t			bnobt_sz;
+	xfs_extlen_t			inobt_sz;
+	xfs_extlen_t			rmapbt_sz;
+	xfs_extlen_t			refcbt_sz;
+	int				error;
+
+	if (!(sm->sm_flags & XFS_SCRUB_FLAG_REPAIR))
+		return 0;
+
+	if (sm->sm_agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+
+	/*
+	 * Try to get the actual counters from disk; if not, make
+	 * some worst case assumptions.
+	 */
+	error = xfs_read_agi(mp, NULL, sm->sm_agno, &bp);
+	if (!error) {
+		agi = XFS_BUF_TO_AGI(bp);
+		icount = be32_to_cpu(agi->agi_count);
+		xfs_trans_brelse(NULL, bp);
+	} else
+		icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
+
+	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
+	if (!error) {
+		agf = XFS_BUF_TO_AGF(bp);
+		aglen = be32_to_cpu(agf->agf_length);
+		freelen = be32_to_cpu(agf->agf_freeblks);
+		usedlen = aglen - freelen;
+		xfs_trans_brelse(NULL, bp);
+	} else {
+		aglen = mp->m_sb.sb_agblocks;
+		freelen = aglen;
+		usedlen = aglen;
+	}
+
+	/*
+	 * Figure out how many blocks we'd need worst case to rebuild
+	 * each type of btree.  Note that we can only rebuild the
+	 * bnobt/cntbt or inobt/finobt as pairs.
+	 */
+	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_HOLEMASK_BIT);
+	else
+		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
+				XFS_INODES_PER_CHUNK);
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		inobt_sz *= 2;
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
+		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
+	} else {
+		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
+		refcbt_sz = 0;
+	}
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		rmapbt_sz = 0;
+
+	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
+}
+
 /* Set us up with a transaction and an empty context. */
 STATIC int
 xfs_scrub_setup(

