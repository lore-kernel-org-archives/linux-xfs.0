Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EA9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiLaAEq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiLaAEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB141E3E1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C2FB81DB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B2BC433EF;
        Sat, 31 Dec 2022 00:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445080;
        bh=0nt0A368Yczd78WdClNJXoCZr74mhwc9HZz2A5dNbuE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R9q/bRpQ0Of7vV/fInQUq5gVJ63n+vt3OINhdsa6vCdAm41xfa0q1ae1m2TPxVIQq
         RCEXGBi6Gr2ZVwCa3ZbO72QXQmWmx5W02kW+NqKoP3ctrmQd6WD7j+ljtzSemc7lPr
         e7wftVzQYZF14pcLk53p4pNWdTx1m8OgxSER42YJoFKQz3YJDPvPfR9db8twwTgfY9
         nRbEShELG+jHXwAuJMopd95np3pJMrI3+SfCMkJu5bM65TnIR0aBXe6Y6jcys09cDP
         YV/XvSHlGrTsPAuaNiuj4VCTnMWZEdgSxMbHrgSYwPxgKFnjYlcHqZDYrYMJ8T7h/q
         H5IFfPgu5E3Rw==
Subject: [PATCH 2/3] xfs: use b_offset to support direct-mapping pages when
 blocksize < pagesize
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:32 -0800
Message-ID: <167243847293.701196.6861685486317100169.stgit@magnolia>
In-Reply-To: <167243847260.701196.16973261353833975727.stgit@magnolia>
References: <167243847260.701196.16973261353833975727.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support using directly-mapped pages in the buffer cache when the fs
blocksize is less than the page size.  This is not strictly necessary
since the only user of direct-map buffers always uses page-sized
buffers, but I included it here for completeness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e00682cd8901..db3344a36f14 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -303,7 +303,7 @@ xfs_buf_free_direct_pages(
 	ASSERT(bp->b_target->bt_flags & XFS_BUFTARG_DIRECT_MAP);
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
 		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
@@ -336,7 +336,7 @@ xfs_buf_free_pages(
 	ASSERT(bp->b_flags & _XBF_PAGES);
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		if (bp->b_pages[i])
@@ -465,6 +465,8 @@ xfs_buf_alloc_pages(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
+
+	bp->b_offset = 0;
 	return 0;
 }
 
@@ -513,16 +515,32 @@ xfs_buf_alloc_direct_pages(
 	struct xfs_buf_map	*map;
 	gfp_t			gfp_mask = __GFP_NOWARN;
 	const unsigned int	page_align_mask = PAGE_SIZE - 1;
+	unsigned int		first_page_offset;
 	unsigned int		m, p, n;
 	int			error;
 
 	ASSERT(bp->b_target->bt_flags & XFS_BUFTARG_IN_MEMORY);
 
-	/* For direct-map buffers, each map has to be page aligned. */
-	for (m = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++)
-		if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+	/*
+	 * For direct-map buffer targets with multiple mappings, the first map
+	 * must end on a page boundary; the last map must start at a page
+	 * boundary; and the maps in between must start and end on a page
+	 * boundary.  For single-mapping buffers, we don't care.
+	 */
+	if (bp->b_map_count > 1) {
+		map = &bp->b_maps[bp->b_map_count - 1];
+		if (BBTOB(map->bm_bn) & page_align_mask)
 			return -ENOTBLK;
 
+		map = &bp->b_maps[0];
+		if (BBTOB(map->bm_bn + map->bm_len) & page_align_mask)
+			return -ENOTBLK;
+
+		for (m = 1, map++; m < bp->b_map_count - 1; m++, map++)
+			if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+				return -ENOTBLK;
+	}
+
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 	else
@@ -540,6 +558,7 @@ xfs_buf_alloc_direct_pages(
 	}
 
 	/* Map in the xfile pages. */
+	first_page_offset = offset_in_page(BBTOB(xfs_buf_daddr(bp)));
 	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
 		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
 			unsigned int	len;
@@ -556,6 +575,7 @@ xfs_buf_alloc_direct_pages(
 	}
 
 	bp->b_flags |= _XBF_DIRECT_MAP;
+	bp->b_offset = first_page_offset;
 	return 0;
 
 fail:
@@ -592,7 +612,7 @@ _xfs_buf_map_pages(
 
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
+		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -619,6 +639,8 @@ _xfs_buf_map_pages(
 
 		if (!bp->b_addr)
 			return -ENOMEM;
+
+		bp->b_addr += bp->b_offset;
 	}
 
 	return 0;

