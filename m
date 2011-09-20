Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KM0V31086320 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:00:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E1461C2AA42
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qOq4O4rFNcfCXgk7 for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R68Mg-0006xz-Jt
	for xfs@oss.sgi.com; Tue, 20 Sep 2011 22:00:30 +0000
Message-Id: <20110920220030.576600914@bombadil.infradead.org>
Date: Tue, 20 Sep 2011 17:59:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] libxfs: handle short reads in libxfs_readbufr
References: <20110920215917.508421839@bombadil.infradead.org>
Content-Disposition: inline; filename=libxfs-handle-short-reads
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

Copy the code from libxfs_writebufr to handle short reads, and also
tidy up a formatting issue found in the libxfs_writebufr copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-09-20 20:43:28.000000000 +0000
+++ xfsprogs-dev/libxfs/rdwr.c	2011-09-20 20:43:49.000000000 +0000
@@ -455,16 +455,24 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t b
 	int	fd = libxfs_device_to_fd(dev);
 	int	bytes = BBTOB(len);
 	int	error;
+	int	sts;
 
 	ASSERT(BBTOB(len) <= bp->b_bcount);
 
-	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) < 0) {
+	sts = pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno));
+	if (sts < 0) {
 		error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
 			progname, strerror(error));
 		if (flags & LIBXFS_EXIT_ON_FAILURE)
 			exit(1);
 		return error;
+	} else if (sts != bytes) {
+		fprintf(stderr, _("%s: error - read only %d of %d bytes\n"),
+			progname, sts, bytes);
+		if (flags & LIBXFS_EXIT_ON_FAILURE)
+			exit(1);
+		return EIO;
 	}
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %u bytes, blkno=%llu(%llu), %p\n",
@@ -510,8 +518,7 @@ libxfs_writebufr(xfs_buf_t *bp)
 		if (bp->b_flags & LIBXFS_B_EXIT)
 			exit(1);
 		return error;
-	}
-	else if (sts != bp->b_bcount) {
+	} else if (sts != bp->b_bcount) {
 		fprintf(stderr, _("%s: error - wrote only %d of %d bytes\n"),
 			progname, sts, bp->b_bcount);
 		if (bp->b_flags & LIBXFS_B_EXIT)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
