Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTYaH031686
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F68B33F1FC
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:43 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id pUYUs8CxWIOMcvMn for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:43 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUiIF019247
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:44 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUiDQ019240
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:44 +0200
Date: Tue, 29 Jul 2008 21:30:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/21] make btree tracing generic
Message-ID: <20080729193044.GI19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-trace
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

make the existing bmap btree tracing generic so that it applies to all
btree types.

Some fragments lifted from a patch by Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-29 16:23:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-29 16:52:06.000000000 +0200
@@ -190,6 +190,25 @@ struct xfs_btree_ops {
 
 	/* get inode rooted btree root */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
+
+	/* btree tracing */
+#ifdef XFS_BTREE_TRACE
+	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
+				       char *, int, int, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t);
+	void		(*trace_cursor)(struct xfs_btree_cur *, __uint32_t *,
+					__uint64_t *, __uint64_t *);
+	void		(*trace_key)(struct xfs_btree_cur *,
+				     union xfs_btree_key *, __uint64_t *,
+				     __uint64_t *);
+	void		(*trace_record)(struct xfs_btree_cur *,
+					union xfs_btree_rec *, __uint64_t *,
+					__uint64_t *, __uint64_t *);
+#endif
 };
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_btree_trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_btree_trace.c	2008-07-29 16:59:40.000000000 +0200
@@ -0,0 +1,247 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
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
+#include "xfs_types.h"
+#include "xfs_inum.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_btree_trace.h"
+
+STATIC void
+xfs_btree_trace_ptr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	ptr,
+	__psunsigned_t		*high,
+	__psunsigned_t		*low)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		__u64 val = be64_to_cpu(ptr.l);
+		*high = val >> 32;
+		*low = (int)val;
+	} else {
+		*high = 0;
+		*low = be32_to_cpu(ptr.s);
+	}
+}
+
+/*
+ * Add a trace buffer entry for arguments, for a buffer & 1 integer arg.
+ */
+void
+xfs_btree_trace_argbi(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*b,
+	int			i,
+	int			line)
+{
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGBI,
+				 line, (__psunsigned_t)b, i, 0, 0, 0, 0, 0,
+				 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for a buffer & 2 integer args.
+ */
+void
+xfs_btree_trace_argbii(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*b,
+	int			i0,
+	int			i1,
+	int			line)
+{
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGBII,
+				 line, (__psunsigned_t)b, i0, i1, 0, 0, 0, 0,
+				 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for 3 block-length args
+ * and an integer arg.
+ */
+void
+xfs_btree_trace_argfffi(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	xfs_dfiloff_t		o,
+	xfs_dfsbno_t		b,
+	xfs_dfilblks_t		i,
+	int			j,
+	int			line)
+{
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGFFFI, line,
+		o >> 32, (int)o, b >> 32, (int)b,
+		i >> 32, (int)i, (int)j, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for one integer arg.
+ */
+void
+xfs_btree_trace_argi(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	int			i,
+	int			line)
+{
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGI,
+				 line, i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, fsblock, key.
+ */
+void
+xfs_btree_trace_argipk(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	int			i,
+	union xfs_btree_ptr	ptr,
+	union xfs_btree_key	*key,
+	int			line)
+{
+	__psunsigned_t		high, low;
+	__uint64_t		l0, l1;
+
+	xfs_btree_trace_ptr(cur, ptr, &high, &low);
+	cur->bc_ops->trace_key(cur, key, &l0, &l1);
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPK,
+				 line, i, high, low,
+				 l0 >> 32, (int)l0,
+				 l1 >> 32, (int)l1,
+				 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, fsblock, rec.
+ */
+void
+xfs_btree_trace_argipr(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	int			i,
+	union xfs_btree_ptr	ptr,
+	union xfs_btree_rec	*rec,
+	int			line)
+{
+	__psunsigned_t		high, low;
+	__uint64_t		l0, l1, l2;
+
+	xfs_btree_trace_ptr(cur, ptr, &high, &low);
+	cur->bc_ops->trace_record(cur, rec, &l0, &l1, &l2);
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPR,
+			      line, i,
+			      high, low,
+			      l0 >> 32, (int)l0,
+			      l1 >> 32, (int)l1,
+			      l2 >> 32, (int)l2,
+			      0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, key.
+ */
+void
+xfs_btree_trace_argik(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	int			i,
+	union xfs_btree_key	*key,
+	int			line)
+{
+	__uint64_t		l0, l1;
+
+	cur->bc_ops->trace_key(cur, key, &l0, &l1);
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGIK,
+				 line, i,
+				 l0 >> 32, (int)l0,
+				 l1 >> 32, (int)l1,
+				 0, 0, 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for record.
+ */
+void
+xfs_btree_trace_argr(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	int			line)
+{
+	__uint64_t		l0, l1, l2;
+
+	cur->bc_ops->trace_record(cur, rec, &l0, &l1, &l2);
+	cur->bc_ops->trace_enter(cur, func, XBT_ARGS, XFS_BTREE_KTRACE_ARGR,
+			      line,
+			      l0 >> 32, (int)l0,
+			      l1 >> 32, (int)l1,
+			      l2 >> 32, (int)l2,
+			      0, 0, 0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for the cursor/operation.
+ */
+void
+xfs_btree_trace_cursor(
+	const char		*func,
+	struct xfs_btree_cur	*cur,
+	int			type,
+	int			line)
+{
+	__uint32_t		s0;
+	__uint64_t		l0, l1;
+	char			*s;
+
+	switch (type) {
+	case XBT_ARGS:
+		s = "args";
+		break;
+	case XBT_ENTRY:
+		s = "entry";
+		break;
+	case XBT_ERROR:
+		s = "error";
+		break;
+	case XBT_EXIT:
+		s = "exit";
+		break;
+	default:
+		s = "unknown";
+		break;
+	}
+
+	cur->bc_ops->trace_cursor(cur, &s0, &l0, &l1);
+	cur->bc_ops->trace_enter(cur, func, s, XFS_BTREE_KTRACE_CUR, line,
+				 s0,
+				 l0 >> 32, (int)l0,
+				 l1 >> 32, (int)l1,
+				 (__psunsigned_t)cur->bc_bufs[0],
+				 (__psunsigned_t)cur->bc_bufs[1],
+				 (__psunsigned_t)cur->bc_bufs[2],
+				 (__psunsigned_t)cur->bc_bufs[3],
+				 (cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
+				 (cur->bc_ptrs[2] << 16) | cur->bc_ptrs[3]);
+}
Index: linux-2.6-xfs/fs/xfs/Makefile
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile	2008-07-29 16:23:24.000000000 +0200
@@ -81,7 +81,8 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_dmops.o \
 				   xfs_qmops.o
 
-xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
+xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
+				   xfs_dir2_trace.o
 
 # Objects in linux/
 xfs-y				+= $(addprefix $(XFS_LINUX)/, \
Index: linux-2.6-xfs/fs/xfs/xfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs.h	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs.h	2008-07-29 16:23:24.000000000 +0200
@@ -30,7 +30,7 @@
 #define XFS_ATTR_TRACE 1
 #define XFS_BLI_TRACE 1
 #define XFS_BMAP_TRACE 1
-#define XFS_BMBT_TRACE 1
+#define XFS_BTREE_TRACE 1
 #define XFS_DIR2_TRACE 1
 #define XFS_DQUOT_TRACE 1
 #define XFS_ILOCK_TRACE 1
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-29 16:57:57.000000000 +0200
@@ -37,16 +37,13 @@
 #include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
-#if defined(XFS_BMBT_TRACE)
-ktrace_t	*xfs_bmbt_trace_buf;
-#endif
-
 /*
  * Prototypes for internal btree functions.
  */
@@ -61,245 +58,33 @@ STATIC int xfs_bmbt_split(xfs_btree_cur_
 		__uint64_t *, xfs_btree_cur_t **, int *);
 STATIC int xfs_bmbt_updkey(xfs_btree_cur_t *, xfs_bmbt_key_t *, int);
 
-
-#if defined(XFS_BMBT_TRACE)
-
-static char	ARGS[] = "args";
-static char	ENTRY[] = "entry";
-static char	ERROR[] = "error";
 #undef EXIT
-static char	EXIT[] = "exit";
 
-/*
- * Add a trace buffer entry for the arguments given to the routine,
- * generic form.
- */
-STATIC void
-xfs_bmbt_trace_enter(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	char		*s,
-	int		type,
-	int		line,
-	__psunsigned_t	a0,
-	__psunsigned_t	a1,
-	__psunsigned_t	a2,
-	__psunsigned_t	a3,
-	__psunsigned_t	a4,
-	__psunsigned_t	a5,
-	__psunsigned_t	a6,
-	__psunsigned_t	a7,
-	__psunsigned_t	a8,
-	__psunsigned_t	a9,
-	__psunsigned_t	a10)
-{
-	xfs_inode_t	*ip;
-	int		whichfork;
-
-	ip = cur->bc_private.b.ip;
-	whichfork = cur->bc_private.b.whichfork;
-	ktrace_enter(xfs_bmbt_trace_buf,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-	ASSERT(ip->i_btrace);
-	ktrace_enter(ip->i_btrace,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-}
-/*
- * Add a trace buffer entry for arguments, for a buffer & 1 integer arg.
- */
-STATIC void
-xfs_bmbt_trace_argbi(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*b,
-	int		i,
-	int		line)
-{
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGBI, line,
-		(__psunsigned_t)b, i, 0, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for a buffer & 2 integer args.
- */
-STATIC void
-xfs_bmbt_trace_argbii(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*b,
-	int		i0,
-	int		i1,
-	int		line)
-{
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGBII, line,
-		(__psunsigned_t)b, i0, i1, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for 3 block-length args
- * and an integer arg.
- */
-STATIC void
-xfs_bmbt_trace_argfffi(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	xfs_dfiloff_t		o,
-	xfs_dfsbno_t		b,
-	xfs_dfilblks_t		i,
-	int			j,
-	int			line)
-{
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGFFFI, line,
-		o >> 32, (int)o, b >> 32, (int)b,
-		i >> 32, (int)i, (int)j, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for one integer arg.
- */
-STATIC void
-xfs_bmbt_trace_argi(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	int		i,
-	int		line)
-{
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGI, line,
-		i, 0, 0, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, fsblock, key.
- */
-STATIC void
-xfs_bmbt_trace_argifk(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_fsblock_t		f,
-	xfs_dfiloff_t		o,
-	int			line)
-{
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFK, line,
-		i, (xfs_dfsbno_t)f >> 32, (int)f, o >> 32,
-		(int)o, 0, 0, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, fsblock, rec.
- */
-STATIC void
-xfs_bmbt_trace_argifr(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_fsblock_t		f,
-	xfs_bmbt_rec_t		*r,
-	int			line)
-{
-	xfs_dfsbno_t		b;
-	xfs_dfilblks_t		c;
-	xfs_dfsbno_t		d;
-	xfs_dfiloff_t		o;
-	xfs_bmbt_irec_t		s;
-
-	d = (xfs_dfsbno_t)f;
-	xfs_bmbt_disk_get_all(r, &s);
-	o = (xfs_dfiloff_t)s.br_startoff;
-	b = (xfs_dfsbno_t)s.br_startblock;
-	c = s.br_blockcount;
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFR, line,
-		i, d >> 32, (int)d, o >> 32,
-		(int)o, b >> 32, (int)b, c >> 32,
-		(int)c, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for arguments, for int, key.
- */
-STATIC void
-xfs_bmbt_trace_argik(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_bmbt_key_t		*k,
-	int			line)
-{
-	xfs_dfiloff_t		o;
-
-	o = be64_to_cpu(k->br_startoff);
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFK, line,
-		i, o >> 32, (int)o, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
-}
-
-/*
- * Add a trace buffer entry for the cursor/operation.
- */
-STATIC void
-xfs_bmbt_trace_cursor(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	char		*s,
-	int		line)
-{
-	xfs_bmbt_rec_host_t	r;
-
-	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
-	xfs_bmbt_trace_enter(func, cur, s, XFS_BMBT_KTRACE_CUR, line,
-		(cur->bc_nlevels << 24) | (cur->bc_private.b.flags << 16) |
-		cur->bc_private.b.allocated,
-		r.l0 >> 32, (int)r.l0,
-		r.l1 >> 32, (int)r.l1,
-		(unsigned long)cur->bc_bufs[0], (unsigned long)cur->bc_bufs[1],
-		(unsigned long)cur->bc_bufs[2], (unsigned long)cur->bc_bufs[3],
-		(cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
-		(cur->bc_ptrs[2] << 16) | cur->bc_ptrs[3]);
-}
-
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i)	\
-	xfs_bmbt_trace_argbi(__func__, c, b, i, __LINE__)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)	\
-	xfs_bmbt_trace_argbii(__func__, c, b, i, j, __LINE__)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)	\
-	xfs_bmbt_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
-#define	XFS_BMBT_TRACE_ARGI(c,i)	\
-	xfs_bmbt_trace_argi(__func__, c, i, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)	\
-	xfs_bmbt_trace_argifk(__func__, c, i, f, s, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)	\
-	xfs_bmbt_trace_argifr(__func__, c, i, f, r, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k)	\
-	xfs_bmbt_trace_argik(__func__, c, i, k, __LINE__)
-#define	XFS_BMBT_TRACE_CURSOR(c,s)	\
-	xfs_bmbt_trace_cursor(__func__, c, s, __LINE__)
-#else
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)
-#define	XFS_BMBT_TRACE_ARGI(c,i)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k)
-#define	XFS_BMBT_TRACE_CURSOR(c,s)
-#endif	/* XFS_BMBT_TRACE */
+#define ENTRY	XBT_ENTRY
+#define ERROR	XBT_ERROR
+#define EXIT	XBT_EXIT
+
+/*
+ * Keep the XFS_BMBT_TRACE_ names around for now until all code using them
+ * is converted to be generic and thus switches to the XFS_BTREE_TRACE_ names.
+ */
+#define	XFS_BMBT_TRACE_ARGBI(c,b,i) \
+	XFS_BTREE_TRACE_ARGBI(c,b,i)
+#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j) \
+	XFS_BTREE_TRACE_ARGBII(c,b,i,j)
+#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j) \
+	XFS_BTREE_TRACE_ARGFFFI(c,o,b,i,j)
+#define	XFS_BMBT_TRACE_ARGI(c,i) \
+	XFS_BTREE_TRACE_ARGI(c,i)
+#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s) \
+	XFS_BTREE_TRACE_ARGIPK(c,i,(union xfs_btree_ptr)f,s)
+#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r) \
+	XFS_BTREE_TRACE_ARGIPR(c,i, \
+		(union xfs_btree_ptr)f, (union xfs_btree_rec *)r)
+#define	XFS_BMBT_TRACE_ARGIK(c,i,k) \
+	XFS_BTREE_TRACE_ARGIK(c,i,(union xfs_btree_key *)k)
+#define	XFS_BMBT_TRACE_CURSOR(c,s) \
+	XFS_BTREE_TRACE_CURSOR(c,s)
 
 
 /*
@@ -1485,7 +1270,8 @@ xfs_bmbt_split(
 	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
 
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
+	// disable until merged into common code
+//	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	lbp = cur->bc_bufs[level];
@@ -2639,9 +2425,102 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
+#ifdef XFS_BTREE_TRACE
+
+ktrace_t	*xfs_bmbt_trace_buf;
+
+STATIC void
+xfs_bmbt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_private.b.whichfork;
+
+	ktrace_enter(xfs_bmbt_trace_buf,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+	ktrace_enter(ip->i_btrace,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_bmbt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	struct xfs_bmbt_rec_host r;
+
+	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
+
+	*s0 = (cur->bc_nlevels << 24) |
+	      (cur->bc_private.b.flags << 16) |
+	       cur->bc_private.b.allocated;
+	*l0 = r.l0;
+	*l1 = r.l1;
+}
+
+STATIC void
+xfs_bmbt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*l0 = be64_to_cpu(key->bmbt.br_startoff);
+	*l1 = 0;
+}
+
+STATIC void
+xfs_bmbt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	struct xfs_bmbt_irec	irec;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	*l0 = irec.br_startoff;
+	*l1 = irec.br_startblock;
+	*l2 = irec.br_blockcount;
+}
+#endif /* XFS_BTREE_TRACE */
+
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_bmbt_trace_enter,
+	.trace_cursor		= xfs_bmbt_trace_cursor,
+	.trace_key		= xfs_bmbt_trace_key,
+	.trace_record		= xfs_bmbt_trace_record,
+#endif
 };
 
 /*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-29 16:23:24.000000000 +0200
@@ -39,6 +39,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
@@ -97,7 +98,9 @@ EXPORT_SYMBOL(xfs_alloc_trace_buf);
 #ifdef XFS_BMAP_TRACE
 EXPORT_SYMBOL(xfs_bmap_trace_buf);
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
+EXPORT_SYMBOL(xfs_allocbt_trace_buf);
+EXPORT_SYMBOL(xfs_inobt_trace_buf);
 EXPORT_SYMBOL(xfs_bmbt_trace_buf);
 #endif
 #ifdef XFS_ATTR_TRACE
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-29 16:23:24.000000000 +0200
@@ -35,6 +35,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
 #include "xfs_rtalloc.h"
@@ -1744,10 +1745,18 @@ xfs_alloc_trace_bufs(void)
 	if (!xfs_bmap_trace_buf)
 		goto out_free_alloc_trace;
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
+	xfs_allocbt_trace_buf = ktrace_alloc(XFS_ALLOCBT_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_allocbt_trace_buf)
+		goto out_free_bmap_trace;
+
+	xfs_inobt_trace_buf = ktrace_alloc(XFS_INOBT_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_inobt_trace_buf)
+		goto out_free_allocbt_trace;
+
 	xfs_bmbt_trace_buf = ktrace_alloc(XFS_BMBT_TRACE_SIZE, KM_MAYFAIL);
 	if (!xfs_bmbt_trace_buf)
-		goto out_free_bmap_trace;
+		goto out_free_inobt_trace;
 #endif
 #ifdef XFS_ATTR_TRACE
 	xfs_attr_trace_buf = ktrace_alloc(XFS_ATTR_TRACE_SIZE, KM_MAYFAIL);
@@ -1769,8 +1778,12 @@ xfs_alloc_trace_bufs(void)
 	ktrace_free(xfs_attr_trace_buf);
  out_free_bmbt_trace:
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	ktrace_free(xfs_bmbt_trace_buf);
+ out_free_inobt_trace:
+	ktrace_free(xfs_inobt_trace_buf);
+ out_free_allocbt_trace:
+	ktrace_free(xfs_allocbt_trace_buf);
  out_free_bmap_trace:
 #endif
 #ifdef XFS_BMAP_TRACE
@@ -1793,8 +1806,10 @@ xfs_free_trace_bufs(void)
 #ifdef XFS_ATTR_TRACE
 	ktrace_free(xfs_attr_trace_buf);
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	ktrace_free(xfs_bmbt_trace_buf);
+	ktrace_free(xfs_inobt_trace_buf);
+	ktrace_free(xfs_allocbt_trace_buf);
 #endif
 #ifdef XFS_BMAP_TRACE
 	ktrace_free(xfs_bmap_trace_buf);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-29 16:52:06.000000000 +0200
@@ -233,24 +233,6 @@ typedef struct xfs_btree_lblock xfs_bmbt
 
 #ifdef __KERNEL__
 
-#if defined(XFS_BMBT_TRACE)
-/*
- * Trace buffer entry types.
- */
-#define XFS_BMBT_KTRACE_ARGBI	1
-#define XFS_BMBT_KTRACE_ARGBII	2
-#define XFS_BMBT_KTRACE_ARGFFFI 3
-#define XFS_BMBT_KTRACE_ARGI	4
-#define XFS_BMBT_KTRACE_ARGIFK	5
-#define XFS_BMBT_KTRACE_ARGIFR	6
-#define XFS_BMBT_KTRACE_ARGIK	7
-#define XFS_BMBT_KTRACE_CUR	8
-
-#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
-#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmbt_trace_buf;
-#endif
-
 /*
  * Prototypes for xfs_bmap.c to call.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-07-29 16:23:24.000000000 +0200
@@ -41,6 +41,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
@@ -841,7 +842,7 @@ xfs_iread(
 #ifdef XFS_BMAP_TRACE
 	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_SLEEP);
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_SLEEP);
 #endif
 #ifdef XFS_RW_TRACE
@@ -2600,7 +2601,7 @@ xfs_idestroy(
 #ifdef XFS_BMAP_TRACE
 	ktrace_free(ip->i_xtrace);
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	ktrace_free(ip->i_btrace);
 #endif
 #ifdef XFS_RW_TRACE
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-07-29 16:23:24.000000000 +0200
@@ -251,7 +251,7 @@ typedef struct xfs_inode {
 #ifdef XFS_BMAP_TRACE
 	struct ktrace		*i_xtrace;	/* inode extent list trace */
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	struct ktrace		*i_btrace;	/* inode bmap btree trace */
 #endif
 #ifdef XFS_RW_TRACE
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-29 16:59:55.000000000 +0200
@@ -45,6 +45,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"
@@ -88,7 +89,7 @@ static void	xfsidbg_xattrtrace(int);
 static void	xfsidbg_xblitrace(xfs_buf_log_item_t *);
 #endif
 #ifdef XFS_BMAP_TRACE
-static void	xfsidbg_xbmatrace(int);
+static void	xfsidbg_xbtatrace(int, struct ktrace *, int);
 static void	xfsidbg_xbmitrace(xfs_inode_t *);
 static void	xfsidbg_xbmstrace(xfs_inode_t *);
 static void	xfsidbg_xbxatrace(int);
@@ -133,7 +134,7 @@ static void	xfsidbg_xattrleaf(xfs_attr_l
 static void	xfsidbg_xattrsf(xfs_attr_shortform_t *);
 static void	xfsidbg_xbirec(xfs_bmbt_irec_t *r);
 static void	xfsidbg_xbmalla(xfs_bmalloca_t *);
-static void	xfsidbg_xbrec(xfs_bmbt_rec_host_t *);
+static void	xfsidbg_xbmbtrec(xfs_bmbt_rec_host_t *);
 static void	xfsidbg_xbroot(xfs_inode_t *);
 static void	xfsidbg_xbroota(xfs_inode_t *);
 static void	xfsidbg_xbtcur(xfs_btree_cur_t *);
@@ -198,9 +199,6 @@ static int	xfs_attr_trace_entry(ktrace_e
 #ifdef XFS_BMAP_TRACE
 static int	xfs_bmap_trace_entry(ktrace_entry_t *ktep);
 #endif
-#ifdef XFS_BMAP_TRACE
-static int	xfs_bmbt_trace_entry(ktrace_entry_t *ktep);
-#endif
 #ifdef XFS_DIR2_TRACE
 static int	xfs_dir2_trace_entry(ktrace_entry_t *ktep);
 #endif
@@ -421,10 +419,52 @@ static int	kdbm_xfs_xbmatrace(
 	if (diag)
 		return diag;
 
-	xfsidbg_xbmatrace((int) addr);
+	xfsidbg_xbtatrace(XFS_BTNUM_BMAP, xfs_bmbt_trace_buf, (int)addr);
 	return 0;
 }
 
+static int	kdbm_xfs_xbtaatrace(
+	int	argc,
+	const char **argv)
+{
+	unsigned long addr;
+	int nextarg = 1;
+	long offset = 0;
+	int diag;
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+	if (diag)
+		return diag;
+
+	/* also contains XFS_BTNUM_CNT */
+	xfsidbg_xbtatrace(XFS_BTNUM_BNO, xfs_allocbt_trace_buf, (int)addr);
+	return 0;
+}
+
+static int	kdbm_xfs_xbtiatrace(
+	int	argc,
+	const char **argv)
+{
+	unsigned long addr;
+	int nextarg = 1;
+	long offset = 0;
+	int diag;
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+	if (diag)
+		return diag;
+
+	xfsidbg_xbtatrace(XFS_BTNUM_INO, xfs_inobt_trace_buf, (int)addr);
+	return 0;
+}
+
+
 static int	kdbm_xfs_xbmitrace(
 	int	argc,
 	const char **argv)
@@ -902,7 +942,7 @@ static int	kdbm_xfs_xbrec(
 	if (diag)
 		return diag;
 
-	xfsidbg_xbrec((xfs_bmbt_rec_host_t *) addr);
+	xfsidbg_xbmbtrec((xfs_bmbt_rec_host_t *) addr);
 	return 0;
 }
 
@@ -2273,6 +2313,10 @@ static struct xif xfsidbg_funcs[] = {
 				"Dump XFS bmap btree per-inode trace" },
   {  "xbmstrc",	kdbm_xfs_xbmstrace,	"<xfs_inode_t>",
 				"Dump XFS bmap btree inode trace" },
+  {  "xbtaatrc", kdbm_xfs_xbtaatrace,	"<count>",
+				"Dump XFS alloc btree count trace" },
+  {  "xbtiatrc", kdbm_xfs_xbtiatrace,	"<count>",
+				"Dump XFS inobt btree count trace" },
 #endif
   {  "xbrec",	kdbm_xfs_xbrec,		"<xfs_bmbt_rec_64_t>",
 				"Dump XFS bmap record"},
@@ -2706,16 +2750,115 @@ xfs_bmap_trace_entry(ktrace_entry_t *kte
 	return 1;
 }
 
+static void
+xfsidb_btree_trace_record(
+	int			btnum,
+	unsigned long		l0,
+	unsigned long		l1,
+	unsigned long		l2,
+	unsigned long		l3,
+	unsigned long		l4,
+	unsigned long		l5)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BMAP:
+	{
+		struct xfs_bmbt_irec s;
+
+		s.br_startoff = ((xfs_dfiloff_t)l0 << 32) | (xfs_dfiloff_t)l1;
+		s.br_startblock = ((xfs_dfsbno_t)l2 << 32) | (xfs_dfsbno_t)l3;
+		s.br_blockcount = ((xfs_dfilblks_t)l4 << 32) | (xfs_dfilblks_t)l5;
+
+		xfsidbg_xbirec(&s);
+		break;
+	}
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		qprintf(" startblock = %d, blockcount = %d\n",
+			(unsigned int)l0, (unsigned int)l2);
+		break;
+	case XFS_BTNUM_INO:
+		qprintf(" startino = %d, freecount = %d, free = %lld\n",
+			(unsigned int)l0, (unsigned int)l2,
+			((xfs_inofree_t)l4 << 32) | (xfs_inofree_t)l5);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+xfsidb_btree_trace_key(
+	int			btnum,
+	unsigned long		l0,
+	unsigned long		l1,
+	unsigned long		l2,
+	unsigned long		l3)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BMAP:
+		qprintf(" startoff 0x%x%08x\n", (unsigned int)l0, (unsigned int)l1);
+		break;
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		qprintf(" startblock %d blockcount %d\n",
+			(unsigned int)l0, (unsigned int)l3);
+		break;
+	case XFS_BTNUM_INO:
+		qprintf(" startino %d\n", (unsigned int)l0);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+xfsidb_btree_trace_cursor(
+	int			btnum,
+	unsigned long		l0,
+	unsigned long		l1,
+	unsigned long		l2,
+	unsigned long		l3,
+	unsigned long		l4)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BMAP:
+	{
+		struct xfs_bmbt_rec_host r;
+
+		qprintf(" nlevels %ld flags %ld allocated %ld ",
+			(l0 >> 24) & 0xff, (l0 >> 16) & 0xff, l0 & 0xffff);
+
+		r.l0 = (unsigned long long)l1 << 32 | l2;
+		r.l1 = (unsigned long long)l3 << 32 | l4;
+
+		xfsidbg_xbmbtrec(&r);
+		break;
+	}
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		qprintf(" agno %d startblock %d blockcount %d\n",
+			(unsigned int)l0, (unsigned int)l1, (unsigned int)l3);
+		break;
+	case XFS_BTNUM_INO:
+		qprintf(" agno %d startino %d free %lld\n",
+			(unsigned int)l0, (unsigned int)l1,
+			((xfs_inofree_t)l3 << 32) | (xfs_inofree_t)l4);
+		break;
+	default:
+		break;
+	}
+}
+
 /*
  * Print xfs bmap btree trace buffer entry.
  */
 static int
-xfs_bmbt_trace_entry(
-	ktrace_entry_t	  *ktep)
+xfs_btree_trace_entry(
+	int			btnum,
+	ktrace_entry_t	  	*ktep)
 {
 	int			line;
-	xfs_bmbt_rec_host_t	r;
-	xfs_bmbt_irec_t		s;
 	int			type;
 	int			whichfork;
 
@@ -2732,18 +2875,18 @@ xfs_bmbt_trace_entry(
 		"da"[whichfork],
 		(xfs_btree_cur_t *)ktep->val[4]);
 	switch (type) {
-	case XFS_BMBT_KTRACE_ARGBI:
+	case XFS_BTREE_KTRACE_ARGBI:
 		qprintf(" buf 0x%p i %ld\n",
 			(xfs_buf_t *)ktep->val[5],
 			(long)ktep->val[6]);
 		break;
-	case XFS_BMBT_KTRACE_ARGBII:
+	case XFS_BTREE_KTRACE_ARGBII:
 		qprintf(" buf 0x%p i0 %ld i1 %ld\n",
 			(xfs_buf_t *)ktep->val[5],
 			(long)ktep->val[6],
 			(long)ktep->val[7]);
 		break;
-	case XFS_BMBT_KTRACE_ARGFFFI:
+	case XFS_BTREE_KTRACE_ARGFFFI:
 		qprintf(" o 0x%x%08x b 0x%x%08x i 0x%x%08x j %ld\n",
 			(unsigned int)(long)ktep->val[5],
 			(unsigned int)(long)ktep->val[6],
@@ -2753,11 +2896,11 @@ xfs_bmbt_trace_entry(
 			(unsigned int)(long)ktep->val[10],
 			(long)ktep->val[11]);
 		break;
-	case XFS_BMBT_KTRACE_ARGI:
+	case XFS_BTREE_KTRACE_ARGI:
 		qprintf(" i 0x%lx\n",
 			(long)ktep->val[5]);
 		break;
-	case XFS_BMBT_KTRACE_ARGIFK:
+	case XFS_BTREE_KTRACE_ARGIPK:
 		qprintf(" i 0x%lx f 0x%x%08x o 0x%x%08x\n",
 			(long)ktep->val[5],
 			(unsigned int)(long)ktep->val[6],
@@ -2765,39 +2908,45 @@ xfs_bmbt_trace_entry(
 			(unsigned int)(long)ktep->val[8],
 			(unsigned int)(long)ktep->val[9]);
 		break;
-	case XFS_BMBT_KTRACE_ARGIFR:
+	case XFS_BTREE_KTRACE_ARGIPR:
 		qprintf(" i 0x%lx f 0x%x%08x ",
 			(long)ktep->val[5],
 			(unsigned int)(long)ktep->val[6],
 			(unsigned int)(long)ktep->val[7]);
-		s.br_startoff = (xfs_fileoff_t)
-			(((xfs_dfiloff_t)(unsigned long)ktep->val[8] << 32) |
-				(xfs_dfiloff_t)(unsigned long)ktep->val[9]);
-		s.br_startblock = (xfs_fsblock_t)
-			(((xfs_dfsbno_t)(unsigned long)ktep->val[10] << 32) |
-				(xfs_dfsbno_t)(unsigned long)ktep->val[11]);
-		s.br_blockcount = (xfs_filblks_t)
-			(((xfs_dfilblks_t)(unsigned long)ktep->val[12] << 32) |
-				(xfs_dfilblks_t)(unsigned long)ktep->val[13]);
-		xfsidbg_xbirec(&s);
-		break;
-	case XFS_BMBT_KTRACE_ARGIK:
-		qprintf(" i 0x%lx o 0x%x%08x\n",
-			(long)ktep->val[5],
-			(unsigned int)(long)ktep->val[6],
-			(unsigned int)(long)ktep->val[7]);
-		break;
-	case XFS_BMBT_KTRACE_CUR:
-		qprintf(" nlevels %ld flags %ld allocated %ld ",
-			((long)ktep->val[5] >> 24) & 0xff,
-			((long)ktep->val[5] >> 16) & 0xff,
-			(long)ktep->val[5] & 0xffff);
-		r.l0 = (unsigned long long)(unsigned long)ktep->val[6] << 32 |
-			(unsigned long)ktep->val[7];
-		r.l1 = (unsigned long long)(unsigned long)ktep->val[8] << 32 |
-			(unsigned long)ktep->val[9];
+		xfsidb_btree_trace_record(btnum,
+					 (unsigned long)ktep->val[8],
+					 (unsigned long)ktep->val[9],
+					 (unsigned long)ktep->val[10],
+					 (unsigned long)ktep->val[11],
+					 (unsigned long)ktep->val[12],
+					 (unsigned long)ktep->val[13]);
+		break;
+	case XFS_BTREE_KTRACE_ARGIK:
+		qprintf(" i 0x%lx\n", (long)ktep->val[5]);
+		xfsidb_btree_trace_key(btnum,
+				      (unsigned long)ktep->val[6],
+				      (unsigned long)ktep->val[7],
+				      (unsigned long)ktep->val[8],
+				      (unsigned long)ktep->val[9]);
+		break;
+	case XFS_BTREE_KTRACE_ARGR:
+		xfsidb_btree_trace_record(btnum,
+					 (unsigned long)ktep->val[5],
+					 (unsigned long)ktep->val[6],
+					 (unsigned long)ktep->val[7],
+					 (unsigned long)ktep->val[8],
+					 (unsigned long)ktep->val[9],
+					 (unsigned long)ktep->val[10]);
+		break;
+	case XFS_BTREE_KTRACE_CUR:
+
+		xfsidb_btree_trace_cursor(btnum,
+					  (unsigned long)ktep->val[5],
+					  (unsigned long)ktep->val[6],
+					  (unsigned long)ktep->val[7],
+					  (unsigned long)ktep->val[8],
+					  (unsigned long)ktep->val[9]);
 
-		xfsidbg_xbrec(&r);
 		qprintf(" bufs 0x%p 0x%p 0x%p 0x%p ",
 			(xfs_buf_t *)ktep->val[10],
 			(xfs_buf_t *)ktep->val[11],
@@ -4383,21 +4532,21 @@ xfsidbg_xbmalla(xfs_bmalloca_t *a)
 
 #ifdef XFS_BMAP_TRACE
 /*
- * Print out the last "count" entries in the bmap btree trace buffer.
+ * Print out the last "count" entries in a btree trace buffer.
  * The "a" is for "all" inodes.
  */
 static void
-xfsidbg_xbmatrace(int count)
+xfsidbg_xbtatrace(int btnum, struct ktrace *trace_buf, int count)
 {
 	ktrace_entry_t  *ktep;
 	ktrace_snap_t   kts;
 	int	     nentries;
 	int	     skip_entries;
 
-	if (xfs_bmbt_trace_buf == NULL) {
+	if (trace_buf == NULL) {
 		qprintf("The xfs bmap btree trace buffer is not initialized\n");		return;
 	}
-	nentries = ktrace_nentries(xfs_bmbt_trace_buf);
+	nentries = ktrace_nentries(trace_buf);
 	if (count == -1) {
 		count = nentries;
 	}
@@ -4406,23 +4555,23 @@ xfsidbg_xbmatrace(int count)
 		return;
 	}
 
-	ktep = ktrace_first(xfs_bmbt_trace_buf, &kts);
+	ktep = ktrace_first(trace_buf, &kts);
 	if (count != nentries) {
 		/*
 		 * Skip the total minus the number to look at minus one
 		 * for the entry returned by ktrace_first().
 		 */
 		skip_entries = nentries - count - 1;
-		ktep = ktrace_skip(xfs_bmbt_trace_buf, skip_entries, &kts);
+		ktep = ktrace_skip(trace_buf, skip_entries, &kts);
 		if (ktep == NULL) {
 			qprintf("Skipped them all\n");
 			return;
 		}
 	}
 	while (ktep != NULL) {
-		if (xfs_bmbt_trace_entry(ktep))
+		if (xfs_btree_trace_entry(btnum, ktep))
 			qprintf("\n");
-		ktep = ktrace_next(xfs_bmbt_trace_buf, &kts);
+		ktep = ktrace_next(trace_buf, &kts);
 	}
 }
 
@@ -4442,7 +4591,7 @@ xfsidbg_xbmitrace(xfs_inode_t *ip)
 
 	ktep = ktrace_first(ip->i_btrace, &kts);
 	while (ktep != NULL) {
-		if (xfs_bmbt_trace_entry(ktep))
+		if (xfs_btree_trace_entry(XFS_BTNUM_BMAP, ktep))
 			qprintf("\n");
 		ktep = ktrace_next(ip->i_btrace, &kts);
 	}
@@ -4465,7 +4614,7 @@ xfsidbg_xbmstrace(xfs_inode_t *ip)
 	ktep = ktrace_first(xfs_bmbt_trace_buf, &kts);
 	while (ktep != NULL) {
 		if ((xfs_inode_t *)(ktep->val[2]) == ip) {
-			if (xfs_bmbt_trace_entry(ktep))
+			if (xfs_btree_trace_entry(XFS_BTNUM_BMAP, ktep))
 				qprintf("\n");
 		}
 		ktep = ktrace_next(xfs_bmbt_trace_buf, &kts);
@@ -4477,7 +4626,7 @@ xfsidbg_xbmstrace(xfs_inode_t *ip)
  * Print xfs bmap record
  */
 static void
-xfsidbg_xbrec(xfs_bmbt_rec_host_t *r)
+xfsidbg_xbmbtrec(xfs_bmbt_rec_host_t *r)
 {
 	xfs_bmbt_irec_t	irec;
 
@@ -6398,7 +6547,7 @@ xfsidbg_xnode(xfs_inode_t *ip)
 #ifdef XFS_BMAP_TRACE
 	qprintf(" bmap_trace 0x%p\n", ip->i_xtrace);
 #endif
-#ifdef XFS_BMBT_TRACE
+#ifdef XFS_BTREE_TRACE
 	qprintf(" bmbt trace 0x%p\n", ip->i_btrace);
 #endif
 #ifdef XFS_RW_TRACE
Index: linux-2.6-xfs/fs/xfs/xfs_btree_trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_btree_trace.h	2008-07-29 16:53:44.000000000 +0200
@@ -0,0 +1,116 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
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
+#ifndef __XFS_BTREE_TRACE_H__
+#define	__XFS_BTREE_TRACE_H__
+
+struct xfs_btree_cur;
+struct xfs_buf;
+
+
+/*
+ * Trace hooks.
+ * i,j = integer (32 bit)
+ * b = btree block buffer (xfs_buf_t)
+ * p = btree ptr
+ * r = btree record
+ * k = btree key
+ */
+
+#ifdef XFS_BTREE_TRACE
+
+/*
+ * Trace buffer entry types.
+ */
+#define XFS_BTREE_KTRACE_ARGBI   1
+#define XFS_BTREE_KTRACE_ARGBII  2
+#define XFS_BTREE_KTRACE_ARGFFFI 3
+#define XFS_BTREE_KTRACE_ARGI    4
+#define XFS_BTREE_KTRACE_ARGIPK  5
+#define XFS_BTREE_KTRACE_ARGIPR  6
+#define XFS_BTREE_KTRACE_ARGIK   7
+#define XFS_BTREE_KTRACE_ARGR	 8
+#define XFS_BTREE_KTRACE_CUR     9
+
+/*
+ * Sub-types for cursor traces.
+ */
+#define XBT_ARGS	0
+#define XBT_ENTRY	1
+#define XBT_ERROR	2
+#define XBT_EXIT	3
+
+void xfs_btree_trace_argbi(const char *, struct xfs_btree_cur *,
+		struct xfs_buf *, int, int);
+void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
+		struct xfs_buf *, int, int, int);
+void xfs_btree_trace_argfffi(const char *, struct xfs_btree_cur *,
+		xfs_dfiloff_t, xfs_dfsbno_t, xfs_dfilblks_t, int, int);
+void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
+void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_ptr, union xfs_btree_key *, int);
+void xfs_btree_trace_argipr(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_ptr, union xfs_btree_rec *, int);
+void xfs_btree_trace_argik(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_key *, int);
+void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
+		union xfs_btree_rec *, int);
+void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
+
+
+#define XFS_ALLOCBT_TRACE_SIZE	4096	/* size of global trace buffer */
+extern ktrace_t	*xfs_allocbt_trace_buf;
+
+#define XFS_INOBT_TRACE_SIZE	4096	/* size of global trace buffer */
+extern ktrace_t	*xfs_inobt_trace_buf;
+
+#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
+#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
+extern ktrace_t	*xfs_bmbt_trace_buf;
+
+
+#define	XFS_BTREE_TRACE_ARGBI(c,b,i)	\
+	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGBII(c,b,i,j)	\
+	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
+#define	XFS_BTREE_TRACE_ARGFFFI(c,o,b,i,j)	\
+	xfs_btree_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
+#define	XFS_BTREE_TRACE_ARGI(c,i)	\
+	xfs_btree_trace_argi(__func__, c, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPK(c,i,p,k)	\
+	xfs_btree_trace_argipk(__func__, c, i, p, k, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPR(c,i,p,r)	\
+	xfs_btree_trace_argipr(__func__, c, i, p, r, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIK(c,i,k)	\
+	xfs_btree_trace_argik(__func__, c, i, k, __LINE__)
+#define XFS_BTREE_TRACE_ARGR(c,r)	\
+	xfs_btree_trace_argr(__func__, c, r, __LINE__)
+#define	XFS_BTREE_TRACE_CURSOR(c,t)	\
+	xfs_btree_trace_cursor(__func__, c, t, __LINE__)
+#else
+#define	XFS_BTREE_TRACE_ARGBI(c,b,i)
+#define	XFS_BTREE_TRACE_ARGBII(c,b,i,j)
+#define	XFS_BTREE_TRACE_ARGFFFI(c,o,b,i,j)
+#define	XFS_BTREE_TRACE_ARGI(c,i)
+#define	XFS_BTREE_TRACE_ARGIPK(c,i,p,s)
+#define	XFS_BTREE_TRACE_ARGIPR(c,i,p,r)
+#define	XFS_BTREE_TRACE_ARGIK(c,i,k)
+#define XFS_BTREE_TRACE_ARGR(c,r)
+#define	XFS_BTREE_TRACE_CURSOR(c,t)
+#endif	/* XFS_BTREE_TRACE */
+
+#endif /* __XFS_BTREE_TRACE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-29 16:52:06.000000000 +0200
@@ -2219,8 +2219,82 @@ xfs_allocbt_dup_cursor(
 			cur->bc_btnum);
 }
 
+#ifdef XFS_BTREE_TRACE
+
+ktrace_t	*xfs_allocbt_trace_buf;
+
+STATIC void
+xfs_allocbt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	ktrace_enter(xfs_allocbt_trace_buf, (void *)(__psint_t)type,
+		(void *)func, (void *)s, NULL, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_allocbt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.a.ar_startblock;
+	*l1 = cur->bc_rec.a.ar_blockcount;
+}
+
+STATIC void
+xfs_allocbt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*l0 = be32_to_cpu(key->alloc.ar_startblock);
+	*l1 = be32_to_cpu(key->alloc.ar_blockcount);
+}
+
+STATIC void
+xfs_allocbt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	*l0 = be32_to_cpu(rec->alloc.ar_startblock);
+	*l1 = be32_to_cpu(rec->alloc.ar_blockcount);
+	*l2 = 0;
+}
+#endif /* XFS_BTREE_TRACE */
+
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_allocbt_trace_enter,
+	.trace_cursor		= xfs_allocbt_trace_cursor,
+	.trace_key		= xfs_allocbt_trace_key,
+	.trace_record		= xfs_allocbt_trace_record,
+#endif
 };
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-29 16:23:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-29 16:52:06.000000000 +0200
@@ -2085,8 +2085,82 @@ xfs_inobt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+#ifdef XFS_BTREE_TRACE
+
+ktrace_t	*xfs_inobt_trace_buf;
+
+STATIC void
+xfs_inobt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	ktrace_enter(xfs_inobt_trace_buf, (void *)(__psint_t)type,
+		(void *)func, (void *)s, NULL, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_inobt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.i.ir_startino;
+	*l1 = cur->bc_rec.i.ir_free;
+}
+
+STATIC void
+xfs_inobt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*l0 = be32_to_cpu(key->inobt.ir_startino);
+	*l1 = 0;
+}
+
+STATIC void
+xfs_inobt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	*l0 = be32_to_cpu(rec->inobt.ir_startino);
+	*l1 = be32_to_cpu(rec->inobt.ir_freecount);
+	*l2 = be64_to_cpu(rec->inobt.ir_free);
+}
+#endif /* XFS_BTREE_TRACE */
+
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_inobt_trace_enter,
+	.trace_cursor		= xfs_inobt_trace_cursor,
+	.trace_key		= xfs_inobt_trace_key,
+	.trace_record		= xfs_inobt_trace_record,
+#endif
 };
 
 /*

-- 
