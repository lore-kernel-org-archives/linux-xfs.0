Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF6FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F0D64ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBSDXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBSDXu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 22:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06C7164D74;
        Fri, 19 Feb 2021 03:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613704990;
        bh=4EITOIjAmBMK0GdN5IJMY3LI3QvjIMGw7EXHdMMWm0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BoeGMh1LmsNKPLSSVooyXe0gPVxxRtilfZ0xAUtOz5MY+95/WIlk4CVmh6bFAidEc
         eZgpQ3Ka8v+bqpTiidPZSsWnVEDu+rTQ7l/kC5U2ZdOlKWrtYegCh2EleWHRztggvm
         rbr5ddUOzx32r16tHtoKenpXxtqw0MBLYyn+Fsq/r8F5NOw88y84Km/gxIa1rxESee
         k8K/k5KiQbKL/MM0I05v9DBtVpmQy+q++iQSDaZjJ3ml77pTxJ27gHW8AjjJL+MjdW
         OhSDO87tBXyhJcF2OS1VcJR+6fShpjGHeVpN8mNvnmMq9TxepSunzM5XfH+I24b6/B
         KNm6Ino00gfew==
Date:   Thu, 18 Feb 2021 19:23:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't call into blockgc scan with freeze protection
Message-ID: <20210219032309.GX7193@magnolia>
References: <20210218201458.718889-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218201458.718889-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 03:14:58PM -0500, Brian Foster wrote:
> fstest xfs/167 produced a lockdep splat that complained about a
> nested transaction acquiring freeze protection during an eofblocks
> scan. Drop freeze protection around the block reclaim scan in the
> transaction allocation code to avoid this problem.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I think it seems reasonable, though I really wish that other patchset to
clean up all the "modify thread state when we start/end transactions"
had landed.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 44f72c09c203..c32c62d3b77a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -261,6 +261,7 @@ xfs_trans_alloc(
>  {
>  	struct xfs_trans	*tp;
>  	int			error;
> +	bool			retried = false;
>  
>  	/*
>  	 * Allocate the handle before we do our freeze accounting and setting up
> @@ -288,19 +289,27 @@ xfs_trans_alloc(
>  	INIT_LIST_HEAD(&tp->t_dfops);
>  	tp->t_firstblock = NULLFSBLOCK;
>  
> +retry:
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> -	if (error == -ENOSPC) {
> +	if (error == -ENOSPC && !retried) {
>  		/*
>  		 * We weren't able to reserve enough space for the transaction.
>  		 * Flush the other speculative space allocations to free space.
>  		 * Do not perform a synchronous scan because callers can hold
>  		 * other locks.
>  		 */
> +		retried = true;
> +		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> +			sb_end_intwrite(mp->m_super);
>  		error = xfs_blockgc_free_space(mp, NULL);
> -		if (!error)
> -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> -	}
> -	if (error) {
> +		if (error) {
> +			kmem_cache_free(xfs_trans_zone, tp);
> +			return error;
> +		}
> +		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> +			sb_start_intwrite(mp->m_super);
> +		goto retry;
> +	} else if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;
>  	}
> -- 
> 2.26.2
> 
