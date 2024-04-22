Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE194153BF8
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803998; cv=none; b=e1ljrSARUs/NmlFHPSxZUWnKGHY16FEmXBvRIFnJnANOyqG4/MAdEYSxCYKGKqtWVb22eH0HCzA5WrzuemVPnJywDQMJ7O4A14HnSSDjB7pGpptu2oE9meIsuQVwn2o9X4ecQFoNW3Z4966QcfqLb8RT0MRcGeAtBvNh9S5mGfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803998; c=relaxed/simple;
	bh=Mxuhz5gLmUJbK8WQX2dFBEdFld+GGPAt5PoWfk70KSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBUfkTD0dpehQtuxvPJpHiHB3DvYRNKQDTnnU9YBAbgw33oSPIT+2QLKrJOuTT0Q2zQris6Tugcbp5jFzue2tQ2nC4wlAZ4IsG9zmm1d1PHvurpETzcfH8XdC+0D6q5Z9ERD0V+3NuLvKRXcHdFXgH8GMwjNiuj3wmE4GxKlbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJa/yl4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJa/yl4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59E3C32783;
	Mon, 22 Apr 2024 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803998;
	bh=Mxuhz5gLmUJbK8WQX2dFBEdFld+GGPAt5PoWfk70KSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJa/yl4jLuqgAMgT6t3bMz9IaEX3GPk2IHHLEPou+rlqLELDdR4knXiwFJJZLSsCe
	 yQLEJPtND7HsD+E7Hf7DLH068frPoRDIjA6T81QgU9a0Nc7BVxdYQ5SJvKBQa5Kkbx
	 CpaHG4ZIyveFyvIjP/Kd51ksIlC8dEzFrrdo9zxynHUAD+UCvuH22PXURibQfQHds1
	 7AiCh0ueTWxiTrPNIr4fIw4yRCrXpnObxD5JsIxyXFcenfO4299ClMNSYZT0tY0pr/
	 ny7bbYhaqw8s+w6AOHiBCUzsva2pY33GqRARRu5Lu9NOrrqweVboPF89t0penb6cEp
	 EDhXhZ3kFs6rA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 33/67] xfs: constrain dirty buffers while formatting a staged btree
Date: Mon, 22 Apr 2024 18:25:55 +0200
Message-ID: <20240422163832.858420-35-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: e069d549705e49841247acf9b3176744e27d5425

Constrain the number of dirty buffers that are locked by the btree
staging code at any given time by establishing a threshold at which we
put them all on the delwri queue and push them to disk.  This limits
memory consumption while writing out new btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.c | 50 +++++++++++++++++++++++++++++---------
 libxfs/xfs_btree_staging.h | 10 ++++++++
 repair/agbtree.c           |  1 +
 3 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index a6f0d7d3b..d4164e37b 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -333,24 +333,41 @@ xfs_btree_commit_ifakeroot(
 /*
  * Put a btree block that we're loading onto the ordered list and release it.
  * The btree blocks will be written to disk when bulk loading is finished.
+ * If we reach the dirty buffer threshold, flush them to disk before
+ * continuing.
  */
-static void
+static int
 xfs_btree_bload_drop_buf(
-	struct list_head	*buffers_list,
-	struct xfs_buf		**bpp)
+	struct xfs_btree_bload		*bbl,
+	struct list_head		*buffers_list,
+	struct xfs_buf			**bpp)
 {
-	if (*bpp == NULL)
-		return;
+	struct xfs_buf			*bp = *bpp;
+	int				error;
+
+	if (!bp)
+		return 0;
 
 	/*
 	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
 	 * xfs_buf_read will not pointlessly reread the contents from the disk.
 	 */
-	(*bpp)->b_flags |= XBF_DONE;
+	bp->b_flags |= XBF_DONE;
 
-	xfs_buf_delwri_queue_here(*bpp, buffers_list);
-	xfs_buf_relse(*bpp);
+	xfs_buf_delwri_queue_here(bp, buffers_list);
+	xfs_buf_relse(bp);
 	*bpp = NULL;
+	bbl->nr_dirty++;
+
+	if (!bbl->max_dirty || bbl->nr_dirty < bbl->max_dirty)
+		return 0;
+
+	error = xfs_buf_delwri_submit(buffers_list);
+	if (error)
+		return error;
+
+	bbl->nr_dirty = 0;
+	return 0;
 }
 
 /*
@@ -422,7 +439,10 @@ xfs_btree_bload_prep_block(
 	 */
 	if (*blockp)
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
-	xfs_btree_bload_drop_buf(buffers_list, bpp);
+
+	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
+	if (ret)
+		return ret;
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
@@ -770,6 +790,7 @@ xfs_btree_bload(
 	cur->bc_nlevels = bbl->btree_height;
 	xfs_btree_set_ptr_null(cur, &child_ptr);
 	xfs_btree_set_ptr_null(cur, &ptr);
+	bbl->nr_dirty = 0;
 
 	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
 			&avg_per_block, &blocks, &blocks_with_extra);
@@ -808,7 +829,10 @@ xfs_btree_bload(
 			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
 	}
 	total_blocks += blocks;
-	xfs_btree_bload_drop_buf(&buffers_list, &bp);
+
+	ret = xfs_btree_bload_drop_buf(bbl, &buffers_list, &bp);
+	if (ret)
+		goto out;
 
 	/* Populate the internal btree nodes. */
 	for (level = 1; level < cur->bc_nlevels; level++) {
@@ -850,7 +874,11 @@ xfs_btree_bload(
 				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
 		}
 		total_blocks += blocks;
-		xfs_btree_bload_drop_buf(&buffers_list, &bp);
+
+		ret = xfs_btree_bload_drop_buf(bbl, &buffers_list, &bp);
+		if (ret)
+			goto out;
+
 		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
 	}
 
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index bd5b3f004..f0a500728 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -112,6 +112,16 @@ struct xfs_btree_bload {
 	 * height of the new btree.
 	 */
 	unsigned int			btree_height;
+
+	/*
+	 * Flush the new btree block buffer list to disk after this many blocks
+	 * have been formatted.  Zero prohibits writing any buffers until all
+	 * blocks have been formatted.
+	 */
+	uint16_t			max_dirty;
+
+	/* Number of dirty buffers. */
+	uint16_t			nr_dirty;
 };
 
 int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 10a0c7e48..981d8e340 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -23,6 +23,7 @@ init_rebuild(
 	memset(btr, 0, sizeof(struct bt_rebuild));
 
 	bulkload_init_ag(&btr->newbt, sc, oinfo);
+	btr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	bulkload_estimate_ag_slack(sc, &btr->bload, est_agfreeblocks);
 }
 
-- 
2.44.0

