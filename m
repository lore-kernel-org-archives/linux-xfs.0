Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BF2EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 03:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjFODil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 23:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjFODik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 23:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA48B196
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC0761048
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 03:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE18AC433C0;
        Thu, 15 Jun 2023 03:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686800317;
        bh=JVmdlXk4jCyu0hjSimdkQ0eqZrrcAffHqqJ+NPUWnWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bsQZIizcsfBAGiA3MhCS4DpUukb4bAA8zBpNvqIPMFG7cONl2D9iZc1JP3qJhE/03
         ixu7rfNyiZVBF5fQ0G3mk/cAtmvdJdjugxqf1O5q1U8tjHkRq/BwTzFRDqfLmQWzJN
         81V4fxbfbTHt4RE9lqloRPYZl9IyNUfpvRa55+KPrEJkI7IAou9A+FNl+o1f9XHerQ
         2WmqhQnVdHVdw8yDaek//hj8RkLdUI14NTRHpJxTw3BQqAccqOlbDxQN3qr01gImww
         PYKRHazjCDM5fu9UymcOhj0cyO9kuZBnDNGDh4nudtnzd9YKYP7El5djI/BdlzXLP2
         bz+IHQtLu2Csw==
Date:   Wed, 14 Jun 2023 20:38:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/3] xfs: allow extent free intents to be retried
Message-ID: <20230615033837.GM11441@frogsfrogsfrogs>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615014201.3171380-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 11:42:00AM +1000, Dave Chinner wrote:
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
>  fs/xfs/xfs_extfree_item.c | 64 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index f9e36b810663..3b33d27efdce 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,29 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI when we need to roll the
> + * transaction and continue with a new EFI.
> + */
> +static void
> +xfs_efd_from_efi(
> +	struct xfs_efd_log_item	*efdp)
> +{
> +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> +	uint                    i;
> +
> +	ASSERT(efip->efi_format.efi_nextents > 0);
> +
> +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> +		return;
> +
> +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> +	       efdp->efd_format.efd_extents[i] =
> +		       efip->efi_format.efi_extents[i];
> +	}
> +	efdp->efd_next_extent = efip->efi_format.efi_nextents;

Odd question -- if we managed to free half the extents mentioned in an
EFI before hitting -EAGAIN, then efdp->efd_next_extent should already be
half of efip->efi_format.efi_nextents, right?

I suppose it's duplicative (or maybe just careful) to recopy the entire
thing... but maybe that doesn't even really matter since no modern xlog
code actually pays attention to what's in the EFD aside from the ID
number.


> +}
> +
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> @@ -378,6 +401,17 @@ xfs_trans_free_extent(
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
> @@ -495,6 +529,13 @@ xfs_extent_free_finish_item(
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
> @@ -620,6 +661,7 @@ xfs_efi_item_recover(
>  	struct xfs_trans		*tp;
>  	int				i;
>  	int				error = 0;
> +	bool				requeue_only = false;
>  
>  	/*
>  	 * First check the validity of the extents described by the
> @@ -652,9 +694,25 @@ xfs_efi_item_recover(
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
> +			xfs_free_extent_later(tp, fake.xefi_startblock,
> +				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);

Shouldn't we check the return value of xfs_free_extent_later now?
I think we already did that above, but since you just plumbed in the
extra checks, we ought to use it. :)

(Also the indenting here isn't the usual two tabs)

Aside from that everything looks in order here.

--D

> +			requeue_only = true;
> +			error = 0;
> +			continue;
> +		};
> +
>  		if (error == -EFSCORRUPTED)
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					extp, sizeof(*extp));
> -- 
> 2.40.1
> 
