Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFL9tva075033 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 15:09:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86F671268F5F
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 13:09:54 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4br7mDOBd406RIwT for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 13:09:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RQQGP-0001k1-Kr
	for xfs@oss.sgi.com; Tue, 15 Nov 2011 21:09:53 +0000
Date: Tue, 15 Nov 2011 16:09:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] repair: avoid ABBA deadlocks on prefetched buffers
Message-ID: <20111115210953.GA6670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Both the prefetch threads and actual repair processing threads can have
multiple buffers at a time locked, but they do no use a common locker
order, which can lead to ABBA deadlocks while trying to lock the buffers.

Switch the prefetch code to do a trylock and skip buffers that have
already been locked to avoid this deadlock.

Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-11-15 20:43:02.513069998 +0100
+++ xfsprogs-dev/include/libxfs.h	2011-11-15 20:43:16.669736580 +0100
@@ -279,27 +279,41 @@ enum xfs_buf_flags_t {	/* b_flags bits *
 extern struct cache	*libxfs_bcache;
 extern struct cache_operations	libxfs_bcache_operations;
 
+#define LIBXFS_GETBUF_TRYLOCK	(1 << 0)
+
 #ifdef XFS_BUF_TRACING
 
 #define libxfs_readbuf(dev, daddr, len, flags) \
-		libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, (dev), (daddr), (len), (flags))
+	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
+			    (dev), (daddr), (len), (flags))
 #define libxfs_writebuf(buf, flags) \
-		libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, (buf), (flags))
+	libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, \
+			      (buf), (flags))
 #define libxfs_getbuf(dev, daddr, len) \
-		libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, (dev), (daddr), (len))
+	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
+			    (dev), (daddr), (len))
+#define libxfs_getbuf_flags(dev, daddr, len, flags) \
+	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
+			    (dev), (daddr), (len), (flags))
 #define libxfs_putbuf(buf) \
-		libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
+	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
-extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int, dev_t, xfs_daddr_t, int, int);
-extern int	libxfs_trace_writebuf(const char *, const char *, int, xfs_buf_t *, int);
+extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int,
+			dev_t, xfs_daddr_t, int, int);
+extern int	libxfs_trace_writebuf(const char *, const char *, int,
+			xfs_buf_t *, int);
 extern xfs_buf_t *libxfs_trace_getbuf(const char *, const char *, int, dev_t, xfs_daddr_t, int);
-extern void	libxfs_trace_putbuf (const char *, const char *, int, xfs_buf_t *);
+extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
+			dev_t, xfs_daddr_t, int, unsigned int);
+extern void	libxfs_trace_putbuf (const char *, const char *, int,
+			xfs_buf_t *);
 
 #else
 
 extern xfs_buf_t *libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
 extern int	libxfs_writebuf(xfs_buf_t *, int);
 extern xfs_buf_t *libxfs_getbuf(dev_t, xfs_daddr_t, int);
+extern xfs_buf_t *libxfs_getbuf_flags(dev_t, xfs_daddr_t, int, unsigned int);
 extern void	libxfs_putbuf (xfs_buf_t *);
 
 #endif
Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-11-15 20:43:02.503069998 +0100
+++ xfsprogs-dev/libxfs/rdwr.c	2011-11-15 20:43:16.669736580 +0100
@@ -195,6 +195,7 @@ libxfs_log_header(
 #undef libxfs_readbuf
 #undef libxfs_writebuf
 #undef libxfs_getbuf
+#undef libxfs_getbuf_flags
 #undef libxfs_putbuf
 
 xfs_buf_t 	*libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
@@ -238,6 +239,19 @@ libxfs_trace_getbuf(const char *func, co
 	return bp;
 }
 
+xfs_buf_t *
+libxfs_trace_getbuf_flags(const char *func, const char *file, int line,
+		dev_t device, xfs_daddr_t blkno, int len, unsigned long flags)
+{
+	xfs_buf_t	*bp = libxfs_getbuf(device, blkno, len, flags);
+
+	bp->b_func = func;
+	bp->b_file = file;
+	bp->b_line = line;
+
+	return bp;
+}
+
 void
 libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 {
@@ -380,8 +394,8 @@ int			lock_buf_count = 0;
 
 extern int     use_xfs_buf_lock;
 
-xfs_buf_t *
-libxfs_getbuf(dev_t device, xfs_daddr_t blkno, int len)
+struct xfs_buf *
+libxfs_getbuf_flags(dev_t device, xfs_daddr_t blkno, int len, unsigned int flags)
 {
 	xfs_buf_t	*bp;
 	xfs_bufkey_t	key;
@@ -392,28 +406,48 @@ libxfs_getbuf(dev_t device, xfs_daddr_t
 	key.bblen = len;
 
 	miss = cache_node_get(libxfs_bcache, &key, (struct cache_node **)&bp);
-	if (bp) {
-		if (use_xfs_buf_lock)
+	if (!bp)
+		return NULL;
+
+	if (use_xfs_buf_lock) {
+		if (flags & LIBXFS_GETBUF_TRYLOCK) {
+			int ret;
+
+			ret = pthread_mutex_trylock(&bp->b_lock);
+			if (ret) {
+				ASSERT(ret == EAGAIN);
+				cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+				return NULL;
+			}
+		} else {
 			pthread_mutex_lock(&bp->b_lock);
-		cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
-			cache_node_get_priority((struct cache_node *)bp) -
+		}
+	}
+
+	cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
+		cache_node_get_priority((struct cache_node *)bp) -
 						CACHE_PREFETCH_PRIORITY);
 #ifdef XFS_BUF_TRACING
-		pthread_mutex_lock(&libxfs_bcache->c_mutex);
-		lock_buf_count++;
-		list_add(&bp->b_lock_list, &lock_buf_list);
-		pthread_mutex_unlock(&libxfs_bcache->c_mutex);
+	pthread_mutex_lock(&libxfs_bcache->c_mutex);
+	lock_buf_count++;
+	list_add(&bp->b_lock_list, &lock_buf_list);
+	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
 #endif
 #ifdef IO_DEBUG
-		printf("%lx %s: %s buffer %p for bno = %llu\n",
-			pthread_self(), __FUNCTION__, miss ? "miss" : "hit",
-			bp, (long long)LIBXFS_BBTOOFF64(blkno));
+	printf("%lx %s: %s buffer %p for bno = %llu\n",
+		pthread_self(), __FUNCTION__, miss ? "miss" : "hit",
+		bp, (long long)LIBXFS_BBTOOFF64(blkno));
 #endif
-	}
 
 	return bp;
 }
 
+struct xfs_buf *
+libxfs_getbuf(dev_t device, xfs_daddr_t blkno, int len)
+{
+	return libxfs_getbuf_flags(device, blkno, len, 0);
+}
+
 void
 libxfs_putbuf(xfs_buf_t *bp)
 {
Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2011-11-15 20:44:30.903069469 +0100
+++ xfsprogs-dev/repair/prefetch.c	2011-11-15 20:48:23.073068083 +0100
@@ -112,8 +112,17 @@ pf_queue_io(
 {
 	xfs_buf_t		*bp;
 
-	bp = libxfs_getbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-			XFS_FSB_TO_BB(mp, blen));
+	/*
+	 * Never block on a buffer lock here, given that the actual repair
+	 * code might lock buffers in a different order from us.  Given that
+	 * the lock holder is either reading it from disk himself or
+	 * completely overwriting it this behaviour is perfectly fine.
+	 */
+	bp = libxfs_getbuf_flags(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+			XFS_FSB_TO_BB(mp, blen), LIBXFS_GETBUF_TRYLOCK);
+	if (!bp)
+		return;
+
 	if (bp->b_flags & LIBXFS_B_UPTODATE) {
 		if (B_IS_INODE(flag))
 			pf_read_inode_dirs(args, bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
