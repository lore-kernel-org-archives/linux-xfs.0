Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuLU1121258 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3179E1E6531A
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	vwyJkuVPGcnvIajM for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:07 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39287363-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:06 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTCD-0004PI-2Q
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:57:05 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTC0-0000Qk-Mg
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/18] xfs: stop using the page cache to back the buffer cache
Date: Tue, 14 Sep 2010 20:56:17 +1000
Message-Id: <1284461777-1496-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that he buffer cache has it's own LRU, we do not need to use the page cache
to provide persistent caching and reclaim infrastructure. Convert the buffer
cache to use alloc_pages() instead of the page cache. This will remove all the
overhead of page cache management from setup and teardown of the buffers, as
well as needing to mark pages accessed as we find buffers in the buffer cache.

By avoiding the page cache, we also remove the need to keep state in the
page_private(page) field so that it persists across buffer free/buffer rebuild,
and so all that code can be removed. This also fixes the long-standing problem
of not having enough bits in the page_private field to track all the state
needed for a 512 sector/64k page setup.

It also removes the need for page locking during reads as the pages are unique
to the buffer and nobody else will be attempting to access them.

The only open question is how to best handle sub-page buffers - can we use
kmalloc/slab memory for sub-page sized buffers, or do we need to split up
pages ourselves? Worth noting is that the current code still works on sub-page
block size filesystems, it is just inefficient w.r.t. memory usage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |  256 +++++---------------------------------------
 fs/xfs/linux-2.6/xfs_buf.h |    2 +-
 2 files changed, 27 insertions(+), 231 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 12b37c6..c3b1f4a 100644
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
  *	Internal xfs_buf_t object manipulation
  */
 
@@ -260,7 +191,7 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
+	if (bp->b_flags & _XBF_PAGES) {
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
@@ -270,9 +201,7 @@ xfs_buf_free(
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			if (bp->b_flags & _XBF_PAGE_CACHE)
-				ASSERT(!PagePrivate(page));
-			page_cache_release(page);
+			__free_page(page);
 		}
 	}
 	_xfs_buf_free_pages(bp);
@@ -287,8 +216,6 @@ _xfs_buf_lookup_pages(
 	xfs_buf_t		*bp,
 	uint			flags)
 {
-	struct address_space	*mapping = bp->b_target->bt_mapping;
-	size_t			blocksize = bp->b_target->bt_bsize;
 	size_t			size = bp->b_count_desired;
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
@@ -303,22 +230,21 @@ _xfs_buf_lookup_pages(
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
 		return error;
-	bp->b_flags |= _XBF_PAGE_CACHE;
+	bp->b_flags |= _XBF_PAGES;
 
 	offset = bp->b_offset;
-	first = bp->b_file_offset >> PAGE_CACHE_SHIFT;
+	first = bp->b_file_offset >> PAGE_SHIFT;
 
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
 				for (i = 0; i < bp->b_page_count; i++)
-					unlock_page(bp->b_pages[i]);
+					__free_page(bp->b_pages[i]);
 				return -ENOMEM;
 			}
 
@@ -341,33 +267,11 @@ _xfs_buf_lookup_pages(
 
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
-
-	if (!(bp->b_flags & _XBF_PAGE_LOCKED)) {
-		for (i = 0; i < bp->b_page_count; i++)
-			unlock_page(bp->b_pages[i]);
-	}
-
-	if (page_count == bp->b_page_count)
-		bp->b_flags |= XBF_DONE;
-
 	return error;
 }
 
@@ -661,7 +565,7 @@ xfs_buf_readahead(
 {
 	struct backing_dev_info *bdi;
 
-	bdi = target->bt_mapping->backing_dev_info;
+	bdi = blk_get_backing_dev_info(target->bt_bdev);
 	if (bdi_read_congested(bdi))
 		return;
 
@@ -739,10 +643,10 @@ xfs_buf_associate_memory(
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
@@ -759,13 +663,12 @@ xfs_buf_associate_memory(
 
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
@@ -936,7 +839,7 @@ xfs_buf_lock(
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 
@@ -981,7 +884,7 @@ xfs_buf_wait_unpin(
 		if (atomic_read(&bp->b_pin_count) == 0)
 			break;
 		if (atomic_read(&bp->b_io_remaining))
-			blk_run_address_space(bp->b_target->bt_mapping);
+			blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 		schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
@@ -1206,10 +1109,8 @@ _xfs_buf_ioend(
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
@@ -1218,35 +1119,12 @@ xfs_buf_bio_end_io(
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
@@ -1260,7 +1138,6 @@ _xfs_buf_ioapply(
 	int			offset = bp->b_offset;
 	int			size = bp->b_count_desired;
 	sector_t		sector = bp->b_bn;
-	unsigned int		blocksize = bp->b_target->bt_bsize;
 
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
@@ -1281,30 +1158,6 @@ _xfs_buf_ioapply(
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
-
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
 	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
@@ -1318,7 +1171,7 @@ next_chunk:
 	bio->bi_private = bp;
 
 	for (; size && nr_pages; nr_pages--, map_i++) {
-		int	rbytes, nbytes = PAGE_CACHE_SIZE - offset;
+		int	rbytes, nbytes = PAGE_SIZE - offset;
 
 		if (nbytes > size)
 			nbytes = size;
@@ -1333,7 +1186,6 @@ next_chunk:
 		total_nr_pages--;
 	}
 
-submit_io:
 	if (likely(bio->bi_size)) {
 		if (xfs_buf_is_vmapped(bp)) {
 			flush_kernel_vmap_range(bp->b_addr,
@@ -1343,18 +1195,7 @@ submit_io:
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
@@ -1400,7 +1241,7 @@ xfs_buf_iowait(
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_run_backing_dev(bp->b_target->bt_bdi, NULL);
 	wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
@@ -1418,8 +1259,8 @@ xfs_buf_offset(
 		return XFS_BUF_PTR(bp) + offset;
 
 	offset += bp->b_offset;
-	page = bp->b_pages[offset >> PAGE_CACHE_SHIFT];
-	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_CACHE_SIZE-1));
+	page = bp->b_pages[offset >> PAGE_SHIFT];
+	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_SIZE-1));
 }
 
 /*
@@ -1441,9 +1282,9 @@ xfs_buf_iomove(
 		page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
 		cpoff = xfs_buf_poff(boff + bp->b_offset);
 		csize = min_t(size_t,
-			      PAGE_CACHE_SIZE-cpoff, bp->b_count_desired-boff);
+			      PAGE_SIZE-cpoff, bp->b_count_desired-boff);
 
-		ASSERT(((csize + cpoff) <= PAGE_CACHE_SIZE));
+		ASSERT(((csize + cpoff) <= PAGE_SIZE));
 
 		switch (mode) {
 		case XBRW_ZERO:
@@ -1549,7 +1390,6 @@ xfs_free_buftarg(
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
-	iput(btp->bt_mapping->host);
 
 	kthread_stop(btp->bt_task);
 	kmem_free(btp);
@@ -1573,15 +1413,6 @@ xfs_setsize_buftarg_flags(
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
 
@@ -1596,7 +1427,7 @@ xfs_setsize_buftarg_early(
 	struct block_device	*bdev)
 {
 	return xfs_setsize_buftarg_flags(btp,
-			PAGE_CACHE_SIZE, bdev_logical_block_size(bdev), 0);
+			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
 }
 
 int
@@ -1609,40 +1440,6 @@ xfs_setsize_buftarg(
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
@@ -1670,12 +1467,11 @@ xfs_alloc_buftarg(
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
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink,
@@ -1897,7 +1693,7 @@ xfsbufd(
 			count++;
 		}
 		if (count)
-			blk_run_address_space(target->bt_mapping);
+			blk_run_backing_dev(target->bt_bdi, NULL);
 
 	} while (!kthread_should_stop());
 
@@ -1945,7 +1741,7 @@ xfs_flush_buftarg(
 
 	if (wait) {
 		/* Expedite and wait for IO to complete. */
-		blk_run_address_space(target->bt_mapping);
+		blk_run_backing_dev(target->bt_bdi, NULL);
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 36f71aa..1ec3d28 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -130,7 +130,7 @@ typedef struct xfs_bufhash {
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
-	struct address_space	*bt_mapping;
+	struct backing_dev_info	*bt_bdi;
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_bsize;
 	unsigned int		bt_sshift;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
