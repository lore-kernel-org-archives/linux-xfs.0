Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o729Whak181777 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 04:32:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10B4A15CE77B
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 02:40:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aXOqjyROA1ETjGVL for
	<xfs@oss.sgi.com>; Mon, 02 Aug 2010 02:40:53 -0700 (PDT)
Date: Mon, 2 Aug 2010 05:32:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] dio: scale unaligned IO tracking via multiple lists
Message-ID: <20100802093259.GB7612@infradead.org>
References: <1280733945-16231-1-git-send-email-david@fromorbit.com>
	<1280733945-16231-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280733945-16231-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Mon, Aug 02, 2010 at 05:25:45PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To avoid concerns that a single list and lock tracking the unaligned IOs
> will not scale appropriately, create multiple lists and locks and chose them by
> hashing the unaligned block being zeroed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/direct-io.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 611524e..95dcba4 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -152,8 +152,29 @@ struct dio_zero_block {
>  	atomic_t	ref;		/* reference count */
>  };
>  
> -DEFINE_SPINLOCK(dio_zero_block_lock);
> -LIST_HEAD(dio_zero_block_list);
> +#define DIO_ZERO_BLOCK_NR	37LL
> +struct dio_zero_block_head {
> +	struct list_head	list;
> +	spinlock_t		lock;
> +};
> +
> +struct dio_zero_block_head dio_zero_blocks[DIO_ZERO_BLOCK_NR];

Again, should be static.

> +#define to_dio_zero_list(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR].list)
> +#define to_dio_zero_lock(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR].lock)

> +	struct list_head *list  = to_dio_zero_list(zero_block);
> +	spinlock_t *lock = to_dio_zero_lock(zero_block);

What about just finding the dio_zero_block_head and stuffing it into
a local variable?  Probably doesn't matter in the end anyway.

Also looks good.

If people really care about making this scale better we could also make
it per-sb. 

One really big problem is that no one tells the users that unaligned
direct I/O is a performance problem.  We should add a variant of the
XFS DIOINFO ioctl to the core VFS, including minimally required and
optimal alignment values.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
