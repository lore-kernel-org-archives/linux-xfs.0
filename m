Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404494AbfFKPKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:46 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] block: fix page leak when merging to same page
Date: Tue, 11 Jun 2019 17:10:06 +0200
Message-Id: <20190611151007.13625-5-hch@lst.de>
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

When multiple iovecs reference the same page, each get_user_page call
will add a reference to the page.  But once we've created the bio that
information gets lost and only a single reference will be dropped after
I/O completion.  Use the same_page information returned from
__bio_try_merge_page to drop additional references to pages that were
already present in the bio.

Based on a patch from Ming Lei.

Link: https://lkml.org/lkml/2019/4/23/64
Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c34327aa9216..0d841ba4373a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -891,6 +891,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
+	bool same_page = false;
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
@@ -911,8 +912,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		struct page *page = pages[i];
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
-		if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
-			return -EINVAL;
+
+		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
+			if (same_page)
+				put_page(page);
+		} else {
+			if (WARN_ON_ONCE(bio_full(bio)))
+                                return -EINVAL;
+			__bio_add_page(bio, page, len, offset);
+		}
 		offset = 0;
 	}
 
-- 
2.20.1
