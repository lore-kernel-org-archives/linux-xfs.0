Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6C9C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C5A64F93
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 22:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhCHW1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:27:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhCHW06 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 17:26:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77C446525A;
        Mon,  8 Mar 2021 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615242418;
        bh=GULEj138zivwWiAhlWlVbpigJoW0i2bzLTgdj/fa/6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ed7B0OFcn6MoSGQ6tKq+yURLF5isWATa0nNfuNdyE4FeRPbT47pP3GQPcIEbgMdey
         4IHmWgj27gso0IYYVBDSKeDjlhPSybIxac8njVhSBXjSts+Zgs3G/8HWMYWB6qyfU2
         9Obp0b4t0Vj444Tc0yCAic9M+2LC6ySaM3xlQtbaak7xO89kRuR+LS1iqNampVc2Jb
         2N1mrEeyZx5KEtbROEXi17++QBt6CkvPM1Dbv6oheeynx63ROsuqbwGCZ54Gnwdsyb
         wW7IPbdT+YcELVc96d6vKK/OQxePuJ2ppOiquMUjhFtzDwIKOsTWE9BMPGZVQxkbLa
         U+sc6+tPe5kfw==
Date:   Mon, 8 Mar 2021 14:26:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
Message-ID: <20210308222657.GB3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The new checkpoint caceh flush mechanism requires us to issue an
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
> flush bio and to wait on it. THe block layer has no such primitives
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

static void?

> +xfs_flush_bdev_async_endio(
> +	struct bio	*bio)
> +{
> +	if (bio->bi_private)
> +		complete(bio->bi_private);

Er... when would bi_private be null?  We always set it in
xfs_flush_bdev_async, and nobody else uses this helper, right?

--D

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
