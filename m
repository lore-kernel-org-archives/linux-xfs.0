Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J0gAf8142513 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 19:42:11 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 566471D8A7C
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:42:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4uyvNFu4TaL88WeI for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 17:42:09 -0700 (PDT)
Date: Wed, 19 Oct 2011 11:42:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: replace i_flock with a sleeping bitlock
Message-ID: <20111019004206.GB21338@dastard>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.357001594@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111018201405.357001594@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 18, 2011 at 04:13:06PM -0400, Christoph Hellwig wrote:
> We almost never block on i_flock, the exception is synchronous inode
> flushing.  Instead of bloating the inode with a 16/24-byte completion
> that we abuse as a semaphore just implement it as a bitlock that uses
> a bit waitqueue for the rare sleeping path.  This primarily is a
> tradeoff between a much smaller inode and a faster non-blocking
> path vs a faster faster wakeups, and we are much better off with
> the former.
> 
> A small downside is that we will lose lockdep checking for i_flock, but
> given that it's always taken inside the ilock that should be acceptable.
> 
> Note that for example the inode writeback locking is implemented in a
> very similar way.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....
> @@ -716,3 +716,19 @@ xfs_isilocked(
>  	return 0;
>  }
>  #endif
> +
> +void
> +__xfs_iflock(
> +	struct xfs_inode	*ip)
> +{
> +	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IFLOCK);
> +	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_IFLOCK);
> +
> +	do {
> +		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
> +		if (xfs_isiflocked(ip))
> +			schedule();
> +	} while (!xfs_iflock_nowait(ip));
> +
> +	finish_wait(wq, &wait.wait);
> +}

Given that the only way that the inode will become unlocked is for
IO to complete, that makes this an IO wait, right? Perhaps this
should call io_schedule() in that case?

> @@ -380,6 +372,8 @@ static inline void xfs_ifunlock(xfs_inod
>  #define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
>  #define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
>  #define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
> +#define __XFS_IFLOCK		8	/* inode is beeing flushed right now */
> +#define XFS_IFLOCK		(1 << __XFS_IFLOCK)

Any reason for leaving a gap in the flag space here?

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
