Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E72F929DF5
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:34:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D023E304066
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 10:34:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yc5JY0Q4EjZkWuOc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 10:34:19 -0800 (PST)
Date: Tue, 5 Jan 2016 13:34:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] libxfs: keep unflushable buffers off the cache MRUs
Message-ID: <20160105183417.GE38749@bfoster.bfoster>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
	<1450733829-9319-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450733829-9319-10-git-send-email-david@fromorbit.com>
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

On Tue, Dec 22, 2015 at 08:37:09AM +1100, Dave Chinner wrote:
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
>  libxfs/cache.c  | 34 +++++++++++++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 6 deletions(-)
> 
...
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index a48ebd9..d5ea461 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
...
> @@ -202,10 +223,11 @@ cache_shake(
>  	struct cache_node *	node;
>  	unsigned int		count;
>  
> -	ASSERT(priority <= CACHE_MAX_PRIORITY);
> -	if (priority > CACHE_MAX_PRIORITY)
> +	ASSERT(priority <= CACHE_DIRTY_PRIORITY);
> +	if (priority > CACHE_MAX_PRIORITY && !all)
>  		priority = 0;
>  
> +

Extra newline. FWIW, it also looks like the only cache_shake() caller
where all == 0 already prevents calling with priority >
CACHE_MAX_PRIORITY. I think a brief comment in one or both places with
regard to why >max priority is skipped unless 'all == 1' would be good,
though.

Also, it looks like the loop in cache_report() could be updated to dump
the dirty priority mru entry count.

Finally, what happens once a buffer on the dirty mru is fully repaired,
rewritten and released? Is it placed right back on the "unshakeable"
dirty mru or is cn_priority updated somewhere? On further digging, it
looks like a subsequent buffer lookup (__cache_lookup()) drops the
priority, though it appears to be designed to deal with prefetched
buffers and the associated B_INODE..B_DIR_BMAP mappings.

Brian

>  	mru = &cache->c_mrus[priority];
>  	count = 0;
>  	list_head_init(&temp);
> @@ -221,6 +243,8 @@ cache_shake(
>  
>  		/* can't release dirty objects */
>  		if (cache->flush(node)) {
> +			cache_move_to_dirty_mru(cache, node);
> +			mru->cm_count--;
>  			pthread_mutex_unlock(&node->cn_mutex);
>  			continue;
>  		}
> @@ -578,7 +602,7 @@ cache_purge(
>  {
>  	int			i;
>  
> -	for (i = 0; i <= CACHE_MAX_PRIORITY; i++)
> +	for (i = 0; i <= CACHE_DIRTY_PRIORITY; i++)
>  		cache_shake(cache, i, 1);
>  
>  #ifdef CACHE_DEBUG
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
