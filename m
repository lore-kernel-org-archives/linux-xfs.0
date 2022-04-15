Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F091C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 11:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352579AbiDOLDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 07:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352580AbiDOLD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 07:03:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E40D5BF52B
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 04:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650020450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swJmJjsyEir1ptFGEkx0uxAo7c+eDE2H3xRn7VWYphQ=;
        b=IyYak90jj0HnWuOqkylXROFzabUoWUlkUVMnfOXlfdlLFBAQbXK96WbRV5P/rZzQmHQ5uV
        6Bu+tN7iywngoTfqO42rK/lM/oB5Mc8xiV5Cd9DEGERBWPN8DI1iosIBysTVFt07Ec5Hhh
        w4Wa4JfqaaQr3ndH6YO3KzKD07p+9To=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-AyWIkw6wMn-zgAe2jDt2yg-1; Fri, 15 Apr 2022 07:00:47 -0400
X-MC-Unique: AyWIkw6wMn-zgAe2jDt2yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDEA638041DB;
        Fri, 15 Apr 2022 11:00:46 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D388C40EC01C;
        Fri, 15 Apr 2022 11:00:42 +0000 (UTC)
Date:   Fri, 15 Apr 2022 19:00:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <YllQVT6n472eUB7+@T590>
References: <20220415034703.2081695-1-ming.lei@redhat.com>
 <20220415051844.GA22762@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415051844.GA22762@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 07:18:44AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 15, 2022 at 11:47:03AM +0800, Ming Lei wrote:
> > +	/* make sure the bio is issued before polling */
> > +	if (bio.bi_opf & REQ_POLLED)
> > +		blk_flush_plug(current->plug, false);
> 
> I still think the core code should handle this.  Without that we'd need
> to export the blk_flush_plug for anything that would want to poll bios
> from modules, in addition to it generally being a mess.  See a proposed

So far there isn't such usage yet. dm calls bio_poll() in ->iopoll(),
and its caller(io_uring) will finish the plug.

> patch for that below.  I'd also split the flush aspect from the poll
> aspect into two patches.
> 
> > +		if (bio.bi_opf & REQ_POLLED)
> > +			bio_poll(&bio, NULL, 0);
> > +		else
> >  			blk_io_schedule();
> 
> Instead of this duplicate logic everywhere I'd just make bio_boll
> call blk_io_schedule for the !REQ_POLLED case and simplify all the
> callers.

bio_poll() may be called with rcu read lock held, so I'd suggest to
not mix the two together.

> 
> > +			if (dio->submit.poll_bio &&
> > +					(dio->submit.poll_bio->bi_opf &
> > +						REQ_POLLED))
> 
> This indentation looks awfull,normal would be:
> 
> 			if (dio->submit.poll_bio &&
> 			    (dio->submit.poll_bio->bi_opf & REQ_POLLED))

That follows the indentation style of fs/iomap/direct-io.c for break in
'if'.

> 
> ---
> From 08ff61b0142eb708fc384cf867c72175561d974a Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 15 Apr 2022 07:15:42 +0200
> Subject: blk-mq: don't plug for synchronously polled requests
> 
> For synchronous polling to work, the bio must be issued to the driver from
> the submit_bio call, otherwise ->bi_cookie won't be set.
> 
> Based on a patch from Ming Lei.
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ed3ed86f7dd24..bcc7e3d11296c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2851,7 +2851,13 @@ void blk_mq_submit_bio(struct bio *bio)
>  		return;
>  	}
>  
> -	if (plug)
> +	/*
> +	 * We can't plug for synchronously polled submissions, otherwise
> +	 * bio->bi_cookie won't be set directly after submission, which is the
> +	 * indicator used by the submitter to check if a bio needs polling.
> +	 */
> +	if (plug &&
> +	    (rq->bio->bi_opf & (REQ_POLLED | REQ_NOWAIT)) != REQ_POLLED)
>  		blk_add_rq_to_plug(plug, rq);
>  	else if ((rq->rq_flags & RQF_ELV) ||
>  		 (rq->mq_hctx->dispatch_busy &&

It is nothing to do with REQ_NOWAIT. sync polled dio can be marked as
REQ_NOWAIT by userspace too. If '--nowait=1' is added in the fio
reproducer, io timeout is triggered too.



Thanks,
Ming

