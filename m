Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCD17C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924711; cv=none; b=rURBRW9WylurctdI7q+EzHIY9qAqfv0XFgO9Xqj3fmQ0xNGrTHu2lQ5dYh624PRb1iPqBLPh7EdAwXNK39gZywyxZlci7LLLGVCdufMoXvQQp/IbGyclqmH6tENANFzDi2Kih3slCf9QV73Ktyz8ylTxcCfCgkEQdHxcUHKlPIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924711; c=relaxed/simple;
	bh=z4OBXrY2HuCRSPgUXEyvtlL3xuDo3f6aZhQ9kQoGqtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pU80Itb0xgW3F/Jd3dzFtexcbiw67yVl7zmUF6YrGAAlYjRTahFTEF8XvVpYBVTtYXMZPSx5J9yDl28B9yI9bKo+g60LNbNoLNsNtQBLXnds0oUQpP0kOl0r0Qlf9CP3diTtTpPP850bfDjdrUdZErOWXfUszY+lhD0VJDkPFXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FME1/Gah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FME1/Gah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584E1C2BD10;
	Thu, 20 Jun 2024 23:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924711;
	bh=z4OBXrY2HuCRSPgUXEyvtlL3xuDo3f6aZhQ9kQoGqtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FME1/GahLS9EBja+SRaO83Nlxt5Ckh0vvkQcYouK4uQXRweOdiuYHyOdg+opildl1
	 eSs9LL07iVcN3OrP4WefWXqly5jj2XLDqjJdzLhqnc0wgXZScHk2lzqXm1Xyk2id39
	 4FSG0PzJmS493pGKFR/cJ0WW/IYxAFPee9fEqgHz/4evPXPnXLJI24euhgFR4ey25Z
	 AI3C8FGwIvUsskl4fPbCeZ2UO+IAFemsKUcrU86UX+GYoMR6SyNgTnmRqvxdAIBnS0
	 xyV1wxgUU2nDvrpZLNypseOGeXqk4y8zsPmmZEWqJ5Z/OMMHsNEoPLoQVeWq1vgEZA
	 /ZYlaPWpPAsnA==
Date: Thu, 20 Jun 2024 16:05:10 -0700
Subject: [PATCH 2/9] xfs: convert "skip_discard" to a proper flags bitset
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418730.3183906.8429370486663214449.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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

Convert the boolean to skip discard on free into a proper flags field so
that we can add more flags in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             |    2 +-
 fs/xfs/libxfs/xfs_alloc.c          |   13 +++++++------
 fs/xfs/libxfs/xfs_alloc.h          |    9 +++++++--
 fs/xfs/libxfs/xfs_bmap.c           |   12 ++++++++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |    5 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_refcount.c       |    6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
 fs/xfs/scrub/newbt.c               |    5 +++--
 fs/xfs/scrub/reap.c                |    7 ++++---
 fs/xfs/xfs_reflink.c               |    2 +-
 12 files changed, 39 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 240e079cb3fbb..7e80732cb5470 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -1008,7 +1008,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				XFS_AG_RESV_NONE, true);
+				XFS_AG_RESV_NONE, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (err2)
 			goto resv_err;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9a8110e530b55..9c6dc82539639 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2588,7 +2588,7 @@ xfs_defer_extent_free(
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard,
+	unsigned int			free_flags,
 	struct xfs_defer_pending	**dfpp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2608,6 +2608,7 @@ xfs_defer_extent_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
+	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
@@ -2619,7 +2620,7 @@ xfs_defer_extent_free(
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	xefi->xefi_agresv = type;
-	if (skip_discard)
+	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
@@ -2647,11 +2648,11 @@ xfs_free_extent_later(
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
 
@@ -2676,13 +2677,13 @@ xfs_free_extent_later(
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
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0b956f8b9d5a7..2da543fb90ecd 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -233,7 +233,12 @@ xfs_buf_to_agfl_bno(
 
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
@@ -262,7 +267,7 @@ struct xfs_alloc_autoreap {
 };
 
 int xfs_alloc_schedule_autoreap(const struct xfs_alloc_arg *args,
-		bool skip_discard, struct xfs_alloc_autoreap *aarp);
+		unsigned int free_flags, struct xfs_alloc_autoreap *aarp);
 void xfs_alloc_cancel_autoreap(struct xfs_trans *tp,
 		struct xfs_alloc_autoreap *aarp);
 void xfs_alloc_commit_autoreap(struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 09e3302a4b72f..7df74c35d9f90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -605,7 +605,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
@@ -5381,11 +5381,15 @@ xfs_bmap_del_extent_real(
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index f5d84dcb58da0..d1b06ccde19ea 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -282,7 +282,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f8d5ed7aedde8..0af5b7a33d055 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1990,7 +1990,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -2036,8 +2036,7 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
-				false);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 42e9fd47f6c73..496e2f72a85b9 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -170,7 +170,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv, false);
+			&XFS_RMAP_OINFO_INOBT, resv, 0);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 511c912d515c9..4d8bb760c7235 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1173,7 +1173,7 @@ xfs_refcount_adjust_extents(
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE, false);
+						  XFS_AG_RESV_NONE, 0);
 				if (error)
 					goto out_error;
 			}
@@ -1237,7 +1237,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE, false);
+					XFS_AG_RESV_NONE, 0);
 			if (error)
 				goto out_error;
 		}
@@ -2022,7 +2022,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 		if (error)
 			goto out_trans;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index ca59f6c89f3e3..cb3b1d42ae9a8 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -109,7 +109,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, 0);
 }
 
 STATIC int
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 4a0271123d94e..2aa14b7ab6306 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -160,7 +160,8 @@ xrep_newbt_add_blocks(
 	if (args->tp) {
 		ASSERT(xnr->oinfo.oi_offset == 0);
 
-		error = xfs_alloc_schedule_autoreap(args, true, &resv->autoreap);
+		error = xfs_alloc_schedule_autoreap(args,
+				XFS_FREE_EXTENT_SKIP_DISCARD, &resv->autoreap);
 		if (error)
 			goto out_pag;
 	}
@@ -414,7 +415,7 @@ xrep_newbt_free_extent(
 	 */
 	fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
 	error = xfs_free_extent_later(sc->tp, fsbno, free_aglen, &xnr->oinfo,
-			xnr->resv, true);
+			xnr->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index be283153c254e..53697f3c5e1b0 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -451,7 +451,7 @@ xreap_agextent_iter(
 
 		xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
 		error = xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL,
-				rs->resv, true);
+				rs->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (error)
 			return error;
 
@@ -477,7 +477,7 @@ xreap_agextent_iter(
 	 * system with large EFIs.
 	 */
 	error = xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
-			rs->resv, true);
+			rs->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
 	if (error)
 		return error;
 
@@ -943,7 +943,8 @@ xrep_reap_bmapi_iter(
 	xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
 			-(int64_t)imap->br_blockcount);
 	return xfs_free_extent_later(sc->tp, imap->br_startblock,
-			imap->br_blockcount, NULL, XFS_AG_RESV_NONE, true);
+			imap->br_blockcount, NULL, XFS_AG_RESV_NONE,
+			XFS_FREE_EXTENT_SKIP_DISCARD);
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 265a2a418bc7b..6fde6ec8092f0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -603,7 +603,7 @@ xfs_reflink_cancel_cow_blocks(
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
 					del.br_blockcount, NULL,
-					XFS_AG_RESV_NONE, false);
+					XFS_AG_RESV_NONE, 0);
 			if (error)
 				break;
 

