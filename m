Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78439C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7D5613AD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 23:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhETXyu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 19:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233104AbhETXyt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 19:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B989B6101D;
        Thu, 20 May 2021 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621554807;
        bh=0R5pd34o0PSScKYxrGTS8qy89L85sD6HbPhozntwvks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kn8+rJruiJIFCEOi/4W6Jn6NC0D6TQyGzHbTz9Bo7sAd/dHAnlqnF1BQGacl4tKNJ
         K6P82YJhTb6JbY9b8JAGrjsIPalkelKboVqXvXlmH1aGOHQd1Z8bUOmkvpg0PQFAiH
         qL+xJlXqo9mL7OvBVD7nF9C23Pq9E5lVEGcAxZerxHLzQ4s8n9I1WB8iWIJ1QNq5QP
         vGRyDcVIx+t/MmSjqJPBEbsYDFHnpfAJFu88hSRmNKimk21sTi3bNqYAGomstHXIKz
         8dIAOsCYuK2FDlVbQAyO64nJoy2ZeFQRYUhNdTZBJDWUOG7xkrzpcF9eJMPbUxRJxH
         JIxjbQz+hM0CQ==
Date:   Thu, 20 May 2021 16:53:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/39] xfs: async blkdev cache flush
Message-ID: <20210520235327.GE9675@magnolia>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:12:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new checkpoint cache flush mechanism requires us to issue an
> unconditional cache flush before we start a new checkpoint. We don't
> want to block for this if we can help it, and we have a fair chunk
> of CPU work to do between starting the checkpoint and issuing the
> first journal IO.
> 
> Hence it makes sense to amortise the latency cost of the cache flush
> by issuing it asynchronously and then waiting for it only when we
> need to issue the first IO in the transaction.
> 
> To do this, we need async cache flush primitives to submit the cache
> flush bio and to wait on it. The block layer has no such primitives
> for filesystems, so roll our own for the moment.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bio_io.c | 35 +++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_linux.h  |  2 ++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 17f36db2f792..de727532e137 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -9,6 +9,41 @@ static inline unsigned int bio_max_vecs(unsigned int count)
>  	return bio_max_segs(howmany(count, PAGE_SIZE));
>  }
>  
> +static void
> +xfs_flush_bdev_async_endio(
> +	struct bio	*bio)
> +{
> +	complete(bio->bi_private);
> +}
> +
> +/*
> + * Submit a request for an async cache flush to run. If the request queue does
> + * not require flush operations, just skip it altogether. If the caller needsi
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
> +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> +		complete(done);
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
> index 7688663b9773..c174262a074e 100644
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
> 2.31.1
> 
