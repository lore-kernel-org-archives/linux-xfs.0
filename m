Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KM0WJm086343 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:00:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D00691606F77
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:05:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	49oZmVgvmwot5YVx for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:05:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R68Mg-0006yV-QE
	for xfs@oss.sgi.com; Tue, 20 Sep 2011 22:00:30 +0000
Message-Id: <20110920220030.771822970@bombadil.infradead.org>
Date: Tue, 20 Sep 2011 17:59:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] libxfs: add b_error
References: <20110920215917.508421839@bombadil.infradead.org>
Content-Disposition: inline; filename=libxfs-add-b_error
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

Add a b_error field to struct xfs_buf so that we can return the exact error
fro libxfs_readbuf.  And explicit error return would be nice, but this
requires large changes to common code that should be done on the kernel
side first.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-09-20 20:44:23.000000000 +0000
+++ xfsprogs-dev/include/libxfs.h	2011-09-20 20:44:32.000000000 +0000
@@ -230,6 +230,7 @@ typedef struct xfs_buf {
 	void			*b_fsprivate2;
 	void			*b_fsprivate3;
 	char			*b_addr;
+	int			b_error;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-09-20 20:44:37.000000000 +0000
+++ xfsprogs-dev/libxfs/rdwr.c	2011-09-20 20:45:22.000000000 +0000
@@ -314,6 +314,7 @@ libxfs_initbuf(xfs_buf_t *bp, dev_t devi
 	bp->b_blkno = bno;
 	bp->b_bcount = bytes;
 	bp->b_dev = device;
+	bp->b_error = 0;
 	if (!bp->b_addr)
 		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
 	if (!bp->b_addr) {
@@ -495,10 +496,8 @@ libxfs_readbuf(dev_t dev, xfs_daddr_t bl
 	bp = libxfs_getbuf(dev, blkno, len);
 	if (bp && !(bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
 		error = libxfs_readbufr(dev, blkno, bp, len, flags);
-		if (error) {
-			libxfs_putbuf(bp);
-			return NULL;
-		}
+		if (error)
+			bp->b_error = error;
 	}
 	return bp;
 }
Index: xfsprogs-dev/libxfs/trans.c
===================================================================
--- xfsprogs-dev.orig/libxfs/trans.c	2011-09-20 20:45:29.000000000 +0000
+++ xfsprogs-dev/libxfs/trans.c	2011-09-20 20:46:34.000000000 +0000
@@ -477,6 +477,7 @@ libxfs_trans_read_buf(
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
 	xfs_buftarg_t		bdev;
+	int			error;
 
 	*bpp = NULL;
 
@@ -486,6 +487,8 @@ libxfs_trans_read_buf(
 			return (flags & XBF_TRYLOCK) ?
 				EAGAIN : XFS_ERROR(ENOMEM);
 		}
+		if (bp->b_error)
+			goto out_relse;
 		goto done;
 	}
 
@@ -504,6 +507,8 @@ libxfs_trans_read_buf(
 		return (flags & XBF_TRYLOCK) ?
 			EAGAIN : XFS_ERROR(ENOMEM);
 	}
+	if (bp->b_error)
+		goto out_relse;
 
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
@@ -519,6 +524,10 @@ libxfs_trans_read_buf(
 done:
 	*bpp = bp;
 	return 0;
+out_relse:
+	error = bp->b_error;
+	xfs_buf_relse(bp);
+	return error;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
