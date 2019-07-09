Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfGIPYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 11:24:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: chain bios the right way around in xfs_rw_bdev
Date: Tue,  9 Jul 2019 08:23:52 -0700
Message-Id: <20190709152352.27465-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

We need to chain the earlier bios to the later ones, so that
submit_bio_wait waits on the bio that all the completions are
dispatched to.

Fixes: 6ad5b3255b9e ("xfs: use bios directly to read and write the log recovery buffers")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bio_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 757c1d9293eb..e2148f2d5d6b 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -43,7 +43,7 @@ xfs_rw_bdev(
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
 			bio->bi_opf = prev->bi_opf;
-			bio_chain(bio, prev);
+			bio_chain(prev, bio);
 
 			submit_bio(prev);
 		}
-- 
2.20.1
