Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbdJTOo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 10:44:57 -0400
Date: Fri, 20 Oct 2017 07:44:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] lockdep: Assign a lock_class per gendisk used for
 wait_for_completion()
Message-ID: <20171020144451.GA16793@infradead.org>
References: <1508392531-11284-1-git-send-email-byungchul.park@lge.com>
 <1508396607-25362-1-git-send-email-byungchul.park@lge.com>
 <1508396607-25362-5-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508396607-25362-5-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

The Subject prefix for this should be "block:".

> @@ -945,7 +945,7 @@ int submit_bio_wait(struct bio *bio)
>  {
>  	struct submit_bio_ret ret;
>  
> -	init_completion(&ret.event);
> +	init_completion_with_map(&ret.event, &bio->bi_disk->lockdep_map);

FYI, I have an outstanding patch to simplify this a lot, which
switches this to DECLARE_COMPLETION_ONSTACK.  I can delay this or let
you pick it up with your series, but we'll need a variant of
DECLARE_COMPLETION_ONSTACK with the lockdep annotations.

Patch below for reference:

---
>From d65b89843c9f82c0744643515ba51dd10e66e67b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 5 Oct 2017 18:31:02 +0200
Subject: block: use DECLARE_COMPLETION_ONSTACK in submit_bio_wait

Simplify the code by getting rid of the submit_bio_ret structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8338304ea256..4e18e959fc0a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -917,17 +917,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
 
-struct submit_bio_ret {
-	struct completion event;
-	int error;
-};
-
 static void submit_bio_wait_endio(struct bio *bio)
 {
-	struct submit_bio_ret *ret = bio->bi_private;
-
-	ret->error = blk_status_to_errno(bio->bi_status);
-	complete(&ret->event);
+	complete(bio->bi_private);
 }
 
 /**
@@ -943,16 +935,15 @@ static void submit_bio_wait_endio(struct bio *bio)
  */
 int submit_bio_wait(struct bio *bio)
 {
-	struct submit_bio_ret ret;
+	DECLARE_COMPLETION_ONSTACK(done);
 
-	init_completion(&ret.event);
-	bio->bi_private = &ret;
+	bio->bi_private = &done;
 	bio->bi_end_io = submit_bio_wait_endio;
 	bio->bi_opf |= REQ_SYNC;
 	submit_bio(bio);
-	wait_for_completion_io(&ret.event);
+	wait_for_completion_io(&done);
 
-	return ret.error;
+	return blk_status_to_errno(bio->bi_status);
 }
 EXPORT_SYMBOL(submit_bio_wait);
 
-- 
2.14.2

