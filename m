Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13FB67F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:47:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 969D0AC007
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 22:47:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id SGgNwEWrko6KK3n5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 22:47:06 -0700 (PDT)
Date: Thu, 24 Apr 2014 22:47:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Message-ID: <20140425054705.GA30118@infradead.org>
References: <1398315722-20870-1-git-send-email-david@fromorbit.com>
	<1398315722-20870-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398315722-20870-4-git-send-email-david@fromorbit.com>
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

On Thu, Apr 24, 2014 at 03:01:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prefetch currently does not do CRC validation when the IO completes
> due to the optimisation it performs and the fact that it does not
> know what the type of metadata into the buffer is supposed to be.
> Hence, mark all prefetched buffers as "suspect" so that when the
> end user tries to read it with a supplied validation function the
> validation is run even though the buffer was already in the cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, but a few minor nitpicks below:

> +		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
> +			bp->b_error = 0;
> +			bp->b_ops = ops;
> +			bp->b_ops->verify_read(bp);
> +			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +		}

There's three copies of code in the previous and this patch, it probably
should go into a helper function.

> +	else if (bp->b_ops) {
>  		bp->b_ops->verify_read(bp);
> +		bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> +	}

Same with this.

>  		bp->b_flags |= LIBXFS_B_UPTODATE;
>  		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT);
> +		bp->b_flags &= ~LIBXFS_B_UNCHECKED;

Any reason not to clear all three flags in a single line?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
