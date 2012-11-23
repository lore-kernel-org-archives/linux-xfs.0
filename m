Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN8VsX4048253 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 02:31:55 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6tEWqgv3rbU5HAEH (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 00:34:04 -0800 (PST)
Date: Fri, 23 Nov 2012 03:34:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121123083403.GB24938@infradead.org>
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
	<1353641065-14983-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1353641065-14983-4-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Nov 23, 2012 at 02:24:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
> aligned ranges. Neither test 242 or 290 exercise this correctly, so
> the behaviour is completely busted even though the tests pass.
> 
> Fix it to support full byte range granularity as was originally
> intended for this ioctl.

Looks good, but a couple cosmetic comments below:

> +	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);

I'd call this granularity.

> +	/* round the range iof extents we are going to convert inwards */
> +	start = round_up(offset, rounding);
> +	end = round_down(offset + len, rounding);

start_boundary, end_boundary?

> +	if (start < end - 1) {
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
> +		ASSERT(offset + len <= start);
> +		error = xfs_iozero(ip, offset, len);
> +		goto out_unlock;
> +	}
> +
> +	/* now we've handled the interior of the range, handle the edges */
> +	if (start != offset)
> +		error = xfs_iozero(ip, offset, start - offset);
> +	if (!error && end != offset + len)
> +		error = xfs_iozero(ip, end, offset + len - end);

I'd move the edge iozero calls into the if branch, that gives a natural
code flow and avoids the goto unlock in the sub-page case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
