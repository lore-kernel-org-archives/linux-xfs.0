Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 617F57F3F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 07:36:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30856304053
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:36:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jQTPOE2khEQerSw1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:36:10 -0700 (PDT)
Date: Fri, 30 Oct 2015 08:36:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: introduce BMAPI_ZERO for allocating zeroed
	extents
Message-ID: <20151030123608.GB54905@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-3-git-send-email-david@fromorbit.com>
	<20151029142757.GD11663@bfoster.bfoster>
	<20151029233548.GR19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029233548.GR19199@dastard>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Fri, Oct 30, 2015 at 10:35:48AM +1100, Dave Chinner wrote:
> On Thu, Oct 29, 2015 at 10:27:58AM -0400, Brian Foster wrote:
> > On Mon, Oct 19, 2015 at 02:27:14PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
...
> 
> > I suspect there's no use case to pass XFS_BMAPI_ZERO for new unwritten
> > allocations, but if the flag is passed, doesn't this cause duplicate
> > block zeroing?
> 
> It probably would, but....
> 
> > Perhaps we should drop the zero flag from 'flags' after
> > allocation in xfs_bmapi_write() just to ensure this executes in one
> > place or the other..?
> 
> I think that if we hit this, we're doing something else wrong - why
> would we allocate unwritten extents and still need to initialise
> them to zero?
> 

No idea, really (as noted above). ;) It just looked like it could be
invoked twice per bmapi call, nothing else I saw prevented it, and it
looks easily avoidable. Maybe somebody down the road decides to turn on
block zeroing unconditionally in the block allocator due to hardware
support or some such. Or maybe we'll never hit the problem. The point is
that this code will inevitably be modified/enhanced down the road and
nobody is going to remember that the zeroing is invoked twice in a
particular prealloc codepath.

If we don't want to mess with the flags, how about an assert somewhere
so it's explicit the bmapi implementation doesn't expect this
combination of flags?

> > > +	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
> > > +	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
> > > +	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
> > > +
> > > +	if (IS_DAX(VFS_I(ip)))
> > > +		return dax_clear_blocks(VFS_I(ip), block, size);
> > > +
> > > +	/*
> > > +	 * let the block layer decide on the fastest method of
> > > +	 * implementing the zeroing.
> > > +	 */
> > > +	return sb_issue_zeroout(mp->m_super, block, count_fsb, GFP_NOFS);
> > 
> > The count param to sb_issue_zeroout() is a sector_t and we're passing an
> > FSB.
> 
> "sector_t" does not mean the function takes parameters in units of
> sectors. It's the only variable that you can guarantee will be sized
> correctly to the kernel's configured block device capacity
> support. Indeed:
> 
> static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
>                 sector_t nr_blocks, gfp_t gfp_mask)
> {
>         return blkdev_issue_zeroout(sb->s_bdev,
>                                     block << (sb->s_blocksize_bits - 9),
>                                     nr_blocks << (sb->s_blocksize_bits - 9),
>                                     gfp_mask, true);
> }
> 
> sb_issue_zeroout() takes a block device offset and length in
> filesystem block size units and converts them back to sectors to
> pass it to the block layer.
> 

Ah, I see. I missed the conversion that was being done there via the sb
helper.

Brian

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
