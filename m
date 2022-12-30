Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF1CC4708E
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiL3XpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiL3XpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:45:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE7A1E3D3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:45:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A0FB81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237E8C433D2;
        Fri, 30 Dec 2022 23:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443898;
        bh=drfGIRUyZx928VAx6JrlB0S9UxQvWtA0wLjTQhONjxM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zp0GKZjWTLXNtetKgkx0GrHbaGYTDViF/12eO7Bv57U3KJ0q0Sn/2TyBhU2cU5+vP
         KPQH2hr42vAmmGukfAwRgbfaiXqBa2DyieJ3ScXcZkNAfDlUEOEgrwGRDzd22fXahc
         l3jqjdEi68rh6KINHBMT/Bb9Rc2MGHURuCQdMG+bs7oAoc7IPfQ29IXKRDzP1O1T0E
         7Ma51UM3fQmaXot5eY/3mTCNvb1eeGlb+4sHFV5dj7BCWHUly8HETbaog4+SscNBwQ
         1muULwzLlBJ//ND+btf7er8dexWyvYadDTQ9J+qZ06QRwahUHlWvo+Sr7F+TJjTtik
         BYvgGo6A2YtdA==
Subject: [PATCH 4/9] xfs: initialize btree blocks using btree_ops structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:34 -0800
Message-ID: <167243841426.696890.4047886536099651182.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
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
index 58d485a76150..f9e9e6879d53 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -412,7 +412,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -471,7 +471,7 @@ xfs_freesp_init_recs(
 }
 
 /*
- * Alloc btree root block init functions
+ * bnobt/cntbt btree root block init functions
  */
 static void
 xfs_bnoroot_init(
@@ -479,17 +479,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
-	xfs_freesp_init_recs(mp, bp, id);
-}
-
-static void
-xfs_cntroot_init(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp,
-	struct aghdr_init_data	*id)
-{
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 1, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -505,7 +495,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
@@ -718,7 +708,7 @@ struct xfs_aghdr_grow_data {
 	size_t			numblks;
 	const struct xfs_buf_ops *ops;
 	aghdr_init_work_f	work;
-	xfs_btnum_t		type;
+	const struct xfs_btree_ops *bc_ops;
 	bool			need_init;
 };
 
@@ -772,13 +762,15 @@ xfs_ag_init_headers(
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
@@ -786,7 +778,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_inobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_INO,
+		.bc_ops = &xfs_inobt_ops,
 		.need_init = true
 	},
 	{ /* FINO root block */
@@ -794,7 +786,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_finobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_FINO,
+		.bc_ops = &xfs_finobt_ops,
 		.need_init =  xfs_has_finobt(mp)
 	},
 	{ /* RMAP root block */
@@ -802,6 +794,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_rmapbt_buf_ops,
 		.work = &xfs_rmaproot_init,
+		.bc_ops = &xfs_rmapbt_ops,
 		.need_init = xfs_has_rmapbt(mp)
 	},
 	{ /* REFC root block */
@@ -809,7 +802,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_REFC,
+		.bc_ops = &xfs_refcountbt_ops,
 		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
@@ -827,7 +820,7 @@ xfs_ag_init_headers(
 
 		id->daddr = dp->daddr;
 		id->numblks = dp->numblks;
-		id->type = dp->type;
+		id->bc_ops = dp->bc_ops;
 		error = xfs_ag_init_hdr(mp, id, dp->work, dp->ops);
 		if (error)
 			break;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 6d5ddefa321e..654f58aa831f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -251,7 +251,7 @@ struct aghdr_init_data {
 	/* per header data */
 	xfs_daddr_t		daddr;		/* header location */
 	size_t			numblks;	/* size of header */
-	xfs_btnum_t		type;		/* type of btree root block */
+	const struct xfs_btree_ops *bc_ops;	/* btree ops */
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 89fd34fbae7a..b91f273ccbec 100644
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
@@ -697,9 +696,8 @@ xfs_bmap_extents_to_btree(
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
index 82a1e06aeac6..2cf6459b7bca 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -43,9 +43,8 @@ xfs_bmdr_to_bmbt(
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
index 4c5b4d26cd1b..78c18c027575 100644
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
index f23d12626a68..3145d7e61cb4 100644
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
index 4436522705e5..052fbc1086dc 100644
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

