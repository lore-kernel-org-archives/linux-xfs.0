Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 309017CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 19:24:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABEC5AC006
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:24:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QCwFf116PybedM9w (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:24:35 -0800 (PST)
Date: Thu, 11 Feb 2016 17:24:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] libxfs: refactor the btree size calculator code
Message-ID: <20160212012432.GA26204@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<20160123003508.2475.53723.stgit@birch.djwong.org>
	<20160211234807.GI6350@birch.djwong.org>
	<20160212010722.GV14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160212010722.GV14668@dastard>
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

On Fri, Feb 12, 2016 at 12:07:22PM +1100, Dave Chinner wrote:
> On Thu, Feb 11, 2016 at 03:48:07PM -0800, Darrick J. Wong wrote:
> > On Fri, Jan 22, 2016 at 04:35:08PM -0800, Darrick J. Wong wrote:
> > > Create a macro to generate btree height calculator functions.
> > > This will be used (much) later when we get to the refcount
> > > btree.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  libxfs/xfs_bmap.c       |   18 +-----------------
> > >  libxfs/xfs_bmap_btree.c |    9 +++++++++
> > >  libxfs/xfs_bmap_btree.h |    3 +++
> > >  libxfs/xfs_btree.c      |   28 ++++++++++++++++++++++++++++
> > >  libxfs/xfs_btree.h      |    3 +++
> > >  5 files changed, 44 insertions(+), 17 deletions(-)
> > > 
> > > 
> > > diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> > > index aef7cf3..c134765 100644
> > > --- a/libxfs/xfs_bmap.c
> > > +++ b/libxfs/xfs_bmap.c
> > > @@ -172,25 +172,9 @@ xfs_bmap_worst_indlen(
> > >  	xfs_inode_t	*ip,		/* incore inode pointer */
> > >  	xfs_filblks_t	len)		/* delayed extent length */
> > >  {
> > > -	int		level;		/* btree level number */
> > > -	int		maxrecs;	/* maximum record count at this level */
> > > -	xfs_mount_t	*mp;		/* mount structure */
> > >  	xfs_filblks_t	rval;		/* return value */
> > >  
> > > -	mp = ip->i_mount;
> > > -	maxrecs = mp->m_bmap_dmxr[0];
> > > -	for (level = 0, rval = 0;
> > > -	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
> > > -	     level++) {
> > > -		len += maxrecs - 1;
> > > -		do_div(len, maxrecs);
> > > -		rval += len;
> > > -		if (len == 1)
> > > -			return rval + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) -
> > > -				level - 1;
> > > -		if (level == 0)
> > > -			maxrecs = mp->m_bmap_dmxr[1];
> > > -	}
> > > +	rval = xfs_bmbt_calc_size(ip->i_mount, len);
> > 
> > NAK.  This function figures out how many blocks could be required to handle
> > adding (worst-case one-extent-per-block) extents to the bmbt and btree splits
> > all the way up the tree, whereas xfs_btree_calc_size() merely calculates the
> > number of blocks needed to create a tree with some number of records.  When I
> > start using the AG reservation code and counting the number of blocks in use at
> > mount time, using the below xfs_btree_calc_size() to calculate the resevation
> > size leads to undersized reservations, which (I think?) explains why I still
> > occasionally run out of blocks when expanding the refcount tree, which is
> > supposed to reserve /all/ the blocks it'll ever need.
> > 
> > This function should go back to the way it was, and the xfs_btree_calc_size()
> > function will get fixed to calculate tree size correctly.
> > 
> > Also NAK on the kernelside version of this patch.
> 
> Thanks for the heads-up, Darrick. I hadn't pulled this in to either
> tree yet, because it hadn't got a reviewed-by. I guess that's a sign
> that the process is working as it should. :P

lol. :)

I'll post a branch off of your for-next 4.6 branch soon; it'll have all
the fixes that have been accumulating since the last RFC posting.

--D

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
