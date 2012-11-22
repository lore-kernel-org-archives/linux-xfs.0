Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAM58KiQ149366 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 23:08:20 -0600
Message-ID: <50ADB3AA.302@sgi.com>
Date: Wed, 21 Nov 2012 23:10:02 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
	<50A3E86A.2060402@sgi.com> <50A3F80C.7050502@sgi.com>
	<20121121080502.GP2591@dastard>
In-Reply-To: <20121121080502.GP2591@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 11/21/2012 02:05 AM, Dave Chinner wrote:
...
> 
> [ Here's a tip for the future: anything that changes allocation
> corner cases needs to be run through the entire of xfstests suite
> because they have a nasty habit of causing secondary problems.... ]
> 
Makes sense -- I'll keep that in mind for the future. (Thanks!)

...

> +
> +STATIC int
> +xfs_zero_file_space(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		len,
> +	int			attr_flags)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uint			rounding;
> +	xfs_off_t		start;
> +	xfs_off_t		end;
> +	int			error;
> +
> +	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
Let's say rounding is 4K
> +
> +	/* round the range iof extents we are going to convert inwards */
> +	start = round_up(offset, rounding);
> +	end = round_down(offset + len, rounding);
Now, let's say we pass in (4K-1) for the offset and (4K-1).

Then start would be 4K and the end would be 4K, right?

> +
> +	ASSERT(start >= offset);
> +	ASSERT(end <= offset + len);
These are both true, so this is good.
> +
> +	if (!(attr_flags & XFS_ATTR_NOLOCK))
> +		xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +
> +	if (start < end - 1) {
This is false, as expected.
> +		/* punch out the page cache over the conversion range */
> +		truncate_pagecache_range(VFS_I(ip), start, end - 1);
> +		/* convert the blocks */
> +		error = xfs_alloc_file_space(ip, start, end - start - 1,
> +				    XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
> +				    attr_flags);
> +		if (error)
> +			goto out_unlock;
> +	} else {
> +		/* it's a sub-rounding range */
> +		ASSERT(offset + len <= rounding);
This is false. (8K - 2) <= 4K -- Not so good.

Maybe (2*rounding) would be better, as offset + len could never be
greater than 2rounding (but can be greater than 1rounding). Or removing
this assert altogether.

> +		error = xfs_iozero(ip, offset, len);
> +		goto out_unlock;
> +	}
> +
> +	/* now we've handled the interior of the range, handle the edges */
> +	if (start != offset)
> +		error = xfs_iozero(ip, offset, start - offset);
> +	if (!error && end != offset + len)
> +		error = xfs_iozero(ip, end, offset + len - end);
This looks good.
> +
> +out_unlock:
> +	if (!(attr_flags & XFS_ATTR_NOLOCK))
> +		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	return error;
...

Beyond that, I think it all looks good and like what you've done!

Thanks,

Andrew

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
