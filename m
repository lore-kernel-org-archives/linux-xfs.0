Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45838 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753257AbeD3XAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 19:00:18 -0400
Received: by mail-pg0-f65.google.com with SMTP id i29-v6so7249955pgn.12
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 16:00:18 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
From: Jens Axboe <axboe@kernel.dk>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
 <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
Message-ID: <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
Date: Mon, 30 Apr 2018 17:00:14 -0600
MIME-Version: 1.0
In-Reply-To: <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 4:40 PM, Jens Axboe wrote:
> On 4/30/18 4:28 PM, Dave Chinner wrote:
>> Yes, it does, but so would having the block layer to throttle device
>> discard requests in flight to a queue depth of 1. And then we don't
>> have to change XFS at all.
> 
> I'm perfectly fine with making that change by default, and much easier
> for me since I don't have to patch file systems.

Totally untested, but this should do the trick. It ensures we have
a QD of 1 (per caller), which should be sufficient.

If people tune down the discard size, then you'll be blocking waiting
for discards on issue.

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a676084d4740..0bf9befcc863 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -11,16 +11,19 @@
 #include "blk.h"
 
 static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
-		gfp_t gfp)
+			    gfp_t gfp)
 {
-	struct bio *new = bio_alloc(gfp, nr_pages);
-
+	/*
+	 * Devices suck at discard, so if we have to break up the bio
+	 * size due to the max discard size setting, wait for the
+	 * previous one to finish first.
+	 */
 	if (bio) {
-		bio_chain(bio, new);
-		submit_bio(bio);
+		submit_bio_wait(bio);
+		bio_put(bio);
 	}
 
-	return new;
+	return bio_alloc(gfp, nr_pages);
 }
 
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
@@ -63,7 +66,8 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t end_sect, tmp;
 
 		/* Make sure bi_size doesn't overflow */
-		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+		req_sects = min_t(sector_t, nr_sects,
+					q->limits.max_discard_sectors);
 
 		/**
 		 * If splitting a request, and the next starting sector would be

-- 
Jens Axboe

