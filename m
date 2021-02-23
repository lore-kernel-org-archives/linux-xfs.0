Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495FCC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 14:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00AB64E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 14:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhBWOEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 09:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhBWODp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 09:03:45 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D673C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 06:02:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so8810138pfg.11
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 06:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lfVTTALn3EIbf3XW+Y1VR/dyHhiOJl4nkILGYE/qL5c=;
        b=FXREBcO6DfszNK9Nj8NAz9wa6BXYkb9fmRKNNw8A93tpbneZMsN9B6Hjq1W9R8xukM
         zkgYy2/iA71ZTAhuVYFjCgemMHczcNaV3P687uMS4hkKS/X9ug5XpT1V4twLrLxrGjmV
         9u6kZ20i42bI2riYk1/UdHIxpxGSjrua91d4y2F38Ztc6zFOXldM0fbjzYrTQ+ph/vm9
         aEUNvq5Ma8HHANtj+PArGErGfsFoXxoQvdp7AdVeYDmYt6NEXUfYqWbav3Jad11Uk5Hz
         4VrfIA3bb7nbREG70caCQArs7uzLzQ/K14xlSqW8SMNQ3gAy3nPAzU/xwe8BYZTQsv//
         3VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lfVTTALn3EIbf3XW+Y1VR/dyHhiOJl4nkILGYE/qL5c=;
        b=tuZ4Q9XwuH7hSAYJD4wqT5neafvTr0iiTPhimYfbDTxVGMnC7u2gftGcuyLWumAIpJ
         96Mucrcz7c+koObrHHpNrrM4tuZHfKQJmZqDfuWcojRgC00wV4scihdKnYLBx/OL73q/
         xNHELOC4H7Kee9CGVFa6CnNlPfgEb4jJCGptjRYyO9rfSAAORc7a+0O2BLibFB2xeQIG
         r7oWSF07hNkgB+LnCiQgDceOYZIPHIsqwm5wjW7nG26YfbzxT+KLTvqDG+KQ0aFKymRb
         ZmEkZyLND5TBZvDqS8rRe0ySyhl/X/gNTiCWdvCbtNf63FIvaqDArFu5wAjkLvS1/k+F
         ZgsQ==
X-Gm-Message-State: AOAM530Np2HmfTz6nphK9f7DWFR+1E/iMJ5z0pW1vTGDfR5yVRGtQvce
        b1cdRvAVv0yeQSH5BrabJEamWMCiYds=
X-Google-Smtp-Source: ABdhPJyWVZ/dq5Ylhmm3Mv1cVWMo/kgTv1EOOyA05g1o2xy9a59PoCxMQfYTwveDtvJTocaFugtSSg==
X-Received: by 2002:a05:6a00:12:b029:1ed:a619:6079 with SMTP id h18-20020a056a000012b02901eda6196079mr2419336pfk.60.1614088951464;
        Tue, 23 Feb 2021 06:02:31 -0800 (PST)
Received: from garuda ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id i7sm3486524pjs.1.2021.02.23.06.02.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 06:02:30 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-5-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: async blkdev cache flush
In-reply-to: <20210223033442.3267258-5-david@fromorbit.com>
Date:   Tue, 23 Feb 2021 19:32:28 +0530
Message-ID: <87eeh6naq3.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
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

Thanks for the detailed commit message explaining the reasoning behind the
requirement for an async cache flush primitive.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

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
> +	struct completion	*done)
> +{
> +	struct bio *bio;
> +
> +	bio = bio_alloc(GFP_NOFS, 0);
> +	bio_set_dev(bio, bdev);
> +	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> +	bio->bi_private = done;
> +        bio->bi_end_io = xfs_flush_bdev_async_endio;
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


--
chandan
