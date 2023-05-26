Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97E6C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjEZBia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:38:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAAE1A4
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C7060C64
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8164AC4339C;
        Fri, 26 May 2023 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065105;
        bh=beNvbjjit+ypsA+aS2nPDIMVtwdg6SCUWhMPDVdrKkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h0G4R9+0EB/ZutV2ZdPkO+XSUjAoCs2EYtop9zkx9e4ZFqEHEIn4mFmE/jn26tTQU
         QXn5/NHjFmRsASWISgSWXKjEkUL+wO0QLG7rHIy4Fk6zG2KmrJfP2S9TRLx635cPHe
         xvUr2j6eES5URMWk+LeePoLUjfnSbQjLUO71jbxEkv2EAIl4LbzNUpEsaTk+biqW+y
         9Cc9MKpMUzxjJD3G3YgVnqPUy44V6NyF1ztkvjhflxsCfM+RD9wrslBeWs/NhMc27m
         P9KmuhuyYt4J6hU+t79gFsaz4HK3cPrXKgwSF2NuqZfcuMCErvG/mFbcWXFHTnPGc7
         QYUn09pNVh+DA==
Date:   Thu, 25 May 2023 18:38:25 -0700
Subject: [PATCH 2/3] xfs: use b_offset to support direct-mapping pages when
 blocksize < pagesize
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069041.3738195.13112721685809073705.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069009.3738195.8548151008033051712.stgit@frogsfrogsfrogs>
References: <168506069009.3738195.8548151008033051712.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_buf.c       |    8 ++++++--
 fs/xfs/xfs_buf_xfile.c |   20 +++++++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9b14f317396c..bc386c0a3ed5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -321,7 +321,7 @@ xfs_buf_free(
 	ASSERT(list_empty(&bp->b_lru));
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 	if (bp->b_flags & _XBF_DIRECT_MAP)
 		xfile_buf_unmap_pages(bp);
@@ -434,6 +434,8 @@ xfs_buf_alloc_pages(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
+
+	bp->b_offset = 0;
 	return 0;
 }
 
@@ -449,7 +451,7 @@ _xfs_buf_map_pages(
 
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
+		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -476,6 +478,8 @@ _xfs_buf_map_pages(
 
 		if (!bp->b_addr)
 			return -ENOMEM;
+
+		bp->b_addr += bp->b_offset;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
index 5757e0521a60..06c5d14f1093 100644
--- a/fs/xfs/xfs_buf_xfile.c
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -163,15 +163,27 @@ xfile_buf_map_pages(
 	gfp_t			gfp_mask = __GFP_NOWARN;
 	const unsigned int	page_align_mask = PAGE_SIZE - 1;
 	unsigned int		m, p, n;
+	unsigned int		first_page_offset;
 	int			error;
 
 	ASSERT(xfile_buftarg_can_direct_map(bp->b_target));
 
-	/* For direct-map buffers, each map has to be page aligned. */
-	for (m = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++)
-		if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+	/*
+	 * For direct-map buffer targets with multiple mappings, the first map
+	 * must end on a page boundary and the rest of the mappings must start
+	 * and end on a page boundary.  For single-mapping buffers, we don't
+	 * care.
+	 */
+	if (bp->b_map_count > 1) {
+		map = &bp->b_maps[0];
+		if (BBTOB(map->bm_bn + map->bm_len) & page_align_mask)
 			return -ENOTBLK;
 
+		for (m = 1, map++; m < bp->b_map_count - 1; m++, map++)
+			if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+				return -ENOTBLK;
+	}
+
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 	else
@@ -182,6 +194,7 @@ xfile_buf_map_pages(
 		return error;
 
 	/* Map in the xfile pages. */
+	first_page_offset = offset_in_page(BBTOB(xfs_buf_daddr(bp)));
 	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
 		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
 			unsigned int	len;
@@ -198,6 +211,7 @@ xfile_buf_map_pages(
 	}
 
 	bp->b_flags |= _XBF_DIRECT_MAP;
+	bp->b_offset = first_page_offset;
 	return 0;
 
 fail:

