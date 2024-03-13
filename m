Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32E0A951
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295049; cv=none; b=cb2+sLdBdHI64VngtPTvIPGTzqsTFZJHMj+azPF2xiOhxu/QAVYM2CkpbWAU9ArNod/Oh8DFTu091TZrleAXXMj3rASWlr4U0muwGqzfQwBCnr2CdDMIYIhDczRY0yZTjxBpHDRcpgpj4Iz0JJeeXJKKctW0Ruxdl0zbFoTLeko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295049; c=relaxed/simple;
	bh=cS7OJpJHoDkdBrgAP/jm20wAQvoA9BpEMGEsrXMIY+M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbkqf5sPn2vIq9IvDQUh6Ub2FBOmzIrtHU6yJz4R6oNjomT6a3MPoXc0lewoOSsS1B4HIARGKaebV9MUOCYUftMeKrJ1QcNVSrcRCVH17iIdGh59mzQRTBssgbO4sRJymqXVM2t0UHe7m7WbZBG0Fp+E1KEv0pGB4FbtUuwLvcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJUd1IqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJUd1IqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE8AC433F1;
	Wed, 13 Mar 2024 01:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295048;
	bh=cS7OJpJHoDkdBrgAP/jm20wAQvoA9BpEMGEsrXMIY+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jJUd1IqE6MPp7wDkA6vaBKSoVZerU+1uY/mHijSGxmeHsGqcr705A240JRIDZhgBz
	 O7dIL5OZ8nKGxY6AvqLPAq+qDBdOoihGTPntQSgVdC4+j7Gmj/kXUFOIH9ljgypNn2
	 CFpX7j6KehVTnesIPTQY1jnhaqMdxE1rdQ9a66IQ8P6F9aZTf6VV2jz50jMUBbLLYx
	 NL1MUGw3W8nGoHrui9amgNvlxX25b6jUob3ncaEVOShfv23WsavJPezmnZp44pK8cB
	 su8uAH485fMb19MKZlmtCHkmOvYIExjP1BZvf6FtAtbeHmh4fbELjowcFRVCWk8b2p
	 BOPNM5c+cOR+Q==
Date: Tue, 12 Mar 2024 18:57:28 -0700
Subject: [PATCH 17/67] xfs: remove __xfs_free_extent_later
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431439.2061787.18202538769819164762.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4c88fef3af4a51c2cdba6a28237e98da4873e8dc

xfs_free_extent_later is a trivial helper, so remove it to reduce the
amount of thinking required to understand the deferred freeing
interface.  This will make it easier to introduce automatic reaping of
speculative allocations in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c             |    2 +-
 libxfs/xfs_alloc.c          |    2 +-
 libxfs/xfs_alloc.h          |   14 +-------------
 libxfs/xfs_bmap.c           |    4 ++--
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_ialloc.c         |    5 +++--
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_refcount.c       |    6 +++---
 libxfs/xfs_refcount_btree.c |    2 +-
 9 files changed, 14 insertions(+), 25 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ac34a1c233c2..bdb8a08bbea7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -982,7 +982,7 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
+		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
 				XFS_AG_RESV_NONE, true);
 		if (err2)
 			goto resv_err;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 7ac7c2f6cc4c..0a2404466f69 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2519,7 +2519,7 @@ xfs_defer_agfl_block(
  * The list is maintained sorted (by block number).
  */
 int
-__xfs_free_extent_later(
+xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6bb8d295c321..6b95d1d8a853 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -231,7 +231,7 @@ xfs_buf_to_agfl_bno(
 	return bp->b_addr;
 }
 
-int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
+int xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		enum xfs_ag_resv_type type, bool skip_discard);
 
@@ -256,18 +256,6 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
 
-static inline int
-xfs_free_extent_later(
-	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
-	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type		type)
-{
-	return __xfs_free_extent_later(tp, bno, len, oinfo, type, false);
-}
-
-
 extern struct kmem_cache	*xfs_extfree_item_cache;
 
 int __init xfs_extfree_intent_init_cache(void);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8fde0dc256f0..8c553d22c535 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -569,7 +569,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE);
+			XFS_AG_RESV_NONE, false);
 	if (error)
 		return error;
 
@@ -5212,7 +5212,7 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			error = __xfs_free_extent_later(tp, del->br_startblock,
+			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					XFS_AG_RESV_NONE,
 					((bflags & XFS_BMAPI_NODISCARD) ||
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 925cc153b209..c4d5c8a64747 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -270,7 +270,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE);
+			XFS_AG_RESV_NONE, false);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index a95675b1d3d0..14826280d46e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1849,7 +1849,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE);
+				XFS_AG_RESV_NONE, false);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1895,7 +1895,8 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
+				false);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 0c5d7ba1ce72..593cb1fcc1d9 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -160,7 +160,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv);
+			&XFS_RMAP_OINFO_INOBT, resv, false);
 }
 
 STATIC int
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index ae72f25077ad..2284b45fbb04 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1152,7 +1152,7 @@ xfs_refcount_adjust_extents(
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE);
+						  XFS_AG_RESV_NONE, false);
 				if (error)
 					goto out_error;
 			}
@@ -1214,7 +1214,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE);
+					XFS_AG_RESV_NONE, false);
 			if (error)
 				goto out_error;
 		}
@@ -1984,7 +1984,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE);
+				XFS_AG_RESV_NONE, false);
 		if (error)
 			goto out_trans;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 67cb59e33500..bc8bd867eee7 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -111,7 +111,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
 }
 
 STATIC int

