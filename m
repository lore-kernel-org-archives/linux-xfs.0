Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951712837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995115; cv=none; b=AZBSO8PLN79KUZBQq57sk/i/prMA+ZyVciu4PoFPU7Jqz+Dwk1ZKOT/yBll7IN4zGB/nHGQUE0igDe7x27seowCSe1tZnjXyiTPbzXmaSDTmdyUjbicigkPpDl39Qhl1jbL0QaLOdH9A/NcFZlgtzAtTxAfaU7f2VUebCBV8vn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995115; c=relaxed/simple;
	bh=HYIjUETBuO28smF/EyXbY4+ftie+l1G8Ua8k6tot8s4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbOiZXRMPMbGs6B6iTbbxZLyVUgwacI6bI78Keh2fyKVa9qSalFMYaiIDW92Ul7KNleYnogvB7/U/UEO4A5bAOL3J+gHR30NS+8V9ifKgs4kcUUQAcEubC4+OfmjOvWapAAvXw9tj1rRIA32CRUdtfTsf0m+pQkEymESbyHOydk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuBacXYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuBacXYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692A6C4CED3;
	Mon, 23 Dec 2024 23:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995115;
	bh=HYIjUETBuO28smF/EyXbY4+ftie+l1G8Ua8k6tot8s4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tuBacXYWDLmWYYKChDY6UeDsJ0H3k4z9h7u5Hx9BBLiW3zx5VlMX0UPDvQcVXDOnJ
	 2C9is6ZSBRHoh50qOUGwSFvOKBjHbe4azhRVZ70MkOQ67ulbF/bPBOlaGUIKw0mCIF
	 nINieuTPMit5J4tBtFyQBiJ6B31mygu5i69fmTPNIuhHXztErreKj3C+DYYaVvU9GJ
	 tAOfnD68+Wek+InmbskccPHnVKdHBPgprZ/W8JfeuflnqL2fQB6rvZsfsacEuRey4c
	 WZJX8irfN5kHx9aNVLmN9h8C4ndsX/UWI0RV5LvcZz1qMnqQZRQbWqvfFyK1myDxxo
	 u4KyP+3np82Jg==
Date: Mon, 23 Dec 2024 15:05:14 -0800
Subject: [PATCH 33/37] xfs: create a shadow rmap btree during realtime rmap
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419287.2380130.204047964870765263.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree_mem.c    |    1 
 fs/xfs/libxfs/xfs_rmap.c         |    3 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  117 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    6 ++
 fs/xfs/libxfs/xfs_shared.h       |    7 ++
 fs/xfs/scrub/rtrmap_repair.c     |  137 ++++++++++++++++++++++++++------------
 fs/xfs/xfs_stats.c               |    3 +
 fs/xfs/xfs_stats.h               |    1 
 8 files changed, 228 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index df3d613675a15a..f2f7b4305413e9 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -18,6 +18,7 @@
 #include "xfs_ag.h"
 #include "xfs_buf_item.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /* Set the root of an in-memory btree. */
 void
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 2f0688a57991cc..f8415fd96cc2aa 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -327,7 +327,8 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (xfs_btree_is_rtrmap(cur->bc_ops))
+	if (xfs_btree_is_rtrmap(cur->bc_ops) ||
+	    xfs_btree_is_mem_rtrmap(cur->bc_ops))
 		return xfs_rtrmap_check_irec(to_rtg(cur->bc_group), irec);
 	return xfs_rmap_check_irec(to_perag(cur->bc_group), irec);
 }
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 6bf1b253c24746..b90901e39e92ce 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -28,6 +28,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
 #include "xfs_health.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -542,6 +544,121 @@ xfs_rtrmapbt_init_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
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
+	unsigned int		maxrecs;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
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
+	maxrecs = xfs_rtrmapbt_maxrecs(mp, XFBNO_BLOCKSIZE, level == 0);
+	return xfs_btree_memblock_verify(bp, maxrecs);
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
+const struct xfs_btree_ops xfs_rtrmapbt_mem_ops = {
+	.type			= XFS_BTREE_TYPE_MEM,
+	.geom_flags		= XFS_BTGEO_OVERLAPPING,
+
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_mem_2),
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
+	struct xfbtree		*xfbt)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
+			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+	cur->bc_mem.xfbtree = xfbt;
+	cur->bc_nlevels = xfbt->nlevels;
+	cur->bc_group = xfs_group_hold(rtg_group(rtg));
+	return cur;
+}
+
+/* Create an in-memory realtime rmap btree. */
+int
+xfs_rtrmapbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp,
+	xfs_rgnumber_t		rgno)
+{
+	xfbt->owner = rgno;
+	return xfbtree_init(mp, xfbt, btp, &xfs_rtrmapbt_mem_ops);
+}
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
 /*
  * Install a new rt reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index ad76ac7938b602..9d0915089891a5 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_ifakeroot;
 struct xfs_rtgroup;
+struct xfbtree;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
@@ -201,4 +202,9 @@ int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index da23dac22c3f08..960716c387cc2b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -57,6 +57,7 @@ extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
 extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
+extern const struct xfs_btree_ops xfs_rtrmapbt_mem_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -98,8 +99,14 @@ static inline bool xfs_btree_is_mem_rmap(const struct xfs_btree_ops *ops)
 {
 	return ops == &xfs_rmapbt_mem_ops;
 }
+
+static inline bool xfs_btree_is_mem_rtrmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rtrmapbt_mem_ops;
+}
 #else
 # define xfs_btree_is_mem_rmap(...)	(false)
+# define xfs_btree_is_mem_rtrmap(...)	(false)
 #endif
 
 static inline bool xfs_btree_is_rtrmap(const struct xfs_btree_ops *ops)
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 60e317725dea86..b376bcc8d1d2ed 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -12,6 +12,8 @@
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
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
+	struct xfbtree		rtrmap_btree;
 
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
+	error = xrep_setup_xfbtree(sc, descr);
+	kfree(descr);
+	if (error)
+		return error;
 
 	rr = kzalloc(sizeof(struct xrep_rtrmap), XCHK_GFP_FLAGS);
 	if (!rr)
@@ -135,11 +137,6 @@ xrep_rtrmap_stash(
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
@@ -148,6 +145,7 @@ xrep_rtrmap_stash(
 		.rm_flags	= flags,
 	};
 	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*mcur;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -155,8 +153,18 @@ xrep_rtrmap_stash(
 
 	trace_xrep_rtrmap_found(sc->mp, &rmap);
 
-	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
-	return xfarray_append(rr->rtrmap_records, &rre);
+	/* Add entry to in-memory btree. */
+	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, &rr->rtrmap_btree);
+	error = xfs_rmap_map_raw(mcur, &rmap);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	return xfbtree_trans_commit(&rr->rtrmap_btree, sc->tp);
+
+out_cancel:
+	xfbtree_trans_cancel(&rr->rtrmap_btree, sc->tp);
+	return error;
 }
 
 /* Finding all file and bmbt extents. */
@@ -395,6 +403,24 @@ xrep_rtrmap_scan_ag(
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
 /* Generate all the reverse-mappings for the realtime device. */
 STATIC int
 xrep_rtrmap_find_rmaps(
@@ -403,6 +429,7 @@ xrep_rtrmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_perag	*pag = NULL;
 	struct xfs_inode	*ip;
+	struct xfs_btree_cur	*mcur;
 	int			error;
 
 	/* Generate rmaps for the realtime superblock */
@@ -468,7 +495,19 @@ xrep_rtrmap_find_rmaps(
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
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, &rr->rtrmap_btree);
+	rr->nr_records = 0;
+	error = xfs_rmap_query_all(mcur, xrep_rtrmap_check_record, rr);
+	xfs_btree_del_cursor(mcur, error);
+
+	return error;
 }
 
 /* Building the new rtrmap btree. */
@@ -482,29 +521,25 @@ xrep_rtrmap_get_records(
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
@@ -549,7 +584,6 @@ xrep_rtrmap_build_new_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	struct xfs_btree_cur	*rmap_cur;
-	uint64_t		nr_records;
 	int			error;
 
 	/*
@@ -569,11 +603,9 @@ xrep_rtrmap_build_new_tree(
 	rmap_cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
 	xfs_btree_stage_ifakeroot(rmap_cur, &rr->new_btree.ifake);
 
-	nr_records = xfarray_length(rr->rtrmap_records);
-
 	/* Compute how many blocks we'll need for the rmaps collected. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records);
+			&rr->new_btree.bload, rr->nr_records);
 	if (error)
 		goto err_cur;
 
@@ -599,12 +631,20 @@ xrep_rtrmap_build_new_tree(
 	if (error)
 		goto err_cur;
 
+	/*
+	 * Create a cursor to the in-memory btree so that we can bulk load the
+	 * new btree.
+	 */
+	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, &rr->rtrmap_btree);
+	error = xfs_btree_goto_left_edge(rr->mcur);
+	if (error)
+		goto err_mcur;
+
 	/* Add all observed rmap records. */
 	rr->new_btree.ifake.if_fork->if_format = XFS_DINODE_FMT_META_BTREE;
-	rr->array_cur = XFARRAY_CURSOR_INIT;
 	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
 	if (error)
-		goto err_cur;
+		goto err_mcur;
 
 	/*
 	 * Install the new rtrmap btree in the inode.  After this point the old
@@ -614,6 +654,14 @@ xrep_rtrmap_build_new_tree(
 	xfs_rtrmapbt_commit_staged_btree(rmap_cur, sc->tp);
 	xrep_inode_set_nblocks(rr->sc, rr->new_btree.ifake.if_blocks);
 	xfs_btree_del_cursor(rmap_cur, 0);
+	xfs_btree_del_cursor(rr->mcur, 0);
+	rr->mcur = NULL;
+
+	/*
+	 * Now that we've written the new btree to disk, we don't need to keep
+	 * updating the in-memory btree.  Abort the scan to stop live updates.
+	 */
+	xchk_iscan_abort(&rr->iscan);
 
 	/* Dispose of any unused blocks and the accounting information. */
 	error = xrep_newbt_commit(&rr->new_btree);
@@ -622,6 +670,8 @@ xrep_rtrmap_build_new_tree(
 
 	return xrep_roll_trans(sc);
 
+err_mcur:
+	xfs_btree_del_cursor(rr->mcur, error);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 	xrep_newbt_cancel(&rr->new_btree);
@@ -658,16 +708,13 @@ xrep_rtrmap_setup_scan(
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
+	error = xfs_rtrmapbt_mem_init(sc->mp, &rr->rtrmap_btree, sc->xmbtp,
+			rtg_rgno(sc->sr.rtg));
 	if (error)
 		goto out_bitmap;
 
@@ -686,7 +733,7 @@ xrep_rtrmap_teardown(
 	struct xrep_rtrmap	*rr)
 {
 	xchk_iscan_teardown(&rr->iscan);
-	xfarray_destroy(rr->rtrmap_records);
+	xfbtree_destroy(&rr->rtrmap_btree);
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
 }
 
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f94fb70b524ffb..b7f2988bc03bb7 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -53,7 +53,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "refcntbt",		xfsstats_offset(xs_rmap_mem_2)	},
 		{ "rmapbt_mem",		xfsstats_offset(xs_rcbag_2)	},
 		{ "rcbagbt",		xfsstats_offset(xs_rtrmap_2)	},
-		{ "rtrmapbt",		xfsstats_offset(xs_qm_dqreclaims)},
+		{ "rtrmapbt",		xfsstats_offset(xs_rtrmap_mem_2)},
+		{ "rtrmapbt_mem",	xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 05dc69c6d94906..9c47de5dff2dd6 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -128,6 +128,7 @@ struct __xfsstats {
 	uint32_t		xs_rmap_mem_2[__XBTS_MAX];
 	uint32_t		xs_rcbag_2[__XBTS_MAX];
 	uint32_t		xs_rtrmap_2[__XBTS_MAX];
+	uint32_t		xs_rtrmap_mem_2[__XBTS_MAX];
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;

