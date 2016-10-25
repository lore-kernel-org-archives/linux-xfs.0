Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936309AbcJYPI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 11:08:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] block: add bio_iov_iter_get_pages()
Date: Tue, 25 Oct 2016 17:08:15 +0200
Message-Id: <1477408098-10153-4-git-send-email-hch@lst.de>
In-Reply-To: <1477408098-10153-1-git-send-email-hch@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

This is a helper that pins down a range from an iov_iter and adds it to
a bio without requiring a separate memory allocation for the page array.
It will be used for upcoming direct I/O implementations for block devices
and iomap based file systems.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
[hch: ported to the iov_iter interface, renamed and added comments.
      All blame should be directed to me and all fame should go to Kent
      after this!]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index db85c57..2cf6eba 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -847,6 +847,55 @@ int bio_add_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+/**
+ * bio_iov_iter_get_pages - pin user or kernel pages and add them to a bio
+ * @bio: bio to add pages to
+ * @iter: iov iterator describing the region to be mapped
+ *
+ * Pins as many pages from *iter and appends them to @bio's bvec array. The
+ * pages will have to be released using put_page() when done.
+ */
+int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
+{
+	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
+	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
+	struct page **pages = (struct page **)bv;
+	size_t offset, diff;
+	ssize_t size;
+
+	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
+	if (unlikely(size <= 0))
+		return size ? size : -EFAULT;
+	nr_pages = (size + offset + PAGE_SIZE - 1) / PAGE_SIZE;
+
+	/*
+	 * Deep magic below:  We need to walk the pinned pages backwards
+	 * because we are abusing the space allocated for the bio_vecs
+	 * for the page array.  Because the bio_vecs are larger than the
+	 * page pointers by definition this will always work.  But it also
+	 * means we can't use bio_add_page, so any changes to it's semantics
+	 * need to be reflected here as well.
+	 */
+	bio->bi_iter.bi_size += size;
+	bio->bi_vcnt += nr_pages;
+
+	diff = (nr_pages * PAGE_SIZE - offset) - size;
+	while (nr_pages--) {
+		bv[nr_pages].bv_page = pages[nr_pages];
+		bv[nr_pages].bv_len = PAGE_SIZE;
+		bv[nr_pages].bv_offset = 0;
+	}
+
+	bv[0].bv_offset += offset;
+	bv[0].bv_len -= offset;
+	if (diff)
+		bv[bio->bi_vcnt - 1].bv_len -= diff;
+
+	iov_iter_advance(iter, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
+
 struct submit_bio_ret {
 	struct completion event;
 	int error;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 97cb48f..66228c2 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -430,6 +430,7 @@ void bio_chain(struct bio *, struct bio *);
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
+int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    const struct iov_iter *, gfp_t);
-- 
2.1.4

