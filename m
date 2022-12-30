Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85360C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiL3Wdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiL3Wdr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:33:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1691D0F4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7AAB0CE19B9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73ECC433EF;
        Fri, 30 Dec 2022 22:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439622;
        bh=x/1U3PbThAmnIoxkBIvMQ8ptkeoAc5ciPNSNJyiS/vA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jb42k1QB8JzXmXr9FyzomjU/2CXA83lc+2q35KjIsSjTuwfbjKi8oq0dxZ6hJ21Mx
         omlbKcNexj+j85e00Y5ae80asx6qCf3b1AWHGbzEQnL3/oxRGfJEdXgH/hXkLN6eSp
         9ZwFX0tpa7b5UjN3c3IioZWZMW0zEC0KPU7dLQbX4ucWLb3bsriJRDNMkJ/dbdNVgG
         Y31hoW+G9czYnEu5P1m2QW9syRT7Bu434LJ0IyPURz1KvuD4l9oxNoMtJbT0sIWkLM
         UayUxFJEOllT//ohVBD0tf6N/o/bllpyLwWkkdnQCdAf8inWJKkaBwlBG7TGJIIGWK
         PpjqrGZHpwbVA==
Subject: [PATCH 3/8] xfs: pass xfs_extent_free_item directly through the log
 intent code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825705.683219.9898603770353328011.stgit@magnolia>
In-Reply-To: <167243825653.683219.11053689306747459204.stgit@magnolia>
References: <167243825653.683219.11053689306747459204.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass the incore xfs_extent_free_item through the EFI logging code
instead of repeatedly boxing and unboxing parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   55 +++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d5130d1fcfae..618d2f9ff535 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -345,23 +345,30 @@ static int
 xfs_trans_free_extent(
 	struct xfs_trans		*tp,
 	struct xfs_efd_log_item		*efdp,
-	xfs_fsblock_t			start_block,
-	xfs_extlen_t			ext_len,
-	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
+	struct xfs_extent_free_item	*free)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
 	uint				next_extent;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, start_block);
+	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
+							free->xefi_startblock);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-								start_block);
+							free->xefi_startblock);
 	int				error;
 
-	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
+	oinfo.oi_owner = free->xefi_owner;
+	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
-	error = __xfs_free_extent(tp, start_block, ext_len,
-				  oinfo, XFS_AG_RESV_NONE, skip_discard);
+	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
+			free->xefi_blockcount);
+
+	error = __xfs_free_extent(tp, free->xefi_startblock,
+			free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+			free->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -375,8 +382,8 @@ xfs_trans_free_extent(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = start_block;
-	extp->ext_len = ext_len;
+	extp->ext_start = free->xefi_startblock;
+	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
 	return error;
@@ -463,20 +470,12 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_owner_info		oinfo = { };
 	struct xfs_extent_free_item	*free;
 	int				error;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	oinfo.oi_owner = free->xefi_owner;
-	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
-	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
-			free->xefi_startblock,
-			free->xefi_blockcount,
-			&oinfo, free->xefi_flags & XFS_EFI_SKIP_DISCARD);
+
+	error = xfs_trans_free_extent(tp, EFD_ITEM(done), free);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -599,7 +598,6 @@ xfs_efi_item_recover(
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
-	struct xfs_extent		*extp;
 	int				i;
 	int				error = 0;
 
@@ -624,10 +622,17 @@ xfs_efi_item_recover(
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+		struct xfs_extent_free_item	fake = {
+			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
+		};
+		struct xfs_extent		*extp;
+
 		extp = &efip->efi_format.efi_extents[i];
-		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len,
-					      &XFS_RMAP_OINFO_ANY_OWNER, false);
+
+		fake.xefi_startblock = extp->ext_start;
+		fake.xefi_blockcount = extp->ext_len;
+
+		error = xfs_trans_free_extent(tp, efdp, &fake);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));

