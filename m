Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36524 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbeETW0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:33 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 07/12] dm: convert to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:53 -0400
Message-Id: <20180520222558.7053-8-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/dm-bio-prison-v1.c      | 13 ++++---
 drivers/md/dm-bio-prison-v2.c      | 13 ++++---
 drivers/md/dm-cache-target.c       | 25 ++++++-------
 drivers/md/dm-core.h               |  4 +-
 drivers/md/dm-crypt.c              | 60 ++++++++++++++----------------
 drivers/md/dm-integrity.c          | 15 ++++----
 drivers/md/dm-io.c                 | 29 ++++++++-------
 drivers/md/dm-kcopyd.c             | 22 ++++++-----
 drivers/md/dm-log-userspace-base.c | 19 +++++-----
 drivers/md/dm-region-hash.c        | 23 ++++++------
 drivers/md/dm-rq.c                 |  2 +-
 drivers/md/dm-snap.c               | 17 ++++-----
 drivers/md/dm-thin.c               | 32 ++++++++--------
 drivers/md/dm-verity-fec.c         | 55 +++++++++++++--------------
 drivers/md/dm-verity-fec.h         |  8 ++--
 drivers/md/dm-zoned-target.c       | 13 +++----
 drivers/md/dm.c                    | 53 ++++++++++++--------------
 17 files changed, 197 insertions(+), 206 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 874841f0fc..8e33a38083 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -19,7 +19,7 @@
 
 struct dm_bio_prison {
 	spinlock_t lock;
-	mempool_t *cell_pool;
+	mempool_t cell_pool;
 	struct rb_root cells;
 };
 
@@ -34,14 +34,15 @@ static struct kmem_cache *_cell_cache;
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
 	struct dm_bio_prison *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	int ret;
 
 	if (!prison)
 		return NULL;
 
 	spin_lock_init(&prison->lock);
 
-	prison->cell_pool = mempool_create_slab_pool(MIN_CELLS, _cell_cache);
-	if (!prison->cell_pool) {
+	ret = mempool_init_slab_pool(&prison->cell_pool, MIN_CELLS, _cell_cache);
+	if (ret) {
 		kfree(prison);
 		return NULL;
 	}
@@ -54,21 +55,21 @@ EXPORT_SYMBOL_GPL(dm_bio_prison_create);
 
 void dm_bio_prison_destroy(struct dm_bio_prison *prison)
 {
-	mempool_destroy(prison->cell_pool);
+	mempool_exit(&prison->cell_pool);
 	kfree(prison);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_destroy);
 
 struct dm_bio_prison_cell *dm_bio_prison_alloc_cell(struct dm_bio_prison *prison, gfp_t gfp)
 {
-	return mempool_alloc(prison->cell_pool, gfp);
+	return mempool_alloc(&prison->cell_pool, gfp);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_alloc_cell);
 
 void dm_bio_prison_free_cell(struct dm_bio_prison *prison,
 			     struct dm_bio_prison_cell *cell)
 {
-	mempool_free(cell, prison->cell_pool);
+	mempool_free(cell, &prison->cell_pool);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_free_cell);
 
diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 8ce3a1a588..601b156920 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -21,7 +21,7 @@ struct dm_bio_prison_v2 {
 	struct workqueue_struct *wq;
 
 	spinlock_t lock;
-	mempool_t *cell_pool;
+	mempool_t cell_pool;
 	struct rb_root cells;
 };
 
@@ -36,6 +36,7 @@ static struct kmem_cache *_cell_cache;
 struct dm_bio_prison_v2 *dm_bio_prison_create_v2(struct workqueue_struct *wq)
 {
 	struct dm_bio_prison_v2 *prison = kmalloc(sizeof(*prison), GFP_KERNEL);
+	int ret;
 
 	if (!prison)
 		return NULL;
@@ -43,8 +44,8 @@ struct dm_bio_prison_v2 *dm_bio_prison_create_v2(struct workqueue_struct *wq)
 	prison->wq = wq;
 	spin_lock_init(&prison->lock);
 
-	prison->cell_pool = mempool_create_slab_pool(MIN_CELLS, _cell_cache);
-	if (!prison->cell_pool) {
+	ret = mempool_init_slab_pool(&prison->cell_pool, MIN_CELLS, _cell_cache);
+	if (ret) {
 		kfree(prison);
 		return NULL;
 	}
@@ -57,21 +58,21 @@ EXPORT_SYMBOL_GPL(dm_bio_prison_create_v2);
 
 void dm_bio_prison_destroy_v2(struct dm_bio_prison_v2 *prison)
 {
-	mempool_destroy(prison->cell_pool);
+	mempool_exit(&prison->cell_pool);
 	kfree(prison);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_destroy_v2);
 
 struct dm_bio_prison_cell_v2 *dm_bio_prison_alloc_cell_v2(struct dm_bio_prison_v2 *prison, gfp_t gfp)
 {
-	return mempool_alloc(prison->cell_pool, gfp);
+	return mempool_alloc(&prison->cell_pool, gfp);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_alloc_cell_v2);
 
 void dm_bio_prison_free_cell_v2(struct dm_bio_prison_v2 *prison,
 				struct dm_bio_prison_cell_v2 *cell)
 {
-	mempool_free(cell, prison->cell_pool);
+	mempool_free(cell, &prison->cell_pool);
 }
 EXPORT_SYMBOL_GPL(dm_bio_prison_free_cell_v2);
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index da208638fb..001c712482 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -447,9 +447,9 @@ struct cache {
 	struct work_struct migration_worker;
 	struct delayed_work waker;
 	struct dm_bio_prison_v2 *prison;
-	struct bio_set *bs;
+	struct bio_set bs;
 
-	mempool_t *migration_pool;
+	mempool_t migration_pool;
 
 	struct dm_cache_policy *policy;
 	unsigned policy_nr_args;
@@ -550,7 +550,7 @@ static struct dm_cache_migration *alloc_migration(struct cache *cache)
 {
 	struct dm_cache_migration *mg;
 
-	mg = mempool_alloc(cache->migration_pool, GFP_NOWAIT);
+	mg = mempool_alloc(&cache->migration_pool, GFP_NOWAIT);
 	if (!mg)
 		return NULL;
 
@@ -569,7 +569,7 @@ static void free_migration(struct dm_cache_migration *mg)
 	if (atomic_dec_and_test(&cache->nr_allocated_migrations))
 		wake_up(&cache->migration_wait);
 
-	mempool_free(mg, cache->migration_pool);
+	mempool_free(mg, &cache->migration_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -924,7 +924,7 @@ static void issue_op(struct bio *bio, void *context)
 static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
 				      dm_oblock_t oblock, dm_cblock_t cblock)
 {
-	struct bio *origin_bio = bio_clone_fast(bio, GFP_NOIO, cache->bs);
+	struct bio *origin_bio = bio_clone_fast(bio, GFP_NOIO, &cache->bs);
 
 	BUG_ON(!origin_bio);
 
@@ -2011,7 +2011,7 @@ static void destroy(struct cache *cache)
 {
 	unsigned i;
 
-	mempool_destroy(cache->migration_pool);
+	mempool_exit(&cache->migration_pool);
 
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
@@ -2047,8 +2047,7 @@ static void destroy(struct cache *cache)
 		kfree(cache->ctr_args[i]);
 	kfree(cache->ctr_args);
 
-	if (cache->bs)
-		bioset_free(cache->bs);
+	bioset_exit(&cache->bs);
 
 	kfree(cache);
 }
@@ -2498,8 +2497,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	cache->features = ca->features;
 	if (writethrough_mode(cache)) {
 		/* Create bioset for writethrough bios issued to origin */
-		cache->bs = bioset_create(BIO_POOL_SIZE, 0, 0);
-		if (!cache->bs)
+		r = bioset_init(&cache->bs, BIO_POOL_SIZE, 0, 0);
+		if (r)
 			goto bad;
 	}
 
@@ -2630,9 +2629,9 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		goto bad;
 	}
 
-	cache->migration_pool = mempool_create_slab_pool(MIGRATION_POOL_SIZE,
-							 migration_cache);
-	if (!cache->migration_pool) {
+	r = mempool_init_slab_pool(&cache->migration_pool, MIGRATION_POOL_SIZE,
+				   migration_cache);
+	if (r) {
 		*error = "Error creating cache's migration mempool";
 		goto bad;
 	}
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 3222e21cbb..f21c5d21bf 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -91,8 +91,8 @@ struct mapped_device {
 	/*
 	 * io objects are allocated from here.
 	 */
-	struct bio_set *io_bs;
-	struct bio_set *bs;
+	struct bio_set io_bs;
+	struct bio_set bs;
 
 	/*
 	 * freeze/thaw support require holding onto a super block
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 44ff473dab..eaf6b279ac 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -143,14 +143,14 @@ struct crypt_config {
 	 * pool for per bio private data, crypto requests,
 	 * encryption requeusts/buffer pages and integrity tags
 	 */
-	mempool_t *req_pool;
-	mempool_t *page_pool;
-	mempool_t *tag_pool;
+	mempool_t req_pool;
+	mempool_t page_pool;
+	mempool_t tag_pool;
 	unsigned tag_pool_max_sectors;
 
 	struct percpu_counter n_allocated_pages;
 
-	struct bio_set *bs;
+	struct bio_set bs;
 	struct mutex bio_alloc_lock;
 
 	struct workqueue_struct *io_queue;
@@ -1245,7 +1245,7 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
 	if (!ctx->r.req)
-		ctx->r.req = mempool_alloc(cc->req_pool, GFP_NOIO);
+		ctx->r.req = mempool_alloc(&cc->req_pool, GFP_NOIO);
 
 	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
 
@@ -1262,7 +1262,7 @@ static void crypt_alloc_req_aead(struct crypt_config *cc,
 				 struct convert_context *ctx)
 {
 	if (!ctx->r.req_aead)
-		ctx->r.req_aead = mempool_alloc(cc->req_pool, GFP_NOIO);
+		ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
 
 	aead_request_set_tfm(ctx->r.req_aead, cc->cipher_tfm.tfms_aead[0]);
 
@@ -1290,7 +1290,7 @@ static void crypt_free_req_skcipher(struct crypt_config *cc,
 	struct dm_crypt_io *io = dm_per_bio_data(base_bio, cc->per_bio_data_size);
 
 	if ((struct skcipher_request *)(io + 1) != req)
-		mempool_free(req, cc->req_pool);
+		mempool_free(req, &cc->req_pool);
 }
 
 static void crypt_free_req_aead(struct crypt_config *cc,
@@ -1299,7 +1299,7 @@ static void crypt_free_req_aead(struct crypt_config *cc,
 	struct dm_crypt_io *io = dm_per_bio_data(base_bio, cc->per_bio_data_size);
 
 	if ((struct aead_request *)(io + 1) != req)
-		mempool_free(req, cc->req_pool);
+		mempool_free(req, &cc->req_pool);
 }
 
 static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_bio)
@@ -1409,7 +1409,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
 		mutex_lock(&cc->bio_alloc_lock);
 
-	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
+	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, &cc->bs);
 	if (!clone)
 		goto out;
 
@@ -1418,7 +1418,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 	remaining_size = size;
 
 	for (i = 0; i < nr_iovecs; i++) {
-		page = mempool_alloc(cc->page_pool, gfp_mask);
+		page = mempool_alloc(&cc->page_pool, gfp_mask);
 		if (!page) {
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
@@ -1453,7 +1453,7 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 
 	bio_for_each_segment_all(bv, clone, i) {
 		BUG_ON(!bv->bv_page);
-		mempool_free(bv->bv_page, cc->page_pool);
+		mempool_free(bv->bv_page, &cc->page_pool);
 	}
 }
 
@@ -1492,7 +1492,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		crypt_free_req(cc, io->ctx.r.req, base_bio);
 
 	if (unlikely(io->integrity_metadata_from_pool))
-		mempool_free(io->integrity_metadata, io->cc->tag_pool);
+		mempool_free(io->integrity_metadata, &io->cc->tag_pool);
 	else
 		kfree(io->integrity_metadata);
 
@@ -1565,7 +1565,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	 * biovecs we don't need to worry about the block layer
 	 * modifying the biovec array; so leverage bio_clone_fast().
 	 */
-	clone = bio_clone_fast(io->base_bio, gfp, cc->bs);
+	clone = bio_clone_fast(io->base_bio, gfp, &cc->bs);
 	if (!clone)
 		return 1;
 
@@ -2219,17 +2219,16 @@ static void crypt_dtr(struct dm_target *ti)
 
 	crypt_free_tfms(cc);
 
-	if (cc->bs)
-		bioset_free(cc->bs);
+	bioset_exit(&cc->bs);
 
-	mempool_destroy(cc->page_pool);
-	mempool_destroy(cc->req_pool);
-	mempool_destroy(cc->tag_pool);
-
-	if (cc->page_pool)
+	if (mempool_initialized(&cc->page_pool))
 		WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0);
 	percpu_counter_destroy(&cc->n_allocated_pages);
 
+	mempool_exit(&cc->page_pool);
+	mempool_exit(&cc->req_pool);
+	mempool_exit(&cc->tag_pool);
+
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 
@@ -2743,8 +2742,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		iv_size_padding = align_mask;
 	}
 
-	ret = -ENOMEM;
-
 	/*  ...| IV + padding | original IV | original sec. number | bio tag offset | */
 	additional_req_size = sizeof(struct dm_crypt_request) +
 		iv_size_padding + cc->iv_size +
@@ -2752,8 +2749,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		sizeof(uint64_t) +
 		sizeof(unsigned int);
 
-	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start + additional_req_size);
-	if (!cc->req_pool) {
+	ret = mempool_init_kmalloc_pool(&cc->req_pool, MIN_IOS, cc->dmreq_start + additional_req_size);
+	if (ret) {
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad;
 	}
@@ -2762,14 +2759,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_size,
 		      ARCH_KMALLOC_MINALIGN);
 
-	cc->page_pool = mempool_create(BIO_MAX_PAGES, crypt_page_alloc, crypt_page_free, cc);
-	if (!cc->page_pool) {
+	ret = mempool_init(&cc->page_pool, BIO_MAX_PAGES, crypt_page_alloc, crypt_page_free, cc);
+	if (ret) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad;
 	}
 
-	cc->bs = bioset_create(MIN_IOS, 0, BIOSET_NEED_BVECS);
-	if (!cc->bs) {
+	ret = bioset_init(&cc->bs, MIN_IOS, 0, BIOSET_NEED_BVECS);
+	if (ret) {
 		ti->error = "Cannot allocate crypt bioset";
 		goto bad;
 	}
@@ -2806,11 +2803,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		if (!cc->tag_pool_max_sectors)
 			cc->tag_pool_max_sectors = 1;
 
-		cc->tag_pool = mempool_create_kmalloc_pool(MIN_IOS,
+		ret = mempool_init_kmalloc_pool(&cc->tag_pool, MIN_IOS,
 			cc->tag_pool_max_sectors * cc->on_disk_tag_size);
-		if (!cc->tag_pool) {
+		if (ret) {
 			ti->error = "Cannot allocate integrity tags mempool";
-			ret = -ENOMEM;
 			goto bad;
 		}
 
@@ -2903,7 +2899,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 				GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN)))) {
 			if (bio_sectors(bio) > cc->tag_pool_max_sectors)
 				dm_accept_partial_bio(bio, cc->tag_pool_max_sectors);
-			io->integrity_metadata = mempool_alloc(cc->tag_pool, GFP_NOIO);
+			io->integrity_metadata = mempool_alloc(&cc->tag_pool, GFP_NOIO);
 			io->integrity_metadata_from_pool = true;
 		}
 	}
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 77d9fe58da..20f5bc1c74 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -142,7 +142,7 @@ struct dm_integrity_c {
 	unsigned tag_size;
 	__s8 log2_tag_size;
 	sector_t start;
-	mempool_t *journal_io_mempool;
+	mempool_t journal_io_mempool;
 	struct dm_io_client *io;
 	struct dm_bufio_client *bufio;
 	struct workqueue_struct *metadata_wq;
@@ -1817,7 +1817,7 @@ static void complete_copy_from_journal(unsigned long error, void *context)
 	struct journal_completion *comp = io->comp;
 	struct dm_integrity_c *ic = comp->ic;
 	remove_range(ic, &io->range);
-	mempool_free(io, ic->journal_io_mempool);
+	mempool_free(io, &ic->journal_io_mempool);
 	if (unlikely(error != 0))
 		dm_integrity_io_error(ic, "copying from journal", -EIO);
 	complete_journal_op(comp);
@@ -1886,7 +1886,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 			}
 			next_loop = k - 1;
 
-			io = mempool_alloc(ic->journal_io_mempool, GFP_NOIO);
+			io = mempool_alloc(&ic->journal_io_mempool, GFP_NOIO);
 			io->comp = &comp;
 			io->range.logical_sector = sec;
 			io->range.n_sectors = (k - j) << ic->sb->log2_sectors_per_block;
@@ -1918,7 +1918,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				if (j == k) {
 					remove_range_unlocked(ic, &io->range);
 					spin_unlock_irq(&ic->endio_wait.lock);
-					mempool_free(io, ic->journal_io_mempool);
+					mempool_free(io, &ic->journal_io_mempool);
 					goto skip_io;
 				}
 				for (l = j; l < k; l++) {
@@ -2980,9 +2980,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	ic->journal_io_mempool = mempool_create_slab_pool(JOURNAL_IO_MEMPOOL, journal_io_cache);
-	if (!ic->journal_io_mempool) {
-		r = -ENOMEM;
+	r = mempool_init_slab_pool(&ic->journal_io_mempool, JOURNAL_IO_MEMPOOL, journal_io_cache);
+	if (r) {
 		ti->error = "Cannot allocate mempool";
 		goto bad;
 	}
@@ -3196,7 +3195,7 @@ static void dm_integrity_dtr(struct dm_target *ti)
 		destroy_workqueue(ic->writer_wq);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
-	mempool_destroy(ic->journal_io_mempool);
+	mempool_exit(&ic->journal_io_mempool);
 	if (ic->io)
 		dm_io_client_destroy(ic->io);
 	if (ic->dev)
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index a8d914d5ab..53c6ed0eaa 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -22,8 +22,8 @@
 #define DM_IO_MAX_REGIONS	BITS_PER_LONG
 
 struct dm_io_client {
-	mempool_t *pool;
-	struct bio_set *bios;
+	mempool_t pool;
+	struct bio_set bios;
 };
 
 /*
@@ -49,32 +49,33 @@ struct dm_io_client *dm_io_client_create(void)
 {
 	struct dm_io_client *client;
 	unsigned min_ios = dm_get_reserved_bio_based_ios();
+	int ret;
 
 	client = kmalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
 
-	client->pool = mempool_create_slab_pool(min_ios, _dm_io_cache);
-	if (!client->pool)
+	ret = mempool_init_slab_pool(&client->pool, min_ios, _dm_io_cache);
+	if (ret)
 		goto bad;
 
-	client->bios = bioset_create(min_ios, 0, BIOSET_NEED_BVECS);
-	if (!client->bios)
+	ret = bioset_init(&client->bios, min_ios, 0, BIOSET_NEED_BVECS);
+	if (ret)
 		goto bad;
 
 	return client;
 
    bad:
-	mempool_destroy(client->pool);
+	mempool_exit(&client->pool);
 	kfree(client);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(dm_io_client_create);
 
 void dm_io_client_destroy(struct dm_io_client *client)
 {
-	mempool_destroy(client->pool);
-	bioset_free(client->bios);
+	mempool_exit(&client->pool);
+	bioset_exit(&client->bios);
 	kfree(client);
 }
 EXPORT_SYMBOL(dm_io_client_destroy);
@@ -120,7 +121,7 @@ static void complete_io(struct io *io)
 		invalidate_kernel_vmap_range(io->vma_invalidate_address,
 					     io->vma_invalidate_size);
 
-	mempool_free(io, io->client->pool);
+	mempool_free(io, &io->client->pool);
 	fn(error_bits, context);
 }
 
@@ -344,7 +345,7 @@ static void do_region(int op, int op_flags, unsigned region,
 					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
 		}
 
-		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
+		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, &io->client->bios);
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
 		bio_set_dev(bio, where->bdev);
 		bio->bi_end_io = endio;
@@ -442,7 +443,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	init_completion(&sio.wait);
 
-	io = mempool_alloc(client->pool, GFP_NOIO);
+	io = mempool_alloc(&client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->client = client;
@@ -474,7 +475,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 		return -EIO;
 	}
 
-	io = mempool_alloc(client->pool, GFP_NOIO);
+	io = mempool_alloc(&client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->client = client;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index e6e7c68664..c89a675a2a 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -47,7 +47,7 @@ struct dm_kcopyd_client {
 	wait_queue_head_t destroyq;
 	atomic_t nr_jobs;
 
-	mempool_t *job_pool;
+	mempool_t job_pool;
 
 	struct workqueue_struct *kcopyd_wq;
 	struct work_struct kcopyd_work;
@@ -479,7 +479,7 @@ static int run_complete_job(struct kcopyd_job *job)
 	 */
 	if (job->master_job == job) {
 		mutex_destroy(&job->lock);
-		mempool_free(job, kc->job_pool);
+		mempool_free(job, &kc->job_pool);
 	}
 	fn(read_err, write_err, context);
 
@@ -751,7 +751,7 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	 * Allocate an array of jobs consisting of one master job
 	 * followed by SPLIT_COUNT sub jobs.
 	 */
-	job = mempool_alloc(kc->job_pool, GFP_NOIO);
+	job = mempool_alloc(&kc->job_pool, GFP_NOIO);
 	mutex_init(&job->lock);
 
 	/*
@@ -835,7 +835,7 @@ void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 {
 	struct kcopyd_job *job;
 
-	job = mempool_alloc(kc->job_pool, GFP_NOIO);
+	job = mempool_alloc(&kc->job_pool, GFP_NOIO);
 
 	memset(job, 0, sizeof(struct kcopyd_job));
 	job->kc = kc;
@@ -879,7 +879,7 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
  *---------------------------------------------------------------*/
 struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
-	int r = -ENOMEM;
+	int r;
 	struct dm_kcopyd_client *kc;
 
 	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
@@ -892,14 +892,16 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 	INIT_LIST_HEAD(&kc->pages_jobs);
 	kc->throttle = throttle;
 
-	kc->job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
-	if (!kc->job_pool)
+	r = mempool_init_slab_pool(&kc->job_pool, MIN_JOBS, _job_cache);
+	if (r)
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
 	kc->kcopyd_wq = alloc_workqueue("kcopyd", WQ_MEM_RECLAIM, 0);
-	if (!kc->kcopyd_wq)
+	if (!kc->kcopyd_wq) {
+		r = -ENOMEM;
 		goto bad_workqueue;
+	}
 
 	kc->pages = NULL;
 	kc->nr_reserved_pages = kc->nr_free_pages = 0;
@@ -923,7 +925,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 bad_client_pages:
 	destroy_workqueue(kc->kcopyd_wq);
 bad_workqueue:
-	mempool_destroy(kc->job_pool);
+	mempool_exit(&kc->job_pool);
 bad_slab:
 	kfree(kc);
 
@@ -942,7 +944,7 @@ void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 	destroy_workqueue(kc->kcopyd_wq);
 	dm_io_client_destroy(kc->io_client);
 	client_free_pages(kc);
-	mempool_destroy(kc->job_pool);
+	mempool_exit(&kc->job_pool);
 	kfree(kc);
 }
 EXPORT_SYMBOL(dm_kcopyd_client_destroy);
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 53b7b06d0a..52090bee17 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -76,7 +76,7 @@ struct log_c {
 	 */
 	uint32_t integrated_flush;
 
-	mempool_t *flush_entry_pool;
+	mempool_t flush_entry_pool;
 };
 
 static struct kmem_cache *_flush_entry_cache;
@@ -249,11 +249,10 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		goto out;
 	}
 
-	lc->flush_entry_pool = mempool_create_slab_pool(FLUSH_ENTRY_POOL_SIZE,
-							_flush_entry_cache);
-	if (!lc->flush_entry_pool) {
+	r = mempool_init_slab_pool(&lc->flush_entry_pool, FLUSH_ENTRY_POOL_SIZE,
+				   _flush_entry_cache);
+	if (r) {
 		DMERR("Failed to create flush_entry_pool");
-		r = -ENOMEM;
 		goto out;
 	}
 
@@ -313,7 +312,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 out:
 	kfree(devices_rdata);
 	if (r) {
-		mempool_destroy(lc->flush_entry_pool);
+		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);
 	} else {
@@ -342,7 +341,7 @@ static void userspace_dtr(struct dm_dirty_log *log)
 	if (lc->log_dev)
 		dm_put_device(lc->ti, lc->log_dev);
 
-	mempool_destroy(lc->flush_entry_pool);
+	mempool_exit(&lc->flush_entry_pool);
 
 	kfree(lc->usr_argv_str);
 	kfree(lc);
@@ -570,7 +569,7 @@ static int userspace_flush(struct dm_dirty_log *log)
 	int mark_list_is_empty;
 	int clear_list_is_empty;
 	struct dm_dirty_log_flush_entry *fe, *tmp_fe;
-	mempool_t *flush_entry_pool = lc->flush_entry_pool;
+	mempool_t *flush_entry_pool = &lc->flush_entry_pool;
 
 	spin_lock_irqsave(&lc->flush_lock, flags);
 	list_splice_init(&lc->mark_list, &mark_list);
@@ -653,7 +652,7 @@ static void userspace_mark_region(struct dm_dirty_log *log, region_t region)
 	struct dm_dirty_log_flush_entry *fe;
 
 	/* Wait for an allocation, but _never_ fail */
-	fe = mempool_alloc(lc->flush_entry_pool, GFP_NOIO);
+	fe = mempool_alloc(&lc->flush_entry_pool, GFP_NOIO);
 	BUG_ON(!fe);
 
 	spin_lock_irqsave(&lc->flush_lock, flags);
@@ -687,7 +686,7 @@ static void userspace_clear_region(struct dm_dirty_log *log, region_t region)
 	 * to cause the region to be resync'ed when the
 	 * device is activated next time.
 	 */
-	fe = mempool_alloc(lc->flush_entry_pool, GFP_ATOMIC);
+	fe = mempool_alloc(&lc->flush_entry_pool, GFP_ATOMIC);
 	if (!fe) {
 		DMERR("Failed to allocate memory to clear region.");
 		return;
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 85c32b22a4..43149eb493 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -63,7 +63,7 @@ struct dm_region_hash {
 
 	/* hash table */
 	rwlock_t hash_lock;
-	mempool_t *region_pool;
+	mempool_t region_pool;
 	unsigned mask;
 	unsigned nr_buckets;
 	unsigned prime;
@@ -169,6 +169,7 @@ struct dm_region_hash *dm_region_hash_create(
 	struct dm_region_hash *rh;
 	unsigned nr_buckets, max_buckets;
 	size_t i;
+	int ret;
 
 	/*
 	 * Calculate a suitable number of buckets for our hash
@@ -220,9 +221,9 @@ struct dm_region_hash *dm_region_hash_create(
 	INIT_LIST_HEAD(&rh->failed_recovered_regions);
 	rh->flush_failure = 0;
 
-	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
-						      sizeof(struct dm_region));
-	if (!rh->region_pool) {
+	ret = mempool_init_kmalloc_pool(&rh->region_pool, MIN_REGIONS,
+					sizeof(struct dm_region));
+	if (ret) {
 		vfree(rh->buckets);
 		kfree(rh);
 		rh = ERR_PTR(-ENOMEM);
@@ -242,14 +243,14 @@ void dm_region_hash_destroy(struct dm_region_hash *rh)
 		list_for_each_entry_safe(reg, nreg, rh->buckets + h,
 					 hash_list) {
 			BUG_ON(atomic_read(&reg->pending));
-			mempool_free(reg, rh->region_pool);
+			mempool_free(reg, &rh->region_pool);
 		}
 	}
 
 	if (rh->log)
 		dm_dirty_log_destroy(rh->log);
 
-	mempool_destroy(rh->region_pool);
+	mempool_exit(&rh->region_pool);
 	vfree(rh->buckets);
 	kfree(rh);
 }
@@ -287,7 +288,7 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 {
 	struct dm_region *reg, *nreg;
 
-	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
+	nreg = mempool_alloc(&rh->region_pool, GFP_ATOMIC);
 	if (unlikely(!nreg))
 		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
 
@@ -303,7 +304,7 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 	reg = __rh_lookup(rh, region);
 	if (reg)
 		/* We lost the race. */
-		mempool_free(nreg, rh->region_pool);
+		mempool_free(nreg, &rh->region_pool);
 	else {
 		__rh_insert(rh, nreg);
 		if (nreg->state == DM_RH_CLEAN) {
@@ -481,17 +482,17 @@ void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled)
 	list_for_each_entry_safe(reg, next, &recovered, list) {
 		rh->log->type->clear_region(rh->log, reg->key);
 		complete_resync_work(reg, 1);
-		mempool_free(reg, rh->region_pool);
+		mempool_free(reg, &rh->region_pool);
 	}
 
 	list_for_each_entry_safe(reg, next, &failed_recovered, list) {
 		complete_resync_work(reg, errors_handled ? 0 : 1);
-		mempool_free(reg, rh->region_pool);
+		mempool_free(reg, &rh->region_pool);
 	}
 
 	list_for_each_entry_safe(reg, next, &clean, list) {
 		rh->log->type->clear_region(rh->log, reg->key);
-		mempool_free(reg, rh->region_pool);
+		mempool_free(reg, &rh->region_pool);
 	}
 
 	rh->log->type->flush(rh->log);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1c18f335da..6e547b8dd2 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -433,7 +433,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
-	r = blk_rq_prep_clone(clone, rq, tio->md->bs, gfp_mask,
+	r = blk_rq_prep_clone(clone, rq, &tio->md->bs, gfp_mask,
 			      dm_rq_bio_constructor, tio);
 	if (r)
 		return r;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 216035be56..b11ddc55f2 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -87,7 +87,7 @@ struct dm_snapshot {
 	 */
 	struct list_head out_of_order_list;
 
-	mempool_t *pending_pool;
+	mempool_t pending_pool;
 
 	struct dm_exception_table pending;
 	struct dm_exception_table complete;
@@ -682,7 +682,7 @@ static void free_completed_exception(struct dm_exception *e)
 
 static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snapshot *s)
 {
-	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
+	struct dm_snap_pending_exception *pe = mempool_alloc(&s->pending_pool,
 							     GFP_NOIO);
 
 	atomic_inc(&s->pending_exceptions_count);
@@ -695,7 +695,7 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snapshot *s = pe->snap;
 
-	mempool_free(pe, s->pending_pool);
+	mempool_free(pe, &s->pending_pool);
 	smp_mb__before_atomic();
 	atomic_dec(&s->pending_exceptions_count);
 }
@@ -1196,10 +1196,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_kcopyd;
 	}
 
-	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
-	if (!s->pending_pool) {
+	r = mempool_init_slab_pool(&s->pending_pool, MIN_IOS, pending_cache);
+	if (r) {
 		ti->error = "Could not allocate mempool for pending exceptions";
-		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 
@@ -1259,7 +1258,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	unregister_snapshot(s);
 
 bad_load_and_register:
-	mempool_destroy(s->pending_pool);
+	mempool_exit(&s->pending_pool);
 
 bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
@@ -1355,7 +1354,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	while (atomic_read(&s->pending_exceptions_count))
 		msleep(1);
 	/*
-	 * Ensure instructions in mempool_destroy aren't reordered
+	 * Ensure instructions in mempool_exit aren't reordered
 	 * before atomic_read.
 	 */
 	smp_mb();
@@ -1367,7 +1366,7 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	__free_exceptions(s);
 
-	mempool_destroy(s->pending_pool);
+	mempool_exit(&s->pending_pool);
 
 	dm_exception_store_destroy(s->store);
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b11107497d..6c923824ec 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -260,7 +260,7 @@ struct pool {
 	struct dm_deferred_set *all_io_ds;
 
 	struct dm_thin_new_mapping *next_mapping;
-	mempool_t *mapping_pool;
+	mempool_t mapping_pool;
 
 	process_bio_fn process_bio;
 	process_bio_fn process_discard;
@@ -917,7 +917,7 @@ static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
-	mempool_free(m, m->tc->pool->mapping_pool);
+	mempool_free(m, &m->tc->pool->mapping_pool);
 }
 
 static void process_prepared_mapping(struct dm_thin_new_mapping *m)
@@ -961,7 +961,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 
 out:
 	list_del(&m->list);
-	mempool_free(m, pool->mapping_pool);
+	mempool_free(m, &pool->mapping_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -971,7 +971,7 @@ static void free_discard_mapping(struct dm_thin_new_mapping *m)
 	struct thin_c *tc = m->tc;
 	if (m->cell)
 		cell_defer_no_holder(tc, m->cell);
-	mempool_free(m, tc->pool->mapping_pool);
+	mempool_free(m, &tc->pool->mapping_pool);
 }
 
 static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
@@ -999,7 +999,7 @@ static void process_prepared_discard_no_passdown(struct dm_thin_new_mapping *m)
 		bio_endio(m->bio);
 
 	cell_defer_no_holder(tc, m->cell);
-	mempool_free(m, tc->pool->mapping_pool);
+	mempool_free(m, &tc->pool->mapping_pool);
 }
 
 /*----------------------------------------------------------------*/
@@ -1092,7 +1092,7 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		metadata_operation_failed(pool, "dm_thin_remove_range", r);
 		bio_io_error(m->bio);
 		cell_defer_no_holder(tc, m->cell);
-		mempool_free(m, pool->mapping_pool);
+		mempool_free(m, &pool->mapping_pool);
 		return;
 	}
 
@@ -1105,7 +1105,7 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		metadata_operation_failed(pool, "dm_pool_inc_data_range", r);
 		bio_io_error(m->bio);
 		cell_defer_no_holder(tc, m->cell);
-		mempool_free(m, pool->mapping_pool);
+		mempool_free(m, &pool->mapping_pool);
 		return;
 	}
 
@@ -1150,7 +1150,7 @@ static void process_prepared_discard_passdown_pt2(struct dm_thin_new_mapping *m)
 		bio_endio(m->bio);
 
 	cell_defer_no_holder(tc, m->cell);
-	mempool_free(m, pool->mapping_pool);
+	mempool_free(m, &pool->mapping_pool);
 }
 
 static void process_prepared(struct pool *pool, struct list_head *head,
@@ -1196,7 +1196,7 @@ static int ensure_next_mapping(struct pool *pool)
 	if (pool->next_mapping)
 		return 0;
 
-	pool->next_mapping = mempool_alloc(pool->mapping_pool, GFP_ATOMIC);
+	pool->next_mapping = mempool_alloc(&pool->mapping_pool, GFP_ATOMIC);
 
 	return pool->next_mapping ? 0 : -ENOMEM;
 }
@@ -2835,8 +2835,8 @@ static void __pool_destroy(struct pool *pool)
 		destroy_workqueue(pool->wq);
 
 	if (pool->next_mapping)
-		mempool_free(pool->next_mapping, pool->mapping_pool);
-	mempool_destroy(pool->mapping_pool);
+		mempool_free(pool->next_mapping, &pool->mapping_pool);
+	mempool_exit(&pool->mapping_pool);
 	dm_deferred_set_destroy(pool->shared_read_ds);
 	dm_deferred_set_destroy(pool->all_io_ds);
 	kfree(pool);
@@ -2931,11 +2931,11 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	}
 
 	pool->next_mapping = NULL;
-	pool->mapping_pool = mempool_create_slab_pool(MAPPING_POOL_SIZE,
-						      _new_mapping_cache);
-	if (!pool->mapping_pool) {
+	r = mempool_init_slab_pool(&pool->mapping_pool, MAPPING_POOL_SIZE,
+				   _new_mapping_cache);
+	if (r) {
 		*error = "Error creating pool's mapping mempool";
-		err_p = ERR_PTR(-ENOMEM);
+		err_p = ERR_PTR(r);
 		goto bad_mapping_pool;
 	}
 
@@ -2955,7 +2955,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	return pool;
 
 bad_sort_array:
-	mempool_destroy(pool->mapping_pool);
+	mempool_exit(&pool->mapping_pool);
 bad_mapping_pool:
 	dm_deferred_set_destroy(pool->all_io_ds);
 bad_all_io_ds:
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index e13f90832b..86405869f1 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -309,13 +309,13 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 	unsigned n;
 
 	if (!fio->rs)
-		fio->rs = mempool_alloc(v->fec->rs_pool, GFP_NOIO);
+		fio->rs = mempool_alloc(&v->fec->rs_pool, GFP_NOIO);
 
 	fec_for_each_prealloc_buffer(n) {
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(v->fec->prealloc_pool, GFP_NOWAIT);
+		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOWAIT);
 		if (unlikely(!fio->bufs[n])) {
 			DMERR("failed to allocate FEC buffer");
 			return -ENOMEM;
@@ -327,7 +327,7 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(v->fec->extra_pool, GFP_NOWAIT);
+		fio->bufs[n] = mempool_alloc(&v->fec->extra_pool, GFP_NOWAIT);
 		/* we can manage with even one buffer if necessary */
 		if (unlikely(!fio->bufs[n]))
 			break;
@@ -335,7 +335,7 @@ static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 	fio->nbufs = n;
 
 	if (!fio->output)
-		fio->output = mempool_alloc(v->fec->output_pool, GFP_NOIO);
+		fio->output = mempool_alloc(&v->fec->output_pool, GFP_NOIO);
 
 	return 0;
 }
@@ -493,15 +493,15 @@ void verity_fec_finish_io(struct dm_verity_io *io)
 	if (!verity_fec_is_enabled(io->v))
 		return;
 
-	mempool_free(fio->rs, f->rs_pool);
+	mempool_free(fio->rs, &f->rs_pool);
 
 	fec_for_each_prealloc_buffer(n)
-		mempool_free(fio->bufs[n], f->prealloc_pool);
+		mempool_free(fio->bufs[n], &f->prealloc_pool);
 
 	fec_for_each_extra_buffer(fio, n)
-		mempool_free(fio->bufs[n], f->extra_pool);
+		mempool_free(fio->bufs[n], &f->extra_pool);
 
-	mempool_free(fio->output, f->output_pool);
+	mempool_free(fio->output, &f->output_pool);
 }
 
 /*
@@ -549,9 +549,9 @@ void verity_fec_dtr(struct dm_verity *v)
 	if (!verity_fec_is_enabled(v))
 		goto out;
 
-	mempool_destroy(f->rs_pool);
-	mempool_destroy(f->prealloc_pool);
-	mempool_destroy(f->extra_pool);
+	mempool_exit(&f->rs_pool);
+	mempool_exit(&f->prealloc_pool);
+	mempool_exit(&f->extra_pool);
 	kmem_cache_destroy(f->cache);
 
 	if (f->data_bufio)
@@ -675,6 +675,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
 	u64 hash_blocks;
+	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
 		verity_fec_dtr(v);
@@ -770,11 +771,11 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	/* Preallocate an rs_control structure for each worker thread */
-	f->rs_pool = mempool_create(num_online_cpus(), fec_rs_alloc,
-				    fec_rs_free, (void *) v);
-	if (!f->rs_pool) {
+	ret = mempool_init(&f->rs_pool, num_online_cpus(), fec_rs_alloc,
+			   fec_rs_free, (void *) v);
+	if (ret) {
 		ti->error = "Cannot allocate RS pool";
-		return -ENOMEM;
+		return ret;
 	}
 
 	f->cache = kmem_cache_create("dm_verity_fec_buffers",
@@ -786,26 +787,26 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	/* Preallocate DM_VERITY_FEC_BUF_PREALLOC buffers for each thread */
-	f->prealloc_pool = mempool_create_slab_pool(num_online_cpus() *
-						    DM_VERITY_FEC_BUF_PREALLOC,
-						    f->cache);
-	if (!f->prealloc_pool) {
+	ret = mempool_init_slab_pool(&f->prealloc_pool, num_online_cpus() *
+				     DM_VERITY_FEC_BUF_PREALLOC,
+				     f->cache);
+	if (ret) {
 		ti->error = "Cannot allocate FEC buffer prealloc pool";
-		return -ENOMEM;
+		return ret;
 	}
 
-	f->extra_pool = mempool_create_slab_pool(0, f->cache);
-	if (!f->extra_pool) {
+	ret = mempool_init_slab_pool(&f->extra_pool, 0, f->cache);
+	if (ret) {
 		ti->error = "Cannot allocate FEC buffer extra pool";
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* Preallocate an output buffer for each thread */
-	f->output_pool = mempool_create_kmalloc_pool(num_online_cpus(),
-						     1 << v->data_dev_block_bits);
-	if (!f->output_pool) {
+	ret = mempool_init_kmalloc_pool(&f->output_pool, num_online_cpus(),
+					1 << v->data_dev_block_bits);
+	if (ret) {
 		ti->error = "Cannot allocate FEC output pool";
-		return -ENOMEM;
+		return ret;
 	}
 
 	/* Reserve space for our per-bio data */
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index bb31ce87a9..6ad803b2b3 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -46,10 +46,10 @@ struct dm_verity_fec {
 	sector_t hash_blocks;	/* blocks covered after v->hash_start */
 	unsigned char roots;	/* number of parity bytes, M-N of RS(M, N) */
 	unsigned char rsn;	/* N of RS(M, N) */
-	mempool_t *rs_pool;	/* mempool for fio->rs */
-	mempool_t *prealloc_pool;	/* mempool for preallocated buffers */
-	mempool_t *extra_pool;	/* mempool for extra buffers */
-	mempool_t *output_pool;	/* mempool for output */
+	mempool_t rs_pool;	/* mempool for fio->rs */
+	mempool_t prealloc_pool;	/* mempool for preallocated buffers */
+	mempool_t extra_pool;	/* mempool for extra buffers */
+	mempool_t output_pool;	/* mempool for output */
 	struct kmem_cache *cache;	/* cache for buffers */
 };
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index e73b077668..30602d15ad 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -57,7 +57,7 @@ struct dmz_target {
 	struct workqueue_struct *chunk_wq;
 
 	/* For cloned BIOs to zones */
-	struct bio_set		*bio_set;
+	struct bio_set		bio_set;
 
 	/* For flush */
 	spinlock_t		flush_lock;
@@ -121,7 +121,7 @@ static int dmz_submit_read_bio(struct dmz_target *dmz, struct dm_zone *zone,
 	}
 
 	/* Partial BIO: we need to clone the BIO */
-	clone = bio_clone_fast(bio, GFP_NOIO, dmz->bio_set);
+	clone = bio_clone_fast(bio, GFP_NOIO, &dmz->bio_set);
 	if (!clone)
 		return -ENOMEM;
 
@@ -779,10 +779,9 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->len = (sector_t)dmz_nr_chunks(dmz->metadata) << dev->zone_nr_sectors_shift;
 
 	/* Zone BIO */
-	dmz->bio_set = bioset_create(DMZ_MIN_BIOS, 0, 0);
-	if (!dmz->bio_set) {
+	ret = bioset_init(&dmz->bio_set, DMZ_MIN_BIOS, 0, 0);
+	if (ret) {
 		ti->error = "Create BIO set failed";
-		ret = -ENOMEM;
 		goto err_meta;
 	}
 
@@ -828,7 +827,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	destroy_workqueue(dmz->chunk_wq);
 err_bio:
 	mutex_destroy(&dmz->chunk_lock);
-	bioset_free(dmz->bio_set);
+	bioset_exit(&dmz->bio_set);
 err_meta:
 	dmz_dtr_metadata(dmz->metadata);
 err_dev:
@@ -858,7 +857,7 @@ static void dmz_dtr(struct dm_target *ti)
 
 	dmz_dtr_metadata(dmz->metadata);
 
-	bioset_free(dmz->bio_set);
+	bioset_exit(&dmz->bio_set);
 
 	dmz_put_zoned_device(ti);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7d98ee1137..7dc0c5ef7c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -148,8 +148,8 @@ static int dm_numa_node = DM_NUMA_NODE;
  * For mempools pre-allocation at the table loading time.
  */
 struct dm_md_mempools {
-	struct bio_set *bs;
-	struct bio_set *io_bs;
+	struct bio_set bs;
+	struct bio_set io_bs;
 };
 
 struct table_device {
@@ -537,7 +537,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, 0, md->io_bs);
+	clone = bio_alloc_bioset(GFP_NOIO, 0, &md->io_bs);
 	if (!clone)
 		return NULL;
 
@@ -572,7 +572,7 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
 		/* the dm_target_io embedded in ci->io is available */
 		tio = &ci->io->tio;
 	} else {
-		struct bio *clone = bio_alloc_bioset(gfp_mask, 0, ci->io->md->bs);
+		struct bio *clone = bio_alloc_bioset(gfp_mask, 0, &ci->io->md->bs);
 		if (!clone)
 			return NULL;
 
@@ -1784,10 +1784,8 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		destroy_workqueue(md->wq);
 	if (md->kworker_task)
 		kthread_stop(md->kworker_task);
-	if (md->bs)
-		bioset_free(md->bs);
-	if (md->io_bs)
-		bioset_free(md->io_bs);
+	bioset_exit(&md->bs);
+	bioset_exit(&md->io_bs);
 
 	if (md->dax_dev) {
 		kill_dax(md->dax_dev);
@@ -1964,16 +1962,10 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		 * If so, reload bioset because front_pad may have changed
 		 * because a different table was loaded.
 		 */
-		if (md->bs) {
-			bioset_free(md->bs);
-			md->bs = NULL;
-		}
-		if (md->io_bs) {
-			bioset_free(md->io_bs);
-			md->io_bs = NULL;
-		}
+		bioset_exit(&md->bs);
+		bioset_exit(&md->io_bs);
 
-	} else if (md->bs) {
+	} else if (bioset_initialized(&md->bs)) {
 		/*
 		 * There's no need to reload with request-based dm
 		 * because the size of front_pad doesn't change.
@@ -1985,12 +1977,14 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		goto out;
 	}
 
-	BUG_ON(!p || md->bs || md->io_bs);
+	BUG_ON(!p ||
+	       bioset_initialized(&md->bs) ||
+	       bioset_initialized(&md->io_bs));
 
 	md->bs = p->bs;
-	p->bs = NULL;
+	memset(&p->bs, 0, sizeof(p->bs));
 	md->io_bs = p->io_bs;
-	p->io_bs = NULL;
+	memset(&p->io_bs, 0, sizeof(p->io_bs));
 out:
 	/* mempool bind completed, no longer need any mempools in the table */
 	dm_table_free_md_mempools(t);
@@ -2904,6 +2898,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
 	unsigned int front_pad, io_front_pad;
+	int ret;
 
 	if (!pools)
 		return NULL;
@@ -2915,10 +2910,10 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
-		pools->io_bs = bioset_create(pool_size, io_front_pad, 0);
-		if (!pools->io_bs)
+		ret = bioset_init(&pools->io_bs, pool_size, io_front_pad, 0);
+		if (ret)
 			goto out;
-		if (integrity && bioset_integrity_create(pools->io_bs, pool_size))
+		if (integrity && bioset_integrity_create(&pools->io_bs, pool_size))
 			goto out;
 		break;
 	case DM_TYPE_REQUEST_BASED:
@@ -2931,11 +2926,11 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 		BUG();
 	}
 
-	pools->bs = bioset_create(pool_size, front_pad, 0);
-	if (!pools->bs)
+	ret = bioset_init(&pools->bs, pool_size, front_pad, 0);
+	if (ret)
 		goto out;
 
-	if (integrity && bioset_integrity_create(pools->bs, pool_size))
+	if (integrity && bioset_integrity_create(&pools->bs, pool_size))
 		goto out;
 
 	return pools;
@@ -2951,10 +2946,8 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	if (!pools)
 		return;
 
-	if (pools->bs)
-		bioset_free(pools->bs);
-	if (pools->io_bs)
-		bioset_free(pools->io_bs);
+	bioset_exit(&pools->bs);
+	bioset_exit(&pools->io_bs);
 
 	kfree(pools);
 }
-- 
2.17.0

