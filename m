Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMkMRQ176267 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:46:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 194C34F8B87
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:46:21 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6dBrYifsqjYz13AD for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 14:46:21 -0800 (PST)
Date: Tue, 22 Nov 2011 17:46:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] repair: avoid ABBA deadlocks on prefetched buffers
Message-ID: <20111122224620.GA20107@infradead.org>
References: <20111115210953.GA6670@infradead.org>
	<201111180944.10048.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201111180944.10048.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Nov 18, 2011 at 09:44:09AM +0100, Arkadiusz Mi??kiewicz wrote:
> On Tuesday 15 of November 2011, Christoph Hellwig wrote:
> > Both the prefetch threads and actual repair processing threads can have
> > multiple buffers at a time locked, but they do no use a common locker
> > order, which can lead to ABBA deadlocks while trying to lock the buffers.
> 
> There is still some issue with deadlocking.
> 
> The last printed messages:
> b????dna liczba magiczna 0x41425443 w bloku inobt 2/1438099
> b????dna liczba magiczna 0x41425443 w bloku inobt 2/1438196
> b????dna liczba magiczna 0x41425443 w bloku inobt 2/1438732
> (invalid magic number ... in block inobt ...)

It looks like you have a circular loop in the inobt tree, and repair
deadlocks trying to read the same node again.  Below is a patch working
around that by allowing recursive locking for the buffer lock and then
letting the normal two strikes and out policy apply.  I'm not overly
proud of the patch, but in the short term I can't think of anything
better.


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
