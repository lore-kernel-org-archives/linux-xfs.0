Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFA4A7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 06:29:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A42E8F8040
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 04:29:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T4kWFBc9AGxegz2L for
	<xfs@oss.sgi.com>; Thu, 24 Apr 2014 04:29:50 -0700 (PDT)
Date: Thu, 24 Apr 2014 07:29:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140424112948.GB51140@bfoster.bfoster>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<1397146116-42546-5-git-send-email-bfoster@redhat.com>
	<20140424053259.GA15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140424053259.GA15995@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 24, 2014 at 03:32:59PM +1000, Dave Chinner wrote:
> On Thu, Apr 10, 2014 at 12:08:29PM -0400, Brian Foster wrote:
> > Create the xfs_calc_finobt_res() helper to calculate the finobt log
> > reservation for inode allocation and free. Update
> > XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
> > insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
> > reserve blocks for the potential finobt record insertion on inode
> > free (i.e., if an inode chunk was previously fully allocated).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c       | 25 ++++++++++++++++++++++-
> >  fs/xfs/xfs_trans_resv.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/xfs_trans_space.h |  7 ++++++-
> >  3 files changed, 80 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 5e7a38f..8576892 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1837,8 +1837,31 @@ xfs_inactive_ifree(
> >  	int			error;
> >  
> >  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
> > +
> > +	/*
> > +	 * The ifree transaction might need to allocate blocks for record
> > +	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
> > +	 * allow ifree to dip into the reserved block pool if necessary.
> > +	 *
> > +	 * Freeing large sets of inodes generally means freeing inode chunks,
> > +	 * directory and file data blocks, so this should be relatively safe.
> > +	 * Only under severe circumstances should it be possible to free enough
> > +	 * inodes to exhaust the reserve block pool via finobt expansion while
> > +	 * at the same time not creating free space in the filesystem.
> > +	 *
> > +	 * Send a warning if the reservation does happen to fail, as the inode
> > +	 * now remains allocated and sits on the unlinked list until the fs is
> > +	 * repaired.
> > +	 */
> > +	tp->t_flags |= XFS_TRANS_RESERVE;
> > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> > +				  XFS_IFREE_SPACE_RES(mp), 0);
> >  	if (error) {
> > +		if (error == ENOSPC)
> > +			xfs_warn_ratelimited(mp,
> > +			"Failed to remove inode(s) from unlinked list. "
> > +			"Please free space, unmount and run xfs_repair.");
> > +
> >  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> >  		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
> >  		return error;
> 
> Comment is good, but if we get an ENOSPC error here we won't be in a
> shutdown state, hence the assert needs fixing (i.e. else {assert})
> 

Yeah, good catch.

Brian

> Otherwise this looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
