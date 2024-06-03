Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE1B135A53
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442774; cv=none; b=JssGRkKMRNpLmQWabYyoq18v8M1M6e3kCmYd+E0XWJDbUbOFzuTIAlnVZXSh+s7JNJQdekNrR82hHqftVZ5q7Goa77J1COI0RLICAjowqBpWs1yguQHZx4PFNxAYBDNZHWjuiNzcJfDeItwWZ0Uq0eNw35Yhjk/CSqz0y54qXOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442774; c=relaxed/simple;
	bh=n5VwZSy1D1ZfcQExFPNhbnalLb5nBYl1WT4fCH3uOcA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAZkAhCy2vnhGE9iak4/3B7bhukEOQVQyGwsNrjvQ3YCRSbvR1ZLRfuCl2OvRLfTeXyMO7toP9TnHVMLcQxI693624pv6v0Yazoe5BqIn2lye7sUnuirAcybReTJ+q/jc20ytqXSTHFwFOXluYgqsoxHG5AxIcckcZ7+fslo+sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyAeKBpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyAeKBpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BCEC2BD10;
	Mon,  3 Jun 2024 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442774;
	bh=n5VwZSy1D1ZfcQExFPNhbnalLb5nBYl1WT4fCH3uOcA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PyAeKBpcHErhscMVnzlgHrP8c3Aca0gLLGI2cYAHfpMYrXR/7SPyW2H7rzW7OZhb+
	 JT7seTdPVxrDEU66gj0tmZ0MbtsJrhyyEHlPTyPHeGeoQCawJuo8EGyp6YX9MttCkh
	 RGRghruMXpADKLzU9L1YV9jpQ1+7nbHj5kJrWMKPRhYjVbe00Tm3p2lqx63t6PyWos
	 A+dTqTO83JndhneLu1cKiGLAt5GYmPygxV9hoFQ67DcMm2RAqHrmNVgDbrCMdz5IO1
	 6j7PSu60baNiFCJZC4doAt/7YduDQ+BCVEXrZmxzxig4/aJgd5z5VhIpagAJztGoNY
	 VYTgsrlYpTlQg==
Date: Mon, 03 Jun 2024 12:26:13 -0700
Subject: [PATCH 6/6] xfs_repair: remove the old rmap collection slabs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043161.1450153.4440030997500562469.stgit@frogsfrogsfrogs>
In-Reply-To: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
References: <171744043069.1450153.1345347577840777304.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |    9 +-
 repair/phase4.c |   23 ------
 repair/rmap.c   |  201 ++++++++++---------------------------------------------
 repair/rmap.h   |   16 ++--
 repair/scan.c   |    7 --
 5 files changed, 46 insertions(+), 210 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 9d2f71055..168cbf484 100644
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
index f267149ab..5e5d8c3c7 100644
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
index f34e42300..519633278 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -30,20 +30,14 @@ struct xfs_ag_rmap {
 	/* rmap buffer target for btree */
 	struct xfs_buftarg	*ar_xmbtp;
 
-	/* rmap observations, p4 */
-	struct xfs_slab		*ar_rmaps;
-
-	/* unmerged rmaps */
-	struct xfs_slab		*ar_raw_rmaps;
-
-	/* agfl entries from leftover agbt allocations */
-	int			ar_flcount;
-
-	/* last rmap seen */
-	struct xfs_rmap_irec	ar_last_rmap;
+	/* rmaps for rebuilt ag btrees */
+	struct xfs_slab		*ar_agbtree_rmaps;
 
 	/* refcount items, p4-5 */
 	struct xfs_slab		*ar_refcount_items;
+
+	/* agfl entries from leftover agbt allocations */
+	int			ar_flcount;
 };
 
 /* Only the parts of struct xfs_rmap_irec that we need to compute refcounts. */
@@ -85,6 +79,7 @@ rmaps_destroy(
 	struct xfs_mount	*mp,
 	struct xfs_ag_rmap	*ag_rmap)
 {
+	free_slab(&ag_rmap->ar_agbtree_rmaps);
 	free_slab(&ag_rmap->ar_refcount_items);
 
 	if (!rmaps_has_observations(ag_rmap))
@@ -123,6 +118,11 @@ rmaps_init_ag(
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
@@ -137,7 +137,6 @@ rmaps_init(
 	struct xfs_mount	*mp)
 {
 	xfs_agnumber_t		i;
-	int			error;
 
 	if (!rmap_needs_work(mp))
 		return;
@@ -146,21 +145,8 @@ rmaps_init(
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
@@ -175,11 +161,8 @@ rmaps_free(
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
@@ -294,7 +277,7 @@ rmap_add_mem_rec(
  * Add an observation about a block mapping in an inode's data or attribute
  * fork for later btree reconstruction.
  */
-int
+void
 rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -304,11 +287,9 @@ rmap_add_rec(
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
@@ -329,36 +310,10 @@ rmap_add_rec(
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
@@ -382,13 +337,12 @@ __rmap_add_raw_rec(
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
@@ -399,7 +353,7 @@ rmap_add_bmbt_rec(
 	xfs_agblock_t		agbno;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
@@ -407,14 +361,14 @@ rmap_add_bmbt_rec(
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
@@ -423,13 +377,13 @@ rmap_add_ag_rec(
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
@@ -459,62 +413,7 @@ rmap_add_agbtree_mapping(
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
@@ -551,7 +450,7 @@ popcnt(
  * Add an allocation group's fixed metadata to the rmap list.  This includes
  * sb/agi/agf/agfl headers, inode chunks, and the log.
  */
-int
+void
 rmap_add_fixed_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
@@ -560,18 +459,14 @@ rmap_add_fixed_ag_rec(
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
@@ -589,10 +484,8 @@ rmap_add_fixed_ag_rec(
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
 
@@ -600,13 +493,9 @@ rmap_add_fixed_ag_rec(
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
@@ -647,12 +536,6 @@ rmap_commit_agbtree_mappings(
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
@@ -676,7 +559,8 @@ rmap_commit_agbtree_mappings(
 	 * space btree blocks, so we must be careful not to create those
 	 * records again.  Create a bitmap of already-recorded OWN_AG rmaps.
 	 */
-	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
+	error = init_slab_cursor(ag_rmap->ar_agbtree_rmaps, rmap_compare,
+			&rm_cur);
 	if (error)
 		goto err;
 	error = -bitmap_alloc(&own_ag_bitmap);
@@ -709,7 +593,7 @@ rmap_commit_agbtree_mappings(
 
 		agbno = be32_to_cpu(*b);
 		if (!bitmap_test(own_ag_bitmap, agbno, 1)) {
-			error = rmap_add_ag_rec(mp, agno, agbno, 1,
+			error = rmap_add_agbtree_mapping(mp, agno, agbno, 1,
 					XFS_RMAP_OWN_AG);
 			if (error)
 				goto err;
@@ -720,13 +604,9 @@ rmap_commit_agbtree_mappings(
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
 
@@ -1094,6 +974,8 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
+	if (!rmaps_has_observations(&ag_rmaps[agno]))
+		return 0;
 
 	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
 	if (error)
@@ -1238,17 +1120,6 @@ rmap_record_count(
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
index 2de3ec56f..683a51af3 100644
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
index 715be1166..338308ef8 100644
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

