Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B21442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801750; cv=none; b=q/o0mXntd/mNy2ri36jvybRQtXkvDxZ52EqCVCUCcKc9BlKpmKuQpSeN0+xlCCr1HS1eR6s6jBpweSGYXxDoST9b5yxFrrWwMzAJdmGjzqmrbAThfMzaQ1E3PP5J9Ll6opMeWQXMfqjGlZ0AhH60yG9xpG+PSagpWIFtHnpC6hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801750; c=relaxed/simple;
	bh=2t85aX2wCxgNO8XfGcWrh+utx8crvoewHU9oD0h/1bI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5RLJBkm/kgVg78+kcAbImD1BRyyhiOa/RFIrBfkZS6l6wpderaQEObDF/u8d3x/C4LM3hXOXNkGhkYfLKx1FOBDZmnzZ2nApcJf0hnaQ1llrxyh2fwS3IVJN/5dttqTpYGEDdV4C3VjuZQsdwG6HMH2ajlzYpstT+E4loVIDms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTmjBCn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTmjBCn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B907C56776;
	Tue, 27 Aug 2024 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801749;
	bh=2t85aX2wCxgNO8XfGcWrh+utx8crvoewHU9oD0h/1bI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tTmjBCn9D9L2B/OC2rjYKKjBfg/DUejr1bOEWVc0er++KUK3MoMKx4Z4rH3efJCOL
	 mL3TB4IJ00HPuR7etaCxS0/cIeE6eqwtXh+fOSmq5ajz6LezmdBerVE03FvMHYL7kH
	 Mr6y+Nru6Lz2jvQYLHXeIXfzeR7nLyOmp0JcQT3sk6XseceCkp/4APh8gMUJa66uDb
	 JM9cPIX+Vjz1z/okv1NRBVNLRu7GlFz/UBx1EX1YSusriwSWdTl4EydghITSUDDBnD
	 P+t/S9Ufk242n91F1sfL1Mok+ocve8pJGYjJIgJqjWFjUV9FyXbAro0AQ0+X8vOdw7
	 XuCd5MuX1Fu+Q==
Date: Tue, 27 Aug 2024 16:35:48 -0700
Subject: [PATCH 08/10] xfs: hoist the code that moves the incore inode fork
 broot memory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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

Whenever we change the size of the memory buffer holding an inode fork
btree root block, we have to copy the contents over.  Refactor all this
into a single function that handles both, in preparation for making
xfs_iroot_realloc more generic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   87 ++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 60646a6c32ec7..307207473abdb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -387,6 +387,50 @@ xfs_iroot_free(
 	ifp->if_broot = NULL;
 }
 
+/* Move the bmap btree root from one incore buffer to another. */
+static void
+xfs_ifork_move_broot(
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
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -413,12 +457,11 @@ xfs_iroot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			cur_max;
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
 	int			new_max;
 	size_t			new_size;
-	char			*np;
-	char			*op;
+	size_t			old_size = ifp->if_broot_bytes;
 
 	/*
 	 * Handle the degenerate case quietly.
@@ -427,13 +470,12 @@ xfs_iroot_realloc(
 		return;
 	}
 
-	ifp = xfs_ifork_ptr(ip, whichfork);
 	if (rec_diff > 0) {
 		/*
 		 * If there wasn't any memory allocated before, just
 		 * allocate it now and get out.
 		 */
-		if (ifp->if_broot_bytes == 0) {
+		if (old_size == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
 			xfs_iroot_alloc(ip, whichfork, new_size);
 			return;
@@ -442,22 +484,16 @@ xfs_iroot_realloc(
 		/*
 		 * If there is already an existing if_broot, then we need
 		 * to realloc() it and shift the pointers to their new
-		 * location.  The records don't change location because
-		 * they are kept butted up against the btree block header.
+		 * location.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_KERNEL | __GFP_NOFAIL);
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
+		ifp->if_broot_bytes = new_size;
+		xfs_ifork_move_broot(ip, whichfork, ifp->if_broot, new_size,
+				ifp->if_broot, old_size, cur_max);
 		return;
 	}
 
@@ -466,8 +502,8 @@ xfs_iroot_realloc(
 	 * if_broot buffer.  It must already exist.  If we go to zero
 	 * records, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 
@@ -478,22 +514,11 @@ xfs_iroot_realloc(
 	}
 
 	new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
-
-	op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-	np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-	memcpy(np, op, new_max * sizeof(xfs_bmbt_key_t));
-
-	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-			ifp->if_broot_bytes);
-	np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1, (int)new_size);
-	memcpy(np, op, new_max * sizeof(xfs_fsblock_t));
-
+	xfs_ifork_move_broot(ip, whichfork, new_broot, new_size, ifp->if_broot,
+			old_size, new_max);
 	kfree(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-	       xfs_inode_fork_size(ip, whichfork));
 }
 
 

