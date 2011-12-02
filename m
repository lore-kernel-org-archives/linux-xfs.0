Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2ICNPX094657 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 12:12:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 531831F3F475
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	L9DCZUzdCpFpHCCc for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:42 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD4-0000kj-4t
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:42 +0000
Message-Id: <20111202174742.106589485@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/12] repair: use recursive buffer locking
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-fix-recursion-deadlocks
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

On a sufficiently corrupt filesystem walking the btree nodes might hit the
same node node again, which currently will deadlock.  Use a recursion
counter to avoid the direct deadlock and let them normal loop detection
(two bad nodes and out) do its work.  This is how repair behaved before
we added the lock when implementing buffer prefetching.

Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-11-22 22:28:23.000000000 +0000
+++ xfsprogs-dev/include/libxfs.h	2011-11-22 22:34:27.000000000 +0000
@@ -226,6 +226,8 @@ typedef struct xfs_buf {
 	unsigned		b_bcount;
 	dev_t			b_dev;
 	pthread_mutex_t		b_lock;
+	pthread_t		b_holder;
+	unsigned int		b_recur;
 	void			*b_fsprivate;
 	void			*b_fsprivate2;
 	void			*b_fsprivate3;
Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-11-22 22:28:23.000000000 +0000
+++ xfsprogs-dev/libxfs/rdwr.c	2011-11-22 22:40:01.000000000 +0000
@@ -342,6 +342,8 @@ libxfs_initbuf(xfs_buf_t *bp, dev_t devi
 	list_head_init(&bp->b_lock_list);
 #endif
 	pthread_mutex_init(&bp->b_lock, NULL);
+	bp->b_holder = 0;
+	bp->b_recur = 0;
 }
 
 xfs_buf_t *
@@ -410,18 +412,24 @@ libxfs_getbuf_flags(dev_t device, xfs_da
 		return NULL;
 
 	if (use_xfs_buf_lock) {
-		if (flags & LIBXFS_GETBUF_TRYLOCK) {
-			int ret;
+		int ret;
 
-			ret = pthread_mutex_trylock(&bp->b_lock);
-			if (ret) {
-				ASSERT(ret == EAGAIN);
-				cache_node_put(libxfs_bcache, (struct cache_node *)bp);
-				return NULL;
+		ret = pthread_mutex_trylock(&bp->b_lock);
+		if (ret) {
+			ASSERT(ret == EAGAIN);
+			if (flags & LIBXFS_GETBUF_TRYLOCK)
+				goto out_put;
+
+			if (pthread_equal(bp->b_holder, pthread_self())) {
+				fprintf(stderr,
+	_("recursive buffer locking detected\n"));
+				bp->b_recur++;
+			} else {
+				pthread_mutex_lock(&bp->b_lock);
 			}
-		} else {
-			pthread_mutex_lock(&bp->b_lock);
 		}
+
+		bp->b_holder = pthread_self();
 	}
 
 	cache_node_set_priority(libxfs_bcache, (struct cache_node *)bp,
@@ -440,6 +448,9 @@ libxfs_getbuf_flags(dev_t device, xfs_da
 #endif
 
 	return bp;
+out_put:
+	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	return NULL;
 }
 
 struct xfs_buf *
@@ -458,8 +469,14 @@ libxfs_putbuf(xfs_buf_t *bp)
 	list_del_init(&bp->b_lock_list);
 	pthread_mutex_unlock(&libxfs_bcache->c_mutex);
 #endif
-	if (use_xfs_buf_lock)
-		pthread_mutex_unlock(&bp->b_lock);
+	if (use_xfs_buf_lock) {
+		if (bp->b_recur) {
+			bp->b_recur--;
+		} else {
+			bp->b_holder = 0;
+			pthread_mutex_unlock(&bp->b_lock);
+		}
+	}
 	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
