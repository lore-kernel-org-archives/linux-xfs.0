Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B5EC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjEZBJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbjEZBJb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:09:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8991E5A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CE4364C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F8EC433D2;
        Fri, 26 May 2023 01:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063356;
        bh=ZTCrdxAd9r3cHQjyCBQRGJZIlr3z+NKv757MkE1gFPc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fR37c7lwp09wvq2u0W0EUkWhuKbzl2Yyq9MAAoGYMX6oFtJiQ4EmAVTYyUZQ0mjHt
         fe11azqFr5uksa4OVR2ha5gtI8RU3GMO1OONnS2zdMz/asejPSJ9ojn5096W1QLw2H
         c/Hz5Ft6yROL+iIYmnmtdqTuA099Z3V59iORaU39JZHUDqzht1aJDG1WFfM+n01KjR
         gRYHGPXht9aHB5xmP9WAdjgJ8E0XW20sUGzDGBPbXnqgWIX6FMqT/omC3Wu9pLOc+0
         QjrAq08jgZiZGm8B8fZDQ/1G5nFuHl/ThbYn75qrr9JEkLe5p91PwZUrgs83QIQZO2
         6ys1za9C6uoUg==
Date:   Thu, 25 May 2023 18:09:16 -0700
Subject: [PATCH 5/9] xfs: rename btree block/buffer init functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062752.3733506.12361036578321217753.stgit@frogsfrogsfrogs>
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

Rename xfs_btree_init_block_int to xfs_btree_init_block, and
xfs_btree_init_block to xfs_btree_init_buf so that the name suggests the
type that caller are supposed to pass in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c            |    6 +++---
 fs/xfs/libxfs/xfs_bmap.c          |    6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_btree.c         |    8 ++++----
 fs/xfs/libxfs/xfs_btree.h         |    4 ++--
 fs/xfs/libxfs/xfs_btree_staging.c |    2 +-
 fs/xfs/scrub/xfbtree.c            |    2 +-
 7 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 02aef7334b67..5ee3ec70edbe 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -473,7 +473,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -539,7 +539,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -555,7 +555,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2836e9887736..c58aa644a0b3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -639,8 +639,8 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block_int(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			1, 1, ip->i_ino);
+	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL, 1,
+			1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -685,7 +685,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block_int(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
+	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
 			0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3683080296ef..904971502dc6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -44,7 +44,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block_int(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
 			0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bb2a7473fe05..742e24b24ba2 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1213,7 +1213,7 @@ xfs_btree_set_sibling(
 }
 
 void
-xfs_btree_init_block_int(
+xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1255,7 +1255,7 @@ xfs_btree_init_block_int(
 }
 
 void
-xfs_btree_init_block(
+xfs_btree_init_buf(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
 	const struct xfs_btree_ops	*ops,
@@ -1263,7 +1263,7 @@ xfs_btree_init_block(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
@@ -1289,7 +1289,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 06c89fc415b5..925bcd245bcf 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -451,10 +451,10 @@ xfs_btree_reada_bufs(
 /*
  * Initialise a new btree block header
  */
-void xfs_btree_init_block(struct xfs_mount *mp, struct xfs_buf *bp,
+void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		const struct xfs_btree_ops *ops, __u16 level, __u16 numrecs,
 		__u64 owner);
-void xfs_btree_init_block_int(struct xfs_mount *mp,
+void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
 		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
 
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 0bf20472dd27..de17d333ffb3 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -404,7 +404,7 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
 				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
 				nr_this_block, cur->bc_ino.ip->i_ino);
 
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 7f13110ef67b..1260c29c426c 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -416,7 +416,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block_int(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
+	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
 			cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);

