Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45888 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbeEGQNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 12:13:42 -0400
Received: by mail-io0-f194.google.com with SMTP id c9-v6so28303904iob.12
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 09:13:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] block: break discard submissions into the user defined size
Date: Mon,  7 May 2018 10:13:32 -0600
Message-Id: <1525709615-14395-2-git-send-email-axboe@kernel.dk>
In-Reply-To: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: dchinner@redhat.com, hch@lst.de, Jens Axboe <axboe@kernel.dk>

Don't build discards bigger than what the user asked for, if the
user decided to limit the size by writing to 'discard_max_bytes'.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-lib.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a676084d4740..7417d617091b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -62,10 +62,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		unsigned int req_sects;
 		sector_t end_sect, tmp;
 
-		/* Make sure bi_size doesn't overflow */
-		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+		/* Issue in chunks of the user defined max discard setting */
+		req_sects = min_t(sector_t, nr_sects,
+					q->limits.max_discard_sectors);
 
-		/**
+		/*
 		 * If splitting a request, and the next starting sector would be
 		 * misaligned, stop the discard at the previous aligned sector.
 		 */
-- 
2.7.4

