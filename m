Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5ECA48
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbWihAKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F03C433C7;
	Mon,  1 Jan 2024 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067424;
	bh=OYlNyLdbsjonbkLaT84wqBq8bFCJ7z4h7LxU2erqbuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IbWihAKLirbNjjm5uIRdZGBox+iHshDYJfl1tbrzAYnOBZzdHyXZQo1vrjNmXaZhK
	 ma2ELzEemQKrnYGXWRPsocs5xFvWKMGTY3WjGP5O7XBNcV0/4HGIZ19QvliF8Ty3Q1
	 ATfzyGZqcENChpJRKnRR4TpdyausC3ixLtHDWRAI3WIP6XxzvtfblGp7rffVBpmC6o
	 yJNVFSoO4xxLVLbSCZkaNkMj0Ic5w+kOVWrEeHsB2rNBb6guOaa9Yz/FDm5W5pqr3J
	 l/9+oIDLYfts4vuNiGnuRYKxxMq/wDY5mqBjav9FPFiBhFMsIUt4HZ4NwsWajmuP+V
	 yySptnQsmX0Dw==
Date: Sun, 31 Dec 2023 16:03:44 +9900
Subject: [PATCH 10/14] xfs: support leaves in the incore btree root block in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013335.1812545.4747668590297411066.stgit@frogsfrogsfrogs>
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

Add some logic to xfs_iroot_realloc so that we can handle leaf records
in the btree root block correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmap_inflate.c       |    2 +-
 libxfs/xfs_bmap_btree.c |    4 +++-
 libxfs/xfs_bmap_btree.h |    5 ++++-
 libxfs/xfs_inode_fork.c |   12 +++++++-----
 libxfs/xfs_inode_fork.h |    5 +++--
 repair/bmap_repair.c    |    2 +-
 6 files changed, 19 insertions(+), 11 deletions(-)


diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 118d911a1db..b08204201c2 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -282,7 +282,7 @@ iroot_size(
 	unsigned int		nr_this_level,
 	void			*priv)
 {
-	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
 }
 
 static int
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 4156e23a2da..8658e7c390a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -520,6 +520,7 @@ xfs_bmbt_broot_move(
 	size_t			dst_bytes,
 	struct xfs_btree_block	*src_broot,
 	size_t			src_bytes,
+	unsigned int		level,
 	unsigned int		numrecs)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -527,6 +528,7 @@ xfs_bmbt_broot_move(
 	void			*sptr;
 
 	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+	ASSERT(level > 0);
 
 	/*
 	 * We always have to move the pointers because they are not butted
@@ -839,7 +841,7 @@ xfs_bmbt_iroot_alloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	xfs_iroot_alloc(ip, whichfork,
-			xfs_bmap_broot_space_calc(ip->i_mount, 1));
+			xfs_bmap_broot_space_calc(ip->i_mount, 1, 1));
 
 	/* Fill in the root. */
 	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_bmbt_ops, 1, 1,
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index a9ddc9b42e6..d20321bfe2f 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -161,8 +161,11 @@ xfs_bmap_broot_ptr_addr(
 static inline size_t
 xfs_bmap_broot_space_calc(
 	struct xfs_mount	*mp,
+	unsigned int		level,
 	unsigned int		nrecs)
 {
+	ASSERT(level > 0);
+
 	/*
 	 * If the bmbt root block is empty, we should be converting the fork
 	 * to extents format.  Hence, the size is zero.
@@ -183,7 +186,7 @@ xfs_bmap_broot_space(
 	struct xfs_mount	*mp,
 	struct xfs_bmdr_block	*bb)
 {
-	return xfs_bmap_broot_space_calc(mp, be16_to_cpu(bb->bb_numrecs));
+	return xfs_bmap_broot_space_calc(mp, 1, be16_to_cpu(bb->bb_numrecs));
 }
 
 /* Compute the space required for the ondisk root block. */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 50422bbeb8f..ec3a399e798 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -407,6 +407,7 @@ xfs_iroot_realloc(
 	struct xfs_btree_block		*new_broot;
 	size_t				new_size;
 	size_t				old_size = ifp->if_broot_bytes;
+	unsigned int			level;
 	int				cur_max;
 	int				new_max;
 
@@ -421,16 +422,17 @@ xfs_iroot_realloc(
 	if (old_size == 0) {
 		ASSERT(rec_diff > 0);
 
-		new_size = ops->size(mp, rec_diff);
+		new_size = ops->size(mp, 0, rec_diff);
 		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = ops->maxrecs(mp, old_size, false);
+	level = be16_to_cpu(ifp->if_broot->bb_level);
+	cur_max = ops->maxrecs(mp, old_size, level == 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	new_size = ops->size(mp, new_max);
+	new_size = ops->size(mp, level, new_max);
 
 	if (rec_diff > 0) {
 		/*
@@ -442,7 +444,7 @@ xfs_iroot_realloc(
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
 		ops->move(ip, whichfork, ifp->if_broot, new_size,
-				ifp->if_broot, old_size, cur_max);
+				ifp->if_broot, old_size, level, cur_max);
 		return;
 	}
 
@@ -459,7 +461,7 @@ xfs_iroot_realloc(
 	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
 	ops->move(ip, whichfork, new_broot, new_size, ifp->if_broot,
-			ifp->if_broot_bytes, new_max);
+			ifp->if_broot_bytes, level, new_max);
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 1ac9a7a8b5f..9a0136f8273 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -279,7 +279,8 @@ struct xfs_ifork_broot_ops {
 			bool leaf);
 
 	/* Calculate the bytes required for the incore btree root block. */
-	size_t (*size)(struct xfs_mount *mp, unsigned int nrecs);
+	size_t (*size)(struct xfs_mount *mp, unsigned int level,
+			unsigned int nrecs);
 
 	/*
 	 * Move an incore btree root from one buffer to another.  Note that
@@ -289,7 +290,7 @@ struct xfs_ifork_broot_ops {
 	void (*move)(struct xfs_inode *ip, int whichfork,
 			struct xfs_btree_block *dst_broot, size_t dst_bytes,
 			struct xfs_btree_block *src_broot, size_t src_bytes,
-			unsigned int numrecs);
+			unsigned int level, unsigned int numrecs);
 };
 
 void xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index a8cbff67ceb..dfd1405cca2 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -285,7 +285,7 @@ xrep_bmap_iroot_size(
 {
 	ASSERT(level > 0);
 
-	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
 }
 
 /* Update the inode counters. */

