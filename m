Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661A238B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFvwkL9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0344C433C8;
	Mon,  1 Jan 2024 00:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067549;
	bh=hsFiDo/Vgiq2SIIYlcDn1QfRZpBL4Kna3PNVw6/Itj0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VFvwkL9jziUFYbl0tDQ/hl0d7PqoNQBWc7+iIOq3F8pMZ5u7PZ93/CCLBnim+7hX3
	 3o5b3sE+4IM3BlrXDqxQawG30CGjNuKbx72NSvlu2UyNpFpCrFNKyTbN6/NJR+YZT5
	 Ro5H7aW4mbLikBnWfWK8rxtgSQmWhNp35FwVXRvQQyywMPCzQGpD61S3Zpxo/ZEX46
	 zjCT3XqQSzBIf5O8N1JWbte/F/BE8VKZcaAJhTiPSoFHA/IoHgX4dixoV1lFfvaGD6
	 POEjiS5jiCxvNYXl2YhJCUutMFuQL4zE/Ent2zk7oc18It+x8516JSVJthgnoynqh0
	 yhWlUicDCGc3w==
Date: Sun, 31 Dec 2023 16:05:49 +9900
Subject: [PATCH 2/8] xfs: convert "skip_discard" to a proper flags bitset
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014068.1814860.302450409363918197.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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
index f22d58ad040..ac6b0090825 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -978,7 +978,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				XFS_AG_RESV_NONE, true);
+				XFS_AG_RESV_NONE, XFS_FREE_EXTENT_SKIP_DISCARD);
 		if (err2)
 			goto resv_err;
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 08cdfe7e3d3..442a045378c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2587,7 +2587,7 @@ xfs_defer_extent_free(
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type,
-	bool				skip_discard,
+	unsigned int			free_flags,
 	struct xfs_defer_pending	**dfpp)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2607,6 +2607,7 @@ xfs_defer_extent_free(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
+	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
@@ -2618,7 +2619,7 @@ xfs_defer_extent_free(
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	xefi->xefi_agresv = type;
-	if (skip_discard)
+	if (free_flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
@@ -2646,11 +2647,11 @@ xfs_free_extent_later(
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
 
@@ -2675,13 +2676,13 @@ xfs_free_extent_later(
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
index 0b956f8b9d5..2da543fb90e 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7fefbb7d21c..323f60b1128 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -582,7 +582,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
@@ -5260,11 +5260,15 @@ xfs_bmap_del_extent_real(
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
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 8658e7c390a..f98cc408540 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -269,7 +269,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE, false);
+			XFS_AG_RESV_NONE, 0);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8aae4b79c85..935f8127c0e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1960,7 +1960,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE, false);
+				XFS_AG_RESV_NONE, 0);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -2006,8 +2006,7 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
-				false);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 80d28d3fea5..a5f2ccec2e9 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -160,7 +160,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv, false);
+			&XFS_RMAP_OINFO_INOBT, resv, 0);
 }
 
 STATIC int
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index fe63b9eec8a..6c6634675c2 100644
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
index 1fbd250c1a8..c57e89f4be8 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -107,7 +107,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, 0);
 }
 
 STATIC int
diff --git a/repair/bulkload.c b/repair/bulkload.c
index a97839f549d..e9c52afd23c 100644
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
 

