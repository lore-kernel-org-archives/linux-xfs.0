Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfC1DuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Mar 2019 23:50:15 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] block: clarify that bio_add_page() and related helpers can add multi pages
Date: Thu, 28 Mar 2019 11:50:01 +0800
Message-Id: <20190328035001.26276-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

bio_add_page() and __bio_add_page() are capable of adding pages into
bio, and now we have at least two such usages alreay:

	- __bio_iov_bvec_add_pages()
	- nvmet_bdev_execute_rw().

So update comments on these two helpers.

The thing is a bit special for __bio_try_merge_page(), given the caller
needs to know if the new added page is same with the last added page,
then it isn't safe to pass multi-page in case that 'same_page' is true,
so adds warning on potential misuse, and updates comment on
__bio_try_merge_page().

Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 40 ++++++++++++++++++++++------------------
 include/linux/bio.h |  4 ++--
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b64cedc7f87c..0cfb2fd981c3 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -750,9 +750,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
 /**
  * __bio_try_merge_page - try appending data to an existing bvec.
  * @bio: destination bio
- * @page: page to add
+ * @start_page: start page to add
  * @len: length of the data to add
- * @off: offset of the data in @page
+ * @off: offset of the data relative to @start_page
  * @same_page: if %true only merge if the new data is in the same physical
  *		page as the last segment of the bio.
  *
@@ -760,9 +760,11 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * a useful optimisation for file systems with a block size smaller than the
  * page size.
  *
+ * Warn if @same_page is true and (@len, @off) crosses pages.
+ *
  * Return %true on success or %false on failure.
  */
-bool __bio_try_merge_page(struct bio *bio, struct page *page,
+bool __bio_try_merge_page(struct bio *bio, struct page *start_page,
 		unsigned int len, unsigned int off, bool same_page)
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
@@ -772,10 +774,12 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 		phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
 			bv->bv_offset + bv->bv_len - 1;
-		phys_addr_t page_addr = page_to_phys(page);
+		phys_addr_t page_addr = page_to_phys(start_page);
 
 		if (vec_end_addr + 1 != page_addr + off)
 			return false;
+
+		WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
 		if (same_page && (vec_end_addr & PAGE_MASK) != page_addr)
 			return false;
 
@@ -788,16 +792,16 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
 /**
- * __bio_add_page - add page to a bio in a new segment
+ * __bio_add_page - add page(s) to a bio in a new segment
  * @bio: destination bio
- * @page: page to add
- * @len: length of the data to add
- * @off: offset of the data in @page
+ * @start_page: start page to add
+ * @len: length of the data to add, may cross pages
+ * @off: offset of the data relative to @start_page, may cross pages
  *
  * Add the data at @page + @off to @bio as a new bvec.  The caller must ensure
  * that @bio has space for another bvec.
  */
-void __bio_add_page(struct bio *bio, struct page *page,
+void __bio_add_page(struct bio *bio, struct page *start_page,
 		unsigned int len, unsigned int off)
 {
 	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
@@ -805,7 +809,7 @@ void __bio_add_page(struct bio *bio, struct page *page,
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
 	WARN_ON_ONCE(bio_full(bio));
 
-	bv->bv_page = page;
+	bv->bv_page = start_page;
 	bv->bv_offset = off;
 	bv->bv_len = len;
 
@@ -815,22 +819,22 @@ void __bio_add_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL_GPL(__bio_add_page);
 
 /**
- *	bio_add_page	-	attempt to add page to bio
+ *	bio_add_page	-	attempt to add page(s) to bio
  *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
+ *	@start_page: start page to add
+ *	@len: vec entry length, may cross pages
+ *	@offset: vec entry offset relative to @start_page, may cross pages
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
+ *	Attempt to add page(s) to the bio_vec maplist. This will only fail
  *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
  */
-int bio_add_page(struct bio *bio, struct page *page,
+int bio_add_page(struct bio *bio, struct page *start_page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
+	if (!__bio_try_merge_page(bio, start_page, len, offset, false)) {
 		if (bio_full(bio))
 			return 0;
-		__bio_add_page(bio, page, len, offset);
+		__bio_add_page(bio, start_page, len, offset);
 	}
 	return len;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb6090aa165d..40acfe5dc99f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -432,9 +432,9 @@ void bio_chain(struct bio *, struct bio *);
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-bool __bio_try_merge_page(struct bio *bio, struct page *page,
+bool __bio_try_merge_page(struct bio *bio, struct page *start_page,
 		unsigned int len, unsigned int off, bool same_page);
-void __bio_add_page(struct bio *bio, struct page *page,
+void __bio_add_page(struct bio *bio, struct page *start_page,
 		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 struct rq_map_data;
-- 
2.9.5
