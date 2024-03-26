Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0491292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425005; cv=none; b=UjEGe8NaGsE42xEe9eKIMgfGs/5ml7Zs5ES/wvgLz7atgPdFFlQ+q0Ow8M7ewDgzaVxz3qAvV2LLktWtVmPeCcZstbWiNcrUHBNJPD5g/WYAjPHa4PW1o2chpJsLB2v0dakdq9u1PZ8aOvGfpvoMIWbkR4Kp1t/aLHvZtnib/l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425005; c=relaxed/simple;
	bh=s9tCzXdaKCeUry3VF9hWs/olcovGPu5gUYpqqy/8Ndw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChTjGE0oWridNjAVZHiK/h1Qmt9OyCaOkrK07Fb8TG1PyP3ECUwuGKpt86i1AkoCBMiNox0jb9jG13mdtkRt8jiR6kbGomyBSWyCE4/8BwaHfQPNkDKiCRPf/ZKWHgd4r1wpVuvuQXgawYI7xuQ7gibuhFyKV3xGaTs8I4gC8pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qMF0Qgq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qMF0Qgq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D64C433C7;
	Tue, 26 Mar 2024 03:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425005;
	bh=s9tCzXdaKCeUry3VF9hWs/olcovGPu5gUYpqqy/8Ndw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qMF0Qgq4uPTm+Q2ORVeMCsLYJzuK/TGpL7NbjYOFD0SV/PG6vLWQsfusV+TC++2Xk
	 kAoOp4pU24lxWo/89oqj1ls0IfVPm1TXqIYC5TfZUo7Jdx/ay/f7HUVBxP00iuuPIa
	 5J+yF/i2ljXyPJSkbvoat+Jml2dcWjYcKkfk25QHFJ9/buCV5ux41bxUKcjnqarCNK
	 sKsdURcOajrhgxD9kVyDjTwmbWFOvqVaJ7EBD2L/8j3oKA87haiIQYnV5jX0oONkpx
	 YRS7Qnpb3AOQwGF+v/kAqpuiz3TUlhJC0Xh3e/tjVyBD0t1lblJsb0P/NvD+zxkhl0
	 /Q0PoCpUm901w==
Date: Mon, 25 Mar 2024 20:50:04 -0700
Subject: [PATCH 083/110] xfs: rename btree helpers that depends on the block
 number representation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132576.2215168.4142360528017033484.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5ef819c34f954fccfc42f79b9b0bea9b40cef9a1

All these helpers hardcode fsblocks or agblocks and not just the pointer
size.  Rename them so that the names are still fitting when we add the
long format in-memory blocks and adjust the checks when calling them to
check the btree types and not just pointer length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    8 +++--
 libxfs/xfs_bmap_btree.c     |    8 +++--
 libxfs/xfs_btree.c          |   64 ++++++++++++++++++++++---------------------
 libxfs/xfs_btree.h          |   16 +++++------
 libxfs/xfs_ialloc_btree.c   |    8 +++--
 libxfs/xfs_refcount_btree.c |    8 +++--
 libxfs/xfs_rmap_btree.c     |    8 +++--
 7 files changed, 61 insertions(+), 59 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 35d3dde426b1..949eb02cd073 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -320,7 +320,7 @@ xfs_allocbt_verify(
 		return __this_address;
 
 	if (xfs_has_crc(mp)) {
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		fa = xfs_btree_agblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
 	}
@@ -360,7 +360,7 @@ xfs_allocbt_verify(
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_alloc_mxr[level != 0]);
 }
 
 static void
@@ -369,7 +369,7 @@ xfs_allocbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_allocbt_verify(bp);
@@ -393,7 +393,7 @@ xfs_allocbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index eede6ffd62ea..2a603b4d19be 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -419,7 +419,7 @@ xfs_bmbt_verify(
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
 		 */
-		fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+		fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
 		if (fa)
 			return fa;
 	}
@@ -435,7 +435,7 @@ xfs_bmbt_verify(
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return __this_address;
 
-	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
+	return xfs_btree_fsblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
 }
 
 static void
@@ -444,7 +444,7 @@ xfs_bmbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_lblock_verify_crc(bp))
+	if (!xfs_btree_fsblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_bmbt_verify(bp);
@@ -468,7 +468,7 @@ xfs_bmbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_lblock_calc_crc(bp);
+	xfs_btree_fsblock_calc_crc(bp);
 }
 
 const struct xfs_buf_ops xfs_bmbt_buf_ops = {
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index fae121acecb4..e69b88b9061c 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -54,7 +54,7 @@ xfs_btree_magic(
  * bytes.
  */
 static inline xfs_failaddr_t
-xfs_btree_check_lblock_siblings(
+xfs_btree_check_fsblock_siblings(
 	struct xfs_mount	*mp,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
@@ -73,7 +73,7 @@ xfs_btree_check_lblock_siblings(
 }
 
 static inline xfs_failaddr_t
-xfs_btree_check_sblock_siblings(
+xfs_btree_check_agblock_siblings(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
@@ -96,7 +96,7 @@ xfs_btree_check_sblock_siblings(
  * or NULL if everything is ok.
  */
 static xfs_failaddr_t
-__xfs_btree_check_lblock(
+__xfs_btree_check_fsblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
@@ -137,9 +137,10 @@ __xfs_btree_check_lblock(
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
@@ -149,7 +150,7 @@ __xfs_btree_check_lblock(
  * or NULL if everything is ok.
  */
 static xfs_failaddr_t
-__xfs_btree_check_sblock(
+__xfs_btree_check_agblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
@@ -176,10 +177,10 @@ __xfs_btree_check_sblock(
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
@@ -196,9 +197,9 @@ __xfs_btree_check_block(
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
@@ -242,7 +243,7 @@ __xfs_btree_check_ptr(
 	if (level <= 0)
 		return -EFSCORRUPTED;
 
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 		if (!xfs_verify_fsbno(cur->bc_mp,
 				be64_to_cpu((&ptr->l)[index])))
 			return -EFSCORRUPTED;
@@ -270,7 +271,7 @@ xfs_btree_check_ptr(
 
 	error = __xfs_btree_check_ptr(cur, ptr, index, level);
 	if (error) {
-		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
@@ -303,7 +304,7 @@ xfs_btree_check_ptr(
  * it to disk.
  */
 void
-xfs_btree_lblock_calc_crc(
+xfs_btree_fsblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -317,7 +318,7 @@ xfs_btree_lblock_calc_crc(
 }
 
 bool
-xfs_btree_lblock_verify_crc(
+xfs_btree_fsblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -341,7 +342,7 @@ xfs_btree_lblock_verify_crc(
  * it to disk.
  */
 void
-xfs_btree_sblock_calc_crc(
+xfs_btree_agblock_calc_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -355,7 +356,7 @@ xfs_btree_sblock_calc_crc(
 }
 
 bool
-xfs_btree_sblock_verify_crc(
+xfs_btree_agblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
@@ -910,7 +911,7 @@ xfs_btree_reada_bufs(
 }
 
 STATIC int
-xfs_btree_readahead_lblock(
+xfs_btree_readahead_fsblock(
 	struct xfs_btree_cur	*cur,
 	int			lr,
 	struct xfs_btree_block	*block)
@@ -935,7 +936,7 @@ xfs_btree_readahead_lblock(
 }
 
 STATIC int
-xfs_btree_readahead_sblock(
+xfs_btree_readahead_agblock(
 	struct xfs_btree_cur	*cur,
 	int			lr,
 	struct xfs_btree_block *block)
@@ -986,8 +987,8 @@ xfs_btree_readahead(
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return xfs_btree_readahead_lblock(cur, lr, block);
-	return xfs_btree_readahead_sblock(cur, lr, block);
+		return xfs_btree_readahead_fsblock(cur, lr, block);
+	return xfs_btree_readahead_agblock(cur, lr, block);
 }
 
 STATIC int
@@ -4594,7 +4595,7 @@ xfs_btree_change_owner(
 
 /* Verify the v5 fields of a long-format btree block. */
 xfs_failaddr_t
-xfs_btree_lblock_v5hdr_verify(
+xfs_btree_fsblock_v5hdr_verify(
 	struct xfs_buf		*bp,
 	uint64_t		owner)
 {
@@ -4615,7 +4616,7 @@ xfs_btree_lblock_v5hdr_verify(
 
 /* Verify a long-format btree block. */
 xfs_failaddr_t
-xfs_btree_lblock_verify(
+xfs_btree_fsblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
 {
@@ -4630,21 +4631,22 @@ xfs_btree_lblock_verify(
 
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
@@ -4663,13 +4665,13 @@ xfs_btree_sblock_v5hdr_verify(
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
@@ -4684,10 +4686,10 @@ xfs_btree_sblock_verify(
 
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index d3afa6209ff8..b9b46a573e64 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index cb0a7c7792a1..58c520ecba5a 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -308,7 +308,7 @@ xfs_inobt_verify(
 	 * xfs_perag_initialised_agi(pag)) if we ever do.
 	 */
 	if (xfs_has_crc(mp)) {
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		fa = xfs_btree_agblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
 	}
@@ -318,7 +318,7 @@ xfs_inobt_verify(
 	if (level >= M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp,
+	return xfs_btree_agblock_verify(bp,
 			M_IGEO(mp)->inobt_mxr[level != 0]);
 }
 
@@ -328,7 +328,7 @@ xfs_inobt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_inobt_verify(bp);
@@ -352,7 +352,7 @@ xfs_inobt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 6ec0e36e5819..362b2a2d733a 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -216,7 +216,7 @@ xfs_refcountbt_verify(
 
 	if (!xfs_has_reflink(mp))
 		return __this_address;
-	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	fa = xfs_btree_agblock_v5hdr_verify(bp);
 	if (fa)
 		return fa;
 
@@ -238,7 +238,7 @@ xfs_refcountbt_verify(
 	} else if (level >= mp->m_refc_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_refc_mxr[level != 0]);
 }
 
 STATIC void
@@ -247,7 +247,7 @@ xfs_refcountbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_refcountbt_verify(bp);
@@ -271,7 +271,7 @@ xfs_refcountbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 18168db6ed0e..2b7504f7a083 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -334,7 +334,7 @@ xfs_rmapbt_verify(
 
 	if (!xfs_has_rmapbt(mp))
 		return __this_address;
-	fa = xfs_btree_sblock_v5hdr_verify(bp);
+	fa = xfs_btree_agblock_v5hdr_verify(bp);
 	if (fa)
 		return fa;
 
@@ -345,7 +345,7 @@ xfs_rmapbt_verify(
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;
 
-	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
+	return xfs_btree_agblock_verify(bp, mp->m_rmap_mxr[level != 0]);
 }
 
 static void
@@ -354,7 +354,7 @@ xfs_rmapbt_read_verify(
 {
 	xfs_failaddr_t	fa;
 
-	if (!xfs_btree_sblock_verify_crc(bp))
+	if (!xfs_btree_agblock_verify_crc(bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
 	else {
 		fa = xfs_rmapbt_verify(bp);
@@ -378,7 +378,7 @@ xfs_rmapbt_write_verify(
 		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 		return;
 	}
-	xfs_btree_sblock_calc_crc(bp);
+	xfs_btree_agblock_calc_crc(bp);
 
 }
 

