Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F7BE4D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVTf8zG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18170C433C7;
	Sun, 31 Dec 2023 21:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059278;
	bh=woua6IpqqqlyjVZ9b74wmYzhNy0KRmv2OM6hIs3bF0g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVTf8zG8ZcO+QjWN9s2GSu7cqa3ouYELKvcyCnT6u+bFy6jK5TZUJOYPd2uLR9ejd
	 3ffqz1JkVkv7pNSEa7YFa+0SPU6Opm5yPAS30l+Lwo+FeJU869DJ/EMdsK60d2WGot
	 yLJz9j1I9aTypUWk8vdm1ywbgrleGxynZr4D+O/a8jGw9ZkH5GRlJjfWCAF0CQJ3az
	 oXAbowd7cILir+nK3VJd9SoCebhzDGOnxkKLL9IF1DumuGxUaDj3c6dp4SH5yWCk3Q
	 3JHCQWlbG4qP8WJgor7F8JNGterWyxX5C3VaYIVCPB5j5kK2nmlu7Ua64uzFZoXhPH
	 0HF9yN3HolMzg==
Date: Sun, 31 Dec 2023 13:47:57 -0800
Subject: [PATCH 13/44] xfs: wire up a new inode fork type for the realtime
 refcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851792.1766284.1788850346864434897.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Plumb in the pieces we need to embed the root of the realtime refcount
btree in an inode's data fork, complete with new fork type and
on-disk interpretation functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h           |    8 +
 fs/xfs/libxfs/xfs_inode_fork.c       |    8 +
 fs/xfs/libxfs/xfs_ondisk.h           |    1 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  236 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  112 ++++++++++++++++
 fs/xfs/xfs_inode_item_recover.c      |    4 +
 6 files changed, 366 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 93a9b8e3b5694..ca964befb51cf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1824,6 +1824,14 @@ typedef __be32 xfs_refcount_ptr_t;
  */
 #define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
+/*
+ * rt refcount root header, on-disk form only.
+ */
+struct xfs_rtrefcount_root {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+};
+
 /* inode-rooted btree pointer type */
 typedef __be64 xfs_rtrefcount_ptr_t;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ae6e7deb04106..df42ffa15d96e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -28,6 +28,7 @@
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -274,8 +275,7 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_REFCOUNT:
 			if (!xfs_has_rtreflink(ip->i_mount))
 				return -EFSCORRUPTED;
-			ASSERT(0); /* to be implemented later */
-			return -EFSCORRUPTED;
+			return xfs_iformat_rtrefcount(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -672,7 +672,9 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_REFCOUNT:
-		ASSERT(0); /* to be implemented later */
+		ASSERT(whichfork == XFS_DATA_FORK);
+		if (iip->ili_fields & brootflag[whichfork])
+			xfs_iflush_rtrefcount(ip, dip);
 		break;
 
 	default:
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 242b683125662..3a5581ecb36d4 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -80,6 +80,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrefcount_root,	4);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index e1e8a3ea32091..ae8dea035d29f 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -85,6 +85,41 @@ xfs_rtrefcountbt_get_maxrecs(
 	return cur->bc_mp->m_rtrefc_mxr[level != 0];
 }
 
+/*
+ * Calculate number of records in a realtime refcount btree inode root.
+ */
+unsigned int
+xfs_rtrefcountbt_droot_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= sizeof(struct xfs_rtrefcount_root);
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (2 * sizeof(struct xfs_refcount_key) +
+			sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_rtrefcountbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork so that
+ * we can resize the in-memory buffer to match it.  After a resize to the
+ * maximum size this function returns the same value as
+ * xfs_rtrefcountbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_rtrefcountbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_rtrefc_mxr[level != 0];
+	return xfs_rtrefcountbt_droot_maxrecs(cur->bc_ino.forksize, level == 0);
+}
+
 STATIC void
 xfs_rtrefcountbt_init_key_from_rec(
 	union xfs_btree_key		*key,
@@ -255,6 +290,68 @@ xfs_rtrefcountbt_keys_contiguous(
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
 
+/* Move the rt refcount btree root from one incore buffer to another. */
+static void
+xfs_rtrefcountbt_broot_move(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_btree_block	*dst_broot,
+	size_t			dst_bytes,
+	struct xfs_btree_block	*src_broot,
+	size_t			src_bytes,
+	unsigned int		level,
+	unsigned int		numrecs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	void			*dptr;
+	void			*sptr;
+
+	ASSERT(xfs_rtrefcount_droot_space(src_broot) <=
+			xfs_inode_fork_size(ip, whichfork));
+
+	/*
+	 * We always have to move the pointers because they are not butted
+	 * against the btree block header.
+	 */
+	if (numrecs && level > 0) {
+		sptr = xfs_rtrefcount_broot_ptr_addr(mp, src_broot, 1,
+				src_bytes);
+		dptr = xfs_rtrefcount_broot_ptr_addr(mp, dst_broot, 1,
+				dst_bytes);
+		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
+	}
+
+	if (src_broot == dst_broot)
+		return;
+
+	/*
+	 * If the root is being totally relocated, we have to migrate the block
+	 * header and the keys/records that come after it.
+	 */
+	memcpy(dst_broot, src_broot, XFS_RTREFCOUNT_BLOCK_LEN);
+
+	if (!numrecs)
+		return;
+
+	if (level == 0) {
+		sptr = xfs_rtrefcount_rec_addr(src_broot, 1);
+		dptr = xfs_rtrefcount_rec_addr(dst_broot, 1);
+		memcpy(dptr, sptr,
+				numrecs * sizeof(struct xfs_refcount_rec));
+	} else {
+		sptr = xfs_rtrefcount_key_addr(src_broot, 1);
+		dptr = xfs_rtrefcount_key_addr(dst_broot, 1);
+		memcpy(dptr, sptr,
+				numrecs * sizeof(struct xfs_refcount_key));
+	}
+}
+
+static const struct xfs_ifork_broot_ops xfs_rtrefcountbt_iroot_ops = {
+	.maxrecs		= xfs_rtrefcountbt_maxrecs,
+	.size			= xfs_rtrefcount_broot_space_calc,
+	.move			= xfs_rtrefcountbt_broot_move,
+};
+
 const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
@@ -267,6 +364,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.free_block		= xfs_btree_free_imeta_block,
 	.get_minrecs		= xfs_rtrefcountbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrefcountbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrefcountbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrefcountbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
@@ -277,6 +375,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
+	.iroot_ops		= &xfs_rtrefcountbt_iroot_ops,
 };
 
 /* Initialize a new rt refcount btree cursor. */
@@ -530,3 +629,140 @@ xfs_rtrefcountbt_calc_reserves(
 	return xfs_rtrefcountbt_max_size(mp,
 			xfs_rtb_to_rtx(mp, mp->m_sb.sb_rgblocks));
 }
+
+/*
+ * Convert on-disk form of btree root to in-memory form.
+ */
+STATIC void
+xfs_rtrefcountbt_from_disk(
+	struct xfs_inode		*ip,
+	struct xfs_rtrefcount_root	*dblock,
+	int				dblocklen,
+	struct xfs_btree_block		*rblock)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_refcount_key	*fkp;
+	__be64				*fpp;
+	struct xfs_refcount_key	*tkp;
+	__be64				*tpp;
+	struct xfs_refcount_rec	*frp;
+	struct xfs_refcount_rec	*trp;
+	unsigned int			numrecs;
+	unsigned int			maxrecs;
+	unsigned int			rblocklen;
+
+	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
+
+	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
+			ip->i_ino);
+
+	rblock->bb_level = dblock->bb_level;
+	rblock->bb_numrecs = dblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrefcount_droot_key_addr(dblock, 1);
+		tkp = xfs_rtrefcount_key_addr(rblock, 1);
+		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
+		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		numrecs = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
+		trp = xfs_rtrefcount_rec_addr(rblock, 1);
+		numrecs = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Load a realtime reference count btree root in from disk. */
+int
+xfs_iformat_rtrefcount(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_rtrefcount_root *dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	unsigned int		numrecs;
+	unsigned int		level;
+	int			dsize;
+
+	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
+	numrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > mp->m_rtrefc_maxlevels ||
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+		return -EFSCORRUPTED;
+
+	xfs_iroot_alloc(ip, XFS_DATA_FORK,
+			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
+	xfs_rtrefcountbt_from_disk(ip, dfp, dsize, ifp->if_broot);
+	return 0;
+}
+
+/*
+ * Convert in-memory form of btree root to on-disk form.
+ */
+void
+xfs_rtrefcountbt_to_disk(
+	struct xfs_mount		*mp,
+	struct xfs_btree_block		*rblock,
+	int				rblocklen,
+	struct xfs_rtrefcount_root	*dblock,
+	int				dblocklen)
+{
+	struct xfs_refcount_key	*fkp;
+	__be64				*fpp;
+	struct xfs_refcount_key	*tkp;
+	__be64				*tpp;
+	struct xfs_refcount_rec	*frp;
+	struct xfs_refcount_rec	*trp;
+	unsigned int			maxrecs;
+	unsigned int			numrecs;
+
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_RTREFC_CRC_MAGIC));
+	ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
+	ASSERT(rblock->bb_u.l.bb_blkno == cpu_to_be64(XFS_BUF_DADDR_NULL));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
+
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrefcount_key_addr(rblock, 1);
+		tkp = xfs_rtrefcount_droot_key_addr(dblock, 1);
+		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
+		numrecs = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrefcount_rec_addr(rblock, 1);
+		trp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
+		numrecs = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Flush a realtime reference count btree root out to disk. */
+void
+xfs_iflush_rtrefcount(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_rtrefcount_root *dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+
+	ASSERT(ifp->if_broot != NULL);
+	ASSERT(ifp->if_broot_bytes > 0);
+	ASSERT(xfs_rtrefcount_droot_space(ifp->if_broot) <=
+			xfs_inode_fork_size(ip, XFS_DATA_FORK));
+	xfs_rtrefcountbt_to_disk(ip->i_mount, ifp->if_broot,
+			ifp->if_broot_bytes, dfp,
+			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index 045f7b1f72833..bd070e54781a1 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -27,6 +27,7 @@ void xfs_rtrefcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 unsigned int xfs_rtrefcountbt_maxrecs(struct xfs_mount *mp,
 		unsigned int blocklen, bool leaf);
 void xfs_rtrefcountbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rtrefcountbt_droot_maxrecs(unsigned int blocklen, bool leaf);
 
 /*
  * Addresses of records, keys, and pointers within an incore rtrefcountbt block.
@@ -76,4 +77,115 @@ xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
 unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+/* Addresses of key, pointers, and records within an ondisk rtrefcount block. */
+
+static inline struct xfs_refcount_rec *
+xfs_rtrefcount_droot_rec_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index)
+{
+	return (struct xfs_refcount_rec *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_refcount_rec));
+}
+
+static inline struct xfs_refcount_key *
+xfs_rtrefcount_droot_key_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index)
+{
+	return (struct xfs_refcount_key *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_refcount_key));
+}
+
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_droot_ptr_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index,
+	unsigned int			maxrecs)
+{
+	return (xfs_rtrefcount_ptr_t *)
+		((char *)(block + 1) +
+		 maxrecs * sizeof(struct xfs_refcount_key) +
+		 (index - 1) * sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Address of pointers within the incore btree root.
+ *
+ * These are to be used when we know the size of the block and
+ * we don't have a cursor.
+ */
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_broot_ptr_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*bb,
+	unsigned int		index,
+	unsigned int		block_size)
+{
+	return xfs_rtrefcount_ptr_addr(bb, index,
+			xfs_rtrefcountbt_maxrecs(mp, block_size, false));
+}
+
+/*
+ * Compute the space required for the incore btree root containing the given
+ * number of records.
+ */
+static inline size_t
+xfs_rtrefcount_broot_space_calc(
+	struct xfs_mount	*mp,
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = XFS_RTREFCOUNT_BLOCK_LEN;
+
+	if (level > 0)
+		return sz + nrecs * (sizeof(struct xfs_refcount_key) +
+				     sizeof(xfs_rtrefcount_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_refcount_rec);
+}
+
+/*
+ * Compute the space required for the incore btree root given the ondisk
+ * btree root block.
+ */
+static inline size_t
+xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
+{
+	return xfs_rtrefcount_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+/* Compute the space required for the ondisk root block. */
+static inline size_t
+xfs_rtrefcount_droot_space_calc(
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = sizeof(struct xfs_rtrefcount_root);
+
+	if (level > 0)
+		return sz + nrecs * (sizeof(struct xfs_refcount_key) +
+				     sizeof(xfs_rtrefcount_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_refcount_rec);
+}
+
+/*
+ * Compute the space required for the ondisk root block given an incore root
+ * block.
+ */
+static inline size_t
+xfs_rtrefcount_droot_space(struct xfs_btree_block *bb)
+{
+	return xfs_rtrefcount_droot_space_calc(be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+int xfs_iformat_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
+void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
+		struct xfs_btree_block *rblock, int rblocklen,
+		struct xfs_rtrefcount_root *dblock, int dblocklen);
+void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 2b5f7a143c479..317a27e6a5a4b 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -23,6 +23,7 @@
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 STATIC void
 xlog_recover_inode_ra_pass2(
@@ -284,6 +285,9 @@ xlog_recover_inode_dbroot(
 	case XFS_DINODE_FMT_RMAP:
 		xfs_rtrmapbt_to_disk(mp, src, len, dfork, dsize);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		xfs_rtrefcountbt_to_disk(mp, src, len, dfork, dsize);
+		break;
 	default:
 		ASSERT(0);
 		return -EFSCORRUPTED;

