Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36A618094
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7F51304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:11 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RlVsOcNShCeTTask (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:09 -0800 (PST)
Subject: [PATCH 43/76] xfs: add refcount btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:01:05 -0800
Message-ID: <20151219090105.12713.78693.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Implement the generic btree operations required to manipulate refcount
btree blocks.  The implementation is similar to the bmapbt, though it
will only allocate and free blocks from the AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_refcount.c       |  169 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h       |   29 +++++
 fs/xfs/libxfs/xfs_refcount_btree.c |  203 ++++++++++++++++++++++++++++++++++++
 4 files changed, 402 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_refcount.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9bac577..7d84c62 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -53,6 +53,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_log_rlimit.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
new file mode 100644
index 0000000..b3f2c25
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
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
+/**
+ * xfs_refcountbt_lookup_le() -- Look up the first record less than or equal to
+ *				 [bno, len] in the btree given by cur.
+ * @cur: refcount btree cursor
+ * @bno: AG block number to look up
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int
+xfs_refcountbt_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcountbt_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/**
+ * xfs_refcountbt_lookup_ge() -- Look up the first record greater than or equal
+ *				 to [bno, len] in the btree given by cur.
+ * @cur: refcount btree cursor
+ * @bno: AG block number to look up
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int					/* error */
+xfs_refcountbt_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	int			*stat)	/* success/failure */
+{
+	trace_xfs_refcountbt_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_GE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/**
+ * xfs_refcountbt_get_rec() -- Get the data from the pointed-to record.
+ *
+ * @cur: refcount btree cursor
+ * @irec: set to the record currently pointed to by the btree cursor
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int
+xfs_refcountbt_get_rec(
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
+		trace_xfs_refcountbt_get(cur->bc_mp, cur->bc_private.a.agno,
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
+xfs_refcountbt_update(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec)
+{
+	union xfs_btree_rec	rec;
+
+	trace_xfs_refcountbt_update(cur->bc_mp, cur->bc_private.a.agno, irec);
+	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
+	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
+	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Insert the record referred to by cur to the value given
+ * by [bno, len, refcount].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcountbt_insert(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec,
+	int				*i)
+{
+	trace_xfs_refcountbt_insert(cur->bc_mp, cur->bc_private.a.agno, irec);
+	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
+	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
+	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
+	return xfs_btree_insert(cur, i);
+}
+
+/*
+ * Remove the record referred to by cur, then set the pointer to the spot
+ * where the record could be re-inserted, in case we want to increment or
+ * decrement the cursor.
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcountbt_delete(
+	struct xfs_btree_cur	*cur,
+	int			*i)
+{
+	struct xfs_refcount_irec	irec;
+	int			found_rec;
+	int			error;
+
+	error = xfs_refcountbt_get_rec(cur, &irec, &found_rec);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	trace_xfs_refcountbt_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
+	error = xfs_btree_delete(cur, i);
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+	if (error)
+		return error;
+	error = xfs_refcountbt_lookup_ge(cur, irec.rc_startblock, &found_rec);
+out_error:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
new file mode 100644
index 0000000..033a9b1
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_REFCOUNT_H__
+#define __XFS_REFCOUNT_H__
+
+extern int xfs_refcountbt_lookup_le(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcountbt_lookup_ge(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcountbt_get_rec(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
+
+#endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7067a05..d7574cd 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -43,6 +43,158 @@ xfs_refcountbt_dup_cursor(
 			cur->bc_private.a.flist);
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
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_refcountbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
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
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_REFC);
+	args.minlen = args.maxlen = args.prod = 1;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out_error;
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.len == 1);
+
+	new->s = cpu_to_be32(args.agbno);
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
+	struct xfs_trans	*tp = cur->bc_tp;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
+
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
+	xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
+			&oinfo);
+	xfs_trans_binval(tp, bp);
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
+	ASSERT(rec->refc.rc_startblock != 0);
+
+	key->refc.rc_startblock = rec->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->refc.rc_startblock != 0);
+
+	rec->refc.rc_startblock = key->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(cur->bc_rec.rc.rc_startblock != 0);
+
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
 STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
@@ -104,12 +256,63 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
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
+		trace_xfs_refcount_rec_order_error(cur->bc_mp,
+				cur->bc_private.a.agno, &a, &b);
+	}
+
+	return ret;
+}
+#endif	/* DEBUG */
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
+	.init_rec_from_key	= xfs_refcountbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
+	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_refcountbt_keys_inorder,
+	.recs_inorder		= xfs_refcountbt_recs_inorder,
+#endif
 };
 
 /**

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
