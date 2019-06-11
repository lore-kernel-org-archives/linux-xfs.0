Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404429AbfFKPK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:26 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/5] block: fix gap checking in __bio_add_pc_page
Date: Tue, 11 Jun 2019 17:10:03 +0200
Message-Id: <20190611151007.13625-2-hch@lst.de>
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

If we can add more data into an existing segment we do not create a gap
per definition, so move the check for a gap after the attempt to merge
into the segment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 683cbb40f051..6db39699aab9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -722,18 +722,18 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 			goto done;
 		}
 
+		if (page_is_mergeable(bvec, page, len, offset, false) &&
+		    can_add_page_to_seg(q, bvec, page, len, offset)) {
+			bvec->bv_len += len;
+			goto done;
+		}
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
 		 */
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
-
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
-		    can_add_page_to_seg(q, bvec, page, len, offset)) {
-			bvec->bv_len += len;
-			goto done;
-		}
 	}
 
 	if (bio_full(bio))
-- 
2.20.1
