Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751C3EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 22:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjGLWkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 18:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjGLWkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 18:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F25A1BF9
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 15:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05543618B3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 22:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5234EC433C7;
        Wed, 12 Jul 2023 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689201602;
        bh=m1aCE91DQMW3W62Q5U31rzNq2zG0jBvwLcPPaVaAl1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJbz8ro0OGktaZH555iWbQRn4CadBdn3T3kUwTJ7R2owoQeshwwsO+Wkbn36/jf99
         RPYQHLRyJt5aCEDj9QuYbUP/QXqrH96yF+3ceSUAHwFUygcnawqsVlnxwuhz8+erPR
         ndyRf8JpyezzHg6gBoSiLS+utOxwXJwlmLDy/VdWfRFgWD2/08o3dIhF8eMUCy1FUG
         N2A8JZ0yOZvp6Vyol/+/wGCQxhUcUlXKZL6JEuFRmMuNiNKyeLFjT54zd2jvD+XvnU
         uCNnoPi8eJsUy5bFirkMX3yok+XFdgQQGshDh/ZtVRjo1FtcvHl+Hrm6kUAEgFl4NM
         ecH1gdYVACqCg==
Date:   Wed, 12 Jul 2023 15:40:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 2/6] xfs: invert the realtime summary cache
Message-ID: <20230712224001.GV108251@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <e3ae5bfc7cd4b640e83a25f001169d4ae50d797a.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ae5bfc7cd4b640e83a25f001169d4ae50d797a.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:12PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In commit 355e3532132b ("xfs: cache minimum realtime summary level"), I
> added a cache of the minimum level of the realtime summary that has any
> free extents. However, it turns out that the _maximum_ level is more
> useful for upcoming optimizations, and basically equivalent for the
> existing usage. So, let's change the meaning of the cache to be the
> maximum level + 1, or 0 if there are no free extents.

Hmm.  If I'm reading xfs_rtmodify_summary_int right, m_rsum_cache[b] now
tells us the maximum log2(length) of the free extents starting in
rtbitmap block b?

IOWs, let's say the cache contents are:

{2, 3, 2, 15, 8}

Someone asks for a 400rtx (realtime extent) allocation, so we want to
find a free space of at least magnitude floor(log2(400)) == 8.

The cache tells us that there aren't any free extents longer than 2^1
blocks in rtbitmap blocks 0 and 2; longer than 2^2 blocks in rtbmp block
1; longer than 2^7 blocks in rtbmp block 4; nor longer than 2^14 blocks
in rtbmp block 3?

From the cache contents, we should therefore examine rtbitmap block 3.

If the cache contents were instead:

{2, 3, 2, 8, 8}

Then we instead might scan rtbitmap blocks 3 and 4 for the longest
allocation that we can get?  Looking back at the original commit, that
seems to make more sense to me...

> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |  6 +++---
>  fs/xfs/xfs_mount.h           |  6 +++---
>  fs/xfs/xfs_rtalloc.c         | 31 +++++++++++++++++++------------
>  3 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 1a832c9a412f..d9493f64adfc 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -503,10 +503,10 @@ xfs_rtmodify_summary_int(
>  
>  		*sp += delta;
>  		if (mp->m_rsum_cache) {
> -			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
> -				mp->m_rsum_cache[bbno]++;
> -			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
> +			if (*sp == 0 && log + 1 == mp->m_rsum_cache[bbno])
>  				mp->m_rsum_cache[bbno] = log;
> +			if (*sp != 0 && log >= mp->m_rsum_cache[bbno])
> +				mp->m_rsum_cache[bbno] = log + 1;
>  		}
>  		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 6c09f89534d3..964541c36730 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -103,9 +103,9 @@ typedef struct xfs_mount {
>  
>  	/*
>  	 * Optional cache of rt summary level per bitmap block with the
> -	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> -	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
> -	 * inode lock.
> +	 * invariant that m_rsum_cache[bbno] > the maximum i for which
> +	 * rsum[i][bbno] != 0, or 0 if rsum[i][bbno] == 0 for all i.
> +	 * Reads and writes are serialized by the rsumip inode lock.
>  	 */
>  	uint8_t			*m_rsum_cache;
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 61ef13286654..d3c76532d20e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -56,14 +56,19 @@ xfs_rtany_summary(
>  	int		log;		/* loop counter, log2 of ext. size */
>  	xfs_suminfo_t	sum;		/* summary data */
>  
> -	/* There are no extents at levels < m_rsum_cache[bbno]. */
> -	if (mp->m_rsum_cache && low < mp->m_rsum_cache[bbno])
> -		low = mp->m_rsum_cache[bbno];
> +	/* There are no extents at levels >= m_rsum_cache[bbno]. */
> +	if (mp->m_rsum_cache) {
> +		high = min(high, mp->m_rsum_cache[bbno] - 1);
> +		if (low > high) {
> +			*stat = 0;
> +			return 0;
> +		}
> +	}
>  
>  	/*
>  	 * Loop over logs of extent sizes.
>  	 */
> -	for (log = low; log <= high; log++) {
> +	for (log = high; log >= low; log--) {
>  		/*
>  		 * Get one summary datum.
>  		 */
> @@ -84,9 +89,9 @@ xfs_rtany_summary(
>  	 */
>  	*stat = 0;
>  out:
> -	/* There were no extents at levels < log. */
> -	if (mp->m_rsum_cache && log > mp->m_rsum_cache[bbno])
> -		mp->m_rsum_cache[bbno] = log;
> +	/* There were no extents at levels > log. */
> +	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
> +		mp->m_rsum_cache[bbno] = log + 1;
>  	return 0;
>  }
>  
> @@ -878,12 +883,14 @@ xfs_alloc_rsum_cache(
>  	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
>  {
>  	/*
> -	 * The rsum cache is initialized to all zeroes, which is trivially a
> -	 * lower bound on the minimum level with any free extents. We can
> -	 * continue without the cache if it couldn't be allocated.
> +	 * The rsum cache is initialized to the maximum value, which is
> +	 * trivially an upper bound on the maximum level with any free extents.
> +	 * We can continue without the cache if it couldn't be allocated.
>  	 */
> -	mp->m_rsum_cache = kvzalloc(rbmblocks, GFP_KERNEL);
> -	if (!mp->m_rsum_cache)
> +	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
> +	if (mp->m_rsum_cache)
> +		memset(mp->m_rsum_cache, -1, rbmblocks);
> +	else
>  		xfs_warn(mp, "could not allocate realtime summary cache");
>  }
>  
> -- 
> 2.41.0
> 
