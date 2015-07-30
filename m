Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C1DEB7F6C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 16:10:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE874304032
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 14:10:34 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id imsgNRqspzITer83 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 14:10:30 -0700 (PDT)
Date: Thu, 30 Jul 2015 14:09:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/24] xfs: map an inode's offset to an exact physical
	block
Message-ID: <20150730210957.GI10043@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223409.17414.33569.stgit@birch.djwong.org>
	<20150730010417.GK16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150730010417.GK16638@dastard>
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

On Thu, Jul 30, 2015 at 11:04:17AM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2015 at 03:34:09PM -0700, Darrick J. Wong wrote:
> > Teach the bmap routine to know how to map a range of file blocks to a
> > specific range of physical blocks, instead of simply allocating fresh
> > blocks.  This enables reflink to map a file to blocks that are already
> > in use.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |   21 +++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_bmap.h |    3 +++
> >  2 files changed, 24 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index dfdd9e6..1297b94 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3897,6 +3897,15 @@ STATIC int
> >  xfs_bmap_alloc(
> >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> >  {
> > +	if (ap->flags & XFS_BMAPI_EXACT) {
> > +		trace_xfs_reflink_relink_blocks(ap->ip, *ap->firstblock,
> > +				ap->length);
> > +		ap->blkno = *ap->firstblock;
> > +		ap->ip->i_d.di_nblocks += ap->length;
> > +		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> > +		return 0;
> > +	}
> 
> XFS_BMAPI_EXACT is confusing to me - "exact" already means something
> in the xfs_bmapi API w.r.t. the XFS_BMAPI_ENTIRE flag. That is, if
> XFS_BMAPI_ENTIRE is not set, we want the map returned to span only
> the /exact range requested/. If XFS_BMAPI_ENTIRE is set, we want the
> entire extent that overlaps the range requested...
> 
> So I think this might be better named to match it's intended
> function. e.g. remap, reuse, ref_only, etc.

How about XFS_BMAPI_REFLINK?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
