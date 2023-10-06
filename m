Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C79EE92FE6
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJFF1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjJFF1h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:27:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C46B6
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:27:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA83C433C8;
        Fri,  6 Oct 2023 05:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696570056;
        bh=9tr9T8231jvrHgALXhfFCMY7IiiWK10Y/jYmAscEqLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAJybesK6DEl7jmkLGSf9k1ERDdpqAzLIkU8/UPQf1v3+4pmVug0SSlHfPv6gy9Zc
         V8GVtpqmuxVdp2ZbAxzUcgZjdWihC4pfznaq6K0b/sLChHRaIb1460RDUYcgfQdSCM
         X9m7aYESOnOZ03hpSajwLqAPjUH4Bnx95j3E0UA9i865S7zeNBNH/YVs7s5wcZtCNa
         9PVgaXA9G3BtDn7qER85H0I4j4T+pTArCraeaAfaiGgWYBtUIs57lMysgCj7mhT1B+
         5XpZ/KH9ZeP9XucejJ/zvI9WukdRsM4a5gH6S8NttLmqav8JBQwc3OS+EQPiU9BRCC
         KKSTlRo7oVaJw==
Date:   Thu, 5 Oct 2023 22:27:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 2/9] xfs: contiguous EOF allocation across AGs
Message-ID: <20231006052735.GT21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:36AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently when we allocate at EOF, we set the initial target to the
> location of the inode. Then we call xfs_bmap_adjacent(), which sees
> that we are doing an EOF extension, so it moves the target to the
> last block of the previous extent. This may be in a different AG to
> the inode.
> 
> When we then go to select the AG with the best free length, the AG
> at the target block might not have sufficient free space for the
> full allocation, so we may select a different AG. We then do an
> exact BNO allocation with the original target (EOF block), which
> reverts back to attempting an allocation in an AG that doesn't have
> sufficient contiguous free space available.
> 
> This generally leads to allocation failure, and then we fall back to
> scanning the AGs for one that the allocation will succeed in. This
> scan also results in contended AGS being skipped, so we have no idea
> what AG we are going to end up allocating in. For sequential writes,
> this results in random extents being located in random places in
> non-target AGs.
> 
> We want to guarantee that we can allocate in the AG that we have
> selected as having the "best contiguous free space" efficiently,
> so if we select a different AG, we should move the allocation target
> and skip the exact EOF allocation as we know it will not succeed.
> i.e. we should start with aligned allocation immediately, knowing it
> will likely succeed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Sounds good to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e14671414afb..e64ba7e2d13d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3252,8 +3252,18 @@ xfs_bmap_btalloc_select_lengths(
>  		if (error && error != -EAGAIN)
>  			break;
>  		error = 0;
> -		if (*blen >= args->maxlen)
> +		if (*blen >= args->maxlen) {
> +			/*
> +			 * We are going to target a different AG than the
> +			 * incoming target, so we need to reset the target and
> +			 * skip exact EOF allocation attempts.
> +			 */
> +			if (agno != startag) {
> +				ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
> +				ap->aeof = false;
> +			}
>  			break;
> +		}
>  	}
>  	if (pag)
>  		xfs_perag_rele(pag);
> @@ -3514,10 +3524,10 @@ xfs_bmap_btalloc_aligned(
>  	int			error;
>  
>  	/*
> -	 * If we failed an exact EOF allocation already, stripe
> -	 * alignment will have already been taken into account in
> -	 * args->minlen. Hence we only adjust minlen to try to preserve
> -	 * alignment if no slop has been reserved for alignment
> +	 * If we failed an exact EOF allocation already, stripe alignment will
> +	 * have already been taken into account in args->minlen. Hence we only
> +	 * adjust minlen to try to preserve alignment if no slop has been
> +	 * reserved for alignment
>  	 */
>  	if (args->minalignslop == 0) {
>  		if (blen > stripe_align &&
> @@ -3653,6 +3663,16 @@ xfs_bmap_btalloc_best_length(
>  	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
>  	xfs_bmap_adjacent(ap);
>  
> +	/*
> +	 * We only use stripe alignment for EOF allocations. Hence if it isn't
> +	 * an EOF allocation, clear the stripe alignment. This allows us to
> +	 * skip exact block EOF allocation yet still do stripe aligned
> +	 * allocation if we select a different AG to the
> +	 * exact target block due to a lack of contiguous free space.
> +	 */
> +	if (!ap->aeof)
> +		stripe_align = 0;
> +
>  	/*
>  	 * Search for an allocation group with a single extent large enough for
>  	 * the request.  If one isn't found, then adjust the minimum allocation
> @@ -3675,7 +3695,7 @@ xfs_bmap_btalloc_best_length(
>  	}
>  
>  	/* attempt aligned allocation for new EOF extents */
> -	if (ap->aeof)
> +	if (stripe_align)
>  		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
>  				false);
>  	if (error || args->fsbno != NULLFSBLOCK)
> -- 
> 2.40.1
> 
