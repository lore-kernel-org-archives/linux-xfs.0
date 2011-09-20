Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KM0Wt8086326 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:00:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 703891606F74
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:05:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hkjtD1wBEJAbmrCs for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:05:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R68Mg-0006xT-E0
	for xfs@oss.sgi.com; Tue, 20 Sep 2011 22:00:30 +0000
Message-Id: <20110920220030.374670125@bombadil.infradead.org>
Date: Tue, 20 Sep 2011 17:59:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] libxfs: save errno before possibly overwriting it
References: <20110920215917.508421839@bombadil.infradead.org>
Content-Disposition: inline; filename=libxfs-fix-errno
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

Save away errno for a later error return before possibly overwriting
it in fprintf.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/libxfs/rdwr.c
===================================================================
--- xfsprogs-dev.orig/libxfs/rdwr.c	2011-09-20 20:41:09.000000000 +0000
+++ xfsprogs-dev/libxfs/rdwr.c	2011-09-20 20:43:28.000000000 +0000
@@ -454,15 +454,17 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t b
 {
 	int	fd = libxfs_device_to_fd(dev);
 	int	bytes = BBTOB(len);
+	int	error;
 
 	ASSERT(BBTOB(len) <= bp->b_bcount);
 
 	if (pread64(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno)) < 0) {
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
@@ -498,14 +500,16 @@ libxfs_writebufr(xfs_buf_t *bp)
 {
 	int	sts;
 	int	fd = libxfs_device_to_fd(bp->b_dev);
+	int	error;
 
 	sts = pwrite64(fd, bp->b_addr, bp->b_bcount, LIBXFS_BBTOOFF64(bp->b_blkno));
 	if (sts < 0) {
+		error = errno;
 		fprintf(stderr, _("%s: pwrite64 failed: %s\n"),
-			progname, strerror(errno));
+			progname, strerror(error));
 		if (bp->b_flags & LIBXFS_B_EXIT)
 			exit(1);
-		return errno;
+		return error;
 	}
 	else if (sts != bp->b_bcount) {
 		fprintf(stderr, _("%s: error - wrote only %d of %d bytes\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
