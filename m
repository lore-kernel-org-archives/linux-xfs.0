Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FA9C0015E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Jul 2023 22:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjGRW4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGRW4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 18:56:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978E8E0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 15:56:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so148609a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 15:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689720977; x=1692312977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldfZ6lOKERdJNpkH9/Fwa0WYhwOT+qCrSUEcI/k8P5M=;
        b=cq5tD8GHeHgz8KfZoA8FCEw3xL9g7hwH7WkD4/bOCdavBVBakfd80i+P5gvmZSm/Ai
         FEYRBWlcb8qjO12GLj+2s87FkJUsPhqwqrA5EpFEd+r+eUcxX7xaHQUe8ryXgxBeC+xk
         7BtD9Qhdh67zbcWk4Fomyow656yPnlkRweBhsVDwHZkjI3CotxvBt5KjFydAjerGn0xX
         jGiGASSe9wOErxeuoQilk9Wag3bFH0kpTAktRrODGau4wbqv3H5pORdbgHSiCDFeh8H5
         GhXQ+rY0QWVGyWS3F1GBMzMVZ+e/afbckG0uTiVVpppDWX09G2eZ+jRnGY7vKgkltVfi
         KTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689720977; x=1692312977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldfZ6lOKERdJNpkH9/Fwa0WYhwOT+qCrSUEcI/k8P5M=;
        b=M0vGarmIbmIr+l+iuGGCdwayWzZm3OueiG9Ma4dsvBgp9s2yVK3rL544PeHA/es14x
         K1jrFzY5YiWWjP2Lkwutpk/Ti6oFEvc52APPaD+KnVq0UdgGuOQflAZ2fjf2cDyeV02Q
         /KYq4NVC1aN+sFnzhth3DrOPEvbZsvm1+1W77H6uDXJCidkP1xHypKMGQYEuhZDJm5I3
         9ZDZZX0H9YMN/QB4i7CF7UA8ZsUNNk9vyAOj1Q+mJ2quJ+ukZRrB6Q7SWSNeGWmJaMDN
         oSabYFQBOdWE8lORy7OHJsQ5hlv1vT6ETt8tpRVd6JoS956B8OVYP1Dg+CwjAssf/evG
         YhCQ==
X-Gm-Message-State: ABy/qLaZWc3ZCdSe0igbcuyu4ZhNXdxqx2YtQmolhmPH8scbyOMHg7o3
        glJrn2OqkmlYszUkqvcTeKrz6g==
X-Google-Smtp-Source: APBJJlG2vp50w8Tx86+ab2QE7UkhEW2kMRnEbpWTZ8QP6Scw8E1ddFUjtGGjfesKWtqoz99uTGWJ3w==
X-Received: by 2002:a17:90a:17ab:b0:265:d7ac:55b1 with SMTP id q40-20020a17090a17ab00b00265d7ac55b1mr618906pja.4.1689720976911;
        Tue, 18 Jul 2023 15:56:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id u63-20020a17090a51c500b00256a4d59bfasm92243pjh.23.2023.07.18.15.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 15:56:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qLtc5-007jn1-0w;
        Wed, 19 Jul 2023 08:56:13 +1000
Date:   Wed, 19 Jul 2023 08:56:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 1/5] iomap: simplify logic for when a dio can get
 completed inline
Message-ID: <ZLcYjW6vJhEXy7hU@dread.disaster.area>
References: <20230718194920.1472184-1-axboe@kernel.dk>
 <20230718194920.1472184-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718194920.1472184-3-axboe@kernel.dk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 01:49:16PM -0600, Jens Axboe wrote:
> Currently iomap gates this on !IOMAP_DIO_WRITE, but this isn't entirely
> accurate. Some writes can complete just fine inline. One such example is
> polled IO, where the completion always happens in task context.
> 
> Add IOMAP_DIO_INLINE_COMP which tells the completion side if we can
> complete this dio inline, or if it needs punting to a workqueue. We set
> this flag by default for any dio, and turn it off for unwritten extents
> or blocks that require a sync at completion time.

Ignoring the O_DSYNC case (I'll get to that at the end), this is
still wrong - it misses extending writes that need to change file
size at IO completion. For some filesystems, file extension at IO
completion has the same constraints as unwritten extent conversion
(i.e. requires locking and transactions), but the iomap
infrastructure has no idea whether the filesystem performing the IO
requires this or not.

i.e. if iomap always punts unwritten extent IO to a workqueue, we
also have to punt extending writes to a workqueue.  Fundamentally,
the iomap code itself cannot make a correct determination of whether
IO completion of any specific write IO requires completion in task
context.

Only the filesystem knows that,

However, the filesystem knows if the IO is going to need IO
completion processing at submission time. It tells iomap that it
needs completion processing via the IOMAP_F_DIRTY flag. This allows
filesystems to determine what IOs iomap can consider as "writes that
don't need filesystem completion processing".

With this flag, iomap can optimise the IO appropriately. We can use
REQ_FUA for O_DSYNC writes if IOMAP_F_DIRTY is not set. We can do
inline completion if IOMAP_F_DIRTY is not set. But if IOMAP_F_DIRTY
is set, the filesystem needs to run it's own completion processing,
and so iomap cannot run that write with an inline completion.

> Gate the inline completion on whether we're in a task or not as well.
> This will always be true for polled IO, but for IRQ driven IO, the
> completion context may not allow for inline completions.

Again, context does not matter for pure overwrites - we can complete
them inline regardless of completion context. The task context only
matters when the filesystem needs to do completion work, and we've
already established that we are not doing inline completion
for polled IO for unwritten, O_DSYNC or extending file writes.

IOWs, we already avoid polled completions for all the situations
where IOMAP_F_DIRTY is set by the filesystem to indicate the
operation is not a pure overwrite....


> ---
>  fs/iomap/direct-io.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index ea3b868c8355..6fa77094cf0a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -20,6 +20,7 @@
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
>   */
> +#define IOMAP_DIO_INLINE_COMP	(1 << 27)
>  #define IOMAP_DIO_WRITE_FUA	(1 << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1 << 29)
>  #define IOMAP_DIO_WRITE		(1 << 30)
> @@ -161,15 +162,15 @@ void iomap_dio_bio_end_io(struct bio *bio)
>  			struct task_struct *waiter = dio->submit.waiter;
>  			WRITE_ONCE(dio->submit.waiter, NULL);
>  			blk_wake_io_task(waiter);
> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
> +		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {

Regardless of whether the code is correct or not, this needs a
comment explaining what problem the in_task() check is working
around...

> +			WRITE_ONCE(dio->iocb->private, NULL);
> +			iomap_dio_complete_work(&dio->aio.work);
> +		} else {
>  			struct inode *inode = file_inode(dio->iocb->ki_filp);
>  
>  			WRITE_ONCE(dio->iocb->private, NULL);
>  			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>  			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> -		} else {
> -			WRITE_ONCE(dio->iocb->private, NULL);
> -			iomap_dio_complete_work(&dio->aio.work);
>  		}
>  	}
>  
> @@ -244,6 +245,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  
>  	if (iomap->type == IOMAP_UNWRITTEN) {
>  		dio->flags |= IOMAP_DIO_UNWRITTEN;
> +		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
>  		need_zeroout = true;
>  	}
>  
> @@ -500,7 +502,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	dio->i_size = i_size_read(inode);
>  	dio->dops = dops;
>  	dio->error = 0;
> -	dio->flags = 0;
> +	/* default to inline completion, turned off when not supported */
> +	dio->flags = IOMAP_DIO_INLINE_COMP;
>  	dio->done_before = done_before;

I think this is poorly coded. If we get the clearing logic
wrong (as is the case in this patch) then bad things will
happen when we run inline completion in an irq context when
the filesystem needs to run a transaction. e.g. file extension.

It looks to me like you hacked around this "default is wrong" case
with the "in_task()" check in completion, but given that check is
completely undocumented....

>  	dio->submit.iter = iter;
> @@ -535,6 +538,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		/* for data sync or sync, we need sync completion processing */
>  		if (iocb_is_dsync(iocb)) {
>  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;

This is looks wrong, too. We set IOMAP_DIO_WRITE_FUA ca couple of
lines later, and during bio submission we check if REQ_FUA can be
used if IOMAP_F_DIRTY is not set. If all the bios we submit use
REQ_FUA, then we clear IOMAP_DIO_NEED_SYNC before we drop the dio
submission reference.

For such a REQ_FUA bio chains, we can now safely do inline
completion because we don't run generic_write_sync() in IO
completion now. The filesystem does not need to perform blocking or
IO operations in completion, either, so these IOs can be completed
in line like any other pure overwrite DIO....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
