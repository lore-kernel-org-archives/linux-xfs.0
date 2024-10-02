Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1FB2F22
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831802; cv=none; b=NqP0qv82QCCfH3qCNMpxQCjk4PsXo+pFrKvfuU+4DjxkY+mMCCRYNf6z9w+ZFj3wlIbE5g0fHrD5fnIsBV1FqFqghhGypZs8kxLQb36tzS+gNWTaYdyqFd39Kz5a36To9tNruEIkET1whKtsK9j6vxhsHeFbB3qxF04WGqb0ejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831802; c=relaxed/simple;
	bh=Sn0tvy1BP6CbrPhRoKkFGkzKEZGPx7sqEfBM1MJsNX0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHfPcIV6zrQQ2m7qdFvx3DzrZUot453itS7l/yPjLeFSyNmdaJatjJuTfiz00mVDFlEUQejdvz+TJw3Sfy1Tcbp6HEuWWb/8ertpAqdtuDKP6i4LeyETNjPJCB5d+TE83LiXFbjgM2vxgP00zPVgXgQ/xTd1Bv7D3Nw5C7JfkUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwKEqUpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwKEqUpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BAC4CEC6;
	Wed,  2 Oct 2024 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831801;
	bh=Sn0tvy1BP6CbrPhRoKkFGkzKEZGPx7sqEfBM1MJsNX0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HwKEqUpk+dAAHmP6Llk3XAbn6TfhTXbTJ31pP60vgglO8T+z1S7sqIIrtMQfHwXEM
	 VjWhJXEYEbOTd+cthC1IJhzsPO4QCqMWDRG676y79n1h9KlpD0jGxcOlj27AIf3xt9
	 EDMoOXv2kWFoyoykaRe5gJIi59h452bIyi4BLAt/RVF7iniS5XTEUiQqCLwO6Mln0t
	 GhGWxF2+0gh7QFhNdQ++6kQj/FfgKbgOb9d2bry8t3uex5ffq8aW7y0XQebDRRTFYl
	 CWTQb3ilGP+SjaFHaU/zB16wfKVR3vao/dEiaMO8sF3QAq43E1ohlcpvlano2FN64/
	 KShJKIM0SFAog==
Date: Tue, 01 Oct 2024 18:16:41 -0700
Subject: [PATCH 34/64] xfs: convert "skip_discard" to a proper flags bitset
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102294.4036371.16777725362646870986.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 980faece91a60c279e7c24cb1d1a378bbbb74bb9

Convert the boolean to skip discard on free into a proper flags field so
that we can add more flags in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c             |    2 +-
 libxfs/xfs_alloc.c          |   13 +++++++------
 libxfs/xfs_alloc.h          |    9 +++++++--
 libxfs/xfs_bmap.c           |   12 ++++++++----
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_ialloc.c         |    5 ++---
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_refcount.c       |    6 +++---
 libxfs/xfs_refcount_btree.c |    2 +-
 repair/bulkload.c           |    3 ++-
 10 files changed, 33 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 47522d0fc..ed9ac7f58 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -1006,7 +1006,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				XFS_AG_RESV_NONE, true);
+				XFS_AG_RESV_NONE, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (err2)
 			goto resv_err;
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 48fdffd46..6f792d280 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2558,7 +2558,7 @@ xfs_defer_extent_free(
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard,
+	unsigned int			free_flags,
 	struct xfs_defer_pending	**dfpp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2578,6 +2578,7 @@ xfs_defer_extent_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
+	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
@@ -2589,7 +2590,7 @@ xfs_defer_extent_free(
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	xefi->xefi_agresv = type;
-	if (skip_discard)
+	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
@@ -2617,11 +2618,11 @@ xfs_free_extent_later(
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard)
+	unsigned int			free_flags)
 {
 	struct xfs_defer_pending	*dontcare = NULL;
 
-	return xfs_defer_extent_free(tp, bno, len, oinfo, type, skip_discard,
+	return xfs_defer_extent_free(tp, bno, len, oinfo, type, free_flags,
 			&dontcare);
 }
 
@@ -2646,13 +2647,13 @@ xfs_free_extent_later(
 int
 xfs_alloc_schedule_autoreap(
 	const struct xfs_alloc_arg	*args,
-	bool				skip_discard,
+	unsigned int			free_flags,
 	struct xfs_alloc_autoreap	*aarp)
 {
 	int				error;
 
 	error = xfs_defer_extent_free(args->tp, args->fsbno, args->len,
-			&args->oinfo, args->resv, skip_discard, &aarp->dfp);
+			&args->oinfo, args->resv, free_flags, &aarp->dfp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 3dc8e44fe..7f51b3cb0 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -235,7 +235,12 @@ xfs_buf_to_agfl_bno(
 
 int xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
-		enum xfs_ag_resv_type type, bool skip_discard);
+		enum xfs_ag_resv_type type, unsigned int free_flags);
+
+/* Don't issue a discard for the blocks freed. */
+#define XFS_FREE_EXTENT_SKIP_DISCARD	(1U << 0)
+
+#define XFS_FREE_EXTENT_ALL_FLAGS	(XFS_FREE_EXTENT_SKIP_DISCARD)
 
 /*
  * List of extents to be free "later".
@@ -264,7 +269,7 @@ struct xfs_alloc_autoreap {
 };
 
 int xfs_alloc_schedule_autoreap(const struct xfs_alloc_arg *args,
-		bool skip_discard, struct xfs_alloc_autoreap *aarp);
+		unsigned int free_flags, struct xfs_alloc_autoreap *aarp);
 void xfs_alloc_cancel_autoreap(struct xfs_trans *tp,
 		struct xfs_alloc_autoreap *aarp);
 void xfs_alloc_commit_autoreap(struct xfs_trans *tp,
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5f4446104..4b10f169f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -599,7 +599,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
@@ -5375,11 +5375,15 @@ xfs_bmap_del_extent_real(
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 		} else {
+			unsigned int	efi_flags = 0;
+
+			if ((bflags & XFS_BMAPI_NODISCARD) ||
+			    del->br_state == XFS_EXT_UNWRITTEN)
+				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
+
 			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
-					XFS_AG_RESV_NONE,
-					((bflags & XFS_BMAPI_NODISCARD) ||
-					del->br_state == XFS_EXT_UNWRITTEN));
+					XFS_AG_RESV_NONE, efi_flags);
 		}
 		if (error)
 			return error;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2a603b4d1..a14ca3595 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -281,7 +281,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index cef2819aa..c526f677e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1985,7 +1985,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -2031,8 +2031,7 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
-				false);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5db9d0b33..5042cc62f 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -169,7 +169,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv, false);
+			&XFS_RMAP_OINFO_INOBT, resv, 0);
 }
 
 STATIC int
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 47049488b..b4e6900be 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1172,7 +1172,7 @@ xfs_refcount_adjust_extents(
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE, false);
+						  XFS_AG_RESV_NONE, 0);
 				if (error)
 					goto out_error;
 			}
@@ -1236,7 +1236,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE, false);
+					XFS_AG_RESV_NONE, 0);
 			if (error)
 				goto out_error;
 		}
@@ -2021,7 +2021,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 		if (error)
 			goto out_trans;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 362b2a2d7..162f9e689 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -108,7 +108,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, 0);
 }
 
 STATIC int
diff --git a/repair/bulkload.c b/repair/bulkload.c
index d36e32d99..c96e569ef 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -196,7 +196,8 @@ bulkload_free_extent(
 	 */
 	fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
 	error = -libxfs_free_extent_later(sc->tp, fsbno, free_aglen,
-			&bkl->oinfo, XFS_AG_RESV_NONE, true);
+			&bkl->oinfo, XFS_AG_RESV_NONE,
+			XFS_FREE_EXTENT_SKIP_DISCARD);
 	if (error)
 		return error;
 

