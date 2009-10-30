Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U9943V174319 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 04:09:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E2A117FD6A0
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:09:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QIF23siPteMXJfQb for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:09:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N3nTv-00066O-Ln
	for xfs@oss.sgi.com; Fri, 30 Oct 2009 09:09:15 +0000
Date: Fri, 30 Oct 2009 05:09:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: use WRITE_SYNC_PLUG for synchronous writeout
Message-ID: <20091030090915.GA23188@infradead.org>
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

The VM and I/O schedulers now expect us to use WRITE_SYNC_PLUG for synchronous
writeout. Right now I can't see any changes in performance numbers with this,
but we're getting some beating for not using it, and the knowledge defintively
could help the block code to make better decisions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-24 10:08:36.622254197 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-24 10:18:27.803006347 +0200
@@ -412,8 +412,9 @@ xfs_end_bio(
 
 STATIC void
 xfs_submit_ioend_bio(
-	xfs_ioend_t	*ioend,
-	struct bio	*bio)
+	struct writeback_control *wbc,
+	xfs_ioend_t		*ioend,
+	struct bio		*bio)
 {
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
@@ -426,7 +427,8 @@ xfs_submit_ioend_bio(
 	if (xfs_ioend_new_eof(ioend))
 		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
 
-	submit_bio(WRITE, bio);
+	submit_bio(wbc->sync_mode == WB_SYNC_ALL ?
+		   WRITE_SYNC_PLUG : WRITE, bio);
 	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
 	bio_put(bio);
 }
@@ -505,6 +507,7 @@ static inline int bio_add_buffer(struct 
  */
 STATIC void
 xfs_submit_ioend(
+	struct writeback_control *wbc,
 	xfs_ioend_t		*ioend)
 {
 	xfs_ioend_t		*head = ioend;
@@ -533,19 +536,19 @@ xfs_submit_ioend(
  retry:
 				bio = xfs_alloc_ioend_bio(bh);
 			} else if (bh->b_blocknr != lastblock + 1) {
-				xfs_submit_ioend_bio(ioend, bio);
+				xfs_submit_ioend_bio(wbc, ioend, bio);
 				goto retry;
 			}
 
 			if (bio_add_buffer(bio, bh) != bh->b_size) {
-				xfs_submit_ioend_bio(ioend, bio);
+				xfs_submit_ioend_bio(wbc, ioend, bio);
 				goto retry;
 			}
 
 			lastblock = bh->b_blocknr;
 		}
 		if (bio)
-			xfs_submit_ioend_bio(ioend, bio);
+			xfs_submit_ioend_bio(wbc, ioend, bio);
 		xfs_finish_ioend(ioend, 0);
 	} while ((ioend = next) != NULL);
 }
@@ -1198,7 +1201,7 @@ xfs_page_state_convert(
 	}
 
 	if (iohead)
-		xfs_submit_ioend(iohead);
+		xfs_submit_ioend(wbc, iohead);
 
 	return page_dirty;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
