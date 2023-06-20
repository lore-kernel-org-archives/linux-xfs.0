Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9D6EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 03:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjFTDYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 23:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjFTDYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 23:24:15 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECD6E61
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 20:24:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5440e98616cso3479665a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 20:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687231454; x=1689823454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ryIpKTUyW3nsWUvjswuSb+m975AWMUY4La5hm9WNIs=;
        b=TlWVH3lSWUt/qF8c1emfUo7rWwqdvJhbzYxfdbGMH2avhCPXhXcpmWMclAdfYAtCWv
         0pYs+yliIs3njaZbQfP/VIeQYG4IEsjAPgWYNfIChiUdxu+X5lzInR/dysj89XTG9S/R
         gNd0SfK5sDvBD+FZTDBzUTHRvr+WytqScVjZlIYiT1H25nEustv1L/kDQb9er3nIO1Ch
         usmPEd4ePQBrk41ALZCaBj1a+1W68vXC4CQfavi7Zdz1l0OMP12XxlLmsbeg+8aYBff1
         w/qCtaSsvsaDjxdLPcEygYu2RgzGQnVCSiN7VAnabOQ66PoYacK7kcVpgQiuW+xwOSug
         mfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687231454; x=1689823454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ryIpKTUyW3nsWUvjswuSb+m975AWMUY4La5hm9WNIs=;
        b=NtFzGqB3gYz1WXe6VeDowRAB8ZoxWZ3C5QkyXAqpV3Pw9xWCBMpbCbUrCepcKLG4yE
         JwS1Ln993m6rrycjIjE5+K7e4askQuMsOcZ4GUnW1Sz55cqKb4PNeO5LV+C7W608gYf9
         WFJyRkGtp6xQRZpF3Xf2M3Sd/4OS1s2SEW98B7ZW9C+RYR/jYUpzcNBU8h2ddGIEbtLr
         +0h8ZMNE9kt2fe+vdzCkEXkZb584gb7aAsbtcXU0dzkZkN06PWt6uXaie6Tp4/df0Cof
         yiuloxy0wXbCz52jQRjA3b3UcLHVkUDUu7Eeo1RY/CmPAA/Vv7alUN251uzWNaXCZR31
         s3rw==
X-Gm-Message-State: AC+VfDzVU7y1ZbpX0o/ODT+fhBO00Sm6x52/a7YgoKHj3Aw+2RP6yICA
        /NFI+6tmX6OCcmDJYXALyGW1o+/YXAB4CvZZdNQ=
X-Google-Smtp-Source: ACHHUZ4oeDEFbaEncXQF4SWjhCFt/YqYla3eC7XxkZDqdTcoP4se5QY7V7p6H1D4ZVU4CMNSpeN5zA==
X-Received: by 2002:a17:903:2449:b0:1b5:674d:2aa5 with SMTP id l9-20020a170903244900b001b5674d2aa5mr6731299pls.13.1687231453646;
        Mon, 19 Jun 2023 20:24:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id o4-20020a1709026b0400b001b176d96da0sm490641plk.78.2023.06.19.20.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 20:24:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBRyU-00DtmD-2Y;
        Tue, 20 Jun 2023 13:24:10 +1000
Date:   Tue, 20 Jun 2023 13:24:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <ZJEb2nSpIWoiKm6a@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> After an online repair, we need to invalidate buffers representing the
> blocks from the old metadata that we're replacing.  It's possible that
> parts of a tree that were previously cached in memory are no longer
> accessible due to media failure or other corruption on interior nodes,
> so repair figures out the old blocks from the reverse mapping data and
> scans the buffer cache directly.
> 
> Unfortunately, the current buffer cache code triggers asserts if the
> rhashtable lookup finds a non-stale buffer of a different length than
> the key we searched for.  For regular operation this is desirable, but
> for this repair procedure, we don't care since we're going to forcibly
> stale the buffer anyway.  Add an internal lookup flag to avoid the
> assert.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/reap.c |    2 +-
>  fs/xfs/xfs_buf.c    |    5 ++++-
>  fs/xfs/xfs_buf.h    |   10 ++++++++++
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index 30e61315feb0..ca75c22481d2 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -149,7 +149,7 @@ xrep_block_reap_binval(
>  	 */
>  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
>  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);

Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
nothing about what the incore lookup is actually doing. The actual
lookup action that is being performed is "find any match" rather
than "find exact match". XBF_ANY_MATCH would be a better name, IMO.

>  	if (error)
>  		return;
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15d1e5a7c2d3..b31e6d09a056 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
>  		 * reallocating a busy extent. Skip this buffer and
>  		 * continue searching for an exact match.
>  		 */
> -		ASSERT(bp->b_flags & XBF_STALE);
> +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> +			ASSERT(bp->b_flags & XBF_STALE);

And this becomes XBM_ANY_MATCH, too.

>  		return 1;
>  	}
>  	return 0;
> @@ -682,6 +683,8 @@ xfs_buf_get_map(
>  	int			error;
>  	int			i;
>  
> +	if (flags & XBF_BCACHE_SCAN)
> +		cmap.bm_flags |= XBM_IGNORE_LENGTH_MISMATCH;
>  	for (i = 0; i < nmaps; i++)
>  		cmap.bm_len += map[i].bm_len;
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 549c60942208..d6e8c3bab9f6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -44,6 +44,11 @@ struct xfs_buf;
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
>  /* flags used only as arguments to access routines */
> +/*
> + * We're scanning the buffer cache; do not warn about lookup mismatches.

The code using the flag isn't doing this - it's trying to invalidate
any existing buffer at the location given. It simply wants any
buffer at that address to be returned...

> + * Only online repair should use this.
> + */
> +#define XBF_BCACHE_SCAN	 (1u << 28)
>  #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
>  #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
>  #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
> @@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> +	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
>  	{ XBF_INCORE,		"INCORE" }, \
>  	{ XBF_TRYLOCK,		"TRYLOCK" }, \
>  	{ XBF_UNMAPPED,		"UNMAPPED" }
> @@ -114,8 +120,12 @@ typedef struct xfs_buftarg {
>  struct xfs_buf_map {
>  	xfs_daddr_t		bm_bn;	/* block number for I/O */
>  	int			bm_len;	/* size of I/O */
> +	unsigned int		bm_flags;
>  };
>  
> +/* Don't complain about live buffers with the wrong length during lookup. */
> +#define XBM_IGNORE_LENGTH_MISMATCH	(1U << 0)

Which makes me wonder now: can we have two cached buffers at the
same address with different lengths during a repair?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
