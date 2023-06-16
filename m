Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33355EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjFPBhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F87294A
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0302061B41
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366B9C433C0;
        Fri, 16 Jun 2023 01:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879422;
        bh=lhvaQ8CsmoaVlMCWNV84JWkreaqq6CqZvwZWZ0JlIVc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pH2N0rGL4SmxKJ9AS3YTlg7IecYB1fPoSYg8oJekNlhAPrYe3L6AZgT54yE6S4NlS
         OcIq62FIaMqfDzJvvsppxVVGkH8Sut78/L9er7GeLeJE9tWQwPgDelMvtuQzle5ctP
         Ik+cKbjMOJUP0sC1GOi8frWGpKipfjYcWzs8CcIGgn4x58P5OwVJowDt3hSc6VMiSK
         XyCxG3fg6V5cw2Kp5dvW+VRhizV7/NQ8IjuqrjP0MLDFJjINyb3jAyHYjSto9beCZ8
         hD1SoPKIUvikbL7bvyjkhe0EsY1n/LPlDc99idnyRh/hWwJopMb7JtE6nQLggTnqVN
         icGCPl2+pOolg==
Subject: [PATCH 1/8] libxfs: deferred items should call
 xfs_perag_intent_{get,put}
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:01 -0700
Message-ID: <168687942165.831530.11916953464551186899.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the intent item _get_group and _put_group functions call
xfs_perag_intent_{get,put} to match the kernel.  In userspace they're
the same thing so this makes no difference.  However, let's not leave
unnecessary discrepancies.

Fixes: 7cb26322f74 ("xfs: allow queued AG intents to drain before scrubbing")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index dc00d6d6..6c5c7dd5 100644
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

