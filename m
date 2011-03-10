Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2A12MmB071634 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 19:02:28 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 819A51310069
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 17:05:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3FrbWTjqxCitEqlF for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 17:05:09 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: stop using the page cache to back the buffer cache
Date: Thu, 10 Mar 2011 12:05:04 +1100
Message-Id: <1299719104-11961-1-git-send-email-david@fromorbit.com>
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
Cc: chris.mason@oracle.com

From: Dave Chinner <dchinner@redhat.com>

Now that the buffer cache has it's own LRU, we do not need to use
the page cache to provide persistent caching and reclaim
infrastructure. Convert the buffer cache to use alloc_pages()
instead of the page cache. This will remove all the overhead of page
cache management from setup and teardown of the buffers, as well as
needing to mark pages accessed as we find buffers in the buffer
cache.

By avoiding the page cache, we also remove the need to keep state in
the page_private(page) field for persistant storage across buffer
free/buffer rebuild and so all that code can be removed. This also
fixes the long-standing problem of not having enough bits in the
page_private field to track all the state needed for a 512
sector/64k page setup.

It also removes the need for page locking during reads as the pages
are unique to the buffer and nobody else will be attempting to
access them.

Finally, it removes the buftarg address space lock as a point of
global contention on workloads that allocate and free buffers
quickly such as when creating or removing large numbers of inodes in
parallel. This remove the 16TB limit on filesystem size on 32 bit
machines as the page index (32 bit) is no longer used for lookups
of metadata buffers - the buffer cache is now solely indexed by disk
address which is stored in a 64 bit field in the buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |  337 ++++++++++----------------------------------
 fs/xfs/linux-2.6/xfs_buf.h |   40 +-----
 2 files changed, 81 insertions(+), 296 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index a5a260f..332b76b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -94,75 +94,6 @@ xfs_buf_vmap_len(
 }
 
 /*
- *	Page Region interfaces.
- *
- *	For pages in filesystems where the blocksize is smaller than the
- *	pagesize, we use the page->private field (long) to hold a bitmap
- * 	of uptodate regions within the page.
- *
- *	Each such region is "bytes per page / bits per long" bytes long.
- *
- *	NBPPR == number-of-bytes-per-page-region
- *	BTOPR == bytes-to-page-region (rounded up)
- *	BTOPRT == bytes-to-page-region-truncated (rounded down)
- */
-#if (BITS_PER_LONG == 32)
-#define PRSHIFT		(PAGE_CACHE_SHIFT - 5)	/* (32 == 1<<5) */
-#elif (BITS_PER_LONG == 64)
-#define PRSHIFT		(PAGE_CACHE_SHIFT - 6)	/* (64 == 1<<6) */
-#else
-#error BITS_PER_LONG must be 32 or 64
-#endif
-#define NBPPR		(PAGE_CACHE_SIZE/BITS_PER_LONG)
-#define BTOPR(b)	(((unsigned int)(b) + (NBPPR - 1)) >> PRSHIFT)
-#define BTOPRT(b)	(((unsigned int)(b) >> PRSHIFT))
-
-STATIC unsigned long
-page_region_mask(
-	size_t		offset,
-	size_t		length)
-{
-	unsigned long	mask;
-	int		first, final;
-
-	first = BTOPR(offset);
-	final = BTOPRT(offset + length - 1);
-	first = min(first, final);
-
-	mask = ~0UL;
-	mask <<= BITS_PER_LONG - (final - first);
-	mask >>= BITS_PER_LONG - (final);
-
-	ASSERT(offset + length <= PAGE_CACHE_SIZE);
-	ASSERT((final - first) < BITS_PER_LONG && (final - first) >= 0);
-
-	return mask;
-}
-
-STATIC void
-set_page_region(
-	struct page	*page,
-	size_t		offset,
-	size_t		length)
-{
-	set_page_private(page,
-		page_private(page) | page_region_mask(offset, length));
-	if (page_private(page) == ~0UL)
-		SetPageUptodate(page);
-}
-
-STATIC int
-test_page_region(
-	struct page	*page,
-	size_t		offset,
-	size_t		length)
-{
-	unsigned long	mask = page_region_mask(offset, length);
-
-	return (mask && (page_private(page) & mask) == mask);
-}
-
-/*
  * xfs_buf_lru_add - add a buffer to the LRU.
  *
  * The LRU takes a new reference to the buffer so that it will only be freed
@@ -332,7 +263,7 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
+	if (bp->b_flags & _XBF_PAGES) {
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
@@ -342,25 +273,22 @@ xfs_buf_free(
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			if (bp->b_flags & _XBF_PAGE_CACHE)
-				ASSERT(!PagePrivate(page));
-			page_cache_release(page);
+			__free_page(page);
 		}
-	}
+	} else if (bp->b_flags & _XBF_KMEM)
+		kmem_free(bp->b_addr);
 	_xfs_buf_free_pages(bp);
 	xfs_buf_deallocate(bp);
 }
 
 /*
- *	Finds all pages for buffer in question and builds it's page list.
+ * Allocates all the pages for buffer in question and builds it's page list.
  */
 STATIC int
-_xfs_buf_lookup_pages(
+xfs_buf_allocate_memory(
 	xfs_buf_t		*bp,
 	uint			flags)
 {
-	struct address_space	*mapping = bp->b_target->bt_mapping;
-	size_t			blocksize = bp->b_target->bt_bsize;
 	size_t			size = bp->b_count_desired;
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
@@ -369,29 +297,55 @@ _xfs_buf_lookup_pages(
 	xfs_off_t		end;
 	int			error;
 
+	/*
+	 * for buffers that are contained within a single page, just allocate
+	 * the memory from the heap - there's no need for the complexity of
+	 * page arrays to keep allocation down to order 0.
+	 */
+	if (bp->b_buffer_length < PAGE_SIZE) {
+		bp->b_addr = kmem_alloc(bp->b_buffer_length, xb_to_km(flags));
+		if (!bp->b_addr) {
+			/* low memory - use alloc_page loop instead */
+			goto use_alloc_page;
+		}
+
+		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
+								PAGE_MASK) !=
+		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
+			/* b_addr spans two pages - use alloc_page instead */
+			kmem_free(bp->b_addr);
+			bp->b_addr = NULL;
+			goto use_alloc_page;
+		}
+		bp->b_offset = offset_in_page(bp->b_addr);
+		bp->b_pages = bp->b_page_array;
+		bp->b_pages[0] = virt_to_page(bp->b_addr);
+		bp->b_page_count = 1;
+		bp->b_flags |= XBF_MAPPED | _XBF_KMEM;
+		return 0;
+	}
+
+use_alloc_page:
 	end = bp->b_file_offset + bp->b_buffer_length;
 	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
-
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
 		return error;
-	bp->b_flags |= _XBF_PAGE_CACHE;
 
 	offset = bp->b_offset;
-	first = bp->b_file_offset >> PAGE_CACHE_SHIFT;
+	first = bp->b_file_offset >> PAGE_SHIFT;
+	bp->b_flags |= _XBF_PAGES;
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		struct page	*page;
 		uint		retries = 0;
-
-	      retry:
-		page = find_or_create_page(mapping, first + i, gfp_mask);
+retry:
+		page = alloc_page(gfp_mask);
 		if (unlikely(page == NULL)) {
 			if (flags & XBF_READ_AHEAD) {
 				bp->b_page_count = i;
-				for (i = 0; i < bp->b_page_count; i++)
-					unlock_page(bp->b_pages[i]);
-				return -ENOMEM;
+				error = ENOMEM;
+				goto out_free_pages;
 			}
 
 			/*
@@ -412,33 +366,16 @@ _xfs_buf_lookup_pages(
 
 		XFS_STATS_INC(xb_page_found);
 
-		nbytes = min_t(size_t, size, PAGE_CACHE_SIZE - offset);
+		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
 		size -= nbytes;
-
-		ASSERT(!PagePrivate(page));
-		if (!PageUptodate(page)) {
-			page_count--;
-			if (blocksize >= PAGE_CACHE_SIZE) {
-				if (flags & XBF_READ)
-					bp->b_flags |= _XBF_PAGE_LOCKED;
-			} else if (!PagePrivate(page)) {
-				if (test_page_region(page, offset, nbytes))
-					page_count++;
-			}
-		}
-
 		bp->b_pages[i] = page;
 		offset = 0;
 	}
+	return 0;
 
-	if (!(bp->b_flags & _XBF_PAGE_LOCKED)) {
-		for (i = 0; i < bp->b_page_count; i++)
-			unlock_page(bp->b_pages[i]);
-	}
-
-	if (page_count == bp->b_page_count)
-		bp->b_flags |= XBF_DONE;
-
+out_free_pages:
+	for (i = 0; i < bp->b_page_count; i++)
+		__free_page(bp->b_pages[i]);
 	return error;
 }
 
@@ -450,8 +387,9 @@ _xfs_buf_map_pages(
 	xfs_buf_t		*bp,
 	uint			flags)
 {
-	/* A single page buffer is always mappable */
+	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
+		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
@@ -576,9 +514,14 @@ found:
 		}
 	}
 
+	/*
+	 * if the buffer is stale, clear all the external state associated with
+	 * it. We need to keep flags such as how we allocated the buffer memory
+	 * intact here.
+	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= XBF_MAPPED;
+		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
 	}
 
 	trace_xfs_buf_find(bp, flags, _RET_IP_);
@@ -599,7 +542,7 @@ xfs_buf_get(
 	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp, *new_bp;
-	int			error = 0, i;
+	int			error = 0;
 
 	new_bp = xfs_buf_allocate(flags);
 	if (unlikely(!new_bp))
@@ -607,7 +550,7 @@ xfs_buf_get(
 
 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
 	if (bp == new_bp) {
-		error = _xfs_buf_lookup_pages(bp, flags);
+		error = xfs_buf_allocate_memory(bp, flags);
 		if (error)
 			goto no_buffer;
 	} else {
@@ -616,9 +559,6 @@ xfs_buf_get(
 			return NULL;
 	}
 
-	for (i = 0; i < bp->b_page_count; i++)
-		mark_page_accessed(bp->b_pages[i]);
-
 	if (!(bp->b_flags & XBF_MAPPED)) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
@@ -719,7 +659,7 @@ xfs_buf_readahead(
 {
 	struct backing_dev_info *bdi;
 
-	bdi = target->bt_mapping->backing_dev_info;
+	bdi = blk_get_backing_dev_info(target->bt_bdev);
 	if (bdi_read_congested(bdi))
 		return;
 
@@ -798,10 +738,10 @@ xfs_buf_associate_memory(
 	size_t			buflen;
 	int			page_count;
 
-	pageaddr = (unsigned long)mem & PAGE_CACHE_MASK;
+	pageaddr = (unsigned long)mem & PAGE_MASK;
 	offset = (unsigned long)mem - pageaddr;
-	buflen = PAGE_CACHE_ALIGN(len + offset);
-	page_count = buflen >> PAGE_CACHE_SHIFT;
+	buflen = PAGE_ALIGN(len + offset);
+	page_count = buflen >> PAGE_SHIFT;
 
 	/* Free any previous set of page pointers */
 	if (bp->b_pages)
@@ -818,13 +758,12 @@ xfs_buf_associate_memory(
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		bp->b_pages[i] = mem_to_page((void *)pageaddr);
-		pageaddr += PAGE_CACHE_SIZE;
+		pageaddr += PAGE_SIZE;
 	}
 
 	bp->b_count_desired = len;
 	bp->b_buffer_length = buflen;
 	bp->b_flags |= XBF_MAPPED;
-	bp->b_flags &= ~_XBF_PAGE_LOCKED;
 
 	return 0;
 }
@@ -931,20 +870,7 @@ xfs_buf_rele(
 
 
 /*
- *	Mutual exclusion on buffers.  Locking model:
- *
- *	Buffers associated with inodes for which buffer locking
- *	is not enabled are not protected by semaphores, and are
- *	assumed to be exclusively owned by the caller.  There is a
- *	spinlock in the buffer, used by the caller when concurrent
- *	access is possible.
- */
-
-/*
- *	Locks a buffer object, if it is not already locked.  Note that this in
- *	no way locks the underlying pages, so it is only useful for
- *	synchronizing concurrent use of buffer objects, not for synchronizing
- *	independent access to the underlying pages.
+ *	Lock a buffer object, if it is not already locked.
  *
  *	If we come across a stale, pinned, locked buffer, we know that we are
  *	being asked to lock a buffer that has been reallocated. Because it is
@@ -978,10 +904,7 @@ xfs_buf_lock_value(
 }
 
 /*
- *	Locks a buffer object.
- *	Note that this in no way locks the underlying pages, so it is only
- *	useful for synchronizing concurrent use of buffer objects, not for
- *	synchronizing independent access to the underlying pages.
+ *	Lock a buffer object.
  *
  *	If we come across a stale, pinned, locked buffer, we know that we
  *	are being asked to lock a buffer that has been reallocated. Because
@@ -998,7 +921,7 @@ xfs_buf_lock(
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 
@@ -1043,7 +966,7 @@ xfs_buf_wait_unpin(
 		if (atomic_read(&bp->b_pin_count) == 0)
 			break;
 		if (atomic_read(&bp->b_io_remaining))
-			blk_run_address_space(bp->b_target->bt_mapping);
+			blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 		schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
@@ -1256,10 +1179,8 @@ _xfs_buf_ioend(
 	xfs_buf_t		*bp,
 	int			schedule)
 {
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		bp->b_flags &= ~_XBF_PAGE_LOCKED;
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
 		xfs_buf_ioend(bp, schedule);
-	}
 }
 
 STATIC void
@@ -1268,35 +1189,12 @@ xfs_buf_bio_end_io(
 	int			error)
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
-	unsigned int		blocksize = bp->b_target->bt_bsize;
-	struct bio_vec		*bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 
 	xfs_buf_ioerror(bp, -error);
 
 	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	do {
-		struct page	*page = bvec->bv_page;
-
-		ASSERT(!PagePrivate(page));
-		if (unlikely(bp->b_error)) {
-			if (bp->b_flags & XBF_READ)
-				ClearPageUptodate(page);
-		} else if (blocksize >= PAGE_CACHE_SIZE) {
-			SetPageUptodate(page);
-		} else if (!PagePrivate(page) &&
-				(bp->b_flags & _XBF_PAGE_CACHE)) {
-			set_page_region(page, bvec->bv_offset, bvec->bv_len);
-		}
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (bp->b_flags & _XBF_PAGE_LOCKED)
-			unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
-
 	_xfs_buf_ioend(bp, 1);
 	bio_put(bio);
 }
@@ -1310,7 +1208,6 @@ _xfs_buf_ioapply(
 	int			offset = bp->b_offset;
 	int			size = bp->b_count_desired;
 	sector_t		sector = bp->b_bn;
-	unsigned int		blocksize = bp->b_target->bt_bsize;
 
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
@@ -1331,29 +1228,6 @@ _xfs_buf_ioapply(
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
 	}
 
-	/* Special code path for reading a sub page size buffer in --
-	 * we populate up the whole page, and hence the other metadata
-	 * in the same page.  This optimization is only valid when the
-	 * filesystem block size is not smaller than the page size.
-	 */
-	if ((bp->b_buffer_length < PAGE_CACHE_SIZE) &&
-	    ((bp->b_flags & (XBF_READ|_XBF_PAGE_LOCKED)) ==
-	      (XBF_READ|_XBF_PAGE_LOCKED)) &&
-	    (blocksize >= PAGE_CACHE_SIZE)) {
-		bio = bio_alloc(GFP_NOIO, 1);
-
-		bio->bi_bdev = bp->b_target->bt_bdev;
-		bio->bi_sector = sector - (offset >> BBSHIFT);
-		bio->bi_end_io = xfs_buf_bio_end_io;
-		bio->bi_private = bp;
-
-		bio_add_page(bio, bp->b_pages[0], PAGE_CACHE_SIZE, 0);
-		size = 0;
-
-		atomic_inc(&bp->b_io_remaining);
-
-		goto submit_io;
-	}
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
@@ -1367,8 +1241,9 @@ next_chunk:
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
+
 	for (; size && nr_pages; nr_pages--, map_i++) {
-		int	rbytes, nbytes = PAGE_CACHE_SIZE - offset;
+		int	rbytes, nbytes = PAGE_SIZE - offset;
 
 		if (nbytes > size)
 			nbytes = size;
@@ -1383,7 +1258,6 @@ next_chunk:
 		total_nr_pages--;
 	}
 
-submit_io:
 	if (likely(bio->bi_size)) {
 		if (xfs_buf_is_vmapped(bp)) {
 			flush_kernel_vmap_range(bp->b_addr,
@@ -1393,18 +1267,7 @@ submit_io:
 		if (size)
 			goto next_chunk;
 	} else {
-		/*
-		 * if we get here, no pages were added to the bio. However,
-		 * we can't just error out here - if the pages are locked then
-		 * we have to unlock them otherwise we can hang on a later
-		 * access to the page.
-		 */
 		xfs_buf_ioerror(bp, EIO);
-		if (bp->b_flags & _XBF_PAGE_LOCKED) {
-			int i;
-			for (i = 0; i < bp->b_page_count; i++)
-				unlock_page(bp->b_pages[i]);
-		}
 		bio_put(bio);
 	}
 }
@@ -1450,7 +1313,7 @@ xfs_buf_iowait(
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 	wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
@@ -1468,8 +1331,8 @@ xfs_buf_offset(
 		return XFS_BUF_PTR(bp) + offset;
 
 	offset += bp->b_offset;
-	page = bp->b_pages[offset >> PAGE_CACHE_SHIFT];
-	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_CACHE_SIZE-1));
+	page = bp->b_pages[offset >> PAGE_SHIFT];
+	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_SIZE-1));
 }
 
 /*
@@ -1491,9 +1354,9 @@ xfs_buf_iomove(
 		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
 		cpoff = xfs_buf_poff(boff + bp->b_offset);
 		csize = min_t(size_t,
-			      PAGE_CACHE_SIZE-cpoff, bp->b_count_desired-boff);
+			      PAGE_SIZE-cpoff, bp->b_count_desired-boff);
 
-		ASSERT(((csize + cpoff) <= PAGE_CACHE_SIZE));
+		ASSERT(((csize + cpoff) <= PAGE_SIZE));
 
 		switch (mode) {
 		case XBRW_ZERO:
@@ -1606,7 +1469,6 @@ xfs_free_buftarg(
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
-	iput(btp->bt_mapping->host);
 
 	kthread_stop(btp->bt_task);
 	kmem_free(btp);
@@ -1630,15 +1492,6 @@ xfs_setsize_buftarg_flags(
 		return EINVAL;
 	}
 
-	if (verbose &&
-	    (PAGE_CACHE_SIZE / BITS_PER_LONG) > sectorsize) {
-		printk(KERN_WARNING
-			"XFS: %u byte sectors in use on device %s.  "
-			"This is suboptimal; %u or greater is ideal.\n",
-			sectorsize, XFS_BUFTARG_NAME(btp),
-			(unsigned int)PAGE_CACHE_SIZE / BITS_PER_LONG);
-	}
-
 	return 0;
 }
 
@@ -1653,7 +1506,7 @@ xfs_setsize_buftarg_early(
 	struct block_device	*bdev)
 {
 	return xfs_setsize_buftarg_flags(btp,
-			PAGE_CACHE_SIZE, bdev_logical_block_size(bdev), 0);
+			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
 }
 
 int
@@ -1666,41 +1519,6 @@ xfs_setsize_buftarg(
 }
 
 STATIC int
-xfs_mapping_buftarg(
-	xfs_buftarg_t		*btp,
-	struct block_device	*bdev)
-{
-	struct backing_dev_info	*bdi;
-	struct inode		*inode;
-	struct address_space	*mapping;
-	static const struct address_space_operations mapping_aops = {
-		.sync_page = block_sync_page,
-		.migratepage = fail_migrate_page,
-	};
-
-	inode = new_inode(bdev->bd_inode->i_sb);
-	if (!inode) {
-		printk(KERN_WARNING
-			"XFS: Cannot allocate mapping inode for device %s\n",
-			XFS_BUFTARG_NAME(btp));
-		return ENOMEM;
-	}
-	inode->i_ino = get_next_ino();
-	inode->i_mode = S_IFBLK;
-	inode->i_bdev = bdev;
-	inode->i_rdev = bdev->bd_dev;
-	bdi = blk_get_backing_dev_info(bdev);
-	if (!bdi)
-		bdi = &default_backing_dev_info;
-	mapping = &inode->i_data;
-	mapping->a_ops = &mapping_aops;
-	mapping->backing_dev_info = bdi;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	btp->bt_mapping = mapping;
-	return 0;
-}
-
-STATIC int
 xfs_alloc_delwrite_queue(
 	xfs_buftarg_t		*btp,
 	const char		*fsname)
@@ -1728,12 +1546,11 @@ xfs_alloc_buftarg(
 	btp->bt_mount = mp;
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
+	btp->bt_bdi = blk_get_backing_dev_info(bdev);
 	INIT_LIST_HEAD(&btp->bt_lru);
 	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	if (xfs_mapping_buftarg(btp, bdev))
-		goto error;
 	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
@@ -1955,7 +1772,7 @@ xfsbufd(
 			count++;
 		}
 		if (count)
-			blk_run_address_space(target->bt_mapping);
+			blk_run_backing_dev(target->bt_bdi, NULL);
 
 	} while (!kthread_should_stop());
 
@@ -2003,7 +1820,7 @@ xfs_flush_buftarg(
 
 	if (wait) {
 		/* Expedite and wait for IO to complete. */
-		blk_run_address_space(target->bt_mapping);
+		blk_run_backing_dev(target->bt_bdi, NULL);
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index cbe6595..a9a1c45 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -61,30 +61,11 @@ typedef enum {
 #define XBF_DONT_BLOCK	(1 << 16)/* do not block in current thread */
 
 /* flags used only internally */
-#define _XBF_PAGE_CACHE	(1 << 17)/* backed by pagecache */
 #define _XBF_PAGES	(1 << 18)/* backed by refcounted pages */
 #define	_XBF_RUN_QUEUES	(1 << 19)/* run block device task queue	*/
+#define	_XBF_KMEM	(1 << 20)/* backed by heap memory */
 #define _XBF_DELWRI_Q	(1 << 21)/* buffer on delwri queue */
 
-/*
- * Special flag for supporting metadata blocks smaller than a FSB.
- *
- * In this case we can have multiple xfs_buf_t on a single page and
- * need to lock out concurrent xfs_buf_t readers as they only
- * serialise access to the buffer.
- *
- * If the FSB size >= PAGE_CACHE_SIZE case, we have no serialisation
- * between reads of the page. Hence we can have one thread read the
- * page and modify it, but then race with another thread that thinks
- * the page is not up-to-date and hence reads it again.
- *
- * The result is that the first modifcation to the page is lost.
- * This sort of AGF/AGI reading race can happen when unlinking inodes
- * that require truncation and results in the AGI unlinked list
- * modifications being lost.
- */
-#define _XBF_PAGE_LOCKED	(1 << 22)
-
 typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
@@ -100,12 +81,10 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
 	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* ditto */\
 	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
-	{ _XBF_PAGE_CACHE,	"PAGE_CACHE" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_RUN_QUEUES,	"RUN_QUEUES" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_PAGE_LOCKED,	"PAGE_LOCKED" }
-
+	{ _XBF_KMEM,		"KMEM" }, \
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 typedef enum {
 	XBT_FORCE_SLEEP = 0,
@@ -120,7 +99,7 @@ typedef struct xfs_bufhash {
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
-	struct address_space	*bt_mapping;
+	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_bsize;
 	unsigned int		bt_sshift;
@@ -139,17 +118,6 @@ typedef struct xfs_buftarg {
 	unsigned int		bt_lru_nr;
 } xfs_buftarg_t;
 
-/*
- *	xfs_buf_t:  Buffer structure for pagecache-based buffers
- *
- * This buffer structure is used by the pagecache buffer management routines
- * to refer to an assembly of pages forming a logical buffer.
- *
- * The buffer structure is used on a temporary basis only, and discarded when
- * released.  The real data storage is recorded in the pagecache. Buffers are
- * hashed to the block device on which the file system resides.
- */
-
 struct xfs_buf;
 typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
