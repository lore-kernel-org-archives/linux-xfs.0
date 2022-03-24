Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B8DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 05:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbiCXF0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 01:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCXF0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 01:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E262939BA
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 22:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9890260A56;
        Thu, 24 Mar 2022 05:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03FBC340EC;
        Thu, 24 Mar 2022 05:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648099470;
        bh=yTttBokpLAiVFeWg7ukJDuK3yZ3MpX6DE9wfuL3GXds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PhdMWv7ZRkyhT2jqnkN22zAquT5nAP5Ps9wnfy75y51kbApgU+b++s7JkcPyzTKTT
         ORE/eH8+ADPQVPFEWNRsowqAQPXtqQJWgs9p86zdeILwalshrhNKCWoR91GLTjbcIt
         vhgs2UXww444mMGzsBjmTsFhHobjs+Bd1CF54SMjhCTmjWtAWm+aiYjCyBcuLv2mCx
         ZetAPNQoVytmFSqeFtbC2pxTDWvoL57fHLnuUrmJU7S5z4Y9Gpe/BFGnH20PxhGNNK
         sXu3OK27/bjyxnjyTgNTVPFX9SQpsT2Ut4gKXDhRA3CzEShWNkBkTrBOz84Xh8np35
         F1ywzhrkQp5DA==
Date:   Wed, 23 Mar 2022 22:24:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>, g@magnolia
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
Message-ID: <20220324052429.GS8241@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462946.550479.3987400627869935198.stgit@magnolia>
 <20220323211147.GX1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323211147.GX1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 08:11:47AM +1100, Dave Chinner wrote:
> On Sun, Mar 20, 2022 at 09:43:49AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't spin in an infinite loop trying to reserve blocks -- if we can't
> > do it after 30 tries, we're racing with a nearly full filesystem, so
> > just give up.
> > 
> > Cc: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c |   12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 710e857bb825..615334e4f689 100644
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
> > @@ -430,9 +431,16 @@ xfs_reserve_blocks(
> >  	 * If the request is larger than the current reservation, reserve the
> >  	 * blocks before we update the reserve counters. Sample m_fdblocks and
> >  	 * perform a partial reservation if the request exceeds free space.
> > +	 *
> > +	 * The loop body estimates how many blocks it can request from fdblocks
> > +	 * to stash in the reserve pool.  This is a classic TOCTOU race since
> > +	 * fdblocks updates are not always coordinated via m_sb_lock.  We also
> > +	 * cannot tell if @free remaining unchanged between iterations is due
> > +	 * to an idle system or freed blocks being consumed immediately, so
> > +	 * we'll try a finite number of times to satisfy the request.
> >  	 */
> >  	error = -ENOSPC;
> > -	do {
> > +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
> >  		free = percpu_counter_sum(&mp->m_fdblocks) -
> >  						xfs_fdblocks_unavailable(mp);
> >  		if (free <= 0)
> > @@ -459,7 +467,7 @@ xfs_reserve_blocks(
> >  		spin_unlock(&mp->m_sb_lock);
> >  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> >  		spin_lock(&mp->m_sb_lock);
> > -	} while (error == -ENOSPC);
> > +	}
> 
> So the problem here is that if we don't get all of the reservation,
> we get none of it, so we try again. This seems like we should simply
> punch the error back out to userspace and let it retry rather than
> try a few times and then fail anyway. Either way, userspace has to
> handle failure to reserve enough blocks.
> 
> The other alternative here is that we just change the reserve block
> limit when ENOSPC occurs and allow the xfs_mod_fdblocks() refill
> code just fill up the pool as space is freed. That would greatly
> simplify the code - we do a single attempt to reserve the new space,
> and if it fails we don't care because the reserve space gets
> refilled before free space is made available again.  I think that's
> preferable to having an arbitrary number of retries like this that's
> going to end up failing anyway.

How about I try the following tomorrow?

spin_lock(...);
mp->m_resblks = request;
free = percpu_counter_sum(&mp->m_fdblocks) - xfs_fdblocks_unavailable(mp);
if (request < mp->m_resblks_avail && free > 0) {
	ask = min(request - mp->m_resblks_avail, free);

	spin_unlock(...);
	error = xfs_mod_fdblocks(mp, -ask, 0);
	spin_lock(...);

	if (!error)
		mp->m_resblks_avail += ask;
}
spin_unlock(...);
return error;

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
