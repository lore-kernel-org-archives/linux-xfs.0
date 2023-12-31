Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE51BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyTf8SQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEDAC433C8;
	Sun, 31 Dec 2023 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058887;
	bh=AGNibaqhcAEWJRh0rnewZY5wZq9a3+ScxyapTVUC4Xc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SyTf8SQ+6YG6s4IEsiZMdcAFHHUdI5Iv4B8Pjy0JHrZPlqOGnb+ENFqZiQCnoAzdC
	 xa8nTuWjnGMMNRohGfLM4zVtpUmg3WgDxbGZ9zpbLPr5Y5sk24bTIO+/9qcJ+R9a3j
	 IeBJSVNR6GwqW7m4AK0XuA7CIXT5iB2VfK5TvA8E4ofFWxlCE82iVug5dYLSKhCgXe
	 qJB7u5zCfj8Zp7bqfyiUIZRLYyUBp2PXKvQf49dBbUXP7vs/k3RImXQnYvpp9RLwz/
	 9pjoGP3jzChS3O11GXCuG/O1uMApyGkOvad9jY3QMjzBJ3EULDDp6s9BIeDsEseWHz
	 9Ksf9h04tjTWA==
Date: Sun, 31 Dec 2023 13:41:26 -0800
Subject: [PATCH 37/39] xfs: create a shadow rmap btree during realtime rmap
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850496.1764998.9469664524257812727.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c        |    2 
 fs/xfs/libxfs/xfs_btree.h        |    1 
 fs/xfs/libxfs/xfs_rmap.c         |    5 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  123 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    9 ++
 fs/xfs/scrub/rtrmap_repair.c     |  158 +++++++++++++++++++++++++++-----------
 fs/xfs/scrub/xfbtree.c           |    3 +
 7 files changed, 255 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a294641d91832..2a181cf30299f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -491,6 +491,8 @@ xfs_btree_del_cursor(
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
 		if (cur->bc_mem.pag)
 			xfs_perag_put(cur->bc_mem.pag);
+		if (cur->bc_mem.rtg)
+			xfs_rtgroup_put(cur->bc_mem.rtg);
 	}
 	kmem_cache_free(cur->bc_cache, cur);
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3559cf5d3a653..4753a5c847616 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -269,6 +269,7 @@ struct xfs_btree_cur_mem {
 	struct xfbtree			*xfbtree;
 	struct xfs_buf			*head_bp;
 	struct xfs_perag		*pag;
+	struct xfs_rtgroup		*rtg;
 };
 
 struct xfs_btree_level {
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8766805ed1343..d100e03f9560f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -329,8 +329,11 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP) {
+		if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+			return xfs_rtrmap_check_irec(cur->bc_mem.rtg, irec);
 		return xfs_rtrmap_check_irec(cur->bc_ino.rtg, irec);
+	}
 
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
 		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 51a8ffff1c755..3084153af3a43 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -28,6 +28,9 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -557,6 +560,126 @@ xfs_rtrmapbt_stage_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+/*
+ * Validate an in-memory realtime rmap btree block.  Callers are allowed to
+ * generate an in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rtrmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (xfs_has_rmapbt(mp)) {
+		if (level >= mp->m_rtrmap_maxlevels)
+			return __this_address;
+	} else {
+		if (level >= xfs_rtrmapbt_maxlevels_ondisk())
+			return __this_address;
+	}
+
+	return xfbtree_lblock_verify(bp,
+			xfs_rtrmapbt_maxrecs(mp, xfo_to_b(1), level == 0));
+}
+
+static void
+xfs_rtrmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rtrmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rtrmapbt_mem_buf_ops = {
+	.name			= "xfs_rtrmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RTRMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_write		= xfs_rtrmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rtrmapbt_mem_verify,
+};
+
+static const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_LONG_PTRS | XFS_BTREE_IN_XFILE,
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rtrmapbt_key_diff,
+	.buf_ops		= &xfs_rtrmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
+	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_mem_cursor(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*head_bp,
+	struct xfbtree		*xfbtree)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = rtg->rtg_mount;
+
+	/* Overlapping btree; 2 keys per pointer. */
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RTRMAP,
+			&xfs_rtrmapbt_mem_ops, mp->m_rtrmap_maxlevels,
+			xfs_rtrmapbt_cur_cache);
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_mem.xfbtree = xfbtree;
+	cur->bc_mem.head_bp = head_bp;
+	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+
+	cur->bc_mem.rtg = xfs_rtgroup_hold(rtg);
+	return cur;
+}
+
+int
+xfs_rtrmapbt_mem_create(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_buftarg	*target,
+	struct xfbtree		**xfbtreep)
+{
+	struct xfbtree_config	cfg = {
+		.btree_ops	= &xfs_rtrmapbt_mem_ops,
+		.target		= target,
+		.flags		= XFBTREE_DIRECT_MAP,
+		.owner		= rgno,
+	};
+
+	return xfbtree_create(mp, &cfg, xfbtreep);
+}
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
 /*
  * Install a new rt reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 5aec719be053f..b0a8e8d89f9eb 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -205,4 +205,13 @@ int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
 unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+struct xfbtree;
+struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp, struct xfs_buf *mhead_bp,
+		struct xfbtree *xfbtree);
+int xfs_rtrmapbt_mem_create(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index c56558ce919ab..00e606dfc6842 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -12,6 +12,7 @@
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_btree_mem.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
@@ -41,6 +42,7 @@
 #include "scrub/iscan.h"
 #include "scrub/newbt.h"
 #include "scrub/reap.h"
+#include "scrub/xfbtree.h"
 
 /*
  * Realtime Reverse Mapping Btree Repair
@@ -64,24 +66,13 @@
  * We use the 'xrep_rtrmap' prefix for all the rmap functions.
  */
 
-/*
- * Packed rmap record.  The UNWRITTEN flags are hidden in the upper bits of
- * offset, just like the on-disk record.
- */
-struct xrep_rtrmap_extent {
-	xfs_rgblock_t	startblock;
-	xfs_extlen_t	blockcount;
-	uint64_t	owner;
-	uint64_t	offset;
-} __packed;
-
 /* Context for collecting rmaps */
 struct xrep_rtrmap {
 	/* new rtrmapbt information */
 	struct xrep_newbt	new_btree;
 
 	/* rmap records generated from primary metadata */
-	struct xfarray		*rtrmap_records;
+	struct xfbtree		*rtrmap_btree;
 
 	struct xfs_scrub	*sc;
 
@@ -91,8 +82,11 @@ struct xrep_rtrmap {
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
-	/* get_records()'s position in the free space record array. */
-	xfarray_idx_t		array_cur;
+	/* in-memory btree cursor for the ->get_blocks walk */
+	struct xfs_btree_cur	*mcur;
+
+	/* Number of records we're staging in the new btree. */
+	uint64_t		nr_records;
 };
 
 /* Set us up to repair rt reverse mapping btrees. */
@@ -101,6 +95,14 @@ xrep_setup_rtrmapbt(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_rtrmap	*rr;
+	char			*descr;
+	int			error;
+
+	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
+	error = xrep_setup_buftarg(sc, descr);
+	kfree(descr);
+	if (error)
+		return error;
 
 	rr = kzalloc(sizeof(struct xrep_rtrmap), XCHK_GFP_FLAGS);
 	if (!rr)
@@ -138,11 +140,6 @@ xrep_rtrmap_stash(
 	uint64_t		offset,
 	unsigned int		flags)
 {
-	struct xrep_rtrmap_extent	rre = {
-		.startblock	= startblock,
-		.blockcount	= blockcount,
-		.owner		= owner,
-	};
 	struct xfs_rmap_irec	rmap = {
 		.rm_startblock	= startblock,
 		.rm_blockcount	= blockcount,
@@ -151,6 +148,8 @@ xrep_rtrmap_stash(
 		.rm_flags	= flags,
 	};
 	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*mcur;
+	struct xfs_buf		*mhead_bp;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -158,8 +157,23 @@ xrep_rtrmap_stash(
 
 	trace_xrep_rtrmap_found(sc->mp, &rmap);
 
-	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
-	return xfarray_append(rr->rtrmap_records, &rre);
+	/* Add entry to in-memory btree. */
+	error = xfbtree_head_read_buf(rr->rtrmap_btree, sc->tp, &mhead_bp);
+	if (error)
+		return error;
+
+	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, mhead_bp,
+			rr->rtrmap_btree);
+	error = xfs_rmap_map_raw(mcur, &rmap);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	return xfbtree_trans_commit(rr->rtrmap_btree, sc->tp);
+
+out_cancel:
+	xfbtree_trans_cancel(rr->rtrmap_btree, sc->tp);
+	return error;
 }
 
 /* Finding all file and bmbt extents. */
@@ -402,6 +416,24 @@ xrep_rtrmap_scan_ag(
 	return error;
 }
 
+/* Count and check all collected records. */
+STATIC int
+xrep_rtrmap_check_record(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rtrmap		*rr = priv;
+	int				error;
+
+	error = xrep_rtrmap_check_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	rr->nr_records++;
+	return 0;
+}
+
 STATIC int
 xrep_rtrmap_find_super_rmaps(
 	struct xrep_rtrmap	*rr)
@@ -421,6 +453,8 @@ xrep_rtrmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_perag	*pag;
 	struct xfs_inode	*ip;
+	struct xfs_buf		*mhead_bp;
+	struct xfs_btree_cur	*mcur;
 	xfs_agnumber_t		agno;
 	int			error;
 
@@ -484,7 +518,25 @@ xrep_rtrmap_find_rmaps(
 		}
 	}
 
-	return 0;
+	/*
+	 * Now that we have everything locked again, we need to count the
+	 * number of rmap records stashed in the btree.  This should reflect
+	 * all actively-owned rt files in the filesystem.  At the same time,
+	 * check all our records before we start building a new btree, which
+	 * requires the rtbitmap lock.
+	 */
+	error = xfbtree_head_read_buf(rr->rtrmap_btree, NULL, &mhead_bp);
+	if (error)
+		return error;
+
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, mhead_bp,
+			rr->rtrmap_btree);
+	rr->nr_records = 0;
+	error = xfs_rmap_query_all(mcur, xrep_rtrmap_check_record, rr);
+	xfs_btree_del_cursor(mcur, error);
+	xfs_buf_relse(mhead_bp);
+
+	return error;
 }
 
 /* Building the new rtrmap btree. */
@@ -498,29 +550,25 @@ xrep_rtrmap_get_records(
 	unsigned int			nr_wanted,
 	void				*priv)
 {
-	struct xrep_rtrmap_extent	rec;
-	struct xfs_rmap_irec		*irec = &cur->bc_rec.r;
 	struct xrep_rtrmap		*rr = priv;
 	union xfs_btree_rec		*block_rec;
 	unsigned int			loaded;
 	int				error;
 
 	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
-		error = xfarray_load_next(rr->rtrmap_records, &rr->array_cur,
-				&rec);
+		int			stat = 0;
+
+		error = xfs_btree_increment(rr->mcur, 0, &stat);
 		if (error)
 			return error;
-
-		irec->rm_startblock = rec.startblock;
-		irec->rm_blockcount = rec.blockcount;
-		irec->rm_owner = rec.owner;
-
-		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+		if (!stat)
 			return -EFSCORRUPTED;
 
-		error = xrep_rtrmap_check_mapping(rr->sc, irec);
+		error = xfs_rmap_get_rec(rr->mcur, &cur->bc_rec.r, &stat);
 		if (error)
 			return error;
+		if (!stat)
+			return -EFSCORRUPTED;
 
 		block_rec = xfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -565,7 +613,7 @@ xrep_rtrmap_build_new_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	struct xfs_btree_cur	*rmap_cur;
-	uint64_t		nr_records;
+	struct xfs_buf		*mhead_bp;
 	int			error;
 
 	/*
@@ -585,11 +633,9 @@ xrep_rtrmap_build_new_tree(
 	rmap_cur = xfs_rtrmapbt_stage_cursor(sc->mp, rtg, rtg->rtg_rmapip,
 			&rr->new_btree.ifake);
 
-	nr_records = xfarray_length(rr->rtrmap_records);
-
 	/* Compute how many blocks we'll need for the rmaps collected. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records);
+			&rr->new_btree.bload, rr->nr_records);
 	if (error)
 		goto err_cur;
 
@@ -615,12 +661,25 @@ xrep_rtrmap_build_new_tree(
 	if (error)
 		goto err_cur;
 
+	/*
+	 * Create a cursor to the in-memory btree so that we can bulk load the
+	 * new btree.
+	 */
+	error = xfbtree_head_read_buf(rr->rtrmap_btree, NULL, &mhead_bp);
+	if (error)
+		goto err_cur;
+
+	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, mhead_bp,
+			rr->rtrmap_btree);
+	error = xfs_btree_goto_left_edge(rr->mcur);
+	if (error)
+		goto err_mcur;
+
 	/* Add all observed rmap records. */
 	rr->new_btree.ifake.if_fork->if_format = XFS_DINODE_FMT_RMAP;
-	rr->array_cur = XFARRAY_CURSOR_INIT;
 	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
 	if (error)
-		goto err_cur;
+		goto err_mcur;
 
 	/*
 	 * Install the new rtrmap btree in the inode.  After this point the old
@@ -630,6 +689,15 @@ xrep_rtrmap_build_new_tree(
 	xfs_rtrmapbt_commit_staged_btree(rmap_cur, sc->tp);
 	xrep_inode_set_nblocks(rr->sc, rr->new_btree.ifake.if_blocks);
 	xfs_btree_del_cursor(rmap_cur, 0);
+	xfs_btree_del_cursor(rr->mcur, 0);
+	rr->mcur = NULL;
+	xfs_buf_relse(mhead_bp);
+
+	/*
+	 * Now that we've written the new btree to disk, we don't need to keep
+	 * updating the in-memory btree.  Abort the scan to stop live updates.
+	 */
+	xchk_iscan_abort(&rr->iscan);
 
 	/* Dispose of any unused blocks and the accounting information. */
 	error = xrep_newbt_commit(&rr->new_btree);
@@ -638,6 +706,9 @@ xrep_rtrmap_build_new_tree(
 
 	return xrep_roll_trans(sc);
 
+err_mcur:
+	xfs_btree_del_cursor(rr->mcur, error);
+	xfs_buf_relse(mhead_bp);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 	xrep_newbt_cancel(&rr->new_btree);
@@ -674,16 +745,13 @@ xrep_rtrmap_setup_scan(
 	struct xrep_rtrmap	*rr)
 {
 	struct xfs_scrub	*sc = rr->sc;
-	char			*descr;
 	int			error;
 
 	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
 
 	/* Set up some storage */
-	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_rtrmap_extent),
-			&rr->rtrmap_records);
-	kfree(descr);
+	error = xfs_rtrmapbt_mem_create(sc->mp, sc->sr.rtg->rtg_rgno,
+			sc->xfile_buftarg, &rr->rtrmap_btree);
 	if (error)
 		goto out_bitmap;
 
@@ -702,7 +770,7 @@ xrep_rtrmap_teardown(
 	struct xrep_rtrmap	*rr)
 {
 	xchk_iscan_teardown(&rr->iscan);
-	xfarray_destroy(rr->rtrmap_records);
+	xfbtree_destroy(rr->rtrmap_btree);
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
 }
 
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 9e557d87d1c9c..7c035ad1f696a 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -17,6 +17,7 @@
 #include "xfs_error.h"
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
@@ -298,6 +299,8 @@ xfbtree_dup_cursor(
 
 	if (cur->bc_mem.pag)
 		ncur->bc_mem.pag = xfs_perag_hold(cur->bc_mem.pag);
+	if (cur->bc_mem.rtg)
+		ncur->bc_mem.rtg = xfs_rtgroup_hold(cur->bc_mem.rtg);
 
 	return ncur;
 }

