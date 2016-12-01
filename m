Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753128AbcLAVbK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 16:31:10 -0500
Date: Thu, 1 Dec 2016 16:31:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: deprecate barrier/nobarrier mount option
Message-ID: <20161201213107.GA59700@bfoster.bfoster>
References: <20161130225444.15869-1-david@fromorbit.com>
 <20161130225444.15869-3-david@fromorbit.com>
 <20161201124745.GE22890@bfoster.bfoster>
 <20161201202006.GG11750@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201202006.GG11750@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2016 at 07:20:06AM +1100, Dave Chinner wrote:
> On Thu, Dec 01, 2016 at 07:47:46AM -0500, Brian Foster wrote:
> > On Thu, Dec 01, 2016 at 09:54:44AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We always perform integrity operations now, so these mount options
> > > don't do anything. Deprecate them and mark them for removal in
> > > in a year.
> > > 
> > > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  Documentation/filesystems/xfs.txt | 12 ++++--------
> > >  fs/xfs/xfs_super.c                | 25 ++++++++++++++++---------
> > >  2 files changed, 20 insertions(+), 17 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 563d1d146b8c..eecbaac08eba 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > ...
> > > @@ -374,6 +371,14 @@ xfs_parseargs(
> > >  			mp->m_flags |= XFS_MOUNT_DAX;
> > >  			break;
> > >  #endif
> > > +		case Opt_barrier:
> > > +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> > > +			mp->m_flags |= XFS_MOUNT_BARRIER;
> > > +			break;
> > > +		case Opt_nobarrier:
> > > +			xfs_warn(mp, "%s option is deprecated, ignoring.", p);
> > > +			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> > > +			break;
> > 
> > So basically XFS_MOUNT_BARRIER exists solely for the purpose of
> > showargs. Should we just kill it too and do something deterministic on
> > showargs (i.e., always show 'barrier' or just drop it entirely), or does
> > precedent suggest otherwise?
> 
> Well, they are deprecated and ignored, but we can't remove them
> straight away so I thought we should still report them appropriately
> in showargs.
> 
> I don't really care either way - I can kill it completely if
> you think that's better.
> 

Ok. No major preference.. my first instinct was just to see it all
killed off to explicitly show that the mount option has no effect.
Either way is fine, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
