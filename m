Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4BBC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiLaCpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiLaCpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C17B2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9815B81E5E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A570C433EF;
        Sat, 31 Dec 2022 02:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454705;
        bh=zQAMXPr+LfaTNo3yFxzNRyfn+hkhxCHxPKSu7UimOq0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WAthvWDi3YM8yNiwlOqQtBE98OMp2TyaZGOtYiTSgYnM7K+0eaQOIj2KWOoqa7JDM
         c0igVtNPI7gYj0yK9L0dVMDvNuZ+80QHymoqa7AacszIDycqv7zLScXLZ37I7HLXN1
         qp41ja/zLMmrRfvNck1U+EgKaSGW6NDqTrDcbYaZtBczUQnx1YyFsGqybAauZqxC/6
         TXcgv6w1MQ8H0nz7sY7M/yyZd6A8lu1y6nsHnMTkGk2p9MhlCxDgmdKXMjvbfx23SF
         yRREpExJgfO25/ObU37kw9WfdveDwC5It/A+Vp4Ix5dfqTYAUhzAxWLM3YuxDb62tg
         K7Fc2+T/5tgJw==
Subject: [PATCH 10/41] xfs: wire up a new inode fork type for the realtime
 rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879729.732820.17165461557693639730.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the pieces we need to embed the root of the realtime rmap
btree in an inode's data fork, complete with new fork type and
on-disk interpretation functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h       |    8 ++
 libxfs/xfs_inode_fork.c   |    8 +-
 libxfs/xfs_rtrmap_btree.c |  220 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |  112 +++++++++++++++++++++++
 4 files changed, 345 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index babe5d3fabb..a2b8d8ee8af 100644
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
index b441328cc9c..386f23b2954 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -25,6 +25,7 @@
 #include "xfs_errortag.h"
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -260,8 +261,7 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_RMAP:
 			if (!xfs_has_rtrmapbt(ip->i_mount))
 				return -EFSCORRUPTED;
-			ASSERT(0); /* to be implemented later */
-			return -EFSCORRUPTED;
+			return xfs_iformat_rtrmap(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -643,7 +643,9 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_RMAP:
-		ASSERT(0); /* to be implemented later */
+		ASSERT(whichfork == XFS_DATA_FORK);
+		if (iip->ili_fields & brootflag[whichfork])
+			xfs_iflush_rtrmap(ip, dip);
 		break;
 
 	default:
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index d45f711ce06..f92815b08a2 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -83,6 +83,39 @@ xfs_rtrmapbt_get_maxrecs(
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
@@ -375,6 +408,64 @@ xfs_rtrmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
+/* Move the rtrmap btree root from one incore buffer to another. */
+static void
+xfs_rtrmapbt_broot_move(
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
+	ASSERT(xfs_rtrmap_droot_space(src_broot) <=
+			xfs_inode_fork_size(ip, whichfork));
+
+	/*
+	 * We always have to move the pointers because they are not butted
+	 * against the btree block header.
+	 */
+	if (numrecs && level > 0) {
+		sptr = xfs_rtrmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
+		dptr = xfs_rtrmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
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
+	memcpy(dst_broot, src_broot, XFS_RTRMAP_BLOCK_LEN);
+
+	if (!numrecs)
+		return;
+
+	if (level == 0) {
+		sptr = xfs_rtrmap_rec_addr(src_broot, 1);
+		dptr = xfs_rtrmap_rec_addr(dst_broot, 1);
+		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_rmap_rec));
+	} else {
+		sptr = xfs_rtrmap_key_addr(src_broot, 1);
+		dptr = xfs_rtrmap_key_addr(dst_broot, 1);
+		memcpy(dptr, sptr, numrecs * 2 * sizeof(struct xfs_rmap_key));
+	}
+}
+
+static const struct xfs_ifork_broot_ops xfs_rtrmapbt_iroot_ops = {
+	.maxrecs		= xfs_rtrmapbt_maxrecs,
+	.size			= xfs_rtrmap_broot_space_calc,
+	.move			= xfs_rtrmapbt_broot_move,
+};
+
 const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
@@ -387,6 +478,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.free_block		= xfs_btree_free_imeta_block,
 	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrmapbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
@@ -397,6 +489,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
+	.iroot_ops		= &xfs_rtrmapbt_iroot_ops,
 };
 
 /* Initialize a new rt rmap btree cursor. */
@@ -645,3 +738,130 @@ xfs_rtrmapbt_calc_reserves(
 	return max_t(xfs_filblks_t, mp->m_sb.sb_rgblocks >> 6,
 			xfs_rtrmapbt_max_size(mp, mp->m_sb.sb_rgblocks));
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
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_rtrmap_root	*dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	unsigned int		numrecs;
+	unsigned int		level;
+	int			dsize;
+
+	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
+	numrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > mp->m_rtrmap_maxlevels ||
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+		return -EFSCORRUPTED;
+
+	xfs_iroot_alloc(ip, XFS_DATA_FORK,
+			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
+	xfs_rtrmapbt_from_disk(ip, dfp, dsize, ifp->if_broot);
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
index 63e667d0d76..6917a31bfe0 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -27,6 +27,7 @@ void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 unsigned int xfs_rtrmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
 		bool leaf);
 void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rtrmapbt_droot_maxrecs(unsigned int blocklen, bool leaf);
 
 /*
  * Addresses of records, keys, and pointers within an incore rtrmapbt block.
@@ -86,4 +87,115 @@ int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 
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
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

