Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN9ertV206981 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 03:40:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DCA31551684
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 01:40:50 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WUsKCpg7qnE9cSTm for <xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 01:40:50 -0800 (PST)
Date: Wed, 23 Nov 2011 04:40:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE to XFS V2
Message-ID: <20111123094049.GA5465@infradead.org>
References: <4ECB5B21.7080508@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECB5B21.7080508@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 04:19:45PM +0800, Jeff Liu wrote:
> Hello,
> 
> This is the V2 attempt to add SEEK_DATA/SEEK_HOLE to XFS.

Thanks Jeff, this looks pretty good for "simple" implementation,
I only have a few rather cosmetic comments.

Do you plan on updating Josef's old xfstests support patch for
SEEK_DATA/SEEK_HOLE?  Also it would be nice to do the pagecache
probing for dirty unwritten extents next to get a better quality
of implementation.

>+STATIC int
>+xfs_seek_data(
>+	struct xfs_inode *ip,
>+	loff_t *start)
>+{

In the XFS code we generally tab-aling the paramter names, just like
you already did for the local variables:

STATIC int
xfs_seek_data(
	struct xfs_inode	*ip,
	loff_t			*start)

(that also applies for a few other functions)

> +		/*
> +		 * Hole handling for unwritten extents landed in a hole.
> +		 * If the next extent is a data  extent, then return the
> +		 * start of it, otherwise we need to move the start offset
> +		 * and map more blocks.
> +		 */

I don't think this comment is quite correct.  We don't just end up here
for unwritten extents.  I'd recommend something like:

		/*
		 * We landed in a hole.  Skip to the next extent.
		 */

> +		if (map[0].br_startblock == HOLESTARTBLOCK) {
> +			if (map[1].br_startblock == HOLESTARTBLOCK) {
> +				fsbno = map[1].br_startoff +
> +					map[1].br_blockcount;

I don't think this code is reachable - xfs_bmapi will never produce
multiple consecutive HOLESTARTBLOCK extents.  If you want to ensure
that feel free to add an assert, e.g.

		if (map[0].br_startblock == HOLESTARTBLOCK) {
			ASSERT(map[1].br_startblock != HOLESTARTBLOCK);

			*start = max_t(loff_t, seekoff,
			       XFS_FSB_TO_B(mp, map[1].br_startoff));
			break;
		}

This also means that we never have to loop here until we add dirty
unwritten probing - if the second extent doesn't contain data there
won't be any other data extent in this file beyound our offset.

> +
> +		/*
> +		 * Landed in an in-memory data extent or in an allocated
> +		 * extent.
> +		 */

> +		if (map[0].br_startoff == DELAYSTARTBLOCK ||
> +		    map[0].br_state == XFS_EXT_NORM) {

I think just checking for br_state == XFS_EXT_NORM should be fine here,
as unwritten extents can be delayed allocated.  But until we add probing
for dirty unwritten extents is added we have to treat unwritten extents
as data anyway to avoid data loss.

Note that once unwrittent extent probing also needs to cover the hole
case above and not just this case.

> +STATIC int
> +xfs_seek_extent(
> +	struct inode		*inode,
> +	loff_t			*start,
> +	u32			type)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp;
> +	int			lock;
> +	int			error = 0;
> +
> +	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> +		return XFS_ERROR(EINVAL);

I'd recommend moving this check into xfs_file_llseek and even do it
for the normal lseek requests - it's another sanity check for corrupted
filesystems which makes sense everywhere.  I also think the return value
should be EFSCORRUPTED.

Also XFS_DINODE_FMT_LOCAL isn't valid for regular files (yet) so it
shouldn't be tested for.

> +
> +	lock = xfs_ilock_map_shared(ip);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		error = EIO;
> +		goto out_lock;
> +	}

The shutdown check probably should go into the common lseek code and
done for all cases.

> +
> +	XFS_STATS_INC(xs_blk_mapr);

I don't think this counter should be incremented here.

> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +
> +	ASSERT(ifp->if_ext_max ==
> +	      XFS_IFORK_SIZE(ip, XFS_DATA_FORK) / (uint)sizeof(xfs_bmbt_rec_t));

Please just drop this assert.  if_ext_max is pretty useless, and I have
a patch to remove it pending.  No adding another use of it in your patch
will make merging a bit easier.

> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error)
> +			goto out_lock;
> +	}
> +
> +	if (type == SEEK_HOLE)
> +		error = xfs_seek_hole(ip, start);
> +	else
> +		error = xfs_seek_data(ip, start);

Now that just the locking and the xfs_iread_extents call is left in
this function I'd suggest to remove it and instead add duplicates
of the locking and xfs_iread_extents into xfs_seek_hole and
xfs_seek_data.

> +	switch (origin) {
> +	case SEEK_END:
> +	case SEEK_CUR:
> +		offset = generic_file_llseek(file, offset, origin);
> +		goto out;

instead of the goto out just return the generic_file_llseek return
value directly here.

> +	case SEEK_DATA:
> +	case SEEK_HOLE:
> +		if (offset >= i_size_read(inode)) {
> +			ret = -ENXIO;
> +			goto error;
> +		}
> +
> +		ret = xfs_seek_extent(inode, &offset, origin);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	if (offset != file->f_pos)
> +		file->f_pos = offset;

doing the offset update outside the case scrope doesn't make much sense.

I'd probably just move the offset check and offset update into the
low-level xfs_seek_data/xfs_seek_hole helpers - it's a tiny bit of
duplication, but it keeps the functions self-contained and the
top-level llseek method just dispatcher into the different routines.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
