Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEF7C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 15:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbjFIPO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 11:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241269AbjFIPOZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 11:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9DA2D48
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 08:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EA7658F5
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 15:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FFC4339B;
        Fri,  9 Jun 2023 15:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686323660;
        bh=PCOQGsF+CewGsTxDpdiDeXGrQahLehyVb24NgbRShO4=;
        h=Date:From:To:Cc:Subject:From;
        b=mhinQBF7BEZ9FdBhOlGpNYlQqDUZZPb425MIITF7Xmk0hEhK3JYfKow9PB1FMHJUF
         QhE385Gp4VjZHqw1h6esuE5br9x7b8qI20UXxqvFM6qYNjM8SnPv07VEsCdJVNWnUk
         WXmdNjYEE02fisSaKp/zHNCQhdzeUrSC/9R65+GoRm+AHppQ4gXe6kwsNk3k0IpZrW
         cjr5RIeKkHPE2VLiJVklIMCdOcyhHaKMXjtRcX3U9EgIM9i3Ep0e5KhiWt46CBwt/a
         lIBe7DE+wScltrp5O7jtil/3CyHBl97wWgvEtTaLoXLC5Ru4uzcCUltx3cuPF+XxMl
         HBednW38YpFmQ==
Date:   Fri, 9 Jun 2023 08:14:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: deferred items should call xfs_perag_intent_{get,put}
Message-ID: <20230609151420.GZ1325469@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the intent item _get_group and _put_group functions call
xfs_perag_intent_{get,put} to match the kernel.  In userspace they're
the same thing so this makes no difference.  However, let's not leave
unnecessary discrepancies with the kernel code.

Fixes: 7cb26322f74 ("xfs: allow queued AG intents to drain before scrubbing")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index dc00d6d671d..6c5c7dd5677 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -70,7 +70,7 @@ xfs_extent_free_create_done(
 	return NULL;
 }
 
-/* Take a passive ref to the AG containing the space we're freeing. */
+/* Take an active ref to the AG containing the space we're freeing. */
 void
 xfs_extent_free_get_group(
 	struct xfs_mount		*mp,
@@ -79,15 +79,15 @@ xfs_extent_free_get_group(
 	xfs_agnumber_t			agno;
 
 	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
-	xefi->xefi_pag = xfs_perag_get(mp, agno);
+	xefi->xefi_pag = xfs_perag_intent_get(mp, agno);
 }
 
-/* Release a passive AG ref after some freeing work. */
+/* Release an active AG ref after some freeing work. */
 static inline void
 xfs_extent_free_put_group(
 	struct xfs_extent_free_item	*xefi)
 {
-	xfs_perag_put(xefi->xefi_pag);
+	xfs_perag_intent_put(xefi->xefi_pag);
 }
 
 /* Process a free extent. */
@@ -104,6 +104,7 @@ xfs_extent_free_finish_item(
 	int				error;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+
 	oinfo.oi_owner = xefi->xefi_owner;
 	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
@@ -166,6 +167,7 @@ xfs_agfl_free_finish_item(
 	xfs_agblock_t			agbno;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+
 	ASSERT(xefi->xefi_blockcount == 1);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
@@ -232,7 +234,7 @@ xfs_rmap_update_create_done(
 	return NULL;
 }
 
-/* Take a passive ref to the AG containing the space we're rmapping. */
+/* Take an active ref to the AG containing the space we're rmapping. */
 void
 xfs_rmap_update_get_group(
 	struct xfs_mount	*mp,
@@ -241,15 +243,15 @@ xfs_rmap_update_get_group(
 	xfs_agnumber_t	agno;
 
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
-	ri->ri_pag = xfs_perag_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, agno);
 }
 
-/* Release a passive AG ref after finishing rmapping work. */
+/* Release an active AG ref after finishing rmapping work. */
 static inline void
 xfs_rmap_update_put_group(
 	struct xfs_rmap_intent	*ri)
 {
-	xfs_perag_put(ri->ri_pag);
+	xfs_perag_intent_put(ri->ri_pag);
 }
 
 /* Process a deferred rmap update. */
@@ -344,7 +346,7 @@ xfs_refcount_update_create_done(
 	return NULL;
 }
 
-/* Take a passive ref to the AG containing the space we're refcounting. */
+/* Take an active ref to the AG containing the space we're refcounting. */
 void
 xfs_refcount_update_get_group(
 	struct xfs_mount		*mp,
@@ -353,15 +355,15 @@ xfs_refcount_update_get_group(
 	xfs_agnumber_t			agno;
 
 	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
-	ri->ri_pag = xfs_perag_get(mp, agno);
+	ri->ri_pag = xfs_perag_intent_get(mp, agno);
 }
 
-/* Release a passive AG ref after finishing refcounting work. */
+/* Release an active AG ref after finishing refcounting work. */
 static inline void
 xfs_refcount_update_put_group(
 	struct xfs_refcount_intent	*ri)
 {
-	xfs_perag_put(ri->ri_pag);
+	xfs_perag_intent_put(ri->ri_pag);
 }
 
 /* Process a deferred refcount update. */
@@ -461,7 +463,7 @@ xfs_bmap_update_create_done(
 	return NULL;
 }
 
-/* Take a passive ref to the AG containing the space we're mapping. */
+/* Take an active ref to the AG containing the space we're mapping. */
 void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
@@ -470,15 +472,23 @@ xfs_bmap_update_get_group(
 	xfs_agnumber_t		agno;
 
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
-	bi->bi_pag = xfs_perag_get(mp, agno);
+
+	/*
+	 * Bump the intent count on behalf of the deferred rmap and refcount
+	 * intent items that that we can queue when we finish this bmap work.
+	 * This new intent item will bump the intent count before the bmap
+	 * intent drops the intent count, ensuring that the intent count
+	 * remains nonzero across the transaction roll.
+	 */
+	bi->bi_pag = xfs_perag_intent_get(mp, agno);
 }
 
-/* Release a passive AG ref after finishing mapping work. */
+/* Release an active AG ref after finishing mapping work. */
 static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
-	xfs_perag_put(bi->bi_pag);
+	xfs_perag_intent_put(bi->bi_pag);
 }
 
 /* Process a deferred rmap update. */
