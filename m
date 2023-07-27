Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8F7EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjG0WZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbjG0WZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:25:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D1A2D4D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7E3F61F5C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB04C433C7;
        Thu, 27 Jul 2023 22:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496720;
        bh=edHw4cOW5UU3E4AVP0OqgqlVio8nA0A0hPHYvUuRA54=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XMioFHmTO2/2jtJ2Ed8pXLTkbK/qvtfysPmXuqhQCHAMOF24cqJ4tqGWhd/jfw/Tp
         h5HTOMX/5OUBrtY7OYr0iF9gWmHx+TOEzmLV/wbAZsnAX3vOdNX2TCUVl6VLZ+B+G1
         0ixLkJfIwiVI3xz4ZjGjgSYZwnPMz4c8gzOnVGyDkOG2u5HOwwaVFQuugGDjZu3PwO
         0lYG+KIr/6YLdtVZjkWYZx/nFwlIIwxJBXBZATsmfb9dzZIxn+ABBGwvk6J2A+rALb
         PGfvb9MOjSjjTBI3A2LHV9K9apR6eUWsc9Ks2jdIrPebmAtIWki80CFmVYdNXQmzpy
         4o76Jnqhan1yw==
Date:   Thu, 27 Jul 2023 15:25:19 -0700
Subject: [PATCH 6/6] xfs: constrain dirty buffers while formatting a staged
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623261.921279.325810005467116401.stgit@frogsfrogsfrogs>
In-Reply-To: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
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
index adbc3ec1d4167..589d722f60b49 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -91,6 +91,7 @@ xrep_newbt_init_ag(
 	xnr->alloc_hint = alloc_hint;
 	xnr->resv = resv;
 	INIT_LIST_HEAD(&xnr->resv_list);
+	xnr->bload.max_dirty = XFS_B_TO_FSBT(sc->mp, 256U << 10); /* 256K */
 	xrep_newbt_estimate_slack(xnr);
 }
 

