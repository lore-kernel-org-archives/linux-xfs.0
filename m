Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774D4804
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 04:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724646794; cv=none; b=WyKXXhs4RYgd8YP0dYHDPsQg9knCrgHoeCxCq5j63xPv+zfYp3+bVTBnjVnld2IW298RjdYaIOSHkhjqs4WC266Mhwd+QECNysn5C0zY7Ar1MPeNVT24jkAOk60dmAWRp0cL88WHdDA4PtBfZOuzD3f0zbEC3QX62ZEL8P+Cj9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724646794; c=relaxed/simple;
	bh=xHB+hwTdK7wwoDPtwy6dDlXXaBcUg6ai4XmbA4onYXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNrtYn/owjid69apHAPDjWgZTPVkrCamCnSx8+RT/4rp0n06P0I0sQDuAsmj4oW24VOklX1zpXcnmfEBnptI00J8MNvq5HhNZpXWrfePiVTROi4oUOtgpABmjkP+BchZFdxk2UmiFnPm8PHZN67yBSL3mRq0GSEoQdU2MnPfhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eDJehmJ6; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eDJehmJ6"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7142448aaf9so2548724b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 21:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724646792; x=1725251592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VleShYx2a6LzVDD1hcUEYoSFbc5WubfO8gmYbTNieHA=;
        b=eDJehmJ6jFvxREfl+DyNxvwhrmxm7bqbBw/+n5Nfv03qGB6fXjF3MmMSWs0JlriL9F
         h/SfCUiVgE8jFxU9+dAM2VfU1g0ENQthSoGe7MdYGgqlbi34RcrT8Zwp9t9c4TOsOeIl
         UPW1vB7vxv++HZJaZh/vSC0zgX4jE+5h0aAp4Asf1iS5MoA40advgufOsQF6Kb77MlGN
         D168p8el97t4tCgtWe8EuDX7CZM23Gc7Nhlb0OUz0xckKCGDBEc1RrI/Y6yzXTSUj3Lv
         arLUkCpAhU/oVIRSf78Y1EFv0Bd+kZu2ebEBiJNBccdWo/Z4uxIpafM97RYFMU+NLWNZ
         KWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724646792; x=1725251592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VleShYx2a6LzVDD1hcUEYoSFbc5WubfO8gmYbTNieHA=;
        b=F24JfCOi/wmwzr7pOCETZheYNXdt1rxCZqYoiLQ9yLKq8B+o5igQ5y+OmU5+5/jpWW
         LXAUHFqPZi9g3dp0e3QOjH2uxWGiakFiTR4jIcfTwByNWIBMPWwV0vSrFqIwsp/+DfVn
         9A/XfEYidYZTr58cUUU4OdSgEcYR+clonT9oTV8bZbPcDFf+FAbz68+OzqG1exZ/E2qR
         AZWpClQqGCxY5lVm8TvZfSM49/g/8vpT0ZbWUVm4v/bkIOBSZHn7nmfP/+nYCboTMPd3
         Xh872TEVVV0GP3kIlDava3GpyRVexa4ulEjZNKpW10+EqJ11o9xX9hCztxQel0rS2lcy
         RQQg==
X-Forwarded-Encrypted: i=1; AJvYcCViP2vT7rCs+ZvPJfPlIdkaOZUVzV/4Hj16g02vjvD63Ev486TOxdwHTLNeL0Gb7QlCYpK7DodDbtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH3mVcce0IqrRRcBB8rPEok6NrKAnuV2nhglJayMFRhu+sGx7V
	7BdFnYb/rejxmo1TcoAi4CrwlcHS83hPsJgI50ewCzswBmKyP5EWrqd0Xolp1w8=
X-Google-Smtp-Source: AGHT+IGFqrxxnGRik4pOFkZD6YdHvC7S3dFD2wecUUg++Fkht9zniJ3tHeZIu7RTn8hqt7VcVrNXiA==
X-Received: by 2002:a05:6a20:bcaf:b0:1cc:b09f:4776 with SMTP id adf61e73a8af0-1ccb09f477cmr1820673637.0.1724646791449;
        Sun, 25 Aug 2024 21:33:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143424966csm6300147b3a.54.2024.08.25.21.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 21:33:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siRPg-00Cy5X-1R;
	Mon, 26 Aug 2024 14:33:08 +1000
Date: Mon, 26 Aug 2024 14:33:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs: support logging EFIs for realtime extents
Message-ID: <ZswFhKNrMh4I8QGm@dread.disaster.area>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:25:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the EFI mechanism how to free realtime extents.  We're going to
> need this to enforce proper ordering of operations when we enable
> realtime rmap.
> 
> Declare a new log intent item type (XFS_LI_EFI_RT) and a separate defer
> ops for rt extents.  This keeps the ondisk artifacts and processing code
> completely separate between the rt and non-rt cases.  Hopefully this
> will make it easier to debug filesystem problems.

Doesn't this now require busy extent tracking for rt extents that
are being freed?  i.e. they get marked as free with the EFD, but
cannot be reallocated (or discarded) until the EFD is committed to
disk.

we don't allow user data allocation on the data device to reuse busy
ranges because the freeing of the extent has not yet been committed
to the journal. Because we use async transaction commits, that means
we can return to userspace without even the EFI in the journal - it
can still be in memory in the CIL. Hence we cannot allow userspace
to reallocate that range and write to it, even though it is marked free in the
in-memory metadata.

If userspace then does a write and then we crash without the
original EFI on disk, then we've just violated metadata vs data
update ordering because recovery will not replay the extent free nor
the new allocation, yet the data in that extent will have been
changed.

Hence I think that if we are moving to intent based freeing of real
time extents, we absolutely need to add support for busy extent
tracking to realtime groups before we enable EFIs on realtime
groups.....

Also ....

> @@ -447,6 +467,17 @@ xfs_extent_free_defer_add(
>  
>  	trace_xfs_extent_free_defer(mp, xefi);
>  
> +	if (xfs_efi_is_realtime(xefi)) {
> +		xfs_rgnumber_t		rgno;
> +
> +		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
> +		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
> +
> +		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
> +				&xfs_rtextent_free_defer_type);
> +		return;
> +	}
> +
>  	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
>  	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
>  		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,

Hmmmm. Isn't this also missing the xfs_drain intent interlocks that
allow online repair to wait until all the intents outstanding on a
group complete?

> @@ -687,6 +735,106 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>  	.relog_intent	= xfs_extent_free_relog_intent,
>  };
>  
> +#ifdef CONFIG_XFS_RT
> +/* Sort realtime efi items by rtgroup for efficiency. */
> +static int
> +xfs_rtextent_free_diff_items(
> +	void				*priv,
> +	const struct list_head		*a,
> +	const struct list_head		*b)
> +{
> +	struct xfs_extent_free_item	*ra = xefi_entry(a);
> +	struct xfs_extent_free_item	*rb = xefi_entry(b);
> +
> +	return ra->xefi_rtg->rtg_rgno - rb->xefi_rtg->rtg_rgno;
> +}
> +
> +/* Create a realtime extent freeing */
> +static struct xfs_log_item *
> +xfs_rtextent_free_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count,
> +	bool				sort)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_efi_log_item		*efip;
> +	struct xfs_extent_free_item	*xefi;
> +
> +	ASSERT(count > 0);
> +
> +	efip = xfs_efi_init(mp, XFS_LI_EFI_RT, count);
> +	if (sort)
> +		list_sort(mp, items, xfs_rtextent_free_diff_items);
> +	list_for_each_entry(xefi, items, xefi_list)
> +		xfs_extent_free_log_item(tp, efip, xefi);
> +	return &efip->efi_item;
> +}

Hmmmm - when would we get an XFS_LI_EFI_RT with multiple extents in
it? We only ever free a single user data extent per transaction at a
time, right? There will be no metadata blocks being freed on the rt
device - all the BMBT, refcountbt and rmapbt blocks that get freed
as a result of freeing the user data extent will be in the data
device and so will use EFIs, not EFI_RTs....

> +
> +/* Cancel a realtime extent freeing. */
> +STATIC void
> +xfs_rtextent_free_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> +
> +	xfs_rtgroup_put(xefi->xefi_rtg);
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
> +}
> +
> +/* Process a free realtime extent. */
> +STATIC int
> +xfs_rtextent_free_finish_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
> +	struct list_head		*item,
> +	struct xfs_btree_cur		**state)

btree cursor ....

> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> +	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
> +	struct xfs_rtgroup		**rtgp = (struct xfs_rtgroup **)state;

... but is apparently holding a xfs_rtgroup. that's kinda nasty, and
the rtg the xefi is supposed to be associated with is already held
by the xefi, so....

> +	int				error = 0;
> +
> +	trace_xfs_extent_free_deferred(mp, xefi);
> +
> +	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
> +		if (*rtgp != xefi->xefi_rtg) {
> +			xfs_rtgroup_lock(xefi->xefi_rtg, XFS_RTGLOCK_BITMAP);
> +			xfs_rtgroup_trans_join(tp, xefi->xefi_rtg,
> +					XFS_RTGLOCK_BITMAP);
> +			*rtgp = xefi->xefi_rtg;

How does this case happen? Why is it safe to lock the xefi rtg
here, and why are we returning the xefi rtg to the caller without
taking extra references or dropping the rtg the caller passed in?

At least a comment explaining what is happening is necessary here...

> +		}
> +		error = xfs_rtfree_blocks(tp, xefi->xefi_rtg,
> +				xefi->xefi_startblock, xefi->xefi_blockcount);
> +	}
> +	if (error == -EAGAIN) {
> +		xfs_efd_from_efi(efdp);
> +		return error;
> +	}
> +
> +	xfs_efd_add_extent(efdp, xefi);
> +	xfs_rtextent_free_cancel_item(item);
> +	return error;
> +}
> +
> +const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
> +	.name		= "rtextent_free",
> +	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> +	.create_intent	= xfs_rtextent_free_create_intent,
> +	.abort_intent	= xfs_extent_free_abort_intent,
> +	.create_done	= xfs_extent_free_create_done,
> +	.finish_item	= xfs_rtextent_free_finish_item,
> +	.cancel_item	= xfs_rtextent_free_cancel_item,
> +	.recover_work	= xfs_extent_free_recover_work,
> +	.relog_intent	= xfs_extent_free_relog_intent,
> +};
> +#else
> +const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
> +	.name		= "rtextent_free",
> +};
> +#endif /* CONFIG_XFS_RT */
> +
>  STATIC bool
>  xfs_efi_item_match(
>  	struct xfs_log_item	*lip,
> @@ -731,7 +879,7 @@ xlog_recover_efi_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> +	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
>  	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
>  	if (error) {
>  		xfs_efi_item_free(efip);
> @@ -749,6 +897,58 @@ const struct xlog_recover_item_ops xlog_efi_item_ops = {
>  	.commit_pass2		= xlog_recover_efi_commit_pass2,
>  };
>  
> +#ifdef CONFIG_XFS_RT
> +STATIC int
> +xlog_recover_rtefi_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	struct xfs_mount		*mp = log->l_mp;
> +	struct xfs_efi_log_item		*efip;
> +	struct xfs_efi_log_format	*efi_formatp;
> +	int				error;
> +
> +	efi_formatp = item->ri_buf[0].i_addr;
> +
> +	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> +				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
> +	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> +	if (error) {
> +		xfs_efi_item_free(efip);
> +		return error;
> +	}
> +	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> +
> +	xlog_recover_intent_item(log, &efip->efi_item, lsn,
> +			&xfs_rtextent_free_defer_type);
> +	return 0;
> +}
> +#else
> +STATIC int
> +xlog_recover_rtefi_commit_pass2(
> +	struct xlog			*log,
> +	struct list_head		*buffer_list,
> +	struct xlog_recover_item	*item,
> +	xfs_lsn_t			lsn)
> +{
> +	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
> +			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
> +	return -EFSCORRUPTED;

This needs to be a more meaningful error. It's not technically a
corruption - we recognised that an RTEFI is needing to be recovered,
but this kernel does not have RTEFI support compiled in. Hence the
error should be something along the lines of

"RTEFI found in journal, but kernel not compiled with CONFIG_XFS_RT enabled.
Cannot recover journal, please remount using a kernel with RT device
support enabled."

-Dave.

-- 
Dave Chinner
david@fromorbit.com
