Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966392AbeBPMb1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Feb 2018 07:31:27 -0500
Date: Fri, 16 Feb 2018 07:31:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: separate secondary sb update in growfs
Message-ID: <20180216123125.GA53090@bfoster.bfoster>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-7-david@fromorbit.com>
 <20180209161153.GC21413@bfoster.bfoster>
 <20180215222358.GS7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180215222358.GS7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 16, 2018 at 09:23:58AM +1100, Dave Chinner wrote:
> On Fri, Feb 09, 2018 at 11:11:54AM -0500, Brian Foster wrote:
> > On Thu, Feb 01, 2018 at 05:42:01PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > This happens after all the transactions to update the superblock
> > > occur, and errors need to be handled slightly differently. Seperate
> > 
> > Separate
> > 
> > > out the code into it's own function, and clean up the error goto
> > > stack in the core growfs code as it is now much simpler.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_fsops.c | 154 ++++++++++++++++++++++++++++++-----------------------
> > >  1 file changed, 87 insertions(+), 67 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 5c844e540320..113be7dbdc81 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > ...
> > > @@ -572,16 +572,79 @@ xfs_growfs_data_private(
> > >  		error = xfs_ag_resv_free(pag);
> > >  		xfs_perag_put(pag);
> > >  		if (error)
> > > -			goto out;
> > > +			return error;
> > >  	}
> > >  
> > >  	/* Reserve AG metadata blocks. */
> > > -	error = xfs_fs_reserve_ag_blocks(mp);
> > > -	if (error && error != -ENOSPC)
> > > -		goto out;
> > > +	return xfs_fs_reserve_ag_blocks(mp);
> > 
> > It looks like we change the semantics of -ENOSPC during perag
> > reservation init. No mention of whether this is intentional and/or
> > why..?
> 
> Not sure what I changed here - it just returns the error to the
> caller because it's no longer going to jump over code after
> xfs_fs_reserve_ag_blocks(mp) has already shut down the filesystem
> (which it does on any error other than ENOSPC).
> 

It the semantics of -ENOSPC (i.e., how that error is/was specially
handled) that looked different..

> Perhaps....
> 
> > > @@ -694,6 +707,7 @@ xfs_growfs_data(
> > >  	struct xfs_mount	*mp,
> > >  	struct xfs_growfs_data	*in)
> > >  {
> > > +	xfs_agnumber_t		oagcount;
> > >  	int			error = 0;
> > >  
> > >  	if (!capable(CAP_SYS_ADMIN))
> > > @@ -708,6 +722,7 @@ xfs_growfs_data(
> > >  			goto out_error;
> > >  	}
> > >  
> > > +	oagcount = mp->m_sb.sb_agcount;
> > >  	error = xfs_growfs_data_private(mp, in);
> > >  	if (error)
> > >  		goto out_error;
> 
> .... you are commenting on this code here, were ENOSPC is not
> specially handled to all the superblocks to be updated even if we
> got an ENOSPC on data-grow?
> 

Not sure I parse that...

> > > @@ -722,6 +737,11 @@ xfs_growfs_data(
> > >  	} else
> > >  		mp->m_maxicount = 0;
> > >  
> > > +	/*
> > > +	 * Update secondary superblocks now the physical grow has completed
> > > +	 */
> > > +	error = xfs_growfs_update_superblocks(mp, oagcount);
> > > +
> 
> i.e. it doesn't run this at ENOSPC now?
> 

... but yeah, this I think, taking a quick look back.

Essentially it looked like -ENOSPC from the perag res init currently
does not result in a growfs operation error. We'd simply move on to the
next step and the growfs may very well return success. Here, it looks
like we've changed behavior to return -ENOSPC to userspace (without any
explanation).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
