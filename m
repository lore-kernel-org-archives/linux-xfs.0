Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7838391
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8Ht/Es/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F80CC433C8;
	Mon,  1 Jan 2024 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067878;
	bh=hx8zB/4FBIfavZ2WTLKbvz8MKn1eMGSqqBhLTqN0+U4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m8Ht/Es/EftBnzDGjls7AFbpX/fW/O8872oz4wZ9khubVnTgAgIbkRFGXem3kmb8Y
	 cLxODWuzZiB4oJFV/UG0n6RT8dKZiB8STHOcVz6tLNvhBnViNth0zkSlD4xZU7lDLV
	 CNRxoJVtoqUpnyVdD4D/3pi+J3MJ7LL4o93JHn0XfYB+Bk2PRPz7LRhwAPsFoV/CD3
	 vdKYj25UX32clEDUkUWpgJR3Oa9w34BjRZfe4hCZokfR3M9F/7Gh9NLRg3tzho8aUl
	 xseoWImvxOWr6kp6xWvW+fflA264RzaSce9IX0JIh+791JsAJUiOCuxQY7gB8PsBUD
	 1EZgnuq/EgRJg==
Date: Sun, 31 Dec 2023 16:11:17 +9900
Subject: [PATCH 03/47] xfs: define the on-disk realtime rmap btree format
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015352.1815505.7863078156157020200.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Start filling out the rtrmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for connecting the
btree operations implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h          |    1 
 include/xfs_mount.h       |    9 +
 libxfs/Makefile           |    2 
 libxfs/init.c             |    5 -
 libxfs/xfs_btree.c        |    5 +
 libxfs/xfs_format.h       |    3 
 libxfs/xfs_ondisk.h       |    1 
 libxfs/xfs_rtrmap_btree.c |  305 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |   83 ++++++++++++
 libxfs/xfs_sb.c           |    6 +
 libxfs/xfs_shared.h       |    2 
 11 files changed, 420 insertions(+), 2 deletions(-)
 create mode 100644 libxfs/xfs_rtrmap_btree.c
 create mode 100644 libxfs/xfs_rtrmap_btree.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 8d2e321b914..3ab93158cf7 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -93,6 +93,7 @@ struct iomap;
 #include "imeta_utils.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 1284e848835..4e4da5bc4fa 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -92,11 +92,14 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* XFS_BMAP_BLOCK_DMINRECS */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rtrmap_mxr[2]; /* max rtrmap btree records */
+	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2];  /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refc btree levels */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
@@ -233,6 +236,12 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
+static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
+{
+	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp) &&
+	       xfs_has_rmapbt(mp);
+}
+
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a37a5263199..0b3e8c896bd 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -63,6 +63,7 @@ HFILES = \
 	xfs_rmap_btree.h \
 	xfs_rtbitmap.h \
 	xfs_rtgroup.h \
+	xfs_rtrmap_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_swapext.h \
@@ -121,6 +122,7 @@ CFILES = cache.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
 	xfs_rtgroup.c \
+	xfs_rtrmap_btree.c \
 	xfs_sb.c \
 	xfs_swapext.c \
 	xfs_symlink_remote.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index 2663485a80d..9a4dfe02945 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -21,6 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_imeta.h"
 #include "libfrog/platform.h"
 #include "xfile.h"
 
@@ -656,8 +657,7 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	/* This will be filled in later. */
-	mp->m_rtbtree_maxlevels = 0;
+	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
 }
 
 /* Compute maximum possible height of all btrees. */
@@ -673,6 +673,7 @@ libxfs_compute_all_maxlevels(
 	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e0276ad655a..ea0d5d71d03 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -29,6 +29,7 @@
 #include "xfbtree.h"
 #include "xfs_btree_mem.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Btree magic numbers.
@@ -5525,6 +5526,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_refcountbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrmapbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5543,6 +5547,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_bmbt_destroy_cur_cache();
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
+	xfs_rtrmapbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b47d4f16143..5317c6438f0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1753,6 +1753,9 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/* inode-based btree pointer type */
+typedef __be64 xfs_rtrmap_ptr_t;
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 70b96efa269..897a1b72f8d 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -77,6 +77,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
new file mode 100644
index 00000000000..1b6375af818
--- /dev/null
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_rtgroup.h"
+
+static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
+
+/*
+ * Realtime Reverse Map btree.
+ *
+ * This is a btree used to track the owner(s) of a given extent in the realtime
+ * device.  See the comments in xfs_rmap_btree.c for more information.
+ *
+ * This tree is basically the same as the regular rmap btree except that it
+ * is rooted in an inode and does not live in free space.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_rtrmapbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ino.rtg,
+			cur->bc_ino.ip);
+
+	/* Copy the flags values since init cursor doesn't get them. */
+	new->bc_ino.flags = cur->bc_ino.flags;
+
+	return new;
+}
+
+static xfs_failaddr_t
+xfs_rtrmapbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	int			level;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	if (!xfs_has_rmapbt(mp))
+		return __this_address;
+	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+	level = be16_to_cpu(block->bb_level);
+	if (level > mp->m_rtrmap_maxlevels)
+		return __this_address;
+
+	return xfs_btree_lblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
+}
+
+static void
+xfs_rtrmapbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_lblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtrmapbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_rtrmapbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rtrmapbt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_lblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
+	.name			= "xfs_rtrmapbt",
+	.magic			= { 0, cpu_to_be32(XFS_RTRMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rtrmapbt_read_verify,
+	.verify_write		= xfs_rtrmapbt_write_verify,
+	.verify_struct		= xfs_rtrmapbt_verify,
+};
+
+const struct xfs_btree_ops xfs_rtrmapbt_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE |
+				  XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_IROOT_RECORDS,
+
+	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+};
+
+/* Initialize a new rt rmap btree cursor. */
+static struct xfs_btree_cur *
+xfs_rtrmapbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RTRMAP,
+			&xfs_rtrmapbt_ops, mp->m_rtrmap_maxlevels,
+			xfs_rtrmapbt_cur_cache);
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+
+	cur->bc_ino.ip = ip;
+	cur->bc_ino.allocated = 0;
+	cur->bc_ino.flags = 0;
+
+	cur->bc_ino.rtg = xfs_rtgroup_hold(rtg);
+	return cur;
+}
+
+/* Allocate a new rt rmap btree cursor. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+	cur = xfs_rtrmapbt_init_common(mp, tp, rtg, ip);
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	cur->bc_ino.whichfork = XFS_DATA_FORK;
+	return cur;
+}
+
+/* Create a new rt reverse mapping btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_rtrmapbt_init_common(mp, NULL, rtg, ip);
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
+	cur->bc_ino.whichfork = -1;
+	xfs_btree_stage_ifakeroot(cur, ifake, NULL);
+	return cur;
+}
+
+/*
+ * Install a new rt reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rtrmapbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_ino.ifake;
+	struct xfs_ifork	*ifp;
+	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	/*
+	 * Free any resources hanging off the real fork, then shallow-copy the
+	 * staging fork's contents into the real fork to transfer everything
+	 * we just built.
+	 */
+	ifp = xfs_ifork_ptr(cur->bc_ino.ip, XFS_DATA_FORK);
+	xfs_idestroy_fork(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, tp, XFS_DATA_FORK, &xfs_rtrmapbt_ops);
+}
+
+/* Calculate number of records in a rt reverse mapping btree block. */
+static inline unsigned int
+xfs_rtrmapbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Calculate number of records in an rt reverse mapping btree block.
+ */
+unsigned int
+xfs_rtrmapbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTRMAP_BLOCK_LEN;
+	return xfs_rtrmapbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for realtime reverse mapping btrees. */
+unsigned int
+xfs_rtrmapbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rtrmapbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rtrmapbt_block_maxrecs(blocklen, false) / 2;
+
+	/* We need at most one record for every block in an rt group. */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+}
+
+int __init
+xfs_rtrmapbt_init_cur_cache(void)
+{
+	xfs_rtrmapbt_cur_cache = kmem_cache_create("xfs_rtrmapbt_cur",
+			xfs_btree_cur_sizeof(xfs_rtrmapbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_rtrmapbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_rtrmapbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rtrmapbt_cur_cache);
+	xfs_rtrmapbt_cur_cache = NULL;
+}
+
+/* Compute the maximum height of an rt reverse mapping btree. */
+void
+xfs_rtrmapbt_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		d_maxlevels, r_maxlevels;
+
+	if (!xfs_has_rtrmapbt(mp)) {
+		mp->m_rtrmap_maxlevels = 0;
+		return;
+	}
+
+	/*
+	 * The realtime rmapbt lives on the data device, which means that its
+	 * maximum height is constrained by the size of the data device and
+	 * the height required to store one rmap record for each block in an
+	 * rt group.
+	 */
+	d_maxlevels = xfs_btree_space_to_height(mp->m_rtrmap_mnr,
+				mp->m_sb.sb_dblocks);
+	r_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrmap_mnr,
+				mp->m_sb.sb_rgblocks);
+
+	/* Add one level to handle the inode root level. */
+	mp->m_rtrmap_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
+}
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
new file mode 100644
index 00000000000..0f732679719
--- /dev/null
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_RTRMAP_BTREE_H__
+#define	__XFS_RTRMAP_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+struct xbtree_ifakeroot;
+struct xfs_rtgroup;
+
+/* rmaps only exist on crc enabled filesystems */
+#define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		struct xfs_inode *ip);
+struct xfs_btree_cur *xfs_rtrmapbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp);
+unsigned int xfs_rtrmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
+void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+
+/*
+ * Addresses of records, keys, and pointers within an incore rtrmapbt block.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+static inline struct xfs_rmap_rec *
+xfs_rtrmap_rec_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_rec *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_rmap_rec));
+}
+
+static inline struct xfs_rmap_key *
+xfs_rtrmap_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_key *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 (index - 1) * 2 * sizeof(struct xfs_rmap_key));
+}
+
+static inline struct xfs_rmap_key *
+xfs_rtrmap_high_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_key *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 sizeof(struct xfs_rmap_key) +
+		 (index - 1) * 2 * sizeof(struct xfs_rmap_key));
+}
+
+static inline xfs_rtrmap_ptr_t *
+xfs_rtrmap_ptr_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_rtrmap_ptr_t *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 maxrecs * 2 * sizeof(struct xfs_rmap_key) +
+		 (index - 1) * sizeof(xfs_rtrmap_ptr_t));
+}
+
+unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
+
+int __init xfs_rtrmapbt_init_cur_cache(void);
+void xfs_rtrmapbt_destroy_cur_cache(void);
+
+#endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index aff2ab79f9b..891b71190d5 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -26,6 +26,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1123,6 +1124,11 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_rtrmap_mxr[0] = xfs_rtrmapbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_rtrmap_mxr[1] = xfs_rtrmapbt_maxrecs(mp, sbp->sb_blocksize, false);
+	mp->m_rtrmap_mnr[0] = mp->m_rtrmap_mxr[0] / 2;
+	mp->m_rtrmap_mnr[1] = mp->m_rtrmap_mxr[1] / 2;
+
 	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, true);
 	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 8ad4b67d6fe..adb742267c9 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -42,6 +42,7 @@ extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
@@ -54,6 +55,7 @@ extern const struct xfs_btree_ops xfs_finobt_ops;
 extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
+extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
 
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);

