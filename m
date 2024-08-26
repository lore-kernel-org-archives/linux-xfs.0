Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735D62B9C5
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724701117; cv=none; b=WtN/2nhHKiF0r3ZZAkSWidDlBx24P/S9m8aWjvtLgc76JwKBHkNGa1kOnE1pDvP653rKv0gcyG8JxHkNd92FLspjfo1NerbCuXG4t2ESBfThfiOQS2ClRNEtIAPty+Q1F9SxMeuDMxx+6392owOiYnzWjRG/XG6sneDk9DC9sW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724701117; c=relaxed/simple;
	bh=2E3HukfSX/FmV9Kb4EolrR0aWbN/JwRSuF2QPgEAFB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbGd7AueTmucsWv41BjtvYqS4kKI5Dliz1b0V0cBuk1m7rjyYHKKO6lEVXEEDPYVaDmQPNkxGobhnFSZ1fRcu7qw0HO+csKPbdFMRIqt+583RytYGlNb+Ps/7OUaVePN6lImNa9rd7G7dyJkk76wfTO/DM1pAYQMmLfaj7k8Iyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azLwe2PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azLwe2PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D7DC8B7A3;
	Mon, 26 Aug 2024 19:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724701116;
	bh=2E3HukfSX/FmV9Kb4EolrR0aWbN/JwRSuF2QPgEAFB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=azLwe2PLNoaHhCXn8N7YXkFQ5qiy5k86FM6Wcjc32GjXfj5G4PT+pMOMyHhE7ydWP
	 P8LDu2GqIi75HOpMsBQX6U0VGDWTbPi689bhi9Y0SEeW7b/zKe/kJSps7xByEgitbz
	 xdTcGJdjkHKyYpfzipnDWlyUx2WeexV9wmxQLwoJ/hhax1S/HiAzXcgyY97HaFUfYT
	 r8jJtobP1Hj9Ctw65OGDvY0HhT0Q3S5vUzurBIjwXNnHaGNWb29EHQpFLPsnpsVkui
	 foY2p1dtXPBTEiF1tZ6HXV8HHGzQF2hOLK/M08zFAv1Psfg7gr4Qs6kJFlz1DQnRFt
	 xlf9/9GxZwoEg==
Date: Mon, 26 Aug 2024 12:38:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs: support logging EFIs for realtime extents
Message-ID: <20240826193835.GD865349@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088816.60592.12361252562494894102.stgit@frogsfrogsfrogs>
 <ZswFhKNrMh4I8QGm@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZswFhKNrMh4I8QGm@dread.disaster.area>

On Mon, Aug 26, 2024 at 02:33:08PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:25:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the EFI mechanism how to free realtime extents.  We're going to
> > need this to enforce proper ordering of operations when we enable
> > realtime rmap.
> > 
> > Declare a new log intent item type (XFS_LI_EFI_RT) and a separate defer
> > ops for rt extents.  This keeps the ondisk artifacts and processing code
> > completely separate between the rt and non-rt cases.  Hopefully this
> > will make it easier to debug filesystem problems.
> 
> Doesn't this now require busy extent tracking for rt extents that
> are being freed?  i.e. they get marked as free with the EFD, but
> cannot be reallocated (or discarded) until the EFD is committed to
> disk.
> 
> we don't allow user data allocation on the data device to reuse busy
> ranges because the freeing of the extent has not yet been committed
> to the journal. Because we use async transaction commits, that means
> we can return to userspace without even the EFI in the journal - it
> can still be in memory in the CIL. Hence we cannot allow userspace
> to reallocate that range and write to it, even though it is marked free in the
> in-memory metadata.

Ah, that's a good point -- in memory the bunmapi -> RTEFI -> RTEFD ->
rtalloc -> bmapi transactions succeed, userspace writes to the file
blocks, then the log goes down without completing /any/ of those
transactions, and now a read of the old file gets new contents.

> If userspace then does a write and then we crash without the
> original EFI on disk, then we've just violated metadata vs data
> update ordering because recovery will not replay the extent free nor
> the new allocation, yet the data in that extent will have been
> changed.
> 
> Hence I think that if we are moving to intent based freeing of real
> time extents, we absolutely need to add support for busy extent
> tracking to realtime groups before we enable EFIs on realtime
> groups.....

Yep.  As a fringe benefit, we'd be able to support issuing discards from
FITRIM without holding the rtbitmap lock, and -o discard on rt extents
too.

> Also ....
> 
> > @@ -447,6 +467,17 @@ xfs_extent_free_defer_add(
> >  
> >  	trace_xfs_extent_free_defer(mp, xefi);
> >  
> > +	if (xfs_efi_is_realtime(xefi)) {
> > +		xfs_rgnumber_t		rgno;
> > +
> > +		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
> > +		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
> > +
> > +		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
> > +				&xfs_rtextent_free_defer_type);
> > +		return;
> > +	}
> > +
> >  	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
> >  	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
> >  		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
> 
> Hmmmm. Isn't this also missing the xfs_drain intent interlocks that
> allow online repair to wait until all the intents outstanding on a
> group complete?

Yep.  I forgot about that.

> > @@ -687,6 +735,106 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
> >  	.relog_intent	= xfs_extent_free_relog_intent,
> >  };
> >  
> > +#ifdef CONFIG_XFS_RT
> > +/* Sort realtime efi items by rtgroup for efficiency. */
> > +static int
> > +xfs_rtextent_free_diff_items(
> > +	void				*priv,
> > +	const struct list_head		*a,
> > +	const struct list_head		*b)
> > +{
> > +	struct xfs_extent_free_item	*ra = xefi_entry(a);
> > +	struct xfs_extent_free_item	*rb = xefi_entry(b);
> > +
> > +	return ra->xefi_rtg->rtg_rgno - rb->xefi_rtg->rtg_rgno;
> > +}
> > +
> > +/* Create a realtime extent freeing */
> > +static struct xfs_log_item *
> > +xfs_rtextent_free_create_intent(
> > +	struct xfs_trans		*tp,
> > +	struct list_head		*items,
> > +	unsigned int			count,
> > +	bool				sort)
> > +{
> > +	struct xfs_mount		*mp = tp->t_mountp;
> > +	struct xfs_efi_log_item		*efip;
> > +	struct xfs_extent_free_item	*xefi;
> > +
> > +	ASSERT(count > 0);
> > +
> > +	efip = xfs_efi_init(mp, XFS_LI_EFI_RT, count);
> > +	if (sort)
> > +		list_sort(mp, items, xfs_rtextent_free_diff_items);
> > +	list_for_each_entry(xefi, items, xefi_list)
> > +		xfs_extent_free_log_item(tp, efip, xefi);
> > +	return &efip->efi_item;
> > +}
> 
> Hmmmm - when would we get an XFS_LI_EFI_RT with multiple extents in
> it? We only ever free a single user data extent per transaction at a
> time, right? There will be no metadata blocks being freed on the rt
> device - all the BMBT, refcountbt and rmapbt blocks that get freed
> as a result of freeing the user data extent will be in the data
> device and so will use EFIs, not EFI_RTs....

Later on when we get to reflink, a refcount decrement operation on an
extent that has a mix of single and multiple-owned blocks can generate
RTEFIs with multiple extents.

> > +
> > +/* Cancel a realtime extent freeing. */
> > +STATIC void
> > +xfs_rtextent_free_cancel_item(
> > +	struct list_head		*item)
> > +{
> > +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> > +
> > +	xfs_rtgroup_put(xefi->xefi_rtg);
> > +	kmem_cache_free(xfs_extfree_item_cache, xefi);
> > +}
> > +
> > +/* Process a free realtime extent. */
> > +STATIC int
> > +xfs_rtextent_free_finish_item(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_log_item		*done,
> > +	struct list_head		*item,
> > +	struct xfs_btree_cur		**state)
> 
> btree cursor ....
> 
> > +{
> > +	struct xfs_mount		*mp = tp->t_mountp;
> > +	struct xfs_extent_free_item	*xefi = xefi_entry(item);
> > +	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
> > +	struct xfs_rtgroup		**rtgp = (struct xfs_rtgroup **)state;
> 
> ... but is apparently holding a xfs_rtgroup. that's kinda nasty, and
> the rtg the xefi is supposed to be associated with is already held
> by the xefi, so....

It's very nasty, and I preferred when it was just a void**.  Maybe we
should just change that to a:

struct xfs_intent_item_state {
	struct xfs_btree_cur	*cur;
	struct xfs_rtgroup	*rtg;
};

and pass that around?  At least then the compiler can typecheck that for
us.

> > +	int				error = 0;
> > +
> > +	trace_xfs_extent_free_deferred(mp, xefi);
> > +
> > +	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
> > +		if (*rtgp != xefi->xefi_rtg) {
> > +			xfs_rtgroup_lock(xefi->xefi_rtg, XFS_RTGLOCK_BITMAP);
> > +			xfs_rtgroup_trans_join(tp, xefi->xefi_rtg,
> > +					XFS_RTGLOCK_BITMAP);
> > +			*rtgp = xefi->xefi_rtg;
> 
> How does this case happen? Why is it safe to lock the xefi rtg
> here, and why are we returning the xefi rtg to the caller without
> taking extra references or dropping the rtg the caller passed in?
> 
> At least a comment explaining what is happening is necessary here...

Hmm, I wonder when /is/ this possible?  I don't think it can actually
happen ... except maybe in the case of a bunmapi where we pass in a
large bmbt_irec array?  Let me investigate...

The locks and ijoins will be dropped at transaction commit.

> > +		}
> > +		error = xfs_rtfree_blocks(tp, xefi->xefi_rtg,
> > +				xefi->xefi_startblock, xefi->xefi_blockcount);
> > +	}
> > +	if (error == -EAGAIN) {
> > +		xfs_efd_from_efi(efdp);
> > +		return error;
> > +	}
> > +
> > +	xfs_efd_add_extent(efdp, xefi);
> > +	xfs_rtextent_free_cancel_item(item);
> > +	return error;
> > +}
> > +
> > +const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
> > +	.name		= "rtextent_free",
> > +	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
> > +	.create_intent	= xfs_rtextent_free_create_intent,
> > +	.abort_intent	= xfs_extent_free_abort_intent,
> > +	.create_done	= xfs_extent_free_create_done,
> > +	.finish_item	= xfs_rtextent_free_finish_item,
> > +	.cancel_item	= xfs_rtextent_free_cancel_item,
> > +	.recover_work	= xfs_extent_free_recover_work,
> > +	.relog_intent	= xfs_extent_free_relog_intent,
> > +};
> > +#else
> > +const struct xfs_defer_op_type xfs_rtextent_free_defer_type = {
> > +	.name		= "rtextent_free",
> > +};
> > +#endif /* CONFIG_XFS_RT */
> > +
> >  STATIC bool
> >  xfs_efi_item_match(
> >  	struct xfs_log_item	*lip,
> > @@ -731,7 +879,7 @@ xlog_recover_efi_commit_pass2(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > -	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> > +	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
> >  	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> >  	if (error) {
> >  		xfs_efi_item_free(efip);
> > @@ -749,6 +897,58 @@ const struct xlog_recover_item_ops xlog_efi_item_ops = {
> >  	.commit_pass2		= xlog_recover_efi_commit_pass2,
> >  };
> >  
> > +#ifdef CONFIG_XFS_RT
> > +STATIC int
> > +xlog_recover_rtefi_commit_pass2(
> > +	struct xlog			*log,
> > +	struct list_head		*buffer_list,
> > +	struct xlog_recover_item	*item,
> > +	xfs_lsn_t			lsn)
> > +{
> > +	struct xfs_mount		*mp = log->l_mp;
> > +	struct xfs_efi_log_item		*efip;
> > +	struct xfs_efi_log_format	*efi_formatp;
> > +	int				error;
> > +
> > +	efi_formatp = item->ri_buf[0].i_addr;
> > +
> > +	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
> > +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > +				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> > +	efip = xfs_efi_init(mp, ITEM_TYPE(item), efi_formatp->efi_nextents);
> > +	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> > +	if (error) {
> > +		xfs_efi_item_free(efip);
> > +		return error;
> > +	}
> > +	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> > +
> > +	xlog_recover_intent_item(log, &efip->efi_item, lsn,
> > +			&xfs_rtextent_free_defer_type);
> > +	return 0;
> > +}
> > +#else
> > +STATIC int
> > +xlog_recover_rtefi_commit_pass2(
> > +	struct xlog			*log,
> > +	struct list_head		*buffer_list,
> > +	struct xlog_recover_item	*item,
> > +	xfs_lsn_t			lsn)
> > +{
> > +	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
> > +			item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
> > +	return -EFSCORRUPTED;
> 
> This needs to be a more meaningful error. It's not technically a
> corruption - we recognised that an RTEFI is needing to be recovered,
> but this kernel does not have RTEFI support compiled in. Hence the
> error should be something along the lines of
> 
> "RTEFI found in journal, but kernel not compiled with CONFIG_XFS_RT enabled.
> Cannot recover journal, please remount using a kernel with RT device
> support enabled."

Ok.  That should probably get applied to the RTRUI and RTCUI recovery
stubs too.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
