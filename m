Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mARJvdn7028601 for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 13:57:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F002C16131F0
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id a0zZmUIqXRpNUWTl for
	<xfs@oss.sgi.com>; Thu, 27 Nov 2008 11:57:38 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L5mz5-0007pQ-Sx
	for xfs@oss.sgi.com; Thu, 27 Nov 2008 19:57:07 +0000
Date: Thu, 27 Nov 2008 14:57:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] move inode tracing out of xfs_vnode.[ch]
Message-ID: <20081127195707.GC15027@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Move the inode tracing into xfs_iget.c / xfs_inode.h and kill xfs_vnode.c
now that it's empty.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/Makefile
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile	2008-11-16 21:16:20.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/Makefile	2008-11-16 21:18:05.000000000 +0100
@@ -97,7 +97,6 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   xfs_lrw.o \
 				   xfs_super.o \
 				   xfs_sync.o \
-				   xfs_vnode.o \
 				   xfs_xattr.o \
 				   xfs_ksyms.o) 
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-11-16 21:16:23.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,82 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
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
-#include "xfs_vnodeops.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-
-/*
- * And this gunk is needed for xfs_mount.h"
- */
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_dmapi.h"
-#include "xfs_inum.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-
-
-#ifdef	XFS_INODE_TRACE
-
-#define KTRACE_ENTER(ip, vk, s, line, ra)			\
-	ktrace_enter(	(ip)->i_trace,				\
-/*  0 */		(void *)(__psint_t)(vk),		\
-/*  1 */		(void *)(s),				\
-/*  2 */		(void *)(__psint_t) line,		\
-/*  3 */		(void *)(__psint_t)atomic_read(&VFS_I(ip)->i_count), \
-/*  4 */		(void *)(ra),				\
-/*  5 */		NULL,					\
-/*  6 */		(void *)(__psint_t)current_cpu(),	\
-/*  7 */		(void *)(__psint_t)current_pid(),	\
-/*  8 */		(void *)__return_address,		\
-/*  9 */		NULL, NULL, NULL, NULL, NULL, NULL, NULL)
-
-/*
- * Vnode tracing code.
- */
-void
-_xfs_itrace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_ENTRY, func, 0, ra);
-}
-
-void
-_xfs_itrace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_EXIT, func, 0, ra);
-}
-
-void
-xfs_itrace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_HOLD, file, line, ra);
-}
-
-void
-_xfs_itrace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_REF, file, line, ra);
-}
-
-void
-xfs_itrace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
-{
-	KTRACE_ENTER(ip, INODE_KTRACE_RELE, file, line, ra);
-}
-#endif	/* XFS_INODE_TRACE */
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-11-16 21:18:05.000000000 +0100
@@ -793,3 +793,51 @@ xfs_isilocked(
 }
 #endif
 
+#ifdef	XFS_INODE_TRACE
+
+#define KTRACE_ENTER(ip, vk, s, line, ra)			\
+	ktrace_enter(	(ip)->i_trace,				\
+/*  0 */		(void *)(__psint_t)(vk),		\
+/*  1 */		(void *)(s),				\
+/*  2 */		(void *)(__psint_t) line,		\
+/*  3 */		(void *)(__psint_t)atomic_read(&VFS_I(ip)->i_count), \
+/*  4 */		(void *)(ra),				\
+/*  5 */		NULL,					\
+/*  6 */		(void *)(__psint_t)current_cpu(),	\
+/*  7 */		(void *)(__psint_t)current_pid(),	\
+/*  8 */		(void *)__return_address,		\
+/*  9 */		NULL, NULL, NULL, NULL, NULL, NULL, NULL)
+
+/*
+ * Vnode tracing code.
+ */
+void
+_xfs_itrace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
+{
+	KTRACE_ENTER(ip, INODE_KTRACE_ENTRY, func, 0, ra);
+}
+
+void
+_xfs_itrace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
+{
+	KTRACE_ENTER(ip, INODE_KTRACE_EXIT, func, 0, ra);
+}
+
+void
+xfs_itrace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+{
+	KTRACE_ENTER(ip, INODE_KTRACE_HOLD, file, line, ra);
+}
+
+void
+_xfs_itrace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+{
+	KTRACE_ENTER(ip, INODE_KTRACE_REF, file, line, ra);
+}
+
+void
+xfs_itrace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+{
+	KTRACE_ENTER(ip, INODE_KTRACE_RELE, file, line, ra);
+}
+#endif	/* XFS_INODE_TRACE */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 21:16:46.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-11-16 21:18:05.000000000 +0100
@@ -54,19 +54,6 @@ struct attrlist_cursor_kern;
 					   Prevent VM access to the pages until
 					   the operation completes. */
 
-#define IHOLD(ip) \
-do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	atomic_inc(&(VFS_I(ip)->i_count)); \
-	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
-} while (0)
-
-#define IRELE(ip) \
-do { \
-	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
-	iput(VFS_I(ip)); \
-} while (0)
-
 /*
  * Dealing with bad inodes
  */
@@ -103,39 +90,4 @@ static inline void vn_atime_to_time_t(st
 					PAGECACHE_TAG_DIRTY)
 
 
-/*
- * Tracking vnode activity.
- */
-#if defined(XFS_INODE_TRACE)
-
-#define	INODE_TRACE_SIZE	16		/* number of trace entries */
-#define	INODE_KTRACE_ENTRY	1
-#define	INODE_KTRACE_EXIT	2
-#define	INODE_KTRACE_HOLD	3
-#define	INODE_KTRACE_REF	4
-#define	INODE_KTRACE_RELE	5
-
-extern void _xfs_itrace_entry(struct xfs_inode *, const char *, inst_t *);
-extern void _xfs_itrace_exit(struct xfs_inode *, const char *, inst_t *);
-extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
-extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
-extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
-#define xfs_itrace_entry(ip)	\
-	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
-#define xfs_itrace_exit(ip)	\
-	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
-#define xfs_itrace_exit_tag(ip, tag)	\
-	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
-#define xfs_itrace_ref(ip)	\
-	_xfs_itrace_ref(ip, __FILE__, __LINE__, (inst_t *)__return_address)
-
-#else
-#define	xfs_itrace_entry(a)
-#define	xfs_itrace_exit(a)
-#define	xfs_itrace_exit_tag(a, b)
-#define	xfs_itrace_hold(a, b, c, d)
-#define	xfs_itrace_ref(a)
-#define	xfs_itrace_rele(a, b, c, d)
-#endif
-
 #endif	/* __XFS_VNODE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-11-16 21:15:39.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-11-16 21:18:05.000000000 +0100
@@ -540,6 +540,51 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
 void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
+#if defined(XFS_INODE_TRACE)
+
+#define	INODE_TRACE_SIZE	16		/* number of trace entries */
+#define	INODE_KTRACE_ENTRY	1
+#define	INODE_KTRACE_EXIT	2
+#define	INODE_KTRACE_HOLD	3
+#define	INODE_KTRACE_REF	4
+#define	INODE_KTRACE_RELE	5
+
+extern void _xfs_itrace_entry(struct xfs_inode *, const char *, inst_t *);
+extern void _xfs_itrace_exit(struct xfs_inode *, const char *, inst_t *);
+extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
+extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
+extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
+#define xfs_itrace_entry(ip)	\
+	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
+#define xfs_itrace_exit(ip)	\
+	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
+#define xfs_itrace_exit_tag(ip, tag)	\
+	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
+#define xfs_itrace_ref(ip)	\
+	_xfs_itrace_ref(ip, __FILE__, __LINE__, (inst_t *)__return_address)
+
+#else
+#define	xfs_itrace_entry(a)
+#define	xfs_itrace_exit(a)
+#define	xfs_itrace_exit_tag(a, b)
+#define	xfs_itrace_hold(a, b, c, d)
+#define	xfs_itrace_ref(a)
+#define	xfs_itrace_rele(a, b, c, d)
+#endif
+
+#define IHOLD(ip) \
+do { \
+	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
+	atomic_inc(&(VFS_I(ip)->i_count)); \
+	xfs_itrace_hold((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+} while (0)
+
+#define IRELE(ip) \
+do { \
+	xfs_itrace_rele((ip), __FILE__, __LINE__, (inst_t *)__return_address); \
+	iput(VFS_I(ip)); \
+} while (0)
+
 #endif /* __KERNEL__ */
 
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
