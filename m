Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933886AbeEIHtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:49:04 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/33] iomap: use __bio_add_page in iomap_dio_zero
Date: Wed,  9 May 2018 09:48:05 +0200
Message-Id: <20180509074830.16196-9-hch@lst.de>
In-Reply-To: <20180509074830.16196-1-hch@lst.de>
References: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

We don't need any merging logic, and this also replaces a BUG_ON with a
WARN_ON_ONCE inside __bio_add_page for the impossible overflow condition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index b3592183b1a0..58bb39bac72b 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -951,8 +951,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
 	get_page(page);
-	if (bio_add_page(bio, page, len, 0) != len)
-		BUG();
+	__bio_add_page(bio, page, len, 0);
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
 
 	atomic_inc(&dio->ref);
-- 
2.17.0

