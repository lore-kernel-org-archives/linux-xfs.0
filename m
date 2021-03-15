Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D95C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86B4C64E99
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCOOn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234198AbhCOOm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WIKpX6XEFcBX/9VOplVvyceHffEenQJ+IHxh9dFMM2g=;
        b=FVSiDx0v9WLUKq6Bl6dPhCQ8XNA7VAOdbuvRJKYzLgkngMtT64nKL0Q1LYq0vqIHTP4hm8
        tNSF19JbOaU/399TJn5FoXTQq5itHRFCMhzGiPnGq5jUgD9uY5Ibt8JuO3C28OatRwifaC
        //EttQgDIxWZhiNQoDJ+cgTmdto7/Ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-sKbvNjm0M0a9jug_tRL_9Q-1; Mon, 15 Mar 2021 10:42:55 -0400
X-MC-Unique: sKbvNjm0M0a9jug_tRL_9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A0AE107ACCA;
        Mon, 15 Mar 2021 14:42:54 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E12CE19D7C;
        Mon, 15 Mar 2021 14:42:53 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:42:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <YE9ybOGsxrr5qvDb@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-6-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new checkpoint caceh flush mechanism requires us to issue an

		     cache

> unconditional cache flush before we start a new checkpoint. We don't
> want to block for this if we can help it, and we have a fair chunk
> of CPU work to do between starting the checkpoint and issuing the
> first journal IO.
> 
> Hence it makes sense to amortise the latency cost of the cache flush
> by issuing it asynchronously and then waiting for it only when we
> need to issue the first IO in the transaction.
> 
> TO do this, we need async cache flush primitives to submit the cache

  To

> flush bio and to wait on it. THe block layer has no such primitives

			       The

> for filesystems, so roll our own for the moment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bio_io.c | 36 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_linux.h  |  2 ++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 17f36db2f792..668f8bd27b4a 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -9,6 +9,42 @@ static inline unsigned int bio_max_vecs(unsigned int count)
>  	return bio_max_segs(howmany(count, PAGE_SIZE));
>  }
>  
> +void
> +xfs_flush_bdev_async_endio(
> +	struct bio	*bio)
> +{
> +	if (bio->bi_private)
> +		complete(bio->bi_private);
> +}
> +
> +/*
> + * Submit a request for an async cache flush to run. If the request queue does
> + * not require flush operations, just skip it altogether. If the caller needsi

									   needs

> + * to wait for the flush completion at a later point in time, they must supply a
> + * valid completion. This will be signalled when the flush completes.  The
> + * caller never sees the bio that is issued here.
> + */
> +void
> +xfs_flush_bdev_async(
> +	struct bio		*bio,
> +	struct block_device	*bdev,
> +	struct completion	*done)
> +{
> +	struct request_queue	*q = bdev->bd_disk->queue;
> +

It seems rather odd to me to accept a bio here and then init it, but I
see this was explicitly changed from the previous version to avoid an
allocation (I'd rather see the bio in the CIL context or something
rather than dropped on the stack, but whatever).

> +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> +		complete(done);

The NULL or no NULL debate aside, this should be consistent with the
logic in the callback (IMO, just check for NULL here as Chandan
suggested). With that fixed up, one way or the other:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		return;
> +	}
> +
> +	bio_init(bio, NULL, 0);
> +	bio_set_dev(bio, bdev);
> +	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> +	bio->bi_private = done;
> +	bio->bi_end_io = xfs_flush_bdev_async_endio;
> +
> +	submit_bio(bio);
> +}
>  int
>  xfs_rw_bdev(
>  	struct block_device	*bdev,
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index af6be9b9ccdf..953d98bc4832 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -196,6 +196,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  		char *data, unsigned int op);
> +void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
> +		struct completion *done);
>  
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> -- 
> 2.28.0
> 

