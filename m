Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 11:49:32 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OInOQ3015048
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 11:49:27 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8OInQA5020736
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 20:49:26 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8OInQI4020734
	for xfs@oss.sgi.com; Mon, 24 Sep 2007 20:49:26 +0200
Date: Mon, 24 Sep 2007 20:49:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill superflous buffer locking
Message-ID: <20070924184926.GA20661@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There is no need to lock any page in xfs_buf.c because we operate
on our own address_space and all locking is covered by the buffer
semaphore.  If we ever switch back to main blockdeive address_space
as suggested e.g. for fsblock with a similar scheme the locking will
have to be totally revised anyway because the current scheme is
neither correct nor coherent with itself.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-09-23 13:28:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c	2007-09-23 14:13:43.000000000 +0200
@@ -396,6 +396,7 @@ _xfs_buf_lookup_pages(
 			congestion_wait(WRITE, HZ/50);
 			goto retry;
 		}
+		unlock_page(page);
 
 		XFS_STATS_INC(xb_page_found);
 
@@ -405,10 +406,7 @@ _xfs_buf_lookup_pages(
 		ASSERT(!PagePrivate(page));
 		if (!PageUptodate(page)) {
 			page_count--;
-			if (blocksize >= PAGE_CACHE_SIZE) {
-				if (flags & XBF_READ)
-					bp->b_locked = 1;
-			} else if (!PagePrivate(page)) {
+			if (blocksize < PAGE_CACHE_SIZE && !PagePrivate(page)) {
 				if (test_page_region(page, offset, nbytes))
 					page_count++;
 			}
@@ -418,11 +416,6 @@ _xfs_buf_lookup_pages(
 		offset = 0;
 	}
 
-	if (!bp->b_locked) {
-		for (i = 0; i < bp->b_page_count; i++)
-			unlock_page(bp->b_pages[i]);
-	}
-
 	if (page_count == bp->b_page_count)
 		bp->b_flags |= XBF_DONE;
 
@@ -747,7 +740,6 @@ xfs_buf_associate_memory(
 		bp->b_page_count = ++i;
 		ptr += PAGE_CACHE_SIZE;
 	}
-	bp->b_locked = 0;
 
 	bp->b_count_desired = bp->b_buffer_length = len;
 	bp->b_flags |= XBF_MAPPED;
@@ -1093,25 +1085,13 @@ xfs_buf_iostart(
 	return status;
 }
 
-STATIC_INLINE int
-_xfs_buf_iolocked(
-	xfs_buf_t		*bp)
-{
-	ASSERT(bp->b_flags & (XBF_READ | XBF_WRITE));
-	if (bp->b_flags & XBF_READ)
-		return bp->b_locked;
-	return 0;
-}
-
 STATIC_INLINE void
 _xfs_buf_ioend(
 	xfs_buf_t		*bp,
 	int			schedule)
 {
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		bp->b_locked = 0;
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
 		xfs_buf_ioend(bp, schedule);
-	}
 }
 
 STATIC int
@@ -1146,10 +1126,6 @@ xfs_buf_bio_end_io(
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
-
-		if (_xfs_buf_iolocked(bp)) {
-			unlock_page(page);
-		}
 	} while (bvec >= bio->bi_io_vec);
 
 	_xfs_buf_ioend(bp, 1);
@@ -1161,13 +1137,12 @@ STATIC void
 _xfs_buf_ioapply(
 	xfs_buf_t		*bp)
 {
-	int			i, rw, map_i, total_nr_pages, nr_pages;
+	int			rw, map_i, total_nr_pages, nr_pages;
 	struct bio		*bio;
 	int			offset = bp->b_offset;
 	int			size = bp->b_count_desired;
 	sector_t		sector = bp->b_bn;
 	unsigned int		blocksize = bp->b_target->bt_bsize;
-	int			locking = _xfs_buf_iolocked(bp);
 
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
@@ -1190,7 +1165,7 @@ _xfs_buf_ioapply(
 	 * filesystem block size is not smaller than the page size.
 	 */
 	if ((bp->b_buffer_length < PAGE_CACHE_SIZE) &&
-	    (bp->b_flags & XBF_READ) && locking &&
+	    (bp->b_flags & XBF_READ) &&
 	    (blocksize >= PAGE_CACHE_SIZE)) {
 		bio = bio_alloc(GFP_NOIO, 1);
 
@@ -1207,24 +1182,6 @@ _xfs_buf_ioapply(
 		goto submit_io;
 	}
 
-	/* Lock down the pages which we need to for the request */
-	if (locking && (bp->b_flags & XBF_WRITE) && (bp->b_locked == 0)) {
-		for (i = 0; size; i++) {
-			int		nbytes = PAGE_CACHE_SIZE - offset;
-			struct page	*page = bp->b_pages[i];
-
-			if (nbytes > size)
-				nbytes = size;
-
-			lock_page(page);
-
-			size -= nbytes;
-			offset = 0;
-		}
-		offset = bp->b_offset;
-		size = bp->b_count_desired;
-	}
-
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
 	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2007-09-05 11:17:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.h	2007-09-23 14:04:36.000000000 +0200
@@ -143,7 +143,6 @@ typedef struct xfs_buf {
 	void			*b_fspriv2;
 	void			*b_fspriv3;
 	unsigned short		b_error;	/* error code on I/O */
-	unsigned short		b_locked;	/* page array is locked */
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	struct page		**b_pages;	/* array of page pointers */
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-09-23 13:33:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-09-23 14:04:36.000000000 +0200
@@ -2110,9 +2110,9 @@ print_xfs_buf(
 		   (unsigned long long) bp->b_file_offset,
 		   (unsigned long long) bp->b_buffer_length,
 		   bp->b_addr);
-	kdb_printf("  b_bn 0x%llx b_count_desired 0x%lx b_locked %d\n",
+	kdb_printf("  b_bn 0x%llx b_count_desired 0x%lxn",
 		   (unsigned long long)bp->b_bn,
-		   (unsigned long) bp->b_count_desired, (int)bp->b_locked);
+		   (unsigned long) bp->b_count_desired);
 	kdb_printf("  b_queuetime %ld (now=%ld/age=%ld) b_io_remaining %d\n",
 		   bp->b_queuetime, jiffies, bp->b_queuetime + age,
 		   bp->b_io_remaining.counter);
