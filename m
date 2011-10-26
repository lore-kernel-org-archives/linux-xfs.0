Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QL7bcP036210 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 16:07:37 -0500
Message-ID: <1319663253.5239.75.camel@doink>
Subject: Re: [PATCH 3/4] xfs: replace i_pin_wait with a bit waitqueue
From: Alex Elder <aelder@sgi.com>
Date: Wed, 26 Oct 2011 16:07:33 -0500
In-Reply-To: <20111019182421.048260722@bombadil.infradead.org>
References: <20111019182343.762985925@bombadil.infradead.org>
	<20111019182421.048260722@bombadil.infradead.org>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-10-19 at 14:23 -0400, Christoph Hellwig wrote:
> Replace i_pin_wait, which is only used during synchronous inode flushing
> with a bit waitqueue.  This trades off a much smaller inode against
> slightly slower wakeup performance, and saves 12 (32-bit) or 20 (64-bit)
> bytes in the XFS inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One minor suggestion, plus some discussion from
inside my head below.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -2163,14 +2163,29 @@ xfs_iunpin_nowait(
>  
>  }
>  
> +static void
> +__xfs_iunpin_wait(
> +	struct xfs_inode	*ip)
> +{
> +	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_IPINNED_BIT);
> +	DEFINE_WAIT_BIT(q, &ip->i_flags, __XFS_IPINNED_BIT);

In your last patch, you used "wait" as the name
rather than "q".  Minor consistency nit...

> +	xfs_iunpin(ip);
> +

This initially struck me as unsafe or something,
assuming the inode was pinned.  But I was thinking
of it more like an unlock request, which it is not.
It's more like unplugging something so the inode
will eventually get unpinned.  (Just thinking aloud
here, nevermind me...)

> +	do {
> +		prepare_to_wait(wq, &q.wait, TASK_UNINTERRUPTIBLE);
> +		if (xfs_ipincount(ip))
> +			io_schedule();
> +	} while (xfs_ipincount(ip));
> +	finish_wait(wq, &q.wait);
> +}
> +
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
