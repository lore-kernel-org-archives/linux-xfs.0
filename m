Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4979C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B4D60202
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhBXUwT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:52:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhBXUwT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 15:52:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AFA860202;
        Wed, 24 Feb 2021 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614199898;
        bh=UVu8j9HBiMigfcshhTmAIfKTnpNaNe4tF+HqCtXt3Rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TuCzT09r0/WmdzOKO9/n+FHDYoPIG7is6vivKYZLViMcPJ6v4i8KouWJv+rD5pZog
         AbDz3VlgJuIyl9cZKa4yYi4pUrWidVXWTt/hlEduzQwOR71QDvYA7EZKwFOjNLSuop
         NKEUzrnFLg+xd9nAGfxiWsEOlkuCsyaRlLjKQ278ICQbvtOWEkRfitvRMay6JuVl9F
         SoVoqmr5q35Ob/sWTqEMMZnX/LxXGS5TOVwI1eDR5dLzq7N5Sg02zAaR5OD6LqJveS
         o06l9gmQtzcPgcqnq03nFtXGX8gDbgeI51klvVMqiXBwrqqOxM/s0P7tU7l/CSXZXo
         eTP3nGFNMR30Q==
Date:   Wed, 24 Feb 2021 12:51:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: async blkdev cache flush
Message-ID: <20210224205137.GT7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:38PM +1100, Dave Chinner wrote:
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
>  fs/xfs/xfs_bio_io.c | 30 ++++++++++++++++++++++++++++++
>  fs/xfs/xfs_linux.h  |  1 +
>  2 files changed, 31 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 5abf653a45d4..d55420bc72b5 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -67,3 +67,33 @@ xfs_flush_bdev(
>  	blkdev_issue_flush(bdev, GFP_NOFS);
>  }
>  
> +void
> +xfs_flush_bdev_async_endio(
> +	struct bio	*bio)
> +{
> +	if (bio->bi_private)
> +		complete(bio->bi_private);
> +	bio_put(bio);
> +}
> +
> +/*
> + * Submit a request for an async cache flush to run. If the caller needs to wait
> + * for the flush completion at a later point in time, they must supply a
> + * valid completion. This will be signalled when the flush completes.
> + * The caller never sees the bio that is issued here.
> + */
> +void
> +xfs_flush_bdev_async(
> +	struct block_device	*bdev,

Not sure why this isn't a buftarg function, since (AFAICT) this is the
only caller in the ~30 patches you've sent to the list.  Is there
something else coming down the pipeline such that you only have a raw
block_device pointer?

> +	struct completion	*done)
> +{
> +	struct bio *bio;
> +
> +	bio = bio_alloc(GFP_NOFS, 0);
> +	bio_set_dev(bio, bdev);
> +	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> +	bio->bi_private = done;
> +        bio->bi_end_io = xfs_flush_bdev_async_endio;

Weird indent here.

--D

> +
> +	submit_bio(bio);
> +}
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index e94a2aeefee8..293ff2355e80 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -197,6 +197,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  		char *data, unsigned int op);
>  void xfs_flush_bdev(struct block_device *bdev);
> +void xfs_flush_bdev_async(struct block_device *bdev, struct completion *done);
>  
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> -- 
> 2.28.0
> 
