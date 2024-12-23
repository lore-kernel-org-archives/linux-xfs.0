Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1AA61FFE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994475; cv=none; b=IJ52d2ei08Zh6I0bmWaxVxGhWSYhlwbL51WXnYC/vRhJZoMOKzS8abvYQywnSX8i2873NovSEeqr49C9XmR/WYBpHTQG4sh3p+2R91pyKmxvRUYL5NJeNNCk2A4cK4eX04euGt3vE13d6heQWhve/rVUUMKDdkzQKD7uCFCTdHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994475; c=relaxed/simple;
	bh=7vv/cxmogTtrSII49b6BX2a3DxKpCyesOxdqRKe7M+E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pyp+CKQq6hYaqIMW2u5fdQ42hk3LruUo2etXyGbMtRoJ9zV+XuTJ32jFwJ0oso6vwPZfv7avvIt8OqY4kSdTi566W2yYokZyix9GN8i6MmerqjsG3AtJ0pWuu5ZRFpKqqncKgBnaU9IqF52HVRpYT9RV3qfCYFQ9dfOIwxQTM2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKcSwiSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKcSwiSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB461C4CED3;
	Mon, 23 Dec 2024 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994474;
	bh=7vv/cxmogTtrSII49b6BX2a3DxKpCyesOxdqRKe7M+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iKcSwiSr9Y+TdZY1eek02k4m7Bvv8aiQNotuavrgYm2U/Ay3lcJ4cftqcIiXpG+cx
	 QvFAOXIsfNKBQ0Aa/hxuMhAMEDfhacPNZQEJ0B3Ro/mO+gPPJ3bkvjeg7x5VjlmGfn
	 m04Syv4L3Ej3VxXR/3afkFUM0Gv+PaFdLsFeL6Kbeku0YLuXFsnPa+SXv9llQAPq8w
	 UU0QdTvIRrBIcrHkEkt05gLEvKUfYPZ+Y3hLW6XSODyoCsLNla8P0qScIbwZk3mvPE
	 4gky7+02j8ukZxqFGDmZTsfpw4akAg2hundJh8d3NXHLPB+K+deMpz2nrSbg0JAYjV
	 AM2XXJnArMpEA==
Date: Mon, 23 Dec 2024 14:54:34 -0800
Subject: [PATCH 2/8] xfs: refactor the inode fork memory allocation functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417633.2379682.774028767675384502.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
References: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist the code that allocates, frees, and reallocates if_broot into a
single xfs_iroot_krealloc function.  Eventually we're going to push
xfs_iroot_realloc into the btree ops structure to handle multiple
inode-rooted btrees, but first let's separate out the bits that should
stay in xfs_inode_fork.c.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c |  116 +++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h |    5 ++
 2 files changed, 82 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7f865479c4159f..294c3c5556836e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -178,7 +178,7 @@ xfs_iformat_btree(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_bmdr_block_t	*dfp;
 	struct xfs_ifork	*ifp;
-	/* REFERENCED */
+	struct xfs_btree_block	*broot;
 	int			nrecs;
 	int			size;
 	int			level;
@@ -211,16 +211,13 @@ xfs_iformat_btree(
 		return -EFSCORRUPTED;
 	}
 
-	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmalloc(size,
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-	ASSERT(ifp->if_broot != NULL);
+	broot = xfs_broot_alloc(ifp, size);
 	/*
 	 * Copy and convert from the on-disk structure
 	 * to the in-memory structure.
 	 */
 	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
-			 ifp->if_broot, size);
+			 broot, size);
 
 	ifp->if_bytes = 0;
 	ifp->if_data = NULL;
@@ -362,6 +359,69 @@ xfs_iformat_attr_fork(
 	return error;
 }
 
+/*
+ * Allocate the if_broot component of an inode fork so that it is @new_size
+ * bytes in size, using __GFP_NOLOCKDEP like all the other code that
+ * initializes a broot during inode load.  Returns if_broot.
+ */
+struct xfs_btree_block *
+xfs_broot_alloc(
+	struct xfs_ifork	*ifp,
+	size_t			new_size)
+{
+	ASSERT(ifp->if_broot == NULL);
+
+	ifp->if_broot = kmalloc(new_size,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+	ifp->if_broot_bytes = new_size;
+	return ifp->if_broot;
+}
+
+/*
+ * Reallocate the if_broot component of an inode fork so that it is @new_size
+ * bytes in size.  Returns if_broot.
+ */
+struct xfs_btree_block *
+xfs_broot_realloc(
+	struct xfs_ifork	*ifp,
+	size_t			new_size)
+{
+	/* No size change?  No action needed. */
+	if (new_size == ifp->if_broot_bytes)
+		return ifp->if_broot;
+
+	/* New size is zero, free it. */
+	if (new_size == 0) {
+		ifp->if_broot_bytes = 0;
+		kfree(ifp->if_broot);
+		ifp->if_broot = NULL;
+		return NULL;
+	}
+
+	/*
+	 * Shrinking the iroot means we allocate a new smaller object and copy
+	 * it.  We don't trust krealloc not to nop on realloc-down.
+	 */
+	if (ifp->if_broot_bytes > 0 && ifp->if_broot_bytes > new_size) {
+		struct xfs_btree_block	*old_broot = ifp->if_broot;
+
+		ifp->if_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
+		ifp->if_broot_bytes = new_size;
+		memcpy(ifp->if_broot, old_broot, new_size);
+		kfree(old_broot);
+		return ifp->if_broot;
+	}
+
+	/*
+	 * Growing the iroot means we can krealloc.  This may get us the same
+	 * object.
+	 */
+	ifp->if_broot = krealloc(ifp->if_broot, new_size,
+			GFP_KERNEL | __GFP_NOFAIL);
+	ifp->if_broot_bytes = new_size;
+	return ifp->if_broot;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -388,7 +448,6 @@ xfs_iroot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	struct xfs_btree_block	*new_broot;
 	char			*np;
 	char			*op;
 	size_t			new_size;
@@ -409,9 +468,7 @@ xfs_iroot_realloc(
 		 */
 		if (old_size == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmalloc(new_size,
-						GFP_KERNEL | __GFP_NOFAIL);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_broot_realloc(ifp, new_size);
 			return;
 		}
 
@@ -424,13 +481,12 @@ xfs_iroot_realloc(
 		cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-		ifp->if_broot = krealloc(ifp->if_broot, new_size,
-					 GFP_KERNEL | __GFP_NOFAIL);
+
+		xfs_broot_realloc(ifp, new_size);
 		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     old_size);
 		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     (int)new_size);
-		ifp->if_broot_bytes = (int)new_size;
 		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			xfs_inode_fork_size(ip, whichfork));
 		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
@@ -451,39 +507,21 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size == 0) {
-		ifp->if_broot = NULL;
-		ifp->if_broot_bytes = 0;
+		xfs_broot_realloc(ifp, 0);
 		return;
 	}
 
 	/*
-	 * Shrink the btree root by allocating a smaller object and copying the
-	 * fields from the old object to the new object.  krealloc does nothing
-	 * if we realloc downwards.
-	 */
-	new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
-	/*
-	 * First copy over the btree block header.
-	 */
-	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
-
-	/*
-	 * First copy the keys.
-	 */
-	op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-	np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-	memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
-
-	/*
-	 * Then copy the pointers.
+	 * Shrink the btree root by moving the bmbt pointers, since they are
+	 * not butted up against the btree block header, then reallocating
+	 * broot.
 	 */
 	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
-	np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1, (int)new_size);
-	memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
+	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
+					     (int)new_size);
+	memmove(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
 
-	kfree(ifp->if_broot);
-	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
+	xfs_broot_realloc(ifp, new_size);
 	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 	       xfs_inode_fork_size(ip, whichfork));
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2373d12fd474f0..e3c5c9121044fd 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -170,6 +170,11 @@ void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
 void *		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
+struct xfs_btree_block *xfs_broot_alloc(struct xfs_ifork *ifp,
+				size_t new_size);
+struct xfs_btree_block *xfs_broot_realloc(struct xfs_ifork *ifp,
+				size_t new_size);
+
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,

