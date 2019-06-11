Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404494AbfFKPKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:51 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] block: use __bio_try_merge_page in __bio_try_merge_pc_page
Date: Tue, 11 Jun 2019 17:10:07 +0200
Message-Id: <20190611151007.13625-6-hch@lst.de>
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

Passsthrough bio handling should be the same as normal bio handling,
except that we need to take hardware limitations into account.  Thus
use the common try_merge implementation after checking the hardware
limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0d841ba4373a..7db7186eab1c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -661,20 +661,11 @@ static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
 	phys_addr_t addr1 = page_to_phys(bv->bv_page) + bv->bv_offset;
 	phys_addr_t addr2 = page_to_phys(page) + off + len - 1;
 
-	if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-		*same_page = true;
-		goto done;
-	}
-
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
-	if (!page_is_mergeable(bv, page, len, off, false))
-		return false;
-done:
-	bv->bv_len += len;
-	return true;
+	return __bio_try_merge_page(bio, page, len, off, same_page);
 }
 
 /**
@@ -737,8 +728,8 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
- done:
 	bio->bi_iter.bi_size += len;
+ done:
 	bio->bi_phys_segments = bio->bi_vcnt;
 	bio_set_flag(bio, BIO_SEG_VALID);
 	return len;
-- 
2.20.1
