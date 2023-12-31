Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB637C8C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBJUhgli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C1DC433C7;
	Sun, 31 Dec 2023 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059137;
	bh=thnFXH/rX+EeFWpI+ezkkLNU2BLAXjtQpPcWPNn8pac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kBJUhgliO+Q+5l4UBHLzCFLpOsbOnU2fAylnhpr/e3xnfbXF0I+EKdUMiHJfn/rqe
	 5VTw58qyyYWBNrMKhIv4QBOYD5PnMra0iQRZvZM+TZ0Sfr4ZxHMjJE/3UemkhAER13
	 PamcUE9M6ZF0HW34/ENYW89PmjsOK+Qft4Rm28VcVXzEbfXwp5GXU0PJGwx8FFyLXg
	 rSKhguRJYlliM+I0OIgwhUBHUqnrjaKi4KD9d4bSANXcH1mZRp80UXPHY+BYbwmTOY
	 FHUDZVUvIm5eCw5wsq9sDWRpi/uflsoqNpINwXfHC4qn3pUTQzcE8BPkbtTGWtNs8R
	 OECYYmjrh+K7Q==
Date: Sun, 31 Dec 2023 13:45:36 -0800
Subject: [PATCH 04/44] xfs: define the on-disk realtime refcount btree format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851646.1766284.16245401597535436245.stgit@frogsfrogsfrogs>
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

Start filling out the rtrefcount btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate refcount btree blocks. This prepares the way for connecting
the btree operations implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                      |    1 
 fs/xfs/libxfs/xfs_btree.c            |    5 +
 fs/xfs/libxfs/xfs_btree.h            |   11 +
 fs/xfs/libxfs/xfs_format.h           |    3 
 fs/xfs/libxfs/xfs_ondisk.h           |    1 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  312 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |   71 ++++++++
 fs/xfs/libxfs/xfs_sb.c               |    8 +
 fs/xfs/libxfs/xfs_shared.h           |    2 
 fs/xfs/xfs_mount.c                   |    7 +
 fs/xfs/xfs_mount.h                   |    9 +
 11 files changed, 425 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f9092ae77e684..783fc053d7be9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -48,6 +48,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
+				   xfs_rtrefcount_btree.o \
 				   xfs_rtrmap_btree.o \
 				   xfs_sb.o \
 				   xfs_swapext.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2a181cf30299f..be484f86da985 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -37,6 +37,7 @@
 #include "xfs_rmap.h"
 #include "xfs_quota.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Btree magic numbers.
@@ -5538,6 +5539,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_rtrmapbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrefcountbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5557,6 +5561,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 	xfs_rtrmapbt_destroy_cur_cache();
+	xfs_rtrefcountbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f58240adda6f4..64e37a0ffb78e 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -229,6 +229,11 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
+struct xbtree_refc {
+	unsigned int	nr_ops;		/* # record updates */
+	unsigned int	shape_changes;	/* # of extent splits */
+};
+
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
 	struct xfs_perag		*pag;
@@ -237,10 +242,7 @@ struct xfs_btree_cur_ag {
 		struct xbtree_afakeroot	*afake;	/* for staging cursor */
 	};
 	union {
-		struct {
-			unsigned int	nr_ops;	/* # record updates */
-			unsigned int	shape_changes;	/* # of extent splits */
-		} refc;
+		struct xbtree_refc	refc;
 		struct {
 			bool		active;	/* allocation cursor state */
 		} abt;
@@ -261,6 +263,7 @@ struct xfs_btree_cur_ino {
 
 /* For extent swap, ignore owner check in verifier */
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
+	struct xbtree_refc		refc;
 };
 
 /* In-memory btree information */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 473bdc2a1ad10..c938b814c430d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1822,6 +1822,9 @@ typedef __be32 xfs_refcount_ptr_t;
  */
 #define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
+/* inode-rooted btree pointer type */
+typedef __be64 xfs_rtrefcount_ptr_t;
+
 /*
  * BMAP Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 102a3574fc682..242b683125662 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -79,6 +79,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
new file mode 100644
index 0000000000000..f99c7167183e5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
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
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+
+static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
+
+/*
+ * Realtime Reference Count btree.
+ *
+ * This is a btree used to track the owner(s) of a given extent in the realtime
+ * device.  See the comments in xfs_refcount_btree.c for more information.
+ *
+ * This tree is basically the same as the regular refcount btree except that
+ * it's rooted in an inode.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrefcountbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_rtrefcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_ino.rtg, cur->bc_ino.ip);
+
+	/* Copy the flags values since init cursor doesn't get them. */
+	new->bc_ino.flags = cur->bc_ino.flags;
+
+	return new;
+}
+
+static xfs_failaddr_t
+xfs_rtrefcountbt_verify(
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
+	if (!xfs_has_reflink(mp))
+		return __this_address;
+	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+	level = be16_to_cpu(block->bb_level);
+	if (level > mp->m_rtrefc_maxlevels)
+		return __this_address;
+
+	return xfs_btree_lblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
+}
+
+static void
+xfs_rtrefcountbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_lblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtrefcountbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_rtrefcountbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rtrefcountbt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_lblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
+	.name			= "xfs_rtrefcountbt",
+	.magic			= { 0, cpu_to_be32(XFS_RTREFC_CRC_MAGIC) },
+	.verify_read		= xfs_rtrefcountbt_read_verify,
+	.verify_write		= xfs_rtrefcountbt_write_verify,
+	.verify_struct		= xfs_rtrefcountbt_verify,
+};
+
+const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
+	.rec_len		= sizeof(struct xfs_refcount_rec),
+	.key_len		= sizeof(struct xfs_refcount_key),
+	.lru_refs		= XFS_REFC_BTREE_REF,
+	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE |
+				  XFS_BTREE_CRC_BLOCKS | XFS_BTREE_IROOT_RECORDS,
+
+	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
+	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
+};
+
+/* Initialize a new rt refcount btree cursor. */
+static struct xfs_btree_cur *
+xfs_rtrefcountbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RTREFC,
+			&xfs_rtrefcountbt_ops, mp->m_rtrefc_maxlevels,
+			xfs_rtrefcountbt_cur_cache);
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
+
+	cur->bc_ino.ip = ip;
+	cur->bc_ino.allocated = 0;
+	cur->bc_ino.flags = 0;
+	cur->bc_ino.refc.nr_ops = 0;
+	cur->bc_ino.refc.shape_changes = 0;
+
+	cur->bc_ino.rtg = xfs_rtgroup_hold(rtg);
+	return cur;
+}
+
+/* Allocate a new rt refcount btree cursor. */
+struct xfs_btree_cur *
+xfs_rtrefcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+	cur = xfs_rtrefcountbt_init_common(mp, tp, rtg, ip);
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	cur->bc_ino.whichfork = XFS_DATA_FORK;
+	return cur;
+}
+
+/* Create a new rt reverse mapping btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_rtrefcountbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_rtrefcountbt_init_common(mp, NULL, rtg, ip);
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
+xfs_rtrefcountbt_commit_staged_btree(
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
+	xfs_btree_commit_ifakeroot(cur, tp, XFS_DATA_FORK,
+			&xfs_rtrefcountbt_ops);
+}
+
+/* Calculate number of records in a realtime refcount btree block. */
+static inline unsigned int
+xfs_rtrefcountbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (sizeof(struct xfs_refcount_key) +
+			   sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Calculate number of records in an refcount btree block.
+ */
+unsigned int
+xfs_rtrefcountbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTREFCOUNT_BLOCK_LEN;
+	return xfs_rtrefcountbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for realtime refcount btrees. */
+unsigned int
+xfs_rtrefcountbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rtrefcountbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rtrefcountbt_block_maxrecs(blocklen, false) / 2;
+
+	/* We need at most one record for every block in an rt group. */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+}
+
+int __init
+xfs_rtrefcountbt_init_cur_cache(void)
+{
+	xfs_rtrefcountbt_cur_cache = kmem_cache_create("xfs_rtrefcountbt_cur",
+			xfs_btree_cur_sizeof(
+					xfs_rtrefcountbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_rtrefcountbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_rtrefcountbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rtrefcountbt_cur_cache);
+	xfs_rtrefcountbt_cur_cache = NULL;
+}
+
+/* Compute the maximum height of a realtime refcount btree. */
+void
+xfs_rtrefcountbt_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		d_maxlevels, r_maxlevels;
+
+	if (!xfs_has_rtreflink(mp)) {
+		mp->m_rtrefc_maxlevels = 0;
+		return;
+	}
+
+	/*
+	 * The realtime refcountbt lives on the data device, which means that
+	 * its maximum height is constrained by the size of the data device and
+	 * the height required to store one refcount record for each rtextent
+	 * in an rt group.
+	 */
+	d_maxlevels = xfs_btree_space_to_height(mp->m_rtrefc_mnr,
+				mp->m_sb.sb_dblocks);
+	r_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrefc_mnr,
+				xfs_rtb_to_rtx(mp, mp->m_sb.sb_rgblocks));
+
+	/* Add one level to handle the inode root level. */
+	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
new file mode 100644
index 0000000000000..6d23ab3a9ad41
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_RTREFCOUNT_BTREE_H__
+#define __XFS_RTREFCOUNT_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+struct xbtree_ifakeroot;
+struct xfs_rtgroup;
+
+/* refcounts only exist on crc enabled filesystems */
+#define XFS_RTREFCOUNT_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+struct xfs_btree_cur *xfs_rtrefcountbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		struct xfs_inode *ip);
+struct xfs_btree_cur *xfs_rtrefcountbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_rtrefcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp);
+unsigned int xfs_rtrefcountbt_maxrecs(struct xfs_mount *mp,
+		unsigned int blocklen, bool leaf);
+void xfs_rtrefcountbt_compute_maxlevels(struct xfs_mount *mp);
+
+/*
+ * Addresses of records, keys, and pointers within an incore rtrefcountbt block.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+static inline struct xfs_refcount_rec *
+xfs_rtrefcount_rec_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_refcount_rec *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_refcount_rec));
+}
+
+static inline struct xfs_refcount_key *
+xfs_rtrefcount_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_refcount_key *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_refcount_key));
+}
+
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_ptr_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_rtrefcount_ptr_t *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 maxrecs * sizeof(struct xfs_refcount_key) +
+		 (index - 1) * sizeof(xfs_rtrefcount_ptr_t));
+}
+
+unsigned int xfs_rtrefcountbt_maxlevels_ondisk(void);
+int __init xfs_rtrefcountbt_init_cur_cache(void);
+void xfs_rtrefcountbt_destroy_cur_cache(void);
+
+#endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a5ca8f4f8699f..b75a5bcbdf19e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -29,6 +29,7 @@
 #include "xfs_swapext.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1136,6 +1137,13 @@ xfs_sb_mount_common(
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
+	mp->m_rtrefc_mxr[0] = xfs_rtrefcountbt_maxrecs(mp, sbp->sb_blocksize,
+			true);
+	mp->m_rtrefc_mxr[1] = xfs_rtrefcountbt_maxrecs(mp, sbp->sb_blocksize,
+			false);
+	mp->m_rtrefc_mnr[0] = mp->m_rtrefc_mxr[0] / 2;
+	mp->m_rtrefc_mnr[1] = mp->m_rtrefc_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index adb742267c9d0..3a7f92a9ac761 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -42,6 +42,7 @@ extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
@@ -56,6 +57,7 @@ extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
+extern const struct xfs_btree_ops xfs_rtrefcountbt_ops;
 
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 30d2d0c5e5e53..b20e0e6410512 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -37,6 +37,7 @@
 #include "xfs_imeta.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -665,7 +666,10 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
+	unsigned int		levels;
+
+	levels = max(mp->m_rtrmap_maxlevels, mp->m_rtrefc_maxlevels);
+	mp->m_rtbtree_maxlevels = levels;
 }
 
 /*
@@ -739,6 +743,7 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 21c889a723820..1c99d0630364f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -138,11 +138,14 @@ typedef struct xfs_mount {
 	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
+	uint			m_rtrefc_mxr[2]; /* max rtrefc btree records */
+	uint			m_rtrefc_mnr[2]; /* min rtrefc btree records */
 	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
+	uint			m_rtrefc_maxlevels; /* max rtrefc btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
@@ -379,6 +382,12 @@ static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
 	       xfs_has_rmapbt(mp);
 }
 
+static inline bool xfs_has_rtreflink(struct xfs_mount *mp)
+{
+	return xfs_has_metadir(mp) && xfs_has_realtime(mp) &&
+	       xfs_has_reflink(mp);
+}
+
 /*
  * Mount features
  *

