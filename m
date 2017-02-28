Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57751 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/12] block_dev: set REQ_NOMERGE for O_ATOMIC writes
Date: Tue, 28 Feb 2017 06:57:35 -0800
Message-Id: <20170228145737.19016-11-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3c47614a4b32..4dd5c54cdefb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -242,6 +242,10 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 		task_io_account_write(ret);
 	}
 
+	/* don't merge atomic requests to avoid going over the limit */
+	if (iocb->ki_filp->f_flags & O_ATOMIC)
+		bio.bi_opf |= REQ_NOMERGE;
+
 	qc = submit_bio(&bio);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -377,6 +381,10 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 
+		/* don't merge atomic requests to avoid going over the limit */
+		if (iocb->ki_filp->f_flags & O_ATOMIC)
+			bio->bi_opf |= REQ_NOMERGE;
+
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 
-- 
2.11.0

