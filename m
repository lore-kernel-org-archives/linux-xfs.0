Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAMNRCLL259852 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 17:27:12 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	n8f4xEu1W3NeeIiI for <xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 15:29:23 -0800 (PST)
Date: Fri, 23 Nov 2012 10:29:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
Message-ID: <20121122232920.GX2591@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
	<50A3E86A.2060402@sgi.com> <50A3F80C.7050502@sgi.com>
	<20121121080502.GP2591@dastard> <50ADB3AA.302@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50ADB3AA.302@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Nov 21, 2012 at 11:10:02PM -0600, Andrew Dahl wrote:
> On 11/21/2012 02:05 AM, Dave Chinner wrote:
> ...
> > 
> > [ Here's a tip for the future: anything that changes allocation
> > corner cases needs to be run through the entire of xfstests suite
> > because they have a nasty habit of causing secondary problems.... ]
> > 
> Makes sense -- I'll keep that in mind for the future. (Thanks!)
> 
> ...
> 
> > +
> > +STATIC int
> > +xfs_zero_file_space(
> > +	struct xfs_inode	*ip,
> > +	xfs_off_t		offset,
> > +	xfs_off_t		len,
> > +	int			attr_flags)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	uint			rounding;
> > +	xfs_off_t		start;
> > +	xfs_off_t		end;
> > +	int			error;
> > +
> > +	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> Let's say rounding is 4K
> > +
> > +	/* round the range iof extents we are going to convert inwards */
> > +	start = round_up(offset, rounding);
> > +	end = round_down(offset + len, rounding);
> Now, let's say we pass in (4K-1) for the offset and (4K-1).
> 
> Then start would be 4K and the end would be 4K, right?
> 
> > +
> > +	ASSERT(start >= offset);
> > +	ASSERT(end <= offset + len);
> These are both true, so this is good.
> > +
> > +	if (!(attr_flags & XFS_ATTR_NOLOCK))
> > +		xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > +
> > +	if (start < end - 1) {
> This is false, as expected.
> > +		/* punch out the page cache over the conversion range */
> > +		truncate_pagecache_range(VFS_I(ip), start, end - 1);
> > +		/* convert the blocks */
> > +		error = xfs_alloc_file_space(ip, start, end - start - 1,
> > +				    XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
> > +				    attr_flags);
> > +		if (error)
> > +			goto out_unlock;
> > +	} else {
> > +		/* it's a sub-rounding range */
> > +		ASSERT(offset + len <= rounding);
> This is false. (8K - 2) <= 4K -- Not so good.

Right, I put this in after testing without thinking too hard about
it. It's always completely wrong, because offset can be an arbitrary
64 bit number, and rounding will always be <=64k...

> Maybe (2*rounding) would be better, as offset + len could never be
> greater than 2rounding (but can be greater than 1rounding). Or removing
> this assert altogether.

No, the correct thing to assert is:

		ASSERT(offset + len <= start);

That is, start is rounded up, and end is rounded down, so for a
sub-block range the end should always be less than the start of the
next block. That's what my current code has in it.

> Beyond that, I think it all looks good and like what you've done!

Thanks for looking at it. now all I've got to do if fix all the test
output. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
