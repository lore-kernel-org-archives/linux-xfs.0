Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FB85289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817303; cv=none; b=pTp08b7f6maG6L6r/C4Lzy+Q0tkjIlTXbSliF6UonzgvwZI5wUxEzRIrwVpxRGfZwsAMeizv2usWSh/MuykTAj5cLUtYn4lNyAqiDzzC7L8ntR42vYPO96PIpC660y5pXioN13YstVMMhPe0BTSbHNvz/Ku18vwbIRjXBs3qQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817303; c=relaxed/simple;
	bh=kR1DpfPSUxT9CuXJ1dvi1nLDABUV9g6ry9O8ov15qYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2OP/FyUH8uQjJmHGmb818M+CPngh2rGMOgooFq9nOcU0H0Cht3EzcOMExMofCVIPpDsAOB9+Pim9+lNpxdaVUTzJT+mRetfB+RuMaVbaswCuUEj/eVzcjU4xohX+HxBpFPHtyK/g5YEe0oBdrU0jS0JyT9boG7vELL1e6z5Zjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmUAFcuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmUAFcuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D710C433F1;
	Thu,  1 Feb 2024 19:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817303;
	bh=kR1DpfPSUxT9CuXJ1dvi1nLDABUV9g6ry9O8ov15qYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OmUAFcuywCPYoMKmDfFrRmahbLkdlFR0zXO4MKHUcX8MybHQy6Xg7tdRQ0698RGDV
	 nOyx2OHkr0hTMrw9pNGHlUOG3MVjKRO9WCW4rMZ938OdB60MLDUzn5cc/ijoDT408a
	 /OCSCuPC4W84IN7AOqZheOAZLaA6SLWNMZyjPy5y/72eVtsOoMoaztJeMDUqIeSX1/
	 IdeDle9OWmnXZIeq6TixNn+tzDd/B61WbS7SVdMPN1bLivVymlbw259DBQ1yHNxH02
	 A8tS8BpGMOXob+m4trNziG8QPIqEeFIY6hpoJSNRDPsCMxQpASJyGX/RECgX+TFWWD
	 k4wqGiUaQw27A==
Date: Thu, 01 Feb 2024 11:55:02 -0800
Subject: [PATCH 09/10] xfs: rename btree helpers that depends on the block
 number representation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335758.1606142.999375330458611081.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

All these helpers hardcode fsblocks or agblocks and not just the pointer
size.  Rename them so that the names are still fitting when we add the
long format in-memory blocks and adjust the checks when calling them to
check the btree types and not just pointer length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    8 ++---
 fs/xfs/libxfs/xfs_bmap_btree.c     |    8 ++---
 fs/xfs/libxfs/xfs_btree.c          |   64 +++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_btree.h          |   16 +++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    8 ++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 ++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |    8 ++---
 7 files changed, 61 insertions(+), 59 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 885c7db5d6e73..6ef5ddd896005 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -322,7 +322,7 @@ xfs_allocbt_verify(
 		return __this_address;
 
 	if (xfs_has_crc(mp)) {
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		fa = xfs_btree_agblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
 	}
@@ -362,7 +362,7 @@ xfs_allocbt_verify(
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_alloc_mxr[level != 0]);
 }
 
 static void
@@ -371,7 +371,7 @@ xfs_allocbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_allocbt_verify(bp);
@@ -395,7 +395,7 @@ xfs_allocbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 54fdf0df8ec35..f5d84dcb58da0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -420,7 +420,7 @@ xfs_bmbt_verify(
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
 		 */
-		fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+		fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
 		if (fa)
 			return fa;
 	}
@@ -436,7 +436,7 @@ xfs_bmbt_verify(
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return __this_address;
 
-	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
+	return xfs_btree_fsblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
 }
 
 static void
@@ -445,7 +445,7 @@ xfs_bmbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_lblock_verify_crc(bp))
+	if (!xfs_btree_fsblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_bmbt_verify(bp);
@@ -469,7 +469,7 @@ xfs_bmbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_lblock_calc_crc(bp);
+	xfs_btree_fsblock_calc_crc(bp);
 }
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c7bd05ffc4ae1..96c1c69689880 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -57,7 +57,7 @@ xfs_btree_magic(
  * bytes.
  */
 static inline xfs_failaddr_t
-xfs_btree_check_lblock_siblings(
+xfs_btree_check_fsblock_siblings(
 	struct xfs_mount	*mp,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
@@ -76,7 +76,7 @@ xfs_btree_check_lblock_siblings(
 }
 
 static inline xfs_failaddr_t
-xfs_btree_check_sblock_siblings(
+xfs_btree_check_agblock_siblings(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
@@ -99,7 +99,7 @@ xfs_btree_check_sblock_siblings(
  * or NULL if everything is ok.
  */
 static xfs_failaddr_t
-__xfs_btree_check_lblock(
+__xfs_btree_check_fsblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
@@ -140,9 +140,10 @@ __xfs_btree_check_lblock(
 	}
 
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_fsblock_siblings(mp, fsb,
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, fsb,
+		fa = xfs_btree_check_fsblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }
@@ -152,7 +153,7 @@ __xfs_btree_check_lblock(
  * or NULL if everything is ok.
  */
 static xfs_failaddr_t
-__xfs_btree_check_sblock(
+__xfs_btree_check_agblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
@@ -179,10 +180,10 @@ __xfs_btree_check_sblock(
 		return __this_address;
 
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(pag, agbno,
+	fa = xfs_btree_check_agblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(pag, agbno,
+		fa = xfs_btree_check_agblock_siblings(pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
@@ -199,9 +200,9 @@ __xfs_btree_check_block(
 	int			level,
 	struct xfs_buf		*bp)
 {
-	if (cur->bc_ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN)
-		return __xfs_btree_check_sblock(cur, block, level, bp);
-	return __xfs_btree_check_lblock(cur, block, level, bp);
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_AG)
+		return __xfs_btree_check_agblock(cur, block, level, bp);
+	return __xfs_btree_check_fsblock(cur, block, level, bp);
 }
 
 static inline unsigned int xfs_btree_block_errtag(struct xfs_btree_cur *cur)
@@ -245,7 +246,7 @@ __xfs_btree_check_ptr(
 	if (level <= 0)
 		return -EFSCORRUPTED;
 
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 		if (!xfs_verify_fsbno(cur->bc_mp,
 				be64_to_cpu((&ptr->l)[index])))
 			return -EFSCORRUPTED;
@@ -273,7 +274,7 @@ xfs_btree_check_ptr(
 
 	error = __xfs_btree_check_ptr(cur, ptr, index, level);
 	if (error) {
-		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
@@ -306,7 +307,7 @@ xfs_btree_check_ptr(
  * it to disk.
  */
 void
-xfs_btree_lblock_calc_crc(
+xfs_btree_fsblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -320,7 +321,7 @@ xfs_btree_lblock_calc_crc(
 }
 
 bool
-xfs_btree_lblock_verify_crc(
+xfs_btree_fsblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -344,7 +345,7 @@ xfs_btree_lblock_verify_crc(
  * it to disk.
  */
 void
-xfs_btree_sblock_calc_crc(
+xfs_btree_agblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -358,7 +359,7 @@ xfs_btree_sblock_calc_crc(
 }
 
 bool
-xfs_btree_sblock_verify_crc(
+xfs_btree_agblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
@@ -913,7 +914,7 @@ xfs_btree_reada_bufs(
 }
 
 STATIC int
-xfs_btree_readahead_lblock(
+xfs_btree_readahead_fsblock(
 	struct xfs_btree_cur	*cur,
 	int			lr,
 	struct xfs_btree_block	*block)
@@ -938,7 +939,7 @@ xfs_btree_readahead_lblock(
 }
 
 STATIC int
-xfs_btree_readahead_sblock(
+xfs_btree_readahead_agblock(
 	struct xfs_btree_cur	*cur,
 	int			lr,
 	struct xfs_btree_block *block)
@@ -989,8 +990,8 @@ xfs_btree_readahead(
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return xfs_btree_readahead_lblock(cur, lr, block);
-	return xfs_btree_readahead_sblock(cur, lr, block);
+		return xfs_btree_readahead_fsblock(cur, lr, block);
+	return xfs_btree_readahead_agblock(cur, lr, block);
 }
 
 STATIC int
@@ -4597,7 +4598,7 @@ xfs_btree_change_owner(
 
 /* Verify the v5 fields of a long-format btree block. */
 xfs_failaddr_t
-xfs_btree_lblock_v5hdr_verify(
+xfs_btree_fsblock_v5hdr_verify(
 	struct xfs_buf		*bp,
 	uint64_t		owner)
 {
@@ -4618,7 +4619,7 @@ xfs_btree_lblock_v5hdr_verify(
 
 /* Verify a long-format btree block. */
 xfs_failaddr_t
-xfs_btree_lblock_verify(
+xfs_btree_fsblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
 {
@@ -4633,21 +4634,22 @@ xfs_btree_lblock_verify(
 
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_fsblock_siblings(mp, fsb,
+			block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, fsb,
+		fa = xfs_btree_check_fsblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }
 
 /**
- * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
+ * xfs_btree_agblock_v5hdr_verify() -- verify the v5 fields of a short-format
  *				      btree block
  *
  * @bp: buffer containing the btree block
  */
 xfs_failaddr_t
-xfs_btree_sblock_v5hdr_verify(
+xfs_btree_agblock_v5hdr_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
@@ -4666,13 +4668,13 @@ xfs_btree_sblock_v5hdr_verify(
 }
 
 /**
- * xfs_btree_sblock_verify() -- verify a short-format btree block
+ * xfs_btree_agblock_verify() -- verify a short-format btree block
  *
  * @bp: buffer containing the btree block
  * @max_recs: maximum records allowed in this btree node
  */
 xfs_failaddr_t
-xfs_btree_sblock_verify(
+xfs_btree_agblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
 {
@@ -4687,10 +4689,10 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
+	fa = xfs_btree_check_agblock_siblings(bp->b_pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
+		fa = xfs_btree_check_agblock_siblings(bp->b_pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7c0b598178f6f..8544f2f506f80 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -441,10 +441,10 @@ int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
 /*
  * btree block CRC helpers
  */
-void xfs_btree_lblock_calc_crc(struct xfs_buf *);
-bool xfs_btree_lblock_verify_crc(struct xfs_buf *);
-void xfs_btree_sblock_calc_crc(struct xfs_buf *);
-bool xfs_btree_sblock_verify_crc(struct xfs_buf *);
+void xfs_btree_fsblock_calc_crc(struct xfs_buf *);
+bool xfs_btree_fsblock_verify_crc(struct xfs_buf *);
+void xfs_btree_agblock_calc_crc(struct xfs_buf *);
+bool xfs_btree_agblock_verify_crc(struct xfs_buf *);
 
 /*
  * Internal btree helpers also used by xfs_bmap.c.
@@ -484,12 +484,12 @@ static inline int xfs_btree_get_level(const struct xfs_btree_block *block)
 #define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
 #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
-xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
-xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_buf *bp,
+xfs_failaddr_t xfs_btree_agblock_v5hdr_verify(struct xfs_buf *bp);
+xfs_failaddr_t xfs_btree_agblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
-xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
+xfs_failaddr_t xfs_btree_fsblock_v5hdr_verify(struct xfs_buf *bp,
 		uint64_t owner);
-xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
+xfs_failaddr_t xfs_btree_fsblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
 unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 74f144b2db68a..cc661fca6ff5b 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -309,7 +309,7 @@ xfs_inobt_verify(
 	 * xfs_perag_initialised_agi(pag)) if we ever do.
 	 */
 	if (xfs_has_crc(mp)) {
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		fa = xfs_btree_agblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
 	}
@@ -319,7 +319,7 @@ xfs_inobt_verify(
 	if (level >= M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp,
+	return xfs_btree_agblock_verify(bp,
 			M_IGEO(mp)->inobt_mxr[level != 0]);
 }
 
@@ -329,7 +329,7 @@ xfs_inobt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_inobt_verify(bp);
@@ -353,7 +353,7 @@ xfs_inobt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f93dae3db7012..ca59f6c89f3e3 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -217,7 +217,7 @@ xfs_refcountbt_verify(
 
 	if (!xfs_has_reflink(mp))
 		return __this_address;
-	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	fa = xfs_btree_agblock_v5hdr_verify(bp);
 	if (fa)
 		return fa;
 
@@ -239,7 +239,7 @@ xfs_refcountbt_verify(
 	} else if (level >= mp->m_refc_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_refc_mxr[level != 0]);
 }
 
 STATIC void
@@ -248,7 +248,7 @@ xfs_refcountbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_refcountbt_verify(bp);
@@ -272,7 +272,7 @@ xfs_refcountbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b1ecc061fdc9c..0751268c102c6 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -336,7 +336,7 @@ xfs_rmapbt_verify(
 
 	if (!xfs_has_rmapbt(mp))
 		return __this_address;
-	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	fa = xfs_btree_agblock_v5hdr_verify(bp);
 	if (fa)
 		return fa;
 
@@ -347,7 +347,7 @@ xfs_rmapbt_verify(
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_rmap_mxr[level != 0]);
 }
 
 static void
@@ -356,7 +356,7 @@ xfs_rmapbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_rmapbt_verify(bp);
@@ -380,7 +380,7 @@ xfs_rmapbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 

