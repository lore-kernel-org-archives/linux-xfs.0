Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EFcvBS148133 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 10:38:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B74A613EA32C
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 08:43:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wKppvHtJsA9FkQHC for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2011 08:43:39 -0700 (PDT)
Date: Wed, 14 Sep 2011 11:38:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair segfaut in stage 6
Message-ID: <20110914153852.GA11050@infradead.org>
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl>
	<20110912161215.GA17798@infradead.org>
	<4E707624.9030703@nasza-klasa.pl>
	<20110914142430.GA28049@infradead.org>
	<4E70C15C.3030502@nasza-klasa.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E70C15C.3030502@nasza-klasa.pl>
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
To: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Wed, Sep 14, 2011 at 04:59:40PM +0200, Bartosz Cisek wrote:
> Stack trace is pasted in bug issue [1] that is linked in first mail ;)
> Compiled by hand from git: "DEBUG=-DDEBUG make". I don't know why some
> of values are 'optimized out'.
> 
> [1] http://oss.sgi.com/bugzilla/show_bug.cgi?id=914

Looks like we do not handle read I/O errors very well (to say at all)
in phase6.  Can you see if the patch below makes a difference?

---
From: Christoph Hellwig <hch@lst.de>
Subject: repair: fix I/O error handling

Currently libxfs_trans_read_buf never returns an error, even if
libxfs_readbuf did not manage to complete the I/O.  This is different
from the kernel behaviour and can lead to segfaults in code that
doesn't expect it.  Add a new b_error member to xfs_buf (mirroring
the kernel version) and use that to propagate proper error codes
to the caller.  Also fix libxfs_readbufr to handle short reads
properly, and to not override errno values e.g. by a fprintf.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-09-14 11:17:42.660738577 -0400
+++ xfsprogs-dev/include/libxfs.h	2011-09-14 11:20:45.959738580 -0400
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
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-09-14 11:12:08.807741720 -0400
+++ xfsprogs-dev/libxfs/rdwr.c	2011-09-14 11:20:21.183238272 -0400
@@ -314,6 +314,7 @@ libxfs_initbuf(xfs_buf_t *bp, dev_t devi
 	bp->b_blkno = bno;
 	bp->b_bcount = bytes;
 	bp->b_dev = device;
+	bp->b_error = 0;
 	if (!bp->b_addr)
 		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
 	if (!bp->b_addr) {
@@ -454,15 +455,17 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t b
 {
 	int	fd = libxfs_device_to_fd(dev);
 	int	bytes = BBTOB(len);
+	int	error;
 
 	ASSERT(BBTOB(len) <= bp->b_bcount);
 
-	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) < 0) {
+	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) != bytes) {
+		error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
-			progname, strerror(errno));
+			progname, strerror(error));
 		if (flags & LIBXFS_EXIT_ON_FAILURE)
 			exit(1);
-		return errno;
+		return error;
 	}
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %u bytes, blkno=%llu(%llu), %p\n",
@@ -485,10 +488,8 @@ libxfs_readbuf(dev_t dev, xfs_daddr_t bl
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
--- xfsprogs-dev.orig/libxfs/trans.c	2011-09-14 11:12:08.827738490 -0400
+++ xfsprogs-dev/libxfs/trans.c	2011-09-14 11:21:19.771739416 -0400
@@ -478,9 +478,20 @@ libxfs_trans_read_buf(
 	xfs_buf_log_item_t	*bip;
 	xfs_buftarg_t		bdev;
 
+	*bpp = NULL;
+
 	if (tp == NULL) {
-		*bpp = libxfs_readbuf(dev, blkno, len, flags);
-		return 0;
+		bp = libxfs_readbuf(dev, blkno, len, flags);
+		if (!bp) {
+			return (flags & XBF_TRYLOCK) ?
+				EAGAIN : XFS_ERROR(ENOMEM);
+		}
+		if (bp->b_error) {
+			int error = bp->b_error;
+			xfs_buf_relse(bp);
+			return error;
+		}
+		goto done;
 	}
 
 	bdev.dev = dev;
@@ -490,15 +501,20 @@ libxfs_trans_read_buf(
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
 		bip->bli_recur++;
-		*bpp = bp;
-		return 0;
+		goto done;
 	}
 
 	bp = libxfs_readbuf(dev, blkno, len, flags);
-       if (!bp){
-               *bpp = NULL;
-               return errno;
-       }
+	if (!bp) {
+		return (flags & XBF_TRYLOCK) ?
+			EAGAIN : XFS_ERROR(ENOMEM);
+	}
+	if (bp->b_error) {
+		int error = bp->b_error;
+		xfs_buf_relse(bp);
+		return error;
+	}
+
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -510,6 +526,8 @@ libxfs_trans_read_buf(
 
 	/* initialise b_fsprivate2 so we can find it incore */
 	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+
+done:
 	*bpp = bp;
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
