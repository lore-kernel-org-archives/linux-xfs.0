Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926AEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiLaBtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B4E1DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:49:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9816B81DFA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89069C433EF;
        Sat, 31 Dec 2022 01:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451344;
        bh=qDzu2D3G0UhDHebx5bUQDX26Rso8PMOGxd5iCK8rqM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F87KdHffeejTzgXnbBePGbZXnLPL5A5eKPYORVVpseClfYk7K2La3qunDnNkX8Ne8
         P0+TA3k6HVsRENo7CnYEIblP5XaDv0QHiaUM3kaQgXsDRq67Qk6kxiP1kcOEGODG+P
         EBewtayUVZK5pgi7VZVcVxm+o2QiQE7O3+zCY5r0ZC41dulQ4A0t/zhqkRnmWd7TbE
         M2I4dgfxvRrqb1Gx9pnlLuxIrgsBTMBDIy9bKiySCZSAKYPE7gzljmi91LGSJffF3h
         5JIBliSmplmKuMfvLQrNMct5xkK0+gvawqzJFsY9GPHwGU31CAv3Qr2Kn0BtxnAayQ
         BwzwAeRI4/w9g==
Subject: [PATCH 04/42] xfs: define the on-disk realtime refcount btree format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870954.717073.1737780719903173961.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Start filling out the rtrefcount btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate refcount btree blocks. This prepares the way for connecting
the btree operations implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                      |    1 
 fs/xfs/libxfs/xfs_btree.c            |    6 +
 fs/xfs/libxfs/xfs_btree.h            |   11 +
 fs/xfs/libxfs/xfs_format.h           |    3 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  311 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |   71 ++++++++
 fs/xfs/libxfs/xfs_sb.c               |    8 +
 fs/xfs/libxfs/xfs_shared.h           |    2 
 fs/xfs/xfs_mount.c                   |    7 +
 fs/xfs/xfs_mount.h                   |    9 +
 fs/xfs/xfs_ondisk.h                  |    1 
 11 files changed, 425 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 17c65dce6d26..9cc30333c089 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -47,6 +47,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
+				   xfs_rtrefcount_btree.o \
 				   xfs_rtrmap_btree.o \
 				   xfs_sb.o \
 				   xfs_swapext.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 377dc9b0a6e6..a789fb75e77d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -37,6 +37,7 @@
 #include "xfs_rmap.h"
 #include "xfs_quota.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Btree magic numbers.
@@ -1388,6 +1389,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_REFC:
+	case XFS_BTNUM_RTREFC:
 		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
 		break;
 	case XFS_BTNUM_RCBAG:
@@ -5548,6 +5550,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_rtrmapbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrefcountbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5567,6 +5572,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 	xfs_rtrmapbt_destroy_cur_cache();
+	xfs_rtrefcountbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ce5ef798c3bc..97127030aea6 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -226,6 +226,11 @@ union xfs_btree_irec {
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
@@ -234,10 +239,7 @@ struct xfs_btree_cur_ag {
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
@@ -258,6 +260,7 @@ struct xfs_btree_cur_ino {
 
 /* For extent swap, ignore owner check in verifier */
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
+	struct xbtree_refc		refc;
 };
 
 /* In-memory btree information */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c49a946e79f3..d2270f95bfbc 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1803,6 +1803,9 @@ typedef __be32 xfs_refcount_ptr_t;
  */
 #define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
+/* inode-rooted btree pointer type */
+typedef __be64 xfs_rtrefcount_ptr_t;
+
 /*
  * BMAP Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
new file mode 100644
index 000000000000..dd8e628b068b
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -0,0 +1,311 @@
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
+	cur->bc_ino.rtg = xfs_rtgroup_bump(rtg);
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
+				xfs_rtb_to_rtxt(mp, mp->m_sb.sb_rgblocks));
+
+	/* Add one level to handle the inode root level. */
+	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
new file mode 100644
index 000000000000..d10ebdcf7727
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
index 570919c223c9..c002cf661912 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -28,6 +28,7 @@
 #include "xfs_swapext.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1075,6 +1076,13 @@ xfs_sb_mount_common(
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
index 31c577a94295..a1bfc98c47a3 100644
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
index 2e64f18deabf..f3ef385f9aaf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -37,6 +37,7 @@
 #include "xfs_imeta.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -655,7 +656,10 @@ static inline void
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
@@ -729,6 +733,7 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b1ffab4cb9cd..487567d1839b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -136,11 +136,14 @@ typedef struct xfs_mount {
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
@@ -369,6 +372,12 @@ static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
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
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index f24a08dd63e9..94bbb6351d3d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -79,6 +79,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to

