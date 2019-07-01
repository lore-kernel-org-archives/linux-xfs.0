Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbfGAERA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 00:17:00 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] block: fix .bi_size overflow
Date: Mon,  1 Jul 2019 12:16:44 +0800
Message-Id: <20190701041644.16052-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
bytes.

Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
include very limited pages, and usually at most 256, so the fs bio
size won't be bigger than 1M bytes most of times.

Since we support multi-page bvec, in theory one fs bio really can
be added > 1M pages, especially in case of hugepage, or big writeback
in case of huge dirty pages. Then there is chance in which .bi_size
is overflowed.

Fixes this issue by adding bio_will_full() which checks if the added
segment may overflow .bi_size.

Cc: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Fixes: 07173c3ec276 ("block: enable multipage bvecs")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         |  8 ++++----
 fs/iomap.c          |  2 +-
 fs/xfs/xfs_aops.c   |  2 +-
 include/linux/bio.h | 10 ++++++++++
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ce797d73bb43..90164e089e60 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -731,7 +731,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		}
 	}
 
-	if (bio_full(bio))
+	if (bio_will_full(bio, len))
 		return 0;
 
 	if (bio->bi_phys_segments >= queue_max_segments(q))
@@ -807,7 +807,7 @@ void __bio_add_page(struct bio *bio, struct page *page,
 	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
 
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	WARN_ON_ONCE(bio_full(bio));
+	WARN_ON_ONCE(bio_will_full(bio, len));
 
 	bv->bv_page = page;
 	bv->bv_offset = off;
@@ -834,7 +834,7 @@ int bio_add_page(struct bio *bio, struct page *page,
 	bool same_page = false;
 
 	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		if (bio_full(bio))
+		if (bio_will_full(bio, len))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
 	}
@@ -922,7 +922,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 			if (same_page)
 				put_page(page);
 		} else {
-			if (WARN_ON_ONCE(bio_full(bio)))
+			if (WARN_ON_ONCE(bio_will_full(bio, len)))
                                 return -EINVAL;
 			__bio_add_page(bio, page, len, offset);
 		}
diff --git a/fs/iomap.c b/fs/iomap.c
index 12654c2e78f8..26cb851f9b35 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -333,7 +333,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	if (iop)
 		atomic_inc(&iop->read_count);
 
-	if (!ctx->bio || !is_contig || bio_full(ctx->bio)) {
+	if (!ctx->bio || !is_contig || bio_will_full(ctx->bio, plen)) {
 		gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
 		int nr_vecs = (length + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8da5e6637771..d705643567e7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -782,7 +782,7 @@ xfs_add_to_ioend(
 		atomic_inc(&iop->write_count);
 
 	if (!merged) {
-		if (bio_full(wpc->ioend->io_bio))
+		if (bio_will_full(wpc->ioend->io_bio, len))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
 		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f87abaa898f0..5feebcc04884 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -107,6 +107,16 @@ static inline bool bio_full(struct bio *bio)
 	return bio->bi_vcnt >= bio->bi_max_vecs;
 }
 
+static inline bool bio_will_full(struct bio *bio, unsigned len)
+{
+	if (bio_full(bio))
+		return true;
+
+	if (bio->bi_iter.bi_size > UINT_MAX - len)
+		return true;
+	return false;
+}
+
 static inline bool bio_next_segment(const struct bio *bio,
 				    struct bvec_iter_all *iter)
 {
-- 
2.20.1
