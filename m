Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:53901 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751274AbeAECK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 21:10:28 -0500
Date: Fri, 5 Jan 2018 13:10:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/21] xfs: catch a few more error codes when scrubbing
 secondary sb
Message-ID: <20180105021026.GY30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398978264.18741.5137794501763948676.stgit@magnolia>
 <20180105011714.GP30682@dastard>
 <20180105012410.GB5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105012410.GB5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 04, 2018 at 05:24:10PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 05, 2018 at 12:17:14PM +1100, Dave Chinner wrote:
> > On Fri, Dec 22, 2017 at 04:43:02PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > The superblock validation routines return a variety of error codes to
> > > reject a mount request.  For scrub we can assume that the mount
> > > succeeded, so if we see these things appear when scrubbing secondary sb
> > > X, we can treat them all like corruption.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/agheader.c |   16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > > index b599358..97beb47 100644
> > > --- a/fs/xfs/scrub/agheader.c
> > > +++ b/fs/xfs/scrub/agheader.c
> > > @@ -126,6 +126,22 @@ xfs_scrub_superblock(
> > >  	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > >  		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > >  		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > > +	/*
> > > +	 * The superblock verifier can return several different error codes
> > > +	 * if it thinks the superblock doesn't look right.  For a mount these
> > > +	 * would all get bounced back to userspace, but if we're here then the
> > > +	 * fs mounted successfully, which means that this secondary superblock
> > > +	 * is simply incorrect.  Treat all these codes the same way we treat
> > > +	 * any corruption.
> > > +	 */
> > > +	switch (error) {
> > > +	case -EINVAL:	/* also -EWRONGFS */
> > > +	case -ENOSYS:
> > > +	case -EFBIG:
> > > +		error = -EFSCORRUPTED;
> > > +	default:
> > > +		break;
> > > +	}
> > >  	if (!xfs_scrub_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
> > >  		return error;
> > 
> > Yes, this change looks fine, so
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > However, what I just realised is that the in-memory primary
> > superblock buffer that we do all our normal modification/logging
> > work on is an uncached buffer that accessed through xfs_getsb(), not
> > a cached buffer we access through xfs_trans_read_buf().
> > 
> > Does the scrub code take this into account?
> 
> We don't scrub the primary superblock at all, assuming that mount
> will reject bad superblocks for us, and we don't touch the primary
> superblock buffer at all, afaik.

No worries, I couldn't remember what it did here and didn't find an
obvious answer as I looked.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
