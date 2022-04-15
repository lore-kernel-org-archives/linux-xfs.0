Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71CEC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 05:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiDOFVQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiDOFVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 01:21:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F351AD8C;
        Thu, 14 Apr 2022 22:18:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1808D68B05; Fri, 15 Apr 2022 07:18:45 +0200 (CEST)
Date:   Fri, 15 Apr 2022 07:18:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220415051844.GA22762@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415034703.2081695-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 11:47:03AM +0800, Ming Lei wrote:
> +	/* make sure the bio is issued before polling */
> +	if (bio.bi_opf & REQ_POLLED)
> +		blk_flush_plug(current->plug, false);

I still think the core code should handle this.  Without that we'd need
to export the blk_flush_plug for anything that would want to poll bios
from modules, in addition to it generally being a mess.  See a proposed
patch for that below.  I'd also split the flush aspect from the poll
aspect into two patches.

> +		if (bio.bi_opf & REQ_POLLED)
> +			bio_poll(&bio, NULL, 0);
> +		else
>  			blk_io_schedule();

Instead of this duplicate logic everywhere I'd just make bio_boll
call blk_io_schedule for the !REQ_POLLED case and simplify all the
callers.

> +			if (dio->submit.poll_bio &&
> +					(dio->submit.poll_bio->bi_opf &
> +						REQ_POLLED))

This indentation looks awfull,normal would be:

			if (dio->submit.poll_bio &&
			    (dio->submit.poll_bio->bi_opf & REQ_POLLED))

---
From 08ff61b0142eb708fc384cf867c72175561d974a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 15 Apr 2022 07:15:42 +0200
Subject: blk-mq: don't plug for synchronously polled requests

For synchronous polling to work, the bio must be issued to the driver from
the submit_bio call, otherwise ->bi_cookie won't be set.

Based on a patch from Ming Lei.

Reported-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ed3ed86f7dd24..bcc7e3d11296c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2851,7 +2851,13 @@ void blk_mq_submit_bio(struct bio *bio)
 		return;
 	}
 
-	if (plug)
+	/*
+	 * We can't plug for synchronously polled submissions, otherwise
+	 * bio->bi_cookie won't be set directly after submission, which is the
+	 * indicator used by the submitter to check if a bio needs polling.
+	 */
+	if (plug &&
+	    (rq->bio->bi_opf & (REQ_POLLED | REQ_NOWAIT)) != REQ_POLLED)
 		blk_add_rq_to_plug(plug, rq);
 	else if ((rq->rq_flags & RQF_ELV) ||
 		 (rq->mq_hctx->dispatch_busy &&
-- 
2.30.2

