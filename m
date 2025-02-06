Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A452423C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881338; cv=none; b=st5JMi4lOshrayoDS56VHtn4MJJ0n8t10hbs3S7XdUTI5urAWi3NNiaXMJaKmCLoBMafJPVYwYzRSyjjOdUjPwqb6fzcTgbSu/vAa9z0CnXicRV+AUukl1wZNEChfJzCRA3orpZHoEDbhMbXDTQy0kQrGGkVmlPoRSL+vhzh+fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881338; c=relaxed/simple;
	bh=B/FC9v2AIkgfDUq4F4CKUDwDj3LOSWcdAKJRg4/1Xzc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGHRvQnN9Bd/PJ9z8E/b4P7qZ5l6OgQh5PxibvmCdjCufhgYCy05jM1ePxbbxj8hmT6Wy0FlHYR5jln4PIPbJiauWQH80fBAwgL5b6c3+j1x32OjgnEi/5x2GbZQAfNO/e/N7nL5YUKeffOCsdQ7gjwrxmuH+cWHYeNMt40YwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vet8DGXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vet8DGXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789B4C4CEDD;
	Thu,  6 Feb 2025 22:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881338;
	bh=B/FC9v2AIkgfDUq4F4CKUDwDj3LOSWcdAKJRg4/1Xzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vet8DGXZXmkh5sPg1B9/VSewXxlmZzPnJhGSQ0+igfdd9EVr+ZoroojI0zLlcVkdv
	 oCyBW8DWY5WawpMsaaKLyBamSEuylQbL/FOWTeESTSu2jpkmooX8MAl4Lj/uDWlOwX
	 AOcHibKHXLq8sLawGOwjDzGQmkigJCBAGNMWHNtOa1tMD54RmZpqSHojhgq1ecSw2X
	 jFDOBoUdX5Misa5CoFNPMjocVUHuFDs31BbuSpdfzj9n5CYOprso9ytbh6tkBvXSgY
	 20Y26YBtuPQYgyzyKPAC1xer4V8NKfVQk4f2sJmGUrXMRZJOcy258Wwq2u7QAnDyga
	 5/M1I8Uqy7oPg==
Date: Thu, 06 Feb 2025 14:35:38 -0800
Subject: [PATCH 02/56] xfs: refactor the inode fork memory allocation
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086820.2739176.18084316097701707775.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6c1c55ac3c0512262817a088e805d99aad4c0867

Hoist the code that allocates, frees, and reallocates if_broot into a
single xfs_iroot_krealloc function.  Eventually we're going to push
xfs_iroot_realloc into the btree ops structure to handle multiple
inode-rooted btrees, but first let's separate out the bits that should
stay in xfs_inode_fork.c.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_fork.c |  116 +++++++++++++++++++++++++++++++----------------
 libxfs/xfs_inode_fork.h |    5 ++
 2 files changed, 82 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 8d7d943311e9a0..8c779c46d8217b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -176,7 +176,7 @@ xfs_iformat_btree(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_bmdr_block_t	*dfp;
 	struct xfs_ifork	*ifp;
-	/* REFERENCED */
+	struct xfs_btree_block	*broot;
 	int			nrecs;
 	int			size;
 	int			level;
@@ -209,16 +209,13 @@ xfs_iformat_btree(
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
@@ -360,6 +357,69 @@ xfs_iformat_attr_fork(
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
@@ -386,7 +446,6 @@ xfs_iroot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	struct xfs_btree_block	*new_broot;
 	char			*np;
 	char			*op;
 	size_t			new_size;
@@ -407,9 +466,7 @@ xfs_iroot_realloc(
 		 */
 		if (old_size == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			ifp->if_broot = kmalloc(new_size,
-						GFP_KERNEL | __GFP_NOFAIL);
-			ifp->if_broot_bytes = (int)new_size;
+			xfs_broot_realloc(ifp, new_size);
 			return;
 		}
 
@@ -422,13 +479,12 @@ xfs_iroot_realloc(
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
@@ -449,39 +505,21 @@ xfs_iroot_realloc(
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
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 2373d12fd474f0..e3c5c9121044fd 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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

