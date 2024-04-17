Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6E8F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389423; cv=none; b=YjuV6TxNWe7bVgI/w8JWqqXE6Wiy8qP+5WL0q7ewXcQht24GCrSgByrS/VykiEMcIb3A/eSznDW0Bz0AxVyPdjgpQRHgy0yY5UlOEFHQxbFl0n+V3MJXj7lpbUs9MTpndIBN0/9sX2LYjKt+tSp80p/mFVwMr66q23T0kZE+l2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389423; c=relaxed/simple;
	bh=bFjH2yBiJDTrejT+uE1wltpsrJuxV3xC+mxbjboOvFY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPqOcdJCH5C8TuTS7q5bX6aG72J6l1BRhjp6ZHuOZUgjdoAEWAKCyM3xVRDt3JiSZr6aSt36ntcUlApJaz7zP8AhLYDHlMX6Q5+3SXbbtpf+JfUKw3jiEFKXmZzSyk7UwX7ksr72G4grjxQWHajVsS0TalVv5t9js57Z2eLTaqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUf0swgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUf0swgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB6C072AA;
	Wed, 17 Apr 2024 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389423;
	bh=bFjH2yBiJDTrejT+uE1wltpsrJuxV3xC+mxbjboOvFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rUf0swgiR6Xc27E94C6i77FujN4V1x4WP18PmfosxyQWHbB9AZwmCxaQM35EfwEyJ
	 JKJrlv57JVbWFMJNhtNMuKH1+8a9lFsSCpfy0whKF0ZA+VmTPyi9Y7JwP1wT2yxKwe
	 gXoGJ7P89T55TjiLOm+FEizwtCjZv9Wx9ZQTod9VF3Vuo5D1SeUfYaQtcVsyrnYcZr
	 Y7A6s4EcUBCYPtjf6EaUFkS7kWBDTHiw9BIPVmallohVkE4u3nuLsQGU1TG7o7Yjba
	 BQ1CdHT0RK93BUBYjPoOHS01YgFOH28qsgjQhzcnRGt/B6cf/oJbW4sQXFkm9D8yb3
	 zbhK7NxcEuywg==
Date: Wed, 17 Apr 2024 14:30:23 -0700
Subject: [PATCH 33/67] xfs: constrain dirty buffers while formatting a staged
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842836.1853449.16278424624863880338.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
 

