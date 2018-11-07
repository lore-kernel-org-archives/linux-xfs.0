Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbeKGNSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 08:18:45 -0500
Date: Tue, 6 Nov 2018 19:50:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: check the ir_startino alignment directly
Message-ID: <20181107035003.GY4135@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147730502.32496.4086322277755351139.stgit@magnolia>
 <20181106213447.GQ19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106213447.GQ19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 08:34:47AM +1100, Dave Chinner wrote:
> On Mon, Nov 05, 2018 at 08:08:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xchk_iallocbt_rec, check the alignment of ir_startino by converting
> > the inode cluster block alignment into units of inodes instead of the
> > other way around (converting ir_startino to blocks).  This prevents us
> > from tripping over off-by-one errors in ir_startino which are obscured
> > by the inode -> block conversion.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/ialloc.c |   32 ++++++++++++++++++++++++++------
> >  1 file changed, 26 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 3c12a0fe3b38..f498dfca3312 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -278,6 +278,29 @@ xchk_iallocbt_check_freemask(
> >  	return error;
> >  }
> >  
> > +/* Make sure this record is aligned to cluster and inoalignmnt size. */
> > +STATIC void
> > +xchk_iallocbt_rec_alignment(
> > +	struct xchk_btree		*bs,
> > +	struct xfs_inobt_rec_incore	*irec)
> > +{
> > +	struct xfs_mount		*mp = bs->cur->bc_mp;
> > +	struct xchk_iallocbt		*iabt = bs->private;
> > +	xfs_agino_t			imask;
> > +
> > +	imask = XFS_OFFBNO_TO_AGINO(mp, iabt->cluster_align, 0) - 1;
> 
> Again, this seems obtuse.
> 
> 	imask = (iabt->cluster_align << mp->m_sb.sb_inopblog) - 1;

Or I'll just add another field to xchk_iallocbt for "inode cluster
alignment in inodes" and use that here and elsewhere.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
