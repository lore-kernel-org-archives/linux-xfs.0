Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA58527E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816787; cv=none; b=XrLQ+I8JfU069gEJCtaxTmfzwqsCOZ29/UdOXtmddCPblk8YqnbpCBY1iLUm5t32KAkNyMedXp5HKk/uX/yYxL3lmLFhMrp3+9oK7DhePToWHHTwUTEwlH/mSnDUTUugHTiWxIs8eA/n9APgEzPvjj2V3d0AL3pWFYlAfMycnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816787; c=relaxed/simple;
	bh=Vi/ck2R9xHjh7fnm+cB0/0ccSLoQNDknhlN2V87ntAw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxn9gC7OkZjZRfWnGmLrLlxOAraQNiJcAZwSeazZX8ciwg7J2L6+p4nOwntdNYFTed1yU7KUQ4WuhfUfFz6esbOmuNr0s83LSEwj+ZZ+OChYFtn/vw7YX0Suy7kABLV4K2glSKvuRj+9A7hTuG8mUsISZr7hJq5pP1SCyZkfQmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1LaNokA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1LaNokA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72920C433C7;
	Thu,  1 Feb 2024 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816787;
	bh=Vi/ck2R9xHjh7fnm+cB0/0ccSLoQNDknhlN2V87ntAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g1LaNokAq5p885kdvv6rcclFStNXZiMuwmBJLBaOmcsiCoftTND7eorsJZf7k0Huk
	 cGh6B1igJOlb0od2xE1GS/qy5eVfKSFUn/2ZJQwKzA4JbhwNQiapYLpL68mdzlQH79
	 uPKazLbdxvTvfBbwebbKqjPraY2S0UaVuh29hs7q1mTYeGueEVdGlTFai6LD5ugA2w
	 d4AqlCfQsZmIFDaB3aqlWG3nYVDkUpNUe0aTObsiZ8NrrOquFNnWzjjSC2P9Q0ENfK
	 5JcwVUkGko2vNmLc/rl8++zEAVVdOiMZKUQL5sufhR5TUoCS/Xz8FNkY4YNrhCUvwf
	 52vpqzPLMUoYw==
Date: Thu, 01 Feb 2024 11:46:26 -0800
Subject: [PATCH 03/27] xfs: don't override bc_ops for staging btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334835.1605438.9383072633206734947.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Add a few conditionals for staging btrees to the core btree code instead
of overloading the bc_ops vector.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 --
 fs/xfs/libxfs/xfs_bmap_btree.c     |    6 +-
 fs/xfs/libxfs/xfs_btree.c          |   75 +++++++++++++++++++------
 fs/xfs/libxfs/xfs_btree_staging.c  |  109 +-----------------------------------
 fs/xfs/libxfs/xfs_btree_staging.h  |    7 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 -
 8 files changed, 72 insertions(+), 139 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 7d9798535dba9..75c66dca61eb1 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -594,11 +594,7 @@ xfs_allocbt_commit_staged_btree(
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 726cb506bbbfa..ec0b970157ae1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -609,7 +609,6 @@ xfs_bmbt_stage_cursor(
 	struct xbtree_ifakeroot	*ifake)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_btree_ops	*ops;
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
@@ -618,8 +617,7 @@ xfs_bmbt_stage_cursor(
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
-	xfs_btree_stage_ifakeroot(cur, ifake, &ops);
-	ops->update_cursor = NULL;
+	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }
 
@@ -663,7 +661,7 @@ xfs_bmbt_commit_staged_btree(
 		break;
 	}
 	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
-	xfs_btree_commit_ifakeroot(cur, tp, whichfork, &xfs_bmbt_ops);
+	xfs_btree_commit_ifakeroot(cur, tp, whichfork);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a5313e5e09eae..2649f24ed7482 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -407,6 +407,15 @@ xfs_btree_free_block(
 
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
@@ -458,8 +467,6 @@ xfs_btree_del_cursor(
 		break;
 	}
 
-	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kmem_free(cur->bc_ops);
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
@@ -467,20 +474,26 @@ xfs_btree_del_cursor(
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
@@ -1895,6 +1908,8 @@ xfs_btree_init_ptr_from_cur(
 		 * in xfs_btree_lookup_get_block and don't need a pointer here.
 		 */
 		ptr->l = 0;
+	} else if (cur->bc_flags & XFS_BTREE_STAGING) {
+		ptr->s = cpu_to_be32(cur->bc_ag.afake->af_root);
 	} else {
 		cur->bc_ops->init_ptr_from_cur(cur, ptr);
 	}
@@ -2716,6 +2731,18 @@ xfs_btree_alloc_block(
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
@@ -3116,6 +3143,21 @@ xfs_btree_new_iroot(
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
@@ -3156,7 +3198,7 @@ xfs_btree_new_root(
 		goto error0;
 
 	/* Set the root in the holding structure  increasing the level by 1. */
-	cur->bc_ops->set_root(cur, &lptr, 1);
+	xfs_btree_set_root(cur, &lptr, 1);
 
 	/*
 	 * At the previous root level there are now two blocks: the old root,
@@ -3584,7 +3626,8 @@ xfs_btree_insert(
 		if (pcur != cur &&
 		    (ncur || xfs_btree_ptr_is_null(cur, &nptr))) {
 			/* Save the state from the cursor before we trash it */
-			if (cur->bc_ops->update_cursor)
+			if (cur->bc_ops->update_cursor &&
+			    !(cur->bc_flags & XFS_BTREE_STAGING))
 				cur->bc_ops->update_cursor(pcur, cur);
 			cur->bc_nlevels = pcur->bc_nlevels;
 			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
@@ -3727,7 +3770,7 @@ xfs_btree_kill_root(
 	 * Update the root pointer, decreasing the level by 1 and then
 	 * free the old root.
 	 */
-	cur->bc_ops->set_root(cur, newroot, -1);
+	xfs_btree_set_root(cur, newroot, -1);
 
 	error = xfs_btree_free_block(cur, bp);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index f0600314335ed..6337a5b928bd5 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
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
 
-	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
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
 
-	kmem_free((void *)cur->bc_ops);
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
 
-	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
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
 
-	kmem_free((void *)cur->bc_ops);
 	cur->bc_ino.ifake = NULL;
 	cur->bc_ino.whichfork = whichfork;
-	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
 	cur->bc_tp = tp;
 }
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index 8e29cd3cc0f17..0c9c2ffb127a9 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fc584424ebdfe..0d04ac32367df 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -537,7 +537,7 @@ xfs_inobt_commit_staged_btree(
 			fields |= XFS_AGI_IBLOCKS;
 		}
 		xfs_ialloc_log_agi(tp, agbp, fields);
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_inobt_ops);
+		xfs_btree_commit_afakeroot(cur, tp, agbp);
 	} else {
 		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
@@ -547,7 +547,7 @@ xfs_inobt_commit_staged_btree(
 			fields |= XFS_AGI_IBLOCKS;
 		}
 		xfs_ialloc_log_agi(tp, agbp, fields);
-		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_finobt_ops);
+		xfs_btree_commit_afakeroot(cur, tp, agbp);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 2eb94f18ff33b..966e87db2403b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -419,7 +419,7 @@ xfs_refcountbt_commit_staged_btree(
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
 				    XFS_AGF_REFCOUNT_ROOT |
 				    XFS_AGF_REFCOUNT_LEVEL);
-	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
+	xfs_btree_commit_afakeroot(cur, tp, agbp);
 }
 
 /* Calculate number of records in a refcount btree block. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 4fdbd6368a034..84eb767425cba 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -567,7 +567,7 @@ xfs_rmapbt_commit_staged_btree(
 	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
 				    XFS_AGF_RMAP_BLOCKS);
-	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_rmapbt_ops);
+	xfs_btree_commit_afakeroot(cur, tp, agbp);
 }
 
 /* Calculate number of records in a reverse mapping btree block. */

