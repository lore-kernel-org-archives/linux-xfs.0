Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 426E229E0C
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:54:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 25EB18F8050
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:54:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2txJtNXVvTWQNVFv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 12:54:14 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 10/35] btrfs: don't pass rq_flag_bits if there is a bio
Date: Tue,  5 Jan 2016 14:53:13 -0600
Message-Id: <1452027218-32303-11-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
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

The bio bi_op and bi_rw is now setup, so there is no need
to pass around the rq_flag_bits bits too.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/btrfs/compression.c |  9 ++++-----
 fs/btrfs/disk-io.c     | 30 ++++++++++++------------------
 fs/btrfs/disk-io.h     |  2 +-
 fs/btrfs/extent_io.c   | 16 +++++++---------
 fs/btrfs/extent_io.h   |  6 +++---
 fs/btrfs/inode.c       | 40 ++++++++++++++++++----------------------
 fs/btrfs/volumes.c     |  6 +++---
 fs/btrfs/volumes.h     |  2 +-
 8 files changed, 49 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 25bf179..3112cc3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -402,7 +402,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				BUG_ON(ret); /* -ENOMEM */
 			}
 
-			ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
+			ret = btrfs_map_bio(root, bio, 0, 1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			bio_put(bio);
@@ -433,7 +433,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
-	ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
+	ret = btrfs_map_bio(root, bio, 0, 1);
 	BUG_ON(ret); /* -ENOMEM */
 
 	bio_put(bio);
@@ -694,8 +694,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			sums += DIV_ROUND_UP(comp_bio->bi_iter.bi_size,
 					     root->sectorsize);
 
-			ret = btrfs_map_bio(root, READ, comp_bio,
-					    mirror_num, 0);
+			ret = btrfs_map_bio(root, comp_bio, mirror_num, 0);
 			if (ret) {
 				bio->bi_error = ret;
 				bio_endio(comp_bio);
@@ -725,7 +724,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
-	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, comp_bio, mirror_num, 0);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(comp_bio);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cd152e2..d344231 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -119,7 +119,6 @@ struct async_submit_bio {
 	struct list_head list;
 	extent_submit_bio_hook_t *submit_bio_start;
 	extent_submit_bio_hook_t *submit_bio_done;
-	int rw;
 	int mirror_num;
 	unsigned long bio_flags;
 	/*
@@ -783,7 +782,7 @@ static void run_one_async_start(struct btrfs_work *work)
 	int ret;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	ret = async->submit_bio_start(async->inode, async->rw, async->bio,
+	ret = async->submit_bio_start(async->inode, async->bio,
 				      async->mirror_num, async->bio_flags,
 				      async->bio_offset);
 	if (ret)
@@ -816,9 +815,8 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	async->submit_bio_done(async->inode, async->rw, async->bio,
-			       async->mirror_num, async->bio_flags,
-			       async->bio_offset);
+	async->submit_bio_done(async->inode, async->bio, async->mirror_num,
+			       async->bio_flags, async->bio_offset);
 }
 
 static void run_one_async_free(struct btrfs_work *work)
@@ -830,7 +828,7 @@ static void run_one_async_free(struct btrfs_work *work)
 }
 
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			int rw, struct bio *bio, int mirror_num,
+			struct bio *bio, int mirror_num,
 			unsigned long bio_flags,
 			u64 bio_offset,
 			extent_submit_bio_hook_t *submit_bio_start,
@@ -843,7 +841,6 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 		return -ENOMEM;
 
 	async->inode = inode;
-	async->rw = rw;
 	async->bio = bio;
 	async->mirror_num = mirror_num;
 	async->submit_bio_start = submit_bio_start;
@@ -889,9 +886,8 @@ static int btree_csum_one_bio(struct bio *bio)
 	return ret;
 }
 
-static int __btree_submit_bio_start(struct inode *inode, int rw,
-				    struct bio *bio, int mirror_num,
-				    unsigned long bio_flags,
+static int __btree_submit_bio_start(struct inode *inode, struct bio *bio,
+				    int mirror_num, unsigned long bio_flags,
 				    u64 bio_offset)
 {
 	/*
@@ -901,7 +897,7 @@ static int __btree_submit_bio_start(struct inode *inode, int rw,
 	return btree_csum_one_bio(bio);
 }
 
-static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
+static int __btree_submit_bio_done(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
@@ -911,7 +907,7 @@ static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 	 * when we're called for a write, we're already in the async
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
-	ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 1);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(bio);
@@ -930,7 +926,7 @@ static int check_async_write(struct inode *inode, unsigned long bio_flags)
 	return 1;
 }
 
-static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
+static int btree_submit_bio_hook(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
@@ -946,21 +942,19 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 					  bio, BTRFS_WQ_ENDIO_METADATA);
 		if (ret)
 			goto out_w_error;
-		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
-				    mirror_num, 0);
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 0);
 	} else if (!async) {
 		ret = btree_csum_one_bio(bio);
 		if (ret)
 			goto out_w_error;
-		ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
-				    mirror_num, 0);
+		ret = btrfs_map_bio(BTRFS_I(inode)->root, bio, mirror_num, 0);
 	} else {
 		/*
 		 * kthread helpers are used to submit writes so that
 		 * checksumming can happen in parallel across all CPUs
 		 */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-					  inode, rw, bio, mirror_num, 0,
+					  inode, bio, mirror_num, 0,
 					  bio_offset,
 					  __btree_submit_bio_start,
 					  __btree_submit_bio_done);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 7c52e29..4a5d5df 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -122,7 +122,7 @@ void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			int rw, struct bio *bio, int mirror_num,
+			struct bio *bio, int mirror_num,
 			unsigned long bio_flags, u64 bio_offset,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b6c281a..25a6da0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2414,8 +2414,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	pr_debug("Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d\n",
 		 read_mode, failrec->this_mirror, failrec->in_validation);
 
-	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
-					 failrec->this_mirror,
+	ret = tree->ops->submit_bio_hook(inode, bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
 		free_io_failure(inode, failrec);
@@ -2736,9 +2735,8 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		ret = tree->ops->submit_bio_hook(page->mapping->host,
-						 bio->bi_rw, bio, mirror_num,
-						 bio_flags, start);
+		ret = tree->ops->submit_bio_hook(page->mapping->host, bio,
+					   mirror_num, bio_flags, start);
 	else
 		btrfsic_submit_bio(bio);
 
@@ -2746,14 +2744,14 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	return ret;
 }
 
-static int merge_bio(struct extent_io_tree *tree, struct page *page,
+static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 		     unsigned long offset, size_t size, struct bio *bio,
 		     unsigned long bio_flags)
 {
 	int ret = 0;
 	if (tree->ops && tree->ops->merge_bio_hook)
-		ret = tree->ops->merge_bio_hook(bio->bi_op, page, offset, size,
-						bio, bio_flags);
+		ret = tree->ops->merge_bio_hook(rw, page, offset, size, bio,
+						bio_flags);
 	BUG_ON(ret < 0);
 	return ret;
 
@@ -2787,7 +2785,7 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    force_bio_submit ||
-		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
+		    merge_bio(op, tree, page, offset, page_size, bio, bio_flags) ||
 		    bio_add_page(bio, page, page_size, offset) < page_size) {
 			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
 			if (ret < 0) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0377413..89f1b75 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -63,9 +63,9 @@ struct extent_state;
 struct btrfs_root;
 struct btrfs_io_bio;
 
-typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int rw,
-				       struct bio *bio, int mirror_num,
-				       unsigned long bio_flags, u64 bio_offset);
+typedef	int (extent_submit_bio_hook_t)(struct inode *inode, struct bio *bio,
+				       int mirror_num, unsigned long bio_flags,
+				       u64 bio_offset);
 struct extent_io_ops {
 	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1e88ec..a96984f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1840,9 +1840,8 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_start(struct inode *inode, int rw,
-				    struct bio *bio, int mirror_num,
-				    unsigned long bio_flags,
+static int __btrfs_submit_bio_start(struct inode *inode, struct bio *bio,
+				    int mirror_num, unsigned long bio_flags,
 				    u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1861,14 +1860,14 @@ static int __btrfs_submit_bio_start(struct inode *inode, int rw,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
+static int __btrfs_submit_bio_done(struct inode *inode, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags,
 			  u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 1);
+	ret = btrfs_map_bio(root, bio, mirror_num, 1);
 	if (ret) {
 		bio->bi_error = ret;
 		bio_endio(bio);
@@ -1880,7 +1879,7 @@ static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
  * extent_io.c submission hook. This does the right thing for csum calculation
  * on write, or reading the csums from the tree before a read
  */
-static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
+static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags,
 			  u64 bio_offset)
 {
@@ -1917,7 +1916,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, rw, bio, mirror_num,
+				   inode, bio, mirror_num,
 				   bio_flags, bio_offset,
 				   __btrfs_submit_bio_start,
 				   __btrfs_submit_bio_done);
@@ -1929,7 +1928,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	}
 
 mapit:
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, bio, mirror_num, 0);
 
 out:
 	if (ret < 0) {
@@ -7708,7 +7707,7 @@ err:
 }
 
 static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
-					int rw, int mirror_num)
+					int mirror_num)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -7722,7 +7721,7 @@ static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
 	if (ret)
 		goto err;
 
-	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+	ret = btrfs_map_bio(root, bio, mirror_num, 0);
 err:
 	bio_put(bio);
 	return ret;
@@ -7806,8 +7805,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		    "Repair DIO Read Error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d\n",
 		    read_mode, failrec->this_mirror, failrec->in_validation);
 
-	ret = submit_dio_repair_bio(inode, bio, read_mode,
-				    failrec->this_mirror);
+	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
 	if (ret) {
 		free_io_failure(inode, failrec);
 		bio_put(bio);
@@ -8045,7 +8043,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
+static int __btrfs_submit_bio_start_direct_io(struct inode *inode,
 				    struct bio *bio, int mirror_num,
 				    unsigned long bio_flags, u64 offset)
 {
@@ -8138,7 +8136,7 @@ static inline int btrfs_lookup_and_bind_dio_csum(struct btrfs_root *root,
 }
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
-					 int rw, u64 file_offset, int skip_sum,
+					 u64 file_offset, int skip_sum,
 					 int async_submit)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -8163,8 +8161,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 
 	if (write && async_submit) {
 		ret = btrfs_wq_submit_bio(root->fs_info,
-				   inode, rw, bio, 0, 0,
-				   file_offset,
+				   inode, bio, 0, 0, file_offset,
 				   __btrfs_submit_bio_start_direct_io,
 				   __btrfs_submit_bio_done);
 		goto err;
@@ -8183,13 +8180,13 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 map:
-	ret = btrfs_map_bio(root, rw, bio, 0, async_submit);
+	ret = btrfs_map_bio(root, bio, 0, async_submit);
 err:
 	bio_put(bio);
 	return ret;
 }
 
-static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
+static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 				    int skip_sum)
 {
 	struct inode *inode = dip->inode;
@@ -8245,7 +8242,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			 * before we're done setting it up
 			 */
 			atomic_inc(&dip->pending_bios);
-			ret = __btrfs_submit_dio_bio(bio, inode, rw,
+			ret = __btrfs_submit_dio_bio(bio, inode,
 						     file_offset, skip_sum,
 						     async_submit);
 			if (ret) {
@@ -8286,7 +8283,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	}
 
 submit:
-	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
+	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
 				     async_submit);
 	if (!ret)
 		return 0;
@@ -8364,8 +8361,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 			dio_data->unsubmitted_oe_range_end;
 	}
 
-	ret = btrfs_submit_direct_hook(dio_bio->bi_op | dio_bio->bi_rw, dip,
-				       skip_sum);
+	ret = btrfs_submit_direct_hook(dip, skip_sum);
 	if (!ret)
 		return;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf1e9af..c281874 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5999,7 +5999,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 
 static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 			      struct bio *bio, u64 physical, int dev_nr,
-			      int rw, int async)
+			      int async)
 {
 	struct btrfs_device *dev = bbio->stripes[dev_nr].dev;
 
@@ -6044,7 +6044,7 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 	}
 }
 
-int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
+int btrfs_map_bio(struct btrfs_root *root,struct bio *bio,
 		  int mirror_num, int async_submit)
 {
 	struct btrfs_device *dev;
@@ -6110,7 +6110,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			bio = first_bio;
 
 		submit_stripe_bio(root, bbio, bio,
-				  bbio->stripes[dev_nr].physical, dev_nr, rw,
+				  bbio->stripes[dev_nr].physical, dev_nr,
 				  async_submit);
 	}
 	btrfs_bio_counter_dec(root->fs_info);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8ef796a..5a2da8a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -437,7 +437,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 type);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
 void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
-int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
+int btrfs_map_bio(struct btrfs_root *root, struct bio *bio,
 		  int mirror_num, int async_submit);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
