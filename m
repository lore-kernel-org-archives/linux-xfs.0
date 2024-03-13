Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE51B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295299; cv=none; b=YIvy6pIVem9q4dyuAeEoQSVwEKcDsfCsAkaByTH/gxMJCAlG9IWaLJQ8dn+C+rDpbzdPidJeMfYLI7/mTcNUmgywMqiZN9I3iPStLZA8mYJJ5HFtV0jgnuni55yz937t0vAOtfL/iJFgyj4ZlEo4sL3hDISu3uFwq5ZXS93ArdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295299; c=relaxed/simple;
	bh=VtSZ2TzdaE00RcjWZI3SncWUw7Rb9INRWxOlmGmIgek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlIWD3KYdeopyrH693zmeyPcvk+a2hPiT5hko3Ei8VqFRMidnVMMATZ6UbET6vwbrcKP8Bikwz0AxzvVzAJX2/ZbIH0i/T4DZqTt+E7+2TjyJk+CH9Pz+C8OJVnyPBm7hv4BNU6zwjpea++MPOomVLLxSHOwkXnJDv9obnTL760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1e5WtiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1e5WtiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD473C433F1;
	Wed, 13 Mar 2024 02:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295298;
	bh=VtSZ2TzdaE00RcjWZI3SncWUw7Rb9INRWxOlmGmIgek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J1e5WtiU1GGaTZ0ClXLIygeq9dedjhHSl7T3hGj2YBG6JWk8ZwBla/bHgcb2/2o8k
	 2Key+hk5C7b5xnLTmmSASsAL4gZHEzzZR76fEmueh1m/wviBmLNgPPDXVlf8uVxaNP
	 UbTlK7Ji+ikzX9I8F+QrvId0UUkU4FqIOYe1wop0tikOF1lSfF2P2z2uEvreCtMlZv
	 XoEbtDH0Rd65t2R/uU/pJ4EdCACLt3nC4c9RD+M6I95D+Z1AP8HTK318JPKNzYfKvq
	 EO/fIdLHJCZ+N1gnSAh8elBK9CiVe2a+OBquxBvqP74rs1N6z2oYEfp/3y3wFdIw5M
	 a+78xiTdcfCZA==
Date: Tue, 12 Mar 2024 19:01:38 -0700
Subject: [PATCH 33/67] xfs: constrain dirty buffers while formatting a staged
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431670.2061787.13362373960946016966.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
 

