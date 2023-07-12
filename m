Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0083CEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 23:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjGLXCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjGLXCC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 19:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633C518E
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 16:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA29361985
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D979C433C7;
        Wed, 12 Jul 2023 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689202920;
        bh=/6F0W44EEniTWpB8cENvUgElPrXBmpXuJwgsPjERgeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ExhwRkKXouK+jYZ3XJha47d12RFQqRYcKvtKvvQo0Q7H9qq8cGbXQegnX0+lCAZg3
         0Zum3nHdFSlJJBjgMx897oua6fM0DHPSFeSiM1WKlRYzEQpLnx3sn/o+4jRvCVyaNy
         fbB0V4WcJEOlOOUxmad5WVLYheTKWsHYarI3HRqNrGhKSqdEc2WvaTOlzsjfd/T160
         t3//IDAU6tRrSdsOb8jgwUCiCj224+u3reirAxN1vzeUqtXGX1npzxIoXa9rUkjtPH
         zUJk/lU0MgsZRP3vOJNRYmj4i5R7yYlpCFRZTraPdrI39BY9S0Wt0hqkTB+8Jln1sf
         /zeFBrZ1hJojg==
Date:   Wed, 12 Jul 2023 16:01:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 4/6] xfs: limit maxlen based on available space in
 xfs_rtallocate_extent_near()
Message-ID: <20230712230159.GX108251@frogsfrogsfrogs>
References: <cover.1687296675.git.osandov@osandov.com>
 <da373ada54c851b448cc7d41167458dc6bd6f8ea.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da373ada54c851b448cc7d41167458dc6bd6f8ea.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:14PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> xfs_rtallocate_extent_near() calls xfs_rtallocate_extent_block() with
> the minlen and maxlen that were passed to it.
> xfs_rtallocate_extent_block() then scans the bitmap block looking for a
> free range of size maxlen. If there is none, it has to scan the whole
> bitmap block before returning the largest range of at least size minlen.
> For a fragmented realtime device and a large allocation request, it's
> almost certain that this will have to search the whole bitmap block,
> leading to high CPU usage.
> 
> However, the realtime summary tells us the maximum size available in the
> bitmap block. We can limit the search in xfs_rtallocate_extent_block()
> to that size and often stop before scanning the whole bitmap block.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index ba7d42e0090f..d079dfb77c73 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -488,6 +488,8 @@ xfs_rtallocate_extent_near(
>  		 * allocating one.
>  		 */
>  		if (maxlog >= 0) {
> +			xfs_extlen_t maxavail =
> +				min(maxlen, ((xfs_extlen_t)1 << (maxlog + 1)) - 1);

There can be up to 2^52rtx (realtime extents) in the filesystem, right?
xfs_extlen_t is a u32, which will overflow this calculation if the
realtime volume is seriously huge.  IOWs, doesn't this need to be:

	xfs_extlen_t maxavail = max_t(xfs_rtblock_t, maxlen,
			(1ULL << (maxlog + 1)) - 1);

(The rest of the patch looks ok)

--D

>  			/*
>  			 * On the positive side of the starting location.
>  			 */
> @@ -497,7 +499,7 @@ xfs_rtallocate_extent_near(
>  				 * this block.
>  				 */
>  				error = xfs_rtallocate_extent_block(mp, tp,
> -					bbno + i, minlen, maxlen, len, &n,
> +					bbno + i, minlen, maxavail, len, &n,
>  					rtbufc, prod, &r);
>  				if (error) {
>  					return error;
> @@ -542,7 +544,7 @@ xfs_rtallocate_extent_near(
>  					if (maxlog >= 0)
>  						continue;
>  					error = xfs_rtallocate_extent_block(mp,
> -						tp, bbno + j, minlen, maxlen,
> +						tp, bbno + j, minlen, maxavail,
>  						len, &n, rtbufc, prod, &r);
>  					if (error) {
>  						return error;
> @@ -564,7 +566,7 @@ xfs_rtallocate_extent_near(
>  				 * that we found.
>  				 */
>  				error = xfs_rtallocate_extent_block(mp, tp,
> -					bbno + i, minlen, maxlen, len, &n,
> +					bbno + i, minlen, maxavail, len, &n,
>  					rtbufc, prod, &r);
>  				if (error) {
>  					return error;
> -- 
> 2.41.0
> 
