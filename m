Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 886297CD1
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B1998F8039
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jd4p4eJbS5gcV9MT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:58 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 11/45] btrfs: have submit_one_bio users use bio op accessors
Date: Sun,  5 Jun 2016 14:31:51 -0500
Message-Id: <1465155145-10812-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

This patch has btrfs's submit_one_bio users set the bio op using
bio_set_op_attrs and get the op using bio_op.

The next patches will continue to convert btrfs,
so submit_bio_hook and merge_bio_hook
related code will be modified to take only the bio. I did
not do it in this patch to try and keep it smaller.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/btrfs/extent_io.c | 88 +++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c1e6f20..48f0302 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2377,7 +2377,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	int read_mode;
 	int ret;
 
-	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
 	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
 	if (ret)
@@ -2403,6 +2403,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		free_io_failure(inode, failrec);
 		return -EIO;
 	}
+	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
 
 	pr_debug("Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d\n",
 		 read_mode, failrec->this_mirror, failrec->in_validation);
@@ -2714,8 +2715,8 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(int rw, struct bio *bio,
-				       int mirror_num, unsigned long bio_flags)
+static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
+				       unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2726,12 +2727,12 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	start = page_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
-	bio->bi_rw = rw;
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
-					   mirror_num, bio_flags, start);
+		ret = tree->ops->submit_bio_hook(page->mapping->host,
+						 bio->bi_rw, bio, mirror_num,
+						 bio_flags, start);
 	else
 		btrfsic_submit_bio(bio);
 
@@ -2739,20 +2740,20 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	return ret;
 }
 
-static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
+static int merge_bio(struct extent_io_tree *tree, struct page *page,
 		     unsigned long offset, size_t size, struct bio *bio,
 		     unsigned long bio_flags)
 {
 	int ret = 0;
 	if (tree->ops && tree->ops->merge_bio_hook)
-		ret = tree->ops->merge_bio_hook(rw, page, offset, size, bio,
-						bio_flags);
+		ret = tree->ops->merge_bio_hook(bio_op(bio), page, offset, size,
+						bio, bio_flags);
 	BUG_ON(ret < 0);
 	return ret;
 
 }
 
-static int submit_extent_page(int rw, struct extent_io_tree *tree,
+static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 			      struct writeback_control *wbc,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
@@ -2780,10 +2781,9 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    force_bio_submit ||
-		    merge_bio(rw, tree, page, offset, page_size, bio, bio_flags) ||
+		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
-			ret = submit_one_bio(rw, bio, mirror_num,
-					     prev_bio_flags);
+			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
 			if (ret < 0) {
 				*bio_ret = NULL;
 				return ret;
@@ -2804,6 +2804,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
+	bio_set_op_attrs(bio, op, op_flags);
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
 		wbc_account_io(wbc, page, page_size);
@@ -2812,7 +2813,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	if (bio_ret)
 		*bio_ret = bio;
 	else
-		ret = submit_one_bio(rw, bio, mirror_num, bio_flags);
+		ret = submit_one_bio(bio, mirror_num, bio_flags);
 
 	return ret;
 }
@@ -2876,7 +2877,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			 get_extent_t *get_extent,
 			 struct extent_map **em_cached,
 			 struct bio **bio, int mirror_num,
-			 unsigned long *bio_flags, int rw,
+			 unsigned long *bio_flags, int read_flags,
 			 u64 *prev_em_start)
 {
 	struct inode *inode = page->mapping->host;
@@ -3059,8 +3060,8 @@ static int __do_readpage(struct extent_io_tree *tree,
 		}
 
 		pnr -= page->index;
-		ret = submit_extent_page(rw, tree, NULL, page,
-					 sector, disk_io_size, pg_offset,
+		ret = submit_extent_page(REQ_OP_READ, read_flags, tree, NULL,
+					 page, sector, disk_io_size, pg_offset,
 					 bdev, bio, pnr,
 					 end_bio_extent_readpage, mirror_num,
 					 *bio_flags,
@@ -3091,7 +3092,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     get_extent_t *get_extent,
 					     struct extent_map **em_cached,
 					     struct bio **bio, int mirror_num,
-					     unsigned long *bio_flags, int rw,
+					     unsigned long *bio_flags,
 					     u64 *prev_em_start)
 {
 	struct inode *inode;
@@ -3112,7 +3113,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 
 	for (index = 0; index < nr_pages; index++) {
 		__do_readpage(tree, pages[index], get_extent, em_cached, bio,
-			      mirror_num, bio_flags, rw, prev_em_start);
+			      mirror_num, bio_flags, 0, prev_em_start);
 		put_page(pages[index]);
 	}
 }
@@ -3122,7 +3123,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			       int nr_pages, get_extent_t *get_extent,
 			       struct extent_map **em_cached,
 			       struct bio **bio, int mirror_num,
-			       unsigned long *bio_flags, int rw,
+			       unsigned long *bio_flags,
 			       u64 *prev_em_start)
 {
 	u64 start = 0;
@@ -3144,7 +3145,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 						  index - first_index, start,
 						  end, get_extent, em_cached,
 						  bio, mirror_num, bio_flags,
-						  rw, prev_em_start);
+						  prev_em_start);
 			start = page_start;
 			end = start + PAGE_SIZE - 1;
 			first_index = index;
@@ -3155,7 +3156,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
 					  end, get_extent, em_cached, bio,
-					  mirror_num, bio_flags, rw,
+					  mirror_num, bio_flags,
 					  prev_em_start);
 }
 
@@ -3163,7 +3164,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
 				   struct bio **bio, int mirror_num,
-				   unsigned long *bio_flags, int rw)
+				   unsigned long *bio_flags, int read_flags)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_ordered_extent *ordered;
@@ -3183,7 +3184,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 	}
 
 	ret = __do_readpage(tree, page, get_extent, NULL, bio, mirror_num,
-			    bio_flags, rw, NULL);
+			    bio_flags, read_flags, NULL);
 	return ret;
 }
 
@@ -3195,9 +3196,9 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	int ret;
 
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, mirror_num,
-				      &bio_flags, READ);
+				      &bio_flags, 0);
 	if (bio)
-		ret = submit_one_bio(READ, bio, mirror_num, bio_flags);
+		ret = submit_one_bio(bio, mirror_num, bio_flags);
 	return ret;
 }
 
@@ -3431,8 +3432,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			       page->index, cur, end);
 		}
 
-		ret = submit_extent_page(write_flags, tree, wbc, page,
-					 sector, iosize, pg_offset,
+		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
+					 page, sector, iosize, pg_offset,
 					 bdev, &epd->bio, max_nr,
 					 end_bio_extent_writepage,
 					 0, 0, 0, false);
@@ -3471,13 +3472,11 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	size_t pg_offset = 0;
 	loff_t i_size = i_size_read(inode);
 	unsigned long end_index = i_size >> PAGE_SHIFT;
-	int write_flags;
+	int write_flags = 0;
 	unsigned long nr_written = 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		write_flags = WRITE_SYNC;
-	else
-		write_flags = WRITE;
 
 	trace___extent_writepage(page, inode, wbc);
 
@@ -3721,7 +3720,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
-	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int write_flags = (epd->sync_io ? WRITE_SYNC : 0) | REQ_META;
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
@@ -3735,9 +3734,10 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
-		ret = submit_extent_page(rw, tree, wbc, p, offset >> 9,
-					 PAGE_SIZE, 0, bdev, &epd->bio,
-					 -1, end_bio_extent_buffer_writepage,
+		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
+					 p, offset >> 9, PAGE_SIZE, 0, bdev,
+					 &epd->bio, -1,
+					 end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags, false);
 		epd->bio_flags = bio_flags;
 		if (ret) {
@@ -4047,13 +4047,12 @@ retry:
 static void flush_epd_write_bio(struct extent_page_data *epd)
 {
 	if (epd->bio) {
-		int rw = WRITE;
 		int ret;
 
-		if (epd->sync_io)
-			rw = WRITE_SYNC;
+		bio_set_op_attrs(epd->bio, REQ_OP_WRITE,
+				 epd->sync_io ? WRITE_SYNC : 0);
 
-		ret = submit_one_bio(rw, epd->bio, 0, epd->bio_flags);
+		ret = submit_one_bio(epd->bio, 0, epd->bio_flags);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
@@ -4180,19 +4179,19 @@ int extent_readpages(struct extent_io_tree *tree,
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, READ, &prev_em_start);
+				   &bio, 0, &bio_flags, &prev_em_start);
 		nr = 0;
 	}
 	if (nr)
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, READ, &prev_em_start);
+				   &bio, 0, &bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
 
 	BUG_ON(!list_empty(pages));
 	if (bio)
-		return submit_one_bio(READ, bio, 0, bio_flags);
+		return submit_one_bio(bio, 0, bio_flags);
 	return 0;
 }
 
@@ -5218,7 +5217,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			err = __extent_read_full_page(tree, page,
 						      get_extent, &bio,
 						      mirror_num, &bio_flags,
-						      READ | REQ_META);
+						      REQ_META);
 			if (err)
 				ret = err;
 		} else {
@@ -5227,8 +5226,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	}
 
 	if (bio) {
-		err = submit_one_bio(READ | REQ_META, bio, mirror_num,
-				     bio_flags);
+		err = submit_one_bio(bio, mirror_num, bio_flags);
 		if (err)
 			return err;
 	}
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
