Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfHBPIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Aug 2019 11:08:41 -0400
Subject: Re: [PATCH 03/24] mm: factor shrinker work calculations
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-4-david@fromorbit.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e07bf57b-a9cb-cb7b-b2be-3ec1b355a184@suse.com>
Date: Fri, 2 Aug 2019 18:08:37 +0300
MIME-Version: 1.0
In-Reply-To: <20190801021752.4986-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org



On 1.08.19 г. 5:17 ч., Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Start to clean up the shrinker code by factoring out the calculation
> that determines how much work to do. This separates the calculation
> from clamping and other adjustments that are done before the
> shrinker work is run.
> 
> Also convert the calculation for the amount of work to be done to
> use 64 bit logic so we don't have to keep jumping through hoops to
> keep calculations within 32 bits on 32 bit systems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/vmscan.c | 74 ++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 47 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ae3035fe94bc..b7472953b0e6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -464,13 +464,45 @@ EXPORT_SYMBOL(unregister_shrinker);
>  
>  #define SHRINK_BATCH 128
>  
> +/*
> + * Calculate the number of new objects to scan this time around. Return
> + * the work to be done. If there are freeable objects, return that number in
> + * @freeable_objects.
> + */
> +static int64_t shrink_scan_count(struct shrink_control *shrinkctl,
> +			    struct shrinker *shrinker, int priority,
> +			    int64_t *freeable_objects)

nit: make the return parm definition also uin64_t, also we have u64 types.

> +{
> +	uint64_t delta;
> +	uint64_t freeable;
> +
> +	freeable = shrinker->count_objects(shrinker, shrinkctl);
> +	if (freeable == 0 || freeable == SHRINK_EMPTY)
> +		return freeable;
> +
> +	if (shrinker->seeks) {
> +		delta = freeable >> (priority - 2);
> +		do_div(delta, shrinker->seeks);

a comment about the reasoning behind this calculation would be nice.

> +	} else {
> +		/*
> +		 * These objects don't require any IO to create. Trim
> +		 * them aggressively under memory pressure to keep
> +		 * them from causing refetches in the IO caches.
> +		 */
> +		delta = freeable / 2;
> +	}
> +
> +	*freeable_objects = freeable;
> +	return delta > 0 ? delta : 0;
> +}
> +
>  static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  				    struct shrinker *shrinker, int priority)
>  {
>  	unsigned long freed = 0;
> -	unsigned long long delta;
>  	long total_scan;
> -	long freeable;
> +	int64_t freeable_objects = 0;
> +	int64_t scan_count;

why int and not uint64 ? We can never have negative object count, right?

>  	long nr;
>  	long new_nr;
>  	int nid = shrinkctl->nid;
> @@ -481,9 +513,10 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  	if (!(shrinker->flags & SHRINKER_NUMA_AWARE))
>  		nid = 0;
>  
> -	freeable = shrinker->count_objects(shrinker, shrinkctl);
> -	if (freeable == 0 || freeable == SHRINK_EMPTY)
> -		return freeable;
> +	scan_count = shrink_scan_count(shrinkctl, shrinker, priority,
> +					&freeable_objects);
> +	if (scan_count == 0 || scan_count == SHRINK_EMPTY)
> +		return scan_count;
>  
>  	/*
>  	 * copy the current shrinker scan count into a local variable
> @@ -492,25 +525,11 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  	 */
>  	nr = atomic_long_xchg(&shrinker->nr_deferred[nid], 0);
>  
> -	total_scan = nr;
> -	if (shrinker->seeks) {
> -		delta = freeable >> priority;
> -		delta *= 4;
> -		do_div(delta, shrinker->seeks);
> -	} else {
> -		/*
> -		 * These objects don't require any IO to create. Trim
> -		 * them aggressively under memory pressure to keep
> -		 * them from causing refetches in the IO caches.
> -		 */
> -		delta = freeable / 2;
> -	}
> -
> -	total_scan += delta;
> +	total_scan = nr + scan_count;
>  	if (total_scan < 0) {
>  		pr_err("shrink_slab: %pS negative objects to delete nr=%ld\n",
>  		       shrinker->scan_objects, total_scan);
> -		total_scan = freeable;
> +		total_scan = scan_count;
>  		next_deferred = nr;
>  	} else
>  		next_deferred = total_scan;
> @@ -527,19 +546,20 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  	 * Hence only allow the shrinker to scan the entire cache when
>  	 * a large delta change is calculated directly.
>  	 */
> -	if (delta < freeable / 4)
> -		total_scan = min(total_scan, freeable / 2);
> +	if (scan_count < freeable_objects / 4)
> +		total_scan = min_t(long, total_scan, freeable_objects / 2);
>  
>  	/*
>  	 * Avoid risking looping forever due to too large nr value:
>  	 * never try to free more than twice the estimate number of
>  	 * freeable entries.
>  	 */
> -	if (total_scan > freeable * 2)
> -		total_scan = freeable * 2;
> +	if (total_scan > freeable_objects * 2)
> +		total_scan = freeable_objects * 2;
>  
>  	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
> -				   freeable, delta, total_scan, priority);
> +				   freeable_objects, scan_count,
> +				   total_scan, priority);
>  
>  	/*
>  	 * If the shrinker can't run (e.g. due to gfp_mask constraints), then
> @@ -564,7 +584,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>  	 * possible.
>  	 */
>  	while (total_scan >= batch_size ||
> -	       total_scan >= freeable) {
> +	       total_scan >= freeable_objects) {
>  		unsigned long ret;
>  		unsigned long nr_to_scan = min(batch_size, total_scan);
>  
> 
