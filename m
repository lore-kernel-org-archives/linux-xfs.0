Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48820EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 22:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjGLWon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 18:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjGLWom (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 18:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FCC1720
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 15:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17D9A61934
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 22:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A651C433C7;
        Wed, 12 Jul 2023 22:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689201880;
        bh=Bb2hggdDuDm8PfNkthiUPVOBhkkMF1Y1kYK6iag07RU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBRzQkl1JzB1fsZ7oiraTBvFXWQaEReh4rRef21ZsdTtOHmXXe/rqlLgaDXfDEa8f
         caeohxS7+wPD4XFDS7y2jR9nf6Eebs0LN0nwCuVKbDo7+RyO1obrl3ZRIEcOL5F/0t
         N1CHu/apf43mbiUc8Jszm9XThL8I3KHKbKjK57v8p72z3FAFPqFZ1rFADDDSw0uIsq
         p+edCWUSi1rfhrwQX4x2i9hIUgPKKxRLJ8aVARoNbY7jquCeqsQvF0db/4kkeDgo19
         YJPfLoqsj2Wj5Zd2cBsJNmg1foeOLCQrqIbXjS1zXhTtLIFBGVki6lUucW4ee/xqgH
         BNeCsHHRXsLkg==
Date:   Wed, 12 Jul 2023 15:44:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 3/6] xfs: return maximum free size from
 xfs_rtany_summary()
Message-ID: <20230712224439.GW108251@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <d3d0aad4dbf6999c5fe07d89d63ea6cfabee3ff4.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3d0aad4dbf6999c5fe07d89d63ea6cfabee3ff4.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:13PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Instead of only returning whether there is any free space, return the
> maximum size, which is fast thanks to the previous commit. This will be
> used by two upcoming optimizations.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Assuming I understood the changes in the /last/ two patches, this seems
like a reasonable thing to pass upwards...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d3c76532d20e..ba7d42e0090f 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -50,7 +50,7 @@ xfs_rtany_summary(
>  	int		high,		/* high log2 extent size */
>  	xfs_rtblock_t	bbno,		/* bitmap block number */
>  	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
> -	int		*stat)		/* out: any good extents here? */
> +	int		*maxlog)	/* out: maximum log2 extent size free */
>  {
>  	int		error;		/* error value */
>  	int		log;		/* loop counter, log2 of ext. size */
> @@ -60,7 +60,7 @@ xfs_rtany_summary(
>  	if (mp->m_rsum_cache) {
>  		high = min(high, mp->m_rsum_cache[bbno] - 1);
>  		if (low > high) {
> -			*stat = 0;
> +			*maxlog = -1;
>  			return 0;
>  		}
>  	}
> @@ -80,14 +80,14 @@ xfs_rtany_summary(
>  		 * If there are any, return success.
>  		 */
>  		if (sum) {
> -			*stat = 1;
> +			*maxlog = log;
>  			goto out;
>  		}
>  	}
>  	/*
>  	 * Found nothing, return failure.
>  	 */
> -	*stat = 0;
> +	*maxlog = -1;
>  out:
>  	/* There were no extents at levels > log. */
>  	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
> @@ -427,7 +427,7 @@ xfs_rtallocate_extent_near(
>  	xfs_extlen_t	prod,		/* extent product factor */
>  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
>  {
> -	int		any;		/* any useful extents from summary */
> +	int		maxlog;		/* maximum useful extent from summary */
>  	xfs_rtblock_t	bbno;		/* bitmap block number */
>  	int		error;		/* error value */
>  	int		i;		/* bitmap block offset (loop control) */
> @@ -479,7 +479,7 @@ xfs_rtallocate_extent_near(
>  		 * starting in this bitmap block.
>  		 */
>  		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
> -			bbno + i, rtbufc, &any);
> +			bbno + i, rtbufc, &maxlog);
>  		if (error) {
>  			return error;
>  		}
> @@ -487,7 +487,7 @@ xfs_rtallocate_extent_near(
>  		 * If there are any useful extents starting here, try
>  		 * allocating one.
>  		 */
> -		if (any) {
> +		if (maxlog >= 0) {
>  			/*
>  			 * On the positive side of the starting location.
>  			 */
> @@ -527,7 +527,7 @@ xfs_rtallocate_extent_near(
>  					 */
>  					error = xfs_rtany_summary(mp, tp,
>  						log2len, mp->m_rsumlevels - 1,
> -						bbno + j, rtbufc, &any);
> +						bbno + j, rtbufc, &maxlog);
>  					if (error) {
>  						return error;
>  					}
> @@ -539,7 +539,7 @@ xfs_rtallocate_extent_near(
>  					 * extent given, we've already tried
>  					 * that allocation, don't do it again.
>  					 */
> -					if (any)
> +					if (maxlog >= 0)
>  						continue;
>  					error = xfs_rtallocate_extent_block(mp,
>  						tp, bbno + j, minlen, maxlen,
> -- 
> 2.41.0
> 
