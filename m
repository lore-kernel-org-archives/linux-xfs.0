Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49831 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdJEQdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 12:33:33 -0400
Date: Thu, 5 Oct 2017 09:33:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: false positive lockdep splat with loop device
Message-ID: <20171005163328.GA3562@infradead.org>
References: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
 <20170926042421.GP10955@dastard>
 <CAOQ4uxhybgUmfk_voNxgx+NVT2JabKdcgtmKxSSGRF5LS+_C+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhybgUmfk_voNxgx+NVT2JabKdcgtmKxSSGRF5LS+_C+g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

Does the patch below fix the warning for you?

--
>From 28aae7104425433d39e6142adcd5b88dc5b0ad5f Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 5 Oct 2017 18:31:02 +0200
Subject: block: use DECLARE_COMPLETION_ONSTACK in submit_bio_wait

This way we get our lockdep annotations right in case multiple layers
in the stack use submit_bio_wait.

It also happens to simplify the code by getting rid of the submit_bio_ret
structure.

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
2.14.1

