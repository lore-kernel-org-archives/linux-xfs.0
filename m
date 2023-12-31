Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F65BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajsm9rJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA69DC433C8;
	Sun, 31 Dec 2023 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057884;
	bh=pecXqU7b6oVKLNZtY0fCb60s2i39sAlcBoOfk25Qhc0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ajsm9rJo2A8Ryb6l11oS9n1bVrthFBkkYXAeAMAqx2ktAVG7DZ8D5yFEoWlgKv6R4
	 xiRQfXa2YAKLac1+MsbfCj3hJMD7zuFOz5zEd9UmzuzHRuKUBmf0852bVvvugTjsZd
	 GC1dMdMYtINBazxxRiqSfmIH+7Nm6x9zFw/ykTq74vvdTM6vl5qX11fmrRUY/gwU6k
	 hGeaCK2NQ3UGZNOcjII6O4kPFTxeY38Ir/ji6j1xSoLTuEO4/lqfvhwPb4ABk94G/p
	 ILv5E/k+Gh/YQBaHX4qfB1SEdhbw/4kcEA+MfBpuEI7kOOERevqAl4FKbYnDLEw4Fo
	 IAGRaFDUEwhsg==
Date: Sun, 31 Dec 2023 13:24:44 -0800
Subject: [PATCH 10/14] xfs: support leaves in the incore btree root block in
 xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847529.1763835.15054363501322468315.stgit@frogsfrogsfrogs>
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

Add some logic to xfs_iroot_realloc so that we can handle leaf records
in the btree root block correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |    4 +++-
 fs/xfs/libxfs/xfs_bmap_btree.h |    5 ++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   12 +++++++-----
 fs/xfs/libxfs/xfs_inode_fork.h |    5 +++--
 fs/xfs/scrub/bmap_repair.c     |    2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 51ffe59fa4485..0a5020c8e0f5e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -522,6 +522,7 @@ xfs_bmbt_broot_move(
 	size_t			dst_bytes,
 	struct xfs_btree_block	*src_broot,
 	size_t			src_bytes,
+	unsigned int		level,
 	unsigned int		numrecs)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -529,6 +530,7 @@ xfs_bmbt_broot_move(
 	void			*sptr;
 
 	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+	ASSERT(level > 0);
 
 	/*
 	 * We always have to move the pointers because they are not butted
@@ -841,7 +843,7 @@ xfs_bmbt_iroot_alloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
 	xfs_iroot_alloc(ip, whichfork,
-			xfs_bmap_broot_space_calc(ip->i_mount, 1));
+			xfs_bmap_broot_space_calc(ip->i_mount, 1, 1));
 
 	/* Fill in the root. */
 	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_bmbt_ops, 1, 1,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index a9ddc9b42e614..d20321bfe2f60 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e342be9911774..16543bb873a81 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -409,6 +409,7 @@ xfs_iroot_realloc(
 	struct xfs_btree_block		*new_broot;
 	size_t				new_size;
 	size_t				old_size = ifp->if_broot_bytes;
+	unsigned int			level;
 	int				cur_max;
 	int				new_max;
 
@@ -423,16 +424,17 @@ xfs_iroot_realloc(
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
@@ -444,7 +446,7 @@ xfs_iroot_realloc(
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
 		ops->move(ip, whichfork, ifp->if_broot, new_size,
-				ifp->if_broot, old_size, cur_max);
+				ifp->if_broot, old_size, level, cur_max);
 		return;
 	}
 
@@ -461,7 +463,7 @@ xfs_iroot_realloc(
 	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
 	ops->move(ip, whichfork, new_broot, new_size, ifp->if_broot,
-			ifp->if_broot_bytes, new_max);
+			ifp->if_broot_bytes, level, new_max);
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 1ac9a7a8b5f5e..9a0136f82738d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index f005c21770204..8a6dc7ff2f79e 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -480,7 +480,7 @@ xrep_bmap_iroot_size(
 {
 	ASSERT(level > 0);
 
-	return xfs_bmap_broot_space_calc(cur->bc_mp, nr_this_level);
+	return xfs_bmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
 }
 
 /* Update the inode counters. */

