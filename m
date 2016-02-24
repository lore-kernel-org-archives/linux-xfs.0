Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 859717CA2
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 02:20:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B209304051
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:20:27 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id vhe5vmLtXoJKhGTw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:20:22 -0800 (PST)
Received: from [88.128.80.14] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aYUgH-0004S9-BI
	for xfs@oss.sgi.com; Wed, 24 Feb 2016 08:20:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback path
Date: Wed, 24 Feb 2016 09:20:11 +0100
Message-Id: <1456302011-18915-4-git-send-email-hch@lst.de>
In-Reply-To: <1456302011-18915-1-git-send-email-hch@lst.de>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
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

This patch implements two closely related changes:  First it embedds a
bio the ioend structure so that we don't have to allocate one separately.
Second it uses the block layer bio chaining mechanism to chain additional
bios off this first one if needed instead of manually accouting for
multiple bio completions in the ioend structure.  Together this removes a
memory allocation per ioend and greatly simplifies the ioend setup and
I/O completion path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 217 ++++++++++++++++++++---------------------------------
 fs/xfs/xfs_aops.h  |  15 ++--
 fs/xfs/xfs_super.c |  26 ++-----
 3 files changed, 93 insertions(+), 165 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index fc4fed6..1ea4167 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -118,17 +118,15 @@ next_bh:
  */
 STATIC void
 xfs_destroy_ioend(
-	struct xfs_ioend	*ioend)
+	struct xfs_ioend	*ioend,
+	int			error)
 {
-	struct bio		*bio, *next;
+	struct bio		*bio, *next, *last = ioend->io_bio;
 
-	for (bio = ioend->io_bio_done; bio; bio = next) {
+	for (bio = &ioend->io_inline_bio; bio; bio = next) {
 		struct bio_vec	*bvec;
 		int		i;
 
-		next = bio->bi_private;
-		bio->bi_private = NULL;
-
 		/* walk each page on bio, ending page IO on them */
 		bio_for_each_segment_all(bvec, bio, i) {
 			struct page	*page = bvec->bv_page;
@@ -138,17 +136,21 @@ xfs_destroy_ioend(
 			ASSERT(off < PAGE_SIZE);
 			ASSERT(end_off <= PAGE_SIZE);
 
-			xfs_finish_page_writeback(page, off, end_off,
-						  ioend->io_error);
-
+			xfs_finish_page_writeback(page, off, end_off, error);
 		}
+
+		/*
+		 * For the last bio, bi_private points to the ioend, so we
+		 * need to explicitly end the iteration here.
+		 */
+		if (bio == last)
+			next = NULL;
+		else
+			next = bio->bi_private;
 		bio_put(bio);
 	}
-
-	mempool_free(ioend, xfs_ioend_pool);
 }
 
-
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -220,7 +222,8 @@ xfs_setfilesize(
 
 STATIC int
 xfs_setfilesize_ioend(
-	struct xfs_ioend	*ioend)
+	struct xfs_ioend	*ioend,
+	int			error)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_trans	*tp = ioend->io_append_trans;
@@ -234,53 +237,32 @@ xfs_setfilesize_ioend(
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
-	if (ioend->io_error) {
+	if (error) {
 		xfs_trans_cancel(tp);
-		return ioend->io_error;
+		return error;
 	}
 
 	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
 }
 
 /*
- * Schedule IO completion handling on the final put of an ioend.
- *
- * If there is no work to do we might as well call it a day and free the
- * ioend right now.
- */
-STATIC void
-xfs_finish_ioend(
-	struct xfs_ioend	*ioend)
-{
-	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
-
-		if (ioend->io_type == XFS_IO_UNWRITTEN)
-			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
-		else if (ioend->io_append_trans)
-			queue_work(mp->m_data_workqueue, &ioend->io_work);
-		else
-			xfs_destroy_ioend(ioend);
-	}
-}
-
-/*
  * IO write completion.
  */
 STATIC void
 xfs_end_io(
 	struct work_struct *work)
 {
-	xfs_ioend_t	*ioend = container_of(work, xfs_ioend_t, io_work);
-	struct xfs_inode *ip = XFS_I(ioend->io_inode);
-	int		error = 0;
+	struct xfs_ioend	*ioend =
+		container_of(work, struct xfs_ioend, io_work);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	int			error = ioend->io_bio->bi_error;
 
 	/*
 	 * Set an error if the mount has shut down and proceed with end I/O
 	 * processing so it can perform whatever cleanups are necessary.
 	 */
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		ioend->io_error = -EIO;
+		error = -EIO;
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
@@ -290,50 +272,33 @@ xfs_end_io(
 	 * on error.
 	 */
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
-		if (ioend->io_error)
+		if (error)
 			goto done;
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						  ioend->io_size);
 	} else if (ioend->io_append_trans) {
-		error = xfs_setfilesize_ioend(ioend);
+		error = xfs_setfilesize_ioend(ioend, error);
 	} else {
 		ASSERT(!xfs_ioend_is_append(ioend));
 	}
 
 done:
-	if (error)
-		ioend->io_error = error;
-	xfs_destroy_ioend(ioend);
+	xfs_destroy_ioend(ioend, error);
 }
 
-/*
- * Allocate and initialise an IO completion structure.
- * We need to track unwritten extent write completion here initially.
- * We'll need to extend this for updating the ondisk inode size later
- * (vs. incore size).
- */
-STATIC xfs_ioend_t *
-xfs_alloc_ioend(
-	struct inode		*inode,
-	unsigned int		type)
+STATIC void
+xfs_end_bio(
+	struct bio		*bio)
 {
-	xfs_ioend_t		*ioend;
-
-	ioend = mempool_alloc(xfs_ioend_pool, GFP_NOFS);
-	memset(ioend, 0, sizeof(*ioend));
+	struct xfs_ioend	*ioend = bio->bi_private;
+	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
 
-	/*
-	 * Set the count to 1 initially, which will prevent an I/O
-	 * completion callback from happening before we have started
-	 * all the I/O from calling the completion routine too early.
-	 */
-	atomic_set(&ioend->io_remaining, 1);
-	INIT_LIST_HEAD(&ioend->io_list);
-	ioend->io_type = type;
-	ioend->io_inode = inode;
-	INIT_WORK(&ioend->io_work, xfs_end_io);
-	spin_lock_init(&ioend->io_lock);
-	return ioend;
+	if (ioend->io_type == XFS_IO_UNWRITTEN)
+		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
+	else if (ioend->io_append_trans)
+		queue_work(mp->m_data_workqueue, &ioend->io_work);
+	else
+		xfs_destroy_ioend(ioend, bio->bi_error);
 }
 
 STATIC int
@@ -405,56 +370,6 @@ xfs_imap_valid(
 		offset < imap->br_startoff + imap->br_blockcount;
 }
 
-/*
- * BIO completion handler for buffered IO.
- */
-STATIC void
-xfs_end_bio(
-	struct bio		*bio)
-{
-	struct xfs_ioend	*ioend = bio->bi_private;
-	unsigned long		flags;
-
-	bio->bi_private = NULL;
-	bio->bi_end_io = NULL;
-
-	spin_lock_irqsave(&ioend->io_lock, flags);
-	if (!ioend->io_error)
-	       ioend->io_error = bio->bi_error;
-	if (!ioend->io_bio_done)
-		ioend->io_bio_done = bio;
-	else
-		ioend->io_bio_done_tail->bi_private = bio;
-	ioend->io_bio_done_tail = bio;
-	spin_unlock_irqrestore(&ioend->io_lock, flags);
-
-	xfs_finish_ioend(ioend);
-}
-
-STATIC void
-xfs_submit_ioend_bio(
-	struct writeback_control *wbc,
-	xfs_ioend_t		*ioend,
-	struct bio		*bio)
-{
-	atomic_inc(&ioend->io_remaining);
-	bio->bi_private = ioend;
-	bio->bi_end_io = xfs_end_bio;
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
-}
-
-STATIC struct bio *
-xfs_alloc_ioend_bio(
-	struct buffer_head	*bh)
-{
-	struct bio		*bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
-
-	ASSERT(bio->bi_private == NULL);
-	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-	bio->bi_bdev = bh->b_bdev;
-	return bio;
-}
-
 STATIC void
 xfs_start_buffer_writeback(
 	struct buffer_head	*bh)
@@ -515,10 +430,10 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
 STATIC int
 xfs_submit_ioend(
 	struct writeback_control *wbc,
-	xfs_ioend_t		*ioend,
+	struct xfs_ioend	*ioend,
 	int			status)
 {
-	if (!ioend->io_bio || status)
+	if (status)
 		goto error_finish;
 
 	/* Reserve log space if we might write beyond the on-disk inode size. */
@@ -529,9 +444,10 @@ xfs_submit_ioend(
 			goto error_finish;
 	}
 
-	xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
-	ioend->io_bio = NULL;
-	xfs_finish_ioend(ioend);
+	ioend->io_bio->bi_private = ioend;
+	ioend->io_bio->bi_end_io = xfs_end_bio;
+	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE,
+			ioend->io_bio);
 	return 0;
 
 	/*
@@ -541,10 +457,8 @@ xfs_submit_ioend(
 	 * at this point in time.
 	 */
 error_finish:
-	if (ioend->io_bio)
-		bio_put(ioend->io_bio);
-	ioend->io_error = status;
-	xfs_finish_ioend(ioend);
+	ioend->io_bio->bi_error = status;
+	bio_endio(ioend->io_bio);
 	return status;
 }
 
@@ -565,22 +479,51 @@ xfs_add_to_ioend(
 	struct list_head	*iolist)
 {
 	struct xfs_ioend	*ioend = wpc->ioend;
+	struct bio		*new;
 
 	if (!ioend || wpc->io_type != ioend->io_type ||
 	    bh->b_blocknr != wpc->last_block + 1) {
+		new = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES,
+					xfs_ioend_bioset);
+		new->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+		new->bi_bdev = bh->b_bdev;
+	
 		if (ioend)
 			list_add(&ioend->io_list, iolist);
-		ioend = wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type);
+
+		ioend = container_of(new, struct xfs_ioend, io_inline_bio);
+		INIT_LIST_HEAD(&ioend->io_list);
+		ioend->io_type = wpc->io_type;
+		ioend->io_inode = inode;
+		ioend->io_size = 0;
 		ioend->io_offset = offset;
+		INIT_WORK(&ioend->io_work, xfs_end_io);
+		ioend->io_append_trans = NULL;
+		ioend->io_bio = new;
+
+		wpc->ioend = ioend;
 	}
 
 retry:
-	if (!ioend->io_bio)
-		ioend->io_bio = xfs_alloc_ioend_bio(bh);
-
 	if (xfs_bio_add_buffer(ioend->io_bio, bh) != bh->b_size) {
-		xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
-		ioend->io_bio = NULL;
+		/*
+		 * No space left in the bio.
+		 *
+		 * Allocate a new one, and chain the old bio to the new one.
+		 * Note that we have to do perform the chaining in this
+		 * unintuitive order so that the bi_private linkage is set up
+		 * in the right direction for the traversal in
+		 * xfs_destroy_ioend().
+		 */
+		new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
+		new->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+		new->bi_bdev = bh->b_bdev;
+
+		bio_chain(ioend->io_bio, new);
+		bio_get(ioend->io_bio);	/* for xfs_destroy_ioend */
+		submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE,
+				ioend->io_bio);
+		ioend->io_bio = new;
 		goto retry;
 	}
 
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 1c7b041..8b5b641 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
-extern mempool_t *xfs_ioend_pool;
+extern struct bio_set *xfs_ioend_bioset;
 
 /*
  * Types of I/O for bmap clustering and I/O completion tracking.
@@ -37,24 +37,19 @@ enum {
 	{ XFS_IO_OVERWRITE,		"overwrite" }
 
 /*
- * xfs_ioend struct manages large extent writes for XFS.
- * It can manage several multi-page bio's at once.
+ * Structure for buffered I/O completions.
  */
-typedef struct xfs_ioend {
+struct xfs_ioend {
 	struct list_head	io_list;	/* next ioend in chain */
 	unsigned int		io_type;	/* delalloc / unwritten */
-	int			io_error;	/* I/O error code */
-	atomic_t		io_remaining;	/* hold count */
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
 	struct bio		*io_bio;	/* bio being built */
-	struct bio		*io_bio_done;	/* bios completed */
-	struct bio		*io_bio_done_tail; /* bios completed */
-	spinlock_t		io_lock;	/* for bio completion list */
-} xfs_ioend_t;
+	struct bio		io_inline_bio;	/* MUST BE LAST! */
+};
 
 extern const struct address_space_operations xfs_address_space_operations;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 59c9b7b..33aa638 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -57,8 +57,7 @@
 #include <linux/parser.h>
 
 static const struct super_operations xfs_super_operations;
-static kmem_zone_t *xfs_ioend_zone;
-mempool_t *xfs_ioend_pool;
+struct bio_set *xfs_ioend_bioset;
 
 static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 #ifdef DEBUG
@@ -1646,20 +1645,15 @@ MODULE_ALIAS_FS("xfs");
 STATIC int __init
 xfs_init_zones(void)
 {
-
-	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
-	if (!xfs_ioend_zone)
+	xfs_ioend_bioset = bioset_create(4 * MAX_BUF_PER_PAGE,
+			offsetof(struct xfs_ioend, io_inline_bio));
+	if (!xfs_ioend_bioset)
 		goto out;
 
-	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
-						  xfs_ioend_zone);
-	if (!xfs_ioend_pool)
-		goto out_destroy_ioend_zone;
-
 	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
 						"xfs_log_ticket");
 	if (!xfs_log_ticket_zone)
-		goto out_destroy_ioend_pool;
+		goto out_free_ioend_bioset;
 
 	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
 						"xfs_bmap_free_item");
@@ -1755,10 +1749,8 @@ xfs_init_zones(void)
 	kmem_zone_destroy(xfs_bmap_free_item_zone);
  out_destroy_log_ticket_zone:
 	kmem_zone_destroy(xfs_log_ticket_zone);
- out_destroy_ioend_pool:
-	mempool_destroy(xfs_ioend_pool);
- out_destroy_ioend_zone:
-	kmem_zone_destroy(xfs_ioend_zone);
+ out_free_ioend_bioset:
+ 	bioset_free(xfs_ioend_bioset);
  out:
 	return -ENOMEM;
 }
@@ -1784,9 +1776,7 @@ xfs_destroy_zones(void)
 	kmem_zone_destroy(xfs_btree_cur_zone);
 	kmem_zone_destroy(xfs_bmap_free_item_zone);
 	kmem_zone_destroy(xfs_log_ticket_zone);
-	mempool_destroy(xfs_ioend_pool);
-	kmem_zone_destroy(xfs_ioend_zone);
-
+ 	bioset_free(xfs_ioend_bioset);
 }
 
 STATIC int __init
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
