Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BDE23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881651; cv=none; b=W/aPsDUqwOJcXDcXOeHr5wbMo3cnSGyob+dM4qJ05TNpPa78J7IpzYMSXVbtoJyioaWyJBEtBoq7+gJneYuwf3m36wlujNOdNEKgKRTV0bVONx8ayMGOrM7jso2vOUtsWHNyMRaThc5EDjvcFU4FBpnZTzcpQMBOlwjGp9UwQTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881651; c=relaxed/simple;
	bh=704Q2nCBXAHrSNS4R8mhrmSvtCHyvziCTW2rBpAd5pg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F5aDxCF93syfy807udfM4c0IXo0hj2wGBYiUYqme+6VJitXvFyOKqpjp4IBeX+FFklGm06rw3T/+5o7Jtux9g1j7Htc31X5Cf4fxh4nvZhzc6zTBXDOveukAa7T3w600NybPaVxPQM0vcHw6/E1ORoHan4lfWUp0opVc2vsfkPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fp01bzok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fp01bzok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D71FC4CEDD;
	Thu,  6 Feb 2025 22:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881651;
	bh=704Q2nCBXAHrSNS4R8mhrmSvtCHyvziCTW2rBpAd5pg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fp01bzokF+jXQ68Klrfx5QKwUowfrh6EZalUK0S03iq+IE75WiY5JHI0dGz1XgJYJ
	 D/2DEEiCdnBLVk9uKM6h1xwYSSNUYFUJtQ7FZQjpLtcs2xUQHZ9jbALyNZXrQ8PiyB
	 lMi+f5dkI6aSlc/Ap5Psy4lyoS0VxF+GAEhREMxfVx1O/KJy4q5X8ykmLaLIE990+6
	 qZ70AbDwZNZ+f03BponClXurp+IgnlYVvDoH0cCPsWK6Hq9Ow2Ldnk1zLzdHD4HmOJ
	 GetfCMJBFKHlY2TwqOevRMX4bafKCxDtT4XuSfzBwk7CjaJSF4jm/mdeY66PFnbg6r
	 JIPhLGjMIKU0Q==
Date: Thu, 06 Feb 2025 14:40:50 -0800
Subject: [PATCH 22/56] xfs: wire up a new metafile type for the realtime rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087128.2739176.11825373066552957037.stgit@frogsfrogsfrogs>
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

Source kernel commit: f33659e8a114e2c17108227d30a2bdf398e39bdb

Plumb in the pieces we need to embed the root of the realtime rmap btree
in an inode's data fork, complete with new metafile type and on-disk
interpretation functions.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h       |    8 +
 libxfs/xfs_inode_fork.c   |    6 +
 libxfs/xfs_ondisk.h       |    1 
 libxfs/xfs_rtrmap_btree.c |  251 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |  112 ++++++++++++++++++++
 5 files changed, 375 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f32c9fda5a195f..fba4e59aded4a0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1736,6 +1736,14 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/*
+ * rtrmap root header, on-disk form only.
+ */
+struct xfs_rtrmap_root {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+};
+
 /* inode-based btree pointer type */
 typedef __be64 xfs_rtrmap_ptr_t;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 7c481d159cce15..e4f866969bf1b6 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -25,6 +25,7 @@
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -268,8 +269,7 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_META_BTREE:
 			switch (ip->i_metatype) {
 			case XFS_METAFILE_RTRMAP:
-				ASSERT(0); /* to be implemented later */
-				return -EFSCORRUPTED;
+				return xfs_iformat_rtrmap(ip, dip);
 			default:
 				break;
 			}
@@ -616,7 +616,7 @@ xfs_iflush_fork(
 
 		switch (ip->i_metatype) {
 		case XFS_METAFILE_RTRMAP:
-			ASSERT(0); /* to be implemented later */
+			xfs_iflush_rtrmap(ip, dip);
 			break;
 		default:
 			ASSERT(0);
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 2c50877a1a2f0b..07e2f5fb3a94ae 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -84,6 +84,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
 
 	/*
 	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 08d1e75f190854..39fd9a0ab986e6 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -75,6 +75,39 @@ xfs_rtrmapbt_get_maxrecs(
 	return cur->bc_mp->m_rtrmap_mxr[level != 0];
 }
 
+/* Calculate number of records in the ondisk realtime rmap btree inode root. */
+unsigned int
+xfs_rtrmapbt_droot_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= sizeof(struct xfs_rtrmap_root);
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen / (2 * sizeof(struct xfs_rmap_key) +
+			sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_rtrmapbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork
+ * so that we can resize the in-memory buffer to match it.  After a
+ * resize to the maximum size this function returns the same value
+ * as xfs_rtrmapbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_rtrmapbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_rtrmap_mxr[level != 0];
+	return xfs_rtrmapbt_droot_maxrecs(cur->bc_ino.forksize, level == 0);
+}
+
 /*
  * Convert the ondisk record's offset field into the ondisk key's offset field.
  * Fork and bmbt are significant parts of the rmap record key, but written
@@ -367,6 +400,87 @@ xfs_rtrmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
+static inline void
+xfs_rtrmapbt_move_ptrs(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*broot,
+	short			old_size,
+	size_t			new_size,
+	unsigned int		numrecs)
+{
+	void			*dptr;
+	void			*sptr;
+
+	sptr = xfs_rtrmap_broot_ptr_addr(mp, broot, 1, old_size);
+	dptr = xfs_rtrmap_broot_ptr_addr(mp, broot, 1, new_size);
+	memmove(dptr, sptr, numrecs * sizeof(xfs_rtrmap_ptr_t));
+}
+
+static struct xfs_btree_block *
+xfs_rtrmapbt_broot_realloc(
+	struct xfs_btree_cur	*cur,
+	unsigned int		new_numrecs)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+	struct xfs_btree_block	*broot;
+	unsigned int		new_size;
+	unsigned int		old_size = ifp->if_broot_bytes;
+	const unsigned int	level = cur->bc_nlevels - 1;
+
+	new_size = xfs_rtrmap_broot_space_calc(mp, level, new_numrecs);
+
+	/* Handle the nop case quietly. */
+	if (new_size == old_size)
+		return ifp->if_broot;
+
+	if (new_size > old_size) {
+		unsigned int	old_numrecs;
+
+		/*
+		 * If there wasn't any memory allocated before, just allocate
+		 * it now and get out.
+		 */
+		if (old_size == 0)
+			return xfs_broot_realloc(ifp, new_size);
+
+		/*
+		 * If there is already an existing if_broot, then we need to
+		 * realloc it and possibly move the node block pointers because
+		 * those are not butted up against the btree block header.
+		 */
+		old_numrecs = xfs_rtrmapbt_maxrecs(mp, old_size, level == 0);
+		broot = xfs_broot_realloc(ifp, new_size);
+		if (level > 0)
+			xfs_rtrmapbt_move_ptrs(mp, broot, old_size, new_size,
+					old_numrecs);
+		goto out_broot;
+	}
+
+	/*
+	 * We're reducing numrecs.  If we're going all the way to zero, just
+	 * free the block.
+	 */
+	ASSERT(ifp->if_broot != NULL && old_size > 0);
+	if (new_size == 0)
+		return xfs_broot_realloc(ifp, 0);
+
+	/*
+	 * Shrink the btree root by possibly moving the rtrmapbt pointers,
+	 * since they are not butted up against the btree block header.  Then
+	 * reallocate broot.
+	 */
+	if (level > 0)
+		xfs_rtrmapbt_move_ptrs(mp, ifp->if_broot, old_size, new_size,
+				new_numrecs);
+	broot = xfs_broot_realloc(ifp, new_size);
+
+out_broot:
+	ASSERT(xfs_rtrmap_droot_space(broot) <=
+	       xfs_inode_fork_size(cur->bc_ino.ip, cur->bc_ino.whichfork));
+	return broot;
+}
+
 const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.name			= "rtrmap",
 	.type			= XFS_BTREE_TYPE_INODE,
@@ -386,6 +500,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.free_block		= xfs_btree_free_metafile_block,
 	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrmapbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
@@ -396,6 +511,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+	.broot_realloc		= xfs_rtrmapbt_broot_realloc,
 };
 
 /* Allocate a new rt rmap btree cursor. */
@@ -579,3 +695,138 @@ xfs_rtrmapbt_calc_reserves(
 	return max_t(xfs_filblks_t, blocks / 100,
 			xfs_rtrmapbt_max_size(mp, blocks));
 }
+
+/* Convert on-disk form of btree root to in-memory form. */
+STATIC void
+xfs_rtrmapbt_from_disk(
+	struct xfs_inode	*ip,
+	struct xfs_rtrmap_root	*dblock,
+	unsigned int		dblocklen,
+	struct xfs_btree_block	*rblock)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rmap_rec	*frp;
+	struct xfs_rmap_rec	*trp;
+	unsigned int		rblocklen = xfs_rtrmap_broot_space(mp, dblock);
+	unsigned int		numrecs;
+	unsigned int		maxrecs;
+
+	xfs_btree_init_block(mp, rblock, &xfs_rtrmapbt_ops, 0, 0, ip->i_ino);
+
+	rblock->bb_level = dblock->bb_level;
+	rblock->bb_numrecs = dblock->bb_numrecs;
+	numrecs = be16_to_cpu(dblock->bb_numrecs);
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrmapbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrmap_droot_key_addr(dblock, 1);
+		tkp = xfs_rtrmap_key_addr(rblock, 1);
+		fpp = xfs_rtrmap_droot_ptr_addr(dblock, 1, maxrecs);
+		tpp = xfs_rtrmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrmap_droot_rec_addr(dblock, 1);
+		trp = xfs_rtrmap_rec_addr(rblock, 1);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Load a realtime reverse mapping btree root in from disk. */
+int
+xfs_iformat_rtrmap(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rtrmap_root	*dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	struct xfs_btree_block	*broot;
+	unsigned int		numrecs;
+	unsigned int		level;
+	int			dsize;
+
+	/*
+	 * growfs must create the rtrmap inodes before adding a realtime volume
+	 * to the filesystem, so we cannot use the rtrmapbt predicate here.
+	 */
+	if (!xfs_has_rmapbt(ip->i_mount))
+		return -EFSCORRUPTED;
+
+	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
+	numrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > mp->m_rtrmap_maxlevels ||
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+		return -EFSCORRUPTED;
+
+	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
+			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
+	if (broot)
+		xfs_rtrmapbt_from_disk(ip, dfp, dsize, broot);
+	return 0;
+}
+
+/* Convert in-memory form of btree root to on-disk form. */
+void
+xfs_rtrmapbt_to_disk(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*rblock,
+	unsigned int		rblocklen,
+	struct xfs_rtrmap_root	*dblock,
+	unsigned int		dblocklen)
+{
+	struct xfs_rmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rmap_rec	*frp;
+	struct xfs_rmap_rec	*trp;
+	unsigned int		numrecs;
+	unsigned int		maxrecs;
+
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_RTRMAP_CRC_MAGIC));
+	ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
+	ASSERT(rblock->bb_u.l.bb_blkno == cpu_to_be64(XFS_BUF_DADDR_NULL));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
+
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+	numrecs = be16_to_cpu(rblock->bb_numrecs);
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrmapbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrmap_key_addr(rblock, 1);
+		tkp = xfs_rtrmap_droot_key_addr(dblock, 1);
+		fpp = xfs_rtrmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		tpp = xfs_rtrmap_droot_ptr_addr(dblock, 1, maxrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrmap_rec_addr(rblock, 1);
+		trp = xfs_rtrmap_droot_rec_addr(dblock, 1);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Flush a realtime reverse mapping btree root out to disk. */
+void
+xfs_iflush_rtrmap(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_rtrmap_root	*dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+
+	ASSERT(ifp->if_broot != NULL);
+	ASSERT(ifp->if_broot_bytes > 0);
+	ASSERT(xfs_rtrmap_droot_space(ifp->if_broot) <=
+			xfs_inode_fork_size(ip, XFS_DATA_FORK));
+	xfs_rtrmapbt_to_disk(ip->i_mount, ifp->if_broot, ifp->if_broot_bytes,
+			dfp, XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
+}
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index eaa2942297e20c..e97695066920ee 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -25,6 +25,7 @@ void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 unsigned int xfs_rtrmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
 		bool leaf);
 void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rtrmapbt_droot_maxrecs(unsigned int blocklen, bool leaf);
 
 /*
  * Addresses of records, keys, and pointers within an incore rtrmapbt block.
@@ -81,4 +82,115 @@ void xfs_rtrmapbt_destroy_cur_cache(void);
 
 xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
 
+/* Addresses of key, pointers, and records within an ondisk rtrmapbt block. */
+
+static inline struct xfs_rmap_rec *
+xfs_rtrmap_droot_rec_addr(
+	struct xfs_rtrmap_root	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_rec *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_rmap_rec));
+}
+
+static inline struct xfs_rmap_key *
+xfs_rtrmap_droot_key_addr(
+	struct xfs_rtrmap_root	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_key *)
+		((char *)(block + 1) +
+		 (index - 1) * 2 * sizeof(struct xfs_rmap_key));
+}
+
+static inline xfs_rtrmap_ptr_t *
+xfs_rtrmap_droot_ptr_addr(
+	struct xfs_rtrmap_root	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_rtrmap_ptr_t *)
+		((char *)(block + 1) +
+		 maxrecs * 2 * sizeof(struct xfs_rmap_key) +
+		 (index - 1) * sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Address of pointers within the incore btree root.
+ *
+ * These are to be used when we know the size of the block and
+ * we don't have a cursor.
+ */
+static inline xfs_rtrmap_ptr_t *
+xfs_rtrmap_broot_ptr_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*bb,
+	unsigned int		index,
+	unsigned int		block_size)
+{
+	return xfs_rtrmap_ptr_addr(bb, index,
+			xfs_rtrmapbt_maxrecs(mp, block_size, false));
+}
+
+/*
+ * Compute the space required for the incore btree root containing the given
+ * number of records.
+ */
+static inline size_t
+xfs_rtrmap_broot_space_calc(
+	struct xfs_mount	*mp,
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = XFS_RTRMAP_BLOCK_LEN;
+
+	if (level > 0)
+		return sz + nrecs * (2 * sizeof(struct xfs_rmap_key) +
+					 sizeof(xfs_rtrmap_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_rmap_rec);
+}
+
+/*
+ * Compute the space required for the incore btree root given the ondisk
+ * btree root block.
+ */
+static inline size_t
+xfs_rtrmap_broot_space(struct xfs_mount *mp, struct xfs_rtrmap_root *bb)
+{
+	return xfs_rtrmap_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+/* Compute the space required for the ondisk root block. */
+static inline size_t
+xfs_rtrmap_droot_space_calc(
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = sizeof(struct xfs_rtrmap_root);
+
+	if (level > 0)
+		return sz + nrecs * (2 * sizeof(struct xfs_rmap_key) +
+					 sizeof(xfs_rtrmap_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_rmap_rec);
+}
+
+/*
+ * Compute the space required for the ondisk root block given an incore root
+ * block.
+ */
+static inline size_t
+xfs_rtrmap_droot_space(struct xfs_btree_block *bb)
+{
+	return xfs_rtrmap_droot_space_calc(be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+int xfs_iformat_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
+void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
+		unsigned int rblocklen, struct xfs_rtrmap_root *dblock,
+		unsigned int dblocklen);
+void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */

