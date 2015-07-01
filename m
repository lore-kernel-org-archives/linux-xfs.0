Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 512217F69
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 18:31:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22A45304043
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 16:30:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YARQlFKsqgXiTTNg for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 16:30:56 -0700 (PDT)
Date: Thu, 2 Jul 2015 09:30:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/14] xfs: create a per-AG btree to track reference counts
Message-ID: <20150701233042.GU22807@dastard>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625233916.4992.12808.stgit@birch.djwong.org>
	<20150701001306.GP22807@dastard>
	<20150701225213.GA10043@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701225213.GA10043@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 03:52:13PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2015 at 10:13:06AM +1000, Dave Chinner wrote:
> > On Thu, Jun 25, 2015 at 04:39:16PM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 9cff517..e4954ab 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -446,9 +446,11 @@ xfs_sb_has_compat_feature(
> > >  
> > >  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> > >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> > > +#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflink btree */
> > >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> > >  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> > > -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
> > > +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > > +		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
> > 
> > The XFS_SB_FEAT_RO_COMPAT_REFLINK flag shoul dbe added as a separate
> > patch and put last in the series so it is only enabled once
> > everything is complete.
> 
> What if I define XFS_SB_FEAT_RO_COMPAT_REFLINK at the beginning but omit it
> from the XFS_SB_FEAT_RO_COMPAT_ALL definition until the final patch?  That
> should prohibit anyone from using the half-baked feature during a bisect.

Yup, thats what I meant ;)

> > > +	int			*stat)
> > > +{
> > > +	int			error;
> > > +	xfs_agblock_t		bno;
> > > +
> > > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > > +
> > > +	/* Allocate the new block from the freelist. If we can't, give up.  */
> > > +	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> > > +				       &bno, 1);
> > > +	if (error) {
> > > +		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > > +		return error;
> > > +	}
> > 
> > Why does the reflink btree use the free list? Why can't it use
> > block allocation like the BMBT tree?
> 
> I'm confused about the intended usage of the AGFL -- the XFS FS structure doc
> says that it's for growing the free space btrees and can't be used for anything
> else, but the rmap btree uses it.

The rmap btree is a "freespace" btree in that it is modified at the
same time the two freespace btrees are modified. It's tracking used
space rather than free space, but from an architectural POV the rmap
btree sits at the same lowest layer as the freespace btree.

Think of it like this: when an extent is allocated, the freespace
btree removal needs ot be atomic with the rmap btree insertion so
they remain coherent at all times. Similarly we have the same
situation with extent freeing - removal from the rmap must be atomic
with addition to the freespace btree.

The reflink btree sits a layer above the freespace btrees,
equivalent to the BMBT. That is, when we remove an extent from the
BMBT, we also need to remove the reflink btree reference. Only if
the reference drops to zero does the extent then become free, and we
pass it off to xfs_free_extent()....

> Originally it /did/ use xfs_alloc_vextent(), though it won't be
> difficult to revert.

The way you use EFIs means that it can't be put inside
xfs_alloc_vextent()/xfs_free_extent() - EFIs track movement of
extents from the BMBT to the freespace tree, and so if we now have a
reflink btree in the way, the EFI tracks movement from the reflink
btree to the freespace trees.  i.e. the reflink btree is modified
atomically with the BMBT, not the freespace trees.

Which, really, is a long way of saying that the allocation/freeing
model of reflink btree blocks shoul dbe the same as the BMBT, and
the transactional model integrates with the BMBT modifications, not
the freespace btree modifications...

> > > +/*
> > > + * Allocate a new reflink btree cursor.
> > > + */
> > > +struct xfs_btree_cur *			/* new reflink btree cursor */
> > > +xfs_reflinkbt_init_cursor(
> > > +	struct xfs_mount	*mp,		/* file system mount point */
> > > +	struct xfs_trans	*tp,		/* transaction pointer */
> > > +	struct xfs_buf		*agbp,		/* buffer for agf structure */
> > > +	xfs_agnumber_t		agno)		/* allocation group number */
> > 
> > No real need for these comments on the variables. They are redundant
> > as the code documents what they are just fine.
> 
> I was playing monkey-see monkey-do.  Some of the other functions had
> commented args. :)

Yup, that's the old code. For new code we write it in a way that
doesn't require comments like that ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
