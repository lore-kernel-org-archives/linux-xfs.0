Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9852EC7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 13:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbjEZNNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 09:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjEZNNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 09:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37DB12C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 06:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D65363963
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 13:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07296C433EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685106825;
        bh=SSrzlg0Iv0drphf7vXiHmy+fbbAqaz7qKdX31ITMc2c=;
        h=From:To:Subject:Date:From;
        b=Is5BFPQqqxvE4M+ijSBIYoFME1APBxgbJtXXuqoKLITB2hPC6h0Kt+5ExHZAQMA6x
         Ws/5YipkWYV4Hh10CufM+3BPb3bsjg2HO6Jss+Qvy1gdVD9Skbk2MzGVBMfiuIk4dx
         pWq/fGnqQzZT8+ag7hVpTmEjkg4+mrUb7P35h8gYARJiJEXiOD2P7dMP+h+F6+H+VJ
         OAxz1h8fEwS/3AM1WM8vqkkHi9ed8rI8hSI4UVMSIEMGVKZgLUGFPzgi1YCnqV7fYp
         6LZDx7N54egowZrvfseDPgCK/uJhoAhUeod9xqrIsCVeBw4p0b/eI9uz73YSiPMM7o
         cquYkrCW0csUA==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: Finish renaming xfs_extent_item variables
Date:   Fri, 26 May 2023 15:13:38 +0200
Message-Id: <20230526131338.114548-1-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Finish renaming xfs_extent_free_item variables to xefi on file
libxfs/defer_item.c, because the maintainer overlooked this file while
pulling changes from kernel commit 578c714b215d474c52949e65a914dae67924f0fe.

Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/defer_item.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b95b54e52..285dc9a35 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -80,18 +80,18 @@ xfs_extent_free_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_owner_info		oinfo = { };
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	int				error;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	oinfo.oi_owner = free->xefi_owner;
-	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	oinfo.oi_owner = xefi->xefi_owner;
+	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
-	error = xfs_free_extent(tp, free->xefi_startblock,
-		free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	error = xfs_free_extent(tp, xefi->xefi_startblock,
+		xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
@@ -107,10 +107,10 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -134,25 +134,25 @@ xfs_agfl_free_finish_item(
 {
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	struct xfs_buf			*agbp;
 	struct xfs_perag		*pag;
 	int				error;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	ASSERT(free->xefi_blockcount == 1);
-	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
-	oinfo.oi_owner = free->xefi_owner;
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	ASSERT(xefi->xefi_blockcount == 1);
+	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
+	oinfo.oi_owner = xefi->xefi_owner;
 
 	pag = libxfs_perag_get(mp, agno);
 	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 	if (!error)
 		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
 	libxfs_perag_put(pag);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
-- 
2.30.2

