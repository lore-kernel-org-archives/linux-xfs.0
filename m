Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FCFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 11:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354123AbiDULvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiDULvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 07:51:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 213E727B0F
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 04:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650541743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJj2EnC4G6QPvmNYS+A3b06EQY18U3AZjlnPkgR7O5Q=;
        b=AFMsAVduFPfYOFziyHYoffUpxByvKqbk7/i+MU+PLYY6paDnUQrAjJeEpXQ2la8uxx5Cfy
        5ZJBpGqqRLmVHyO65Kc2N5tVaOckxwXgb/68+E+IsywBpNKBahFp8n9pxkyJZmMBbTLlJP
        nQ0pDjgUuXa0evWA4ohYn2ArYaogDk0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-tyI07rgZMA2EVXOdeUzbtg-1; Thu, 21 Apr 2022 07:49:02 -0400
X-MC-Unique: tyI07rgZMA2EVXOdeUzbtg-1
Received: by mail-pj1-f72.google.com with SMTP id t24-20020a17090a449800b001d2d6e740c3so4538237pjg.9
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 04:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJj2EnC4G6QPvmNYS+A3b06EQY18U3AZjlnPkgR7O5Q=;
        b=1U9DX64p9CWVWQ91x+mEpcRHBoZccAMqCf6AhLG3ZKGpllT+tetWvkGNIlj59Jahtc
         2G1AYbRaloSlmpps+uXEF4zSu3kLEEKBawz+0004XpcJ0KoeKT9JPS6xqbBsNxQeg62x
         MZaK0LgB0x5awFGNydiUzaBRkt618YrkA+xNPhcmSxv7ZjaRxgdURm/wJWqwTjtk3J+z
         jh/8OJyiybTX5TuCOXlP48s616BdBhMJZ8dptC+xmBgXOv8YiimJQYwnDzVKQGRVII84
         J0bqRAWVI7XzIeqjZYCwbSnH/0zsdC8r9pTPn1SymzugoPqZYS8M2ih8upFosMwa98+y
         RlLQ==
X-Gm-Message-State: AOAM532vem71laP15aPmR4Ud6WJgPYBLpaJleQL4BETiboTb2jeWm9wH
        MSfc6BuCesOW7J+A4VNSCEMxxub4IYatqGBasU5FDo0vS3hXPgAGPiJGvThY7uZwKcqzUf0vwGf
        57ODRAHwKqBWGU78GQhnZmhTNxZhQbQHM+46t
X-Received: by 2002:a17:90b:17ce:b0:1d2:75cc:d6c7 with SMTP id me14-20020a17090b17ce00b001d275ccd6c7mr10050153pjb.162.1650541741644;
        Thu, 21 Apr 2022 04:49:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfYLhbaJDyRd/mNR2y/0DfkcUWAGEN4FhbGiNUEYUQIYwH7fWZzRXjXArdBQcGCG2LWNR9jzUc8wImDdal8lo=
X-Received: by 2002:a17:90b:17ce:b0:1d2:75cc:d6c7 with SMTP id
 me14-20020a17090b17ce00b001d275ccd6c7mr10050126pjb.162.1650541741325; Thu, 21
 Apr 2022 04:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220420143110.2679002-1-ming.lei@redhat.com>
In-Reply-To: <20220420143110.2679002-1-ming.lei@redhat.com>
From:   Changhui Zhong <czhong@redhat.com>
Date:   Thu, 21 Apr 2022 19:48:50 +0800
Message-ID: <CAGVVp+XFhe28q2vYDxWJFw4=o=PvyCrFjuBfj1dwmhfpXisuNg@mail.gmail.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test pass with this patch,
Thanks Ming and Christoph !

Tested-by: Changhui Zhong <czhong@redhat.com>



On Wed, Apr 20, 2022 at 10:31 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> from userspace sync io interface, then block layer tries to poll until
> the bio is completed. But the current implementation calls
> blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> timeout easily.
>
> But looks no one reports this kind of issue, which should have been
> triggered in normal io poll sanity test or blktests block/007 as
> observed by Changhui, that means it is very likely that no one uses it
> or no one cares it.
>
> Also after io_uring is invented, io poll for sync dio becomes legacy
> interface.
>
> So ignore RWF_HIPRI hint for sync dio.
>
> CC: linux-mm@kvack.org
> Cc: linux-xfs@vger.kernel.org
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
>         - avoid to break io_uring async polling as pointed by Chritoph
>
>  block/fops.c         | 22 +---------------------
>  fs/iomap/direct-io.c |  7 +++----
>  mm/page_io.c         |  4 +---
>  3 files changed, 5 insertions(+), 28 deletions(-)
>
> diff --git a/block/fops.c b/block/fops.c
> index e3643362c244..b9b83030e0df 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -44,14 +44,6 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>
>  #define DIO_INLINE_BIO_VECS 4
>
> -static void blkdev_bio_end_io_simple(struct bio *bio)
> -{
> -       struct task_struct *waiter = bio->bi_private;
> -
> -       WRITE_ONCE(bio->bi_private, NULL);
> -       blk_wake_io_task(waiter);
> -}
> -
>  static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>                 struct iov_iter *iter, unsigned int nr_pages)
>  {
> @@ -83,8 +75,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>                 bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
>         }
>         bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
> -       bio.bi_private = current;
> -       bio.bi_end_io = blkdev_bio_end_io_simple;
>         bio.bi_ioprio = iocb->ki_ioprio;
>
>         ret = bio_iov_iter_get_pages(&bio, iter);
> @@ -97,18 +87,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>
>         if (iocb->ki_flags & IOCB_NOWAIT)
>                 bio.bi_opf |= REQ_NOWAIT;
> -       if (iocb->ki_flags & IOCB_HIPRI)
> -               bio_set_polled(&bio, iocb);
>
> -       submit_bio(&bio);
> -       for (;;) {
> -               set_current_state(TASK_UNINTERRUPTIBLE);
> -               if (!READ_ONCE(bio.bi_private))
> -                       break;
> -               if (!(iocb->ki_flags & IOCB_HIPRI) || !bio_poll(&bio, NULL, 0))
> -                       blk_io_schedule();
> -       }
> -       __set_current_state(TASK_RUNNING);
> +       submit_bio_wait(&bio);
>
>         bio_release_pages(&bio, should_dirty);
>         if (unlikely(bio.bi_status))
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 62da020d02a1..80f9b047aa1b 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -56,7 +56,8 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>  {
>         atomic_inc(&dio->ref);
>
> -       if (dio->iocb->ki_flags & IOCB_HIPRI) {
> +       /* Sync dio can't be polled reliably */
> +       if ((dio->iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(dio->iocb)) {
>                 bio_set_polled(bio, dio->iocb);
>                 dio->submit.poll_bio = bio;
>         }
> @@ -653,9 +654,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>                         if (!READ_ONCE(dio->submit.waiter))
>                                 break;
>
> -                       if (!dio->submit.poll_bio ||
> -                           !bio_poll(dio->submit.poll_bio, NULL, 0))
> -                               blk_io_schedule();
> +                       blk_io_schedule();
>                 }
>                 __set_current_state(TASK_RUNNING);
>         }
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 89fbf3cae30f..3fbdab6a940e 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -360,7 +360,6 @@ int swap_readpage(struct page *page, bool synchronous)
>          * attempt to access it in the page fault retry time check.
>          */
>         if (synchronous) {
> -               bio->bi_opf |= REQ_POLLED;
>                 get_task_struct(current);
>                 bio->bi_private = current;
>         }
> @@ -372,8 +371,7 @@ int swap_readpage(struct page *page, bool synchronous)
>                 if (!READ_ONCE(bio->bi_private))
>                         break;
>
> -               if (!bio_poll(bio, NULL, 0))
> -                       blk_io_schedule();
> +               blk_io_schedule();
>         }
>         __set_current_state(TASK_RUNNING);
>         bio_put(bio);
> --
> 2.31.1

