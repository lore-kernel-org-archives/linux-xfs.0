Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366BFCA48
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8XP+I0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039C3C433C7;
	Mon,  1 Jan 2024 00:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067346;
	bh=jjdubfWxNoNPhdML9VGj24sWxP7XYRSQekGyW2H1O+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L8XP+I0szS+QSQ4SJ3l6WihowGGhuqBVqYzUzTJbfPNDhBgxSSVYKavwmWyWqwa44
	 qNKxwit3TKQalCmbZH0qslQ1cFv2yMkTzHX5k31HLXAgD7mxspwG/Ut8BqD9LgvlXj
	 NHIQDlQD5WZ5f21aZED/xrPvWj4LWt9vd7eQlbKJZZOxNEGTZzAoGjeIEEO/aFnK2Y
	 obioaQTLueL85G7lbbmVlyfM32m+IZV7GBAOAV2cj9twUNE7I36pQvJBSM58w7r55J
	 eVkwE5sXqwUg22o/ZD54J8lqEqndBOtM3gfZfbBhmBGubJFY7B4LsJV3d4bGI15UI6
	 xYQezNFvDYnUw==
Date: Sun, 31 Dec 2023 16:02:25 +9900
Subject: [PATCH 05/14] xfs: hoist the code that moves the incore inode fork
 broot memory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013268.1812545.663317108791544457.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_inode_fork.c |   99 +++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 42 deletions(-)


diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 765e174999d..edf6dff28b4 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -381,6 +381,50 @@ xfs_iroot_free(
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
@@ -407,12 +451,11 @@ xfs_iroot_realloc(
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
@@ -421,13 +464,12 @@ xfs_iroot_realloc(
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
@@ -436,22 +478,16 @@ xfs_iroot_realloc(
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
 					 GFP_NOFS | __GFP_NOFAIL);
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
 
@@ -460,8 +496,8 @@ xfs_iroot_realloc(
 	 * if_broot buffer.  It must already exist.  If we go to zero
 	 * records, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
@@ -473,35 +509,14 @@ xfs_iroot_realloc(
 		return;
 	}
 
-	/* First copy over the btree block header. */
+	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
-	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+	xfs_ifork_move_broot(ip, whichfork, new_broot, new_size, ifp->if_broot,
+			old_size, new_max);
 
-	/*
-	 * Only copy the keys and pointers if there are any.
-	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the keys.
-		 */
-		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
-
-		/*
-		 * Then copy the pointers.
-		 */
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1,
-						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
-	}
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-		xfs_inode_fork_size(ip, whichfork));
 	return;
 }
 

