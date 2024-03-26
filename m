Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99D1292C4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422797; cv=none; b=YOhjUvGi+fmYOkZu9HqID1bDpB5tH8OeyX92EKtS2pdaQSYFDelrS+uEm4J1P4cKYPj5CAv/lTpafDvllNh+InanLGBim69fqPDsPz5iGixmJSWQNbYFMA7VsTQjGHE0Y4r6W9s7yLHkaxPdA0uWQRxf5q+O2dMbTdXnvZepgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422797; c=relaxed/simple;
	bh=BOyJjmauS2LdKrEtFJ5YjD185t3wiWpkLAknynV8gUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TcRvVeuvQLemhLV4J+W4rklIYXx7dFYVcxzJApzLgqzrU89AAV7ycvuWN0u0gTWQmBg7XdiP/VVWugD6jx09YYarlRup9QRxkIWQrIDmFc/E2KZDSr1//ymgaOsHLmRoHgUXMqCiR/OYM4/hdRyJ3Or2Ot8iXt5TFss6AiGSDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdAE+cyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdAE+cyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAFDC433C7;
	Tue, 26 Mar 2024 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422796;
	bh=BOyJjmauS2LdKrEtFJ5YjD185t3wiWpkLAknynV8gUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdAE+cyhlFti1GfZ3LqhuY27qhPqK9CYsi/9MxYVI6Fl0ge68oSncol+Kq8dBRDFE
	 zA5mCEnbfCVciIHMotjoxneVUxkWLxMSjS27LaUQ9RZvykYjk+ujn3V3DJzBOpdw9a
	 BIF5j/JjOlvUSj9MkpnZcNFHUqiNXNB3jC90/G8pUQKXxOzZ3bfHtrSGA4qmlsxEp9
	 TiJ1sIPPACk+55xrBD+AqrD7MhpoifRaYy4vEtXWJlNIxrU3PQ7RUekITGF22HW+tJ
	 tXMUPg5zar0AxwOSGwRq7nAfFQca0Hqj1H3N50QjNZJoqA19nf+VcMaf/iFq4MmFMo
	 qtJ6Pk0FtIOSw==
Date: Mon, 25 Mar 2024 20:13:16 -0700
Subject: [PATCH 40/67] xfs: repair inode fork block mapping data structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127539.2212320.1516672647870344597.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8f71bede8efd820627ac05c19eac2758214bc896

Use the reverse-mapping btree information to rebuild an inode block map.
Update the btree bulk loading code as necessary to support inode rooted
btrees and fix some bitrot problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap_btree.c    |  121 +++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_bmap_btree.h    |    5 ++
 libxfs/xfs_btree_staging.c |   11 +++-
 libxfs/xfs_btree_staging.h |    2 -
 libxfs/xfs_iext_tree.c     |   23 ++++++--
 libxfs/xfs_inode_fork.c    |    1 
 libxfs/xfs_inode_fork.h    |    3 +
 7 files changed, 136 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index c4d5c8a64747..73ba067df06e 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -15,6 +15,7 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
@@ -286,10 +287,7 @@ xfs_bmbt_get_minrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
-				    cur->bc_ino.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0) / 2;
@@ -304,10 +302,7 @@ xfs_bmbt_get_maxrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = xfs_ifork_ptr(cur->bc_ino.ip,
-				    cur->bc_ino.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0);
@@ -541,23 +536,19 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_contiguous	= xfs_bmbt_keys_contiguous,
 };
 
-/*
- * Allocate a new bmap btree cursor.
- */
-struct xfs_btree_cur *				/* new bmap btree cursor */
-xfs_bmbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* inode owning the btree */
-	int			whichfork)	/* data or attr fork */
+static struct xfs_btree_cur *
+xfs_bmbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork)
 {
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
+
 	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
-	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
@@ -565,10 +556,30 @@ xfs_bmbt_init_cursor(
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
+
+	return cur;
+}
+
+/*
+ * Allocate a new bmap btree cursor.
+ */
+struct xfs_btree_cur *
+xfs_bmbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_bmbt_init_common(mp, tp, ip, whichfork);
+
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.whichfork = whichfork;
 
 	return cur;
@@ -585,6 +596,76 @@ xfs_bmbt_block_maxrecs(
 	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
 }
 
+/*
+ * Allocate a new bmap btree cursor for reloading an inode block mapping data
+ * structure.  Note that callers can use the staged cursor to reload extents
+ * format inode forks if they rebuild the iext tree and commit the staged
+ * cursor immediately.
+ */
+struct xfs_btree_cur *
+xfs_bmbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_btree_ops	*ops;
+
+	/* data fork always has larger maxheight */
+	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
+
+	/* Don't let anyone think we're attached to the real fork yet. */
+	cur->bc_ino.whichfork = -1;
+	xfs_btree_stage_ifakeroot(cur, ifake, &ops);
+	ops->update_cursor = NULL;
+	return cur;
+}
+
+/*
+ * Swap in the new inode fork root.  Once we pass this point the newly rebuilt
+ * mappings are in place and we have to kill off any old btree blocks.
+ */
+void
+xfs_bmbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	int			whichfork)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_ino.ifake;
+	struct xfs_ifork	*ifp;
+	static const short	brootflag[2] = {XFS_ILOG_DBROOT, XFS_ILOG_ABROOT};
+	static const short	extflag[2] = {XFS_ILOG_DEXT, XFS_ILOG_AEXT};
+	int			flags = XFS_ILOG_CORE;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(whichfork != XFS_COW_FORK);
+
+	/*
+	 * Free any resources hanging off the real fork, then shallow-copy the
+	 * staging fork's contents into the real fork to transfer everything
+	 * we just built.
+	 */
+	ifp = xfs_ifork_ptr(cur->bc_ino.ip, whichfork);
+	xfs_idestroy_fork(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		flags |= extflag[whichfork];
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		flags |= brootflag[whichfork];
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, tp, whichfork, &xfs_bmbt_ops);
+}
+
 /*
  * Calculate number of records in a bmap btree block.
  */
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 3e7a40a83835..151b8491f60e 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_block;
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_trans;
+struct xbtree_ifakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -106,6 +107,10 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
+struct xfs_btree_cur *xfs_bmbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_inode *ip, struct xbtree_ifakeroot *ifake);
+void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, int whichfork);
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index d4164e37bd38..0ea44dcf14f3 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -405,7 +405,7 @@ xfs_btree_bload_prep_block(
 		ASSERT(*bpp == NULL);
 
 		/* Allocate a new incore btree root block. */
-		new_size = bbl->iroot_size(cur, nr_this_block, priv);
+		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
 		ifp->if_broot = kmem_zalloc(new_size, 0);
 		ifp->if_broot_bytes = (int)new_size;
 
@@ -596,7 +596,14 @@ xfs_btree_bload_level_geometry(
 	unsigned int		desired_npb;
 	unsigned int		maxnr;
 
-	maxnr = cur->bc_ops->get_maxrecs(cur, level);
+	/*
+	 * Compute the absolute maximum number of records that we can store in
+	 * the ondisk block or inode root.
+	 */
+	if (cur->bc_ops->get_dmaxrecs)
+		maxnr = cur->bc_ops->get_dmaxrecs(cur, level);
+	else
+		maxnr = cur->bc_ops->get_maxrecs(cur, level);
 
 	/*
 	 * Compute the number of blocks we need to fill each block with the
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index f0a5007284ef..055ea43b1e18 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -53,7 +53,7 @@ typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
-		unsigned int nr_this_level, void *priv);
+		unsigned int level, unsigned int nr_this_level, void *priv);
 
 struct xfs_btree_bload {
 	/*
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 7f5c4f403d6d..5d0be2dc8fed 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -622,13 +622,11 @@ static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp)
 }
 
 void
-xfs_iext_insert(
-	struct xfs_inode	*ip,
+xfs_iext_insert_raw(
+	struct xfs_ifork	*ifp,
 	struct xfs_iext_cursor	*cur,
-	struct xfs_bmbt_irec	*irec,
-	int			state)
+	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 	xfs_fileoff_t		offset = irec->br_startoff;
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
@@ -662,12 +660,23 @@ xfs_iext_insert(
 	xfs_iext_set(cur_rec(cur), irec);
 	ifp->if_bytes += sizeof(struct xfs_iext_rec);
 
-	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
-
 	if (new)
 		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
 }
 
+void
+xfs_iext_insert(
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*cur,
+	struct xfs_bmbt_irec	*irec,
+	int			state)
+{
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
+
+	xfs_iext_insert_raw(ifp, cur, irec);
+	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
+}
+
 static struct xfs_iext_node *
 xfs_iext_rebalance_node(
 	struct xfs_iext_node	*parent,
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 3e2d7882a077..80f4215d24bd 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -518,6 +518,7 @@ xfs_idata_realloc(
 	ifp->if_bytes = new_size;
 }
 
+/* Free all memory and reset a fork back to its initial state. */
 void
 xfs_idestroy_fork(
 	struct xfs_ifork	*ifp)
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 96d307784c85..535be5c03689 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -180,6 +180,9 @@ void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
 				const void *data, int64_t size);
 
 xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
+void		xfs_iext_insert_raw(struct xfs_ifork *ifp,
+			struct xfs_iext_cursor *cur,
+			struct xfs_bmbt_irec *irec);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
 			struct xfs_bmbt_irec *, int);
 void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,

