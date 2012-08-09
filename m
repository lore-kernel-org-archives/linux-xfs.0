Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79MlcVl235367 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 17:47:38 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wMcIDH2FxZDiyDcy for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 15:47:36 -0700 (PDT)
Date: Fri, 10 Aug 2012 08:47:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix race while discarding buffers [V3]
Message-ID: <20120809224733.GY2877@dastard>
References: <1344274576-13292-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1344274576-13292-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 06, 2012 at 02:36:16PM -0300, Carlos Maiolino wrote:
> While xfs_buftarg_shrink() is freeing buffers from the dispose list (filled with
> buffers from lru list), there is a possibility to have xfs_buf_stale() racing
> with it, and removing buffers from dispose list before xfs_buftarg_shrink() does
> it.
> 
> This happens because xfs_buftarg_shrink() handle the dispose list without
> locking and since the test condition in xfs_buf_stale()
> -- if (!list_empty(&bp->b_lru)) -- checks for the buffer being in *any* list, if
> the buffer happens to be on dispose list, this causes the buffer counter of the
> lru list (btp->bt_lru_nr) to be decremented twice (once in xfs_buftarg_shrink()
> and another in xfs_buf_stale()) causing a wrong account usage of the lru list,
> which may cause xfs_buftarg_shrink() to return a wrong value to the memory
> shrinker function (shrink_slab()), such account error may also cause a
> underflowed value to be returned; since the counter is lower than the current
> number of items in the lru list, a decrement may happen when the counter is 0,
> causing an underflow since the counter is an unsigned value.

Can you break that up into more than one sentence? It's also good
when quoting code to separate it out like:

	if (!list_empty(&bp->b_lru))

this.

> The fix uses a new flag field (and a new buffer flag) to serialize buffer
> handling during the shrink process. The new flag fied has been designed to use
> btp->bt_lru_lock/unlock instead of xfs_buf_lock/unlock mechanism.
> 
> Thanks to dchinner, sandeen and aris for the help and hints on this
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 7 ++++++-
>  fs/xfs/xfs_buf.h | 7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d7a9dd7..196ec32 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -96,6 +96,8 @@ xfs_buf_lru_add(
>  		atomic_inc(&bp->b_hold);
>  		list_add_tail(&bp->b_lru, &btp->bt_lru);
>  		btp->bt_lru_nr++;
> +		if (bp->b_lru_flags & XBF_LRU_DISPOSE)
> +			bp->b_lru_flags &= ~XBF_LRU_DISPOSE;

I'd just unconditionally clear the flag. if you place the
b_lru_flags variable in the same cacheline as b_lru, then it we
already have the cacheline dirty in cache, so we avoid a test and
branch and so is slightly faster....

>  	}
>  	spin_unlock(&btp->bt_lru_lock);
>  }
> @@ -154,7 +156,8 @@ xfs_buf_stale(
>  		struct xfs_buftarg *btp = bp->b_target;
>  
>  		spin_lock(&btp->bt_lru_lock);
> -		if (!list_empty(&bp->b_lru)) {
> +		if (!list_empty(&bp->b_lru) &&
> +		   !(bp->b_lru_flags & XBF_LRU_DISPOSE)) {

Line up the indents according to the same level of evaluation. i.e

		if (!list_empty(&bp->b_lru) &&
		    !(bp->b_lru_flags & XBF_LRU_DISPOSE)) {
		   ^^^

>  			list_del_init(&bp->b_lru);
>  			btp->bt_lru_nr--;
>  			atomic_dec(&bp->b_hold);
> @@ -228,6 +231,7 @@ _xfs_buf_alloc(
>  	XB_SET_OWNER(bp);
>  	bp->b_target = target;
>  	bp->b_flags = flags;
> +	bp->b_lru_flags = 0;

No need to initialise to zero - the structure is zeroed after
allocation.

>  
>  	/*
>  	 * Set length and io_length to the same value initially.
> @@ -1501,6 +1505,7 @@ xfs_buftarg_shrink(
>  		 */
>  		list_move(&bp->b_lru, &dispose);
>  		btp->bt_lru_nr--;
> +		bp->b_lru_flags |= XBF_LRU_DISPOSE;
>  	}
>  	spin_unlock(&btp->bt_lru_lock);
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d03b73b..ec0a17e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -60,6 +60,9 @@ typedef enum {
>  #define _XBF_DELWRI_Q	(1 << 22)/* buffer on a delwri queue */
>  #define _XBF_COMPOUND	(1 << 23)/* compound buffer */
>  
> +/* flags used to handle lru items */
> +#define XBF_LRU_DISPOSE (1 << 24) /* buffer being discarded */
> +

This is an internal flag, so should have a leading "_". The
preceding comment isn't really necessary, either. i.e:

 #define _XBF_COMPOUND	(1 << 23)/* compound buffer */
+#define _XBF_LRU_DISPOSE (1 << 24) /* buffer being discarded */
+
 typedef unsigned int xfs_buf_flags_t;

> @@ -122,6 +126,7 @@ typedef struct xfs_buf {
>  	atomic_t		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
> +	xfs_buf_flags_t		b_lru_flags;	/* internal lru status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
>  
>  	struct list_head	b_lru;		/* lru list */

That places the b_lru_flags on a different cacheline to b_lru. it
also pushed b_sema further more onto the second cacheline than the
first, and that's a problem:

typedef struct xfs_buf {
        /*
         * first cacheline holds all the fields needed for an uncontended cache
         * hit to be fully processed. The semaphore straddles the cacheline
         * boundary, but the counter and lock sits on the first cacheline,
         * which is the only bit that is touched if we hit the semaphore
         * fast-path on locking.
	 */

So adding things to the first cacheline of the struct xfs_buf is a
Bad Thing To Do. ;)

Just move it to below the b_lru field, and it shoul dbe fine.

FWIW, pahole is your friend - this is the current layout:

$ pahole fs/xfs/xfs_buf.o | grep -A 10 "^struct xfs_buf {"
struct xfs_buf {
        struct rb_node             b_rbnode;             /*     0    24 */
        xfs_daddr_t                b_bn;                 /*    24     8 */
        int                        b_length;             /*    32     4 */
        atomic_t                   b_hold;               /*    36     4 */
        atomic_t                   b_lru_ref;            /*    40     4 */
        xfs_buf_flags_t            b_flags;              /*    44     4 */
        struct semaphore           b_sema;               /*    48    48 */
        /* --- cacheline 1 boundary (64 bytes) was 32 bytes ago --- */
        struct list_head           b_lru;                /*    96    16 */
        wait_queue_head_t          b_waiters;            /*   112    40 */
....

Also, you need to document that concurrent access to b_lru_flags is
protected by the bt_lru_lock (same as b_lru), not the b_sema....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
