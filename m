Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfDBCgl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Apr 2019 22:36:41 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] block: clarify that bio_add_page() and related helpers can add multi pages
Date: Tue,  2 Apr 2019 10:36:32 +0800
Message-Id: <20190402023632.8485-1-ming.lei@redhat.com>
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
 block/bio.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8d516d508ae3..07315056c2f6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -662,6 +662,8 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 	if (same_page && (vec_end_addr & PAGE_MASK) != page_addr)
 		return false;
 
+	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
+
 	return true;
 }
 
@@ -781,9 +783,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
 /**
  * __bio_try_merge_page - try appending data to an existing bvec.
  * @bio: destination bio
- * @page: page to add
+ * @page: start page to add
  * @len: length of the data to add
- * @off: offset of the data in @page
+ * @off: offset of the data relative to @page
  * @same_page: if %true only merge if the new data is in the same physical
  *		page as the last segment of the bio.
  *
@@ -791,6 +793,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * a useful optimisation for file systems with a block size smaller than the
  * page size.
  *
+ * Warn if (@len, @off) crosses pages in case that @same_page is true.
+ *
  * Return %true on success or %false on failure.
  */
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
@@ -813,11 +817,11 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 
 /**
- * __bio_add_page - add page to a bio in a new segment
+ * __bio_add_page - add page(s) to a bio in a new segment
  * @bio: destination bio
- * @page: page to add
- * @len: length of the data to add
- * @off: offset of the data in @page
+ * @page: start page to add
+ * @len: length of the data to add, may cross pages
+ * @off: offset of the data relative to @page, may cross pages
  *
  * Add the data at @page + @off to @bio as a new bvec.  The caller must ensure
  * that @bio has space for another bvec.
@@ -840,13 +844,13 @@ void __bio_add_page(struct bio *bio, struct page *page,
 EXPORT_SYMBOL_GPL(__bio_add_page);
 
 /**
- *	bio_add_page	-	attempt to add page to bio
+ *	bio_add_page	-	attempt to add page(s) to bio
  *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
+ *	@page: start page to add
+ *	@len: vec entry length, may cross pages
+ *	@offset: vec entry offset relative to @page, may cross pages
  *
- *	Attempt to add a page to the bio_vec maplist. This will only fail
+ *	Attempt to add page(s) to the bio_vec maplist. This will only fail
  *	if either bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.
  */
 int bio_add_page(struct bio *bio, struct page *page,
-- 
2.9.5
