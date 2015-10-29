Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4603A7CBF
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 18:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 372EF30404E
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 16:35:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IWBJt4r6oTr8FQgv for <xfs@oss.sgi.com>;
	Thu, 29 Oct 2015 16:35:50 -0700 (PDT)
Date: Fri, 30 Oct 2015 10:35:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: introduce BMAPI_ZERO for allocating zeroed
	extents
Message-ID: <20151029233548.GR19199@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-3-git-send-email-david@fromorbit.com>
	<20151029142757.GD11663@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029142757.GD11663@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Thu, Oct 29, 2015 at 10:27:58AM -0400, Brian Foster wrote:
> On Mon, Oct 19, 2015 at 02:27:14PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To enable DAX to do atomic allocation of zeroed extents, we need to
> > drive the block zeroing deep into the allocator. Because
> > xfs_bmapi_write() can return merged extents on allocation that were
> > only partially allocated (i.e. requested range spans allocated and
> > hole regions, allocation into the hole was contiguous), we cannot
> > zero the extent returned from xfs_bmapi_write() as that can
> > overwrite existing data with zeros.
> > 
> > Hence we have to drive the extent zeroing into the allocation code,
> > prior to where we merge the extents into the BMBT and return the
> > resultant map. This means we need to propagate this need down to
> > the xfs_alloc_vextent() and issue the block zeroing at this point.
> > 
> > While this functionality is being introduced for DAX, there is no
> > reason why it is specific to DAX - we can per-zero blocks during the
> > allocation transaction on any type of device. It's just slow (and
> > usually slower than unwritten allocation and conversion) on
> > traditional block devices so doesn't tend to get used. We can,
> > however, hook hardware zeroing optimisations via sb_issue_zeroout()
> > to this operation, so it may be useful in future and hence the
> > "allocate zeroed blocks" API needs to be implementation neutral.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> >  #endif
> > +
> > +		/* Zero the extent if we were asked to do so */
> > +		if (args->userdata & XFS_ALLOC_USERDATA_ZERO) {
> > +			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
> > +			if (error)
> > +				goto error0;
> > +		}
> > +
> 
> Ok, so we wire up zeroing to the actual block allocation here...

Yes.

> > @@ -4421,6 +4429,17 @@ xfs_bmapi_convert_unwritten(
> >  	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
> >  				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
> >  
> > +	/*
> > +	 * Before insertion into the bmbt, zero the range being converted
> > +	 * if required.
> > +	 */
> > +	if (flags & XFS_BMAPI_ZERO) {
> > +		error = xfs_zero_extent(bma->ip, mval->br_startblock,
> > +					mval->br_blockcount);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> 
> ... and also zero the extent on unwritten conversion, if necessary.

Correct.

> I suspect there's no use case to pass XFS_BMAPI_ZERO for new unwritten
> allocations, but if the flag is passed, doesn't this cause duplicate
> block zeroing?

It probably would, but....

> Perhaps we should drop the zero flag from 'flags' after
> allocation in xfs_bmapi_write() just to ensure this executes in one
> place or the other..?

I think that if we hit this, we're doing something else wrong - why
would we allocate unwritten extents and still need to initialise
them to zero?

> > +	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
> > +	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
> > +	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
> > +
> > +	if (IS_DAX(VFS_I(ip)))
> > +		return dax_clear_blocks(VFS_I(ip), block, size);
> > +
> > +	/*
> > +	 * let the block layer decide on the fastest method of
> > +	 * implementing the zeroing.
> > +	 */
> > +	return sb_issue_zeroout(mp->m_super, block, count_fsb, GFP_NOFS);
> 
> The count param to sb_issue_zeroout() is a sector_t and we're passing an
> FSB.

"sector_t" does not mean the function takes parameters in units of
sectors. It's the only variable that you can guarantee will be sized
correctly to the kernel's configured block device capacity
support. Indeed:

static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
                sector_t nr_blocks, gfp_t gfp_mask)
{
        return blkdev_issue_zeroout(sb->s_bdev,
                                    block << (sb->s_blocksize_bits - 9),
                                    nr_blocks << (sb->s_blocksize_bits - 9),
                                    gfp_mask, true);
}

sb_issue_zeroout() takes a block device offset and length in
filesystem block size units and converts them back to sectors to
pass it to the block layer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
