Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C646BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 06:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiEXGKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 02:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiEXGKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 02:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F916A431
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 23:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653372617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0lVXFe0qFA7zOf/OnqShVeF63IEuBXtzwt2vZMB8Kq8=;
        b=SYPezMStmhvv6/ujh2AY71UOZC7O+oo67xY6WSnRs/PyllgIBNErb3r5ysqokPxDsNvA4a
        63Iu4ywn+BxMKjWZfHKJlxus+2M/fNdqEC9zrLPVLt/wQXNEkp13aNZxiMgcNGjLH1nTZi
        MuqCHQNuDW2QobqnzSqOsZpaWOO+Izg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-ylIz2tdZO6CnnON7h8iTiw-1; Tue, 24 May 2022 02:10:13 -0400
X-MC-Unique: ylIz2tdZO6CnnON7h8iTiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 844DD1C05138;
        Tue, 24 May 2022 06:10:13 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51058C202D1;
        Tue, 24 May 2022 06:10:08 +0000 (UTC)
Date:   Tue, 24 May 2022 14:10:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <Yox2u7KUK6aNbtIh@T590>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
 <YowpjtLfZPld1H6T@T590>
 <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 09:02:39PM -0600, Keith Busch wrote:
> On Tue, May 24, 2022 at 08:40:46AM +0800, Ming Lei wrote:
> > On Mon, May 23, 2022 at 04:36:04PM -0600, Keith Busch wrote:
> > > On Wed, Apr 20, 2022 at 10:31:10PM +0800, Ming Lei wrote:
> > > > So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> > > > from userspace sync io interface, then block layer tries to poll until
> > > > the bio is completed. But the current implementation calls
> > > > blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> > > > timeout easily.
> > > 
> > > Wait a second. The task's current state is TASK_RUNNING when bio_poll() returns
> > > zero, so calling blk_io_schedule() isn't supposed to hang.
> > 
> > void __sched io_schedule(void)
> > {
> >         int token;
> > 
> >         token = io_schedule_prepare();
> >         schedule();
> >         io_schedule_finish(token);
> > }
> > 
> > But who can wakeup this task after scheduling out? There can't be irq
> > handler for POLLED request.
> 
> No one. If everything was working, the task state would be RUNNING, so it is
> immediately available to be scheduled back in.
>  
> > The hang can be triggered on nvme/qemu reliably:
> 
> And clearly it's not working, but for a different reason. The polling thread
> sees an invalid cookie and fails to set the task back to RUNNING, so yes, it
> will sleep with no waker in the current code.
> 
> We usually expect the cookie to be set inline with submit_bio(), but we're not
> guaranteed it won't be punted off to .run_work for a variety of reasons, so
> the thread writing the cookie may be racing with the reader.
> 
> This was fine before the bio polling support since the cookie was always
> returned with submit_bio() before that.
> 
> And I would like psync to continue working with polling. As great as io_uring
> is, it's just not as efficient @qd1.
> 
> Here's a bandaid, though I assume it'll break something...
> 
> ---
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ed1869a305c4..348136dc7ba9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1146,8 +1146,6 @@ void blk_mq_start_request(struct request *rq)
>  	if (blk_integrity_rq(rq) && req_op(rq) == REQ_OP_WRITE)
>  		q->integrity.profile->prepare_fn(rq);
>  #endif
> -	if (rq->bio && rq->bio->bi_opf & REQ_POLLED)
> -	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
>  }
>  EXPORT_SYMBOL(blk_mq_start_request);
>  
> @@ -2464,6 +2462,9 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
>  	WARN_ON_ONCE(err);
>  
>  	blk_account_io_start(rq);
> +
> +	if (rq->bio->bi_opf & REQ_POLLED)
> +	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
>  }

Yeah, this way may improve the situation, but still can't fix all,
what if the submitted bio is merged to another request in plug list?


Thanks,
Ming

