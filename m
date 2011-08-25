Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7PKuNwv238159 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 15:56:24 -0500
Subject: Re: [PATCH 3/6] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314256626-11136-4-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-4-git-send-email-david@fromorbit.com>
Date: Thu, 25 Aug 2011 15:56:18 -0500
Message-ID: <1314305778.3136.100.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Stats show that for an 8-way unlink @ ~80,000 unlinks/s we are doing
> ~1 million cache hit lookups to ~3000 buffer creates. That's almost
> 3 orders of magnitude more cahce hits than misses, so optimising for
> cache hits is quite important. In the cache hit case, we do not need
> to allocate a new buffer in case of a cache miss, so we are
> effectively hitting the allocator for no good reason for vast the
> majority of calls to _xfs_buf_find. 8-way create workloads are
> showing similar cache hit/miss ratios.
> 
> The result is profiles that look like this:
> 
>      samples  pcnt function                        DSO
>      _______ _____ _______________________________ _________________
> 
>      1036.00 10.0% _xfs_buf_find                   [kernel.kallsyms]
>       582.00  5.6% kmem_cache_alloc                [kernel.kallsyms]
>       519.00  5.0% __memcpy                        [kernel.kallsyms]
>       468.00  4.5% __ticket_spin_lock              [kernel.kallsyms]
>       388.00  3.7% kmem_cache_free                 [kernel.kallsyms]
>       331.00  3.2% xfs_log_commit_cil              [kernel.kallsyms]
> 
> 
> Further, there is a fair bit of work involved in initialising a new
> buffer once a cache miss has occurred and we currently do that under
> the rbtree spinlock. That increases spinlock hold time on what are
> heavily used trees.
> 
> To fix this, remove the initialisation of the buffer from
> _xfs_buf_find() and only allocate the new buffer once we've had a
> cache miss. Initialise the buffer immediately after allocating it in
> xfs_buf_get, too, so that is it ready for insert if we get another
> cache miss after allocation. This minimises lock hold time and
> avoids unnecessary allocator churn. The resulting profiles look
> like:
> 
>      samples  pcnt function                    DSO
>      _______ _____ ___________________________ _________________
> 
>      8111.00  9.1% _xfs_buf_find               [kernel.kallsyms]
>      4380.00  4.9% __memcpy                    [kernel.kallsyms]
>      4341.00  4.8% __ticket_spin_lock          [kernel.kallsyms]
>      3401.00  3.8% kmem_cache_alloc            [kernel.kallsyms]
>      2856.00  3.2% xfs_log_commit_cil          [kernel.kallsyms]
>      2625.00  2.9% __kmalloc                   [kernel.kallsyms]
>      2380.00  2.7% kfree                       [kernel.kallsyms]
>      2016.00  2.3% kmem_cache_free             [kernel.kallsyms]
> 
> Showing a significant reduction in time spent doing allocation and
> freeing from slabs (kmem_cache_alloc and kmem_cache_free).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This is a good change, but I found one bug (of omission).
I also have a pretty harmless suggestion, plus suggest
some type changes.

For now I have corrected the bug and implemented the
one suggestion but not the type changes in my own copy
of this patch and am testing with it.  If you are
comfortable with that, I can commit my modified version.
The type changes can go in separately (they might expand
a bit to affect other code anyway).

Otherwise if you fix the bug you can consider this
reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_buf.c |   87 +++++++++++++++++++++++++++++++-----------------------
>  1 files changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c57836d..6fffa06 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -171,10 +171,16 @@ STATIC void
>  _xfs_buf_initialize(
>  	xfs_buf_t		*bp,
>  	xfs_buftarg_t		*target,
> -	xfs_off_t		range_base,
> -	size_t			range_length,
> +	xfs_off_t		bno,
> +	size_t			num_blocks,

Since you are now passing block numbers and block counts
rather than byte offsets and counts the types of these
arguments should be changed accordingly.  I believe the
right types are xfs_daddr_t and xfs_filblks_t; the latter
doesn't exactly fit the usage but it's consistent with
how it's used elsewhere.

This is the type change I mentioned above.  It applies
in several places below (where I'll just mention them
briefly).

>  	xfs_buf_flags_t		flags)
>  {
> +	xfs_off_t		range_base;
> +	size_t			range_length;
> +
> +	range_base = BBTOB(bno);
> +	range_length = BBTOB(num_blocks);
> +
>  	/*
>  	 * We don't want certain flags to appear in b_flags.
>  	 */
> @@ -423,9 +429,9 @@ _xfs_buf_map_pages(
>   */
>  xfs_buf_t *
>  _xfs_buf_find(
> -	xfs_buftarg_t		*btp,	/* block device target		*/
> -	xfs_off_t		ioff,	/* starting offset of range	*/
> -	size_t			isize,	/* length of range		*/
> +	xfs_buftarg_t		*btp,
> +	xfs_off_t		bno,
> +	size_t			num_blocks,

Type change.  (I know in this case you only changed the name,
but the type was wrong to begin with.)

>  	xfs_buf_flags_t		flags,
>  	xfs_buf_t		*new_bp)
>  {

. . .

> @@ -525,34 +529,43 @@ found:
>  }
>  
>  /*
> - *	Assembles a buffer covering the specified range.
> - *	Storage in memory for all portions of the buffer will be allocated,
> - *	although backing storage may not be.
> + * Assembles a buffer covering the specified range. The code needs to be

Maybe say "is" rather than "needs to be" here.

> + * optimised for cache hits, as metadata intensive workloads will see 3 orders
> + * of magnitude more hits than misses.
>   */
> -xfs_buf_t *
> +struct xfs_buf *
>  xfs_buf_get(
> -	xfs_buftarg_t		*target,/* target for buffer		*/
> -	xfs_off_t		ioff,	/* starting offset of range	*/
> -	size_t			isize,	/* length of range		*/
> +	struct xfs_buftarg	*target,
> +	xfs_off_t		bno,
> +	size_t			num_blocks,

Type change.  (Again, types weren't really right to begin with.)
Fixing this maybe ought to be done more pervasively; the types
for values passed in the num_blocks argument are a mix of __u64,
int and size_t.


>  	xfs_buf_flags_t		flags)
>  {
> -	xfs_buf_t		*bp, *new_bp;
> +	struct xfs_buf		*bp;
> +	struct xfs_buf		*new_bp = NULL;
>  	int			error = 0;
>  
> +	bp = _xfs_buf_find(target, bno, num_blocks, flags, new_bp);

I'd rather an explicit NULL be used above for the last argument.
(I've made this change to my own version of this patch.)

> +	if (likely(bp))
> +		goto found;
> +
>  	new_bp = xfs_buf_allocate(flags);
>  	if (unlikely(!new_bp))
>  		return NULL;
>  
> -	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
> +	_xfs_buf_initialize(new_bp, target, bno, num_blocks, flags);
> +

. . .

> @@ -790,7 +803,7 @@ xfs_buf_get_uncached(
>  	bp = xfs_buf_allocate(0);
>  	if (unlikely(bp == NULL))
>  		goto fail;
> -	_xfs_buf_initialize(bp, target, 0, len, 0);
> +	_xfs_buf_initialize(bp, target, 0, BTOBB(len), 0);
>  
>  	error = _xfs_buf_get_pages(bp, page_count, 0);
>  	if (error)

And the only remaining problem is the bug.  You need to make
a change comparable to what's right here in xfs_buf_get_empty().
I.e., that function needs to pass a block count rather than
a byte length.  (I have made this change in my own copy.)





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
