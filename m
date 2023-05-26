Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97D1C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjEZBJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjEZBJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:09:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DF21BF
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0028664C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5C0C433D2;
        Fri, 26 May 2023 01:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063372;
        bh=zaq8Gq0KGILeHAH7BHOIvSJJGLFavqojJQj/ng60BDI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YIZ677EG3PJM8HlD3RtDgXuHVxFlGwHVSpIDSR79Cb4mXWGJJsflCPXegPVoMK9MU
         IrKQdX0HVLGMmJyiBJDTHV7NecrVT1cJYuFAFu47Yr2ignt2gxU26vk4zaPIc/cUvE
         mE6Wf1TJB43lcg4gyfYbzEr9JSEbGzoEU0AlW6NBO9PfTyerB6YkVdTcyDNl6KX+lF
         Os1kl0tdLZBlGzLx8VgA0K+bIy0M8ia2bZIPTPioaZkTgbRM4RQ4IacMcF+YZSg8TE
         LeR8w8Z553l61UUqlYIFKFHN6FM1XK7olJ4TohOnxvLEF3W9ZAfMXUZzEC/J64QFPt
         XucJXDqQTar+A==
Date:   Thu, 25 May 2023 18:09:32 -0700
Subject: [PATCH 6/9] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062767.3733506.14676441776640772037.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
References: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |    3 +--
 fs/xfs/libxfs/xfs_btree.c |    3 +--
 fs/xfs/scrub/xfbtree.c    |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c58aa644a0b3..f81f336a69e5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -685,8 +685,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
-			0, 0, ip->i_ino);
+	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 742e24b24ba2..0fdaacefe45e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1289,8 +1289,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 1260c29c426c..e7975f462428 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -416,8 +416,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
-			cfg->owner);
+	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)

