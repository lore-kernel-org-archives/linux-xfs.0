Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600E0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiL3Wfv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3Wfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:35:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0264125D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93EB161645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EDCC433D2;
        Fri, 30 Dec 2022 22:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439747;
        bh=lK7KjGVil2XUudLzb5KdbJTrm7hyRJ4YP61+8UJOeL4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ISAKScRr/+8zKzdzY/i4uYdg9tky2Tp62wveWjcznk6k8oMQLOtf1HZc0vClcDrig
         2s71MDUmWMyJS6ld/45CgZaXd1IjFskhElHvmHfZrYKHyVyzjzKdPOAvn/IdCftMoL
         NOxQpEZ1NKS9Um3eCpFmC7o+d24zDv6btwRmunrsOag8uXEiE/9ZIu/iYGS5a9ZXBz
         dq2DmCqJG/5VNLcV5k/PQ9skJRYabsHDxlfZ3vXHZ64BlfmZCZQ7DgeyNKbLeKFS/R
         cxDonXsa+Rt0+4LMFj1eg2/XwcMbfT9Fn8/Bfcba1Gxh0Bb5rAXomqqunmjg5ez913
         yJ6+syrFmyg9Q==
Subject: [PATCH 3/5] xfs: give xfs_extfree_intent its own perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:01 -0800
Message-ID: <167243826119.683449.7286941688538439664.stgit@magnolia>
In-Reply-To: <167243826070.683449.502057797810903920.stgit@magnolia>
References: <167243826070.683449.502057797810903920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Give the xfs_extfree_intent an active reference to the perag structure
data.  This reference will be used to enable scrub intent draining
functionality in subsequent patches.  Later, shrink will use these
active references to know if an AG is quiesced or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 ++++-
 fs/xfs/libxfs/xfs_alloc.h |    4 +++
 fs/xfs/xfs_extfree_item.c |   58 +++++++++++++++++++++++++++++----------------
 3 files changed, 47 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 79790c9e7de4..199f22ddc379 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2485,6 +2485,7 @@ xfs_defer_agfl_block(
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
+	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
 }
 
@@ -2501,8 +2502,8 @@ __xfs_free_extent_later(
 	bool				skip_discard)
 {
 	struct xfs_extent_free_item	*xefi;
-#ifdef DEBUG
 	struct xfs_mount		*mp = tp->t_mountp;
+#ifdef DEBUG
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 
@@ -2536,9 +2537,11 @@ __xfs_free_extent_later(
 	} else {
 		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
-	trace_xfs_bmap_free_defer(tp->t_mountp,
+	trace_xfs_bmap_free_defer(mp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
+
+	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 5074aed6dfad..f84f3966e849 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -226,9 +226,13 @@ struct xfs_extent_free_item {
 	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
+	struct xfs_perag	*xefi_pag;
 	unsigned int		xefi_flags;
 };
 
+void xfs_extent_free_get_group(struct xfs_mount *mp,
+		struct xfs_extent_free_item *xefi);
+
 #define XFS_EFI_SKIP_DISCARD	(1U << 0) /* don't issue discard */
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c1aae07467c9..8db9d9abb54a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -350,10 +350,7 @@ xfs_trans_free_extent(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
-	struct xfs_perag		*pag;
 	uint				next_extent;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
-							xefi->xefi_startblock);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
 							xefi->xefi_startblock);
 	int				error;
@@ -364,14 +361,12 @@ xfs_trans_free_extent(
 	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
-	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
-			xefi->xefi_blockcount);
+	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
+			agbno, xefi->xefi_blockcount);
 
-	pag = xfs_perag_get(mp, agno);
-	error = __xfs_free_extent(tp, pag, agbno, xefi->xefi_blockcount,
-			&oinfo, XFS_AG_RESV_NONE,
+	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
-	xfs_perag_put(pag);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -400,14 +395,13 @@ xfs_extent_free_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_mount		*mp = priv;
 	struct xfs_extent_free_item	*ra;
 	struct xfs_extent_free_item	*rb;
 
 	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
 	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->xefi_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->xefi_startblock);
+
+	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
 }
 
 /* Log a free extent to the intent item. */
@@ -466,6 +460,26 @@ xfs_extent_free_create_done(
 	return &xfs_trans_get_efd(tp, EFI_ITEM(intent), count)->efd_item;
 }
 
+/* Take an active ref to the AG containing the space we're freeing. */
+void
+xfs_extent_free_get_group(
+	struct xfs_mount		*mp,
+	struct xfs_extent_free_item	*xefi)
+{
+	xfs_agnumber_t			agno;
+
+	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
+	xefi->xefi_pag = xfs_perag_get(mp, agno);
+}
+
+/* Release an active AG ref after some freeing work. */
+static inline void
+xfs_extent_free_put_group(
+	struct xfs_extent_free_item	*xefi)
+{
+	xfs_perag_put(xefi->xefi_pag);
+}
+
 /* Process a free extent. */
 STATIC int
 xfs_extent_free_finish_item(
@@ -480,6 +494,8 @@ xfs_extent_free_finish_item(
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
+
+	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
@@ -500,6 +516,8 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*xefi;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+
+	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
@@ -530,24 +548,21 @@ xfs_agfl_free_finish_item(
 	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
 	int				error;
-	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	uint				next_extent;
-	struct xfs_perag		*pag;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 	ASSERT(xefi->xefi_blockcount == 1);
-	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
 
-	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, xefi->xefi_blockcount);
+	trace_xfs_agfl_free_deferred(mp, xefi->xefi_pag->pag_agno, 0, agbno,
+			xefi->xefi_blockcount);
 
-	pag = xfs_perag_get(mp, agno);
-	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
-		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
-	xfs_perag_put(pag);
+		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
+				agbno, agbp, &oinfo);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -566,6 +581,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
+	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
@@ -636,7 +652,9 @@ xfs_efi_item_recover(
 		fake.xefi_startblock = extp->ext_start;
 		fake.xefi_blockcount = extp->ext_len;
 
+		xfs_extent_free_get_group(mp, &fake);
 		error = xfs_trans_free_extent(tp, efdp, &fake);
+		xfs_extent_free_put_group(&fake);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));

