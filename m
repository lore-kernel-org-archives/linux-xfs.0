Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CADC4708E
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiL3XZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiL3XYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:24:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD8B1EAD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1B2B81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA605C433EF;
        Fri, 30 Dec 2022 23:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442636;
        bh=Cn3GD9xKEHhETzyCQTM2Fak4/oGtF4xSjct2duJZYYU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E3RinK6VPDtIlWPwT+bjmFpB4a5ZlWAEUmy2ulwy3qyafQCbr6sAAJTjsCE3Ji+VO
         EBeS7EbJPQKKAxqA83ZpWMqebG+FYiZuVqJNxI9VH6Xvdb4Lj6DPRmGaX8GkB/BwHO
         OvlTN4LI7Wu5Jj7SMMeENRAGTjklr94PYZUOLdlgKr7/OoX6wQhxe7MTvY+E3pc+q7
         I+ujgLR2dD3voZiE1dYrd2QKun+4nEc3Tw6VZoUfkZEwzPl/Zc08f5Y0fibmIp6Q4l
         fxbFMIC57RFO3fqXI9+7kUMXnhWxIfCGngsRkOZdNjYdVQn+6iV93HP64Gr0WT6Dg5
         eSCwmQleNe3sQ==
Subject: [PATCH 6/6] xfs: constrain dirty buffers while formatting a staged
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:31 -0800
Message-ID: <167243835193.692312.499795393915967728.stgit@magnolia>
In-Reply-To: <167243835101.692312.6690367712200502185.stgit@magnolia>
References: <167243835101.692312.6690367712200502185.stgit@magnolia>
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
index 99b79de7efcd..842a710e6c3b 100644
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
index a2aa36b23e25..2db03f0ae961 100644
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
index 369965cacc8c..6fd6ea8e6fbd 100644
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
index 82a3a8ef0f12..d2eaf4fdc603 100644
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
index 56c790fa0f9a..507137e7bc24 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -91,6 +91,7 @@ xrep_newbt_init_ag(
 	xnr->alloc_hint = alloc_hint;
 	xnr->resv = resv;
 	INIT_LIST_HEAD(&xnr->resv_list);
+	xnr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	xrep_newbt_estimate_slack(xnr);
 }
 

