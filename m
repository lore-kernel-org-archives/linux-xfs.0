Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEC9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 06:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbiCXGWm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 02:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345058AbiCXGWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 02:22:41 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E00189681C
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 23:21:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A783E10E51DC;
        Thu, 24 Mar 2022 17:21:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXGqH-009Cfh-Ki; Thu, 24 Mar 2022 17:21:05 +1100
Date:   Thu, 24 Mar 2022 17:21:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     g@magnolia, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
Message-ID: <20220324062105.GD1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462946.550479.3987400627869935198.stgit@magnolia>
 <20220323211147.GX1544202@dread.disaster.area>
 <20220324052429.GS8241@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324052429.GS8241@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623c0dd5
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=TY2J1IYYQtW4xuwXge0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 10:24:29PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 24, 2022 at 08:11:47AM +1100, Dave Chinner wrote:
> > On Sun, Mar 20, 2022 at 09:43:49AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Don't spin in an infinite loop trying to reserve blocks -- if we can't
> > > do it after 30 tries, we're racing with a nearly full filesystem, so
> > > just give up.
> > > 
> > > Cc: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_fsops.c |   12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 710e857bb825..615334e4f689 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -379,6 +379,7 @@ xfs_reserve_blocks(
> > >  	int64_t			fdblks_delta = 0;
> > >  	uint64_t		request;
> > >  	int64_t			free;
> > > +	unsigned int		tries;
> > >  	int			error = 0;
> > >  
> > >  	/* If inval is null, report current values and return */
> > > @@ -430,9 +431,16 @@ xfs_reserve_blocks(
> > >  	 * If the request is larger than the current reservation, reserve the
> > >  	 * blocks before we update the reserve counters. Sample m_fdblocks and
> > >  	 * perform a partial reservation if the request exceeds free space.
> > > +	 *
> > > +	 * The loop body estimates how many blocks it can request from fdblocks
> > > +	 * to stash in the reserve pool.  This is a classic TOCTOU race since
> > > +	 * fdblocks updates are not always coordinated via m_sb_lock.  We also
> > > +	 * cannot tell if @free remaining unchanged between iterations is due
> > > +	 * to an idle system or freed blocks being consumed immediately, so
> > > +	 * we'll try a finite number of times to satisfy the request.
> > >  	 */
> > >  	error = -ENOSPC;
> > > -	do {
> > > +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
> > >  		free = percpu_counter_sum(&mp->m_fdblocks) -
> > >  						xfs_fdblocks_unavailable(mp);
> > >  		if (free <= 0)
> > > @@ -459,7 +467,7 @@ xfs_reserve_blocks(
> > >  		spin_unlock(&mp->m_sb_lock);
> > >  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> > >  		spin_lock(&mp->m_sb_lock);
> > > -	} while (error == -ENOSPC);
> > > +	}
> > 
> > So the problem here is that if we don't get all of the reservation,
> > we get none of it, so we try again. This seems like we should simply
> > punch the error back out to userspace and let it retry rather than
> > try a few times and then fail anyway. Either way, userspace has to
> > handle failure to reserve enough blocks.
> > 
> > The other alternative here is that we just change the reserve block
> > limit when ENOSPC occurs and allow the xfs_mod_fdblocks() refill
> > code just fill up the pool as space is freed. That would greatly
> > simplify the code - we do a single attempt to reserve the new space,
> > and if it fails we don't care because the reserve space gets
> > refilled before free space is made available again.  I think that's
> > preferable to having an arbitrary number of retries like this that's
> > going to end up failing anyway.
> 
> How about I try the following tomorrow?
> 
> spin_lock(...);
> mp->m_resblks = request;
> free = percpu_counter_sum(&mp->m_fdblocks) - xfs_fdblocks_unavailable(mp);
> if (request < mp->m_resblks_avail && free > 0) {
              >

> 	ask = min(request - mp->m_resblks_avail, free);
> 
> 	spin_unlock(...);
> 	error = xfs_mod_fdblocks(mp, -ask, 0);
> 	spin_lock(...);
> 
> 	if (!error)
> 		mp->m_resblks_avail += ask;
> }
> spin_unlock(...);
> return error;

Yeah, I think that's fine, though I think that to ensure things
end up as correct as possible:

	spin_unlock(...);
	error = xfs_mod_fdblocks(mp, -ask, 0);
	if (!error)
		xfs_mod_fdblocks(mp, ask, 0);

because if we are racing with other operations, the second
xfs_mod_fdblocks() call will put as much of @ask as needed back on
the resblks counter, and put any left over back on the percpu
counter....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
