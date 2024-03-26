Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0411128813
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422671; cv=none; b=AjK6jfLtAllVqdo9PFHVjN9YmnexgU+RhfKXiOl3qOjcwEFLlWmxjL63QfBJPIj++7PZ9AB/xAPqy1/bxCP1PxoI8n6JuiPgrLJsZSxaGY+RLoJ/JUWMwWZy3Vt1jdFLOJEukz2TEmg+cJSS0bwzS4h5O51JzmGE8oXTBqEMaNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422671; c=relaxed/simple;
	bh=bkXh2Wb4cwTIGeuGd+4vTdHnN3fDRRf0nf908aAt9eQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqHYOyqRuteIIEcCbKDCeu8JL24NLb+dCG+DfhjEbm/ds7WIvdpahXHRCXnCT2CoiKu+oWDXaMEOlgUPmVZXKRcnQ9aGUElrVupUIfP2KR2yHZK+rElGgCFNHHZMm3nKaDNMcV7tUgy7ECjmrY7unZmZJsBPAjVAd6zNqBDHtgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWEDYFFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWEDYFFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747A2C433C7;
	Tue, 26 Mar 2024 03:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422671;
	bh=bkXh2Wb4cwTIGeuGd+4vTdHnN3fDRRf0nf908aAt9eQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OWEDYFFW+xOHgRtTop15tr70y8v18ZxV7xMoey13b8uD+G0L4uTpGzV7q69696eq3
	 gwsMLRSy0+wHlhGlVrqI5Yk70AmKf7M3DOiwQAostiH4zH6nT2/ppduqfKT52+UVUU
	 c4vwU6xR/q9M0+/SPzgaeSWP+R0SGbhMVueQyE1Mz9aOaGjstt8OMtXnQb3DxkDRRP
	 ditRuBzZoqaAwvMmwYZ02Hr4VcX7v03X2js9YjxCzOzZhqOkWfRtqWPZdj+fmOh0KG
	 Bb58s5PsOrUxHbS6c8DO+Wf5g23N3RL9Yzp3Jv7XN54g9/YgAwFR4VM1LYQmUxggyk
	 3pzLvwDezE3Hw==
Date: Mon, 25 Mar 2024 20:11:10 -0700
Subject: [PATCH 32/67] xfs: move btree bulkload record initialization to
 ->get_record implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127423.2212320.9687834052007361387.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6dfeb0c2ecde71d61af77f65eabbdd6ca9315161

When we're performing a bulk load of a btree, move the code that
actually stores the btree record in the new btree block out of the
generic code and into the individual ->get_record implementations.
This is preparation for being able to store multiple records with a
single indirect call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/libxfs_api_defs.h   |    1 +
 libxfs/xfs_btree_staging.c |   17 ++++++-------
 libxfs/xfs_btree_staging.h |   15 ++++++++----
 repair/agbtree.c           |   56 +++++++++++++++++++++++++++++++++-----------
 4 files changed, 60 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1828e4773555..7c055e8aa61e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -53,6 +53,7 @@
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_rec_addr		libxfs_btree_rec_addr
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index be0b43e45f52..a6f0d7d3b286 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -440,22 +440,19 @@ STATIC int
 xfs_btree_bload_leaf(
 	struct xfs_btree_cur		*cur,
 	unsigned int			recs_this_block,
-	xfs_btree_bload_get_record_fn	get_record,
+	xfs_btree_bload_get_records_fn	get_records,
 	struct xfs_btree_block		*block,
 	void				*priv)
 {
-	unsigned int			j;
+	unsigned int			j = 1;
 	int				ret;
 
 	/* Fill the leaf block with records. */
-	for (j = 1; j <= recs_this_block; j++) {
-		union xfs_btree_rec	*block_rec;
-
-		ret = get_record(cur, priv);
-		if (ret)
+	while (j <= recs_this_block) {
+		ret = get_records(cur, j, block, recs_this_block - j + 1, priv);
+		if (ret < 0)
 			return ret;
-		block_rec = xfs_btree_rec_addr(cur, j, block);
-		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+		j += ret;
 	}
 
 	return 0;
@@ -798,7 +795,7 @@ xfs_btree_bload(
 		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
 				nr_this_block);
 
-		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
+		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_records,
 				block, priv);
 		if (ret)
 			goto out;
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index 5f638f711246..bd5b3f004823 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -47,7 +47,9 @@ void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		int whichfork, const struct xfs_btree_ops *ops);
 
 /* Bulk loading of staged btrees. */
-typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
+typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
+		unsigned int idx, struct xfs_btree_block *block,
+		unsigned int nr_wanted, void *priv);
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
@@ -55,11 +57,14 @@ typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
 
 struct xfs_btree_bload {
 	/*
-	 * This function will be called nr_records times to load records into
-	 * the btree.  The function does this by setting the cursor's bc_rec
-	 * field in in-core format.  Records must be returned in sort order.
+	 * This function will be called to load @nr_wanted records into the
+	 * btree.  The implementation does this by setting the cursor's bc_rec
+	 * field in in-core format and using init_rec_from_cur to set the
+	 * records in the btree block.  Records must be returned in sort order.
+	 * The function must return the number of records loaded or the usual
+	 * negative errno.
 	 */
-	xfs_btree_bload_get_record_fn	get_record;
+	xfs_btree_bload_get_records_fn	get_records;
 
 	/*
 	 * This function will be called nr_blocks times to obtain a pointer
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 7211765d3d32..10a0c7e48c9a 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -209,18 +209,25 @@ get_bno_rec(
 
 /* Grab one bnobt record and put it in the btree cursor. */
 static int
-get_bnobt_record(
+get_bnobt_records(
 	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
 	void				*priv)
 {
 	struct bt_rebuild		*btr = priv;
 	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
+	union xfs_btree_rec		*block_rec;
 
 	btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
 	arec->ar_startblock = btr->bno_rec->ex_startblock;
 	arec->ar_blockcount = btr->bno_rec->ex_blockcount;
 	btr->freeblks += btr->bno_rec->ex_blockcount;
-	return 0;
+
+	block_rec = libxfs_btree_rec_addr(cur, idx, block);
+	cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	return 1;
 }
 
 void
@@ -247,10 +254,10 @@ init_freespace_cursors(
 	btr_cnt->cur = libxfs_allocbt_stage_cursor(sc->mp,
 			&btr_cnt->newbt.afake, pag, XFS_BTNUM_CNT);
 
-	btr_bno->bload.get_record = get_bnobt_record;
+	btr_bno->bload.get_records = get_bnobt_records;
 	btr_bno->bload.claim_block = rebuild_claim_block;
 
-	btr_cnt->bload.get_record = get_bnobt_record;
+	btr_cnt->bload.get_records = get_bnobt_records;
 	btr_cnt->bload.claim_block = rebuild_claim_block;
 
 	/*
@@ -371,13 +378,17 @@ get_ino_rec(
 
 /* Grab one inobt record. */
 static int
-get_inobt_record(
+get_inobt_records(
 	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
 	void				*priv)
 {
 	struct bt_rebuild		*btr = priv;
 	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
 	struct ino_tree_node		*ino_rec;
+	union xfs_btree_rec		*block_rec;
 	int				inocnt = 0;
 	int				finocnt = 0;
 	int				k;
@@ -431,7 +442,10 @@ get_inobt_record(
 		btr->first_agino = ino_rec->ino_startnum;
 	btr->freecount += finocnt;
 	btr->count += inocnt;
-	return 0;
+
+	block_rec = libxfs_btree_rec_addr(cur, idx, block);
+	cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	return 1;
 }
 
 /* Initialize both inode btree cursors as needed. */
@@ -490,7 +504,7 @@ init_ino_cursors(
 	btr_ino->cur = libxfs_inobt_stage_cursor(pag, &btr_ino->newbt.afake,
 			XFS_BTNUM_INO);
 
-	btr_ino->bload.get_record = get_inobt_record;
+	btr_ino->bload.get_records = get_inobt_records;
 	btr_ino->bload.claim_block = rebuild_claim_block;
 	btr_ino->first_agino = NULLAGINO;
 
@@ -510,7 +524,7 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 	btr_fino->cur = libxfs_inobt_stage_cursor(pag,
 			&btr_fino->newbt.afake, XFS_BTNUM_FINO);
 
-	btr_fino->bload.get_record = get_inobt_record;
+	btr_fino->bload.get_records = get_inobt_records;
 	btr_fino->bload.claim_block = rebuild_claim_block;
 	btr_fino->first_agino = NULLAGINO;
 
@@ -560,16 +574,23 @@ _("Error %d while creating finobt btree for AG %u.\n"), error, agno);
 
 /* Grab one rmap record. */
 static int
-get_rmapbt_record(
+get_rmapbt_records(
 	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
 	void				*priv)
 {
 	struct xfs_rmap_irec		*rec;
 	struct bt_rebuild		*btr = priv;
+	union xfs_btree_rec		*block_rec;
 
 	rec = pop_slab_cursor(btr->slab_cursor);
 	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
-	return 0;
+
+	block_rec = libxfs_btree_rec_addr(cur, idx, block);
+	cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	return 1;
 }
 
 /* Set up the rmap rebuild parameters. */
@@ -589,7 +610,7 @@ init_rmapbt_cursor(
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr);
 	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, pag);
 
-	btr->bload.get_record = get_rmapbt_record;
+	btr->bload.get_records = get_rmapbt_records;
 	btr->bload.claim_block = rebuild_claim_block;
 
 	/* Compute how many blocks we'll need. */
@@ -631,16 +652,23 @@ _("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 
 /* Grab one refcount record. */
 static int
-get_refcountbt_record(
+get_refcountbt_records(
 	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
 	void				*priv)
 {
 	struct xfs_refcount_irec	*rec;
 	struct bt_rebuild		*btr = priv;
+	union xfs_btree_rec		*block_rec;
 
 	rec = pop_slab_cursor(btr->slab_cursor);
 	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
-	return 0;
+
+	block_rec = libxfs_btree_rec_addr(cur, idx, block);
+	cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	return 1;
 }
 
 /* Set up the refcount rebuild parameters. */
@@ -661,7 +689,7 @@ init_refc_cursor(
 	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
 			pag);
 
-	btr->bload.get_record = get_refcountbt_record;
+	btr->bload.get_records = get_refcountbt_records;
 	btr->bload.claim_block = rebuild_claim_block;
 
 	/* Compute how many blocks we'll need. */

