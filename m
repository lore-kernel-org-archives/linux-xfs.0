Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752390AbeEHMfd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 08:35:33 -0400
Date: Tue, 8 May 2018 08:35:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: skip online discard during eofblocks trims
Message-ID: <20180508123532.GC4764@bfoster.bfoster>
References: <20180507181138.43250-1-bfoster@redhat.com>
 <20180507181138.43250-3-bfoster@redhat.com>
 <20180507233819.GJ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507233819.GJ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 09:38:19AM +1000, Dave Chinner wrote:
> On Mon, May 07, 2018 at 02:11:36PM -0400, Brian Foster wrote:
> > We've had reports of online discard operations being sent from XFS
> > on write-only workloads. These discards occur as a result of
> > eofblocks trims that can occur after a large file copy completes.
> > 
> > These discards are slightly confusing for users who might be paying
> > close attention to online discards (i.e., vdo) due to performance
> > sensitivity. They also happen to be spurious because freed post-eof
> > blocks by definition have not been written to during the current
> > allocation cycle.
> > 
> > Update xfs_free_eofblocks() to skip discards that are purely
> > attributed to eofblocks trims. This cuts down the number of spurious
> > discards that may occur on write-only workloads due to normal
> > preallocation activity.
> > 
> > Note that discards of post-eof extents can still occur from other
> > codepaths that do not isolate handling of post-eof blocks from those
> > within eof. For example, file unlinks and truncates may still cause
> > discards for any file blocks affected by the operation.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_attr_inactive.c |  3 ++-
> >  fs/xfs/xfs_bmap_util.c     |  2 +-
> >  fs/xfs/xfs_inode.c         | 11 ++++++++---
> >  fs/xfs/xfs_inode.h         |  2 +-
> >  fs/xfs/xfs_iops.c          |  3 ++-
> >  fs/xfs/xfs_qm_syscalls.c   |  2 +-
> >  6 files changed, 15 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index 52818ea2eb50..639311e60c5d 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -434,7 +434,8 @@ xfs_attr_inactive(
> >  		if (error)
> >  			goto out_cancel;
> >  
> > -		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
> > +		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0,
> > +					      false);
> >  		if (error)
> >  			goto out_cancel;
> >  	}
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 8cd8c412f52d..7b95d8976488 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -872,7 +872,7 @@ xfs_free_eofblocks(
> >  		 * may be full of holes (ie NULL files bug).
> >  		 */
> >  		error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK,
> > -					      XFS_ISIZE(ip));
> > +					      XFS_ISIZE(ip), true);
> 
> xfs_itruncate_extents_nodiscard(), and then all the other
> xfs_itruncate_extents() can remain unchanged.
> 

Oops, yeah.. I'll apply the same wrapper factoring approach here.

> >  		if (error) {
> >  			/*
> >  			 * If we get an error at this point we simply don't
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2b70c8b4cee2..03b2b7099f90 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1538,7 +1538,8 @@ xfs_itruncate_extents(
> >  	struct xfs_trans	**tpp,
> >  	struct xfs_inode	*ip,
> >  	int			whichfork,
> > -	xfs_fsize_t		new_size)
> > +	xfs_fsize_t		new_size,
> > +	bool			skip_discard)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_trans	*tp = *tpp;
> > @@ -1549,6 +1550,7 @@ xfs_itruncate_extents(
> >  	xfs_filblks_t		unmap_len;
> >  	int			error = 0;
> >  	int			done = 0;
> > +	int			flags = 0;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >  	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> > @@ -1561,6 +1563,9 @@ xfs_itruncate_extents(
> >  
> >  	trace_xfs_itruncate_extents_start(ip, new_size);
> >  
> > +	if (skip_discard)
> > +		flags |= XFS_BMAPI_NODISCARD;
> > +
> 
> 	flags = xfs_bmapi_aflag(whichfork);
> 	if (skip_discard)
> 		flags |= XFS_BMAPI_NODISCARD;
> 
> >  	/*
> >  	 * Since it is possible for space to become allocated beyond
> >  	 * the end of the file (in a crash where the space is allocated
> > @@ -1581,7 +1586,7 @@ xfs_itruncate_extents(
> >  		xfs_defer_init(&dfops, &first_block);
> >  		error = xfs_bunmapi(tp, ip,
> >  				    first_unmap_block, unmap_len,
> > -				    xfs_bmapi_aflag(whichfork),
> > +				    xfs_bmapi_aflag(whichfork) | flags,
> 
> so this gets simpler and easier to read.
> 

Indeed, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
