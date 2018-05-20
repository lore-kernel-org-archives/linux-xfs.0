Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35342 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbeETW0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:20 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 01/12] block: convert bounce, q->bio_split to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:47 -0400
Message-Id: <20180520222558.7053-2-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 block/blk-core.c       |  7 ++++---
 block/blk-merge.c      |  8 +++----
 block/blk-sysfs.c      |  3 +--
 block/bounce.c         | 47 ++++++++++++++++++++++--------------------
 drivers/md/dm.c        |  2 +-
 include/linux/bio.h    |  5 +++++
 include/linux/blkdev.h |  2 +-
 7 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 43370faee9..a3a7462961 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -998,6 +998,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 					   spinlock_t *lock)
 {
 	struct request_queue *q;
+	int ret;
 
 	q = kmem_cache_alloc_node(blk_requestq_cachep,
 				gfp_mask | __GFP_ZERO, node_id);
@@ -1008,8 +1009,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 	if (q->id < 0)
 		goto fail_q;
 
-	q->bio_split = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-	if (!q->bio_split)
+	ret = bioset_init(&q->bio_split, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (ret)
 		goto fail_id;
 
 	q->backing_dev_info = bdi_alloc_node(gfp_mask, node_id);
@@ -1081,7 +1082,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 fail_stats:
 	bdi_put(q->backing_dev_info);
 fail_split:
-	bioset_free(q->bio_split);
+	bioset_exit(&q->bio_split);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5573d0fbec..d70ab08820 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -188,16 +188,16 @@ void blk_queue_split(struct request_queue *q, struct bio **bio)
 	switch (bio_op(*bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-		split = blk_bio_discard_split(q, *bio, q->bio_split, &nsegs);
+		split = blk_bio_discard_split(q, *bio, &q->bio_split, &nsegs);
 		break;
 	case REQ_OP_WRITE_ZEROES:
-		split = blk_bio_write_zeroes_split(q, *bio, q->bio_split, &nsegs);
+		split = blk_bio_write_zeroes_split(q, *bio, &q->bio_split, &nsegs);
 		break;
 	case REQ_OP_WRITE_SAME:
-		split = blk_bio_write_same_split(q, *bio, q->bio_split, &nsegs);
+		split = blk_bio_write_same_split(q, *bio, &q->bio_split, &nsegs);
 		break;
 	default:
-		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
+		split = blk_bio_segment_split(q, *bio, &q->bio_split, &nsegs);
 		break;
 	}
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cae525b7aa..18de028c38 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -824,8 +824,7 @@ static void __blk_release_queue(struct work_struct *work)
 	if (q->mq_ops)
 		blk_mq_debugfs_unregister(q);
 
-	if (q->bio_split)
-		bioset_free(q->bio_split);
+	bioset_exit(&q->bio_split);
 
 	ida_simple_remove(&blk_queue_ida, q->id);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
diff --git a/block/bounce.c b/block/bounce.c
index fea9c8146d..7a6c4d50b5 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -28,28 +28,29 @@
 #define POOL_SIZE	64
 #define ISA_POOL_SIZE	16
 
-static struct bio_set *bounce_bio_set, *bounce_bio_split;
-static mempool_t *page_pool, *isa_page_pool;
+static struct bio_set bounce_bio_set, bounce_bio_split;
+static mempool_t page_pool, isa_page_pool;
 
 #if defined(CONFIG_HIGHMEM)
 static __init int init_emergency_pool(void)
 {
+	int ret;
 #if defined(CONFIG_HIGHMEM) && !defined(CONFIG_MEMORY_HOTPLUG)
 	if (max_pfn <= max_low_pfn)
 		return 0;
 #endif
 
-	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
-	BUG_ON(!page_pool);
+	ret = mempool_init_page_pool(&page_pool, POOL_SIZE, 0);
+	BUG_ON(ret);
 	pr_info("pool size: %d pages\n", POOL_SIZE);
 
-	bounce_bio_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-	BUG_ON(!bounce_bio_set);
+	ret = bioset_init(&bounce_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	BUG_ON(ret);
 	if (bioset_integrity_create(bounce_bio_set, BIO_POOL_SIZE))
 		BUG_ON(1);
 
-	bounce_bio_split = bioset_create(BIO_POOL_SIZE, 0, 0);
-	BUG_ON(!bounce_bio_split);
+	ret = bioset_init(&bounce_bio_split, BIO_POOL_SIZE, 0, 0);
+	BUG_ON(ret);
 
 	return 0;
 }
@@ -91,12 +92,14 @@ static void *mempool_alloc_pages_isa(gfp_t gfp_mask, void *data)
  */
 int init_emergency_isa_pool(void)
 {
-	if (isa_page_pool)
+	int ret;
+
+	if (mempool_initialized(&isa_page_pool))
 		return 0;
 
-	isa_page_pool = mempool_create(ISA_POOL_SIZE, mempool_alloc_pages_isa,
-				       mempool_free_pages, (void *) 0);
-	BUG_ON(!isa_page_pool);
+	ret = mempool_init(&isa_page_pool, ISA_POOL_SIZE, mempool_alloc_pages_isa,
+			   mempool_free_pages, (void *) 0);
+	BUG_ON(ret);
 
 	pr_info("isa pool size: %d pages\n", ISA_POOL_SIZE);
 	return 0;
@@ -163,13 +166,13 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool)
 
 static void bounce_end_io_write(struct bio *bio)
 {
-	bounce_end_io(bio, page_pool);
+	bounce_end_io(bio, &page_pool);
 }
 
 static void bounce_end_io_write_isa(struct bio *bio)
 {
 
-	bounce_end_io(bio, isa_page_pool);
+	bounce_end_io(bio, &isa_page_pool);
 }
 
 static void __bounce_end_io_read(struct bio *bio, mempool_t *pool)
@@ -184,12 +187,12 @@ static void __bounce_end_io_read(struct bio *bio, mempool_t *pool)
 
 static void bounce_end_io_read(struct bio *bio)
 {
-	__bounce_end_io_read(bio, page_pool);
+	__bounce_end_io_read(bio, &page_pool);
 }
 
 static void bounce_end_io_read_isa(struct bio *bio)
 {
-	__bounce_end_io_read(bio, isa_page_pool);
+	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
@@ -214,13 +217,13 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		return;
 
 	if (!passthrough && sectors < bio_sectors(*bio_orig)) {
-		bio = bio_split(*bio_orig, sectors, GFP_NOIO, bounce_bio_split);
+		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
 		generic_make_request(*bio_orig);
 		*bio_orig = bio;
 	}
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, passthrough ? NULL :
-			bounce_bio_set);
+			&bounce_bio_set);
 
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
@@ -247,7 +250,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 
 	bio->bi_flags |= (1 << BIO_BOUNCED);
 
-	if (pool == page_pool) {
+	if (pool == &page_pool) {
 		bio->bi_end_io = bounce_end_io_write;
 		if (rw == READ)
 			bio->bi_end_io = bounce_end_io_read;
@@ -279,10 +282,10 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	if (!(q->bounce_gfp & GFP_DMA)) {
 		if (q->limits.bounce_pfn >= blk_max_pfn)
 			return;
-		pool = page_pool;
+		pool = &page_pool;
 	} else {
-		BUG_ON(!isa_page_pool);
-		pool = isa_page_pool;
+		BUG_ON(!mempool_initialized(&isa_page_pool));
+		pool = &isa_page_pool;
 	}
 
 	/*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4ea404dbcf..7d98ee1137 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1582,7 +1582,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				 * won't be affected by this reassignment.
 				 */
 				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
-								 md->queue->bio_split);
+								 &md->queue->bio_split);
 				ci.io->orig_bio = b;
 				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
 				bio_chain(b, bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 98b175cc00..5e472fcafa 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -760,6 +760,11 @@ struct biovec_slab {
 	struct kmem_cache *slab;
 };
 
+static inline bool bioset_initialized(struct bio_set *bs)
+{
+	return bs->bio_slab != NULL;
+}
+
 /*
  * a small number of entries is fine, not going to be performance critical.
  * basically we just need to survive
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f3999719f8..8b4841117f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -664,7 +664,7 @@ struct request_queue {
 
 	struct blk_mq_tag_set	*tag_set;
 	struct list_head	tag_set_list;
-	struct bio_set		*bio_split;
+	struct bio_set		bio_split;
 
 #ifdef CONFIG_BLK_DEBUG_FS
 	struct dentry		*debugfs_dir;
-- 
2.17.0

