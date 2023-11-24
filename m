Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94FF2C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmJ+yqPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876BBC433C8;
	Fri, 24 Nov 2023 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869661;
	bh=QirfhiiShyfDAlWtK6sUT02ifUECfWECDkA6S5t5gbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pmJ+yqPIkE0wACkB2OvX6oSQdMg4deTORzke2JfHFlpdrhswfL8yubRuunJs5Ia7M
	 bMFEJTebtONoKDVtdjnDj67Rq9EEHprhWKUvx6zWkuiZRYSAG/uaapnZZ6mDIcSZj1
	 87OtAr9BumGlw4EaWflm6jLDur8RM1xplZShbPf9L5SPuN3hYsV410lKfGnkJTtmZV
	 +2FpE+u52DVfXtktn+zHGXEmCj7UG34hT34z3E+WFURUkIlg1vKiCvGnqys/LLD2F0
	 Qv5DsygoPBMlpmZ7pEAajzelAuVcy86r48lu84i9pKBT4ECcnnzLNYW7ixmDOvFDJZ
	 vYxihd7JlhL6w==
Date: Fri, 24 Nov 2023 15:47:41 -0800
Subject: [PATCH 3/7] xfs: remove __xfs_free_extent_later
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926175.2768790.12526519062399034942.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
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

xfs_free_extent_later is a trivial helper, so remove it to reduce the
amount of thinking required to understand the deferred freeing
interface.  This will make it easier to introduce automatic reaping of
speculative allocations in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             |    2 +-
 fs/xfs/libxfs/xfs_alloc.c          |    2 +-
 fs/xfs/libxfs/xfs_alloc.h          |   14 +-------------
 fs/xfs/libxfs/xfs_bmap.c           |    4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |    5 +++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_refcount.c       |    6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
 fs/xfs/scrub/reap.c                |    2 +-
 fs/xfs/xfs_extfree_item.c          |    2 +-
 fs/xfs/xfs_reflink.c               |    2 +-
 12 files changed, 17 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f9f4d694640d0..f62ff125a50ac 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -984,7 +984,7 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
+		err2 = xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
 				XFS_AG_RESV_NONE, true);
 		if (err2)
 			goto resv_err;
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 100ab5931b313..c35224ad9428a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2523,7 +2523,7 @@ xfs_defer_agfl_block(
  * The list is maintained sorted (by block number).
  */
 int
-__xfs_free_extent_later(
+xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6bb8d295c321d..6b95d1d8a8537 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be62acffad6cc..68be1dd4f0f26 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -575,7 +575,7 @@ xfs_bmap_btree_to_extents(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
-			XFS_AG_RESV_NONE);
+			XFS_AG_RESV_NONE, false);
 	if (error)
 		return error;
 
@@ -5218,7 +5218,7 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			error = __xfs_free_extent_later(tp, del->br_startblock,
+			error = xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					XFS_AG_RESV_NONE,
 					((bflags & XFS_BMAPI_NODISCARD) ||
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index bf3f1b36fdd23..8360256cff168 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -272,7 +272,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
-			XFS_AG_RESV_NONE);
+			XFS_AG_RESV_NONE, false);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c709069..d61d03e5b853b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1854,7 +1854,7 @@ xfs_difree_inode_chunk(
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
-				XFS_AG_RESV_NONE);
+				XFS_AG_RESV_NONE, false);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1900,7 +1900,8 @@ xfs_difree_inode_chunk(
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE);
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE,
+				false);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9258f01c0015e..42a5e1f227a05 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -161,7 +161,7 @@ __xfs_inobt_free_block(
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_INOBT, resv);
+			&XFS_RMAP_OINFO_INOBT, resv, false);
 }
 
 STATIC int
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 646b3fa362ad0..3702b4a071100 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1153,7 +1153,7 @@ xfs_refcount_adjust_extents(
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
-						  XFS_AG_RESV_NONE);
+						  XFS_AG_RESV_NONE, false);
 				if (error)
 					goto out_error;
 			}
@@ -1215,7 +1215,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
-					XFS_AG_RESV_NONE);
+					XFS_AG_RESV_NONE, false);
 			if (error)
 				goto out_error;
 		}
@@ -1985,7 +1985,7 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
 				rr->rr_rrec.rc_blockcount, NULL,
-				XFS_AG_RESV_NONE);
+				XFS_AG_RESV_NONE, false);
 		if (error)
 			goto out_trans;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 5c3987d8dc242..3fa795e2488dd 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -112,7 +112,7 @@ xfs_refcountbt_free_block(
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
-			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA, false);
 }
 
 STATIC int
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 86a62420e02c6..78c9f2085db46 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -410,7 +410,7 @@ xreap_agextent_iter(
 	 * Use deferred frees to get rid of the old btree blocks to try to
 	 * minimize the window in which we could crash and lose the old blocks.
 	 */
-	error = __xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
+	error = xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
 			rs->resv, true);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3fa8789820ad9..9e7b58f3566c0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -717,7 +717,7 @@ xfs_efi_item_recover(
 			error = xfs_free_extent_later(tp, fake.xefi_startblock,
 					fake.xefi_blockcount,
 					&XFS_RMAP_OINFO_ANY_OWNER,
-					fake.xefi_agresv);
+					fake.xefi_agresv, false);
 			if (!error) {
 				requeue_only = true;
 				continue;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc284664..d5ca8bcae65b6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -618,7 +618,7 @@ xfs_reflink_cancel_cow_blocks(
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
 					del.br_blockcount, NULL,
-					XFS_AG_RESV_NONE);
+					XFS_AG_RESV_NONE, false);
 			if (error)
 				break;
 

