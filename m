Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XSDB113446 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3696514515CB
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id d3oTnCHCSDde2UmD for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007bH-P7
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:07 +0000
Message-Id: <20100621083607.672484712@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/12] xfs: do not use emums for flags used in tracing
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-tracing-doesnt-like-enums
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

The tracing code can't print flags defined as enums.  Most flags that
we want to print are defines as macros already, but move the few remaining
ones over to make the trace output more useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2010-06-16 14:32:30.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2010-06-16 14:41:06.701005358 +0200
@@ -27,16 +27,16 @@ struct xfs_busy_extent;
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
-typedef enum xfs_alloctype
-{
-	XFS_ALLOCTYPE_ANY_AG,		/* allocate anywhere, use rotor */
-	XFS_ALLOCTYPE_FIRST_AG,		/* ... start at ag 0 */
-	XFS_ALLOCTYPE_START_AG,		/* anywhere, start in this a.g. */
-	XFS_ALLOCTYPE_THIS_AG,		/* anywhere in this a.g. */
-	XFS_ALLOCTYPE_START_BNO,	/* near this block else anywhere */
-	XFS_ALLOCTYPE_NEAR_BNO,		/* in this a.g. and near this block */
-	XFS_ALLOCTYPE_THIS_BNO		/* at exactly this block */
-} xfs_alloctype_t;
+#define XFS_ALLOCTYPE_ANY_AG	0x01	/* allocate anywhere, use rotor */
+#define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
+#define XFS_ALLOCTYPE_START_AG	0x04	/* anywhere, start in this a.g. */
+#define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
+#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
+#define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
+#define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
+
+/* this should become an enum again when the tracing code is fixed */
+typedef unsigned int xfs_alloctype_t;
 
 #define XFS_ALLOC_TYPES \
 	{ XFS_ALLOCTYPE_ANY_AG,		"ANY_AG" }, \
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-06-16 14:33:09.000000000 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-06-16 14:39:50.906009896 +0200
@@ -18,16 +18,16 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
-typedef enum {
-	/* base extent manipulation calls */
-	BMAPI_READ = (1 << 0),		/* read extents */
-	BMAPI_WRITE = (1 << 1),		/* create extents */
-	BMAPI_ALLOCATE = (1 << 2),	/* delayed allocate to real extents */
-	/* modifiers */
-	BMAPI_IGNSTATE = (1 << 4),	/* ignore unwritten state on read */
-	BMAPI_DIRECT = (1 << 5),	/* direct instead of buffered write */
-	BMAPI_TRYLOCK = (1 << 7),	/* non-blocking request */
-} bmapi_flags_t;
+/* base extent manipulation calls */
+#define BMAPI_READ	(1 << 0)	/* read extents */
+#define BMAPI_WRITE	(1 << 1)	/* create extents */
+#define BMAPI_ALLOCATE	(1 << 2)	/* delayed allocate to real extents */
+
+/* modifiers */
+#define BMAPI_IGNSTATE	(1 << 4)	/* ignore unwritten state on read */
+#define BMAPI_DIRECT	(1 << 5)	/* direct instead of buffered write */
+#define BMAPI_MMA	(1 << 6)	/* allocate for mmap write */
+#define BMAPI_TRYLOCK	(1 << 7)	/* non-blocking request */
 
 #define BMAPI_FLAGS \
 	{ BMAPI_READ,		"READ" }, \
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-06-16 14:41:35.278003751 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-06-18 09:57:22.366004277 +0200
@@ -44,57 +44,57 @@ typedef enum {
 	XBRW_ZERO = 3,			/* Zero target memory */
 } xfs_buf_rw_t;
 
-typedef enum {
-	XBF_READ = (1 << 0),	/* buffer intended for reading from device */
-	XBF_WRITE = (1 << 1),	/* buffer intended for writing to device   */
-	XBF_MAPPED = (1 << 2),  /* buffer mapped (b_addr valid)            */
-	XBF_ASYNC = (1 << 4),   /* initiator will not wait for completion  */
-	XBF_DONE = (1 << 5),    /* all pages in the buffer uptodate	   */
-	XBF_DELWRI = (1 << 6),  /* buffer has dirty pages                  */
-	XBF_STALE = (1 << 7),	/* buffer has been staled, do not find it  */
-	XBF_FS_MANAGED = (1 << 8),  /* filesystem controls freeing memory  */
- 	XBF_ORDERED = (1 << 11),    /* use ordered writes		   */
-	XBF_READ_AHEAD = (1 << 12), /* asynchronous read-ahead		   */
-	XBF_LOG_BUFFER = (1 << 13), /* this is a buffer used for the log   */
-
-	/* flags used only as arguments to access routines */
-	XBF_LOCK = (1 << 14),       /* lock requested			   */
-	XBF_TRYLOCK = (1 << 15),    /* lock requested, but do not wait	   */
-	XBF_DONT_BLOCK = (1 << 16), /* do not block in current thread	   */
-
-	/* flags used only internally */
-	_XBF_PAGE_CACHE = (1 << 17),/* backed by pagecache		   */
-	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
-	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
-	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
-
-	/*
-	 * Special flag for supporting metadata blocks smaller than a FSB.
-	 *
-	 * In this case we can have multiple xfs_buf_t on a single page and
-	 * need to lock out concurrent xfs_buf_t readers as they only
-	 * serialise access to the buffer.
-	 *
-	 * If the FSB size >= PAGE_CACHE_SIZE case, we have no serialisation
-	 * between reads of the page. Hence we can have one thread read the
-	 * page and modify it, but then race with another thread that thinks
-	 * the page is not up-to-date and hence reads it again.
-	 *
-	 * The result is that the first modifcation to the page is lost.
-	 * This sort of AGF/AGI reading race can happen when unlinking inodes
-	 * that require truncation and results in the AGI unlinked list
-	 * modifications being lost.
-	 */
-	_XBF_PAGE_LOCKED = (1 << 22),
-
-	/*
-	 * If we try a barrier write, but it fails we have to communicate
-	 * this to the upper layers.  Unfortunately b_error gets overwritten
-	 * when the buffer is re-issued so we have to add another flag to
-	 * keep this information.
-	 */
-	_XFS_BARRIER_FAILED = (1 << 23),
-} xfs_buf_flags_t;
+#define XBF_READ	(1 << 0) /* buffer intended for reading from device */
+#define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
+#define XBF_MAPPED	(1 << 2) /* buffer mapped (b_addr valid) */
+#define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
+#define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
+#define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
+#define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
+#define XBF_FS_MANAGED	(1 << 8) /* filesystem controls freeing memory */
+#define XBF_ORDERED	(1 << 11)/* use ordered writes */
+#define XBF_READ_AHEAD	(1 << 12)/* asynchronous read-ahead */
+#define XBF_LOG_BUFFER	(1 << 13)/* this is a buffer used for the log */
+
+/* flags used only as arguments to access routines */
+#define XBF_LOCK	(1 << 14)/* lock requested */
+#define XBF_TRYLOCK	(1 << 15)/* lock requested, but do not wait */
+#define XBF_DONT_BLOCK	(1 << 16)/* do not block in current thread */
+
+/* flags used only internally */
+#define _XBF_PAGE_CACHE	(1 << 17)/* backed by pagecache */
+#define _XBF_PAGES	(1 << 18)/* backed by refcounted pages */
+#define	_XBF_RUN_QUEUES	(1 << 19)/* run block device task queue	*/
+#define _XBF_DELWRI_Q	(1 << 21)/* buffer on delwri queue */
+
+/*
+ * Special flag for supporting metadata blocks smaller than a FSB.
+ *
+ * In this case we can have multiple xfs_buf_t on a single page and
+ * need to lock out concurrent xfs_buf_t readers as they only
+ * serialise access to the buffer.
+ *
+ * If the FSB size >= PAGE_CACHE_SIZE case, we have no serialisation
+ * between reads of the page. Hence we can have one thread read the
+ * page and modify it, but then race with another thread that thinks
+ * the page is not up-to-date and hence reads it again.
+ *
+ * The result is that the first modifcation to the page is lost.
+ * This sort of AGF/AGI reading race can happen when unlinking inodes
+ * that require truncation and results in the AGI unlinked list
+ * modifications being lost.
+ */
+#define _XBF_PAGE_LOCKED	(1 << 22)
+
+/*
+ * If we try a barrier write, but it fails we have to communicate
+ * this to the upper layers.  Unfortunately b_error gets overwritten
+ * when the buffer is re-issued so we have to add another flag to
+ * keep this information.
+ */
+#define _XFS_BARRIER_FAILED	(1 << 23)
+
+typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
 	{ XBF_READ,		"READ" }, \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
