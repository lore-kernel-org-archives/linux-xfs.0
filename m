Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388190AbfFJJCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 05:02:46 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 1/2] block: introduce 'enum bvec_merge_flags' for __bio_try_merge_page
Date: Mon, 10 Jun 2019 17:02:14 +0800
Message-Id: <20190610090215.14412-2-ming.lei@redhat.com>
In-Reply-To: <20190610090215.14412-1-ming.lei@redhat.com>
References: <20190610090215.14412-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, David Gibson <david@gibson.dropbear.id.au>

Introduce 'enum bvec_merge_flags' and pass it to __bio_try_merge_page,
we have to deal with several cases related with page reference when
merging same page to bio(bvec), such as:

1) only merge to same page without putting reference of the same page,
such as iomap & xfs

2) merge to same page and putting reference of the same page, such as
__bio_iov_iter_get_pages()

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 20 ++++++++++++--------
 fs/iomap.c          |  3 ++-
 fs/xfs/xfs_aops.c   |  3 ++-
 include/linux/bio.h | 14 +++++++++++++-
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 683cbb40f051..39e3b931dc3b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -636,7 +636,7 @@ EXPORT_SYMBOL(bio_clone_fast);
 
 static inline bool page_is_mergeable(const struct bio_vec *bv,
 		struct page *page, unsigned int len, unsigned int off,
-		bool same_page)
+		enum bvec_merge_flags flags)
 {
 	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
 		bv->bv_offset + bv->bv_len - 1;
@@ -648,13 +648,14 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 		return false;
 
 	if ((vec_end_addr & PAGE_MASK) != page_addr) {
-		if (same_page)
+		if (flags & BVEC_MERGE_TO_SAME_PAGE)
 			return false;
 		if (pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
 			return false;
 	}
 
-	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
+	WARN_ON_ONCE((flags & BVEC_MERGE_TO_SAME_PAGE) &&
+			(len + off) > PAGE_SIZE);
 
 	return true;
 }
@@ -729,8 +730,9 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
 
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
-		    can_add_page_to_seg(q, bvec, page, len, offset)) {
+		if (page_is_mergeable(bvec, page, len, offset,
+		    BVEC_MERGE_DEFAULT) && can_add_page_to_seg(q, bvec,
+		    page, len, offset)) {
 			bvec->bv_len += len;
 			goto done;
 		}
@@ -779,7 +781,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * Return %true on success or %false on failure.
  */
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off, bool same_page)
+		unsigned int len, unsigned int off,
+		enum bvec_merge_flags flags)
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return false;
@@ -787,7 +790,7 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page_is_mergeable(bv, page, len, off, same_page)) {
+		if (page_is_mergeable(bv, page, len, off, flags)) {
 			bv->bv_len += len;
 			bio->bi_iter.bi_size += len;
 			return true;
@@ -837,7 +840,8 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
 int bio_add_page(struct bio *bio, struct page *page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
+	if (!__bio_try_merge_page(bio, page, len, offset,
+				  BVEC_MERGE_DEFAULT)) {
 		if (bio_full(bio))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
diff --git a/fs/iomap.c b/fs/iomap.c
index 23ef63fd1669..e04652bbf92a 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -316,7 +316,8 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 */
 	sector = iomap_sector(iomap, pos);
 	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
-		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
+		if (__bio_try_merge_page(ctx->bio, page, plen, poff,
+					 BVEC_MERGE_TO_SAME_PAGE))
 			goto done;
 		is_contig = true;
 	}
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6f0f4761a37..7e7385bc3b9e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -774,7 +774,8 @@ xfs_add_to_ioend(
 				wpc->imap.br_state, offset, bdev, sector);
 	}
 
-	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
+	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff,
+				BVEC_MERGE_TO_SAME_PAGE)) {
 		if (iop)
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0f23b5682640..ee18895431ba 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -419,11 +419,23 @@ extern void bio_uninit(struct bio *);
 extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
 
+enum bvec_merge_flags {
+	BVEC_MERGE_DEFAULT,
+
+	/*
+	 * only merge if new page is same with bio's last page, this
+	 * is exactly the behaviour before introducing multi-page
+	 * bvec
+	 */
+	BVEC_MERGE_TO_SAME_PAGE = BIT(0),
+};
+
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off, bool same_page);
+		unsigned int len, unsigned int off,
+		enum bvec_merge_flags flags);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
-- 
2.20.1
