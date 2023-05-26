Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3AAC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEZBKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZBKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9744125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4645660B88
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC436C433EF;
        Fri, 26 May 2023 01:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063434;
        bh=menHQRsZg3/XWdIkHgX7u9QYdyB6ONR/Hk6n6DxQPX4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=j6c8X8zuTrc/Ni2FTDVZykKKS333rWhFsDNRzGqfJowinBWcEfLXRWU4W+mWo3pdP
         yw+rUvS+s8TW2KWXMrD1OteB6PIPVaHgjTPAKeldBvFK2iS205BYVd03hBEGWZbhw2
         W5BU1KRQj9uBMOQRmr+UmLteKi9c5y4blVA/gRcnQr8UgVjFQuB3wElB/BBQ30uoH0
         BoeubLzBkcoFlciUDp0ngg008nyQ/vYWuHRzOkfurvTWrFWKTVn1CGP30C+4J8A7vZ
         LBL5BehQXP3coYxMiqdHi1EjuMW19leOZYvUvqyuP7tBzZpN5gwDvlDNPVqvkzQ0J9
         WBu3A79+ZP7Ug==
Date:   Thu, 25 May 2023 18:10:34 -0700
Subject: [PATCH 1/4] xfs: move lru refs to the btree ops structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063134.3733778.5150206064076755202.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063115.3733778.10696213835208138453.stgit@frogsfrogsfrogs>
References: <168506063115.3733778.10696213835208138453.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the btree buffer LRU refcount to the btree ops structure so that we
can eliminate the last bc_btnum switch in the generic btree code.  We're
about to create repair-specific btree types, and we don't want that
stuff cluttering up libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |   24 ++----------------------
 fs/xfs/libxfs/xfs_btree.h          |    3 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 ++
 7 files changed, 13 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 20bd1adfba78..698ccf36e072 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -457,6 +457,7 @@ xfs_allocbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -480,6 +481,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index c6b0993bde47..f9cee9bab8fe 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -512,6 +512,7 @@ xfs_bmbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.lru_refs		= XFS_BMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5af19610d891..4c8e9dd25b73 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1350,32 +1350,12 @@ xfs_btree_buf_to_ptr(
 	}
 }
 
-STATIC void
+static inline void
 xfs_btree_set_refs(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
-		break;
-	case XFS_BTNUM_INO:
-	case XFS_BTNUM_FINO:
-		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
-		break;
-	case XFS_BTNUM_BMAP:
-		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_RMAP:
-		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_REFC:
-		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
-		break;
-	default:
-		ASSERT(0);
-	}
+	xfs_buf_set_ref(bp, cur->bc_ops->lru_refs);
 }
 
 int
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7edf8f2b3240..f1b61e11322a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -120,6 +120,9 @@ struct xfs_btree_ops {
 	/* XFS_BTREE_* flags that determine the geometry of the btree */
 	unsigned int	geom_flags;
 
+	/* LRU refcount to set on each btree buffer created */
+	int	lru_refs;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 249049fa645b..da471ccc0a63 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -402,6 +402,7 @@ xfs_inobt_keys_contiguous(
 const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -424,6 +425,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 98e050647aa8..dfb4df6265e0 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -326,6 +326,7 @@ xfs_refcountbt_keys_contiguous(
 const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
+	.lru_refs		= XFS_REFC_BTREE_REF,
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ce4f05a476e9..a4656dd7c729 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -489,6 +489,7 @@ xfs_rmapbt_keys_contiguous(
 const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
@@ -613,6 +614,7 @@ static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
 static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
 				  XFS_BTREE_IN_XFILE,
 

