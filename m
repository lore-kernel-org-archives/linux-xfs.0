Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:43562 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbeETW0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:24 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 03/12] pktcdvd: convert to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:49 -0400
Message-Id: <20180520222558.7053-4-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/block/pktcdvd.c | 50 ++++++++++++++++++++---------------------
 include/linux/pktcdvd.h |  2 +-
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d8aff7f325..69875f5580 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -97,8 +97,8 @@ static int pktdev_major;
 static int write_congestion_on  = PKT_WRITE_CONGESTION_ON;
 static int write_congestion_off = PKT_WRITE_CONGESTION_OFF;
 static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
-static mempool_t *psd_pool;
-static struct bio_set *pkt_bio_set;
+static mempool_t psd_pool;
+static struct bio_set pkt_bio_set;
 
 static struct class	*class_pktcdvd = NULL;    /* /sys/class/pktcdvd */
 static struct dentry	*pkt_debugfs_root = NULL; /* /sys/kernel/debug/pktcdvd */
@@ -631,7 +631,7 @@ static inline struct pkt_rb_node *pkt_rbtree_next(struct pkt_rb_node *node)
 static void pkt_rbtree_erase(struct pktcdvd_device *pd, struct pkt_rb_node *node)
 {
 	rb_erase(&node->rb_node, &pd->bio_queue);
-	mempool_free(node, pd->rb_pool);
+	mempool_free(node, &pd->rb_pool);
 	pd->bio_queue_size--;
 	BUG_ON(pd->bio_queue_size < 0);
 }
@@ -2303,14 +2303,14 @@ static void pkt_end_io_read_cloned(struct bio *bio)
 	psd->bio->bi_status = bio->bi_status;
 	bio_put(bio);
 	bio_endio(psd->bio);
-	mempool_free(psd, psd_pool);
+	mempool_free(psd, &psd_pool);
 	pkt_bio_finished(pd);
 }
 
 static void pkt_make_request_read(struct pktcdvd_device *pd, struct bio *bio)
 {
-	struct bio *cloned_bio = bio_clone_fast(bio, GFP_NOIO, pkt_bio_set);
-	struct packet_stacked_data *psd = mempool_alloc(psd_pool, GFP_NOIO);
+	struct bio *cloned_bio = bio_clone_fast(bio, GFP_NOIO, &pkt_bio_set);
+	struct packet_stacked_data *psd = mempool_alloc(&psd_pool, GFP_NOIO);
 
 	psd->pd = pd;
 	psd->bio = bio;
@@ -2381,7 +2381,7 @@ static void pkt_make_request_write(struct request_queue *q, struct bio *bio)
 	/*
 	 * No matching packet found. Store the bio in the work queue.
 	 */
-	node = mempool_alloc(pd->rb_pool, GFP_NOIO);
+	node = mempool_alloc(&pd->rb_pool, GFP_NOIO);
 	node->bio = bio;
 	spin_lock(&pd->lock);
 	BUG_ON(pd->bio_queue_size < 0);
@@ -2451,7 +2451,7 @@ static blk_qc_t pkt_make_request(struct request_queue *q, struct bio *bio)
 
 			split = bio_split(bio, last_zone -
 					  bio->bi_iter.bi_sector,
-					  GFP_NOIO, pkt_bio_set);
+					  GFP_NOIO, &pkt_bio_set);
 			bio_chain(split, bio);
 		} else {
 			split = bio;
@@ -2707,9 +2707,9 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	if (!pd)
 		goto out_mutex;
 
-	pd->rb_pool = mempool_create_kmalloc_pool(PKT_RB_POOL_SIZE,
-						  sizeof(struct pkt_rb_node));
-	if (!pd->rb_pool)
+	ret = mempool_init_kmalloc_pool(&pd->rb_pool, PKT_RB_POOL_SIZE,
+					sizeof(struct pkt_rb_node));
+	if (ret)
 		goto out_mem;
 
 	INIT_LIST_HEAD(&pd->cdrw.pkt_free_list);
@@ -2766,7 +2766,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 out_mem2:
 	put_disk(disk);
 out_mem:
-	mempool_destroy(pd->rb_pool);
+	mempool_exit(&pd->rb_pool);
 	kfree(pd);
 out_mutex:
 	mutex_unlock(&ctl_mutex);
@@ -2817,7 +2817,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	blk_cleanup_queue(pd->disk->queue);
 	put_disk(pd->disk);
 
-	mempool_destroy(pd->rb_pool);
+	mempool_exit(&pd->rb_pool);
 	kfree(pd);
 
 	/* This is safe: open() is still holding a reference. */
@@ -2914,14 +2914,14 @@ static int __init pkt_init(void)
 
 	mutex_init(&ctl_mutex);
 
-	psd_pool = mempool_create_kmalloc_pool(PSD_POOL_SIZE,
-					sizeof(struct packet_stacked_data));
-	if (!psd_pool)
-		return -ENOMEM;
-	pkt_bio_set = bioset_create(BIO_POOL_SIZE, 0, 0);
-	if (!pkt_bio_set) {
-		mempool_destroy(psd_pool);
-		return -ENOMEM;
+	ret = mempool_init_kmalloc_pool(&psd_pool, PSD_POOL_SIZE,
+				    sizeof(struct packet_stacked_data));
+	if (ret)
+		return ret;
+	ret = bioset_init(&pkt_bio_set, BIO_POOL_SIZE, 0, 0);
+	if (ret) {
+		mempool_exit(&psd_pool);
+		return ret;
 	}
 
 	ret = register_blkdev(pktdev_major, DRIVER_NAME);
@@ -2954,8 +2954,8 @@ static int __init pkt_init(void)
 out:
 	unregister_blkdev(pktdev_major, DRIVER_NAME);
 out2:
-	mempool_destroy(psd_pool);
-	bioset_free(pkt_bio_set);
+	mempool_exit(&psd_pool);
+	bioset_exit(&pkt_bio_set);
 	return ret;
 }
 
@@ -2968,8 +2968,8 @@ static void __exit pkt_exit(void)
 	pkt_sysfs_cleanup();
 
 	unregister_blkdev(pktdev_major, DRIVER_NAME);
-	mempool_destroy(psd_pool);
-	bioset_free(pkt_bio_set);
+	mempool_exit(&psd_pool);
+	bioset_exit(&pkt_bio_set);
 }
 
 MODULE_DESCRIPTION("Packet writing layer for CD/DVD drives");
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 93d142ad15..174601554b 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -186,7 +186,7 @@ struct pktcdvd_device
 	sector_t		current_sector;	/* Keep track of where the elevator is */
 	atomic_t		scan_queue;	/* Set to non-zero when pkt_handle_queue */
 						/* needs to be run. */
-	mempool_t		*rb_pool;	/* mempool for pkt_rb_node allocations */
+	mempool_t		rb_pool;	/* mempool for pkt_rb_node allocations */
 
 	struct packet_iosched   iosched;
 	struct gendisk		*disk;
-- 
2.17.0

