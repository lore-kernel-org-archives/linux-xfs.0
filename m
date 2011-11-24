Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAO3NelE253092 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 21:23:40 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A706826F56A
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 19:23:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mdrYZIcPitmsHz3F for <xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 19:23:37 -0800 (PST)
Date: Thu, 24 Nov 2011 14:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE to XFS V2
Message-ID: <20111124032331.GO2386@dastard>
References: <4ECB5B21.7080508@oracle.com> <20111123094049.GA5465@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111123094049.GA5465@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Wed, Nov 23, 2011 at 04:40:49AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 22, 2011 at 04:19:45PM +0800, Jeff Liu wrote:
> > Hello,
> > 
> > This is the V2 attempt to add SEEK_DATA/SEEK_HOLE to XFS.
> 
> Thanks Jeff, this looks pretty good for "simple" implementation,
> I only have a few rather cosmetic comments.
> 
> Do you plan on updating Josef's old xfstests support patch for
> SEEK_DATA/SEEK_HOLE?  Also it would be nice to do the pagecache
> probing for dirty unwritten extents next to get a better quality
> of implementation.
> 
> >+STATIC int
> >+xfs_seek_data(
> >+	struct xfs_inode *ip,
> >+	loff_t *start)
> >+{
> 
> In the XFS code we generally tab-aling the paramter names, just like
> you already did for the local variables:
> 
> STATIC int
> xfs_seek_data(
> 	struct xfs_inode	*ip,
> 	loff_t			*start)
> 
> (that also applies for a few other functions)
> 
> > +		/*
> > +		 * Hole handling for unwritten extents landed in a hole.
> > +		 * If the next extent is a data  extent, then return the
> > +		 * start of it, otherwise we need to move the start offset
> > +		 * and map more blocks.
> > +		 */
> 
> I don't think this comment is quite correct.  We don't just end up here
> for unwritten extents.  I'd recommend something like:
> 
> 		/*
> 		 * We landed in a hole.  Skip to the next extent.
> 		 */
> 
> > +		if (map[0].br_startblock == HOLESTARTBLOCK) {
> > +			if (map[1].br_startblock == HOLESTARTBLOCK) {
> > +				fsbno = map[1].br_startoff +
> > +					map[1].br_blockcount;
> 
> I don't think this code is reachable - xfs_bmapi will never produce
> multiple consecutive HOLESTARTBLOCK extents.

If the hole would overflow br_blockcount (32 bits of FSB units, 16TB
by default), then we should get multiple consecutive hole records
returned.

> If you want to ensure
> that feel free to add an assert, e.g.
> 
> 		if (map[0].br_startblock == HOLESTARTBLOCK) {
> 			ASSERT(map[1].br_startblock != HOLESTARTBLOCK);
> 
> 			*start = max_t(loff_t, seekoff,
> 			       XFS_FSB_TO_B(mp, map[1].br_startoff));
> 			break;
> 		}
> 
> This also means that we never have to loop here until we add dirty
> unwritten probing - if the second extent doesn't contain data there
> won't be any other data extent in this file beyound our offset.

I think that's incorrect. A data extent is limited in length by the
on disk format (21 bits of FSB, 8GB in 4k block fs), so if you've
got more than 8GB of data or the file is fragmented after the
current extent then we can still get back multiple data extents
before we find the next hole.

> > +
> > +		/*
> > +		 * Landed in an in-memory data extent or in an allocated
> > +		 * extent.
> > +		 */
> 
> > +		if (map[0].br_startoff == DELAYSTARTBLOCK ||
> > +		    map[0].br_state == XFS_EXT_NORM) {
> 
> I think just checking for br_state == XFS_EXT_NORM should be fine here,
> as unwritten extents can be delayed allocated.

Can they? I'm pretty sure delalloc and unwritten are mutually
exclusive states for an extent. That is, if you write over an
unwritten extent, it gets mapped to the disk blocks but remains an
unwritten extent until the data is written. And, IIRC, preallocation
skips over delayed allocation ranges so you can't turn an existing
delalloc region into a preallocated one...

> But until we add probing
> for dirty unwritten extents is added we have to treat unwritten extents
> as data anyway to avoid data loss.

True.

> 
> Note that once unwrittent extent probing also needs to cover the hole
> case above and not just this case.
> 
> > +STATIC int
> > +xfs_seek_extent(
> > +	struct inode		*inode,
> > +	loff_t			*start,
> > +	u32			type)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_ifork	*ifp;
> > +	int			lock;
> > +	int			error = 0;
> > +
> > +	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> > +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> > +	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > +		return XFS_ERROR(EINVAL);
> 
> I'd recommend moving this check into xfs_file_llseek and even do it
> for the normal lseek requests - it's another sanity check for corrupted
> filesystems which makes sense everywhere.  I also think the return value
> should be EFSCORRUPTED.
>
> Also XFS_DINODE_FMT_LOCAL isn't valid for regular files (yet) so it
> shouldn't be tested for.

I don't think it is necessary at all - the low level bmap functions
already do these checks.

> 
> > +
> > +	lock = xfs_ilock_map_shared(ip);
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp)) {
> > +		error = EIO;
> > +		goto out_lock;
> > +	}
> 
> The shutdown check probably should go into the common lseek code and
> done for all cases.

I think the low level functions also do this check so it's not
explicitly needed here, anyway.

> 
> > +
> > +	XFS_STATS_INC(xs_blk_mapr);
> 
> I don't think this counter should be incremented here.

It's done in the lower layer functions, so shouldn't be here.

> 
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +
> > +	ASSERT(ifp->if_ext_max ==
> > +	      XFS_IFORK_SIZE(ip, XFS_DATA_FORK) / (uint)sizeof(xfs_bmbt_rec_t));
> 
> Please just drop this assert.  if_ext_max is pretty useless, and I have
> a patch to remove it pending.  No adding another use of it in your patch
> will make merging a bit easier.

I think it's done in the lower layer functions, anyway.

> 
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +		if (error)
> > +			goto out_lock;
> > +	}

And that is definitely done in the lower layer bmap functions, so is
not necessary here.

> > +
> > +	if (type == SEEK_HOLE)
> > +		error = xfs_seek_hole(ip, start);
> > +	else
> > +		error = xfs_seek_data(ip, start);
> 
> Now that just the locking and the xfs_iread_extents call is left in
> this function I'd suggest to remove it and instead add duplicates
> of the locking and xfs_iread_extents into xfs_seek_hole and
> xfs_seek_data.

Actually, it just turns into "lock, call seek/data fucntion, unlock",
so it can probaly go away entirely.

> 
> > +	switch (origin) {
> > +	case SEEK_END:
> > +	case SEEK_CUR:
> > +		offset = generic_file_llseek(file, offset, origin);
> > +		goto out;
> 
> instead of the goto out just return the generic_file_llseek return
> value directly here.
> 
> > +	case SEEK_DATA:
> > +	case SEEK_HOLE:
> > +		if (offset >= i_size_read(inode)) {
> > +			ret = -ENXIO;
> > +			goto error;
> > +		}
> > +
> > +		ret = xfs_seek_extent(inode, &offset, origin);
> > +		if (ret)
> > +			goto error;
> > +	}
> > +
> > +	if (offset != file->f_pos)
> > +		file->f_pos = offset;
> 
> doing the offset update outside the case scrope doesn't make much sense.
> 
> I'd probably just move the offset check and offset update into the
> low-level xfs_seek_data/xfs_seek_hole helpers - it's a tiny bit of
> duplication, but it keeps the functions self-contained and the
> top-level llseek method just dispatcher into the different routines.

Definitely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
