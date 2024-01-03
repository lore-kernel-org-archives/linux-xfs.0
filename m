Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1EF1D541
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 20:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jdtB8M4G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XwJ9L9WM1oHET6UYYv12pzKKUT6zcVt7qCKmESz2NUA=; b=jdtB8M4GsyCZYx+mWVMZoq+gkJ
	UvR84DqSuErY90ovRUw99kzeMo84IVJy4WN8DPrauMy/yL6f5U5tX6fijx8+phMjpQlz5QUx/mRja
	WaVI1n4bwkUM79XZLd/VazdDOYS5PZSXbmdgI8HO+sybjLtyptyuFiTxBFClMS80WjNT5tW1Ov38P
	982nKvuHM3t2jvGZGHsE8xp41XYx+gsbvxUGMbz2UDN/h0UvZU2LRbiwHctJrGmMaqIlRVK6wKLtn
	g4LVk1JyzEmMa0PSgIByD5jXe+UBEQ2IEw+hmO8h00HiJWmf6anHQ1KjqRHIXRHvgMPQ41/hICP2J
	KlJgBfWw==;
Received: from [89.144.223.119] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rL80m-00C4ST-1R;
	Wed, 03 Jan 2024 20:38:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: remove the in-memory btree header block
Date: Wed,  3 Jan 2024 21:38:32 +0100
Message-Id: <20240103203836.608391-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103203836.608391-1-hch@lst.de>
References: <20240103203836.608391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no need to allocate a whole block (aka page) for the fake btree
on-disk header as we can just stash away the nleves and root block in the
xfbtree structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.h        |   1 -
 fs/xfs/libxfs/xfs_btree_mem.h    |   7 --
 fs/xfs/libxfs/xfs_rmap_btree.c   |   4 +-
 fs/xfs/libxfs/xfs_rmap_btree.h   |   3 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   4 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   3 +-
 fs/xfs/scrub/rcbag.c             |  35 +-----
 fs/xfs/scrub/rcbag_btree.c       |   4 +-
 fs/xfs/scrub/rcbag_btree.h       |   3 +-
 fs/xfs/scrub/rmap_repair.c       |  41 +------
 fs/xfs/scrub/rtrmap_repair.c     |  35 +-----
 fs/xfs/scrub/xfbtree.c           | 188 ++-----------------------------
 fs/xfs/scrub/xfbtree.h           |  24 +---
 13 files changed, 35 insertions(+), 317 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 64e37a0ffb78ea..503f51ef22f81e 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -271,7 +271,6 @@ struct xfbtree;
 
 struct xfs_btree_cur_mem {
 	struct xfbtree			*xfbtree;
-	struct xfs_buf			*head_bp;
 	struct xfs_perag		*pag;
 	struct xfs_rtgroup		*rtg;
 };
diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index cfb30cb1aabc69..eeb3340a22d201 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -26,8 +26,6 @@ struct xfbtree_config {
 #define XFBTREE_DIRECT_MAP		(1U << 0)
 
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
-unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
-
 struct xfs_buftarg *xfbtree_target(struct xfbtree *xfbtree);
 int xfbtree_check_ptr(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, int index, int level);
@@ -63,11 +61,6 @@ int xfbtree_alloc_block(struct xfs_btree_cur *cur,
 		int *stat);
 int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 #else
-static inline unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp)
-{
-	return 0;
-}
-
 static inline struct xfs_buftarg *
 xfbtree_target(struct xfbtree *xfbtree)
 {
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 71887cc23e03f1..41f1b5fa863302 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -641,7 +641,6 @@ struct xfs_btree_cur *
 xfs_rmapbt_mem_cursor(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*head_bp,
 	struct xfbtree		*xfbtree)
 {
 	struct xfs_btree_cur	*cur;
@@ -653,8 +652,7 @@ xfs_rmapbt_mem_cursor(
 			xfs_rmapbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_mem.xfbtree = xfbtree;
-	cur->bc_mem.head_bp = head_bp;
-	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+	cur->bc_nlevels = xfbtree->nlevels;
 
 	cur->bc_mem.pag = xfs_perag_hold(pag);
 	return cur;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 415fad8dad73ed..dfe13b8cbb732d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -68,8 +68,7 @@ void xfs_rmapbt_destroy_cur_cache(void);
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 struct xfbtree;
 struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
-		struct xfs_trans *tp, struct xfs_buf *head_bp,
-		struct xfbtree *xfbtree);
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int xfs_rmapbt_mem_create(struct xfs_mount *mp, xfs_agnumber_t agno,
 		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 87ea5e3ca89375..3b105e2da8468d 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -643,7 +643,6 @@ struct xfs_btree_cur *
 xfs_rtrmapbt_mem_cursor(
 	struct xfs_rtgroup	*rtg,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*head_bp,
 	struct xfbtree		*xfbtree)
 {
 	struct xfs_btree_cur	*cur;
@@ -655,8 +654,7 @@ xfs_rtrmapbt_mem_cursor(
 			xfs_rtrmapbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_mem.xfbtree = xfbtree;
-	cur->bc_mem.head_bp = head_bp;
-	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+	cur->bc_nlevels = xfbtree->nlevels;
 
 	cur->bc_mem.rtg = xfs_rtgroup_hold(rtg);
 	return cur;
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index b0a8e8d89f9eb4..3347205846eb2e 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -208,8 +208,7 @@ unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 struct xfbtree;
 struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
-		struct xfs_trans *tp, struct xfs_buf *mhead_bp,
-		struct xfbtree *xfbtree);
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int xfs_rtrmapbt_mem_create(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index 63f1b6e6488e15..f28ce02f961c7c 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -76,16 +76,11 @@ rcbag_add(
 {
 	struct rcbag_rec		bagrec;
 	struct xfs_mount		*mp = bag->mp;
-	struct xfs_buf			*head_bp;
 	struct xfs_btree_cur		*cur;
 	int				has;
 	int				error;
 
-	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
-	if (error)
-		return error;
-
-	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
 	error = rcbagbt_lookup_eq(cur, rmap, &has);
 	if (error)
 		goto out_cur;
@@ -118,7 +113,6 @@ rcbag_add(
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-	xfs_trans_brelse(tp, head_bp);
 
 	error = xfbtree_trans_commit(bag->xfbtree, tp);
 	if (error)
@@ -129,7 +123,6 @@ rcbag_add(
 
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, head_bp);
 	xfbtree_trans_cancel(bag->xfbtree, tp);
 	return error;
 }
@@ -157,7 +150,6 @@ rcbag_next_edge(
 {
 	struct rcbag_rec		bagrec;
 	struct xfs_mount		*mp = bag->mp;
-	struct xfs_buf			*head_bp;
 	struct xfs_btree_cur		*cur;
 	uint32_t			next_bno = NULLAGBLOCK;
 	int				has;
@@ -166,11 +158,7 @@ rcbag_next_edge(
 	if (next_valid)
 		next_bno = next_rmap->rm_startblock;
 
-	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
-	if (error)
-		return error;
-
-	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
 	error = xfs_btree_goto_left_edge(cur);
 	if (error)
 		goto out_cur;
@@ -205,14 +193,12 @@ rcbag_next_edge(
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-	xfs_trans_brelse(tp, head_bp);
 
 	*next_bnop = next_bno;
 	return 0;
 
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, head_bp);
 	return error;
 }
 
@@ -225,17 +211,12 @@ rcbag_remove_ending_at(
 {
 	struct rcbag_rec	bagrec;
 	struct xfs_mount	*mp = bag->mp;
-	struct xfs_buf		*head_bp;
 	struct xfs_btree_cur	*cur;
 	int			has;
 	int			error;
 
-	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
-	if (error)
-		return error;
-
 	/* go to the right edge of the tree */
-	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
 	memset(&cur->bc_rec, 0xFF, sizeof(cur->bc_rec));
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, &has);
 	if (error)
@@ -271,11 +252,9 @@ rcbag_remove_ending_at(
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-	xfs_trans_brelse(tp, head_bp);
 	return xfbtree_trans_commit(bag->xfbtree, tp);
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, head_bp);
 	xfbtree_trans_cancel(bag->xfbtree, tp);
 	return error;
 }
@@ -288,17 +267,12 @@ rcbag_dump(
 {
 	struct rcbag_rec		bagrec;
 	struct xfs_mount		*mp = bag->mp;
-	struct xfs_buf			*head_bp;
 	struct xfs_btree_cur		*cur;
 	unsigned long long		nr = 0;
 	int				has;
 	int				error;
 
-	error = xfbtree_head_read_buf(bag->xfbtree, tp, &head_bp);
-	if (error)
-		return;
-
-	cur = rcbagbt_mem_cursor(mp, tp, head_bp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
 	error = xfs_btree_goto_left_edge(cur);
 	if (error)
 		goto out_cur;
@@ -327,5 +301,4 @@ rcbag_dump(
 
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfs_trans_brelse(tp, head_bp);
 }
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 9807e08129fe4a..6f0b48b5c37bbd 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -209,7 +209,6 @@ struct xfs_btree_cur *
 rcbagbt_mem_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*head_bp,
 	struct xfbtree		*xfbtree)
 {
 	struct xfs_btree_cur	*cur;
@@ -218,8 +217,7 @@ rcbagbt_mem_cursor(
 			rcbagbt_maxlevels_possible(), rcbagbt_cur_cache);
 
 	cur->bc_mem.xfbtree = xfbtree;
-	cur->bc_mem.head_bp = head_bp;
-	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
+	cur->bc_nlevels = xfbtree->nlevels;
 	return cur;
 }
 
diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
index 6486b6ae534096..59d81d707d32a5 100644
--- a/fs/xfs/scrub/rcbag_btree.h
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -63,8 +63,7 @@ void rcbagbt_destroy_cur_cache(void);
 
 struct xfbtree;
 struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
-		struct xfs_trans *tp, struct xfs_buf *head_bp,
-		struct xfbtree *xfbtree);
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int rcbagbt_mem_create(struct xfs_mount *mp, struct xfs_buftarg *target,
 		struct xfbtree **xfbtreep);
 
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 0f3783aaaa9974..ab61f31868f841 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -226,7 +226,6 @@ xrep_rmap_stash(
 	};
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_btree_cur	*mcur;
-	struct xfs_buf		*mhead_bp;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -238,12 +237,7 @@ xrep_rmap_stash(
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
 	mutex_lock(&rr->lock);
-	error = xfbtree_head_read_buf(rr->rmap_btree, sc->tp, &mhead_bp);
-	if (error)
-		goto out_abort;
-
-	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, mhead_bp,
-			rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, rr->rmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
@@ -924,7 +918,6 @@ xrep_rmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xchk_ag		*sa = &sc->sa;
 	struct xfs_inode	*ip;
-	struct xfs_buf		*mhead_bp;
 	struct xfs_btree_cur	*mcur;
 	int			error;
 
@@ -1011,12 +1004,7 @@ xrep_rmap_find_rmaps(
 	 * all our records before we start building a new btree, which requires
 	 * a bnobt cursor.
 	 */
-	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
-	if (error)
-		return error;
-
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
-			rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
 	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag, XFS_BTNUM_BNO);
 
@@ -1026,7 +1014,6 @@ xrep_rmap_find_rmaps(
 	xfs_btree_del_cursor(sc->sa.bno_cur, error);
 	sc->sa.bno_cur = NULL;
 	xfs_btree_del_cursor(mcur, error);
-	xfs_buf_relse(mhead_bp);
 
 	return error;
 }
@@ -1364,7 +1351,6 @@ xrep_rmap_build_new_tree(
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_btree_cur	*rmap_cur;
-	struct xfs_buf		*mhead_bp;
 	xfs_fsblock_t		fsbno;
 	int			error;
 
@@ -1403,12 +1389,7 @@ xrep_rmap_build_new_tree(
 	 * Count the rmapbt records again, because the space reservation
 	 * for the rmapbt itself probably added more records to the btree.
 	 */
-	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
-	if (error)
-		goto err_cur;
-
-	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
-			rr->rmap_btree);
+	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
 
 	error = xrep_rmap_count_records(rr->mcur, &rr->nr_records);
 	if (error)
@@ -1444,7 +1425,6 @@ xrep_rmap_build_new_tree(
 	xfs_btree_del_cursor(rmap_cur, 0);
 	xfs_btree_del_cursor(rr->mcur, 0);
 	rr->mcur = NULL;
-	xfs_buf_relse(mhead_bp);
 
 	/*
 	 * Now that we've written the new btree to disk, we don't need to keep
@@ -1476,7 +1456,6 @@ xrep_rmap_build_new_tree(
 	pag->pagf_repair_levels[XFS_BTNUM_RMAPi] = 0;
 err_mcur:
 	xfs_btree_del_cursor(rr->mcur, error);
-	xfs_buf_relse(mhead_bp);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 err_newbt:
@@ -1543,20 +1522,16 @@ xrep_rmap_remove_old_tree(
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_btree_cur	*mcur;
-	struct xfs_buf		*mhead_bp;
 	xfs_agblock_t		agend;
 	int			error;
 
 	xagb_bitmap_init(&rfg.rmap_gaps);
 
 	/* Compute free space from the new rmapbt. */
-	error = xfbtree_head_read_buf(rr->rmap_btree, NULL, &mhead_bp);
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, mhead_bp,
-			rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
 
 	error = xfs_rmap_query_all(mcur, xrep_rmap_find_gaps, &rfg);
 	xfs_btree_del_cursor(mcur, error);
-	xfs_buf_relse(mhead_bp);
 	if (error)
 		goto out_bitmap;
 
@@ -1646,7 +1621,6 @@ xrep_rmapbt_live_update(
 	struct xrep_rmap		*rr;
 	struct xfs_mount		*mp;
 	struct xfs_btree_cur		*mcur;
-	struct xfs_buf			*mhead_bp;
 	struct xfs_trans		*tp;
 	void				*txcookie;
 	int				error;
@@ -1664,12 +1638,7 @@ xrep_rmapbt_live_update(
 		goto out_abort;
 
 	mutex_lock(&rr->lock);
-	error = xfbtree_head_read_buf(rr->rmap_btree, tp, &mhead_bp);
-	if (error)
-		goto out_cancel;
-
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, mhead_bp,
-			rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, rr->rmap_btree);
 	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
 			p->blockcount, &p->oinfo, p->unwritten);
 	xfs_btree_del_cursor(mcur, error);
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index c29e3982830183..885752c7436b45 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -159,7 +159,6 @@ xrep_rtrmap_stash(
 	};
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_btree_cur	*mcur;
-	struct xfs_buf		*mhead_bp;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -172,12 +171,7 @@ xrep_rtrmap_stash(
 
 	/* Add entry to in-memory btree. */
 	mutex_lock(&rr->lock);
-	error = xfbtree_head_read_buf(rr->rtrmap_btree, sc->tp, &mhead_bp);
-	if (error)
-		goto out_abort;
-
-	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, mhead_bp,
-			rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, rr->rtrmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
@@ -569,7 +563,6 @@ xrep_rtrmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_perag	*pag;
 	struct xfs_inode	*ip;
-	struct xfs_buf		*mhead_bp;
 	struct xfs_btree_cur	*mcur;
 	xfs_agnumber_t		agno;
 	int			error;
@@ -655,16 +648,10 @@ xrep_rtrmap_find_rmaps(
 	 * check all our records before we start building a new btree, which
 	 * requires the rtbitmap lock.
 	 */
-	error = xfbtree_head_read_buf(rr->rtrmap_btree, NULL, &mhead_bp);
-	if (error)
-		return error;
-
-	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, mhead_bp,
-			rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, rr->rtrmap_btree);
 	rr->nr_records = 0;
 	error = xfs_rmap_query_all(mcur, xrep_rtrmap_check_record, rr);
 	xfs_btree_del_cursor(mcur, error);
-	xfs_buf_relse(mhead_bp);
 
 	return error;
 }
@@ -743,7 +730,6 @@ xrep_rtrmap_build_new_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	struct xfs_btree_cur	*rmap_cur;
-	struct xfs_buf		*mhead_bp;
 	int			error;
 
 	/*
@@ -795,12 +781,7 @@ xrep_rtrmap_build_new_tree(
 	 * Create a cursor to the in-memory btree so that we can bulk load the
 	 * new btree.
 	 */
-	error = xfbtree_head_read_buf(rr->rtrmap_btree, NULL, &mhead_bp);
-	if (error)
-		goto err_cur;
-
-	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, mhead_bp,
-			rr->rtrmap_btree);
+	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, rr->rtrmap_btree);
 	error = xfs_btree_goto_left_edge(rr->mcur);
 	if (error)
 		goto err_mcur;
@@ -821,7 +802,6 @@ xrep_rtrmap_build_new_tree(
 	xfs_btree_del_cursor(rmap_cur, 0);
 	xfs_btree_del_cursor(rr->mcur, 0);
 	rr->mcur = NULL;
-	xfs_buf_relse(mhead_bp);
 
 	/*
 	 * Now that we've written the new btree to disk, we don't need to keep
@@ -838,7 +818,6 @@ xrep_rtrmap_build_new_tree(
 
 err_mcur:
 	xfs_btree_del_cursor(rr->mcur, error);
-	xfs_buf_relse(mhead_bp);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 	xrep_newbt_cancel(&rr->new_btree);
@@ -904,7 +883,6 @@ xrep_rtrmapbt_live_update(
 	struct xrep_rtrmap		*rr;
 	struct xfs_mount		*mp;
 	struct xfs_btree_cur		*mcur;
-	struct xfs_buf			*mhead_bp;
 	struct xfs_trans		*tp;
 	void				*txcookie;
 	int				error;
@@ -922,12 +900,7 @@ xrep_rtrmapbt_live_update(
 		goto out_abort;
 
 	mutex_lock(&rr->lock);
-	error = xfbtree_head_read_buf(rr->rtrmap_btree, tp, &mhead_bp);
-	if (error)
-		goto out_cancel;
-
-	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, mhead_bp,
-			rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, rr->rtrmap_btree);
 	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
 			p->blockcount, &p->oinfo, p->unwritten);
 	xfs_btree_del_cursor(mcur, error);
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 7c035ad1f696ac..3620acc008aa59 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -55,83 +55,6 @@ static inline int xfboff_bitmap_take_first_set(struct xfboff_bitmap *bitmap,
 	return 0;
 }
 
-/* btree ops functions for in-memory btrees. */
-
-static xfs_failaddr_t
-xfs_btree_mem_head_verify(
-	struct xfs_buf			*bp)
-{
-	struct xfs_btree_mem_head	*mhead = bp->b_addr;
-	struct xfs_mount		*mp = bp->b_mount;
-
-	if (!xfs_verify_magic(bp, mhead->mh_magic))
-		return __this_address;
-	if (be32_to_cpu(mhead->mh_nlevels) == 0)
-		return __this_address;
-	if (!uuid_equal(&mhead->mh_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
-
-	return NULL;
-}
-
-static void
-xfs_btree_mem_head_read_verify(
-	struct xfs_buf		*bp)
-{
-	xfs_failaddr_t		fa = xfs_btree_mem_head_verify(bp);
-
-	if (fa)
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
-}
-
-static void
-xfs_btree_mem_head_write_verify(
-	struct xfs_buf		*bp)
-{
-	xfs_failaddr_t		fa = xfs_btree_mem_head_verify(bp);
-
-	if (fa)
-		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
-}
-
-static const struct xfs_buf_ops xfs_btree_mem_head_buf_ops = {
-	.name			= "xfs_btree_mem_head",
-	.magic			= { cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC),
-				    cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC) },
-	.verify_read		= xfs_btree_mem_head_read_verify,
-	.verify_write		= xfs_btree_mem_head_write_verify,
-	.verify_struct		= xfs_btree_mem_head_verify,
-};
-
-/* Initialize the header block for an in-memory btree. */
-static inline void
-xfs_btree_mem_head_init(
-	struct xfs_buf			*head_bp,
-	unsigned long long		owner,
-	xfileoff_t			leaf_xfoff)
-{
-	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
-	struct xfs_mount		*mp = head_bp->b_mount;
-
-	mhead->mh_magic = cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC);
-	mhead->mh_nlevels = cpu_to_be32(1);
-	mhead->mh_owner = cpu_to_be64(owner);
-	mhead->mh_root = cpu_to_be64(leaf_xfoff);
-	uuid_copy(&mhead->mh_uuid, &mp->m_sb.sb_meta_uuid);
-
-	head_bp->b_ops = &xfs_btree_mem_head_buf_ops;
-}
-
-/* Return tree height from the in-memory btree head. */
-unsigned int
-xfs_btree_mem_head_nlevels(
-	struct xfs_buf			*head_bp)
-{
-	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
-
-	return be32_to_cpu(mhead->mh_nlevels);
-}
-
 /* Extract the buftarg target for this xfile btree. */
 struct xfs_buftarg *
 xfbtree_target(struct xfbtree *xfbtree)
@@ -170,7 +93,6 @@ xfbtree_check_ptr(
 	int				level)
 {
 	xfileoff_t			bt_xfoff;
-	xfs_failaddr_t			fa = NULL;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
 
@@ -180,22 +102,10 @@ xfbtree_check_ptr(
 		bt_xfoff = be32_to_cpu(ptr->s);
 
 	if (!xfbtree_verify_xfileoff(cur, bt_xfoff)) {
-		fa = __this_address;
-		goto done;
-	}
-
-	/* Can't point to the head or anything before it */
-	if (bt_xfoff < XFBTREE_INIT_LEAF_BLOCK) {
-		fa = __this_address;
-		goto done;
-	}
-
-done:
-	if (fa) {
 		xfs_err(cur->bc_mp,
 "In-memory: Corrupt btree %d flags 0x%x pointer at level %d index %d fa %pS.",
 				cur->bc_btnum, cur->bc_flags, level, index,
-				fa);
+				__this_address);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -244,20 +154,10 @@ xfbtree_set_root(
 	const union xfs_btree_ptr	*ptr,
 	int				inc)
 {
-	struct xfs_buf			*head_bp = cur->bc_mem.head_bp;
-	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
-
 	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		mhead->mh_root = ptr->l;
-	} else {
-		uint32_t		root = be32_to_cpu(ptr->s);
-
-		mhead->mh_root = cpu_to_be64(root);
-	}
-	be32_add_cpu(&mhead->mh_nlevels, inc);
-	xfs_trans_log_buf(cur->bc_tp, head_bp, 0, sizeof(*mhead) - 1);
+	cur->bc_mem.xfbtree->root = *ptr;
+	cur->bc_mem.xfbtree->nlevels += inc;
 }
 
 /* Initialize a pointer from the in-memory btree header. */
@@ -266,18 +166,9 @@ xfbtree_init_ptr_from_cur(
 	struct xfs_btree_cur		*cur,
 	union xfs_btree_ptr		*ptr)
 {
-	struct xfs_buf			*head_bp = cur->bc_mem.head_bp;
-	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
-
 	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
 
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ptr->l = mhead->mh_root;
-	} else {
-		uint64_t		root = be64_to_cpu(mhead->mh_root);
-
-		ptr->s = cpu_to_be32(root);
-	}
+	*ptr = cur->bc_mem.xfbtree->root;
 }
 
 /* Duplicate an in-memory btree cursor. */
@@ -438,11 +329,11 @@ xfbtree_init_leaf_block(
 	const struct xfbtree_config	*cfg)
 {
 	struct xfs_buf			*bp;
-	xfs_daddr_t			daddr;
+	xfileoff_t			xfoff = xfbt->highest_offset++;
 	int				error;
 
-	daddr = xfo_to_daddr(XFBTREE_INIT_LEAF_BLOCK);
-	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
+	error = xfs_buf_get(xfbt->target, xfo_to_daddr(xfoff), xfbtree_bbsize(),
+			&bp);
 	if (error)
 		return error;
 
@@ -454,31 +345,10 @@ xfbtree_init_leaf_block(
 	if (error)
 		return error;
 
-	xfbt->highest_offset++;
-	return 0;
-}
-
-/* Initialize the in-memory btree header block. */
-STATIC int
-xfbtree_init_head(
-	struct xfbtree		*xfbt)
-{
-	struct xfs_buf		*bp;
-	xfs_daddr_t		daddr;
-	int			error;
-
-	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
-	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
-	if (error)
-		return error;
-
-	xfs_btree_mem_head_init(bp, xfbt->owner, XFBTREE_INIT_LEAF_BLOCK);
-	error = xfs_bwrite(bp);
-	xfs_buf_relse(bp);
-	if (error)
-		return error;
-
-	xfbt->highest_offset++;
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
+		xfbt->root.l = xfoff;
+	else
+		xfbt->root.s = xfoff;
 	return 0;
 }
 
@@ -519,16 +389,13 @@ xfbtree_create(
 	xfbt->minrecs[0] = xfbt->maxrecs[0] / 2;
 	xfbt->minrecs[1] = xfbt->maxrecs[1] / 2;
 	xfbt->owner = cfg->owner;
+	xfbt->nlevels = 1;
 
 	/* Initialize the empty btree. */
 	error = xfbtree_init_leaf_block(mp, xfbt, cfg);
 	if (error)
 		goto err_freesp;
 
-	error = xfbtree_init_head(xfbt);
-	if (error)
-		goto err_freesp;
-
 	trace_xfbtree_create(mp, cfg, xfbt);
 
 	*xfbtreep = xfbt;
@@ -541,37 +408,6 @@ xfbtree_create(
 	return error;
 }
 
-/* Read the in-memory btree head. */
-int
-xfbtree_head_read_buf(
-	struct xfbtree		*xfbt,
-	struct xfs_trans	*tp,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_buftarg	*btp = xfbt->target;
-	struct xfs_mount	*mp = btp->bt_mount;
-	struct xfs_btree_mem_head *mhead;
-	struct xfs_buf		*bp;
-	xfs_daddr_t		daddr;
-	int			error;
-
-	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
-	error = xfs_trans_read_buf(mp, tp, btp, daddr, xfbtree_bbsize(), 0,
-			&bp, &xfs_btree_mem_head_buf_ops);
-	if (error)
-		return error;
-
-	mhead = bp->b_addr;
-	if (be64_to_cpu(mhead->mh_owner) != xfbt->owner) {
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
-		xfs_trans_brelse(tp, bp);
-		return -EFSCORRUPTED;
-	}
-
-	*bpp = bp;
-	return 0;
-}
-
 static inline struct xfile *xfbtree_xfile(struct xfbtree *xfbt)
 {
 	return xfbt->target->bt_xfile;
diff --git a/fs/xfs/scrub/xfbtree.h b/fs/xfs/scrub/xfbtree.h
index ed48981e6c347e..e98f9261464a06 100644
--- a/fs/xfs/scrub/xfbtree.h
+++ b/fs/xfs/scrub/xfbtree.h
@@ -10,17 +10,6 @@
 
 #include "scrub/bitmap.h"
 
-/* Root block for an in-memory btree. */
-struct xfs_btree_mem_head {
-	__be32				mh_magic;
-	__be32				mh_nlevels;
-	__be64				mh_owner;
-	__be64				mh_root;
-	uuid_t				mh_uuid;
-};
-
-#define XFS_BTREE_MEM_HEAD_MAGIC	0x4341544D	/* "CATM" */
-
 /* xfile-backed in-memory btrees */
 
 struct xfboff_bitmap {
@@ -34,6 +23,10 @@ struct xfbtree {
 	/* Bitmap of free space from pos to used */
 	struct xfboff_bitmap		freespace;
 
+	/* Fake header block information */
+	union xfs_btree_ptr		root;
+	uint32_t			nlevels;
+
 	/* Highest xfile offset that has been written to. */
 	xfileoff_t			highest_offset;
 
@@ -45,15 +38,6 @@ struct xfbtree {
 	unsigned int			minrecs[2];
 };
 
-/* The head of the in-memory btree is always at block 0 */
-#define XFBTREE_HEAD_BLOCK		0
-
-/* in-memory btrees are always created with an empty leaf block at block 1 */
-#define XFBTREE_INIT_LEAF_BLOCK		1
-
-int xfbtree_head_read_buf(struct xfbtree *xfbt, struct xfs_trans *tp,
-		struct xfs_buf **bpp);
-
 void xfbtree_destroy(struct xfbtree *xfbt);
 int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
 void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
-- 
2.39.2

