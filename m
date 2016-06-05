Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93C207D15
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 577FC8F8037
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SANhGvWY5AIR6v8O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:30 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 25/45] bcache: use bio op accessors
Date: Sun,  5 Jun 2016 14:32:05 -0500
Message-Id: <1465155145-10812-26-git-send-email-mchristi@redhat.com>
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

Separate the op from the rq_flag_bits and have bcache
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/bcache/btree.c     |  4 ++--
 drivers/md/bcache/debug.c     |  4 ++--
 drivers/md/bcache/journal.c   |  7 ++++---
 drivers/md/bcache/movinggc.c  |  2 +-
 drivers/md/bcache/request.c   | 14 +++++++-------
 drivers/md/bcache/super.c     | 24 +++++++++++++-----------
 drivers/md/bcache/writeback.c |  4 ++--
 7 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index eab505e..76f7534 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -294,10 +294,10 @@ static void bch_btree_node_read(struct btree *b)
 	closure_init_stack(&cl);
 
 	bio = bch_bbio_alloc(b->c);
-	bio->bi_rw	= REQ_META|READ_SYNC;
 	bio->bi_iter.bi_size = KEY_SIZE(&b->key) << 9;
 	bio->bi_end_io	= btree_node_read_endio;
 	bio->bi_private	= &cl;
+	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META|READ_SYNC);
 
 	bch_bio_map(bio, b->keys.set[0].data);
 
@@ -396,8 +396,8 @@ static void do_btree_node_write(struct btree *b)
 
 	b->bio->bi_end_io	= btree_node_write_endio;
 	b->bio->bi_private	= cl;
-	b->bio->bi_rw		= REQ_META|WRITE_SYNC|REQ_FUA;
 	b->bio->bi_iter.bi_size	= roundup(set_bytes(i), block_bytes(b->c));
+	bio_set_op_attrs(b->bio, REQ_OP_WRITE, REQ_META|WRITE_SYNC|REQ_FUA);
 	bch_bio_map(b->bio, i);
 
 	/*
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 52b6bcf..c28df164 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -52,7 +52,7 @@ void bch_btree_verify(struct btree *b)
 	bio->bi_bdev		= PTR_CACHE(b->c, &b->key, 0)->bdev;
 	bio->bi_iter.bi_sector	= PTR_OFFSET(&b->key, 0);
 	bio->bi_iter.bi_size	= KEY_SIZE(&v->key) << 9;
-	bio->bi_rw		= REQ_META|READ_SYNC;
+	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META|READ_SYNC);
 	bch_bio_map(bio, sorted);
 
 	submit_bio_wait(bio);
@@ -114,7 +114,7 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	check = bio_clone(bio, GFP_NOIO);
 	if (!check)
 		return;
-	check->bi_rw |= READ_SYNC;
+	bio_set_op_attrs(check, REQ_OP_READ, READ_SYNC);
 
 	if (bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index af3f9f7..a3c3b30 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -54,11 +54,11 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio_reset(bio);
 		bio->bi_iter.bi_sector	= bucket + offset;
 		bio->bi_bdev	= ca->bdev;
-		bio->bi_rw	= READ;
 		bio->bi_iter.bi_size	= len << 9;
 
 		bio->bi_end_io	= journal_read_endio;
 		bio->bi_private = &cl;
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		bch_bio_map(bio, data);
 
 		closure_bio_submit(bio, &cl);
@@ -449,10 +449,10 @@ static void do_journal_discard(struct cache *ca)
 		atomic_set(&ja->discard_in_flight, DISCARD_IN_FLIGHT);
 
 		bio_init(bio);
+		bio_set_op_attrs(bio, REQ_OP_DISCARD, 0);
 		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
-		bio->bi_rw		= REQ_WRITE|REQ_DISCARD;
 		bio->bi_max_vecs	= 1;
 		bio->bi_io_vec		= bio->bi_inline_vecs;
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
@@ -626,11 +626,12 @@ static void journal_write_unlocked(struct closure *cl)
 		bio_reset(bio);
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_bdev	= ca->bdev;
-		bio->bi_rw	= REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
 		bio->bi_iter.bi_size = sectors << 9;
 
 		bio->bi_end_io	= journal_write_endio;
 		bio->bi_private = w;
+		bio_set_op_attrs(bio, REQ_OP_WRITE,
+				 REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA);
 		bch_bio_map(bio, w->data);
 
 		trace_bcache_journal_write(bio);
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index b929fc9..1881319 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -163,7 +163,7 @@ static void read_moving(struct cache_set *c)
 		moving_init(io);
 		bio = &io->bio.bio;
 
-		bio->bi_rw	= READ;
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		bio->bi_end_io	= read_moving_endio;
 
 		if (bio_alloc_pages(bio, GFP_KERNEL))
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6b85a23..016b0aa 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -253,7 +253,7 @@ static void bch_data_insert_start(struct closure *cl)
 		trace_bcache_cache_insert(k);
 		bch_keylist_push(&op->insert_keys);
 
-		n->bi_rw |= REQ_WRITE;
+		bio_set_op_attrs(n, REQ_OP_WRITE, 0);
 		bch_submit_bbio(n, op->c, k, 0);
 	} while (n != bio);
 
@@ -378,7 +378,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
 	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
-	    (bio->bi_rw & REQ_DISCARD))
+	    (bio_op(bio) == REQ_OP_DISCARD))
 		goto skip;
 
 	if (mode == CACHE_MODE_NONE ||
@@ -899,7 +899,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	 * But check_overlapping drops dirty keys for which io hasn't started,
 	 * so we still want to call it.
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio_op(bio) == REQ_OP_DISCARD)
 		s->iop.bypass = true;
 
 	if (should_writeback(dc, s->orig_bio,
@@ -913,7 +913,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		s->iop.bio = s->orig_bio;
 		bio_get(s->iop.bio);
 
-		if (!(bio->bi_rw & REQ_DISCARD) ||
+		if ((bio_op(bio) != REQ_OP_DISCARD) ||
 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
 			closure_bio_submit(bio, cl);
 	} else if (s->iop.writeback) {
@@ -925,10 +925,10 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
 
-			flush->bi_rw	= WRITE_FLUSH;
 			flush->bi_bdev	= bio->bi_bdev;
 			flush->bi_end_io = request_endio;
 			flush->bi_private = cl;
+			bio_set_op_attrs(flush, REQ_OP_WRITE, WRITE_FLUSH);
 
 			closure_bio_submit(flush, cl);
 		}
@@ -992,7 +992,7 @@ static blk_qc_t cached_dev_make_request(struct request_queue *q,
 				cached_dev_read(dc, s);
 		}
 	} else {
-		if ((bio->bi_rw & REQ_DISCARD) &&
+		if ((bio_op(bio) == REQ_OP_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
 			bio_endio(bio);
 		else
@@ -1103,7 +1103,7 @@ static blk_qc_t flash_dev_make_request(struct request_queue *q,
 					&KEY(d->id, bio->bi_iter.bi_sector, 0),
 					&KEY(d->id, bio_end_sector(bio), 0));
 
-		s->iop.bypass		= (bio->bi_rw & REQ_DISCARD) != 0;
+		s->iop.bypass		= (bio_op(bio) == REQ_OP_DISCARD) != 0;
 		s->iop.writeback	= true;
 		s->iop.bio		= bio;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1eb526a7..c944daf7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -212,8 +212,8 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
-	bio->bi_rw		= REQ_WRITE|REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	= SB_SIZE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
 	bch_bio_map(bio, NULL);
 
 	out->offset		= cpu_to_le64(sb->offset);
@@ -333,7 +333,7 @@ static void uuid_io_unlock(struct closure *cl)
 	up(&c->uuid_write_mutex);
 }
 
-static void uuid_io(struct cache_set *c, unsigned long rw,
+static void uuid_io(struct cache_set *c, int op, unsigned long op_flags,
 		    struct bkey *k, struct closure *parent)
 {
 	struct closure *cl = &c->uuid_write;
@@ -348,21 +348,22 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 	for (i = 0; i < KEY_PTRS(k); i++) {
 		struct bio *bio = bch_bbio_alloc(c);
 
-		bio->bi_rw	= REQ_SYNC|REQ_META|rw;
+		bio->bi_rw	= REQ_SYNC|REQ_META|op_flags;
 		bio->bi_iter.bi_size = KEY_SIZE(k) << 9;
 
 		bio->bi_end_io	= uuid_endio;
 		bio->bi_private = cl;
+		bio_set_op_attrs(bio, op, REQ_SYNC|REQ_META|op_flags);
 		bch_bio_map(bio, c->uuids);
 
 		bch_submit_bbio(bio, c, k, i);
 
-		if (!(rw & WRITE))
+		if (op != REQ_OP_WRITE)
 			break;
 	}
 
 	bch_extent_to_text(buf, sizeof(buf), k);
-	pr_debug("%s UUIDs at %s", rw & REQ_WRITE ? "wrote" : "read", buf);
+	pr_debug("%s UUIDs at %s", op == REQ_OP_WRITE ? "wrote" : "read", buf);
 
 	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
 		if (!bch_is_zero(u->uuid, 16))
@@ -381,7 +382,7 @@ static char *uuid_read(struct cache_set *c, struct jset *j, struct closure *cl)
 		return "bad uuid pointer";
 
 	bkey_copy(&c->uuid_bucket, k);
-	uuid_io(c, READ_SYNC, k, cl);
+	uuid_io(c, REQ_OP_READ, READ_SYNC, k, cl);
 
 	if (j->version < BCACHE_JSET_VERSION_UUIDv1) {
 		struct uuid_entry_v0	*u0 = (void *) c->uuids;
@@ -426,7 +427,7 @@ static int __uuid_write(struct cache_set *c)
 		return 1;
 
 	SET_KEY_SIZE(&k.key, c->sb.bucket_size);
-	uuid_io(c, REQ_WRITE, &k.key, &cl);
+	uuid_io(c, REQ_OP_WRITE, 0, &k.key, &cl);
 	closure_sync(&cl);
 
 	bkey_copy(&c->uuid_bucket, &k.key);
@@ -498,7 +499,8 @@ static void prio_endio(struct bio *bio)
 	closure_put(&ca->prio);
 }
 
-static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
+static void prio_io(struct cache *ca, uint64_t bucket, int op,
+		    unsigned long op_flags)
 {
 	struct closure *cl = &ca->prio;
 	struct bio *bio = bch_bbio_alloc(ca->set);
@@ -507,11 +509,11 @@ static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
 
 	bio->bi_iter.bi_sector	= bucket * ca->sb.bucket_size;
 	bio->bi_bdev		= ca->bdev;
-	bio->bi_rw		= REQ_SYNC|REQ_META|rw;
 	bio->bi_iter.bi_size	= bucket_bytes(ca);
 
 	bio->bi_end_io	= prio_endio;
 	bio->bi_private = ca;
+	bio_set_op_attrs(bio, op, REQ_SYNC|REQ_META|op_flags);
 	bch_bio_map(bio, ca->disk_buckets);
 
 	closure_bio_submit(bio, &ca->prio);
@@ -557,7 +559,7 @@ void bch_prio_write(struct cache *ca)
 		BUG_ON(bucket == -1);
 
 		mutex_unlock(&ca->set->bucket_lock);
-		prio_io(ca, bucket, REQ_WRITE);
+		prio_io(ca, bucket, REQ_OP_WRITE, 0);
 		mutex_lock(&ca->set->bucket_lock);
 
 		ca->prio_buckets[i] = bucket;
@@ -599,7 +601,7 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 			ca->prio_last_buckets[bucket_nr] = bucket;
 			bucket_nr++;
 
-			prio_io(ca, bucket, READ_SYNC);
+			prio_io(ca, bucket, REQ_OP_READ, READ_SYNC);
 
 			if (p->csum != bch_crc64(&p->magic, bucket_bytes(ca) - 8))
 				pr_warn("bad csum reading priorities");
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6012367..d9fd2a6 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -182,7 +182,7 @@ static void write_dirty(struct closure *cl)
 	struct keybuf_key *w = io->bio.bi_private;
 
 	dirty_init(w);
-	io->bio.bi_rw		= WRITE;
+	bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
 	io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 	io->bio.bi_bdev		= io->dc->bdev;
 	io->bio.bi_end_io	= dirty_endio;
@@ -251,10 +251,10 @@ static void read_dirty(struct cached_dev *dc)
 		io->dc		= dc;
 
 		dirty_init(w);
+		bio_set_op_attrs(&io->bio, REQ_OP_READ, 0);
 		io->bio.bi_iter.bi_sector = PTR_OFFSET(&w->key, 0);
 		io->bio.bi_bdev		= PTR_CACHE(dc->disk.c,
 						    &w->key, 0)->bdev;
-		io->bio.bi_rw		= READ;
 		io->bio.bi_end_io	= read_dirty_endio;
 
 		if (bio_alloc_pages(&io->bio, GFP_KERNEL))
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
