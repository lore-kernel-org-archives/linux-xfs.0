Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E84A7F6F
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 03:59:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D46FAC006
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 01:59:03 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FbF2aGXeAHiPNAkI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 01:59:01 -0700 (PDT)
Date: Tue, 21 Jul 2015 10:58:59 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [regression 4.2-rc3] loop: xfstests xfs/073 deadlocked in low
	memory conditions
Message-ID: <20150721085859.GG11967@dhcp22.suse.cz>
References: <20150721015934.GY7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150721015934.GY7943@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>

[CCing more people from a potentially affected fs - the reference to the 
 email thread is: http://marc.info/?l=linux-mm&m=143744398020147&w=2]

On Tue 21-07-15 11:59:34, Dave Chinner wrote:
> Hi Ming,
> 
> With the recent merge of the loop device changes, I'm now seeing
> XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
> 
> The deadlocked is as follows:
> 
> kloopd1: loop_queue_read_work
> 	xfs_file_iter_read
> 	lock XFS inode XFS_IOLOCK_SHARED (on image file)
> 	page cache read (GFP_KERNEL)
> 	radix tree alloc
> 	memory reclaim
> 	reclaim XFS inodes
> 	log force to unpin inodes
> 	<wait for log IO completion>
> 
> xfs-cil/loop1: <does log force IO work>
> 	xlog_cil_push
> 	xlog_write
> 	<loop issuing log writes>
> 		xlog_state_get_iclog_space()
> 		<blocks due to all log buffers under write io>
> 		<waits for IO completion>
> 
> kloopd1: loop_queue_write_work
> 	xfs_file_write_iter
> 	lock XFS inode XFS_IOLOCK_EXCL (on image file)
> 	<wait for inode to be unlocked>
> 
> [The full stack traces are below].
> 
> i.e. the kloopd, with it's split read and write work queues, has
> introduced a dependency through memory reclaim. i.e. that writes
> need to be able to progress for reads make progress.
> 
> The problem, fundamentally, is that mpage_readpages() does a
> GFP_KERNEL allocation, rather than paying attention to the inode's
> mapping gfp mask, which is set to GFP_NOFS.
> 
> The didn't used to happen, because the loop device used to issue
> reads through the splice path and that does:
> 
> 	error = add_to_page_cache_lru(page, mapping, index,
> 			GFP_KERNEL & mapping_gfp_mask(mapping));
> 
> i.e. it pays attention to the allocation context placed on the
> inode and so is doing GFP_NOFS allocations here and avoiding the
> recursion problem.
> 
> [ CC'd Michal Hocko and the mm list because it's a clear exaple of
> why ignoring the mapping gfp mask on any page cache allocation is
> a landmine waiting to be tripped over. ]

Thank you for CCing me. I haven't noticed this one when checking for
other similar hardcoded GFP_KERNEL users (6afdb859b710 ("mm: do not
ignore mapping_gfp_mask in page cache allocation paths")). And there
seem to be more of them now that I am looking closer.

I am not sure what to do about fs/nfs/dir.c:nfs_symlink which doesn't
require GFP_NOFS or mapping gfp mask for other allocations in the same
context.

What do you think about this preliminary (and untested) patch? I cannot
say I would be happy about sprinkling mapping_gfp_mask all over the place
and it sounds like we should drop gfp_mask argument altogether and
use it internally in __add_to_page_cache_locked that would require all
the filesystems to use mapping gfp consistently which I am not sure is
the case here. From a quick glance it seems that some file system use
it all the time while others are selective.
---
>From 72e13282dfb117432332416b60bc4e4d2dad9153 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Tue, 21 Jul 2015 10:06:13 +0200
Subject: [PATCH] mm, fs: Obey gfp_mapping for add_to_page_cache

6afdb859b710 ("mm: do not ignore mapping_gfp_mask in page cache
allocation paths) has caught some users of hardcoded GFP_KERNEL
used in the page cache allocation paths. This, however, wasn't complete
and there were others which went unnoticed.

Dave Chinner has reported the following deadlock for xfs on loop device:
: With the recent merge of the loop device changes, I'm now seeing
: XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
:
: The deadlocked is as follows:
:
: kloopd1: loop_queue_read_work
:       xfs_file_iter_read
:       lock XFS inode XFS_IOLOCK_SHARED (on image file)
:       page cache read (GFP_KERNEL)
:       radix tree alloc
:       memory reclaim
:       reclaim XFS inodes
:       log force to unpin inodes
:       <wait for log IO completion>
:
: xfs-cil/loop1: <does log force IO work>
:       xlog_cil_push
:       xlog_write
:       <loop issuing log writes>
:               xlog_state_get_iclog_space()
:               <blocks due to all log buffers under write io>
:               <waits for IO completion>
:
: kloopd1: loop_queue_write_work
:       xfs_file_write_iter
:       lock XFS inode XFS_IOLOCK_EXCL (on image file)
:       <wait for inode to be unlocked>
:
: i.e. the kloopd, with it's split read and write work queues, has
: introduced a dependency through memory reclaim. i.e. that writes
: need to be able to progress for reads make progress.
:
: The problem, fundamentally, is that mpage_readpages() does a
: GFP_KERNEL allocation, rather than paying attention to the inode's
: mapping gfp mask, which is set to GFP_NOFS.
:
: The didn't used to happen, because the loop device used to issue
: reads through the splice path and that does:
:
:       error = add_to_page_cache_lru(page, mapping, index,
:                       GFP_KERNEL & mapping_gfp_mask(mapping));

This has changed by aa4d86163e4 (block: loop: switch to VFS ITER_BVEC).

This patch changes mpage_readpage{s} to follow gfp mask set for the
mapping. There are, however, other places which are doing basically the
same.

lustre:ll_dir_filler is doing GFP_KERNEL from the function which
apparently uses GFP_NOFS for other allocations so let's make this
consistent.

cifs:readpages_get_pages is called from cifs_readpages and
__cifs_readpages_from_fscache called from the same path obeys mapping
gfp.

ramfs_nommu_expand_for_mapping is hardcoding GFP_KERNEL as well
regardless it uses mapping_gfp_mask for the page allocation.

ext4_mpage_readpages is the called from the page cache allocation path
same as read_pages and read_cache_pages

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 drivers/staging/lustre/lustre/llite/dir.c |  2 +-
 fs/cifs/file.c                            |  5 +++--
 fs/ext4/readpage.c                        |  3 ++-
 fs/mpage.c                                | 14 +++++++++-----
 fs/ramfs/file-nommu.c                     |  5 +++--
 mm/readahead.c                            |  6 ++++--
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index a5bc694dcb64..0a643b8b6deb 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -225,7 +225,7 @@ static int ll_dir_filler(void *_hash, struct page *page0)
 
 		prefetchw(&page->flags);
 		ret = add_to_page_cache_lru(page, inode->i_mapping, offset,
-					    GFP_KERNEL);
+					    GFP_NOFS);
 		if (ret == 0) {
 			unlock_page(page);
 			if (ll_pagevec_add(&lru_pvec, page) == 0)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2ac2d8471393..72c162a1d56d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3380,6 +3380,7 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 	struct page *page, *tpage;
 	unsigned int expected_index;
 	int rc;
+	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
 
 	INIT_LIST_HEAD(tmplist);
 
@@ -3392,7 +3393,7 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 	 */
 	__SetPageLocked(page);
 	rc = add_to_page_cache_locked(page, mapping,
-				      page->index, GFP_KERNEL);
+				      page->index, gfp);
 
 	/* give up if we can't stick it in the cache */
 	if (rc) {
@@ -3419,7 +3420,7 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 
 		__SetPageLocked(page);
 		if (add_to_page_cache_locked(page, mapping, page->index,
-								GFP_KERNEL)) {
+								gfp)) {
 			__ClearPageLocked(page);
 			break;
 		}
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 171b9ac4b45e..92eb970655bd 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -166,7 +166,8 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			page = list_entry(pages->prev, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping,
-						  page->index, GFP_KERNEL))
+						  page->index,
+						  GFP_KERNEL & mapping_gfp_mask(mapping)))
 				goto next_page;
 		}
 
diff --git a/fs/mpage.c b/fs/mpage.c
index dde689d0759d..4a54bd13c9bd 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -139,7 +139,8 @@ map_buffer_to_page(struct page *page, struct buffer_head *bh, int page_block)
 static struct bio *
 do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
-		unsigned long *first_logical_block, get_block_t get_block)
+		unsigned long *first_logical_block, get_block_t get_block,
+		gfp_t gfp)
 {
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
@@ -278,7 +279,7 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 			  	min_t(int, nr_pages, bio_get_nr_vecs(bdev)),
-				GFP_KERNEL);
+				gfp);
 		if (bio == NULL)
 			goto confused;
 	}
@@ -361,6 +362,7 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
+	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
@@ -370,12 +372,13 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					gfp)) {
 			bio = do_mpage_readpage(bio, page,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
-					get_block);
+					get_block, gfp);
 		}
 		page_cache_release(page);
 	}
@@ -395,11 +398,12 @@ int mpage_readpage(struct page *page, get_block_t get_block)
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
+	gfp_t gfp = mapping_gfp_mask(page->mapping);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
-			&map_bh, &first_logical_block, get_block);
+			&map_bh, &first_logical_block, get_block, gfp);
 	if (bio)
 		mpage_bio_submit(READ, bio);
 	return 0;
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index ba1323a94924..a586467f6ff6 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -70,6 +70,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 	unsigned order;
 	void *data;
 	int ret;
+	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 
 	/* make various checks */
 	order = get_order(newsize);
@@ -84,7 +85,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 
 	/* allocate enough contiguous pages to be able to satisfy the
 	 * request */
-	pages = alloc_pages(mapping_gfp_mask(inode->i_mapping), order);
+	pages = alloc_pages(gfp, order);
 	if (!pages)
 		return -ENOMEM;
 
@@ -108,7 +109,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		struct page *page = pages + loop;
 
 		ret = add_to_page_cache_lru(page, inode->i_mapping, loop,
-					GFP_KERNEL);
+					gfp);
 		if (ret < 0)
 			goto add_error;
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 60cd846a9a44..b9b99597dc77 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -90,7 +90,8 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 		page = list_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					GFP_KERNEL & mapping_gfp_mask(mapping))) {
 			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
@@ -128,7 +129,8 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 		struct page *page = list_to_page(pages);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					GFP_KERNEL & mapping_gfp_mask(mapping))) {
 			mapping->a_ops->readpage(filp, page);
 		}
 		page_cache_release(page);
-- 
2.1.4


-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
