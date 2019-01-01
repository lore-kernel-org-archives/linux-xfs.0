Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012P0CA024504
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:00 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp7da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012OsiZ001244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:55 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012OsJe028345
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:54 GMT
Subject: [PATCH 05/20] xfs: define the on-disk realtime rmap btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:24:53 -0800
Message-ID: <154630949349.8108.12482244592276847489.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Start filling out the rtrmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for connecting the
btree operations implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_btree.c        |    1 
 fs/xfs/libxfs/xfs_btree.h        |    3 +
 fs/xfs/libxfs/xfs_format.h       |   48 ++++++++++
 fs/xfs/libxfs/xfs_rmap.c         |   23 ++++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  184 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   48 ++++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 +
 fs/xfs/libxfs/xfs_shared.h       |    1 
 fs/xfs/xfs_mount.c               |    2 
 fs/xfs/xfs_mount.h               |    3 +
 fs/xfs/xfs_ondisk.h              |    2 
 12 files changed, 317 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 57651a47b5e9..b0176dd2bd6b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -54,6 +54,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_rtrmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index aefc375ff3b8..1fdfd6d5b957 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1279,6 +1279,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_RMAP:
+	case XFS_BTNUM_RTRMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_REFC:
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 23806757dba2..96b0073abfa2 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -37,6 +37,8 @@ union xfs_btree_key {
 	struct xfs_rmap_key		rmap;
 	struct xfs_rmap_key		__rmap_bigkey[2];
 	struct xfs_refcount_key		refc;
+	struct xfs_rtrmap_key		rtrmap;
+	struct xfs_rtrmap_key		__rtrmap_bigkey[2];
 };
 
 union xfs_btree_rec {
@@ -46,6 +48,7 @@ union xfs_btree_rec {
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
 	struct xfs_refcount_rec		refc;
+	struct xfs_rtrmap_rec		rtrmap;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d07783140f8c..1e6b1441fe5b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1489,6 +1489,54 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/*
+ * Data record structure
+ */
+struct xfs_rtrmap_rec {
+	__be64		rm_startblock;	/* extent start block */
+	__be64		rm_blockcount;	/* extent length */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+};
+
+/* rm_offset has the same values as the regular rmapbt. */
+#define XFS_RTRMAP_OFF_ATTR_FORK	XFS_RMAP_OFF_ATTR_FORK
+#define XFS_RTRMAP_OFF_BMBT_BLOCK	XFS_RMAP_OFF_BMBT_BLOCK
+#define XFS_RTRMAP_OFF_UNWRITTEN	XFS_RMAP_OFF_UNWRITTEN
+
+#define XFS_RTRMAP_LEN_MAX		((uint64_t)~0U)
+#define XFS_RTRMAP_OFF_FLAGS		XFS_RMAP_OFF_FLAGS
+#define XFS_RTRMAP_OFF_MASK		XFS_RMAP_OFF_MASK
+
+#define XFS_RTRMAP_OFF			XFS_RMAP_OFF
+
+#define XFS_RTRMAP_IS_BMBT_BLOCK(off)	XFS_RMAP_IS_BMBT_BLOCK
+#define XFS_RTRMAP_IS_ATTR_FORK(off)	XFS_RMAP_IS_ATTR_FORK
+#define XFS_RTRMAP_IS_UNWRITTEN(len)	XFS_RMAP_IS_UNWRITTEN
+
+#define RTRMAPBT_STARTBLOCK_BITLEN	64
+#define RTRMAPBT_BLOCKCOUNT_BITLEN	64
+#define RTRMAPBT_OWNER_BITLEN		RMAPBT_OWNER_BITLEN
+#define RTRMAPBT_ATTRFLAG_BITLEN	RMAPBT_ATTRFLAG_BITLEN
+#define RTRMAPBT_BMBTFLAG_BITLEN	RMAPBT_BMBTFLAG_BITLEN
+#define RTRMAPBT_EXNTFLAG_BITLEN	RMAPBT_EXNTFLAG_BITLEN
+#define RTRMAPBT_UNUSED_OFFSET_BITLEN	RMAPBT_UNUSED_OFFSET_BITLEN
+#define RTRMAPBT_OFFSET_BITLEN		RMAPBT_OFFSET_BITLEN
+
+/*
+ * Key structure
+ *
+ * We don't use the length for lookups
+ */
+struct xfs_rtrmap_key {
+	__be64		rm_startblock;	/* extent start block */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+} __packed;
+
+/* btree pointer type */
+typedef __be64 xfs_rtrmap_ptr_t;
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 4d37fd8ec5d5..2f0b79aa89c5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -193,23 +193,36 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_private.a.agno;
+	xfs_agnumber_t		agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
-	if (cur->bc_btnum != XFS_BTNUM_RMAP)
-		goto out_bad_rec;
-
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
 		return error;
 
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		agno = -1;
+	else
+		agno = cur->bc_private.a.agno;
+
 	if (xfs_rmap_btrec_to_irec(rec, irec))
 		goto out_bad_rec;
 
 	if (irec->rm_blockcount == 0)
 		goto out_bad_rec;
-	if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP) {
+		if (!xfs_verify_rtbno(mp, irec->rm_startblock))
+			goto out_bad_rec;
+		if (irec->rm_startblock >
+				irec->rm_startblock + irec->rm_blockcount)
+			goto out_bad_rec;
+		if (!xfs_verify_rtbno(mp,
+				irec->rm_startblock + irec->rm_blockcount - 1))
+			goto out_bad_rec;
+		if (XFS_RMAP_NON_INODE_OWNER(irec->rm_owner))
+			goto out_bad_rec;
+	} else if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
 		if (irec->rm_owner != XFS_RMAP_OWN_FS)
 			goto out_bad_rec;
 		if (irec->rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
new file mode 100644
index 000000000000..62ff99278b3d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_ag_resv.h"
+
+/*
+ * Realtime Reverse map btree.
+ *
+ * This is a per-ag tree used to track the owner(s) of a given extent
+ * in the realtime device.  See the comments in xfs_rmap_btree.c for
+ * more information.
+ *
+ * This tree is basically the same as the regular rmap btree except that
+ * it doesn't live in free space, and the startblock and blockcount
+ * fields have been widened to 64 bits.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_rtrmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.b.ip);
+
+	/* Copy the flags values since init cursor doesn't get them. */
+	new->bc_private.b.flags = cur->bc_private.b.flags;
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
+	if (block->bb_magic != cpu_to_be32(XFS_RTRMAP_CRC_MAGIC))
+		return __this_address;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
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
+	.verify_read		= xfs_rtrmapbt_read_verify,
+	.verify_write		= xfs_rtrmapbt_write_verify,
+	.verify_struct		= xfs_rtrmapbt_verify,
+};
+
+static const struct xfs_btree_ops xfs_rtrmapbt_ops = {
+	.rec_len		= sizeof(struct xfs_rtrmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rtrmap_key),
+
+	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+};
+
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *
+xfs_rtrmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_RTRMAP;
+	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE |
+			XFS_BTREE_CRC_BLOCKS | XFS_BTREE_IROOT_RECORDS |
+			XFS_BTREE_OVERLAPPING;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ops = &xfs_rtrmapbt_ops;
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+
+	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, XFS_DATA_FORK);
+	cur->bc_private.b.ip = ip;
+	cur->bc_private.b.allocated = 0;
+	cur->bc_private.b.flags = 0;
+	cur->bc_private.b.whichfork = XFS_DATA_FORK;
+
+	return cur;
+}
+
+/*
+ * Calculate number of records in an rmap btree block.
+ */
+int
+xfs_rtrmapbt_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTRMAP_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rtrmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rtrmap_key) + sizeof(xfs_rtrmap_ptr_t));
+}
+
+/* Compute the maximum height of an rmap btree. */
+void
+xfs_rtrmapbt_compute_maxlevels(
+	struct xfs_mount		*mp)
+{
+	mp->m_rtrmap_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrmap_mnr,
+			mp->m_sb.sb_rblocks);
+	ASSERT(mp->m_rtrmap_maxlevels <= XFS_BTREE_MAXLEVELS);
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
new file mode 100644
index 000000000000..4b32823a2ec6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_RTRMAP_BTREE_H__
+#define	__XFS_RTRMAP_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+/* rmaps only exist on crc enabled filesystems */
+#define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_RTRMAP_REC_ADDR(block, index) \
+	((struct xfs_rtrmap_rec *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_HIGH_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_PTR_ADDR(block, index, maxrecs) \
+	((xfs_rtrmap_ptr_t *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
+
+struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_mount *mp,
+				struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_rtrmapbt_maxrecs(int blocklen, bool leaf);
+void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+
+#endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 86ba6a2cb3bb..2bbb36066af2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -867,6 +868,11 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_rtrmap_mxr[0] = xfs_rtrmapbt_maxrecs(sbp->sb_blocksize, true);
+	mp->m_rtrmap_mxr[1] = xfs_rtrmapbt_maxrecs(sbp->sb_blocksize, false);
+	mp->m_rtrmap_mnr[0] = mp->m_rtrmap_mxr[0] / 2;
+	mp->m_rtrmap_mnr[1] = mp->m_rtrmap_mxr[1] / 2;
+
 	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, true);
 	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 1c5debe748f0..f34e2740d9dd 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -27,6 +27,7 @@ extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 68b9ba7245e8..6ab64742eb63 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -35,6 +35,7 @@
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrmap_btree.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -777,6 +778,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_compute_maxlevels(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_set_maxicount(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2845a51f1a36..95ed6c7bc3be 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -120,11 +120,14 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rtrmap_mxr[2]; /* max rtrmap btree records */
+	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index d3e04d20d8d4..23c9b6f047c5 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -41,6 +41,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_key,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_rec,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
