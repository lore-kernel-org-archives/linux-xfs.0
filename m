Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C684C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 03:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiEXDCv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 23:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiEXDCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 23:02:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DE87E1EB;
        Mon, 23 May 2022 20:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3782361226;
        Tue, 24 May 2022 03:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052AAC385AA;
        Tue, 24 May 2022 03:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653361362;
        bh=gSDICma7qdNeYy3eh+IRUicbClYtmCsMGCOKhaxkfVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ln0gya3UZwr4BEB/r9seXF6ekAnWCv7NOn6o/3LitiBmGettpyOOrZHnweBMmHfCc
         4Eo0T7lLUXOvmm1ImPHUCnHKPJxR3Kx4EubRjcNlg3lYrOumdo8y8Pxd6kED1ziB3I
         GasU4j4STaRIUgEBTSsKjJ+rA0Dp9gwIYO4mJRjZU3Cx0Flxc/ecyJ8Ccapj8iIJXd
         V56mePNmIE7xjCS1WmVVbfsqKEAacZ73lEGWCPaZnzUikfPL0K8HWjoD8VbLBsibMf
         H4VJmSA3VqCHUXcwgjhS1/VmAMunhF63kYgnsEaHrCIWpXk046i9xZ+3uD8afkiBGo
         MVOTqTnNbJUuQ==
Date:   Mon, 23 May 2022 21:02:39 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
 <YowpjtLfZPld1H6T@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YowpjtLfZPld1H6T@T590>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 08:40:46AM +0800, Ming Lei wrote:
> On Mon, May 23, 2022 at 04:36:04PM -0600, Keith Busch wrote:
> > On Wed, Apr 20, 2022 at 10:31:10PM +0800, Ming Lei wrote:
> > > So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> > > from userspace sync io interface, then block layer tries to poll until
> > > the bio is completed. But the current implementation calls
> > > blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> > > timeout easily.
> > 
> > Wait a second. The task's current state is TASK_RUNNING when bio_poll() returns
> > zero, so calling blk_io_schedule() isn't supposed to hang.
> 
> void __sched io_schedule(void)
> {
>         int token;
> 
>         token = io_schedule_prepare();
>         schedule();
>         io_schedule_finish(token);
> }
> 
> But who can wakeup this task after scheduling out? There can't be irq
> handler for POLLED request.

No one. If everything was working, the task state would be RUNNING, so it is
immediately available to be scheduled back in.
 
> The hang can be triggered on nvme/qemu reliably:

And clearly it's not working, but for a different reason. The polling thread
sees an invalid cookie and fails to set the task back to RUNNING, so yes, it
will sleep with no waker in the current code.

We usually expect the cookie to be set inline with submit_bio(), but we're not
guaranteed it won't be punted off to .run_work for a variety of reasons, so
the thread writing the cookie may be racing with the reader.

This was fine before the bio polling support since the cookie was always
returned with submit_bio() before that.

And I would like psync to continue working with polling. As great as io_uring
is, it's just not as efficient @qd1.

Here's a bandaid, though I assume it'll break something...

---
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ed1869a305c4..348136dc7ba9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1146,8 +1146,6 @@ void blk_mq_start_request(struct request *rq)
 	if (blk_integrity_rq(rq) && req_op(rq) == REQ_OP_WRITE)
 		q->integrity.profile->prepare_fn(rq);
 #endif
-	if (rq->bio && rq->bio->bi_opf & REQ_POLLED)
-	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
 }
 EXPORT_SYMBOL(blk_mq_start_request);
 
@@ -2464,6 +2462,9 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 	WARN_ON_ONCE(err);
 
 	blk_account_io_start(rq);
+
+	if (rq->bio->bi_opf & REQ_POLLED)
+	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
 }
 
 static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
--
