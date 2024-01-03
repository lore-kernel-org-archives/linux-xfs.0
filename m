Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43371D53F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v9YNvS7/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E2lNks/DYf8Dy7EsApd9ORLVJeZaBBoQSaTOubPkY2A=; b=v9YNvS7/0dbgy8GZm3Dl+o0cIo
	7I7n8+WLYWL0e32F9ijzWczuoRV3ew1RhSi9wcrCND6rbtOmC2zCPJmlcy+M1brN8H/EPK/8XsxtL
	IFYS+wbgKkxX2K8uu95wooe4pYD7isxz0sgCGfLcWO6Cz+9qsQUtt/daot7T8TefYeVliVUdNRuUh
	8pUCc36+X7PPtr0HYEigWNBj0LJxC1mbUAuLuFGVz5K5r3TlA6V0/20n4fqLOJO0bCG5ApbQdqLB8
	Yeo5hsl7mbj58l6VDicO3XBPNSc9FivINsC1PxU0VTvgEqGLB+GT/9oEKaPZB7MeHhUchS91JvO3b
	VKRNX8uQ==;
Received: from [89.144.223.119] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rL811-00C4Uc-3B;
	Wed, 03 Jan 2024 20:39:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: embedd struct xfbtree into the owning structure
Date: Wed,  3 Jan 2024 21:38:36 +0100
Message-Id: <20240103203836.608391-6-hch@lst.de>
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

This will allow to use container_of to get at the containing structure,
which will be useful soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs-online-fsck-design.rst    |  5 +-
 fs/xfs/libxfs/xfs_btree_mem.h                 | 26 ++--------
 fs/xfs/libxfs/xfs_rmap_btree.c                | 13 ++---
 fs/xfs/libxfs/xfs_rmap_btree.h                |  2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c              | 13 ++---
 fs/xfs/libxfs/xfs_rtrmap_btree.h              |  2 +-
 fs/xfs/scrub/rcbag.c                          | 20 ++++----
 fs/xfs/scrub/rcbag_btree.c                    | 11 ++--
 fs/xfs/scrub/rcbag_btree.h                    |  2 +-
 fs/xfs/scrub/rmap_repair.c                    | 24 ++++-----
 fs/xfs/scrub/rtrmap_repair.c                  | 22 ++++----
 fs/xfs/scrub/trace.h                          | 13 +++--
 fs/xfs/scrub/xfbtree.c                        | 50 ++++++++-----------
 13 files changed, 82 insertions(+), 121 deletions(-)

diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index 29e123189d3039..5563ce9663711c 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -2277,13 +2277,12 @@ follows:
    pointing to the xfile.
 
 3. Pass the buffer cache target, buffer ops, and other information to
-   ``xfbtree_create`` to write an initial tree header and root block to the
-   xfile.
+   ``xfbtree_init`` to initialize the passed in ``struct xfbtree`` and write an
+   initial root block to the xfile.
    Each btree type should define a wrapper that passes necessary arguments to
    the creation function.
    For example, rmap btrees define ``xfs_rmapbt_mem_create`` to take care of
    all the necessary details for callers.
-   A ``struct xfbtree`` object will be returned.
 
 4. Pass the xfbtree object to the btree cursor creation function for the
    btree type.
diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index 3a5492c2cc26b6..0740537a06c6b0 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -8,23 +8,6 @@
 
 struct xfbtree;
 
-struct xfbtree_config {
-	/* Buffer ops for the btree root block */
-	const struct xfs_btree_ops	*btree_ops;
-
-	/* Buffer target for the xfile backing this btree. */
-	struct xfs_buftarg		*target;
-
-	/* Owner of this btree. */
-	unsigned long long		owner;
-
-	/* XFBTREE_* flags */
-	unsigned int			flags;
-};
-
-/* buffers should be directly mapped from memory */
-#define XFBTREE_DIRECT_MAP		(1U << 0)
-
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 struct xfs_buftarg *xfbtree_target(struct xfbtree *xfbtree);
 int xfbtree_check_ptr(struct xfs_btree_cur *cur,
@@ -51,8 +34,9 @@ unsigned long long xfbtree_buf_to_xfoff(struct xfs_btree_cur *cur,
 int xfbtree_get_minrecs(struct xfs_btree_cur *cur, int level);
 int xfbtree_get_maxrecs(struct xfs_btree_cur *cur, int level);
 
-int xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
-		struct xfbtree **xfbtreep);
+int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
+		const struct xfs_btree_ops *btree_ops);
+
 int xfbtree_alloc_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *start, union xfs_btree_ptr *ptr,
 		int *stat);
@@ -102,8 +86,8 @@ static inline unsigned int xfbtree_bbsize(void)
 #define xfbtree_buf_to_xfoff(cur, bp)		(-1)
 
 static inline int
-xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
-		struct xfbtree **xfbtreep)
+xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
+		const struct xfs_btree_ops *btree_ops)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 41f1b5fa863302..332fdcd07160e4 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -664,16 +664,11 @@ xfs_rmapbt_mem_create(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	struct xfs_buftarg	*target,
-	struct xfbtree		**xfbtreep)
+	struct xfbtree		*xfbt)
 {
-	struct xfbtree_config	cfg = {
-		.btree_ops	= &xfs_rmapbt_mem_ops,
-		.target		= target,
-		.owner		= agno,
-		.flags		= XFBTREE_DIRECT_MAP,
-	};
-
-	return xfbtree_create(mp, &cfg, xfbtreep);
+	xfbt->target = target;
+	xfbt->owner = agno;
+	return xfbtree_init(mp, xfbt, &xfs_rmapbt_mem_ops);
 }
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index dfe13b8cbb732d..1c114efbc090d5 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -70,7 +70,7 @@ struct xfbtree;
 struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int xfs_rmapbt_mem_create(struct xfs_mount *mp, xfs_agnumber_t agno,
-		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+		struct xfs_buftarg *target, struct xfbtree *xfbt);
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 95983dc081fa21..557f829c0826c1 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -657,16 +657,11 @@ xfs_rtrmapbt_mem_create(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno,
 	struct xfs_buftarg	*target,
-	struct xfbtree		**xfbtreep)
+	struct xfbtree		*xfbt)
 {
-	struct xfbtree_config	cfg = {
-		.btree_ops	= &xfs_rtrmapbt_mem_ops,
-		.target		= target,
-		.flags		= XFBTREE_DIRECT_MAP,
-		.owner		= rgno,
-	};
-
-	return xfbtree_create(mp, &cfg, xfbtreep);
+	xfbt->target = target;
+	xfbt->owner = rgno;
+	return xfbtree_init(mp, xfbt, &xfs_rtrmapbt_mem_ops);
 }
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 3347205846eb2e..b499fc7fc2e529 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -210,7 +210,7 @@ struct xfbtree;
 struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
 		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int xfs_rtrmapbt_mem_create(struct xfs_mount *mp, xfs_rgnumber_t rgno,
-		struct xfs_buftarg *target, struct xfbtree **xfbtreep);
+		struct xfs_buftarg *target, struct xfbtree *xfbt);
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/scrub/rcbag.c b/fs/xfs/scrub/rcbag.c
index f28ce02f961c7c..1f3c4555e78ebc 100644
--- a/fs/xfs/scrub/rcbag.c
+++ b/fs/xfs/scrub/rcbag.c
@@ -24,7 +24,7 @@
 
 struct rcbag {
 	struct xfs_mount	*mp;
-	struct xfbtree		*xfbtree;
+	struct xfbtree		xfbtree;
 	uint64_t		nr_items;
 };
 
@@ -62,7 +62,7 @@ rcbag_free(
 {
 	struct rcbag		*bag = *bagp;
 
-	xfbtree_destroy(bag->xfbtree);
+	xfbtree_destroy(&bag->xfbtree);
 	kfree(bag);
 	*bagp = NULL;
 }
@@ -80,7 +80,7 @@ rcbag_add(
 	int				has;
 	int				error;
 
-	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
 	error = rcbagbt_lookup_eq(cur, rmap, &has);
 	if (error)
 		goto out_cur;
@@ -114,7 +114,7 @@ rcbag_add(
 
 	xfs_btree_del_cursor(cur, 0);
 
-	error = xfbtree_trans_commit(bag->xfbtree, tp);
+	error = xfbtree_trans_commit(&bag->xfbtree, tp);
 	if (error)
 		return error;
 
@@ -123,7 +123,7 @@ rcbag_add(
 
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfbtree_trans_cancel(bag->xfbtree, tp);
+	xfbtree_trans_cancel(&bag->xfbtree, tp);
 	return error;
 }
 
@@ -158,7 +158,7 @@ rcbag_next_edge(
 	if (next_valid)
 		next_bno = next_rmap->rm_startblock;
 
-	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
 	error = xfs_btree_goto_left_edge(cur);
 	if (error)
 		goto out_cur;
@@ -216,7 +216,7 @@ rcbag_remove_ending_at(
 	int			error;
 
 	/* go to the right edge of the tree */
-	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
 	memset(&cur->bc_rec, 0xFF, sizeof(cur->bc_rec));
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, &has);
 	if (error)
@@ -252,10 +252,10 @@ rcbag_remove_ending_at(
 	}
 
 	xfs_btree_del_cursor(cur, 0);
-	return xfbtree_trans_commit(bag->xfbtree, tp);
+	return xfbtree_trans_commit(&bag->xfbtree, tp);
 out_cur:
 	xfs_btree_del_cursor(cur, error);
-	xfbtree_trans_cancel(bag->xfbtree, tp);
+	xfbtree_trans_cancel(&bag->xfbtree, tp);
 	return error;
 }
 
@@ -272,7 +272,7 @@ rcbag_dump(
 	int				has;
 	int				error;
 
-	cur = rcbagbt_mem_cursor(mp, tp, bag->xfbtree);
+	cur = rcbagbt_mem_cursor(mp, tp, &bag->xfbtree);
 	error = xfs_btree_goto_left_edge(cur);
 	if (error)
 		goto out_cur;
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 6f0b48b5c37bbd..bbb61d09d97927 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -226,15 +226,10 @@ int
 rcbagbt_mem_create(
 	struct xfs_mount	*mp,
 	struct xfs_buftarg	*target,
-	struct xfbtree		**xfbtreep)
+	struct xfbtree		*xfbt)
 {
-	struct xfbtree_config	cfg = {
-		.btree_ops	= &rcbagbt_mem_ops,
-		.target		= target,
-		.flags		= XFBTREE_DIRECT_MAP,
-	};
-
-	return xfbtree_create(mp, &cfg, xfbtreep);
+	xfbt->target = target;
+	return xfbtree_init(mp, xfbt, &rcbagbt_mem_ops);
 }
 
 /* Calculate number of records in a refcount bag btree block. */
diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
index 59d81d707d32a5..4d3d9d1e49e2fe 100644
--- a/fs/xfs/scrub/rcbag_btree.h
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -65,7 +65,7 @@ struct xfbtree;
 struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfbtree *xfbtree);
 int rcbagbt_mem_create(struct xfs_mount *mp, struct xfs_buftarg *target,
-		struct xfbtree **xfbtreep);
+		struct xfbtree *xfbt);
 
 int rcbagbt_lookup_eq(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *rmap, int *success);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index ab61f31868f841..abeeee88a6ebb3 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -135,7 +135,7 @@ struct xrep_rmap {
 	struct mutex		lock;
 
 	/* rmap records generated from primary metadata */
-	struct xfbtree		*rmap_btree;
+	struct xfbtree		rmap_btree;
 
 	struct xfs_scrub	*sc;
 
@@ -237,13 +237,13 @@ xrep_rmap_stash(
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
 	mutex_lock(&rr->lock);
-	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, &rr->rmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	error = xfbtree_trans_commit(rr->rmap_btree, sc->tp);
+	error = xfbtree_trans_commit(&rr->rmap_btree, sc->tp);
 	if (error)
 		goto out_abort;
 
@@ -251,7 +251,7 @@ xrep_rmap_stash(
 	return 0;
 
 out_cancel:
-	xfbtree_trans_cancel(rr->rmap_btree, sc->tp);
+	xfbtree_trans_cancel(&rr->rmap_btree, sc->tp);
 out_abort:
 	xchk_iscan_abort(&rr->iscan);
 	mutex_unlock(&rr->lock);
@@ -1004,7 +1004,7 @@ xrep_rmap_find_rmaps(
 	 * all our records before we start building a new btree, which requires
 	 * a bnobt cursor.
 	 */
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, &rr->rmap_btree);
 	sc->sa.bno_cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag, XFS_BTNUM_BNO);
 
@@ -1389,7 +1389,7 @@ xrep_rmap_build_new_tree(
 	 * Count the rmapbt records again, because the space reservation
 	 * for the rmapbt itself probably added more records to the btree.
 	 */
-	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
+	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, &rr->rmap_btree);
 
 	error = xrep_rmap_count_records(rr->mcur, &rr->nr_records);
 	if (error)
@@ -1528,7 +1528,7 @@ xrep_rmap_remove_old_tree(
 	xagb_bitmap_init(&rfg.rmap_gaps);
 
 	/* Compute free space from the new rmapbt. */
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, &rr->rmap_btree);
 
 	error = xfs_rmap_query_all(mcur, xrep_rmap_find_gaps, &rfg);
 	xfs_btree_del_cursor(mcur, error);
@@ -1638,14 +1638,14 @@ xrep_rmapbt_live_update(
 		goto out_abort;
 
 	mutex_lock(&rr->lock);
-	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, rr->rmap_btree);
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
 	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
 			p->blockcount, &p->oinfo, p->unwritten);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	error = xfbtree_trans_commit(rr->rmap_btree, tp);
+	error = xfbtree_trans_commit(&rr->rmap_btree, tp);
 	if (error)
 		goto out_cancel;
 
@@ -1654,7 +1654,7 @@ xrep_rmapbt_live_update(
 	return NOTIFY_DONE;
 
 out_cancel:
-	xfbtree_trans_cancel(rr->rmap_btree, tp);
+	xfbtree_trans_cancel(&rr->rmap_btree, tp);
 	xrep_trans_cancel_hook_dummy(&txcookie, tp);
 out_abort:
 	mutex_unlock(&rr->lock);
@@ -1697,7 +1697,7 @@ xrep_rmap_setup_scan(
 
 out_iscan:
 	xchk_iscan_teardown(&rr->iscan);
-	xfbtree_destroy(rr->rmap_btree);
+	xfbtree_destroy(&rr->rmap_btree);
 out_mutex:
 	mutex_destroy(&rr->lock);
 	return error;
@@ -1713,7 +1713,7 @@ xrep_rmap_teardown(
 	xchk_iscan_abort(&rr->iscan);
 	xfs_rmap_hook_del(sc->sa.pag, &rr->hooks);
 	xchk_iscan_teardown(&rr->iscan);
-	xfbtree_destroy(rr->rmap_btree);
+	xfbtree_destroy(&rr->rmap_btree);
 	mutex_destroy(&rr->lock);
 }
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 885752c7436b45..5c3b26ca3affd7 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -77,7 +77,7 @@ struct xrep_rtrmap {
 	struct mutex		lock;
 
 	/* rmap records generated from primary metadata */
-	struct xfbtree		*rtrmap_btree;
+	struct xfbtree		rtrmap_btree;
 
 	struct xfs_scrub	*sc;
 
@@ -171,13 +171,13 @@ xrep_rtrmap_stash(
 
 	/* Add entry to in-memory btree. */
 	mutex_lock(&rr->lock);
-	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, &rr->rtrmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	error = xfbtree_trans_commit(rr->rtrmap_btree, sc->tp);
+	error = xfbtree_trans_commit(&rr->rtrmap_btree, sc->tp);
 	if (error)
 		goto out_abort;
 
@@ -185,7 +185,7 @@ xrep_rtrmap_stash(
 	return 0;
 
 out_cancel:
-	xfbtree_trans_cancel(rr->rtrmap_btree, sc->tp);
+	xfbtree_trans_cancel(&rr->rtrmap_btree, sc->tp);
 out_abort:
 	xchk_iscan_abort(&rr->iscan);
 	mutex_unlock(&rr->lock);
@@ -648,7 +648,7 @@ xrep_rtrmap_find_rmaps(
 	 * check all our records before we start building a new btree, which
 	 * requires the rtbitmap lock.
 	 */
-	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, NULL, &rr->rtrmap_btree);
 	rr->nr_records = 0;
 	error = xfs_rmap_query_all(mcur, xrep_rtrmap_check_record, rr);
 	xfs_btree_del_cursor(mcur, error);
@@ -781,7 +781,7 @@ xrep_rtrmap_build_new_tree(
 	 * Create a cursor to the in-memory btree so that we can bulk load the
 	 * new btree.
 	 */
-	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, rr->rtrmap_btree);
+	rr->mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, NULL, &rr->rtrmap_btree);
 	error = xfs_btree_goto_left_edge(rr->mcur);
 	if (error)
 		goto err_mcur;
@@ -900,14 +900,14 @@ xrep_rtrmapbt_live_update(
 		goto out_abort;
 
 	mutex_lock(&rr->lock);
-	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, rr->rtrmap_btree);
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
 	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
 			p->blockcount, &p->oinfo, p->unwritten);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	error = xfbtree_trans_commit(rr->rtrmap_btree, tp);
+	error = xfbtree_trans_commit(&rr->rtrmap_btree, tp);
 	if (error)
 		goto out_cancel;
 
@@ -916,7 +916,7 @@ xrep_rtrmapbt_live_update(
 	return NOTIFY_DONE;
 
 out_cancel:
-	xfbtree_trans_cancel(rr->rtrmap_btree, tp);
+	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
 	xrep_trans_cancel_hook_dummy(&txcookie, tp);
 out_abort:
 	xchk_iscan_abort(&rr->iscan);
@@ -960,7 +960,7 @@ xrep_rtrmap_setup_scan(
 
 out_iscan:
 	xchk_iscan_teardown(&rr->iscan);
-	xfbtree_destroy(rr->rtrmap_btree);
+	xfbtree_destroy(&rr->rtrmap_btree);
 out_bitmap:
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
 	mutex_destroy(&rr->lock);
@@ -977,7 +977,7 @@ xrep_rtrmap_teardown(
 	xchk_iscan_abort(&rr->iscan);
 	xfs_rtrmap_hook_del(sc->sr.rtg, &rr->hooks);
 	xchk_iscan_teardown(&rr->iscan);
-	xfbtree_destroy(rr->rtrmap_btree);
+	xfbtree_destroy(&rr->rtrmap_btree);
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
 	mutex_destroy(&rr->lock);
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6e15de56be2b75..ddd75799ccecd8 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -26,7 +26,6 @@ struct xchk_iscan;
 struct xchk_nlink;
 struct xchk_fscounters;
 struct xfbtree;
-struct xfbtree_config;
 struct xfs_rmap_update_params;
 struct xfs_parent_name_irec;
 enum xchk_dirpath_outcome;
@@ -2817,10 +2816,10 @@ DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
 
-TRACE_EVENT(xfbtree_create,
-	TP_PROTO(struct xfs_mount *mp, const struct xfbtree_config *cfg,
-		 struct xfbtree *xfbt),
-	TP_ARGS(mp, cfg, xfbt),
+TRACE_EVENT(xfbtree_init,
+	TP_PROTO(struct xfs_mount *mp, struct xfbtree *xfbt,
+		 const struct xfs_btree_ops *btree_ops),
+	TP_ARGS(mp, xfbt, btree_ops),
 	TP_STRUCT__entry(
 		__field(const void *, btree_ops)
 		__field(unsigned long, xfino)
@@ -2831,13 +2830,13 @@ TRACE_EVENT(xfbtree_create,
 		__field(unsigned long long, owner)
 	),
 	TP_fast_assign(
-		__entry->btree_ops = cfg->btree_ops;
+		__entry->btree_ops = btree_ops;
 		__entry->xfino = xfbtree_ino(xfbt);
 		__entry->leaf_mxr = xfbt->maxrecs[0];
 		__entry->node_mxr = xfbt->maxrecs[1];
 		__entry->leaf_mnr = xfbt->minrecs[0];
 		__entry->node_mnr = xfbt->minrecs[1];
-		__entry->owner = cfg->owner;
+		__entry->owner = xfbt->owner;
 	),
 	TP_printk("xfino 0x%lx btree_ops %pS owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
 		  __entry->xfino,
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 11dad651508067..9f59c7f88be9ff 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -237,18 +237,17 @@ xfbtree_destroy(
 {
 	xbitmap64_destroy(&xfbt->freespace);
 	xfs_buftarg_drain(xfbt->target);
-	kfree(xfbt);
 }
 
 /* Compute the number of bytes available for records. */
 static inline unsigned int
 xfbtree_rec_bytes(
 	struct xfs_mount		*mp,
-	const struct xfbtree_config	*cfg)
+	const struct xfs_btree_ops	*btree_ops)
 {
 	unsigned int			blocklen = xfo_to_b(1);
 
-	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS) {
+	if (btree_ops->geom_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_has_crc(mp))
 			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
 
@@ -266,7 +265,7 @@ STATIC int
 xfbtree_init_leaf_block(
 	struct xfs_mount		*mp,
 	struct xfbtree			*xfbt,
-	const struct xfbtree_config	*cfg)
+	const struct xfs_btree_ops	*btree_ops)
 {
 	struct xfs_buf			*bp;
 	xfileoff_t			xfoff = xfbt->highest_offset++;
@@ -279,13 +278,13 @@ xfbtree_init_leaf_block(
 
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
-	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
+	xfs_btree_init_buf(mp, bp, btree_ops, 0, 0, xfbt->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)
 		return error;
 
-	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
+	if (btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
 		xfbt->root.l = xfoff;
 	else
 		xfbt->root.s = xfoff;
@@ -294,57 +293,52 @@ xfbtree_init_leaf_block(
 
 /* Create an xfile btree backing thing that can be used for in-memory btrees. */
 int
-xfbtree_create(
+xfbtree_init(
 	struct xfs_mount		*mp,
-	const struct xfbtree_config	*cfg,
-	struct xfbtree			**xfbtreep)
+	struct xfbtree			*xfbt,
+	const struct xfs_btree_ops	*btree_ops)
 {
-	struct xfbtree			*xfbt;
-	unsigned int			blocklen = xfbtree_rec_bytes(mp, cfg);
-	unsigned int			keyptr_len = cfg->btree_ops->key_len;
+	unsigned int			blocklen = xfbtree_rec_bytes(mp, btree_ops);
+	unsigned int			keyptr_len = btree_ops->key_len;
 	int				error;
 
 	/* Requires an xfile-backed buftarg. */
-	if (!(cfg->target->bt_flags & XFS_BUFTARG_XFILE)) {
-		ASSERT(cfg->target->bt_flags & XFS_BUFTARG_XFILE);
+	if (!xfbt->target) {
+		ASSERT(xfbt->target);
 		return -EINVAL;
 	}
+	if (!(xfbt->target->bt_flags & XFS_BUFTARG_XFILE)) {
+		ASSERT(xfbt->target->bt_flags & XFS_BUFTARG_XFILE);
+		return -EINVAL;
+	}
+	xfbt->target->bt_flags |= XFS_BUFTARG_DIRECT_MAP;
 
-	xfbt = kzalloc(sizeof(struct xfbtree), XCHK_GFP_FLAGS);
-	if (!xfbt)
-		return -ENOMEM;
-	xfbt->target = cfg->target;
-	if (cfg->flags & XFBTREE_DIRECT_MAP)
-		xfbt->target->bt_flags |= XFS_BUFTARG_DIRECT_MAP;
-
+	xfbt->highest_offset = 0;
 	xbitmap64_init(&xfbt->freespace);
 
 	/* Set up min/maxrecs for this btree. */
-	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
+	if (btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
 		keyptr_len += sizeof(__be64);
 	else
 		keyptr_len += sizeof(__be32);
-	xfbt->maxrecs[0] = blocklen / cfg->btree_ops->rec_len;
+	xfbt->maxrecs[0] = blocklen / btree_ops->rec_len;
 	xfbt->maxrecs[1] = blocklen / keyptr_len;
 	xfbt->minrecs[0] = xfbt->maxrecs[0] / 2;
 	xfbt->minrecs[1] = xfbt->maxrecs[1] / 2;
-	xfbt->owner = cfg->owner;
 	xfbt->nlevels = 1;
 
 	/* Initialize the empty btree. */
-	error = xfbtree_init_leaf_block(mp, xfbt, cfg);
+	error = xfbtree_init_leaf_block(mp, xfbt, btree_ops);
 	if (error)
 		goto err_freesp;
 
-	trace_xfbtree_create(mp, cfg, xfbt);
+	trace_xfbtree_init(mp, xfbt, btree_ops);
 
-	*xfbtreep = xfbt;
 	return 0;
 
 err_freesp:
 	xbitmap64_destroy(&xfbt->freespace);
 	xfs_buftarg_drain(xfbt->target);
-	kfree(xfbt);
 	return error;
 }
 
-- 
2.39.2

