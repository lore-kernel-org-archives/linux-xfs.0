Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53998BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMa7anwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B31C433C7;
	Sun, 31 Dec 2023 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058010;
	bh=fuAF200cZdxxxPCPLPmxEbzmq/17DVxLf6R2JGZmEuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rMa7anwWSlttBdFi10mQHrG3ceNszxFPAYrartozY3AMpQzaIjCZPX1sLNbQUnShG
	 rA8hgkxG1rCdBl4qXg1OKITAkEgrnD+/Y3iqPug7VZ15+1AXw2H9+4kNuLl9LGpi7/
	 Aq75kdpJfkkmtfDFkhSNyCRO1w7wd0kntc7UCLVn3T4Xkqi1yz5bOPeLA3P+zTDrJc
	 6p3/fyE6fycFBzF05iT+EsRD36RVpQy3RRrFySQjBRYzCVAqqxr3CPYgX82CpXM0hH
	 r0LlgrIBDrKLGgAxH9jqJx8paIfeCM2Kj2P9aFMt75RAw1j2FSIgfwO03DyDKCM9tT
	 1Nnc7RBb0oHXg==
Date: Sun, 31 Dec 2023 13:26:49 -0800
Subject: [PATCH 2/9] xfs: convert "skip_discard" to a proper flags bitset
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404848368.1764329.5255215453240604553.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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
index 136e02bb1c9eb..35deb474a7cf0 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -980,7 +980,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				XFS_AG_RESV_NONE, true);
+				XFS_AG_RESV_NONE, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (err2)
 			goto resv_err;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0d8cddb1b41ce..1ea88d4675f5f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2591,7 +2591,7 @@ xfs_defer_extent_free(
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard,
+	unsigned int			free_flags,
 	struct xfs_defer_pending	**dfpp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2611,6 +2611,7 @@ xfs_defer_extent_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
+	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
@@ -2622,7 +2623,7 @@ xfs_defer_extent_free(
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	xefi->xefi_agresv = type;
-	if (skip_discard)
+	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
@@ -2650,11 +2651,11 @@ xfs_free_extent_later(
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
 
@@ -2679,13 +2680,13 @@ xfs_free_extent_later(
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
index 2bc0b76bcfbbb..ce9c247525a3d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -588,7 +588,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
@@ -5266,11 +5266,15 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
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
 			if (error)
 				return error;
 		}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 0a5020c8e0f5e..a6de8b7528aa1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -271,7 +271,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7278392a8f949..46c0bb67e4c47 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1965,7 +1965,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -2011,8 +2011,7 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
-				false);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 4a220946d99ca..bb6d4eb6698ca 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -161,7 +161,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv, false);
+			&XFS_RMAP_OINFO_INOBT, resv, 0);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 90a4526fef929..e30c4cdfaa392 100644
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
index ce42ecd3e3715..c2e20854f9bc2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -108,7 +108,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, 0);
 }
 
 STATIC int
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index ad2da235d21bb..8375c8b9752a7 100644
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
index 01ceaa4efa16b..37eb61906be18 100644
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
index 69dfd7e430fe7..7e9273cc16e14 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -619,7 +619,7 @@ xfs_reflink_cancel_cow_blocks(
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
 					del.br_blockcount, NULL,
-					XFS_AG_RESV_NONE, false);
+					XFS_AG_RESV_NONE, 0);
 			if (error)
 				break;
 

