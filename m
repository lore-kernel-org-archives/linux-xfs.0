Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03616C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjEZBJG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjEZBJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:09:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB669B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6BFD610A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41762C433D2;
        Fri, 26 May 2023 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063341;
        bh=CYJ3neU/nzXo3//vOlVP1HOLzAhmgJRLEL3AHkZ65m8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iOiDp2htgEP/LFROP2u8AMIGNB9UNqKpdx9eTUeAovAhPAG+s1e9WsVVguIT8WaEJ
         SgXeWuhZzGN+H03WI8U9euVF13RFgkQ+EczTqrMfB+rQ9ZHCTVogYZLB9nu4Ux02hy
         Z8OB23g8dQIz3eVbR9pZq/cYjr/Jwc+LuTRzp17Oprf2ar3y0J9l83oY4BuSANAq41
         hX1u3yMSYwitg+vd1P/KGoCsG4X8kRo5LJd0doX//JjsX2AXXQeb7BeSX1kqDpSFGK
         EJDCUxbKAJyciviJ4CxjbT0diThWVQF5n3q21LUnbLnfAhZ8dhBDTpSfHgCbndHWOq
         3b7vxiPZwJLcw==
Date:   Thu, 25 May 2023 18:09:00 -0700
Subject: [PATCH 4/9] xfs: initialize btree blocks using btree_ops structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062737.3733506.12195314773534325385.stgit@frogsfrogsfrogs>
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

Notice now that the btree ops structure encodes btree geometry flags and
the magic number through the buffer ops.  Refactor the btree block
initialization functions to use the btree ops so that we no longer have
to open code all that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c            |   33 +++++++++--------------
 fs/xfs/libxfs/xfs_ag.h            |    2 +
 fs/xfs/libxfs/xfs_bmap.c          |   10 +++----
 fs/xfs/libxfs/xfs_bmap_btree.c    |    5 +--
 fs/xfs/libxfs/xfs_btree.c         |   53 +++++++++++++++----------------------
 fs/xfs/libxfs/xfs_btree.h         |   28 ++++++--------------
 fs/xfs/libxfs/xfs_btree_staging.c |    5 +--
 fs/xfs/scrub/xfbtree.c            |    8 +-----
 8 files changed, 53 insertions(+), 91 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index b3b0ee6656cd..02aef7334b67 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -473,7 +473,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -531,7 +531,7 @@ xfs_freesp_init_recs(
 }
 
 /*
- * Alloc btree root block init functions
+ * bnobt/cntbt btree root block init functions
  */
 static void
 xfs_bnoroot_init(
@@ -539,17 +539,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 0, id->agno);
-	xfs_freesp_init_recs(mp, bp, id);
-}
-
-static void
-xfs_cntroot_init(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp,
-	struct aghdr_init_data	*id)
-{
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -565,7 +555,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
@@ -778,7 +768,7 @@ struct xfs_aghdr_grow_data {
 	size_t			numblks;
 	const struct xfs_buf_ops *ops;
 	aghdr_init_work_f	work;
-	xfs_btnum_t		type;
+	const struct xfs_btree_ops *bc_ops;
 	bool			need_init;
 };
 
@@ -832,13 +822,15 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_bnobt_buf_ops,
 		.work = &xfs_bnoroot_init,
+		.bc_ops = &xfs_bnobt_ops,
 		.need_init = true
 	},
 	{ /* CNT root block */
 		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp)),
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_cntbt_buf_ops,
-		.work = &xfs_cntroot_init,
+		.work = &xfs_bnoroot_init,
+		.bc_ops = &xfs_cntbt_ops,
 		.need_init = true
 	},
 	{ /* INO root block */
@@ -846,7 +838,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_inobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_INO,
+		.bc_ops = &xfs_inobt_ops,
 		.need_init = true
 	},
 	{ /* FINO root block */
@@ -854,7 +846,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_finobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_FINO,
+		.bc_ops = &xfs_finobt_ops,
 		.need_init =  xfs_has_finobt(mp)
 	},
 	{ /* RMAP root block */
@@ -862,6 +854,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_rmapbt_buf_ops,
 		.work = &xfs_rmaproot_init,
+		.bc_ops = &xfs_rmapbt_ops,
 		.need_init = xfs_has_rmapbt(mp)
 	},
 	{ /* REFC root block */
@@ -869,7 +862,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_REFC,
+		.bc_ops = &xfs_refcountbt_ops,
 		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
@@ -887,7 +880,7 @@ xfs_ag_init_headers(
 
 		id->daddr = dp->daddr;
 		id->numblks = dp->numblks;
-		id->type = dp->type;
+		id->bc_ops = dp->bc_ops;
 		error = xfs_ag_init_hdr(mp, id, dp->work, dp->ops);
 		if (error)
 			break;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index de7acd82ae09..c5834f90f852 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -330,7 +330,7 @@ struct aghdr_init_data {
 	/* per header data */
 	xfs_daddr_t		daddr;		/* header location */
 	size_t			numblks;	/* size of header */
-	xfs_btnum_t		type;		/* type of btree root block */
+	const struct xfs_btree_ops *bc_ops;	/* btree ops */
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 86180103f5ca..2836e9887736 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -639,9 +639,8 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
-				 XFS_BTNUM_BMAP, 1, 1, ip->i_ino,
-				 XFS_BTREE_LONG_PTRS);
+	xfs_btree_init_block_int(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
+			1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -686,9 +685,8 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block_int(mp, ablock, xfs_buf_daddr(abp),
-				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				XFS_BTREE_LONG_PTRS);
+	xfs_btree_init_block_int(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
+			0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 985199018e8c..3683080296ef 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -44,9 +44,8 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
-				 XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				 XFS_BTREE_LONG_PTRS);
+	xfs_btree_init_block_int(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
+			0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index dbd048bc1e8e..bb2a7473fe05 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -35,24 +35,17 @@
 /*
  * Btree magic numbers.
  */
-static const uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
-	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC, 0 },
-	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
-	  XFS_REFC_CRC_MAGIC }
-};
-
 uint32_t
 xfs_btree_magic(
-	int			crc,
-	xfs_btnum_t		btnum)
+	struct xfs_mount		*mp,
+	const struct xfs_btree_ops	*ops)
 {
-	uint32_t		magic = xfs_magics[crc][btnum];
+	int				idx = xfs_has_crc(mp) ? 1 : 0;
+	__be32				magic = ops->buf_ops->magic[idx];
 
 	/* Ensure we asked for crc for crc-only magics. */
 	ASSERT(magic != 0);
-	return magic;
+	return be32_to_cpu(magic);
 }
 
 /*
@@ -137,7 +130,6 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
@@ -152,7 +144,7 @@ __xfs_btree_check_lblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -208,7 +200,6 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno = NULLAGBLOCK;
@@ -221,7 +212,7 @@ __xfs_btree_check_sblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -1225,21 +1216,20 @@ void
 xfs_btree_init_block_int(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
+	const struct xfs_btree_ops *ops,
 	xfs_daddr_t		blkno,
-	xfs_btnum_t		btnum,
 	__u16			level,
 	__u16			numrecs,
-	__u64			owner,
-	unsigned int		flags)
+	__u64			owner)
 {
 	int			crc = xfs_has_crc(mp);
-	__u32			magic = xfs_btree_magic(crc, btnum);
+	__u32			magic = xfs_btree_magic(mp, ops);
 
 	buf->bb_magic = cpu_to_be32(magic);
 	buf->bb_level = cpu_to_be16(level);
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
-	if (flags & XFS_BTREE_LONG_PTRS) {
+	if (ops->geom_flags & XFS_BTREE_LONG_PTRS) {
 		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
 		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (crc) {
@@ -1266,15 +1256,15 @@ xfs_btree_init_block_int(
 
 void
 xfs_btree_init_block(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_btnum_t	btnum,
-	__u16		level,
-	__u16		numrecs,
-	__u64		owner)
+	struct xfs_mount		*mp,
+	struct xfs_buf			*bp,
+	const struct xfs_btree_ops	*ops,
+	__u16				level,
+	__u16				numrecs,
+	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), xfs_buf_daddr(bp),
-				 btnum, level, numrecs, owner, 0);
+	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
 void
@@ -1299,9 +1289,8 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp),
-				xfs_buf_daddr(bp), cur->bc_btnum, level,
-				numrecs, owner, cur->bc_flags);
+	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8bda5c76f013..06c89fc415b5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -63,7 +63,8 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
-uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
+struct xfs_btree_ops;
+uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
 
 /*
  * For logging record fields.
@@ -450,25 +451,12 @@ xfs_btree_reada_bufs(
 /*
  * Initialise a new btree block header
  */
-void
-xfs_btree_init_block(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_btnum_t	btnum,
-	__u16		level,
-	__u16		numrecs,
-	__u64		owner);
-
-void
-xfs_btree_init_block_int(
-	struct xfs_mount	*mp,
-	struct xfs_btree_block	*buf,
-	xfs_daddr_t		blkno,
-	xfs_btnum_t		btnum,
-	__u16			level,
-	__u16			numrecs,
-	__u64			owner,
-	unsigned int		flags);
+void xfs_btree_init_block(struct xfs_mount *mp, struct xfs_buf *bp,
+		const struct xfs_btree_ops *ops, __u16 level, __u16 numrecs,
+		__u64 owner);
+void xfs_btree_init_block_int(struct xfs_mount *mp,
+		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
+		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 4cdf7976b7bf..0bf20472dd27 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -405,9 +405,8 @@ xfs_btree_bload_prep_block(
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
-				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
-				nr_this_block, cur->bc_ino.ip->i_ino,
-				cur->bc_flags);
+				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
+				nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index bfd8ff8872a5..7f13110ef67b 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -407,10 +407,6 @@ xfbtree_init_leaf_block(
 	struct xfs_buf			*bp;
 	xfs_daddr_t			daddr;
 	int				error;
-	unsigned int			bc_flags = 0;
-
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
-		bc_flags |= XFS_BTREE_LONG_PTRS;
 
 	daddr = xfo_to_daddr(XFBTREE_INIT_LEAF_BLOCK);
 	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
@@ -420,8 +416,8 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block_int(mp, bp->b_addr, daddr, cfg->btnum, 0, 0,
-			cfg->owner, bc_flags);
+	xfs_btree_init_block_int(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
+			cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)

