Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD2MCNc133064 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 20:22:13 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8E432B9F8B
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:22:10 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tldSHTmbebnJ5S7L for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 18:22:10 -0800 (PST)
Date: Tue, 13 Dec 2011 13:22:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/12] repair: use recursive buffer locking
Message-ID: <20111213022208.GZ14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.106589485@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174742.106589485@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:25PM -0500, Christoph Hellwig wrote:
> On a sufficiently corrupt filesystem walking the btree nodes might hit the
> same node node again, which currently will deadlock.  Use a recursion
> counter to avoid the direct deadlock and let them normal loop detection
> (two bad nodes and out) do its work.  This is how repair behaved before
> we added the lock when implementing buffer prefetching.
> 
> Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/include/libxfs.h
> ===================================================================
> --- xfsprogs-dev.orig/include/libxfs.h	2011-11-22 22:28:23.000000000 +0000
> +++ xfsprogs-dev/include/libxfs.h	2011-11-22 22:34:27.000000000 +0000
> @@ -226,6 +226,8 @@ typedef struct xfs_buf {
>  	unsigned		b_bcount;
>  	dev_t			b_dev;
>  	pthread_mutex_t		b_lock;
> +	pthread_t		b_holder;
> +	unsigned int		b_recur;
>  	void			*b_fsprivate;
>  	void			*b_fsprivate2;
>  	void			*b_fsprivate3;
> Index: xfsprogs-dev/libxfs/rdwr.c
> ===================================================================
> --- xfsprogs-dev.orig/libxfs/rdwr.c	2011-11-22 22:28:23.000000000 +0000
> +++ xfsprogs-dev/libxfs/rdwr.c	2011-11-22 22:40:01.000000000 +0000
> @@ -342,6 +342,8 @@ libxfs_initbuf(xfs_buf_t *bp, dev_t devi
>  	list_head_init(&bp->b_lock_list);
>  #endif
>  	pthread_mutex_init(&bp->b_lock, NULL);
> +	bp->b_holder = 0;
> +	bp->b_recur = 0;
>  }
>  
>  xfs_buf_t *
> @@ -410,18 +412,24 @@ libxfs_getbuf_flags(dev_t device, xfs_da
>  		return NULL;
>  
>  	if (use_xfs_buf_lock) {
> -		if (flags & LIBXFS_GETBUF_TRYLOCK) {
> -			int ret;
> +		int ret;
>  
> -			ret = pthread_mutex_trylock(&bp->b_lock);
> -			if (ret) {
> -				ASSERT(ret == EAGAIN);
> -				cache_node_put(libxfs_bcache, (struct cache_node *)bp);
> -				return NULL;
> +		ret = pthread_mutex_trylock(&bp->b_lock);
> +		if (ret) {
> +			ASSERT(ret == EAGAIN);
> +			if (flags & LIBXFS_GETBUF_TRYLOCK)
> +				goto out_put;
> +
> +			if (pthread_equal(bp->b_holder, pthread_self())) {
> +				fprintf(stderr,
> +	_("recursive buffer locking detected\n"));

"Warning: recursive buffer locking @ bno %lld detected"

might be more informative, especially to do with the severity of the
issue.

> +				bp->b_recur++;
> +			} else {
> +				pthread_mutex_lock(&bp->b_lock);
>  			}
> -		} else {
> -			pthread_mutex_lock(&bp->b_lock);
>  		}
> +
> +		bp->b_holder = pthread_self();

That should probably only be written in the branch where the lock is
taken not every time through here.

Also, it might be worth commenting that the only reason there isn't
a race checking bp->b_holder without holding a lock is that the
holder is initialised to zero and cleared before the buffer lock is
dropped so that when a concurrent lookup fails the value of b_holder
will never match the failed thread ID.

Otherwise, looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
