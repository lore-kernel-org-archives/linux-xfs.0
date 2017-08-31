Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6220 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbdHaWTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 18:19:55 -0400
Date: Fri, 1 Sep 2017 08:19:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831221951.GR10621@dastard>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831064033.GF3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 11:40:33PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 30, 2017 at 04:54:00PM +0200, Christoph Hellwig wrote:
> > But reject reflink + DAX file systems for now until the code to
> > support reflinks on DAX is actually implemented.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_super.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 38aaacdbb8b3..92521032468e 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1634,7 +1634,9 @@ xfs_fs_fill_super(
> >  		}
> >  		if (xfs_sb_version_hasreflink(&mp->m_sb))
> >  			xfs_alert(mp,
> > -		"DAX and reflink have not been tested together!");
> > +		"DAX and reflink can not be used together!");
> > +			error = -EINVAL;
> > +			goto out_filestream_unmount;
> 
> /This/ hunk seems fine, but...
> 
> >  	}
> >  
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > @@ -1648,10 +1650,6 @@ xfs_fs_fill_super(
> >  	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
> >  	}
> >  
> > -	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > -		xfs_alert(mp,
> > -	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
> > -
> 
> ...I frankly would rather wait until we land and stabilize the incore
> extent rework, because I'd rather not have the reflink story be: 1) we
> declare reflink stable in 4.14; 2) immediately people start loading up
> XFSes with sparse VM images that blow up on high order allocations and
> then 3) we get a whole lot of complaints about it.  Then in 4.15 we 4)
> land the incore extent map only now we're dragging those same users
> through the mud while /that/ stabilizes, with the result 5) that
> everyone thinks we've gone off the deep end and doesn't trust us
> anymore.

Which is a lose-lose proposition. IOWs, to be avoided at all costs.

> I wish that didn't also mean waiting another 6 months for something that
> none of us /developers/ have seen in practice,

Oh, I've seen it plenty of times in practice. Restoring large
metadumps with (tens of) millions of tiny extents is the common
cause for me.

> especially since the
> enterprise distros will have plenty of time to backport all this stuff
> before their next big releases if it /does/ become a problem.  It's fine
> enough for me (and Christoph's customers, evidently) but is that enough?

FYI, this has been a problem on RHEL for a long time. It's a long
standing, well known problem and that's one of the reasons why
it's at the top of my list to fix right now.

> <shrug> Not sure what to do about my own fear factor. :)  Anyone want to
> offer further comments?  A quick git history trip says sparse inodes
> took about 13 months to go from initial commit to EXPERIMENTAL removed?

I always aimed to remove the experimental tag 4 kernel releases
after the initial merge, assuming testing and required functionality
was all there and complete early on in the stabilisation process.
Generally I had a set of criteria that needed to be fulfilled before
I'd remove the tag, and ticked them off as fixes were merged.

e.g.  CRCs were introduced in 3.10, the experimental tag was removed
in 3.15, so 5 releases in that case. We didn't get CRCs working
sanely until 3.11 and there was still a lot of userspace stuff that
lagged (and having a fully working userspace was a criteria for
removing experimental from the kernel code), so it took longer to
stabilise than something smaller like sparse inodes.

Fixing the extent list memory allocation problem was always
something on my list of "need to fix before reflink can be deployed
in anger", so I'd much prefer that we are conservative in removing
the experimental tag. It doesn't hurt anyone if we keep it on until
we get the extent tree rework merged, and it's better to err on the
side of keeping it too long than not long enough.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
