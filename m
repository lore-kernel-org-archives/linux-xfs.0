Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF22C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 21:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbiCRVCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 17:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiCRVCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BEE2DF3D5
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 14:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DDA4610E7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 21:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B5AC340F4;
        Fri, 18 Mar 2022 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637260;
        bh=yD+WAZ54Bbs3V6H7aIaog8hiHrhQFKwdYrSAj2QBkUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cvwPJkp4kD7h76GWbKuWusj+kgBVefZKWbfO5T1xPVGlzBuD8B3b4IK6Cka7x4i8k
         S//TqYt+RzJYlwt0YpQzxzfUhugF4ViB0Fl01IJWhWP7xw6sudF7Sr9qnazBe1hcV+
         k/tUO0aaIlOVXMiXTyZdhM1QeBjt9iVrAlQ0yfKAWjwQqhqy7ldy9l+l0rDrpZboKe
         dLooHiSg7UmYWC9JHDLiYm71HFEVMjQBC7deExYzzIrcPJreLIn9G5uRyzce/YjvHu
         223qp3L76AUAq/akd9q24WxlXto5Wnw+1Aj4ly1Y7hy7I7AnpuYsS635vo91XnZqxu
         vCQr9oGMebKNg==
Date:   Fri, 18 Mar 2022 14:01:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220318210100.GE8224@magnolia>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755207216.4194202.19795257360716142.stgit@magnolia>
 <YjR4nWL9RXOq1mDi@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjR4nWL9RXOq1mDi@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 08:18:37AM -0400, Brian Foster wrote:
> On Thu, Mar 17, 2022 at 02:21:12PM -0700, Darrick J. Wong wrote:
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
> > Fix this by creating a function to estimate the number of blocks that
> > can be reserved from fdblocks, which needs to exclude the set-aside and
> > m_allocbt_blks.
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
> >  fs/xfs/xfs_fsops.c |    7 +++++--
> >  fs/xfs/xfs_mount.h |   29 +++++++++++++++++++++++++++++
> >  2 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 33e26690a8c4..b71799a3acd3 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -433,8 +433,11 @@ xfs_reserve_blocks(
> >  	 */
> >  	error = -ENOSPC;
> >  	do {
> > -		free = percpu_counter_sum(&mp->m_fdblocks) -
> > -						mp->m_alloc_set_aside;
> > +		/*
> > +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> > +		 * will not give us.
> > +		 */
> 
> This comment seems unnecessary. I'm not sure what this is telling that
> the code doesn't already..?

Yeah, I'll get rid of it.

> > +		free = xfs_fdblocks_available(mp);
> >  		if (free <= 0)
> >  			break;
> >  
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 00720a02e761..998b54c3c454 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -479,6 +479,35 @@ extern void	xfs_unmountfs(xfs_mount_t *);
> >   */
> >  #define XFS_FDBLOCKS_BATCH	1024
> >  
> > +/*
> > + * Estimate the amount of space that xfs_mod_fdblocks might give us without
> > + * drawing from the reservation pool.  In other words, estimate the free space
> > + * that is available to userspace.
> > + *
> > + * This quantity is the amount of free space tracked in the on-disk metadata
> > + * minus:
> > + *
> > + * - Delayed allocation reservations
> > + * - Per-AG space reservations to guarantee metadata expansion
> > + * - Userspace-controlled free space reserve pool
> > + *
> > + * - Space reserved to ensure that we can always split a bmap btree
> > + * - Free space btree blocks that are not available for allocation due to
> > + *   per-AG metadata reservations
> > + *
> > + * The first three are captured in the incore fdblocks counter.
> > + */
> 
> Hm. Sometimes I wonder if we overdocument things to our own detriment
> (reading back my own comments at times suggests I'm terrible at this).
> So do we really need to document what other internal reservations are or
> are not taken out of ->m_fdblocks here..? I suspect we already have
> plenty of sufficient documentation for things like perag res colocated
> with the actual code, such that this kind of thing just creates an
> external reference that will probably just bitrot as years go by. Can we
> reduce this down to just explain how/why this helper has to calculate a
> block availability value for blocks that otherwise haven't been
> explicitly allocated out of the in-core free block counters?

Hmm.  I suppose I could reduce the comment at the same time that I split
out the code that computes the amount of free space that isn't
available.

> > +static inline int64_t
> > +xfs_fdblocks_available(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int64_t			free = percpu_counter_sum(&mp->m_fdblocks);
> > +
> > +	free -= mp->m_alloc_set_aside;
> > +	free -= atomic64_read(&mp->m_allocbt_blks);
> > +	return free;
> > +}
> > +
> 
> FWIW the helper seems fine in context, but will this help us avoid the
> duplicate calculation in xfs_mod_fdblocks(), for instance?

It will once I turn that into:


/*
 * Estimate the amount of free space that is not available to userspace
 * and is not explicitly reserved from the incore fdblocks:
 *
 * - Space reserved to ensure that we can always split a bmap btree
 * - Free space btree blocks that are not available for allocation due
 *   to per-AG metadata reservations
 */
static inline uint64_t
xfs_fdblocks_unavailable(
	struct xfs_mount	*mp)
{
	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
}

/*
 * Estimate the amount of space that xfs_mod_fdblocks might give us
 * without drawing from any reservation pool.  In other words, estimate
 * the free space that is available to userspace.
 */
static inline int64_t
xfs_fdblocks_available(
	struct xfs_mount	*mp)
{
	return percpu_counter_sum(&mp->m_fdblocks) -
			xfs_fdblocks_unavailable(mp);
}

--D

> 
> Brian
> 
> >  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> >  				 bool reserved);
> >  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> > 
> 
