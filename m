Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F27EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjF1Rsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjF1Rsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D233D2123
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 10:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8AD61374
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 17:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D8DC433C0;
        Wed, 28 Jun 2023 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974516;
        bh=WTwPy/VHzX+aNrCDgI5xbNJjpO2K7G7y1r0DrXkVyqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YCcG78IBLoVPridTh9VGa21Uh308bNPWhlUIdPWyUpdIV2xhe9h10WlmpoRP05v9I
         m24gtcqCVNnLfjMDkEpsp0W7hDXUmpORBJrL5EqIPaCK/M0kiiRZi4v6o1pXpcF6pc
         qf1w5jDEnw5bke8v/FRrqLCTMnzEIkWQCu5du3u2sz9wH3rPfxK21L4qXah/dKwokz
         iRLpERKa0Ddzl5X6s3/bRCNz5+IYXniyLLAk6LMiqNQtn+qZjuvnRHFhSNgQIrTYUv
         wHHut2srYZ+51pGwbAYl6R7M7wzBx1+u+CBd/+XRaujhorwlb1ZQ0XHXHNcIS2R4vc
         q4ZHiU8DFhIBA==
Date:   Wed, 28 Jun 2023 10:48:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: allow extent free intents to be retried
Message-ID: <20230628174836.GV11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:08AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Extent freeing neeeds to be able to avoid a busy extent deadlock
> when the transaction itself holds the only busy extents in the
> allocation group. This may occur if we have an EFI that contains
> multiple extents to be freed, and the freeing the second intent
> requires the space the first extent free released to expand the
> AGFL. If we block on the busy extent at this point, we deadlock.
> 
> We hold a dirty transaction that contains a entire atomic extent
> free operations within it, so if we can abort the extent free
> operation and commit the progress that we've made, the busy extent
> can be resolved by a log force. Hence we can restart the aborted
> extent free with a new transaction and continue to make
> progress without risking deadlocks.
> 
> To enable this, we need the EFI processing code to be able to handle
> an -EAGAIN error to tell it to commit the current transaction and
> retry again. This mechanism is already built into the defer ops
> processing (used bythe refcount btree modification intents), so
> there's relatively little handling we need to add to the EFI code to
> enable this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_extfree_item.c | 73 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 70 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 79e65bb6b0a2..098420cbd4a0 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,34 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI when we need to roll the
> + * transaction and continue with a new EFI.
> + *
> + * This simply copies all the extents in the EFI to the EFD rather than make
> + * assumptions about which extents in the EFI have already been processed. We
> + * currently keep the xefi list in the same order as the EFI extent list, but
> + * that may not always be the case. Copying everything avoids leaving a landmine
> + * were we fail to cancel all the extents in an EFI if the xefi list is
> + * processed in a different order to the extents in the EFI.
> + */
> +static void
> +xfs_efd_from_efi(
> +	struct xfs_efd_log_item	*efdp)
> +{
> +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> +	uint                    i;
> +
> +	ASSERT(efip->efi_format.efi_nextents > 0);
> +	ASSERT(efdp->efd_next_extent < efip->efi_format.efi_nextents);
> +
> +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> +	       efdp->efd_format.efd_extents[i] =
> +		       efip->efi_format.efi_extents[i];
> +	}
> +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> +}
> +
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> @@ -378,6 +406,17 @@ xfs_trans_free_extent(
>  	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
> +	/*
> +	 * If we need a new transaction to make progress, the caller will log a
> +	 * new EFI with the current contents. It will also log an EFD to cancel
> +	 * the existing EFI, and so we need to copy all the unprocessed extents
> +	 * in this EFI to the EFD so this works correctly.
> +	 */
> +	if (error == -EAGAIN) {
> +		xfs_efd_from_efi(efdp);
> +		return error;
> +	}
> +
>  	next_extent = efdp->efd_next_extent;
>  	ASSERT(next_extent < efdp->efd_format.efd_nextents);
>  	extp = &(efdp->efd_format.efd_extents[next_extent]);
> @@ -495,6 +534,13 @@ xfs_extent_free_finish_item(
>  
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
>  
> +	/*
> +	 * Don't free the XEFI if we need a new transaction to complete
> +	 * processing of it.
> +	 */
> +	if (error == -EAGAIN)
> +		return error;
> +
>  	xfs_extent_free_put_group(xefi);
>  	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
> @@ -620,6 +666,7 @@ xfs_efi_item_recover(
>  	struct xfs_trans		*tp;
>  	int				i;
>  	int				error = 0;
> +	bool				requeue_only = false;
>  
>  	/*
>  	 * First check the validity of the extents described by the
> @@ -653,9 +700,29 @@ xfs_efi_item_recover(
>  		fake.xefi_startblock = extp->ext_start;
>  		fake.xefi_blockcount = extp->ext_len;
>  
> -		xfs_extent_free_get_group(mp, &fake);
> -		error = xfs_trans_free_extent(tp, efdp, &fake);
> -		xfs_extent_free_put_group(&fake);
> +		if (!requeue_only) {
> +			xfs_extent_free_get_group(mp, &fake);
> +			error = xfs_trans_free_extent(tp, efdp, &fake);
> +			xfs_extent_free_put_group(&fake);
> +		}
> +
> +		/*
> +		 * If we can't free the extent without potentially deadlocking,
> +		 * requeue the rest of the extents to a new so that they get
> +		 * run again later with a new transaction context.
> +		 */
> +		if (error == -EAGAIN || requeue_only) {
> +			error = xfs_free_extent_later(tp, fake.xefi_startblock,
> +					fake.xefi_blockcount,
> +					&XFS_RMAP_OINFO_ANY_OWNER,
> +					fake.xefi_type);
> +			if (!error) {
> +				requeue_only = true;
> +				error = 0;

@error is already zero so this is redundant, right?

If yes then I'll remove the line on commit,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +				continue;
> +			}
> +		};
> +
>  		if (error == -EFSCORRUPTED)
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					extp, sizeof(*extp));
> -- 
> 2.40.1
> 
