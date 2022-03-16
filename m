Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5474C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 16:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbiCPQdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 12:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiCPQdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 12:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCEE6D4CB
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 09:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8466179A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CE0C340EC;
        Wed, 16 Mar 2022 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647448336;
        bh=qQuQnXYispiQjxGOBz4peKreY8hfbDw2h9E6CgPuXEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZYpb9+91ilEaGOeYgOA0V2EqIUzXilR4kqFuaCpyrFJhYl9RxNTjYgBMaEyEO6CF
         vYRIdrBvt2Ch2JQH7Wh2y/9bU4Qj1a9DG4tx52uxne9+ldKMixJesOxrQ/bp+B4TyI
         OcbOT7mvXWPQ54GWd0EYi7fzRWCgZdBSBUXvjY1Ix3X5I51opuMhr0QWtEAJpeNGrL
         SI8UG5xp9PCg43lpK6BF+3fYSbMWOcU/mvnc9yDDDknIXcf31dnJFMGs4YXOm2OutF
         BoMEABZb+djBfvEM0pu4wRxeby8ekxyg9uIQOtMNopAW81jbEvkGdYpOzUbZUOcF91
         eA8fMm5wD/RSg==
Date:   Wed, 16 Mar 2022 09:32:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220316163216.GU8224@magnolia>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjHJ0qOUnmAUEgoV@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 07:28:18AM -0400, Brian Foster wrote:
> On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_reserve_blocks controls the size of the user-visible free space
> > reserve pool.  Given the difference between the current and requested
> > pool sizes, it will try to reserve free space from fdblocks.  However,
> > the amount requested from fdblocks is also constrained by the amount of
> > space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> > reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> > 
> > In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> > out the "free space" used by the free space btrees, because some portion
> > of the free space btrees hold in reserve space for future btree
> > expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> > of blocks that it could request from xfs_mod_fdblocks was not updated to
> > include m_allocbt_blks, so if space is extremely low, the caller hangs.
> > 
> > Fix this by including m_allocbt_blks in the estimation, and modify the
> > loop so that it will not retry infinitely.
> > 
> > Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> > with an fstests configuration that specifies a 1k blocksize and a
> > specially crafted log size that will consume 7/8 of the space (17920
> > blocks, specifically) in that AG.
> > 
> > Cc: Brian Foster <bfoster@redhat.com>
> > Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 33e26690a8c4..78b6982ea5b0 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -379,6 +379,7 @@ xfs_reserve_blocks(
> >  	int64_t			fdblks_delta = 0;
> >  	uint64_t		request;
> >  	int64_t			free;
> > +	unsigned int		tries;
> >  	int			error = 0;
> >  
> >  	/* If inval is null, report current values and return */
> > @@ -432,9 +433,16 @@ xfs_reserve_blocks(
> >  	 * perform a partial reservation if the request exceeds free space.
> >  	 */
> >  	error = -ENOSPC;
> > -	do {
> > -		free = percpu_counter_sum(&mp->m_fdblocks) -
> > -						mp->m_alloc_set_aside;
> > +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
> 
> Any reason for the magic number of retries as opposed to perhaps just
> not retrying at all?

I /think/ the origins of the loop was commit dbcabad19aa9 ("[XFS] Fix
block reservation mechanism."), where I guess Dave decided that we
should loop forever trying to satisfy a request from userspace to
increase the reserve pool.  OFC you and I have been patching this
function to fix all its horrible warts over the years, so maybe you're
right that this should only try once...

(For the mount time default reservation, we should only iterate the loop
once (provided the accounting is correct ;) since nobody else is
touching the free space counters.)

> This seems a little odd when you think about it
> given that the request is already intended to take available space into
> account and modify the request from userspace. OTOH, another
> consideration could be to retry some (really large?) number of times and
> then bail out if we happen to iterate without an observable change in
> free space (i.e., something is wrong), however I suppose that could be
> racy as well. *shrug*

...but if you're the sysadmin desperately trying to increase the size of
the reserve pool when the fs is running near ENOSPC, you're going to be
racing with fdblocks bouncing up and down.  The @free samples that we
take here in the loop body are indeed racy since we can't tell the
difference between @free being unchanged from the last iteration because
someone freed a block and someone else immediately consumed it, or a
totally idle system.

Either way, it's better than hanging the whole system. :)

What if I augment the loop control with a comment capturing some of this:

	/*
	 * The loop body estimates how many blocks it can request from
	 * fdblocks to stash in the reserve pool.  This is a classic
	 * TOCTOU race since fdblocks updates are not always coordinated
	 * via m_sb_lock.  We also cannot tell if @free remaining
	 * unchanged between iterations is due to an idle system or
	 * freed blocks being consumed immediately, so we'll try a
	 * finite number of times to satisfy the request.
	 */
	for (tries = 0; tries < 30...) {

> 
> > +		/*
> > +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> > +		 * will not give us.  This includes the per-AG set-aside space
> > +		 * and free space btree blocks that are not available for
> > +		 * allocation due to per-AG metadata reservations.
> > +		 */
> > +		free = percpu_counter_sum(&mp->m_fdblocks);
> > +		free -= mp->m_alloc_set_aside;
> > +		free -= atomic64_read(&mp->m_allocbt_blks);
> 
> Seems reasonable. Do we want to consider ->m_allocbt_blks in other
> places where ->m_alloc_set_aside is used (i.e. xfs_fs_statfs(), etc.)?
> Not sure how much it matters for space reporting purposes, but if so, it
> might also be worth reconsidering the usefulness of a static field and
> initialization helper (i.e. xfs_alloc_set_aside()) if the majority of
> uses involve a dynamic calculation (due to ->m_allocbt_blks).

When I was writing this patch, I very nearly decided to make those three
lines above their own helper.  I didn't see any other spots that looked
like obvious candidates for such a calculation outside of statfs.

Subtracting m_allocbt_blks from statfs' avail field is a behavior
change, since we always used to consider bnobt blocks as available.  We
don't have an exact count of how many blocks are needed to hide the
per-ag reserved extents, so in the end we have to decide whether we want
to hear complaints about over- or under-estimation of available blocks.

So I think the statfs stuff is a separate patch. :)

--D

> 
> Brian
> 
> >  		if (free <= 0)
> >  			break;
> >  
> > @@ -459,7 +467,7 @@ xfs_reserve_blocks(
> >  		spin_unlock(&mp->m_sb_lock);
> >  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> >  		spin_lock(&mp->m_sb_lock);
> > -	} while (error == -ENOSPC);
> > +	}
> >  
> >  	/*
> >  	 * Update the reserve counters if blocks have been successfully
> > 
> 
