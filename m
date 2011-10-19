Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J0oe1m142997 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 19:50:40 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD6C11D372C
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 17:50:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QSdnIQD0fdEnYYOS for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 17:50:38 -0700 (PDT)
Date: Wed, 19 Oct 2011 11:50:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: replace i_pin_wait with a bit waitqueue
Message-ID: <20111019005036.GC21338@dastard>
References: <20111018201304.279051318@bombadil.infradead.org>
	<20111018201405.557330194@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111018201405.557330194@bombadil.infradead.org>
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

On Tue, Oct 18, 2011 at 04:13:07PM -0400, Christoph Hellwig wrote:
> Replace i_pin_wait, which is only used during synchronous inode flushing
> with a bit waitqueue.  This trades off a much smaller inode against
> slightly slower wakeup performance, and saves 12 (32-bit) or 20 (64-bit)
> bytes in the XFS inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-10-18 20:58:40.141854067 +0200
> +++ xfs/fs/xfs/xfs_inode.c	2011-10-18 21:01:48.296353322 +0200
> @@ -2151,7 +2151,7 @@ xfs_idestroy_fork(
>   * once someone is waiting for it to be unpinned.
>   */
>  static void
> -xfs_iunpin_nowait(
> +xfs_iunpin(
>  	struct xfs_inode	*ip)
>  {
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> @@ -2163,14 +2163,29 @@ xfs_iunpin_nowait(
>  
>  }
>  
> +static void
> +__xfs_iunpin_wait(
> +	struct xfs_inode	*ip)
> +{
> +	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED);
> +	DEFINE_WAIT_BIT(q, &ip->i_flags, __XFS_IPINNED);
> +
> +	xfs_iunpin(ip);
> +
> +	do {
> +		prepare_to_wait(wq, &q.wait, TASK_UNINTERRUPTIBLE);
> +		if (xfs_ipincount(ip))
> +			schedule();
> +	} while (xfs_ipincount(ip));
> +	finish_wait(wq, &q.wait);
> +}

Same comment about io_schedule() here - it's an IO we're waiting to
complete here. And it's not an exclusive wait because we can have
multiple callers waiting on the inode being unpinned and we want
them all woken in one go?

> @@ -374,6 +373,7 @@ xfs_set_projid(struct xfs_inode *ip,
>  #define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
>  #define __XFS_IFLOCK		8	/* inode is beeing flushed right now */
>  #define XFS_IFLOCK		(1 << __XFS_IFLOCK)
> +#define __XFS_IPINNED		9	/* wakeup key for zero pin count */

Should you also define XFS_IPINNED for consistency, even though it
is not used?

Otherwise looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
