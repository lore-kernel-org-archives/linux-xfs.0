Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128A5234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346142; cv=none; b=pY616pk02FoYkT4prRzZCJlJU/od+86k+e2JvUqzgHwL0+NJOh3S+I913ScnWiEKq9brEk0RwjybKUm/zGQRPL8WcHLfEUzF+/uVRfepra513SaMJoZ00i48Y04SCwjf1OdEZTiQ9BCgmnffYAebSl7RxFLrmLAQYyOdfnXhnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346142; c=relaxed/simple;
	bh=IAZ943z8Aej9n030BTQu3qs9uYC5W/n4x9NM2PZYQYw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jd/vDj7UqBsoldwi/Y4PR/aQVk6AGeh6kvsbNXInWaoizg7XpkKN8y2jP2dxZi6JYExdwD7qMDJzTAbGggtlUsXezXm6Q6SRr6XgpNcL25FbznMkvYaUBN5oFJ7dXoeVQbdOMYLlYLv46XI8BteSlFw1TNKXe1yaSKRgyEdKpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYGZ7onT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYGZ7onT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDEAC2BD11;
	Wed, 22 May 2024 02:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346142;
	bh=IAZ943z8Aej9n030BTQu3qs9uYC5W/n4x9NM2PZYQYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sYGZ7onTfoJrUUDXkZ1Y0bOOrDDvFqzqC/N42U2vA2NafO+CIKtGFoNLwTIqwotHV
	 PF875H3vv+xQi8BTCf7+1Grir8GJ/8meM2l7X53CM1dCTTZMx3uUui/iCQrVvG6Don
	 V2/eJ1Ym/fMbh4Fcow3PVNtDZ4Nh450GdDAjsNrer/3ojtpFx4YxC4605NYHjsiaaX
	 6dR4VQpej3w8H41vI3/WcojlMHPt7QoYIKwCEG7X7fDXibHNad4Dpc4fWbB/T2YH7l
	 xeohuDjQt0mgZI8zEby3QkJ2PJwjb9wj6N0VqIwV1GeMHI2QQDjKvT68KZ/zffGt9L
	 8wSaqg/yhKotA==
Date: Tue, 21 May 2024 19:49:01 -0700
Subject: [PATCH 001/111] xfs: convert kmem_zalloc() to kzalloc()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634531725.2478931.15237009832992963071.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 10634530f7ba947d8eab52a580e0840778d4ef75

There's no reason to keep the kmem_zalloc() around anymore, it's
just a thin wrapper around kmalloc(), so lets get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/kmem.h             |    5 ++++-
 libxfs/xfs_ag.c            |    2 +-
 libxfs/xfs_attr_leaf.c     |    3 ++-
 libxfs/xfs_btree_staging.c |    2 +-
 libxfs/xfs_da_btree.c      |    5 +++--
 libxfs/xfs_defer.c         |    2 +-
 libxfs/xfs_dir2.c          |   18 +++++++++---------
 libxfs/xfs_iext_tree.c     |   12 ++++++++----
 8 files changed, 29 insertions(+), 20 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 8ae919c70..6818a4047 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -25,8 +25,9 @@ typedef unsigned int __bitwise gfp_t;
 #define GFP_NOFS	((__force gfp_t)0)
 #define __GFP_NOFAIL	((__force gfp_t)0)
 #define __GFP_NOLOCKDEP	((__force gfp_t)0)
+#define __GFP_RETRY_MAYFAIL	((__force gfp_t)0)
 
-#define __GFP_ZERO	(__force gfp_t)1
+#define __GFP_ZERO	((__force gfp_t)1)
 
 struct kmem_cache * kmem_cache_create(const char *name, unsigned int size,
 		unsigned int align, unsigned int slab_flags,
@@ -65,6 +66,8 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 	return kvmalloc(size, flags);
 }
 
+#define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
+
 static inline void kfree(const void *ptr)
 {
 	return kmem_free(ptr);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 0556d5547..b22be1477 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -379,7 +379,7 @@ xfs_initialize_perag(
 			continue;
 		}
 
-		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index e3f8f67b5..8a0a7c219 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2247,7 +2247,8 @@ xfs_attr3_leaf_unbalance(
 		struct xfs_attr_leafblock *tmp_leaf;
 		struct xfs_attr3_icleaf_hdr tmphdr;
 
-		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
+		tmp_leaf = kzalloc(state->args->geo->blksize,
+				GFP_KERNEL | __GFP_NOFAIL);
 
 		/*
 		 * Copy the header into the temp leaf so that all the stuff
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 0ea44dcf1..45b793559 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -406,7 +406,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kmem_zalloc(new_size, 0);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 0779bb624..0864cb5ed 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2514,7 +2514,7 @@ xfs_dabuf_map(
 	int			error = 0, nirecs, i;
 
 	if (nfsb > 1)
-		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
+		irecs = kzalloc(sizeof(irec) * nfsb, GFP_NOFS | __GFP_NOFAIL);
 
 	nirecs = nfsb;
 	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
@@ -2527,7 +2527,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
+		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
+				GFP_NOFS | __GFP_NOFAIL);
 		if (!map) {
 			error = -ENOMEM;
 			goto out_free_irecs;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bf1d1e06a..70489b097 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -973,7 +973,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index a781520c8..cb299a6ed 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -103,10 +103,10 @@ xfs_da_mount(
 	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
 
-	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				    KM_MAYFAIL);
-	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
-				     KM_MAYFAIL);
+	mp->m_dir_geo = kzalloc(sizeof(struct xfs_da_geometry),
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	mp->m_attr_geo = kzalloc(sizeof(struct xfs_da_geometry),
+				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!mp->m_dir_geo || !mp->m_attr_geo) {
 		kmem_free(mp->m_dir_geo);
 		kmem_free(mp->m_attr_geo);
@@ -235,7 +235,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -272,7 +272,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -371,7 +371,7 @@ xfs_dir_lookup(
 	 * lockdep Doing this avoids having to add a bunch of lockdep class
 	 * annotations into the reclaim path for the ilock.
 	 */
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
@@ -440,7 +440,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -501,7 +501,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kmem_zalloc(sizeof(*args), KM_NOFS);
+	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 24124039f..641b53f4e 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -398,7 +398,8 @@ static void
 xfs_iext_grow(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_node	*node = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	int			i;
 
 	if (ifp->if_height == 1) {
@@ -454,7 +455,8 @@ xfs_iext_split_node(
 	int			*nr_entries)
 {
 	struct xfs_iext_node	*node = *nodep;
-	struct xfs_iext_node	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_node	*new = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	const int		nr_move = KEYS_PER_NODE / 2;
 	int			nr_keep = nr_move + (KEYS_PER_NODE & 1);
 	int			i = 0;
@@ -542,7 +544,8 @@ xfs_iext_split_leaf(
 	int			*nr_entries)
 {
 	struct xfs_iext_leaf	*leaf = cur->leaf;
-	struct xfs_iext_leaf	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
+	struct xfs_iext_leaf	*new = kzalloc(NODE_SIZE,
+						GFP_NOFS | __GFP_NOFAIL);
 	const int		nr_move = RECS_PER_LEAF / 2;
 	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
 	int			i;
@@ -583,7 +586,8 @@ xfs_iext_alloc_root(
 {
 	ASSERT(ifp->if_bytes == 0);
 
-	ifp->if_data = kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS);
+	ifp->if_data = kzalloc(sizeof(struct xfs_iext_rec),
+					GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_height = 1;
 
 	/* now that we have a node step into it */

