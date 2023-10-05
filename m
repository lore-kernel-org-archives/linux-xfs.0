Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D16E92708
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 13:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjJENz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 09:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243889AbjJENtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 09:49:49 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0821A19BF
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 20:47:55 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1dd54aca17cso355540fac.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 20:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696477674; x=1697082474; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7bEDLOV5jkhInD4p7k3uCTNQIl0cFYQ8/24X2yBkgY=;
        b=B/Nut3X+tgroulbG7+5jCTDj8YHloUir0eNVSqJEugTiShTjEf7eiYr7KdUejJJo3W
         8bWl7h15EWfdxZ9Z0U2e5YUxlRU3DlrULpSvuIufZ5197cxSJah0QQn4XxacAYGL+9UG
         H55ADSK9gHNXLOzheDumg8cHCoDd/YDIhFBB9HnQcnplXcv4UvE3OiCjW9RxksC+cnqW
         6Mek4gATyvJq9KerhQatl6GcQtyJ6+sg6RSX+oci9BShl/AuBJu5GjBeiKjqCK/6kyG2
         pd2yaCqo9l7DZBtYK2ip1N28t/qeVN2bWlkOkFchxjeco/y8THN/MSXQrAcc7wyC9WWP
         feUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696477674; x=1697082474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7bEDLOV5jkhInD4p7k3uCTNQIl0cFYQ8/24X2yBkgY=;
        b=U3erV10Wft7GXCUMa86cD6ETWw24taJK1QBAzyBQWpoC6YHSWUUkBR+psCTskWWX4e
         WnGOXxZLWZKXJCKDBIPp4DFBGwAB75NzD3LrlOteLresB/3+WfAi7AckIHqpRmkUtRea
         PubRdRqbBNDEIhL/BUZeHiYnk90tePwjFPOeMK2ZgG0O+Vd6CC26ew/LwnFrTGBvHvms
         jcv2yr8W52UGEbMkmgvibSEuuuEg9/Dwofw3k6TRhOd+uXUZQqlF0TahsY+RFso7K97g
         zwtZiGXk4+gktL509lr2a046J+fiw5cEuMk4wdx1LXw/eoty805ISafKPbnZL9nDFf7I
         oSRg==
X-Gm-Message-State: AOJu0YzUS/AYymfGsUG/mSq0f329umu0Py802HG1ufbkl7mHRv4nBCn5
        aLMBvYxZ1XgBOBQ4B1IP6oqZRIiU0yS6SN9h3LI=
X-Google-Smtp-Source: AGHT+IG1ND4zJRM9SjQHtu62PCfmDQTOtq4HQRqtlteFbqZtQNLN5V4qioOGnGQzN1HofuI8SjYSiQ==
X-Received: by 2002:a05:6870:b294:b0:1b0:43b6:e13b with SMTP id c20-20020a056870b29400b001b043b6e13bmr4768855oao.54.1696477673905;
        Wed, 04 Oct 2023 20:47:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78517000000b0068fb9f98467sm301927pfn.107.2023.10.04.20.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 20:47:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoFL4-009cUm-2k;
        Thu, 05 Oct 2023 14:47:50 +1100
Date:   Thu, 5 Oct 2023 14:47:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: automatic freeing of freshly allocated
 unwritten space
Message-ID: <ZR4x5hVk6XQffHi5@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059209.3312911.11197509089553101214.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059209.3312911.11197509089553101214.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:32:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As mentioned in the previous commit, online repair wants to allocate
> space to write out a new metadata structure, and it also wants to hedge
> against system crashes during repairs by logging (and later cancelling)
> EFIs to free the space if we crash before committing the new data
> structure.
> 
> Therefore, create a trio of functions to schedule automatic reaping of
> freshly allocated unwritten space.  xfs_alloc_schedule_autoreap creates
> a paused EFI representing the space we just allocated.  Once the
> allocations are made and the autoreaps scheduled, we can start writing
> to disk.
> 
> If the writes succeed, xfs_alloc_cancel_autoreap marks the EFI work
> items as stale and unpauses the pending deferred work item.  Assuming
> that's done in the same transaction that commits the new structure into
> the filesystem, we guarantee that either the new object is fully
> visible, or that all the space gets reclaimed.
> 
> If the writes succeed but only part of an extent was used, repair must
> call the same _cancel_autoreap function to kill the first EFI and then
> log a new EFI to free the unused space.  The first EFI is already
> committed, so it cannot be changed.
> 
> For full extents that aren't used, xfs_alloc_commit_autoreap will
> unpause the EFI, which results in the space being freed during the next
> _defer_finish cycle.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |  104 +++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_alloc.h |   12 +++++
>  fs/xfs/xfs_extfree_item.c |   11 +++--
>  3 files changed, 120 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 295d11a27f632..c1ee1862cc1af 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2501,14 +2501,15 @@ xfs_defer_agfl_block(
>   * Add the extent to the list of extents to be free at transaction end.
>   * The list is maintained sorted (by block number).
>   */
> -int
> -xfs_free_extent_later(
> +static int
> +__xfs_free_extent_later(
>  	struct xfs_trans		*tp,
>  	xfs_fsblock_t			bno,
>  	xfs_filblks_t			len,
>  	const struct xfs_owner_info	*oinfo,
>  	enum xfs_ag_resv_type		type,
> -	bool				skip_discard)
> +	bool				skip_discard,
> +	struct xfs_defer_pending	**dfpp)

I was happy that __xfs_free_extent_later() went away in the last
patch. 

I am sad that it has immediately come back....

Can we please name this after what it does? Say
xfs_defer_extent_free()?

>  {
>  	struct xfs_extent_free_item	*xefi;
>  	struct xfs_mount		*mp = tp->t_mountp;
> @@ -2556,10 +2557,105 @@ xfs_free_extent_later(
>  			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
>  
>  	xfs_extent_free_get_group(mp, xefi);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
> +	*dfpp = xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
>  	return 0;
>  }
>  
> +int
> +xfs_free_extent_later(
> +	struct xfs_trans		*tp,
> +	xfs_fsblock_t			bno,
> +	xfs_filblks_t			len,
> +	const struct xfs_owner_info	*oinfo,
> +	enum xfs_ag_resv_type		type,
> +	bool				skip_discard)
> +{
> +	struct xfs_defer_pending	*dontcare = NULL;
> +
> +	return __xfs_free_extent_later(tp, bno, len, oinfo, type, skip_discard,
> +			&dontcare);
> +}
> +
> +/*
> + * Set up automatic freeing of unwritten space in the filesystem.
> + *
> + * This function attached a paused deferred extent free item to the
> + * transaction.  Pausing means that the EFI will be logged in the next
> + * transaction commit, but the pending EFI will not be finished until the
> + * pending item is unpaused.
> + *
> + * If the system goes down after the EFI has been persisted to the log but
> + * before the pending item is unpaused, log recovery will find the EFI, fail to
> + * find the EFD, and free the space.
> + *
> + * If the pending item is unpaused, the next transaction commit will log an EFD
> + * without freeing the space.
> + *
> + * Caller must ensure that the tp, fsbno, len, oinfo, and resv flags of the
> + * @args structure are set to the relevant values.
> + */
> +int
> +xfs_alloc_schedule_autoreap(
> +	const struct xfs_alloc_arg	*args,
> +	bool				skip_discard,
> +	struct xfs_alloc_autoreap	*aarp)
> +{
> +	int				error;
> +
> +	error = __xfs_free_extent_later(args->tp, args->fsbno, args->len,
> +			&args->oinfo, args->resv, skip_discard, &aarp->dfp);
> +	if (error)
> +		return error;
> +
> +	xfs_defer_item_pause(args->tp, aarp->dfp);
> +	return 0;
> +}

Then this becomes much more readable - xfs_defer_free_extent()
returns the defer_pending work item for the EFI, which we then
immediately pause....

> +
> +/*
> + * Cancel automatic freeing of unwritten space in the filesystem.
> + *
> + * Earlier, we created a paused deferred extent free item and attached it to
> + * this transaction so that we could automatically roll back a new space
> + * allocation if the system went down.  Now we want to cancel the paused work
> + * item by marking the EFI stale so we don't actually free the space, unpausing
> + * the pending item and logging an EFD.
> + *
> + * The caller generally should have already mapped the space into the ondisk
> + * filesystem.  If the reserved space was partially used, the caller must call
> + * xfs_free_extent_later to create a new EFI to free the unused space.
> + */
> +void
> +xfs_alloc_cancel_autoreap(
> +	struct xfs_trans		*tp,
> +	struct xfs_alloc_autoreap	*aarp)
> +{
> +	struct xfs_defer_pending	*dfp = aarp->dfp;
> +	struct xfs_extent_free_item	*xefi;
> +
> +	if (!dfp)
> +		return;
> +
> +	list_for_each_entry(xefi, &dfp->dfp_work, xefi_list)
> +		xefi->xefi_flags |= XFS_EFI_STALE;
> +
> +	xfs_defer_item_unpause(tp, dfp);
> +}

Hmmmm. I see what you are trying to do here, though I'm not sure
that "stale" is the right word to describe it. The EFI has been
cancelled, so we want and EFD to be logged without freeing the
extent.

To me, "stale" means "contents longer valid, do not touch" as per
XFS_ISTALE, xfs_buf_stale(), etc

Whereas we use "cancelled" to indicate that the pending operations
on the buffer should not be actioned, such as XFS_BLF_CANCEL buffer
items in log recovery to indicate the buffer has been freed and
while it is cancelled we should not replay the changes found in the
log for that buffer....

Hence I think this is better named XFS_EFI_CANCELLED, and it also
matches what the calling function is doing - cancelling the autoreap
of the extent....

> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 9e7b58f3566c0..98c2667d369e8 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -392,9 +392,14 @@ xfs_trans_free_extent(
>  	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
>  			agbno, xefi->xefi_blockcount);
>  
> -	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
> -			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
> -			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> +	if (xefi->xefi_flags & XFS_EFI_STALE) {
> +		error = 0;
> +	} else {
> +		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
> +				xefi->xefi_blockcount, &oinfo,
> +				xefi->xefi_agresv,
> +				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> +	}

Just init error to 0 when it is declared, then this becomes:

	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
				xefi->xefi_blockcount, &oinfo,
				xefi->xefi_agresv,
				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
	}

Otherwise the code looks ok.

-- 
Dave Chinner
david@fromorbit.com
