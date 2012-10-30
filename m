Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UMWoVL078171 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:32:50 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZlNYI8Zr3dA4DxyY for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 15:34:39 -0700 (PDT)
Date: Wed, 31 Oct 2012 09:34:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/25] xfs: connect up write verifiers to new buffers
Message-ID: <20121030223437.GF29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-24-git-send-email-david@fromorbit.com>
	<20121030133938.GI18595@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030133938.GI18595@caliban.engr.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 30, 2012 at 06:39:38AM -0700, Phil White wrote:
> On Thu, Oct 25, 2012 at 05:34:12PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Metadata buffers that are read from disk have write verifiers
> > already attached to them, but newly allocated buffers do not. Add
> > appropriate write verifiers to all new metadata buffers.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_alloc.c        |    6 +--
> >  fs/xfs/xfs_alloc.h        |    2 +
> >  fs/xfs/xfs_alloc_btree.c  |    1 +
> >  fs/xfs/xfs_attr_leaf.c    |    4 +-
> >  fs/xfs/xfs_bmap.c         |    2 +
> >  fs/xfs/xfs_bmap_btree.c   |    3 +-
> >  fs/xfs/xfs_bmap_btree.h   |    1 +
> >  fs/xfs/xfs_btree.c        |    1 +
> >  fs/xfs/xfs_btree.h        |    2 +
> >  fs/xfs/xfs_da_btree.c     |    3 ++
> >  fs/xfs/xfs_dir2_block.c   |    2 +
> >  fs/xfs/xfs_dir2_data.c    |   11 +++--
> >  fs/xfs/xfs_dir2_leaf.c    |   19 ++++++---
> >  fs/xfs/xfs_dir2_node.c    |   24 +++++++----
> >  fs/xfs/xfs_dir2_priv.h    |    2 +
> >  fs/xfs/xfs_dquot.c        |  104 ++++++++++++++++++++++-----------------------
> >  fs/xfs/xfs_fsops.c        |    7 ++-
> >  fs/xfs/xfs_ialloc.c       |    5 ++-
> >  fs/xfs/xfs_ialloc.h       |    4 +-
> >  fs/xfs/xfs_ialloc_btree.c |    1 +
> >  fs/xfs/xfs_inode.c        |   14 +++++-
> >  fs/xfs/xfs_inode.h        |    1 +
> >  fs/xfs/xfs_mount.c        |    2 +-
> >  fs/xfs/xfs_mount.h        |    1 +
> >  24 files changed, 135 insertions(+), 87 deletions(-)
> > 
> 
> A few comments:
> 
> > diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> > index bb96c55..5d56886 100644
> > --- a/fs/xfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/xfs_attr_leaf.c
> > @@ -923,7 +923,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
> >  					    XFS_ATTR_FORK);
> >  	if (error)
> >  		goto out;
> > -	ASSERT(bp2 != NULL);
> > +	bp2->b_pre_io = bp1->b_pre_io;
> >  	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(dp->i_mount));
> >  	bp1 = NULL;
> >  	xfs_trans_log_buf(args->trans, bp2, 0, XFS_LBSIZE(dp->i_mount) - 1);
> > @@ -977,7 +977,7 @@ xfs_attr_leaf_create(
> >  					    XFS_ATTR_FORK);
> >  	if (error)
> >  		return(error);
> > -	ASSERT(bp != NULL);
> > +	bp->b_pre_io = xfs_attr_leaf_write_verify;
> >  	leaf = bp->b_addr;
> >  	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
> >  	hdr = &leaf->hdr;
> 
> I'm unclear as to why you're removing the asserts here.  There must be
> a reason that you think bp is guaranteed to be safe, but I haven't
> grasped it here.

If bp is NULL then the code is going to oops immediately, anyway.
Hence the assert is redundant.  Further, the function that returns
bp either gives us a valid buffer or returns an error, so logically
the assert is also redundant from that perspective.

Hence I killed them to clean up the code a little.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
