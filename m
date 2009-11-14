Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHfHQ193823 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA621D976FA
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oQCcAfr36cw6QzzB for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK6-0004Xk-2f
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:02 +0000
Message-Id: <20091114161801.978180093@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: kill the STATIC_INLINE macro
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-STATIC_INLINE
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

Remove our own STATIC_INLINE macro.  For small function inside implementation
files just use STATIC and let gcc inline it, and for those in headers do the
normal static inline - they are all small enough to be inlined for debug
builds, too.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-12 17:10:19.847273603 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2009-11-12 17:18:51.342254266 +0100
@@ -337,7 +337,7 @@ xfs_map_blocks(
 	return -xfs_iomap(XFS_I(inode), offset, count, flags, mapp, &nmaps);
 }
 
-STATIC_INLINE int
+STATIC int
 xfs_iomap_valid(
 	xfs_iomap_t		*iomapp,
 	loff_t			offset)
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-11-12 17:13:55.334003777 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-11-12 17:18:51.343279047 +0100
@@ -149,7 +149,7 @@ page_region_mask(
 	return mask;
 }
 
-STATIC_INLINE void
+STATIC void
 set_page_region(
 	struct page	*page,
 	size_t		offset,
@@ -161,7 +161,7 @@ set_page_region(
 		SetPageUptodate(page);
 }
 
-STATIC_INLINE int
+STATIC int
 test_page_region(
 	struct page	*page,
 	size_t		offset,
@@ -1113,7 +1113,7 @@ xfs_bdwrite(
 	xfs_buf_delwri_queue(bp, 1);
 }
 
-STATIC_INLINE void
+STATIC void
 _xfs_buf_ioend(
 	xfs_buf_t		*bp,
 	int			schedule)
Index: xfs/fs/xfs/support/debug.h
===================================================================
--- xfs.orig/fs/xfs/support/debug.h	2009-09-02 02:34:18.083957167 +0200
+++ xfs/fs/xfs/support/debug.h	2009-11-12 17:18:51.346291303 +0100
@@ -41,10 +41,6 @@ extern void assfail(char *expr, char *f,
 # define STATIC static noinline
 #endif
 
-#ifndef STATIC_INLINE
-# define STATIC_INLINE static inline
-#endif
-
 #else /* DEBUG */
 
 #define ASSERT(expr)	\
@@ -54,19 +50,5 @@ extern void assfail(char *expr, char *f,
 # define STATIC noinline
 #endif
 
-/*
- * We stop inlining of inline functions in debug mode.
- * Unfortunately, this means static inline in header files
- * get multiple definitions, so they need to remain static.
- * This then gives tonnes of warnings about unused but defined
- * functions, so we need to add the unused attribute to prevent
- * these spurious warnings.
- */
-#ifndef STATIC_INLINE
-# define STATIC_INLINE static __attribute__ ((unused)) noinline
-#endif
-
 #endif /* DEBUG */
-
-
 #endif  /* __XFS_SUPPORT_DEBUG_H__ */
Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-11-12 17:10:20.365276128 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2009-11-12 17:18:51.352004530 +0100
@@ -98,7 +98,7 @@ STATIC int xfs_attr_leaf_entsize(xfs_att
  * If namespace bits don't match return 0.
  * If all match then return 1.
  */
-STATIC_INLINE int
+STATIC int
 xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
 {
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2009-11-12 17:10:20.092263270 +0100
+++ xfs/fs/xfs/xfs_bmap_btree.c	2009-11-12 17:18:51.355004214 +0100
@@ -98,8 +98,7 @@ xfs_bmdr_to_bmbt(
  * This code must be in sync with the routines xfs_bmbt_get_startoff,
  * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
  */
-
-STATIC_INLINE void
+STATIC void
 __xfs_bmbt_get_all(
 		__uint64_t l0,
 		__uint64_t l1,
Index: xfs/fs/xfs/xfs_filestream.h
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.h	2009-08-27 03:51:46.093856009 +0200
+++ xfs/fs/xfs/xfs_filestream.h	2009-11-12 17:18:51.357025561 +0100
@@ -79,7 +79,7 @@ extern ktrace_t *xfs_filestreams_trace_b
  * the cache that reference per-ag array elements that have since been
  * reallocated.
  */
-STATIC_INLINE int
+static inline int
 xfs_filestream_peek_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
@@ -87,7 +87,7 @@ xfs_filestream_peek_ag(
 	return atomic_read(&mp->m_perag[agno].pagf_fstrms);
 }
 
-STATIC_INLINE int
+static inline int
 xfs_filestream_get_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
@@ -95,7 +95,7 @@ xfs_filestream_get_ag(
 	return atomic_inc_return(&mp->m_perag[agno].pagf_fstrms);
 }
 
-STATIC_INLINE int
+static inline int
 xfs_filestream_put_ag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
@@ -122,7 +122,7 @@ int xfs_filestream_new_ag(struct xfs_bma
 
 
 /* filestreams for the inode? */
-STATIC_INLINE int
+static inline int
 xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-11-09 17:06:46.115004101 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-11-12 17:18:51.362006363 +0100
@@ -425,7 +425,7 @@ xfs_ialloc_ag_alloc(
 	return 0;
 }
 
-STATIC_INLINE xfs_agnumber_t
+STATIC xfs_agnumber_t
 xfs_ialloc_next_ag(
 	xfs_mount_t	*mp)
 {
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-11-12 17:10:20.296276205 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-11-12 17:18:51.367005882 +0100
@@ -2123,7 +2123,7 @@ xfs_icsb_destroy_counters(
 	mutex_destroy(&mp->m_icsb_mutex);
 }
 
-STATIC_INLINE void
+STATIC void
 xfs_icsb_lock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
@@ -2132,7 +2132,7 @@ xfs_icsb_lock_cntr(
 	}
 }
 
-STATIC_INLINE void
+STATIC void
 xfs_icsb_unlock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
@@ -2140,7 +2140,7 @@ xfs_icsb_unlock_cntr(
 }
 
 
-STATIC_INLINE void
+STATIC void
 xfs_icsb_lock_all_counters(
 	xfs_mount_t	*mp)
 {
@@ -2153,7 +2153,7 @@ xfs_icsb_lock_all_counters(
 	}
 }
 
-STATIC_INLINE void
+STATIC void
 xfs_icsb_unlock_all_counters(
 	xfs_mount_t	*mp)
 {
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-09-16 14:36:18.022004650 +0200
+++ xfs/fs/xfs/xfs_mount.h	2009-11-12 17:18:51.369006416 +0100
@@ -387,13 +387,13 @@ xfs_put_perag(struct xfs_mount *mp, xfs_
  * Per-cpu superblock locking functions
  */
 #ifdef HAVE_PERCPU_SB
-STATIC_INLINE void
+static inline void
 xfs_icsb_lock(xfs_mount_t *mp)
 {
 	mutex_lock(&mp->m_icsb_mutex);
 }
 
-STATIC_INLINE void
+static inline void
 xfs_icsb_unlock(xfs_mount_t *mp)
 {
 	mutex_unlock(&mp->m_icsb_mutex);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
