Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21498 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752862AbeBOWO6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 17:14:58 -0500
Date: Fri, 16 Feb 2018 09:10:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: make imaxpct changes in growfs separate
Message-ID: <20180215221017.GR7000@dastard>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-6-david@fromorbit.com>
 <20180209161143.GB21413@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180209161143.GB21413@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 09, 2018 at 11:11:43AM -0500, Brian Foster wrote:
> On Thu, Feb 01, 2018 at 05:42:00PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When growfs changes the imaxpct value of the filesystem, it runs
> > through all the "change size" growfs code, whether it needs to or
> > not. Separate out changing imaxpct into it's own function and
> > transaction to simplify the rest of the growfs code.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 67 +++++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 49 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 94650b7d517e..5c844e540320 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> ...
> > @@ -673,25 +661,68 @@ xfs_growfs_log_private(
> ...
> >  int
> >  xfs_growfs_data(
> > -	xfs_mount_t		*mp,
> > -	xfs_growfs_data_t	*in)
> > +	struct xfs_mount	*mp,
> > +	struct xfs_growfs_data	*in)
> >  {
> > -	int error;
> > +	int			error = 0;
> >  
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EPERM;
> >  	if (!mutex_trylock(&mp->m_growlock))
> >  		return -EWOULDBLOCK;
> > +
> > +	/* update imaxpct seperately to the physical grow of the filesystem */
> 
> separately
> 
> > +	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
> > +		error = xfs_growfs_imaxpct(mp, in->imaxpct);
> > +		if (error)
> > +			goto out_error;
> > +	}
> > +
> >  	error = xfs_growfs_data_private(mp, in);
> > +	if (error)
> > +		goto out_error;
> 
> The 'xfs_growfs -m <maxpct>' use case typically doesn't involve a size
> change. With this change, there's no reason to run through
> xfs_growfs_data_private() if in.newblocks == mp->m_sb.sb_dblocks, right?

Yeah, we can probably do that. I hadn't done that because those
checks (and much more complex ones like a runt last AG) were
already in the xfs_growfs_data_private() code.

> Otherwise this seems fine.

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
