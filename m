Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E44BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJNYHyUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD5C433C7;
	Sun, 31 Dec 2023 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057806;
	bh=v7g08S6VLXgGT4i8z+GtTaRqmhOooJONnwGQ0Y6P4eg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HJNYHyUer/b9boEyWOfhd2GyQ1P9Z2/qHjhWisV+BeM22FEu/81WOE1P2ZfvthAuI
	 a9W5kRgC+bphSu1vjKVGpCHhbue/pHGovk+GPybUzkNvXkdfKissw+nEFosDUzqdgh
	 DMJ3yNcpfsW+zBYyy0i/6fOjaPnZoHIAvUJU/ruDM5YjW/RlDyHqOnoEmoppePZ4Gw
	 Zm0dhZQUrxlZWtbvlbzqxWjeLXTJNyCKg/b4NBAx2Um1yIYpVh+Xm3u9srKG23gvvb
	 iS0ST7oT37LXTMBCAwh+EgLXtwCNNDZz/3Gt04N+3t/cSd6NqrUNz18eZ2TKR3Z6T3
	 8nbHj5OZyFfVw==
Date: Sun, 31 Dec 2023 13:23:26 -0800
Subject: [PATCH 05/14] xfs: hoist the code that moves the incore inode fork
 broot memory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847448.1763835.12234936492203401502.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_inode_fork.c |   99 +++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 08f3d003d5383..c84def822dd18 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -383,6 +383,50 @@ xfs_iroot_free(
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
@@ -409,12 +453,11 @@ xfs_iroot_realloc(
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
@@ -423,13 +466,12 @@ xfs_iroot_realloc(
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
@@ -438,22 +480,16 @@ xfs_iroot_realloc(
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
 
@@ -462,8 +498,8 @@ xfs_iroot_realloc(
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
@@ -475,35 +511,14 @@ xfs_iroot_realloc(
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
 

