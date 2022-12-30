Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5761FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiLaBh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaBh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:37:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756413DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D7F9B81DD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A282FC433D2;
        Sat, 31 Dec 2022 01:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450672;
        bh=FQLB+4WLIzAf9TbYF3lv/fv6x0fPBcbGC7NUCfcje34=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=irr63fhG90k5QozlRA7IVnv1V10ODlHqTql0GL/Wdc0exfP7ST71A7q8Rb0e93+YX
         lJ/VRbqztSjMWpWtzi8oRuXaFoSd2enitA6h7heJokHooHHrrzqapb9wOshe6YvBCK
         BbUW975uejEPryYoZGT5BKEQENNINWR76abr7xsy9GEkhgKHQdJpcDnTTxPITgyJfi
         q02AWRNUcptkE5LhY+4HSy27sSUUEpKGMNKlEcoo1xfWdTho2jG1Kqh59WtB98D21b
         7unYVt5a15mSNAdlzSR3rj8A6V6TGmGwxv5VKE72H2rirTjEnrc5XWNJZ2NS1GNDpK
         SuJcy2z6ubnww==
Subject: [PATCH 04/38] xfs: define the on-disk realtime rmap btree format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869657.715303.4219727068304981370.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Start filling out the rtrmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for connecting the
btree operations implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_btree.c        |    6 +
 fs/xfs/libxfs/xfs_format.h       |    3 
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  306 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   83 ++++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 +
 fs/xfs/libxfs/xfs_shared.h       |    2 
 fs/xfs/xfs_mount.c               |    5 -
 fs/xfs/xfs_mount.h               |    9 +
 fs/xfs/xfs_ondisk.h              |    1 
 10 files changed, 420 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4bf6d663272b..84934538bf52 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -47,6 +47,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
+				   xfs_rtrmap_btree.o \
 				   xfs_sb.o \
 				   xfs_swapext.o \
 				   xfs_symlink_remote.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c02748e16075..4f1f03b207d3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -32,6 +32,7 @@
 #include "scrub/xfbtree.h"
 #include "xfs_btree_mem.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Btree magic numbers.
@@ -1377,6 +1378,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_RMAP:
+	case XFS_BTNUM_RTRMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_REFC:
@@ -5537,6 +5539,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_refcountbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrmapbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5555,6 +5560,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_bmbt_destroy_cur_cache();
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
+	xfs_rtrmapbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b2d4ef28a480..fb727e1e4072 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1734,6 +1734,9 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/* inode-based btree pointer type */
+typedef __be64 xfs_rtrmap_ptr_t;
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
new file mode 100644
index 000000000000..7f6ba2efdaf2
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -0,0 +1,306 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
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
+	cur->bc_ino.rtg = xfs_rtgroup_bump(rtg);
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
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
new file mode 100644
index 000000000000..7380c04e7705
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 54f93e1b0f00..570919c223c9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_swapext.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1064,6 +1065,11 @@ xfs_sb_mount_common(
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
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 62839fc87b50..31c577a94295 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d94d44f40be4..1d2403b93f58 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -36,6 +36,7 @@
 #include "xfs_ag.h"
 #include "xfs_imeta.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -654,8 +655,7 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	/* This will be filled in later. */
-	mp->m_rtbtree_maxlevels = 0;
+	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
 }
 
 /*
@@ -727,6 +727,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_mount_setup_inode_geom(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 55e6e30f9045..a565b1b1372a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -131,11 +131,14 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rtrmap_mxr[2]; /* max rtrmap btree records */
+	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
@@ -359,6 +362,12 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(rtgroups, RTGROUPS)
 
+static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
+{
+	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp) &&
+	       xfs_has_rmapbt(mp);
+}
+
 /*
  * Mount features
  *
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 17e541d35194..35d0695fbf57 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -77,6 +77,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_ondisk,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_ondisk,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to

