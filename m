Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0485EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB22060EFE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhJSSyo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234715AbhJSSym (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758CD60E90;
        Tue, 19 Oct 2021 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669549;
        bh=ZjhNlOLGMIYBKBI6Ojhm00FnV9lgg0okqTosE9lEWc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D9bOavzfOEHlhFNBl96IEPgWIH+FWwq8KKqj4yTXaB6ITGT8yg5B0rpxymv2xiQYm
         BZuUrj8FbbufKbP8R1L9V1wWbJ6wXWLfloddmCUZKyCsAwDW7pB9WxPrEKmuw93qMZ
         lmxp4jEC3vBH2m94RJ7wyYSrurNb559hNMagH5gKdGDADgU9oSxRHXaCWEjbL0hTnN
         X2oFZ+nppr4S8bjCn/Ote8eFiRkuLpbb1eykMasspaVYwP/gt9gbZRVKedccWWrWMR
         V4nCIWWgAWlUv6DCfeEkrlWU+zI2ygAanpN7OgGcYDOg6ChC/qq1jMFYY0FQgn6qWl
         hHPK+s1vGimzA==
Subject: [PATCH 4/5] xfs: reduce the size of struct xfs_extent_free_item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:29 -0700
Message-ID: <163466954919.2235671.801665171595051864.stgit@magnolia>
In-Reply-To: <163466952709.2235671.6966476326124447013.stgit@magnolia>
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We only use EFIs to free metadata blocks -- not regular data/attr fork
extents.  Remove all the fields that we never use, for a net reduction
of 16 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   25 ++++++++++++++++---------
 fs/xfs/libxfs/xfs_alloc.h |    8 ++++++--
 fs/xfs/xfs_extfree_item.c |   13 ++++++++++---
 3 files changed, 32 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9bc1a03a8167..353e53b892e6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2462,12 +2462,11 @@ xfs_defer_agfl_block(
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_cache_alloc(xfs_extfree_item_cache,
+	new = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
-	new->xefi_oinfo = *oinfo;
-	new->xefi_skip_discard = false;
+	new->xefi_owner = oinfo->oi_owner;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
@@ -2505,15 +2504,23 @@ __xfs_free_extent_later(
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
 
-	new = kmem_cache_alloc(xfs_extfree_item_cache,
+	new = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
-	if (oinfo)
-		new->xefi_oinfo = *oinfo;
-	else
-		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	new->xefi_skip_discard = skip_discard;
+	if (skip_discard)
+		new->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+	if (oinfo) {
+		ASSERT(oinfo->oi_offset == 0);
+
+		if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+			new->xefi_flags |= XFS_EFI_ATTR_FORK;
+		if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+			new->xefi_flags |= XFS_EFI_BMBT_BLOCK;
+		new->xefi_owner = oinfo->oi_owner;
+	} else {
+		new->xefi_owner = XFS_RMAP_OWN_NULL;
+	}
 	trace_xfs_bmap_free_defer(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index b61aeb6fbe32..1c14a0b1abea 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -258,12 +258,16 @@ void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
  */
 struct xfs_extent_free_item {
 	struct list_head	xefi_list;
+	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	bool			xefi_skip_discard;
-	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
+	unsigned int		xefi_flags;
 };
 
+#define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
+#define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
+#define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
+
 static inline void
 xfs_free_extent_later(
 	struct xfs_trans		*tp,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index eb378e345f13..47ef9c9c5c17 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -474,14 +474,20 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_extent_free_item	*free;
 	int				error;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	oinfo.oi_owner = free->xefi_owner;
+	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
 			free->xefi_startblock,
 			free->xefi_blockcount,
-			&free->xefi_oinfo, free->xefi_skip_discard);
+			&oinfo, free->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -525,6 +531,7 @@ xfs_agfl_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
 	struct xfs_extent_free_item	*free;
@@ -539,13 +546,13 @@ xfs_agfl_free_finish_item(
 	ASSERT(free->xefi_blockcount == 1);
 	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+	oinfo.oi_owner = free->xefi_owner;
 
 	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
 
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (!error)
-		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
-					    &free->xefi_oinfo);
+		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the

