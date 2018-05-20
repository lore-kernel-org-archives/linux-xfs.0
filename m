Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36532 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752655AbeETW0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:37 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 10/12] btrfs: convert to bioset_init()/mempool_init()
Date: Sun, 20 May 2018 18:25:56 -0400
Message-Id: <20180520222558.7053-11-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/btrfs/extent_io.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e99b329002..56d32bb462 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -26,7 +26,7 @@
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
-static struct bio_set *btrfs_bioset;
+static struct bio_set btrfs_bioset;
 
 static inline bool extent_state_in_tree(const struct extent_state *state)
 {
@@ -162,20 +162,18 @@ int __init extent_io_init(void)
 	if (!extent_buffer_cache)
 		goto free_state_cache;
 
-	btrfs_bioset = bioset_create(BIO_POOL_SIZE,
-				     offsetof(struct btrfs_io_bio, bio),
-				     BIOSET_NEED_BVECS);
-	if (!btrfs_bioset)
+	if (bioset_init(&btrfs_bioset, BIO_POOL_SIZE,
+			offsetof(struct btrfs_io_bio, bio),
+			BIOSET_NEED_BVECS))
 		goto free_buffer_cache;
 
-	if (bioset_integrity_create(btrfs_bioset, BIO_POOL_SIZE))
+	if (bioset_integrity_create(&btrfs_bioset, BIO_POOL_SIZE))
 		goto free_bioset;
 
 	return 0;
 
 free_bioset:
-	bioset_free(btrfs_bioset);
-	btrfs_bioset = NULL;
+	bioset_exit(&btrfs_bioset);
 
 free_buffer_cache:
 	kmem_cache_destroy(extent_buffer_cache);
@@ -198,8 +196,7 @@ void __cold extent_io_exit(void)
 	rcu_barrier();
 	kmem_cache_destroy(extent_state_cache);
 	kmem_cache_destroy(extent_buffer_cache);
-	if (btrfs_bioset)
-		bioset_free(btrfs_bioset);
+	bioset_exit(&btrfs_bioset);
 }
 
 void extent_io_tree_init(struct extent_io_tree *tree,
@@ -2679,7 +2676,7 @@ struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte)
 {
 	struct bio *bio;
 
-	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, btrfs_bioset);
+	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &btrfs_bioset);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = first_byte >> 9;
 	btrfs_io_bio_init(btrfs_io_bio(bio));
@@ -2692,7 +2689,7 @@ struct bio *btrfs_bio_clone(struct bio *bio)
 	struct bio *new;
 
 	/* Bio allocation backed by a bioset does not fail */
-	new = bio_clone_fast(bio, GFP_NOFS, btrfs_bioset);
+	new = bio_clone_fast(bio, GFP_NOFS, &btrfs_bioset);
 	btrfs_bio = btrfs_io_bio(new);
 	btrfs_io_bio_init(btrfs_bio);
 	btrfs_bio->iter = bio->bi_iter;
@@ -2704,7 +2701,7 @@ struct bio *btrfs_io_bio_alloc(unsigned int nr_iovecs)
 	struct bio *bio;
 
 	/* Bio allocation backed by a bioset does not fail */
-	bio = bio_alloc_bioset(GFP_NOFS, nr_iovecs, btrfs_bioset);
+	bio = bio_alloc_bioset(GFP_NOFS, nr_iovecs, &btrfs_bioset);
 	btrfs_io_bio_init(btrfs_io_bio(bio));
 	return bio;
 }
@@ -2715,7 +2712,7 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 	struct btrfs_io_bio *btrfs_bio;
 
 	/* this will never fail when it's backed by a bioset */
-	bio = bio_clone_fast(orig, GFP_NOFS, btrfs_bioset);
+	bio = bio_clone_fast(orig, GFP_NOFS, &btrfs_bioset);
 	ASSERT(bio);
 
 	btrfs_bio = btrfs_io_bio(bio);
-- 
2.17.0

