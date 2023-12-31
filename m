Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E0C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubnjlbn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2206DC433C7;
	Sun, 31 Dec 2023 22:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061186;
	bh=WcWri5J7itNl31AxC+TPe9w2rBDza9NytSyQokyJPDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ubnjlbn0bZwPbTsm99mZBrrZoOpBg1QOysOiwb1Y9GcHMl89Z8SARsOGSOneGWbZc
	 QcfsMlRF6MQtU+RV5rzxkNZKRe6vLieTBa3z1H4H73z1NU9jiEsBFc03ykd1kA0OM+
	 r+AFatZPO4aGHGu2NzumvdJgqPOoMuEBCbxN0QdbnvBe93dalcPFrswIKi3Y9ocvpj
	 1GW10Eh1nFBIat9WK2J2inNuBCAw0KHL4KkyZsWpIoAK5UXqZhcql/FQtyJxyM6s25
	 2SQ48BvPC4kHQAcEBH1cat49rDWwOam0YXY1jdhAwAda7SC29jqq37fornN2LVBuU+
	 xPOPvENOPLhfQ==
Date: Sun, 31 Dec 2023 14:19:45 -0800
Subject: [PATCH 6/6] xfs_repair: remove the old rmap collection slabs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993668.1794934.15182377909926208921.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
References: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
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

Now that we've switched the offline repair code to use an in-memory
rmap btree for everything except recording the rmaps for the newly
generated per-AG btrees, get rid of all the old code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    9 +--
 repair/phase4.c |   23 -------
 repair/rmap.c   |  189 +++++++++----------------------------------------------
 repair/rmap.h   |   16 ++---
 repair/scan.c   |    7 --
 5 files changed, 42 insertions(+), 202 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 629440fe6de..f2da4325d5e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -628,13 +628,8 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 				break;
 			}
 		}
-		if (collect_rmaps) { /* && !check_dups */
-			error = rmap_add_rec(mp, ino, whichfork, &irec);
-			if (error)
-				do_error(
-_("couldn't add reverse mapping\n")
-					);
-		}
+		if (collect_rmaps) /* && !check_dups */
+			rmap_add_rec(mp, ino, whichfork, &irec);
 		*tot += irec.br_blockcount;
 	}
 	error = 0;
diff --git a/repair/phase4.c b/repair/phase4.c
index f267149abf7..5e5d8c3c7d9 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -142,17 +142,7 @@ static void
 process_ags(
 	xfs_mount_t		*mp)
 {
-	xfs_agnumber_t		i;
-	int			error;
-
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		error = rmap_finish_collecting_fork_recs(mp, i);
-		if (error)
-			do_error(
-_("unable to finish adding attr/data fork reverse-mapping data for AG %u.\n"),
-				i);
-	}
 }
 
 static void
@@ -161,18 +151,7 @@ check_rmap_btrees(
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
-	int		error;
-
-	error = rmap_add_fixed_ag_rec(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("unable to add AG %u metadata reverse-mapping data.\n"), agno);
-
-	error = rmap_fold_raw_recs(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
-
+	rmap_add_fixed_ag_rec(wq->wq_ctx, agno);
 	rmaps_verify_btree(wq->wq_ctx, agno);
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 6b01db77010..b338cdc3bea 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -28,11 +28,9 @@
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfbtree	*ar_xfbtree;		/* rmap observations */
-	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
-	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
+	struct xfs_slab	*ar_agbtree_rmaps;	/* rmaps for rebuilt ag btrees */
 	int		ar_flcount;		/* agfl entries from leftover */
 						/* agbt allocations */
-	struct xfs_rmap_irec	ar_last_rmap;	/* last rmap seen */
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
 };
 
@@ -72,6 +70,7 @@ rmaps_destroy(
 {
 	struct xfs_buftarg	*target;
 
+	free_slab(&ag_rmap->ar_agbtree_rmaps);
 	free_slab(&ag_rmap->ar_refcount_items);
 
 	if (!ag_rmap->ar_xfbtree)
@@ -113,6 +112,11 @@ rmaps_init_ag(
 	if (error)
 		goto nomem;
 
+	error = init_slab(&ag_rmap->ar_agbtree_rmaps,
+			sizeof(struct xfs_rmap_irec));
+	if (error)
+		goto nomem;
+
 	return;
 nomem:
 	do_error(
@@ -127,7 +131,6 @@ rmaps_init(
 	struct xfs_mount	*mp)
 {
 	xfs_agnumber_t		i;
-	int			error;
 
 	if (!rmap_needs_work(mp))
 		return;
@@ -136,21 +139,8 @@ rmaps_init(
 	if (!ag_rmaps)
 		do_error(_("couldn't allocate per-AG reverse map roots\n"));
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_init_ag(mp, i, &ag_rmaps[i]);
-
-		error = init_slab(&ag_rmaps[i].ar_rmaps,
-				sizeof(struct xfs_rmap_irec));
-		if (error)
-			do_error(
-_("Insufficient memory while allocating reverse mapping slabs."));
-		error = init_slab(&ag_rmaps[i].ar_raw_rmaps,
-				  sizeof(struct xfs_rmap_irec));
-		if (error)
-			do_error(
-_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
-		ag_rmaps[i].ar_last_rmap.rm_owner = XFS_RMAP_OWN_UNKNOWN;
-	}
 }
 
 /*
@@ -165,11 +155,8 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		free_slab(&ag_rmaps[i].ar_rmaps);
-		free_slab(&ag_rmaps[i].ar_raw_rmaps);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_destroy(mp, &ag_rmaps[i]);
-	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
 }
@@ -300,7 +287,7 @@ rmap_add_mem_rec(
  * Add an observation about a block mapping in an inode's data or attribute
  * fork for later btree reconstruction.
  */
-int
+void
 rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -310,11 +297,9 @@ rmap_add_rec(
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
-	struct xfs_rmap_irec	*last_rmap;
-	int			error = 0;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
@@ -335,36 +320,10 @@ rmap_add_rec(
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
 
 	rmap_add_mem_rec(mp, agno, &rmap);
-
-	last_rmap = &ag_rmaps[agno].ar_last_rmap;
-	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
-		*last_rmap = rmap;
-	else if (rmaps_are_mergeable(last_rmap, &rmap))
-		last_rmap->rm_blockcount += rmap.rm_blockcount;
-	else {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, last_rmap);
-		if (error)
-			return error;
-		*last_rmap = rmap;
-	}
-
-	return error;
-}
-
-/* Finish collecting inode data/attr fork rmaps. */
-int
-rmap_finish_collecting_fork_recs(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	if (!rmap_needs_work(mp) ||
-	    ag_rmaps[agno].ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
-		return 0;
-	return slab_add(ag_rmaps[agno].ar_rmaps, &ag_rmaps[agno].ar_last_rmap);
 }
 
 /* add a raw rmap; these will be merged later */
-static int
+static void
 __rmap_add_raw_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -388,13 +347,12 @@ __rmap_add_raw_rec(
 	rmap.rm_blockcount = len;
 
 	rmap_add_mem_rec(mp, agno, &rmap);
-	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
 }
 
 /*
  * Add a reverse mapping for an inode fork's block mapping btree block.
  */
-int
+void
 rmap_add_bmbt_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -405,7 +363,7 @@ rmap_add_bmbt_rec(
 	xfs_agblock_t		agbno;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
@@ -413,14 +371,14 @@ rmap_add_bmbt_rec(
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + 1 <= mp->m_sb.sb_agblocks);
 
-	return __rmap_add_raw_rec(mp, agno, agbno, 1, ino,
-			whichfork == XFS_ATTR_FORK, true);
+	__rmap_add_raw_rec(mp, agno, agbno, 1, ino, whichfork == XFS_ATTR_FORK,
+			true);
 }
 
 /*
  * Add a reverse mapping for a per-AG fixed metadata extent.
  */
-int
+STATIC void
 rmap_add_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -429,13 +387,13 @@ rmap_add_ag_rec(
 	uint64_t		owner)
 {
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 
-	return __rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
+	__rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
 }
 
 /*
@@ -465,62 +423,7 @@ rmap_add_agbtree_mapping(
 	assert(libxfs_verify_agbext(pag, agbno, len));
 	libxfs_perag_put(pag);
 
-	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
-}
-
-/*
- * Merge adjacent raw rmaps and add them to the main rmap list.
- */
-int
-rmap_fold_raw_recs(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_slab_cursor	*cur = NULL;
-	struct xfs_rmap_irec	*prev, *rec;
-	uint64_t		old_sz;
-	int			error = 0;
-
-	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
-	if (slab_count(ag_rmaps[agno].ar_raw_rmaps) == 0)
-		goto no_raw;
-	qsort_slab(ag_rmaps[agno].ar_raw_rmaps, rmap_compare);
-	error = init_slab_cursor(ag_rmaps[agno].ar_raw_rmaps, rmap_compare,
-			&cur);
-	if (error)
-		goto err;
-
-	prev = pop_slab_cursor(cur);
-	rec = pop_slab_cursor(cur);
-	while (prev && rec) {
-		if (rmaps_are_mergeable(prev, rec)) {
-			prev->rm_blockcount += rec->rm_blockcount;
-			rec = pop_slab_cursor(cur);
-			continue;
-		}
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
-		if (error)
-			goto err;
-		prev = rec;
-		rec = pop_slab_cursor(cur);
-	}
-	if (prev) {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
-		if (error)
-			goto err;
-	}
-	free_slab(&ag_rmaps[agno].ar_raw_rmaps);
-	error = init_slab(&ag_rmaps[agno].ar_raw_rmaps,
-			sizeof(struct xfs_rmap_irec));
-	if (error)
-		do_error(
-_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
-no_raw:
-	if (old_sz)
-		qsort_slab(ag_rmaps[agno].ar_rmaps, rmap_compare);
-err:
-	free_slab_cursor(&cur);
-	return error;
+	return slab_add(ag_rmaps[agno].ar_agbtree_rmaps, &rmap);
 }
 
 static int
@@ -557,7 +460,7 @@ popcnt(
  * Add an allocation group's fixed metadata to the rmap list.  This includes
  * sb/agi/agf/agfl headers, inode chunks, and the log.
  */
-int
+void
 rmap_add_fixed_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
@@ -566,18 +469,14 @@ rmap_add_fixed_ag_rec(
 	xfs_agblock_t		agbno;
 	ino_tree_node_t		*ino_rec;
 	xfs_agino_t		agino;
-	int			error;
 	int			startidx;
 	int			nr;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	/* sb/agi/agf/agfl headers */
-	error = rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp),
-			XFS_RMAP_OWN_FS);
-	if (error)
-		goto out;
+	rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp), XFS_RMAP_OWN_FS);
 
 	/* inodes */
 	ino_rec = findfirst_inode_rec(agno);
@@ -595,10 +494,8 @@ rmap_add_fixed_ag_rec(
 		agino = ino_rec->ino_startnum + startidx;
 		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 		if (XFS_AGINO_TO_OFFSET(mp, agino) == 0) {
-			error = rmap_add_ag_rec(mp, agno, agbno, nr,
+			rmap_add_ag_rec(mp, agno, agbno, nr,
 					XFS_RMAP_OWN_INODES);
-			if (error)
-				goto out;
 		}
 	}
 
@@ -606,13 +503,9 @@ rmap_add_fixed_ag_rec(
 	fsbno = mp->m_sb.sb_logstart;
 	if (fsbno && XFS_FSB_TO_AGNO(mp, fsbno) == agno) {
 		agbno = XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart);
-		error = rmap_add_ag_rec(mp, agno, agbno, mp->m_sb.sb_logblocks,
+		rmap_add_ag_rec(mp, agno, agbno, mp->m_sb.sb_logblocks,
 				XFS_RMAP_OWN_LOG);
-		if (error)
-			goto out;
 	}
-out:
-	return error;
 }
 
 /*
@@ -653,12 +546,6 @@ rmap_commit_agbtree_mappings(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 
-	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
-	free_slab(&ag_rmap->ar_rmaps);
-	error = init_slab(&ag_rmap->ar_rmaps, sizeof(struct xfs_rmap_irec));
-	if (error)
-		goto err;
-
 	/* Add the AGFL blocks to the rmap list */
 	error = -libxfs_trans_read_buf(
 			mp, NULL, mp->m_ddev_targp,
@@ -682,7 +569,8 @@ rmap_commit_agbtree_mappings(
 	 * space btree blocks, so we must be careful not to create those
 	 * records again.  Create a bitmap of already-recorded OWN_AG rmaps.
 	 */
-	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
+	error = init_slab_cursor(ag_rmap->ar_agbtree_rmaps, rmap_compare,
+			&rm_cur);
 	if (error)
 		goto err;
 	error = -bitmap_alloc(&own_ag_bitmap);
@@ -715,7 +603,7 @@ rmap_commit_agbtree_mappings(
 
 		agbno = be32_to_cpu(*b);
 		if (!bitmap_test(own_ag_bitmap, agbno, 1)) {
-			error = rmap_add_ag_rec(mp, agno, agbno, 1,
+			error = rmap_add_agbtree_mapping(mp, agno, agbno, 1,
 					XFS_RMAP_OWN_AG);
 			if (error)
 				goto err;
@@ -726,13 +614,9 @@ rmap_commit_agbtree_mappings(
 	agflbp = NULL;
 	bitmap_free(&own_ag_bitmap);
 
-	/* Merge all the raw rmaps into the main list */
-	error = rmap_fold_raw_recs(mp, agno);
-	if (error)
-		goto err;
-
 	/* Create cursors to rmap structures */
-	error = init_slab_cursor(ag_rmap->ar_rmaps, rmap_compare, &rm_cur);
+	error = init_slab_cursor(ag_rmap->ar_agbtree_rmaps, rmap_compare,
+			&rm_cur);
 	if (error)
 		goto err;
 
@@ -1101,6 +985,8 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
+	if (ag_rmaps[agno].ar_xfbtree == NULL)
+		return 0;
 
 	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
 	if (error)
@@ -1245,17 +1131,6 @@ rmap_record_count(
 	return nr;
 }
 
-/*
- * Return a slab cursor that will return rmap objects in order.
- */
-int
-rmap_init_cursor(
-	xfs_agnumber_t		agno,
-	struct xfs_slab_cursor	**cur)
-{
-	return init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare, cur);
-}
-
 /*
  * Disable the refcount btree check.
  */
diff --git a/repair/rmap.h b/repair/rmap.h
index 2abd37d14e5..50268b2f8ca 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -14,23 +14,19 @@ extern bool rmap_needs_work(struct xfs_mount *);
 extern void rmaps_init(struct xfs_mount *);
 extern void rmaps_free(struct xfs_mount *);
 
-extern int rmap_add_rec(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
-extern int rmap_finish_collecting_fork_recs(struct xfs_mount *mp,
-		xfs_agnumber_t agno);
-extern int rmap_add_ag_rec(struct xfs_mount *, xfs_agnumber_t agno,
-		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
-extern int rmap_add_bmbt_rec(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
-extern int rmap_fold_raw_recs(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
+void rmap_add_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *irec);
+void rmap_add_bmbt_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		xfs_fsblock_t fsbno);
+bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
-extern int rmap_add_fixed_ag_rec(struct xfs_mount *, xfs_agnumber_t);
+void rmap_add_fixed_ag_rec(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 int rmap_add_agbtree_mapping(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
 int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
diff --git a/repair/scan.c b/repair/scan.c
index bda2be24af3..fbe1916ac6c 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -224,7 +224,6 @@ scan_bmapbt(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
-	int			error;
 
 	/*
 	 * unlike the ag freeblock btrees, if anything looks wrong
@@ -415,12 +414,8 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	if (check_dups && collect_rmaps) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		pthread_mutex_lock(&ag_locks[agno].lock);
-		error = rmap_add_bmbt_rec(mp, ino, whichfork, bno);
+		rmap_add_bmbt_rec(mp, ino, whichfork, bno);
 		pthread_mutex_unlock(&ag_locks[agno].lock);
-		if (error)
-			do_error(
-_("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
-				ino, bno);
 	}
 
 	if (level == 0) {

