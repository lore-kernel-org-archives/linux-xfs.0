Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305A41D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424520; cv=none; b=id3/CaavznBEMiERSl2+CFvnhvSRMY15wEKbzgGiT/uprwdZCL7PGruKFOIwXURHVtfqWA9Yq4enRG/kp1DMQQs1iMFIjRcgG667uuU2H4YdL3IOP2Tap9Kd4nWX0Szz1NE1ZHmRjdBtg8qb9rdK6rZdGEA8xn8g+4+UGyNiTJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424520; c=relaxed/simple;
	bh=314ObLGT0d2nu8pjCIJhg953yK3sha+eOn8bXv4A0q8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXn0CV6AgyjNxPEOJP4vkhE2s2RSEKQsX2qpxhW46AVaMOb9yKOJuW9341hRsKz5YsuquA++C6Qk0XtOf5bvFJb1R1LQKvYiPsmQyW4UaF0vKSWFBRcgQwCqo+UaqNdbQ2unEY4PFx/wuVnOClz1dU+K6o86nh/eMegDYloCPy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIw5w0x4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIw5w0x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B0DC433F1;
	Tue, 26 Mar 2024 03:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424519;
	bh=314ObLGT0d2nu8pjCIJhg953yK3sha+eOn8bXv4A0q8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eIw5w0x436YNduwFtOWbC5UmHvpHG4VWk9swoApHx8HhA5ZmAKXpqxGDRbRsbwPrl
	 ve+eCVoxjagGAQUOM1IipbUdvqElzrUFTLkpMjAJwtNuBCPqGLYmmMyVhIzemIbSSp
	 QMkMIfY4V4wnBhkkGf462Zl8DpsMtblQqhsRH+PkbzYnuG56+6jC/g9xHtm+OTMcx9
	 p5Our4TZr/WZgfIKOF/APm+fkkZVq5d3bu0BdKwtl6Q4p8qOfg7EMBm6y+TMWkNJ/G
	 AzflPWNxmScZ2Idte/fK/UK3UwQT83djg4Gr5UDjUogkW4OfJ5/8TiIUnwlCauJxbq
	 zYk3Q65Gfo7yg==
Date: Mon, 25 Mar 2024 20:41:59 -0700
Subject: [PATCH 052/110] xfs: don't override bc_ops for staging btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132133.2215168.11653738399929029050.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2b9e7f2668c540f18afd66a053ea78f3a629f8e2

Add a few conditionals for staging btrees to the core btree code instead
of overloading the bc_ops vector.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    6 --
 libxfs/xfs_bmap_btree.c     |    6 +-
 libxfs/xfs_btree.c          |   75 +++++++++++++++++++++++-------
 libxfs/xfs_btree_staging.c  |  109 +------------------------------------------
 libxfs/xfs_btree_staging.h  |    7 +--
 libxfs/xfs_ialloc_btree.c   |    4 +-
 libxfs/xfs_refcount_btree.c |    2 -
 libxfs/xfs_rmap_btree.c     |    2 -
 8 files changed, 72 insertions(+), 139 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index b18ac70451eb..6b17037f807d 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -592,11 +592,7 @@ xfs_allocbt_commit_staged_btree(
 	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
-	} else {
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
-	}
+	xfs_btree_commit_afakeroot(cur, tp, agbp);
 }
 
 /* Calculate number of records in an alloc btree block. */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 7fc325fd344c..611f5ed962bd 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -608,7 +608,6 @@ xfs_bmbt_stage_cursor(
 	struct xbtree_ifakeroot	*ifake)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_btree_ops	*ops;
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
@@ -617,8 +616,7 @@ xfs_bmbt_stage_cursor(
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
-	xfs_btree_stage_ifakeroot(cur, ifake, &ops);
-	ops->update_cursor = NULL;
+	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }
 
@@ -662,7 +660,7 @@ xfs_bmbt_commit_staged_btree(
 		break;
 	}
 	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
-	xfs_btree_commit_ifakeroot(cur, tp, whichfork, &xfs_bmbt_ops);
+	xfs_btree_commit_ifakeroot(cur, tp, whichfork);
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index f59fa54e3ea6..42a1ed786284 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -404,6 +404,15 @@ xfs_btree_free_block(
 
 	trace_xfs_btree_free_block(cur, bp);
 
+	/*
+	 * Don't allow block freeing for a staging cursor, because staging
+	 * cursors do not support regular btree modifications.
+	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
 	error = cur->bc_ops->free_block(cur, bp);
 	if (!error) {
 		xfs_trans_binval(cur->bc_tp, bp);
@@ -455,8 +464,6 @@ xfs_btree_del_cursor(
 		break;
 	}
 
-	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kfree(cur->bc_ops);
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
@@ -464,20 +471,26 @@ xfs_btree_del_cursor(
  * Duplicate the btree cursor.
  * Allocate a new one, copy the record, re-get the buffers.
  */
-int					/* error */
+int						/* error */
 xfs_btree_dup_cursor(
-	struct xfs_btree_cur *cur,		/* input cursor */
-	struct xfs_btree_cur **ncur)		/* output cursor */
+	struct xfs_btree_cur	*cur,		/* input cursor */
+	struct xfs_btree_cur	**ncur)		/* output cursor */
 {
-	struct xfs_buf	*bp;		/* btree block's buffer pointer */
-	int		error;		/* error return value */
-	int		i;		/* level number of btree block */
-	xfs_mount_t	*mp;		/* mount structure for filesystem */
-	struct xfs_btree_cur *new;		/* new cursor value */
-	xfs_trans_t	*tp;		/* transaction pointer, can be NULL */
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_trans	*tp = cur->bc_tp;
+	struct xfs_buf		*bp;
+	struct xfs_btree_cur	*new;
+	int			error;
+	int			i;
 
-	tp = cur->bc_tp;
-	mp = cur->bc_mp;
+	/*
+	 * Don't allow staging cursors to be duplicated because they're supposed
+	 * to be kept private to a single thread.
+	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * Allocate a new cursor like the old one.
@@ -1892,6 +1905,8 @@ xfs_btree_init_ptr_from_cur(
 		 * in xfs_btree_lookup_get_block and don't need a pointer here.
 		 */
 		ptr->l = 0;
+	} else if (cur->bc_flags & XFS_BTREE_STAGING) {
+		ptr->s = cpu_to_be32(cur->bc_ag.afake->af_root);
 	} else {
 		cur->bc_ops->init_ptr_from_cur(cur, ptr);
 	}
@@ -2713,6 +2728,18 @@ xfs_btree_alloc_block(
 {
 	int				error;
 
+	/*
+	 * Don't allow block allocation for a staging cursor, because staging
+	 * cursors do not support regular btree modifications.
+	 *
+	 * Bulk loading uses a separate callback to obtain new blocks from a
+	 * preallocated list, which prevents ENOSPC failures during loading.
+	 */
+	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
 	error = cur->bc_ops->alloc_block(cur, hint_block, new_block, stat);
 	trace_xfs_btree_alloc_block(cur, new_block, *stat, error);
 	return error;
@@ -3113,6 +3140,21 @@ xfs_btree_new_iroot(
 	return error;
 }
 
+static void
+xfs_btree_set_root(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
+{
+	if (cur->bc_flags & XFS_BTREE_STAGING) {
+		/* Update the btree root information for a per-AG fake root. */
+		cur->bc_ag.afake->af_root = be32_to_cpu(ptr->s);
+		cur->bc_ag.afake->af_levels += inc;
+	} else {
+		cur->bc_ops->set_root(cur, ptr, inc);
+	}
+}
+
 /*
  * Allocate a new root block, fill it in.
  */
@@ -3153,7 +3195,7 @@ xfs_btree_new_root(
 		goto error0;
 
 	/* Set the root in the holding structure  increasing the level by 1. */
-	cur->bc_ops->set_root(cur, &lptr, 1);
+	xfs_btree_set_root(cur, &lptr, 1);
 
 	/*
 	 * At the previous root level there are now two blocks: the old root,
@@ -3581,7 +3623,8 @@ xfs_btree_insert(
 		if (pcur != cur &&
 		    (ncur || xfs_btree_ptr_is_null(cur, &nptr))) {
 			/* Save the state from the cursor before we trash it */
-			if (cur->bc_ops->update_cursor)
+			if (cur->bc_ops->update_cursor &&
+			    !(cur->bc_flags & XFS_BTREE_STAGING))
 				cur->bc_ops->update_cursor(pcur, cur);
 			cur->bc_nlevels = pcur->bc_nlevels;
 			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
@@ -3724,7 +3767,7 @@ xfs_btree_kill_root(
 	 * Update the root pointer, decreasing the level by 1 and then
 	 * free the old root.
 	 */
-	cur->bc_ops->set_root(cur, newroot, -1);
+	xfs_btree_set_root(cur, newroot, -1);
 
 	error = xfs_btree_free_block(cur, bp);
 	if (error)
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 656bad6cdb77..5a988a8bfdd2 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -38,63 +38,6 @@
  * specific btree type to commit the new btree into the filesystem.
  */
 
-/*
- * Don't allow staging cursors to be duplicated because they're supposed to be
- * kept private to a single thread.
- */
-STATIC struct xfs_btree_cur *
-xfs_btree_fakeroot_dup_cursor(
-	struct xfs_btree_cur	*cur)
-{
-	ASSERT(0);
-	return NULL;
-}
-
-/*
- * Don't allow block allocation for a staging cursor, because staging cursors
- * do not support regular btree modifications.
- *
- * Bulk loading uses a separate callback to obtain new blocks from a
- * preallocated list, which prevents ENOSPC failures during loading.
- */
-STATIC int
-xfs_btree_fakeroot_alloc_block(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_ptr	*start_bno,
-	union xfs_btree_ptr		*new_bno,
-	int				*stat)
-{
-	ASSERT(0);
-	return -EFSCORRUPTED;
-}
-
-/*
- * Don't allow block freeing for a staging cursor, because staging cursors
- * do not support regular btree modifications.
- */
-STATIC int
-xfs_btree_fakeroot_free_block(
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp)
-{
-	ASSERT(0);
-	return -EFSCORRUPTED;
-}
-
-/* Initialize a pointer to the root block from the fakeroot. */
-STATIC void
-xfs_btree_fakeroot_init_ptr_from_cur(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
-{
-	struct xbtree_afakeroot	*afake;
-
-	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
-
-	afake = cur->bc_ag.afake;
-	ptr->s = cpu_to_be32(afake->af_root);
-}
-
 /*
  * Bulk Loading for AG Btrees
  * ==========================
@@ -109,47 +52,20 @@ xfs_btree_fakeroot_init_ptr_from_cur(
  * cursor into a regular btree cursor.
  */
 
-/* Update the btree root information for a per-AG fake root. */
-STATIC void
-xfs_btree_afakeroot_set_root(
-	struct xfs_btree_cur		*cur,
-	const union xfs_btree_ptr	*ptr,
-	int				inc)
-{
-	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
-
-	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
-	afake->af_root = be32_to_cpu(ptr->s);
-	afake->af_levels += inc;
-}
-
 /*
  * Initialize a AG-rooted btree cursor with the given AG btree fake root.
- * The btree cursor's bc_ops will be overridden as needed to make the staging
- * functionality work.
  */
 void
 xfs_btree_stage_afakeroot(
 	struct xfs_btree_cur		*cur,
 	struct xbtree_afakeroot		*afake)
 {
-	struct xfs_btree_ops		*nops;
-
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
 	ASSERT(cur->bc_ops->type != XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
-	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
-	nops->free_block = xfs_btree_fakeroot_free_block;
-	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
-	nops->set_root = xfs_btree_afakeroot_set_root;
-	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
-
 	cur->bc_ag.afake = afake;
 	cur->bc_nlevels = afake->af_levels;
-	cur->bc_ops = nops;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 
@@ -163,18 +79,15 @@ void
 xfs_btree_commit_afakeroot(
 	struct xfs_btree_cur		*cur,
 	struct xfs_trans		*tp,
-	struct xfs_buf			*agbp,
-	const struct xfs_btree_ops	*ops)
+	struct xfs_buf			*agbp)
 {
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 	ASSERT(cur->bc_tp == NULL);
 
 	trace_xfs_btree_commit_afakeroot(cur);
 
-	kfree((void *)cur->bc_ops);
 	cur->bc_ag.afake = NULL;
 	cur->bc_ag.agbp = agbp;
-	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
@@ -212,28 +125,15 @@ xfs_btree_commit_afakeroot(
 void
 xfs_btree_stage_ifakeroot(
 	struct xfs_btree_cur		*cur,
-	struct xbtree_ifakeroot		*ifake,
-	struct xfs_btree_ops		**new_ops)
+	struct xbtree_ifakeroot		*ifake)
 {
-	struct xfs_btree_ops		*nops;
-
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
 	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
-	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
-	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
-	nops->free_block = xfs_btree_fakeroot_free_block;
-	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
-
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
-	cur->bc_ops = nops;
 	cur->bc_flags |= XFS_BTREE_STAGING;
-
-	if (new_ops)
-		*new_ops = nops;
 }
 
 /*
@@ -246,18 +146,15 @@ void
 xfs_btree_commit_ifakeroot(
 	struct xfs_btree_cur		*cur,
 	struct xfs_trans		*tp,
-	int				whichfork,
-	const struct xfs_btree_ops	*ops)
+	int				whichfork)
 {
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 	ASSERT(cur->bc_tp == NULL);
 
 	trace_xfs_btree_commit_ifakeroot(cur);
 
-	kfree((void *)cur->bc_ops);
 	cur->bc_ino.ifake = NULL;
 	cur->bc_ino.whichfork = whichfork;
-	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index 8e29cd3cc0f1..0c9c2ffb127a 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -22,7 +22,7 @@ struct xbtree_afakeroot {
 void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
 		struct xbtree_afakeroot *afake);
 void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
-		struct xfs_buf *agbp, const struct xfs_btree_ops *ops);
+		struct xfs_buf *agbp);
 
 /* Fake root for an inode-rooted btree. */
 struct xbtree_ifakeroot {
@@ -41,10 +41,9 @@ struct xbtree_ifakeroot {
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */
 void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
-		struct xbtree_ifakeroot *ifake,
-		struct xfs_btree_ops **new_ops);
+		struct xbtree_ifakeroot *ifake);
 void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
-		int whichfork, const struct xfs_btree_ops *ops);
+		int whichfork);
 
 /* Bulk loading of staged btrees. */
 typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 79ab04684f37..87471ba14f9d 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -536,7 +536,7 @@ xfs_inobt_commit_staged_btree(
 			fields |= XFS_AGI_IBLOCKS;
 		}
 		xfs_ialloc_log_agi(tp, agbp, fields);
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
+		xfs_btree_commit_afakeroot(cur, tp, agbp);
 	} else {
 		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
@@ -546,7 +546,7 @@ xfs_inobt_commit_staged_btree(
 			fields |= XFS_AGI_IBLOCKS;
 		}
 		xfs_ialloc_log_agi(tp, agbp, fields);
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
+		xfs_btree_commit_afakeroot(cur, tp, agbp);
 	}
 }
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 529091a6b246..45bfb39e003e 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -418,7 +418,7 @@ xfs_refcountbt_commit_staged_btree(
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
 				    XFS_AGF_REFCOUNT_ROOT |
 				    XFS_AGF_REFCOUNT_LEVEL);
-	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
+	xfs_btree_commit_afakeroot(cur, tp, agbp);
 }
 
 /* Calculate number of records in a refcount btree block. */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 311261df38a2..52c820108c55 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -565,7 +565,7 @@ xfs_rmapbt_commit_staged_btree(
 	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
 				    XFS_AGF_RMAP_BLOCKS);
-	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_rmapbt_ops);
+	xfs_btree_commit_afakeroot(cur, tp, agbp);
 }
 
 /* Calculate number of records in a reverse mapping btree block. */

