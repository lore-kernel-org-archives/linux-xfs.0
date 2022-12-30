Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28D1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiLaAFs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAFr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:05:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33F76157
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CFB7B81DEC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB4C433EF;
        Sat, 31 Dec 2022 00:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445143;
        bh=lHuuOcQAfX93rEEltlP81qFlydyfE7z0taV6SqYbwAY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fj3geoTZFnG1uXMheTFCFjpEp7FNCSfJtZunqxtibkXYmZcdiFE95CSuNnm4O8NOO
         GWwl/al/nC+Pe05hqICdeUPzd6A/ATqmueNtX1GIhp5Y2W8vvOZlCEKBVUUJtAk6fD
         UTvqKhN029MigH7mNspVaawSMpDbcVXAKnDKPL22oZSw0rRwJmLYX5RJiY71t7LbJ1
         ddjKENvAVBUfjv+mVCSyEYWZ/D+tEKRIXb9ogJiUHyD3ifdd62GQ+xHpvkeZAIkqbO
         TnqwEA2lwIuLOnq8PgGP+wqdUlRlkVNLLmfq09kEGOQoLdQQHfI5Pg3nv2fvZjtFzm
         yniJDG1wkxZ7w==
Subject: [PATCH 3/5] xfs: move btree bulkload record initialization to
 ->get_record implementations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863943.707598.17620950198542269061.stgit@magnolia>
In-Reply-To: <167243863904.707598.12385476439101029022.stgit@magnolia>
References: <167243863904.707598.12385476439101029022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're performing a bulk load of a btree, move the code that
actually stores the btree record in the new btree block out of the
generic code and into the individual ->get_record implementations.
This is preparation for being able to store multiple records with a
single indirect call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h   |    1 +
 libxfs/xfs_btree_staging.c |   17 ++++++-------
 libxfs/xfs_btree_staging.h |   15 ++++++++----
 repair/agbtree.c           |   56 +++++++++++++++++++++++++++++++++-----------
 4 files changed, 60 insertions(+), 29 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index f8efcce777b..5aa9c019d40 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -50,6 +50,7 @@
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_rec_addr		libxfs_btree_rec_addr
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index baf7f422603..97fade90622 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -434,22 +434,19 @@ STATIC int
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
@@ -787,7 +784,7 @@ xfs_btree_bload(
 		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
 				nr_this_block);
 
-		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
+		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_records,
 				block, priv);
 		if (ret)
 			goto out;
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index d6dea3f0088..82a3a8ef0f1 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -50,7 +50,9 @@ void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		int whichfork, const struct xfs_btree_ops *ops);
 
 /* Bulk loading of staged btrees. */
-typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
+typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
+		unsigned int idx, struct xfs_btree_block *block,
+		unsigned int nr_wanted, void *priv);
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
@@ -58,11 +60,14 @@ typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
 
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
index 0fd7ef5d351..d90cbcc2f28 100644
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
 	btr_ino->cur = libxfs_inobt_stage_cursor(sc->mp, &btr_ino->newbt.afake,
 			pag, XFS_BTNUM_INO);
 
-	btr_ino->bload.get_record = get_inobt_record;
+	btr_ino->bload.get_records = get_inobt_records;
 	btr_ino->bload.claim_block = rebuild_claim_block;
 	btr_ino->first_agino = NULLAGINO;
 
@@ -510,7 +524,7 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 	btr_fino->cur = libxfs_inobt_stage_cursor(sc->mp,
 			&btr_fino->newbt.afake, pag, XFS_BTNUM_FINO);
 
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
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
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

