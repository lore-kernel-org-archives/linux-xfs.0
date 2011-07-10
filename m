Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLNb153487 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D5535CCBD
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7FGNH6aEyNnKG8Cy for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:19 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xG-0002xu-OQ
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:18 +0000
Message-Id: <20110710205018.724144355@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/11] xfs: remove leftovers of the old btree tracing code
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-dead-btree-trace-code
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove various bits left over from the old kdb-only btree tracing code, but
leave the actual trace point stubs in place to ease adding new event based
btree tracing.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2011-07-09 13:29:17.081585678 +0200
+++ xfs/fs/xfs/Makefile	2011-07-09 14:02:30.378151424 +0200
@@ -88,8 +88,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o
 
-xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
-
 # Objects in linux/
 xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   kmem.o \
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-07-09 13:29:17.091585678 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-07-09 14:02:30.378151424 +0200
@@ -33,7 +33,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-07-09 13:29:17.101585677 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-07-09 14:05:23.471475993 +0200
@@ -31,7 +31,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
@@ -311,72 +310,6 @@ xfs_allocbt_recs_inorder(
 }
 #endif	/* DEBUG */
 
-#ifdef XFS_BTREE_TRACE
-ktrace_t	*xfs_allocbt_trace_buf;
-
-STATIC void
-xfs_allocbt_trace_enter(
-	struct xfs_btree_cur	*cur,
-	const char		*func,
-	char			*s,
-	int			type,
-	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
-{
-	ktrace_enter(xfs_allocbt_trace_buf, (void *)(__psint_t)type,
-		(void *)func, (void *)s, NULL, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-}
-
-STATIC void
-xfs_allocbt_trace_cursor(
-	struct xfs_btree_cur	*cur,
-	__uint32_t		*s0,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	*s0 = cur->bc_private.a.agno;
-	*l0 = cur->bc_rec.a.ar_startblock;
-	*l1 = cur->bc_rec.a.ar_blockcount;
-}
-
-STATIC void
-xfs_allocbt_trace_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	*l0 = be32_to_cpu(key->alloc.ar_startblock);
-	*l1 = be32_to_cpu(key->alloc.ar_blockcount);
-}
-
-STATIC void
-xfs_allocbt_trace_record(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	__uint64_t		*l0,
-	__uint64_t		*l1,
-	__uint64_t		*l2)
-{
-	*l0 = be32_to_cpu(rec->alloc.ar_startblock);
-	*l1 = be32_to_cpu(rec->alloc.ar_blockcount);
-	*l2 = 0;
-}
-#endif /* XFS_BTREE_TRACE */
-
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
@@ -393,18 +326,10 @@ static const struct xfs_btree_ops xfs_al
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
-
 #ifdef DEBUG
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
 #endif
-
-#ifdef XFS_BTREE_TRACE
-	.trace_enter		= xfs_allocbt_trace_enter,
-	.trace_cursor		= xfs_allocbt_trace_cursor,
-	.trace_key		= xfs_allocbt_trace_key,
-	.trace_record		= xfs_allocbt_trace_record,
-#endif
 };
 
 /*
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2011-07-09 13:29:17.108252343 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2011-07-09 14:04:48.868144412 +0200
@@ -33,7 +33,6 @@
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
@@ -732,95 +731,6 @@ xfs_bmbt_recs_inorder(
 }
 #endif	/* DEBUG */
 
-#ifdef XFS_BTREE_TRACE
-ktrace_t	*xfs_bmbt_trace_buf;
-
-STATIC void
-xfs_bmbt_trace_enter(
-	struct xfs_btree_cur	*cur,
-	const char		*func,
-	char			*s,
-	int			type,
-	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
-{
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
-	int			whichfork = cur->bc_private.b.whichfork;
-
-	ktrace_enter(xfs_bmbt_trace_buf,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-}
-
-STATIC void
-xfs_bmbt_trace_cursor(
-	struct xfs_btree_cur	*cur,
-	__uint32_t		*s0,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	struct xfs_bmbt_rec_host r;
-
-	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
-
-	*s0 = (cur->bc_nlevels << 24) |
-	      (cur->bc_private.b.flags << 16) |
-	       cur->bc_private.b.allocated;
-	*l0 = r.l0;
-	*l1 = r.l1;
-}
-
-STATIC void
-xfs_bmbt_trace_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	*l0 = be64_to_cpu(key->bmbt.br_startoff);
-	*l1 = 0;
-}
-
-/* Endian flipping versions of the bmbt extraction functions */
-STATIC void
-xfs_bmbt_disk_get_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
-{
-	__xfs_bmbt_get_all(get_unaligned_be64(&r->l0),
-				get_unaligned_be64(&r->l1), s);
-}
-
-STATIC void
-xfs_bmbt_trace_record(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	__uint64_t		*l0,
-	__uint64_t		*l1,
-	__uint64_t		*l2)
-{
-	struct xfs_bmbt_irec	irec;
-
-	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
-	*l0 = irec.br_startoff;
-	*l1 = irec.br_startblock;
-	*l2 = irec.br_blockcount;
-}
-#endif /* XFS_BTREE_TRACE */
-
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
@@ -837,18 +747,10 @@ static const struct xfs_btree_ops xfs_bm
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
-
 #ifdef DEBUG
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 #endif
-
-#ifdef XFS_BTREE_TRACE
-	.trace_enter		= xfs_bmbt_trace_enter,
-	.trace_cursor		= xfs_bmbt_trace_cursor,
-	.trace_key		= xfs_bmbt_trace_key,
-	.trace_record		= xfs_bmbt_trace_record,
-#endif
 };
 
 /*
Index: xfs/fs/xfs/xfs_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.c	2011-07-09 13:29:17.121585675 +0200
+++ xfs/fs/xfs/xfs_btree.c	2011-07-09 14:02:30.381484757 +0200
@@ -32,7 +32,6 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
Index: xfs/fs/xfs/xfs_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_btree.h	2011-07-09 13:29:17.131585674 +0200
+++ xfs/fs/xfs/xfs_btree.h	2011-07-09 14:05:39.511475182 +0200
@@ -199,25 +199,6 @@ struct xfs_btree_ops {
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
 #endif
-
-	/* btree tracing */
-#ifdef XFS_BTREE_TRACE
-	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
-				       char *, int, int, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t);
-	void		(*trace_cursor)(struct xfs_btree_cur *, __uint32_t *,
-					__uint64_t *, __uint64_t *);
-	void		(*trace_key)(struct xfs_btree_cur *,
-				     union xfs_btree_key *, __uint64_t *,
-				     __uint64_t *);
-	void		(*trace_record)(struct xfs_btree_cur *,
-					union xfs_btree_rec *, __uint64_t *,
-					__uint64_t *, __uint64_t *);
-#endif
 };
 
 /*
@@ -452,4 +433,23 @@ static inline int xfs_btree_get_level(st
 	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
 		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
 
+/*
+ * Trace hooks.  Currently not implemented as they need to be ported
+ * over to the generic tracing functionality, which is some effort.
+ *
+ * i,j = integer (32 bit)
+ * b = btree block buffer (xfs_buf_t)
+ * p = btree ptr
+ * r = btree record
+ * k = btree key
+ */
+#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
+#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
+#define	XFS_BTREE_TRACE_ARGI(c, i)
+#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
+#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
+#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
+#define XFS_BTREE_TRACE_ARGR(c, r)
+#define	XFS_BTREE_TRACE_CURSOR(c, t)
+
 #endif	/* __XFS_BTREE_H__ */
Index: xfs/fs/xfs/xfs_btree_trace.c
===================================================================
--- xfs.orig/fs/xfs/xfs_btree_trace.c	2011-07-09 13:29:17.138252341 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,249 +0,0 @@
-/*
- * Copyright (c) 2008 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-#include "xfs_types.h"
-#include "xfs_inum.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_btree_trace.h"
-
-STATIC void
-xfs_btree_trace_ptr(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	ptr,
-	__psunsigned_t		*high,
-	__psunsigned_t		*low)
-{
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		__u64 val = be64_to_cpu(ptr.l);
-		*high = val >> 32;
-		*low = (int)val;
-	} else {
-		*high = 0;
-		*low = be32_to_cpu(ptr.s);
-	}
-}
-
-/*
- * Add a trace buffer entry for arguments, for a buffer & 1 integer arg.
- */
-void
-xfs_btree_trace_argbi(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*b,
-	int			i,
-	int			line)
-{
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGBI,
-				 line, (__psunsigned_t)b, i, 0, 0, 0, 0, 0,
-				 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for a buffer & 2 integer args.
- */
-void
-xfs_btree_trace_argbii(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*b,
-	int			i0,
-	int			i1,
-	int			line)
-{
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGBII,
-				 line, (__psunsigned_t)b, i0, i1, 0, 0, 0, 0,
-				 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for 3 block-length args
- * and an integer arg.
- */
-void
-xfs_btree_trace_argfffi(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	xfs_dfiloff_t		o,
-	xfs_dfsbno_t		b,
-	xfs_dfilblks_t		i,
-	int			j,
-	int			line)
-{
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGFFFI,
-				 line,
-				 o >> 32, (int)o,
-				 b >> 32, (int)b,
-				 i >> 32, (int)i,
-				 (int)j, 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for one integer arg.
- */
-void
-xfs_btree_trace_argi(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	int			i,
-	int			line)
-{
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGI,
-				 line, i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, fsblock, key.
- */
-void
-xfs_btree_trace_argipk(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	int			i,
-	union xfs_btree_ptr	ptr,
-	union xfs_btree_key	*key,
-	int			line)
-{
-	__psunsigned_t		high, low;
-	__uint64_t		l0, l1;
-
-	xfs_btree_trace_ptr(cur, ptr, &high, &low);
-	cur->bc_ops->trace_key(cur, key, &l0, &l1);
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPK,
-				 line, i, high, low,
-				 l0 >> 32, (int)l0,
-				 l1 >> 32, (int)l1,
-				 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, fsblock, rec.
- */
-void
-xfs_btree_trace_argipr(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	int			i,
-	union xfs_btree_ptr	ptr,
-	union xfs_btree_rec	*rec,
-	int			line)
-{
-	__psunsigned_t		high, low;
-	__uint64_t		l0, l1, l2;
-
-	xfs_btree_trace_ptr(cur, ptr, &high, &low);
-	cur->bc_ops->trace_record(cur, rec, &l0, &l1, &l2);
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPR,
-			      line, i,
-			      high, low,
-			      l0 >> 32, (int)l0,
-			      l1 >> 32, (int)l1,
-			      l2 >> 32, (int)l2,
-			      0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, key.
- */
-void
-xfs_btree_trace_argik(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	int			i,
-	union xfs_btree_key	*key,
-	int			line)
-{
-	__uint64_t		l0, l1;
-
-	cur->bc_ops->trace_key(cur, key, &l0, &l1);
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIK,
-				 line, i,
-				 l0 >> 32, (int)l0,
-				 l1 >> 32, (int)l1,
-				 0, 0, 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for record.
- */
-void
-xfs_btree_trace_argr(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	int			line)
-{
-	__uint64_t		l0, l1, l2;
-
-	cur->bc_ops->trace_record(cur, rec, &l0, &l1, &l2);
-	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGR,
-			      line,
-			      l0 >> 32, (int)l0,
-			      l1 >> 32, (int)l1,
-			      l2 >> 32, (int)l2,
-			      0, 0, 0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for the cursor/operation.
- */
-void
-xfs_btree_trace_cursor(
-	const char		*func,
-	struct xfs_btree_cur	*cur,
-	int			type,
-	int			line)
-{
-	__uint32_t		s0;
-	__uint64_t		l0, l1;
-	char			*s;
-
-	switch (type) {
-	case XBT_ARGS:
-		s = "args";
-		break;
-	case XBT_ENTRY:
-		s = "entry";
-		break;
-	case XBT_ERROR:
-		s = "error";
-		break;
-	case XBT_EXIT:
-		s = "exit";
-		break;
-	default:
-		s = "unknown";
-		break;
-	}
-
-	cur->bc_ops->trace_cursor(cur, &s0, &l0, &l1);
-	cur->bc_ops->trace_enter(cur, func, s, XFS_BTREE_KTRACE_CUR, line,
-				 s0,
-				 l0 >> 32, (int)l0,
-				 l1 >> 32, (int)l1,
-				 (__psunsigned_t)cur->bc_bufs[0],
-				 (__psunsigned_t)cur->bc_bufs[1],
-				 (__psunsigned_t)cur->bc_bufs[2],
-				 (__psunsigned_t)cur->bc_bufs[3],
-				 (cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
-				 (cur->bc_ptrs[2] << 16) | cur->bc_ptrs[3]);
-}
Index: xfs/fs/xfs/xfs_btree_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_btree_trace.h	2011-07-09 13:29:17.148252342 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,99 +0,0 @@
-/*
- * Copyright (c) 2008 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_BTREE_TRACE_H__
-#define	__XFS_BTREE_TRACE_H__
-
-struct xfs_btree_cur;
-struct xfs_buf;
-
-
-/*
- * Trace hooks.
- * i,j = integer (32 bit)
- * b = btree block buffer (xfs_buf_t)
- * p = btree ptr
- * r = btree record
- * k = btree key
- */
-
-#ifdef XFS_BTREE_TRACE
-
-/*
- * Trace buffer entry types.
- */
-#define XFS_BTREE_KTRACE_ARGBI   1
-#define XFS_BTREE_KTRACE_ARGBII  2
-#define XFS_BTREE_KTRACE_ARGFFFI 3
-#define XFS_BTREE_KTRACE_ARGI    4
-#define XFS_BTREE_KTRACE_ARGIPK  5
-#define XFS_BTREE_KTRACE_ARGIPR  6
-#define XFS_BTREE_KTRACE_ARGIK   7
-#define XFS_BTREE_KTRACE_ARGR	 8
-#define XFS_BTREE_KTRACE_CUR     9
-
-/*
- * Sub-types for cursor traces.
- */
-#define XBT_ARGS	0
-#define XBT_ENTRY	1
-#define XBT_ERROR	2
-#define XBT_EXIT	3
-
-void xfs_btree_trace_argbi(const char *, struct xfs_btree_cur *,
-		struct xfs_buf *, int, int);
-void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
-		struct xfs_buf *, int, int, int);
-void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
-void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_ptr, union xfs_btree_key *, int);
-void xfs_btree_trace_argipr(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_ptr, union xfs_btree_rec *, int);
-void xfs_btree_trace_argik(const char *, struct xfs_btree_cur *, int,
-		union xfs_btree_key *, int);
-void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
-		union xfs_btree_rec *, int);
-void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
-
-#define	XFS_BTREE_TRACE_ARGBI(c, b, i)	\
-	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
-#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)	\
-	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
-#define	XFS_BTREE_TRACE_ARGI(c, i)	\
-	xfs_btree_trace_argi(__func__, c, i, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, k)	\
-	xfs_btree_trace_argipk(__func__, c, i, p, k, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)	\
-	xfs_btree_trace_argipr(__func__, c, i, p, r, __LINE__)
-#define	XFS_BTREE_TRACE_ARGIK(c, i, k)	\
-	xfs_btree_trace_argik(__func__, c, i, k, __LINE__)
-#define XFS_BTREE_TRACE_ARGR(c, r)	\
-	xfs_btree_trace_argr(__func__, c, r, __LINE__)
-#define	XFS_BTREE_TRACE_CURSOR(c, t)	\
-	xfs_btree_trace_cursor(__func__, c, t, __LINE__)
-#else
-#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
-#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
-#define	XFS_BTREE_TRACE_ARGI(c, i)
-#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
-#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
-#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
-#define XFS_BTREE_TRACE_ARGR(c, r)
-#define	XFS_BTREE_TRACE_CURSOR(c, t)
-#endif	/* XFS_BTREE_TRACE */
-
-#endif /* __XFS_BTREE_TRACE_H__ */
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2011-07-09 13:29:17.154919008 +0200
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2011-07-09 14:05:21.608142756 +0200
@@ -31,7 +31,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
@@ -205,72 +204,6 @@ xfs_inobt_recs_inorder(
 }
 #endif	/* DEBUG */
 
-#ifdef XFS_BTREE_TRACE
-ktrace_t	*xfs_inobt_trace_buf;
-
-STATIC void
-xfs_inobt_trace_enter(
-	struct xfs_btree_cur	*cur,
-	const char		*func,
-	char			*s,
-	int			type,
-	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
-{
-	ktrace_enter(xfs_inobt_trace_buf, (void *)(__psint_t)type,
-		(void *)func, (void *)s, NULL, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-}
-
-STATIC void
-xfs_inobt_trace_cursor(
-	struct xfs_btree_cur	*cur,
-	__uint32_t		*s0,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	*s0 = cur->bc_private.a.agno;
-	*l0 = cur->bc_rec.i.ir_startino;
-	*l1 = cur->bc_rec.i.ir_free;
-}
-
-STATIC void
-xfs_inobt_trace_key(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*key,
-	__uint64_t		*l0,
-	__uint64_t		*l1)
-{
-	*l0 = be32_to_cpu(key->inobt.ir_startino);
-	*l1 = 0;
-}
-
-STATIC void
-xfs_inobt_trace_record(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	__uint64_t		*l0,
-	__uint64_t		*l1,
-	__uint64_t		*l2)
-{
-	*l0 = be32_to_cpu(rec->inobt.ir_startino);
-	*l1 = be32_to_cpu(rec->inobt.ir_freecount);
-	*l2 = be64_to_cpu(rec->inobt.ir_free);
-}
-#endif /* XFS_BTREE_TRACE */
-
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
@@ -286,18 +219,10 @@ static const struct xfs_btree_ops xfs_in
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
-
 #ifdef DEBUG
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
-
-#ifdef XFS_BTREE_TRACE
-	.trace_enter		= xfs_inobt_trace_enter,
-	.trace_cursor		= xfs_inobt_trace_cursor,
-	.trace_key		= xfs_inobt_trace_key,
-	.trace_record		= xfs_inobt_trace_record,
-#endif
 };
 
 /*
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2011-07-09 13:29:17.164919007 +0200
+++ xfs/fs/xfs/xfs_iget.c	2011-07-09 14:02:30.388151423 +0200
@@ -38,7 +38,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
-#include "xfs_btree_trace.h"
 #include "xfs_trace.h"
 
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-07-09 14:00:08.094825294 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-07-09 14:02:30.391484756 +0200
@@ -37,7 +37,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
-#include "xfs_btree_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
