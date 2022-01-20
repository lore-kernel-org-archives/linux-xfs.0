Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01166C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357632AbiATA1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA1S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6306C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C442B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18417C004E1;
        Thu, 20 Jan 2022 00:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638435;
        bh=fAWy2s2hCAoAa/NfjC6pZJBjp/mgkOvHhOFPFu93Zmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cMEKrU13ZtahvsHVQhb0U8usIlYxNq+cGjUrU7qZJ3UNeOlT3haIj9Q1bKN029SC2
         9q6rmMa0cGA+4U6hmF4HpJls17XkabWRHMTnfyXV4Ljn8Vg+8dQcv/kd7HAYLCBdyF
         x17ivaKMIhj2lMeL2/57rCpPrtxmEvfrasGCnm0wiUxLYq0K1iZl0fccveKOV6nANm
         Ddcvhwvo8jnXAvAqE3Sox+WWrJ1mkx11lZh0Z7tVQBvy+KTrDKVug5OKGElcl2zExy
         LZI7S9iWQ4FledRUrZSdr0f7vkM5L2uCbnIcu6VtsDwftSdaPQxbwEaK10RZ3cxuoL
         OhXuwPtkzu6qQ==
Subject: [PATCH 44/48] xfs: reduce the size of struct xfs_extent_free_item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:14 -0800
Message-ID: <164263843473.865554.8468624471819753623.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b3b5ff412ab04afd99173bb12d3cc146ee478ae7

We only use EFIs to free metadata blocks -- not regular data/attr fork
extents.  Remove all the fields that we never use, for a net reduction
of 16 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   14 ++++++++++----
 libxfs/xfs_alloc.c  |   25 ++++++++++++++++---------
 libxfs/xfs_alloc.h  |    8 ++++++--
 3 files changed, 32 insertions(+), 15 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e7cba838..d82ce7e0 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -75,13 +75,18 @@ xfs_extent_free_finish_item(
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
 	error = xfs_free_extent(tp, free->xefi_startblock,
-			free->xefi_blockcount, &free->xefi_oinfo,
-			XFS_AG_RESV_NONE);
+			free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -123,6 +128,7 @@ xfs_agfl_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*free;
 	struct xfs_buf			*agbp;
@@ -134,11 +140,11 @@ xfs_agfl_free_finish_item(
 	ASSERT(free->xefi_blockcount == 1);
 	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+	oinfo.oi_owner = free->xefi_owner;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (!error)
-		error = xfs_free_agfl_block(tp, agno, agbno, agbp,
-					    &free->xefi_oinfo);
+		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index f1da8292..1d5aa67f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2458,12 +2458,11 @@ xfs_defer_agfl_block(
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
 
@@ -2501,15 +2500,23 @@ __xfs_free_extent_later(
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index b61aeb6f..1c14a0b1 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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

