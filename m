Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 021A07CED
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53C4BAC009
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:44:47 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id oWcDJiEqz53skbWR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:44:44 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: build bios directly in xfs_add_to_ioend
Date: Wed, 16 Mar 2016 12:44:39 +0100
Message-Id: <1458128681-10869-2-git-send-email-hch@lst.de>
In-Reply-To: <1458128681-10869-1-git-send-email-hch@lst.de>
References: <1458128681-10869-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>

Currently adding a buffer to the ioend and then building a bio from
the buffer list are two separate operations. We don't build the bios
and submit them until the ioend is submitted, and this places a
fixed dependency on bufferhead chaining in the ioend.

The first step to removing the bufferhead chaining in the ioend is
on the IO submission side. We can build the bio directly as we add
the buffers to the ioend chain, thereby removing the need for a
latter "buffer-to-bio" submission loop. This allows us to submit
bios on large ioends as soon as we cannot add more data to the bio.

These bios then get captured by the active plug, and hence will be
dispatched as soon as either the plug overflows or we schedule away
from the writeback context. This will reduce submission latency for
large IOs, but will also allow more timely request queue based
writeback blocking when the device becomes congested.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: various small updates]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 69 +++++++++++++++++++++++++------------------------------
 fs/xfs/xfs_aops.h |  1 +
 2 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 75a39a8..17cc6cc 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -274,6 +274,7 @@ xfs_alloc_ioend(
 	xfs_ioend_t		*ioend;
 
 	ioend = mempool_alloc(xfs_ioend_pool, GFP_NOFS);
+	memset(ioend, 0, sizeof(*ioend));
 
 	/*
 	 * Set the count to 1 initially, which will prevent an I/O
@@ -281,16 +282,9 @@ xfs_alloc_ioend(
 	 * all the I/O from calling the completion routine too early.
 	 */
 	atomic_set(&ioend->io_remaining, 1);
-	ioend->io_error = 0;
 	INIT_LIST_HEAD(&ioend->io_list);
 	ioend->io_type = type;
 	ioend->io_inode = inode;
-	ioend->io_buffer_head = NULL;
-	ioend->io_buffer_tail = NULL;
-	ioend->io_offset = 0;
-	ioend->io_size = 0;
-	ioend->io_append_trans = NULL;
-
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
 }
@@ -452,13 +446,18 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
 }
 
 /*
- * Submit all of the bios for an ioend. We are only passed a single ioend at a
- * time; the caller is responsible for chaining prior to submission.
+ * Submit the bio for an ioend. We are passed an ioend with a bio attached to
+ * it, and we submit that bio. The ioend may be used for multiple bio
+ * submissions, so we only want to allocate an append transaction for the ioend
+ * once. In the case of multiple bio submission, each bio will take an IO
+ * reference to the ioend to ensure that the ioend completion is only done once
+ * all bios have been submitted and the ioend is really done.
  *
  * If @fail is non-zero, it means that we have a situation where some part of
  * the submission process has failed after we have marked paged for writeback
- * and unlocked them. In this situation, we need to fail the ioend chain rather
- * than submit it to IO. This typically only happens on a filesystem shutdown.
+ * and unlocked them. In this situation, we need to fail the bio and ioend
+ * rather than submit it to IO. This typically only happens on a filesystem
+ * shutdown.
  */
 STATIC int
 xfs_submit_ioend(
@@ -466,14 +465,13 @@ xfs_submit_ioend(
 	xfs_ioend_t		*ioend,
 	int			status)
 {
-	struct buffer_head	*bh;
-	struct bio		*bio;
-	sector_t		lastblock = 0;
-
 	/* Reserve log space if we might write beyond the on-disk inode size. */
 	if (!status &&
-	     ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
+	    ioend->io_bio && ioend->io_type != XFS_IO_UNWRITTEN &&
+	    xfs_ioend_is_append(ioend) &&
+	    !ioend->io_append_trans)
 		status = xfs_setfilesize_trans_alloc(ioend);
+
 	/*
 	 * If we are failing the IO now, just mark the ioend with an
 	 * error and finish it. This will run IO completion immediately
@@ -481,31 +479,15 @@ xfs_submit_ioend(
 	 * time.
 	 */
 	if (status) {
+		if (ioend->io_bio)
+			bio_put(ioend->io_bio);
 		ioend->io_error = status;
 		xfs_finish_ioend(ioend);
 		return status;
 	}
 
-	bio = NULL;
-	for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
-
-		if (!bio) {
-retry:
-			bio = xfs_alloc_ioend_bio(bh);
-		} else if (bh->b_blocknr != lastblock + 1) {
-			xfs_submit_ioend_bio(wbc, ioend, bio);
-			goto retry;
-		}
-
-		if (xfs_bio_add_buffer(bio, bh) != bh->b_size) {
-			xfs_submit_ioend_bio(wbc, ioend, bio);
-			goto retry;
-		}
-
-		lastblock = bh->b_blocknr;
-	}
-	if (bio)
-		xfs_submit_ioend_bio(wbc, ioend, bio);
+	xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
+	ioend->io_bio = NULL;
 	xfs_finish_ioend(ioend);
 	return 0;
 }
@@ -523,6 +505,7 @@ xfs_add_to_ioend(
 	struct buffer_head	*bh,
 	xfs_off_t		offset,
 	struct xfs_writepage_ctx *wpc,
+	struct writeback_control *wbc,
 	struct list_head	*iolist)
 {
 	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
@@ -542,8 +525,18 @@ xfs_add_to_ioend(
 		wpc->ioend->io_buffer_tail->b_private = bh;
 		wpc->ioend->io_buffer_tail = bh;
 	}
-
 	bh->b_private = NULL;
+
+retry:
+	if (!wpc->ioend->io_bio)
+		wpc->ioend->io_bio = xfs_alloc_ioend_bio(bh);
+
+	if (xfs_bio_add_buffer(wpc->ioend->io_bio, bh) != bh->b_size) {
+		xfs_submit_ioend_bio(wbc, wpc->ioend, wpc->ioend->io_bio);
+		wpc->ioend->io_bio = NULL;
+		goto retry;
+	}
+
 	wpc->ioend->io_size += bh->b_size;
 	wpc->last_block = bh->b_blocknr;
 	xfs_start_buffer_writeback(bh);
@@ -803,7 +796,7 @@ xfs_writepage_map(
 			lock_buffer(bh);
 			if (wpc->io_type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, wpc, &submit_list);
+			xfs_add_to_ioend(inode, bh, offset, wpc, wbc, &submit_list);
 			count++;
 		}
 
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 4e01bd5..c89c3bd 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -52,6 +52,7 @@ typedef struct xfs_ioend {
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
+	struct bio		*io_bio;	/* bio being built */
 } xfs_ioend_t;
 
 extern const struct address_space_operations xfs_address_space_operations;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
