Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BD6C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD80651B6
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCHJsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 04:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhCHJsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 04:48:13 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B11C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  8 Mar 2021 01:48:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id jx13so2720761pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 08 Mar 2021 01:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=EJEiZwskl1oeQxzC8j2hzFHWQa7s1JdH4gHGHZ1eoVs=;
        b=rB25GVsZyXOgyocMYXj4qIbCdstycCGU2I2rRkgMybRF4mIIYuV6R7FzGuKdxnADEX
         DiK8TwX36OG1GeNsqdFITcrdbGx6kND/VpLofngnlQBD53RJfxwH6iw8FdBOMj28P9R9
         IfuyP+RbxxBoSWdYecEulJug9ZSrmXYBafNWd5dPker5MqT7eaDBhDsc4cxmds2i/Fnk
         Nz+tAiY9cXg8vmlS8Zk01OVhUaKxHp/VB5vsorI0DLSYe4I25V7SYa9mlque1aXXWfKb
         KSVQ8/iOw4STafAColZxpQ6/88T8wqaAimlthgIwvFdY7FYB83dzxMGK2sAF8LsjDl3U
         xNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=EJEiZwskl1oeQxzC8j2hzFHWQa7s1JdH4gHGHZ1eoVs=;
        b=RUMDXJ2aeQBFZ8/plASI/SaE1n/Z9ED/zbaIMTMsrzLrO++ZpFtEofEVOpuNO3pPMH
         RSk6AcXhrrtZUvu3d+0EfFi2SB4LQKukBt9oOZamM/UeNPk0z53upnUSNoylRNSjWRbl
         FHAW0ynUp/Em+IMI0k95tqLvpIco6WqOMvI10TFJhBuVFupf3WW4J9N41F69orL3oWcH
         LFUbaG9RI8dGCwIOd2jfWqR6E+z/G7+mcThfaNp1VUlgHO4pAZ6Qx7HWYmBqYFh/kIge
         kkxArY+mXvz0YM9uNL6hVBA0+TPTlt/JU94I+ecCd6F8Ogf/8cd+TqSfn9G190E6oLN7
         7eNA==
X-Gm-Message-State: AOAM531w0NCHPtdLw5cLftXy+6yvtyopJPGb4wqDDFhKXG73H3UbwKOv
        KA20TwM7qLVdukZvlbYKGwGs3+Y0Swk=
X-Google-Smtp-Source: ABdhPJxGghF7mUIf735wAJlX5FEJgwdn2dmc7YFhCjm6K8VGckYy+4KW0x62yg3izyV6dCE2aneK5w==
X-Received: by 2002:a17:902:e8d3:b029:e3:cb77:2dde with SMTP id v19-20020a170902e8d3b02900e3cb772ddemr20094732plg.78.1615196892606;
        Mon, 08 Mar 2021 01:48:12 -0800 (PST)
Received: from garuda ([122.167.156.41])
        by smtp.gmail.com with ESMTPSA id b9sm9232518pgn.42.2021.03.08.01.48.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 01:48:12 -0800 (PST)
References: <20210305051143.182133-1-david@fromorbit.com> <20210305051143.182133-6-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/45] xfs: async blkdev cache flush
In-reply-to: <20210305051143.182133-6-david@fromorbit.com>
Date:   Mon, 08 Mar 2021 15:18:09 +0530
Message-ID: <87eegq3rja.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Mar 2021 at 10:41, Dave Chinner wrote:
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

complete() should be invoked only when "done" has a non-NULL value.

> +		return;
> +	}

-- 
chandan
