Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBA8fEcO205193 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 02:41:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3357C1DC540
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2qit0vwMH5fbBRiF for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 00:43:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PQyZB-0006Nk-SY
	for xfs@oss.sgi.com; Fri, 10 Dec 2010 08:43:01 +0000
Message-Id: <20101210084301.858316107@bombadil.infradead.org>
Date: Fri, 10 Dec 2010 03:42:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/10] xfs: remove some dead bio handling code
References: <20101210084215.259628825@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-aop-cleanups
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

We'll never have BIO_EOPNOTSUPP set after calling submit_bio as
this can only happen for discards, and used to happen for barriers,
none of which is every submitted by xfs_submit_ioend_bio.  Also
remove the loop around bio_alloc as it will never fail due to it's
mempool backing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 14:49:28.115261980 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 14:49:29.417024168 +0100
@@ -380,26 +380,18 @@ xfs_submit_ioend_bio(
 
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ?
 		   WRITE_SYNC_PLUG : WRITE, bio);
-	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
-	bio_put(bio);
 }
 
 STATIC struct bio *
 xfs_alloc_ioend_bio(
 	struct buffer_head	*bh)
 {
-	struct bio		*bio;
 	int			nvecs = bio_get_nr_vecs(bh->b_bdev);
-
-	do {
-		bio = bio_alloc(GFP_NOIO, nvecs);
-		nvecs >>= 1;
-	} while (!bio);
+	struct bio		*bio = bio_alloc(GFP_NOIO, nvecs);
 
 	ASSERT(bio->bi_private == NULL);
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
-	bio_get(bio);
 	return bio;
 }
 
@@ -470,9 +462,8 @@ xfs_submit_ioend(
 	/* Pass 1 - start writeback */
 	do {
 		next = ioend->io_list;
-		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
+		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private)
 			xfs_start_buffer_writeback(bh);
-		}
 	} while ((ioend = next) != NULL);
 
 	/* Pass 2 - submit I/O */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
