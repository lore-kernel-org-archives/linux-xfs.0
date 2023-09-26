Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D28E7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjI0ARC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjI0APC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:15:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBA24213
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:34:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183EDC433C8;
        Tue, 26 Sep 2023 23:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771240;
        bh=rqbYiDiAl3z02gbBixD/8Y6n+4pvPHKy5+HPyB2/FfY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h+D+UsGfiA3jKDC+ZgE4JTes5Npi84GPR6vcHYSvZMPNLoocxTMgsVD/Ffs7ZgtZN
         Fjd+IVbNnVg3LXQgy0kMLvR8cSYidT4N20KYaFd1PrqXHFVTWIzJAAbMfzbnALVukS
         GeoGCUvlXRiLBCEpAG5QJg9m6GhXHcUy2wKK5kR8FZJem5ov2VsvxpkMwXuxeNTNqP
         LMcADQXBL2cHO4elHx+fDSk11D/AessgwMz4ebxgcZsLCVNpbp/GeIWswrWfvmGCFA
         r9zkV5GTXk1jYc49hp6/ui7ry+sPMLznEcItLHPLoLnVoPYJBPFtxOMidNTPu3qkYS
         HyFrluqs07z2w==
Date:   Tue, 26 Sep 2023 16:33:59 -0700
Subject: [PATCH 4/4] xfs: constrain dirty buffers while formatting a staged
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059634.3313134.8316249027074233589.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059572.3313134.3407643746555317156.stgit@frogsfrogsfrogs>
References: <169577059572.3313134.3407643746555317156.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Constrain the number of dirty buffers that are locked by the btree
staging code at any given time by establishing a threshold at which we
put them all on the delwri queue and push them to disk.  This limits
memory consumption while writing out new btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c         |    2 +
 fs/xfs/libxfs/xfs_btree.h         |    3 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   50 +++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree_staging.h |   10 +++++++
 fs/xfs/scrub/newbt.c              |    1 +
 5 files changed, 54 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6a6503ab0cd76..c100e92140be1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1330,7 +1330,7 @@ xfs_btree_get_buf_block(
  * Read in the buffer at the given ptr and return the buffer and
  * the block pointer within the buffer.
  */
-STATIC int
+int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4d68a58be160c..e0875cec49392 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -700,6 +700,9 @@ void xfs_btree_set_ptr_null(struct xfs_btree_cur *cur,
 int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
 		struct xfs_buf **bpp);
+int xfs_btree_read_buf_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int flags,
+		struct xfs_btree_block **block, struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
 		int lr);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 369965cacc8c5..6fd6ea8e6fbd7 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -333,18 +333,35 @@ xfs_btree_commit_ifakeroot(
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
 
-	xfs_buf_delwri_queue_here(*bpp, buffers_list);
-	xfs_buf_relse(*bpp);
+	if (!bp)
+		return 0;
+
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
@@ -416,7 +433,10 @@ xfs_btree_bload_prep_block(
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
@@ -480,7 +500,7 @@ xfs_btree_bload_node(
 
 		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
 
-		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
+		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
 				&child_bp);
 		if (ret)
 			return ret;
@@ -759,6 +779,7 @@ xfs_btree_bload(
 	cur->bc_nlevels = bbl->btree_height;
 	xfs_btree_set_ptr_null(cur, &child_ptr);
 	xfs_btree_set_ptr_null(cur, &ptr);
+	bbl->nr_dirty = 0;
 
 	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
 			&avg_per_block, &blocks, &blocks_with_extra);
@@ -797,7 +818,10 @@ xfs_btree_bload(
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
@@ -839,7 +863,11 @@ xfs_btree_bload(
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
 
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index 82a3a8ef0f125..d2eaf4fdc6032 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -115,6 +115,16 @@ struct xfs_btree_bload {
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
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 2c388c647d37f..73e21a9e5e929 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -89,6 +89,7 @@ xrep_newbt_init_ag(
 	xnr->alloc_hint = alloc_hint;
 	xnr->resv = resv;
 	INIT_LIST_HEAD(&xnr->resv_list);
+	xnr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	xrep_newbt_estimate_slack(xnr);
 }
 

