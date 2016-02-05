Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 248537CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 08:22:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 045CA8F8049
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 06:22:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xtnSLhhuAQVuR6U0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 06:22:22 -0800 (PST)
Date: Fri, 5 Feb 2016 09:22:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] libxfs: keep unflushable buffers off the cache MRUs
Message-ID: <20160205142220.GC52478@bfoster.bfoster>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454627108-19036-7-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 10:05:07AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There's no point trying to free buffers that are dirty and return
> errors on flush as we have to keep them around until the corruption
> is fixed. Hence if we fail to flush an inode during a cache shake,
> move the buffer to a special dirty MRU list that the cache does not
> shake. This prevents memory pressure from seeing these buffers, but
> allows subsequent cache lookups to still find them through the hash.
> This ensures we don't waste huge amounts of CPU trying to flush and
> reclaim buffers that canot be flushed or reclaimed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/cache.h |  3 ++-
>  libxfs/cache.c  | 78 ++++++++++++++++++++++++++++++++++++++++++---------------
>  2 files changed, 60 insertions(+), 21 deletions(-)
> 
...
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index a48ebd9..d4b4a4e 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
...
> @@ -183,15 +183,45 @@ cache_generic_bulkrelse(
>  }
>  
...
> +/*
> + * We've hit the limit on cache size, so we need to start reclaiming nodes we've
> + * used. The MRU specified by the priority is shaken.  Returns new priority at
> + * end of the call (in case we call again). We are not allowed to reclaim dirty
> + * objects, so we have to flush them first. If flushing fails, we move them to
> + * the "dirty, unreclaimable" list.
> + *
> + * Hence we skip priorities > CACHE_MAX_PRIORITY unless "purge" is set as we
> + * park unflushable (and hence unreclaimable) buffers at these priorities.
> + * Trying to shake unreclaimable buffer lists whent here is memory pressure is a

						typo ^

> + * waste of time and CPU and greatly slows down cache node recycling operations.
> + * Hence we only try to free them if we are being asked to purge the cache of
> + * all entries.
>   */
>  static unsigned int
>  cache_shake(
>  	struct cache *		cache,
>  	unsigned int		priority,
> -	int			all)
> +	bool			purge)
>  {
>  	struct cache_mru	*mru;
>  	struct cache_hash *	hash;
> @@ -202,10 +232,11 @@ cache_shake(
>  	struct cache_node *	node;
>  	unsigned int		count;
>  
> -	ASSERT(priority <= CACHE_MAX_PRIORITY);
> -	if (priority > CACHE_MAX_PRIORITY)
> +	ASSERT(priority <= CACHE_DIRTY_PRIORITY);
> +	if (priority > CACHE_MAX_PRIORITY && !purge)
>  		priority = 0;
>  
> +

... and still an extra newline here. Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	mru = &cache->c_mrus[priority];
>  	count = 0;
>  	list_head_init(&temp);
> @@ -219,8 +250,10 @@ cache_shake(
>  		if (pthread_mutex_trylock(&node->cn_mutex) != 0)
>  			continue;
>  
> -		/* can't release dirty objects */
> -		if (cache->flush(node)) {
> +		/* memory pressure is not allowed to release dirty objects */
> +		if (cache->flush(node) && !purge) {
> +			cache_move_to_dirty_mru(cache, node);
> +			mru->cm_count--;
>  			pthread_mutex_unlock(&node->cn_mutex);
>  			continue;
>  		}
> @@ -242,7 +275,7 @@ cache_shake(
>  		pthread_mutex_unlock(&node->cn_mutex);
>  
>  		count++;
> -		if (!all && count == CACHE_SHAKE_COUNT)
> +		if (!purge && count == CACHE_SHAKE_COUNT)
>  			break;
>  	}
>  	pthread_mutex_unlock(&mru->cm_mutex);
> @@ -423,7 +456,7 @@ next_object:
>  		node = cache_node_allocate(cache, key);
>  		if (node)
>  			break;
> -		priority = cache_shake(cache, priority, 0);
> +		priority = cache_shake(cache, priority, false);
>  		/*
>  		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
>  		 * back the same priority, if not we get back priority+1.
> @@ -578,8 +611,8 @@ cache_purge(
>  {
>  	int			i;
>  
> -	for (i = 0; i <= CACHE_MAX_PRIORITY; i++)
> -		cache_shake(cache, i, 1);
> +	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++)
> +		cache_shake(cache, i, true);
>  
>  #ifdef CACHE_DEBUG
>  	if (cache->c_count != 0) {
> @@ -626,13 +659,13 @@ cache_flush(
>  #define	HASH_REPORT	(3 * HASH_CACHE_RATIO)
>  void
>  cache_report(
> -	FILE 			*fp,
> -	const char 		*name,
> -	struct cache 		*cache)
> +	FILE		*fp,
> +	const char	*name,
> +	struct cache	*cache)
>  {
> -	int 			i;
> -	unsigned long 		count, index, total;
> -	unsigned long 		hash_bucket_lengths[HASH_REPORT + 2];
> +	int		i;
> +	unsigned long	count, index, total;
> +	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
>  
>  	if ((cache->c_hits + cache->c_misses) == 0)
>  		return;
> @@ -662,6 +695,11 @@ cache_report(
>  			i, cache->c_mrus[i].cm_count,
>  			cache->c_mrus[i].cm_count * 100 / cache->c_count);
>  
> +	i = CACHE_DIRTY_PRIORITY;
> +	fprintf(fp, "Dirty MRU %d entries = %6u (%3u%%)\n",
> +		i, cache->c_mrus[i].cm_count,
> +		cache->c_mrus[i].cm_count * 100 / cache->c_count);
> +
>  	/* report hash bucket lengths */
>  	bzero(hash_bucket_lengths, sizeof(hash_bucket_lengths));
>  
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
