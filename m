Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:10124 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756177AbcLAUW3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 15:22:29 -0500
Date: Fri, 2 Dec 2016 07:20:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: deprecate barrier/nobarrier mount option
Message-ID: <20161201202006.GG11750@dastard>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-3-david@fromorbit.com>
 <20161201124745.GE22890@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201124745.GE22890@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 07:47:46AM -0500, Brian Foster wrote:
> On Thu, Dec 01, 2016 at 09:54:44AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We always perform integrity operations now, so these mount options
> > don't do anything. Deprecate them and mark them for removal in
> > in a year.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  Documentation/filesystems/xfs.txt | 12 ++++--------
> >  fs/xfs/xfs_super.c                | 25 ++++++++++++++++---------
> >  2 files changed, 20 insertions(+), 17 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 563d1d146b8c..eecbaac08eba 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -374,6 +371,14 @@ xfs_parseargs(
> >  			mp->m_flags |= XFS_MOUNT_DAX;
> >  			break;
> >  #endif
> > +		case Opt_barrier:
> > +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> > +			mp->m_flags |= XFS_MOUNT_BARRIER;
> > +			break;
> > +		case Opt_nobarrier:
> > +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> > +			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> > +			break;
> 
> So basically XFS_MOUNT_BARRIER exists solely for the purpose of
> showargs. Should we just kill it too and do something deterministic on
> showargs (i.e., always show 'barrier' or just drop it entirely), or does
> precedent suggest otherwise?

Well, they are deprecated and ignored, but we can't remove them
straight away so I thought we should still report them appropriately
in showargs.

I don't really care either way - I can kill it completely if
you think that's better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
