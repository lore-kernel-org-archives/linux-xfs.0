Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736A8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbiLaC45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaC4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:56:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7B1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E8061CD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83BC433EF;
        Sat, 31 Dec 2022 02:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455405;
        bh=pw6LyTbwpGzoa3TOjLQx/uVWOUQkqKBWVY0ru9TrVQc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dtM2EJ3CzVvsE6RSROdEy5ps2lWjqEEXNn1wUi1P6vgQQDg441UbI/LGecQ2YUnXU
         MobMewr3pxdy3bjRfsH6Z8BKIeJzyAREXuEa64EK58GllXMXY3M26tU/98CPw+vTbg
         xkolPMHpKCiTo286Z8+riOnCb2o+xyaGiVxNCQgrJwP98s0rjfalnIE13kfQANskQP
         I49a3HLS/y1zmT9KFUdif5zEBL+W8o6KkLgyPnDMP/qNohrrn18Ol30ueUKs+auAkW
         8zJHIararmuWf5fT3OSy6fZHelOtXx/sNDwA5+rIkrpLajlqFBW4yShLoWrTV7kTPY
         Ge5FrQAM8caGQ==
Subject: [PATCH 10/41] xfs: wire up a new inode fork type for the realtime
 refcount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880902.734096.2518640586226896106.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the pieces we need to embed the root of the realtime refcount
btree in an inode's data fork, complete with new fork type and
on-disk interpretation functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h           |    8 +
 libxfs/xfs_inode_fork.c       |    8 +
 libxfs/xfs_rtrefcount_btree.c |  236 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |  112 +++++++++++++++++++
 4 files changed, 361 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 20af5b730d6..17be73c4522 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1805,6 +1805,14 @@ typedef __be32 xfs_refcount_ptr_t;
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
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index f7a168e0625..b019cbeb5fd 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -267,8 +268,7 @@ xfs_iformat_data_fork(
 		case XFS_DINODE_FMT_REFCOUNT:
 			if (!xfs_has_rtreflink(ip->i_mount))
 				return -EFSCORRUPTED;
-			ASSERT(0); /* to be implemented later */
-			return -EFSCORRUPTED;
+			return xfs_iformat_rtrefcount(ip, dip);
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
@@ -656,7 +656,9 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_REFCOUNT:
-		ASSERT(0); /* to be implemented later */
+		ASSERT(whichfork == XFS_DATA_FORK);
+		if (iip->ili_fields & brootflag[whichfork])
+			xfs_iflush_rtrefcount(ip, dip);
 		break;
 
 	default:
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index a5146550b20..2c9fbab5159 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -83,6 +83,41 @@ xfs_rtrefcountbt_get_maxrecs(
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
@@ -253,6 +288,68 @@ xfs_rtrefcountbt_keys_contiguous(
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
@@ -264,6 +361,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.free_block		= xfs_btree_free_imeta_block,
 	.get_minrecs		= xfs_rtrefcountbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrefcountbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrefcountbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrefcountbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
@@ -274,6 +372,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
+	.iroot_ops		= &xfs_rtrefcountbt_iroot_ops,
 };
 
 /* Initialize a new rt refcount btree cursor. */
@@ -527,3 +626,140 @@ xfs_rtrefcountbt_calc_reserves(
 	return xfs_rtrefcountbt_max_size(mp,
 			xfs_rtb_to_rtxt(mp, mp->m_sb.sb_rgblocks));
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
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index ffda0b063bc..d2fe2004568 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -27,6 +27,7 @@ void xfs_rtrefcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 unsigned int xfs_rtrefcountbt_maxrecs(struct xfs_mount *mp,
 		unsigned int blocklen, bool leaf);
 void xfs_rtrefcountbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rtrefcountbt_droot_maxrecs(unsigned int blocklen, bool leaf);
 
 /*
  * Addresses of records, keys, and pointers within an incore rtrefcountbt block.
@@ -74,4 +75,115 @@ int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 
 xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
 
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

