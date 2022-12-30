Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60408C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiLaBSo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiLaBSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:18:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A391D0C6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8613B61B80
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3346C433D2;
        Sat, 31 Dec 2022 01:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449519;
        bh=lP6Rzrgc7xLOU+BIDdxb6r3kZgJTE+ce101ljAAZkhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bPJTm7o6c9Z/mg1fQM1PiV7sZR162tU+9AIeEBIPcqhQAl5B1Ox2FxuRdzuzjSHqP
         2693YfeL8S/+6nqcOpmw2bhMwjd+jCsvP0gpWJnXfdN1UrjXkToqmRmnuW8DQQUNP3
         g70mY25CE7WEyvXEnxj9Ks8ss5wJQsw+yY1KQMKuBHdeCe5R3RDjkNYEHhg0ThKyQn
         GzgKQbnVRBB6gok1jvPVSKiOfdbeRCQdtqV3R0YbxUR/K5Z6Q25Z+2eFdF13bKwJ5P
         hmAoxTvpBbwke+DARCY5WeWv4KbYEWn/OWNkRzg2zKzKkPoR4WfLp6kJjeJV8xIRYN
         brv/p9KAXGskA==
Subject: [PATCH 09/14] xfs: generalize the btree root reallocation function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865235.708933.17221317441038700322.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for storing realtime rmap btree roots in an inode fork,
make xfs_iroot_realloc take an ops structure that takes care of all the
btree-specific geometry pieces.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   51 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.c      |   22 +++++++----
 fs/xfs/libxfs/xfs_btree.h      |    3 +
 fs/xfs/libxfs/xfs_inode_fork.c |   82 ++++++++--------------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |   23 +++++++++++
 5 files changed, 107 insertions(+), 74 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1d226b284db3..f9d4ca6ced1f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -527,6 +527,56 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
+/* Move the bmap btree root from one incore buffer to another. */
+static void
+xfs_bmbt_broot_move(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_btree_block	*dst_broot,
+	size_t			dst_bytes,
+	struct xfs_btree_block	*src_broot,
+	size_t			src_bytes,
+	unsigned int		numrecs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	void			*dptr;
+	void			*sptr;
+
+	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+
+	/*
+	 * We always have to move the pointers because they are not butted
+	 * against the btree block header.
+	 */
+	if (numrecs) {
+		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
+		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
+		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
+	}
+
+	if (src_broot == dst_broot)
+		return;
+
+	/*
+	 * If the root is being totally relocated, we have to migrate the block
+	 * header and the keys that come after it.
+	 */
+	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
+
+	/* Now copy the keys, which come right after the header. */
+	if (numrecs) {
+		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
+		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
+		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
+	}
+}
+
+static const struct xfs_ifork_broot_ops xfs_bmbt_iroot_ops = {
+	.maxrecs		= xfs_bmbt_maxrecs,
+	.size			= xfs_bmap_broot_space_calc,
+	.move			= xfs_bmbt_broot_move,
+};
+
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
@@ -549,6 +599,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 	.keys_contiguous	= xfs_bmbt_keys_contiguous,
+	.iroot_ops		= &xfs_bmbt_iroot_ops,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5176947870f9..c2e6b4ea28bf 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3080,6 +3080,16 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
+static inline void
+xfs_btree_iroot_realloc(
+	struct xfs_btree_cur		*cur,
+	int				rec_diff)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			cur->bc_ops->iroot_ops, rec_diff);
+}
 
 /*
  * Copy the old inode root contents into a real block and make the
@@ -3164,9 +3174,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_ino.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_ino.whichfork);
+	xfs_btree_iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3336,7 +3344,7 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
+			xfs_btree_iroot_realloc(cur, 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3744,8 +3752,7 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_ino.ip, index,
-				  cur->bc_ino.whichfork);
+		xfs_btree_iroot_realloc(cur, index);
 		block = ifp->if_broot;
 	}
 
@@ -3942,8 +3949,7 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_ino.ip, -1,
-					  cur->bc_ino.whichfork);
+			xfs_btree_iroot_realloc(cur, -1);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0e12360ae36d..3acfdcdf7561 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -202,6 +202,9 @@ struct xfs_btree_ops {
 			       const union xfs_btree_key *key1,
 			       const union xfs_btree_key *key2,
 			       const union xfs_btree_key *mask);
+
+	/* Functions for manipulating the btree root block. */
+	const struct xfs_ifork_broot_ops *iroot_ops;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a9610452ca3a..0ac1c8dba2ed 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -369,50 +369,6 @@ xfs_iroot_free(
 	ifp->if_broot = NULL;
 }
 
-/* Move the bmap btree root from one incore buffer to another. */
-static void
-xfs_ifork_move_broot(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	struct xfs_btree_block	*dst_broot,
-	size_t			dst_bytes,
-	struct xfs_btree_block	*src_broot,
-	size_t			src_bytes,
-	unsigned int		numrecs)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	void			*dptr;
-	void			*sptr;
-
-	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
-
-	/*
-	 * We always have to move the pointers because they are not butted
-	 * against the btree block header.
-	 */
-	if (numrecs) {
-		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
-		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
-		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
-	}
-
-	if (src_broot == dst_broot)
-		return;
-
-	/*
-	 * If the root is being totally relocated, we have to migrate the block
-	 * header and the keys that come after it.
-	 */
-	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
-
-	/* Now copy the keys, which come right after the header. */
-	if (numrecs) {
-		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
-		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
-		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
-	}
-}
-
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -426,24 +382,21 @@ xfs_ifork_move_broot(
  * if we are adding records, one will be allocated.  The caller must also
  * not request that the number of records go below zero, although
  * it can go to zero.
- *
- * ip -- the inode whose if_broot area is changing
- * ext_diff -- the change in the number of records, positive or negative,
- *	 requested for the if_broot array.
  */
 void
 xfs_iroot_realloc(
-	struct xfs_inode	*ip,
-	int			rec_diff,
-	int			whichfork)
+	struct xfs_inode		*ip,
+	int				whichfork,
+	const struct xfs_ifork_broot_ops *ops,
+	int				rec_diff)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	struct xfs_btree_block	*new_broot;
-	size_t			new_size;
-	size_t			old_size = ifp->if_broot_bytes;
-	int			cur_max;
-	int			new_max;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, whichfork);
+	struct xfs_btree_block		*new_broot;
+	size_t				new_size;
+	size_t				old_size = ifp->if_broot_bytes;
+	int				cur_max;
+	int				new_max;
 
 	/* Handle degenerate cases. */
 	if (rec_diff == 0)
@@ -456,16 +409,16 @@ xfs_iroot_realloc(
 	if (old_size == 0) {
 		ASSERT(rec_diff > 0);
 
-		new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
+		new_size = ops->size(mp, rec_diff);
 		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
+	cur_max = ops->maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+	new_size = ops->size(mp, new_max);
 
 	if (rec_diff > 0) {
 		/*
@@ -476,7 +429,7 @@ xfs_iroot_realloc(
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
-		xfs_ifork_move_broot(ip, whichfork, ifp->if_broot, new_size,
+		ops->move(ip, whichfork, ifp->if_broot, new_size,
 				ifp->if_broot, old_size, cur_max);
 		return;
 	}
@@ -493,15 +446,14 @@ xfs_iroot_realloc(
 
 	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
-	xfs_ifork_move_broot(ip, whichfork, new_broot, new_size, ifp->if_broot,
-			old_size, new_max);
+	ops->move(ip, whichfork, new_broot, new_size, ifp->if_broot,
+			ifp->if_broot_bytes, new_max);
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = new_size;
 }
 
-
 /*
  * This is called when the amount of space needed for if_data
  * is increased or decreased.  The change in size is indicated by
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index f4379e2df616..7d95c402f870 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -174,7 +174,6 @@ void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 void		xfs_iroot_alloc(struct xfs_inode *ip, int whichfork,
 				size_t bytes);
 void		xfs_iroot_free(struct xfs_inode *ip, int whichfork);
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
@@ -272,4 +271,26 @@ static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
 	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
 }
 
+struct xfs_ifork_broot_ops {
+	/* Calculate the number of records/keys in the incore btree block. */
+	unsigned int (*maxrecs)(struct xfs_mount *mp, unsigned int blocksize,
+			bool leaf);
+
+	/* Calculate the bytes required for the incore btree root block. */
+	size_t (*size)(struct xfs_mount *mp, unsigned int nrecs);
+
+	/*
+	 * Move an incore btree root from one buffer to another.  Note that
+	 * src_broot and dst_broot could be the same or they could be totally
+	 * separate memory regions.
+	 */
+	void (*move)(struct xfs_inode *ip, int whichfork,
+			struct xfs_btree_block *dst_broot, size_t dst_bytes,
+			struct xfs_btree_block *src_broot, size_t src_bytes,
+			unsigned int numrecs);
+};
+
+void xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
+		const struct xfs_ifork_broot_ops *ops, int rec_diff);
+
 #endif	/* __XFS_INODE_FORK_H__ */

