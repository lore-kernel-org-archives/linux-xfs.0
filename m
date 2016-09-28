Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16650 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbcI1Cye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:54:34 -0400
Subject: [PATCH 09/63] xfs: add refcount btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:54:27 -0700
Message-ID: <147503126699.30303.3194028804178091894.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Implement the generic btree operations required to manipulate refcount
btree blocks.  The implementation is similar to the bmapbt, though it
will only allocate and free blocks from the AG.

Since the refcount root and level fields are separate from the
existing roots and levels array, they need a separate logging flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: fix logging of AGF refcount btree fields]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
v2: Remove init_rec_from_key since we no longer need it, and add
tracepoints when refcount btree operations fail.
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_alloc.c          |    3 
 fs/xfs/libxfs/xfs_format.h         |   10 +-
 fs/xfs/libxfs/xfs_refcount.c       |  177 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h       |   30 +++++
 fs/xfs/libxfs/xfs_refcount_btree.c |  226 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.c                 |    1 
 7 files changed, 446 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_refcount.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8d749f2..98b2427 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -55,6 +55,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aa0e1ca..be7e3fc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2334,6 +2334,9 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_btreeblks),
 		offsetof(xfs_agf_t, agf_uuid),
 		offsetof(xfs_agf_t, agf_rmap_blocks),
+		offsetof(xfs_agf_t, agf_refcount_blocks),
+		offsetof(xfs_agf_t, agf_refcount_root),
+		offsetof(xfs_agf_t, agf_refcount_level),
 		/* needed so that we don't log the whole rest of the structure: */
 		offsetof(xfs_agf_t, agf_spare64),
 		sizeof(xfs_agf_t)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0c194fc..812d55e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -684,8 +684,11 @@ typedef struct xfs_agf {
 #define	XFS_AGF_BTREEBLKS	0x00000800
 #define	XFS_AGF_UUID		0x00001000
 #define	XFS_AGF_RMAP_BLOCKS	0x00002000
-#define	XFS_AGF_SPARE64		0x00004000
-#define	XFS_AGF_NUM_BITS	15
+#define	XFS_AGF_REFCOUNT_BLOCKS	0x00004000
+#define	XFS_AGF_REFCOUNT_ROOT	0x00008000
+#define	XFS_AGF_REFCOUNT_LEVEL	0x00010000
+#define	XFS_AGF_SPARE64		0x00020000
+#define	XFS_AGF_NUM_BITS	18
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
@@ -703,6 +706,9 @@ typedef struct xfs_agf {
 	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
 	{ XFS_AGF_UUID,		"UUID" }, \
 	{ XFS_AGF_RMAP_BLOCKS,	"RMAP_BLOCKS" }, \
+	{ XFS_AGF_REFCOUNT_BLOCKS,	"REFCOUNT_BLOCKS" }, \
+	{ XFS_AGF_REFCOUNT_ROOT,	"REFCOUNT_ROOT" }, \
+	{ XFS_AGF_REFCOUNT_LEVEL,	"REFCOUNT_LEVEL" }, \
 	{ XFS_AGF_SPARE64,	"SPARE64" }
 
 /* disk block (xfs_daddr_t) in the AG */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
new file mode 100644
index 0000000..de13406
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_refcount.h"
+
+/*
+ * Look up the first record less than or equal to [bno, len] in the btree
+ * given by cur.
+ */
+int
+xfs_refcount_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Look up the first record greater than or equal to [bno, len] in the btree
+ * given by cur.
+ */
+int
+xfs_refcount_lookup_ge(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_GE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int
+xfs_refcount_get_rec(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec,
+	int				*stat)
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+		irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+		irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+		trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno,
+				irec);
+	}
+	return error;
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, refcount].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcount_update(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec)
+{
+	union xfs_btree_rec	rec;
+	int			error;
+
+	trace_xfs_refcount_update(cur->bc_mp, cur->bc_private.a.agno, irec);
+	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
+	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
+	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
+	error = xfs_btree_update(cur, &rec);
+	if (error)
+		trace_xfs_refcount_update_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Insert the record referred to by cur to the value given
+ * by [bno, len, refcount].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcount_insert(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec,
+	int				*i)
+{
+	int				error;
+
+	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_private.a.agno, irec);
+	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
+	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
+	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
+	error = xfs_btree_insert(cur, i);
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+out_error:
+	if (error)
+		trace_xfs_refcount_insert_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Remove the record referred to by cur, then set the pointer to the spot
+ * where the record could be re-inserted, in case we want to increment or
+ * decrement the cursor.
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcount_delete(
+	struct xfs_btree_cur	*cur,
+	int			*i)
+{
+	struct xfs_refcount_irec	irec;
+	int			found_rec;
+	int			error;
+
+	error = xfs_refcount_get_rec(cur, &irec, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
+	error = xfs_btree_delete(cur, i);
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+	if (error)
+		goto out_error;
+	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
+out_error:
+	if (error)
+		trace_xfs_refcount_delete_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
new file mode 100644
index 0000000..4dc335a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_REFCOUNT_H__
+#define __XFS_REFCOUNT_H__
+
+extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
+
+#endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 359cf0c..c4550bd 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -34,6 +34,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
+#include "xfs_rmap.h"
 
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
@@ -44,6 +45,178 @@ xfs_refcountbt_dup_cursor(
 			cur->bc_private.a.dfops);
 }
 
+STATIC void
+xfs_refcountbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_refcount_root = ptr->s;
+	be32_add_cpu(&agf->agf_refcount_level, inc);
+	pag->pagf_refcount_level += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp,
+			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
+}
+
+STATIC int
+xfs_refcountbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_alloc_arg	args;		/* block allocation args */
+	int			error;		/* error return value */
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			xfs_refc_block(args.mp));
+	args.firstblock = args.fsbno;
+	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
+	args.minlen = args.maxlen = args.prod = 1;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out_error;
+	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_private.a.agno,
+			args.agbno, 1);
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.len == 1);
+
+	new->s = cpu_to_be32(args.agbno);
+	be32_add_cpu(&agf->agf_refcount_blocks, 1);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out_error:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_refcountbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
+
+	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
+	be32_add_cpu(&agf->agf_refcount_blocks, -1);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
+	xfs_bmap_add_free(mp, cur->bc_private.a.dfops, fsbno, 1,
+			&oinfo);
+
+	return 0;
+}
+
+STATIC int
+xfs_refcountbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mnr[level != 0];
+}
+
+STATIC int
+xfs_refcountbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mxr[level != 0];
+}
+
+STATIC void
+xfs_refcountbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->refc.rc_startblock = rec->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->refc.rc_startblock);
+	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
+	key->refc.rc_startblock = cpu_to_be32(x);
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
+	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
+	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
+}
+
+STATIC void
+xfs_refcountbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_refcount_root != 0);
+
+	ptr->s = agf->agf_refcount_root;
+}
+
+STATIC __int64_t
+xfs_refcountbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
+	struct xfs_refcount_key		*kp = &key->refc;
+
+	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
+}
+
+STATIC __int64_t
+xfs_refcountbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->refc.rc_startblock) -
+			  be32_to_cpu(k2->refc.rc_startblock);
+}
+
 STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
@@ -106,12 +279,65 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_refcountbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->refc.rc_startblock) <
+	       be32_to_cpu(k2->refc.rc_startblock);
+}
+
+STATIC int
+xfs_refcountbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	struct xfs_refcount_irec	a, b;
+
+	int ret = be32_to_cpu(r1->refc.rc_startblock) +
+		be32_to_cpu(r1->refc.rc_blockcount) <=
+		be32_to_cpu(r2->refc.rc_startblock);
+	if (!ret) {
+		a.rc_startblock = be32_to_cpu(r1->refc.rc_startblock);
+		a.rc_blockcount = be32_to_cpu(r1->refc.rc_blockcount);
+		a.rc_refcount = be32_to_cpu(r1->refc.rc_refcount);
+		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
+		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
+		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		a = a; b = b;
+		trace_xfs_refcount_rec_order_error(cur->bc_mp,
+				cur->bc_private.a.agno, &a, &b);
+	}
+
+	return ret;
+}
+#endif
+
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
+	.set_root		= xfs_refcountbt_set_root,
+	.alloc_block		= xfs_refcountbt_alloc_block,
+	.free_block		= xfs_refcountbt_free_block,
+	.get_minrecs		= xfs_refcountbt_get_minrecs,
+	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
+	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
+	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
+	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_refcountbt_keys_inorder,
+	.recs_inorder		= xfs_refcountbt_recs_inorder,
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c2fe6bf..4b4059b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -263,6 +263,7 @@ xfs_growfs_data_private(
 			agf->agf_refcount_root = cpu_to_be32(
 					xfs_refc_block(mp));
 			agf->agf_refcount_level = cpu_to_be32(1);
+			agf->agf_refcount_blocks = cpu_to_be32(1);
 		}
 
 		error = xfs_bwrite(bp);

