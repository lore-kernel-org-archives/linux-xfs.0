Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:45984 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbeETW0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 18:26:36 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 09/12] fs: convert block_dev.c to bioset_init()
Date: Sun, 20 May 2018 18:25:55 -0400
Message-Id: <20180520222558.7053-10-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/block_dev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7ec920e270..b550ae280f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -272,7 +272,7 @@ struct blkdev_dio {
 	struct bio		bio;
 };
 
-static struct bio_set *blkdev_dio_pool __read_mostly;
+static struct bio_set blkdev_dio_pool;
 
 static void blkdev_bio_end_io(struct bio *bio)
 {
@@ -334,7 +334,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, blkdev_dio_pool);
+	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
 	bio_get(bio); /* extra ref for the completion handler */
 
 	dio = container_of(bio, struct blkdev_dio, bio);
@@ -432,10 +432,7 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static __init int blkdev_init(void)
 {
-	blkdev_dio_pool = bioset_create(4, offsetof(struct blkdev_dio, bio), BIOSET_NEED_BVECS);
-	if (!blkdev_dio_pool)
-		return -ENOMEM;
-	return 0;
+	return bioset_init(&blkdev_dio_pool, 4, offsetof(struct blkdev_dio, bio), BIOSET_NEED_BVECS);
 }
 module_init(blkdev_init);
 
-- 
2.17.0

