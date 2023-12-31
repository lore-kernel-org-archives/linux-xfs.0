Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4349C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrSr82st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9B4C433C7;
	Sun, 31 Dec 2023 22:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061248;
	bh=HadWOQsog5KZb29i99N4UdN4JrYQj+I19wBFfNd/o/w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NrSr82stRPcWnuUBoCt//QlcTfFQuuFhkIpRHESuaMlRGkWoHgzwfKbnWi/s2VmUR
	 /6QVv47zlzHWqjL53SwwGrLEqmYUMg0tkR/O7Vz9r4gw5XfSzJJVuGGt0UWrI5wGId
	 EjQCQm53nFzvh5ioWythYnUYZXbxC8GwRBhrNieGnf3HRDJP2/FSB+fGIU4XAAONMe
	 fyjYOxQUHjG0sCsQWJNUeFEYKVdREEwb0GhhliyDqaj+ZdQhQOwHC96xsCponQcBYj
	 pLNvyE1J9GeBrK6nIyygzerxhCtxOLSOPzMUs42ves/2FRzffGMA8M/MEk3KPwkIap
	 p3wrSF044oBEA==
Date: Sun, 31 Dec 2023 14:20:48 -0800
Subject: [PATCH 4/9] xfs: initialize btree blocks using btree_ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994041.1795132.333388847185186312.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
References: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Notice now that the btree ops structure encodes btree geometry flags and
the magic number through the buffer ops.  Refactor the btree block
initialization functions to use the btree ops so that we no longer have
to open code all that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c           |    8 ++-----
 libxfs/xfs_ag.c            |   33 +++++++++++----------------
 libxfs/xfs_ag.h            |    2 +-
 libxfs/xfs_bmap.c          |   10 +++-----
 libxfs/xfs_bmap_btree.c    |    5 ++--
 libxfs/xfs_btree.c         |   53 +++++++++++++++++---------------------------
 libxfs/xfs_btree.h         |   28 +++++++----------------
 libxfs/xfs_btree_staging.c |    5 ++--
 8 files changed, 53 insertions(+), 91 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 69539635046..97edb4a2b2b 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -393,10 +393,6 @@ xfbtree_init_leaf_block(
 	struct xfs_buf			*bp;
 	xfs_daddr_t			daddr;
 	int				error;
-	unsigned int			bc_flags = 0;
-
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
-		bc_flags |= XFS_BTREE_LONG_PTRS;
 
 	daddr = xfo_to_daddr(XFBTREE_INIT_LEAF_BLOCK);
 	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
@@ -406,8 +402,8 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block_int(mp, bp->b_addr, daddr, cfg->btnum, 0, 0,
-			cfg->owner, bc_flags);
+	xfs_btree_init_block_int(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
+			cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1ba23ab533b..9ac49e0a66b 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -471,7 +471,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -529,7 +529,7 @@ xfs_freesp_init_recs(
 }
 
 /*
- * Alloc btree root block init functions
+ * bnobt/cntbt btree root block init functions
  */
 static void
 xfs_bnoroot_init(
@@ -537,17 +537,7 @@ xfs_bnoroot_init(
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
 
@@ -563,7 +553,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
@@ -776,7 +766,7 @@ struct xfs_aghdr_grow_data {
 	size_t			numblks;
 	const struct xfs_buf_ops *ops;
 	aghdr_init_work_f	work;
-	xfs_btnum_t		type;
+	const struct xfs_btree_ops *bc_ops;
 	bool			need_init;
 };
 
@@ -830,13 +820,15 @@ xfs_ag_init_headers(
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
@@ -844,7 +836,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_inobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_INO,
+		.bc_ops = &xfs_inobt_ops,
 		.need_init = true
 	},
 	{ /* FINO root block */
@@ -852,7 +844,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_finobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_FINO,
+		.bc_ops = &xfs_finobt_ops,
 		.need_init =  xfs_has_finobt(mp)
 	},
 	{ /* RMAP root block */
@@ -860,6 +852,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_rmapbt_buf_ops,
 		.work = &xfs_rmaproot_init,
+		.bc_ops = &xfs_rmapbt_ops,
 		.need_init = xfs_has_rmapbt(mp)
 	},
 	{ /* REFC root block */
@@ -867,7 +860,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_REFC,
+		.bc_ops = &xfs_refcountbt_ops,
 		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
@@ -885,7 +878,7 @@ xfs_ag_init_headers(
 
 		id->daddr = dp->daddr;
 		id->numblks = dp->numblks;
-		id->type = dp->type;
+		id->bc_ops = dp->bc_ops;
 		error = xfs_ag_init_hdr(mp, id, dp->work, dp->ops);
 		if (error)
 			break;
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 06506e09a82..79017fcd3df 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -330,7 +330,7 @@ struct aghdr_init_data {
 	/* per header data */
 	xfs_daddr_t		daddr;		/* header location */
 	size_t			numblks;	/* size of header */
-	xfs_btnum_t		type;		/* type of btree root block */
+	const struct xfs_btree_ops *bc_ops;	/* btree ops */
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cfc4350d18e..e7c39ec72f0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -638,9 +638,8 @@ xfs_bmap_extents_to_btree(
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
@@ -685,9 +684,8 @@ xfs_bmap_extents_to_btree(
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
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index aa19b214ad6..b599201d97a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -42,9 +42,8 @@ xfs_bmdr_to_bmbt(
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
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 14f0f017759..d3b2b903def 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -32,24 +32,17 @@
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
@@ -134,7 +127,6 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
@@ -149,7 +141,7 @@ __xfs_btree_check_lblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -205,7 +197,6 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno = NULLAGBLOCK;
@@ -218,7 +209,7 @@ __xfs_btree_check_sblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -1222,21 +1213,20 @@ void
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
@@ -1263,15 +1253,15 @@ xfs_btree_init_block_int(
 
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
@@ -1296,9 +1286,8 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp),
-				xfs_buf_daddr(bp), cur->bc_btnum, level,
-				numrecs, owner, cur->bc_flags);
+	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
 /*
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 2c2d5db94b1..4ee3f13625e 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 0ea44dcf14f..e535d10e13f 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -411,9 +411,8 @@ xfs_btree_bload_prep_block(
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
-				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
-				nr_this_block, cur->bc_ino.ip->i_ino,
-				cur->bc_flags);
+				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
+				nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;

