Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfDVKCT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 06:02:19 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] block: clarify that bio_add_page() and related helpers can add multi pages
Date: Mon, 22 Apr 2019 18:02:07 +0800
Message-Id: <20190422100207.13057-1-ming.lei@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- add Reviewed-by tag
	- rebase on latest for-5.2/block

 block/bio.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5959141d4e46..e92c37ce20a6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -688,6 +688,8 @@ static bool can_add_page_to_seg(struct request_queue *q,
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
 
+	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
+
 	return true;
 }
 
@@ -786,9 +788,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
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
@@ -796,6 +798,8 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * a useful optimisation for file systems with a block size smaller than the
  * page size.
  *
+ * Warn if (@len, @off) crosses pages in case that @same_page is true.
+ *
  * Return %true on success or %false on failure.
  */
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
@@ -818,11 +822,11 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
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
@@ -845,13 +849,13 @@ void __bio_add_page(struct bio *bio, struct page *page,
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
