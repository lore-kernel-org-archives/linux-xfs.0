Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37706 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbeETW0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:31 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 06/12] md: convert to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:52 -0400
Message-Id: <20180520222558.7053-7-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/md-faulty.c    |  2 +-
 drivers/md/md-linear.c    |  2 +-
 drivers/md/md-multipath.c | 17 ++++-----
 drivers/md/md-multipath.h |  2 +-
 drivers/md/md.c           | 61 +++++++++++++------------------
 drivers/md/md.h           |  4 +--
 drivers/md/raid0.c        |  5 +--
 drivers/md/raid1.c        | 76 +++++++++++++++++++--------------------
 drivers/md/raid1.h        |  6 ++--
 drivers/md/raid10.c       | 60 +++++++++++++++----------------
 drivers/md/raid10.h       |  6 ++--
 drivers/md/raid5-cache.c  | 43 +++++++++++-----------
 drivers/md/raid5-ppl.c    | 42 +++++++++-------------
 drivers/md/raid5.c        | 12 +++----
 drivers/md/raid5.h        |  2 +-
 15 files changed, 159 insertions(+), 181 deletions(-)

diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 38264b3842..c2fdf899de 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -214,7 +214,7 @@ static bool faulty_make_request(struct mddev *mddev, struct bio *bio)
 		}
 	}
 	if (failit) {
-		struct bio *b = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+		struct bio *b = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 
 		bio_set_dev(b, conf->rdev->bdev);
 		b->bi_private = bio;
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 4964323d93..d45c697c0e 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -269,7 +269,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 	if (unlikely(bio_end_sector(bio) > end_sector)) {
 		/* This bio crosses a device boundary, so we have to split it */
 		struct bio *split = bio_split(bio, end_sector - bio_sector,
-					      GFP_NOIO, mddev->bio_set);
+					      GFP_NOIO, &mddev->bio_set);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 0a7e99d62c..f71fcdb9b3 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -80,7 +80,7 @@ static void multipath_end_bh_io(struct multipath_bh *mp_bh, blk_status_t status)
 
 	bio->bi_status = status;
 	bio_endio(bio);
-	mempool_free(mp_bh, conf->pool);
+	mempool_free(mp_bh, &conf->pool);
 }
 
 static void multipath_end_request(struct bio *bio)
@@ -117,7 +117,7 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 		return true;
 	}
 
-	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
+	mp_bh = mempool_alloc(&conf->pool, GFP_NOIO);
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
@@ -125,7 +125,7 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
 		bio_io_error(bio);
-		mempool_free(mp_bh, conf->pool);
+		mempool_free(mp_bh, &conf->pool);
 		return true;
 	}
 	multipath = conf->multipaths + mp_bh->path;
@@ -378,6 +378,7 @@ static int multipath_run (struct mddev *mddev)
 	struct multipath_info *disk;
 	struct md_rdev *rdev;
 	int working_disks;
+	int ret;
 
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
@@ -431,9 +432,9 @@ static int multipath_run (struct mddev *mddev)
 	}
 	mddev->degraded = conf->raid_disks - working_disks;
 
-	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
-						 sizeof(struct multipath_bh));
-	if (conf->pool == NULL)
+	ret = mempool_init_kmalloc_pool(&conf->pool, NR_RESERVED_BUFS,
+					sizeof(struct multipath_bh));
+	if (ret)
 		goto out_free_conf;
 
 	mddev->thread = md_register_thread(multipathd, mddev,
@@ -455,7 +456,7 @@ static int multipath_run (struct mddev *mddev)
 	return 0;
 
 out_free_conf:
-	mempool_destroy(conf->pool);
+	mempool_exit(&conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
 	mddev->private = NULL;
@@ -467,7 +468,7 @@ static void multipath_free(struct mddev *mddev, void *priv)
 {
 	struct mpconf *conf = priv;
 
-	mempool_destroy(conf->pool);
+	mempool_exit(&conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
 }
diff --git a/drivers/md/md-multipath.h b/drivers/md/md-multipath.h
index 0adb941f48..b3099e5fc4 100644
--- a/drivers/md/md-multipath.h
+++ b/drivers/md/md-multipath.h
@@ -13,7 +13,7 @@ struct mpconf {
 	spinlock_t		device_lock;
 	struct list_head	retry_list;
 
-	mempool_t		*pool;
+	mempool_t		pool;
 };
 
 /*
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c208c01f63..fc692b7128 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -193,10 +193,10 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 {
 	struct bio *b;
 
-	if (!mddev || !mddev->bio_set)
+	if (!mddev || !bioset_initialized(&mddev->bio_set))
 		return bio_alloc(gfp_mask, nr_iovecs);
 
-	b = bio_alloc_bioset(gfp_mask, nr_iovecs, mddev->bio_set);
+	b = bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
 	if (!b)
 		return NULL;
 	return b;
@@ -205,10 +205,10 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 
 static struct bio *md_bio_alloc_sync(struct mddev *mddev)
 {
-	if (!mddev || !mddev->sync_set)
+	if (!mddev || !bioset_initialized(&mddev->sync_set))
 		return bio_alloc(GFP_NOIO, 1);
 
-	return bio_alloc_bioset(GFP_NOIO, 1, mddev->sync_set);
+	return bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
 }
 
 /*
@@ -510,7 +510,10 @@ static void mddev_delayed_delete(struct work_struct *ws);
 
 static void mddev_put(struct mddev *mddev)
 {
-	struct bio_set *bs = NULL, *sync_bs = NULL;
+	struct bio_set bs, sync_bs;
+
+	memset(&bs, 0, sizeof(bs));
+	memset(&sync_bs, 0, sizeof(sync_bs));
 
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
@@ -521,8 +524,8 @@ static void mddev_put(struct mddev *mddev)
 		list_del_init(&mddev->all_mddevs);
 		bs = mddev->bio_set;
 		sync_bs = mddev->sync_set;
-		mddev->bio_set = NULL;
-		mddev->sync_set = NULL;
+		memset(&mddev->bio_set, 0, sizeof(mddev->bio_set));
+		memset(&mddev->sync_set, 0, sizeof(mddev->sync_set));
 		if (mddev->gendisk) {
 			/* We did a probe so need to clean up.  Call
 			 * queue_work inside the spinlock so that
@@ -535,10 +538,8 @@ static void mddev_put(struct mddev *mddev)
 			kfree(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
-	if (bs)
-		bioset_free(bs);
-	if (sync_bs)
-		bioset_free(sync_bs);
+	bioset_exit(&bs);
+	bioset_exit(&sync_bs);
 }
 
 static void md_safemode_timeout(struct timer_list *t);
@@ -2123,7 +2124,7 @@ int md_integrity_register(struct mddev *mddev)
 			       bdev_get_integrity(reference->bdev));
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(mddev->bio_set, BIO_POOL_SIZE)) {
+	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
@@ -5497,17 +5498,15 @@ int md_run(struct mddev *mddev)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	}
 
-	if (mddev->bio_set == NULL) {
-		mddev->bio_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (!mddev->bio_set)
-			return -ENOMEM;
+	if (!bioset_initialized(&mddev->bio_set)) {
+		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+		if (err)
+			return err;
 	}
-	if (mddev->sync_set == NULL) {
-		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (!mddev->sync_set) {
-			err = -ENOMEM;
+	if (!bioset_initialized(&mddev->sync_set)) {
+		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+		if (err)
 			goto abort;
-		}
 	}
 
 	spin_lock(&pers_lock);
@@ -5668,14 +5667,8 @@ int md_run(struct mddev *mddev)
 	return 0;
 
 abort:
-	if (mddev->bio_set) {
-		bioset_free(mddev->bio_set);
-		mddev->bio_set = NULL;
-	}
-	if (mddev->sync_set) {
-		bioset_free(mddev->sync_set);
-		mddev->sync_set = NULL;
-	}
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
 
 	return err;
 }
@@ -5888,14 +5881,8 @@ void md_stop(struct mddev *mddev)
 	 * This is called from dm-raid
 	 */
 	__md_stop(mddev);
-	if (mddev->bio_set) {
-		bioset_free(mddev->bio_set);
-		mddev->bio_set = NULL;
-	}
-	if (mddev->sync_set) {
-		bioset_free(mddev->sync_set);
-		mddev->sync_set = NULL;
-	}
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fbc925cce8..3507cab22c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -452,8 +452,8 @@ struct mddev {
 
 	struct attribute_group		*to_remove;
 
-	struct bio_set			*bio_set;
-	struct bio_set			*sync_set; /* for sync operations like
+	struct bio_set			bio_set;
+	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 584c103472..65ae47a022 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -479,7 +479,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (bio_end_sector(bio) > zone->zone_end) {
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
-			mddev->bio_set);
+			&mddev->bio_set);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -582,7 +582,8 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	sector = bio_sector;
 
 	if (sectors < bio_sectors(bio)) {
-		struct bio *split = bio_split(bio, sectors, GFP_NOIO, mddev->bio_set);
+		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
+					      &mddev->bio_set);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e9e3308cb0..bad2852071 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -221,7 +221,7 @@ static void free_r1bio(struct r1bio *r1_bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 
 	put_all_bios(conf, r1_bio);
-	mempool_free(r1_bio, conf->r1bio_pool);
+	mempool_free(r1_bio, &conf->r1bio_pool);
 }
 
 static void put_buf(struct r1bio *r1_bio)
@@ -236,7 +236,7 @@ static void put_buf(struct r1bio *r1_bio)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
 	}
 
-	mempool_free(r1_bio, conf->r1buf_pool);
+	mempool_free(r1_bio, &conf->r1buf_pool);
 
 	lower_barrier(conf, sect);
 }
@@ -1178,7 +1178,7 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 
-	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
 	/* Ensure no bio records IO_BLOCKED */
 	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
 	init_r1bio(r1_bio, mddev, bio);
@@ -1268,7 +1268,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
-					      gfp, conf->bio_split);
+					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1278,7 +1278,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio->read_disk = rdisk;
 
-	read_bio = bio_clone_fast(bio, gfp, mddev->bio_set);
+	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r1_bio->bios[rdisk] = read_bio;
 
@@ -1439,7 +1439,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
-					      GFP_NOIO, conf->bio_split);
+					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1479,9 +1479,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (r1_bio->behind_master_bio)
 			mbio = bio_clone_fast(r1_bio->behind_master_bio,
-					      GFP_NOIO, mddev->bio_set);
+					      GFP_NOIO, &mddev->bio_set);
 		else
-			mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+			mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 
 		if (r1_bio->behind_master_bio) {
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
@@ -1657,8 +1657,7 @@ static void close_sync(struct r1conf *conf)
 		_allow_barrier(conf, idx);
 	}
 
-	mempool_destroy(conf->r1buf_pool);
-	conf->r1buf_pool = NULL;
+	mempool_exit(&conf->r1buf_pool);
 }
 
 static int raid1_spare_active(struct mddev *mddev)
@@ -2348,10 +2347,10 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			wbio = bio_clone_fast(r1_bio->behind_master_bio,
 					      GFP_NOIO,
-					      mddev->bio_set);
+					      &mddev->bio_set);
 		} else {
 			wbio = bio_clone_fast(r1_bio->master_bio, GFP_NOIO,
-					      mddev->bio_set);
+					      &mddev->bio_set);
 		}
 
 		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
@@ -2564,17 +2563,15 @@ static int init_resync(struct r1conf *conf)
 	int buffs;
 
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
-	BUG_ON(conf->r1buf_pool);
-	conf->r1buf_pool = mempool_create(buffs, r1buf_pool_alloc, r1buf_pool_free,
-					  conf->poolinfo);
-	if (!conf->r1buf_pool)
-		return -ENOMEM;
-	return 0;
+	BUG_ON(mempool_initialized(&conf->r1buf_pool));
+
+	return mempool_init(&conf->r1buf_pool, buffs, r1buf_pool_alloc,
+			    r1buf_pool_free, conf->poolinfo);
 }
 
 static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
 {
-	struct r1bio *r1bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
+	struct r1bio *r1bio = mempool_alloc(&conf->r1buf_pool, GFP_NOIO);
 	struct resync_pages *rps;
 	struct bio *bio;
 	int i;
@@ -2617,7 +2614,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int idx = sector_to_idx(sector_nr);
 	int page_idx = 0;
 
-	if (!conf->r1buf_pool)
+	if (!mempool_initialized(&conf->r1buf_pool))
 		if (init_resync(conf))
 			return 0;
 
@@ -2953,14 +2950,13 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-					  r1bio_pool_free,
-					  conf->poolinfo);
-	if (!conf->r1bio_pool)
+	err = mempool_init(&conf->r1bio_pool, NR_RAID1_BIOS, r1bio_pool_alloc,
+			   r1bio_pool_free, conf->poolinfo);
+	if (err)
 		goto abort;
 
-	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0, 0);
-	if (!conf->bio_split)
+	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
+	if (err)
 		goto abort;
 
 	conf->poolinfo->mddev = mddev;
@@ -3033,7 +3029,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
  abort:
 	if (conf) {
-		mempool_destroy(conf->r1bio_pool);
+		mempool_exit(&conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
@@ -3041,8 +3037,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
 		kfree(conf->barrier);
-		if (conf->bio_split)
-			bioset_free(conf->bio_split);
+		bioset_exit(&conf->bio_split);
 		kfree(conf);
 	}
 	return ERR_PTR(err);
@@ -3144,7 +3139,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
-	mempool_destroy(conf->r1bio_pool);
+	mempool_exit(&conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
@@ -3152,8 +3147,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
 	kfree(conf->barrier);
-	if (conf->bio_split)
-		bioset_free(conf->bio_split);
+	bioset_exit(&conf->bio_split);
 	kfree(conf);
 }
 
@@ -3199,13 +3193,17 @@ static int raid1_reshape(struct mddev *mddev)
 	 * At the same time, we "pack" the devices so that all the missing
 	 * devices have the higher raid_disk numbers.
 	 */
-	mempool_t *newpool, *oldpool;
+	mempool_t newpool, oldpool;
 	struct pool_info *newpoolinfo;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
 	unsigned long flags;
 	int d, d2;
+	int ret;
+
+	memset(&newpool, 0, sizeof(newpool));
+	memset(&oldpool, 0, sizeof(oldpool));
 
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
@@ -3237,17 +3235,17 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	newpool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-				 r1bio_pool_free, newpoolinfo);
-	if (!newpool) {
+	ret = mempool_init(&newpool, NR_RAID1_BIOS, r1bio_pool_alloc,
+			   r1bio_pool_free, newpoolinfo);
+	if (ret) {
 		kfree(newpoolinfo);
-		return -ENOMEM;
+		return ret;
 	}
 	newmirrors = kzalloc(sizeof(struct raid1_info) * raid_disks * 2,
 			     GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
-		mempool_destroy(newpool);
+		mempool_exit(&newpool);
 		return -ENOMEM;
 	}
 
@@ -3287,7 +3285,7 @@ static int raid1_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 
-	mempool_destroy(oldpool);
+	mempool_exit(&oldpool);
 	return 0;
 }
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index eb84bc68e2..e7ccad8987 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -118,10 +118,10 @@ struct r1conf {
 	 * mempools - it changes when the array grows or shrinks
 	 */
 	struct pool_info	*poolinfo;
-	mempool_t		*r1bio_pool;
-	mempool_t		*r1buf_pool;
+	mempool_t		r1bio_pool;
+	mempool_t		r1buf_pool;
 
-	struct bio_set		*bio_split;
+	struct bio_set		bio_split;
 
 	/* temporary buffer to synchronous IO when attempting to repair
 	 * a read error.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3c60774c84..37d4b236b8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -291,14 +291,14 @@ static void free_r10bio(struct r10bio *r10_bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	put_all_bios(conf, r10_bio);
-	mempool_free(r10_bio, conf->r10bio_pool);
+	mempool_free(r10_bio, &conf->r10bio_pool);
 }
 
 static void put_buf(struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
 
-	mempool_free(r10_bio, conf->r10buf_pool);
+	mempool_free(r10_bio, &conf->r10buf_pool);
 
 	lower_barrier(conf);
 }
@@ -1204,7 +1204,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 				   (unsigned long long)r10_bio->sector);
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
-					      gfp, conf->bio_split);
+					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1213,7 +1213,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	read_bio = bio_clone_fast(bio, gfp, mddev->bio_set);
+	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
@@ -1261,7 +1261,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	} else
 		rdev = conf->mirrors[devnum].rdev;
 
-	mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+	mbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 	if (replacement)
 		r10_bio->devs[n_copy].repl_bio = mbio;
 	else
@@ -1509,7 +1509,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
-					      GFP_NOIO, conf->bio_split);
+					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1533,7 +1533,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
@@ -1732,8 +1732,7 @@ static void close_sync(struct r10conf *conf)
 	wait_barrier(conf);
 	allow_barrier(conf);
 
-	mempool_destroy(conf->r10buf_pool);
-	conf->r10buf_pool = NULL;
+	mempool_exit(&conf->r10buf_pool);
 }
 
 static int raid10_spare_active(struct mddev *mddev)
@@ -2583,7 +2582,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
-		wbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+		wbio = bio_clone_fast(bio, GFP_NOIO, &mddev->bio_set);
 		bio_trim(wbio, sector - bio->bi_iter.bi_sector, sectors);
 		wsector = r10_bio->devs[i].addr + (sector - r10_bio->sector);
 		wbio->bi_iter.bi_sector = wsector +
@@ -2816,25 +2815,25 @@ static void raid10d(struct md_thread *thread)
 
 static int init_resync(struct r10conf *conf)
 {
-	int buffs;
-	int i;
+	int ret, buffs, i;
 
 	buffs = RESYNC_WINDOW / RESYNC_BLOCK_SIZE;
-	BUG_ON(conf->r10buf_pool);
+	BUG_ON(mempool_initialized(&conf->r10buf_pool));
 	conf->have_replacement = 0;
 	for (i = 0; i < conf->geo.raid_disks; i++)
 		if (conf->mirrors[i].replacement)
 			conf->have_replacement = 1;
-	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf);
-	if (!conf->r10buf_pool)
-		return -ENOMEM;
+	ret = mempool_init(&conf->r10buf_pool, buffs,
+			   r10buf_pool_alloc, r10buf_pool_free, conf);
+	if (ret)
+		return ret;
 	conf->next_resync = 0;
 	return 0;
 }
 
 static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 {
-	struct r10bio *r10bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
+	struct r10bio *r10bio = mempool_alloc(&conf->r10buf_pool, GFP_NOIO);
 	struct rsync_pages *rp;
 	struct bio *bio;
 	int nalloc;
@@ -2945,7 +2944,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
 
-	if (!conf->r10buf_pool)
+	if (!mempool_initialized(&conf->r10buf_pool))
 		if (init_resync(conf))
 			return 0;
 
@@ -3699,13 +3698,13 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	conf->geo = geo;
 	conf->copies = copies;
-	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
-					   r10bio_pool_free, conf);
-	if (!conf->r10bio_pool)
+	err = mempool_init(&conf->r10bio_pool, NR_RAID10_BIOS, r10bio_pool_alloc,
+			   r10bio_pool_free, conf);
+	if (err)
 		goto out;
 
-	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0, 0);
-	if (!conf->bio_split)
+	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
+	if (err)
 		goto out;
 
 	calc_sectors(conf, mddev->dev_sectors);
@@ -3733,6 +3732,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	init_waitqueue_head(&conf->wait_barrier);
 	atomic_set(&conf->nr_pending, 0);
 
+	err = -ENOMEM;
 	conf->thread = md_register_thread(raid10d, mddev, "raid10");
 	if (!conf->thread)
 		goto out;
@@ -3742,11 +3742,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
  out:
 	if (conf) {
-		mempool_destroy(conf->r10bio_pool);
+		mempool_exit(&conf->r10bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
-		if (conf->bio_split)
-			bioset_free(conf->bio_split);
+		bioset_exit(&conf->bio_split);
 		kfree(conf);
 	}
 	return ERR_PTR(err);
@@ -3953,7 +3952,7 @@ static int raid10_run(struct mddev *mddev)
 
 out_free_conf:
 	md_unregister_thread(&mddev->thread);
-	mempool_destroy(conf->r10bio_pool);
+	mempool_exit(&conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
@@ -3966,13 +3965,12 @@ static void raid10_free(struct mddev *mddev, void *priv)
 {
 	struct r10conf *conf = priv;
 
-	mempool_destroy(conf->r10bio_pool);
+	mempool_exit(&conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
-	if (conf->bio_split)
-		bioset_free(conf->bio_split);
+	bioset_exit(&conf->bio_split);
 	kfree(conf);
 }
 
@@ -4543,7 +4541,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		 * on all the target devices.
 		 */
 		// FIXME
-		mempool_free(r10_bio, conf->r10buf_pool);
+		mempool_free(r10_bio, &conf->r10buf_pool);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return sectors_done;
 	}
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index e2e8840de9..d3eaaf3eb1 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -93,10 +93,10 @@ struct r10conf {
 						   */
 	wait_queue_head_t	wait_barrier;
 
-	mempool_t		*r10bio_pool;
-	mempool_t		*r10buf_pool;
+	mempool_t		r10bio_pool;
+	mempool_t		r10buf_pool;
 	struct page		*tmppage;
-	struct bio_set		*bio_split;
+	struct bio_set		bio_split;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3c65f52b68..2b775abf37 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -125,9 +125,9 @@ struct r5l_log {
 	struct list_head no_mem_stripes;   /* pending stripes, -ENOMEM */
 
 	struct kmem_cache *io_kc;
-	mempool_t *io_pool;
-	struct bio_set *bs;
-	mempool_t *meta_pool;
+	mempool_t io_pool;
+	struct bio_set bs;
+	mempool_t meta_pool;
 
 	struct md_thread *reclaim_thread;
 	unsigned long reclaim_target;	/* number of space that need to be
@@ -579,7 +579,7 @@ static void r5l_log_endio(struct bio *bio)
 		md_error(log->rdev->mddev, log->rdev);
 
 	bio_put(bio);
-	mempool_free(io->meta_page, log->meta_pool);
+	mempool_free(io->meta_page, &log->meta_pool);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
@@ -748,7 +748,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log)
 {
-	struct bio *bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
+	struct bio *bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, &log->bs);
 
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio_set_dev(bio, log->rdev->bdev);
@@ -780,7 +780,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
 
-	io = mempool_alloc(log->io_pool, GFP_ATOMIC);
+	io = mempool_alloc(&log->io_pool, GFP_ATOMIC);
 	if (!io)
 		return NULL;
 	memset(io, 0, sizeof(*io));
@@ -791,7 +791,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	bio_list_init(&io->flush_barriers);
 	io->state = IO_UNIT_RUNNING;
 
-	io->meta_page = mempool_alloc(log->meta_pool, GFP_NOIO);
+	io->meta_page = mempool_alloc(&log->meta_pool, GFP_NOIO);
 	block = page_address(io->meta_page);
 	clear_page(block);
 	block->magic = cpu_to_le32(R5LOG_MAGIC);
@@ -1223,7 +1223,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 		log->next_checkpoint = io->log_start;
 
 		list_del(&io->log_sibling);
-		mempool_free(io, log->io_pool);
+		mempool_free(io, &log->io_pool);
 		r5l_run_no_mem_stripe(log);
 
 		found = true;
@@ -1647,7 +1647,7 @@ static int r5l_recovery_allocate_ra_pool(struct r5l_log *log,
 {
 	struct page *page;
 
-	ctx->ra_bio = bio_alloc_bioset(GFP_KERNEL, BIO_MAX_PAGES, log->bs);
+	ctx->ra_bio = bio_alloc_bioset(GFP_KERNEL, BIO_MAX_PAGES, &log->bs);
 	if (!ctx->ra_bio)
 		return -ENOMEM;
 
@@ -3066,6 +3066,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
 	struct r5l_log *log;
 	char b[BDEVNAME_SIZE];
+	int ret;
 
 	pr_debug("md/raid:%s: using device %s as journal\n",
 		 mdname(conf->mddev), bdevname(rdev->bdev, b));
@@ -3111,16 +3112,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->io_kc)
 		goto io_kc;
 
-	log->io_pool = mempool_create_slab_pool(R5L_POOL_SIZE, log->io_kc);
-	if (!log->io_pool)
+	ret = mempool_init_slab_pool(&log->io_pool, R5L_POOL_SIZE, log->io_kc);
+	if (ret)
 		goto io_pool;
 
-	log->bs = bioset_create(R5L_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-	if (!log->bs)
+	ret = bioset_init(&log->bs, R5L_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (ret)
 		goto io_bs;
 
-	log->meta_pool = mempool_create_page_pool(R5L_POOL_SIZE, 0);
-	if (!log->meta_pool)
+	ret = mempool_init_page_pool(&log->meta_pool, R5L_POOL_SIZE, 0);
+	if (ret)
 		goto out_mempool;
 
 	spin_lock_init(&log->tree_lock);
@@ -3155,11 +3156,11 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	rcu_assign_pointer(conf->log, NULL);
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
-	mempool_destroy(log->meta_pool);
+	mempool_exit(&log->meta_pool);
 out_mempool:
-	bioset_free(log->bs);
+	bioset_exit(&log->bs);
 io_bs:
-	mempool_destroy(log->io_pool);
+	mempool_exit(&log->io_pool);
 io_pool:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
@@ -3178,9 +3179,9 @@ void r5l_exit_log(struct r5conf *conf)
 	wake_up(&conf->mddev->sb_wait);
 	flush_work(&log->disable_writeback_work);
 	md_unregister_thread(&log->reclaim_thread);
-	mempool_destroy(log->meta_pool);
-	bioset_free(log->bs);
-	mempool_destroy(log->io_pool);
+	mempool_exit(&log->meta_pool);
+	bioset_exit(&log->bs);
+	mempool_exit(&log->io_pool);
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 42890a0837..3a7c363265 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -105,9 +105,9 @@ struct ppl_conf {
 	atomic64_t seq;		/* current log write sequence number */
 
 	struct kmem_cache *io_kc;
-	mempool_t *io_pool;
-	struct bio_set *bs;
-	struct bio_set *flush_bs;
+	mempool_t io_pool;
+	struct bio_set bs;
+	struct bio_set flush_bs;
 
 	/* used only for recovery */
 	int recovered_entries;
@@ -244,7 +244,7 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
 	struct ppl_header *pplhdr;
 	struct page *header_page;
 
-	io = mempool_alloc(ppl_conf->io_pool, GFP_NOWAIT);
+	io = mempool_alloc(&ppl_conf->io_pool, GFP_NOWAIT);
 	if (!io)
 		return NULL;
 
@@ -503,7 +503,7 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
 			struct bio *prev = bio;
 
 			bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES,
-					       ppl_conf->bs);
+					       &ppl_conf->bs);
 			bio->bi_opf = prev->bi_opf;
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
@@ -570,7 +570,7 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
 	list_del(&io->log_sibling);
 	spin_unlock(&log->io_list_lock);
 
-	mempool_free(io, ppl_conf->io_pool);
+	mempool_free(io, &ppl_conf->io_pool);
 
 	spin_lock(&ppl_conf->no_mem_stripes_lock);
 	if (!list_empty(&ppl_conf->no_mem_stripes)) {
@@ -642,7 +642,7 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 			struct bio *bio;
 			char b[BDEVNAME_SIZE];
 
-			bio = bio_alloc_bioset(GFP_NOIO, 0, ppl_conf->flush_bs);
+			bio = bio_alloc_bioset(GFP_NOIO, 0, &ppl_conf->flush_bs);
 			bio_set_dev(bio, bdev);
 			bio->bi_private = io;
 			bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
@@ -1246,11 +1246,9 @@ static void __ppl_exit_log(struct ppl_conf *ppl_conf)
 
 	kfree(ppl_conf->child_logs);
 
-	if (ppl_conf->bs)
-		bioset_free(ppl_conf->bs);
-	if (ppl_conf->flush_bs)
-		bioset_free(ppl_conf->flush_bs);
-	mempool_destroy(ppl_conf->io_pool);
+	bioset_exit(&ppl_conf->bs);
+	bioset_exit(&ppl_conf->flush_bs);
+	mempool_exit(&ppl_conf->io_pool);
 	kmem_cache_destroy(ppl_conf->io_kc);
 
 	kfree(ppl_conf);
@@ -1387,24 +1385,18 @@ int ppl_init_log(struct r5conf *conf)
 		goto err;
 	}
 
-	ppl_conf->io_pool = mempool_create(conf->raid_disks, ppl_io_pool_alloc,
-					   ppl_io_pool_free, ppl_conf->io_kc);
-	if (!ppl_conf->io_pool) {
-		ret = -ENOMEM;
+	ret = mempool_init(&ppl_conf->io_pool, conf->raid_disks, ppl_io_pool_alloc,
+			   ppl_io_pool_free, ppl_conf->io_kc);
+	if (ret)
 		goto err;
-	}
 
-	ppl_conf->bs = bioset_create(conf->raid_disks, 0, BIOSET_NEED_BVECS);
-	if (!ppl_conf->bs) {
-		ret = -ENOMEM;
+	ret = bioset_init(&ppl_conf->bs, conf->raid_disks, 0, BIOSET_NEED_BVECS);
+	if (ret)
 		goto err;
-	}
 
-	ppl_conf->flush_bs = bioset_create(conf->raid_disks, 0, 0);
-	if (!ppl_conf->flush_bs) {
-		ret = -ENOMEM;
+	ret = bioset_init(&ppl_conf->flush_bs, conf->raid_disks, 0, 0);
+	if (ret)
 		goto err;
-	}
 
 	ppl_conf->count = conf->raid_disks;
 	ppl_conf->child_logs = kcalloc(ppl_conf->count, sizeof(struct ppl_log),
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index be117d0a65..a2e64989b0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5192,7 +5192,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	/*
 	 * use bio_clone_fast to make a copy of the bio
 	 */
-	align_bi = bio_clone_fast(raid_bio, GFP_NOIO, mddev->bio_set);
+	align_bi = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->bio_set);
 	if (!align_bi)
 		return 0;
 	/*
@@ -5277,7 +5277,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
-		split = bio_split(raid_bio, sectors, GFP_NOIO, conf->bio_split);
+		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
 		generic_make_request(raid_bio);
 		raid_bio = split;
@@ -6773,8 +6773,7 @@ static void free_conf(struct r5conf *conf)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
-	if (conf->bio_split)
-		bioset_free(conf->bio_split);
+	bioset_exit(&conf->bio_split);
 	kfree(conf->stripe_hashtbl);
 	kfree(conf->pending_data);
 	kfree(conf);
@@ -6853,6 +6852,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	int i;
 	int group_cnt, worker_cnt_per_group;
 	struct r5worker_group *new_group;
+	int ret;
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -6950,8 +6950,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			goto abort;
 	}
 
-	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0, 0);
-	if (!conf->bio_split)
+	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
+	if (ret)
 		goto abort;
 	conf->mddev = mddev;
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 3f8da26032..72e75ba6ab 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -669,7 +669,7 @@ struct r5conf {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
-	struct bio_set		*bio_split;
+	struct bio_set		bio_split;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.
-- 
2.17.0

