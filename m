Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KM0Vm5086317 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:00:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1320417904B
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	l8JPAAIAACRRAfmy for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R68Mg-0006wx-7r
	for xfs@oss.sgi.com; Tue, 20 Sep 2011 22:00:30 +0000
Message-Id: <20110920220030.204339904@bombadil.infradead.org>
Date: Tue, 20 Sep 2011 17:59:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] libxfs: handle read errors in libxfs_trans_read_buf
References: <20110920215917.508421839@bombadil.infradead.org>
Content-Disposition: inline; filename=libxfs-do-not-ignore-read-errors
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

Libxfs_readbuf may return a NULL buffer to indicate that an error happend
during the read, but we currently ignore that if libxfs_trans_read_buf
is called with a NULL transaction pointer.  Fix this by copying the
relevant code from the kernel version of the routine, and also tidy
the code up a bit by using a common exit label.

This fixes a regression that was introduced in xfsprogs 3.0.0 by commit

	"Implement buffer and inode caching in libxfs, groundwork for a
	 parallel version of xfs_repair."

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/libxfs/trans.c
===================================================================
--- xfsprogs-dev.orig/libxfs/trans.c	2011-09-20 20:33:48.000000000 +0000
+++ xfsprogs-dev/libxfs/trans.c	2011-09-20 20:35:24.000000000 +0000
@@ -478,9 +478,15 @@ libxfs_trans_read_buf(
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
+		goto done;
 	}
 
 	bdev.dev = dev;
@@ -490,15 +496,15 @@ libxfs_trans_read_buf(
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
+
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -510,6 +516,7 @@ libxfs_trans_read_buf(
 
 	/* initialise b_fsprivate2 so we can find it incore */
 	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+done:
 	*bpp = bp;
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
