Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2012839F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422687; cv=none; b=T5nrUgV1P7qiOrPQfSSj6gxumINeEk4owTkjw6Xa1GWR8jzWc/icU1n3pBMv5gEDoE72fxuQcoKDo5XQgiy/KQ7yrDyi1I7jtX/G7/FVj4pWvXcQJQJOeRTn+l/o/nRUn1T3Kq28QVcILje13RIii8jwAPa0XWwQYSeyi/Ol8jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422687; c=relaxed/simple;
	bh=LhKeUmXctH9MlOGvLzl0pf9J2QRT/DOHRVlOxpDpBDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5w4/YmCFO5yHD5074y3wN4wQB6F3gA64AV8eQ7Rz/gTKPA9hJYYyeopahjMkdoQ5iA1WqZnEoFyZQwcYVv/6TVv6ZOTKU5Q4zrJtLyn6n5e3RP+4+B9EXKPn+UXyljZ/pjCJx1+wteDi0nwYsbYuOVM0HmJh7TW787u8ZunUlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUq0LYa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUq0LYa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A79EC433F1;
	Tue, 26 Mar 2024 03:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422687;
	bh=LhKeUmXctH9MlOGvLzl0pf9J2QRT/DOHRVlOxpDpBDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pUq0LYa3THXzSgp5MFeqQwWun3W70OVHFSlUOAhkk32B2zJfT6V8taDYqvcXta2K7
	 ajXEnvdIBeBmJA7BkDev3LQa0zohz5Rl2XViA4lXgi3hLS6ZoR4qfmsE3Kts5PfXhC
	 bByxPjg2gowmERTORTT6z35URJ+mb6ZL4iMeDtVyeodsHAFHE6r6lH3K7H7PLq3Cfo
	 PwQ4ua2wPK5aCzULrOl+wvUFasNYdZqfJXz8uINAXWgkl+21LgRdLmoI++w3FfM5w/
	 WYnGFCQo51uUsxcZd9M4UsOpNaFfyi5kJhvIGTyQhqgWTdeViW4/vQIT+xn0IulACC
	 xPg+k5yAlCLYA==
Date: Mon, 25 Mar 2024 20:11:26 -0700
Subject: [PATCH 33/67] xfs: constrain dirty buffers while formatting a staged
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127438.2212320.18400289264043900726.stgit@frogsfrogsfrogs>
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

Source kernel commit: e069d549705e49841247acf9b3176744e27d5425

Constrain the number of dirty buffers that are locked by the btree
staging code at any given time by establishing a threshold at which we
put them all on the delwri queue and push them to disk.  This limits
memory consumption while writing out new btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_btree_staging.c |   50 ++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_btree_staging.h |   10 +++++++++
 repair/agbtree.c           |    1 +
 3 files changed, 50 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index a6f0d7d3b286..d4164e37bd38 100644
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
index bd5b3f004823..f0a5007284ef 100644
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
index 10a0c7e48c9a..981d8e340bf2 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -23,6 +23,7 @@ init_rebuild(
 	memset(btr, 0, sizeof(struct bt_rebuild));
 
 	bulkload_init_ag(&btr->newbt, sc, oinfo);
+	btr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	bulkload_estimate_ag_slack(sc, &btr->bload, est_agfreeblocks);
 }
 

