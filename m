Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LE4VNQ147483 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 09:04:32 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB8921C2F26B
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:04:30 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id L0nTCWED62wRCVqY for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 07:04:30 -0700 (PDT)
Date: Wed, 21 Sep 2011 15:04:23 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [patch 1/4] mm: exclude reserved pages from dirtyable memory
Message-ID: <20110921140423.GG4849@suse.de>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-2-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316526315-16801-2-git-send-email-jweiner@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Minchan Kim <minchan.kim@gmail.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

On Tue, Sep 20, 2011 at 03:45:12PM +0200, Johannes Weiner wrote:
> The amount of dirtyable pages should not include the total number of
> free pages: there is a number of reserved pages that the page
> allocator and kswapd always try to keep free.
> 
> The closer (reclaimable pages - dirty pages) is to the number of
> reserved pages, the more likely it becomes for reclaim to run into
> dirty pages:
> 
>        +----------+ ---
>        |   anon   |  |
>        +----------+  |
>        |          |  |
>        |          |  -- dirty limit new    -- flusher new
>        |   file   |  |                     |
>        |          |  |                     |
>        |          |  -- dirty limit old    -- flusher old
>        |          |                        |
>        +----------+                       --- reclaim
>        | reserved |
>        +----------+
>        |  kernel  |
>        +----------+
> 
> Not treating reserved pages as dirtyable on a global level is only a
> conceptual fix.  In reality, dirty pages are not distributed equally
> across zones and reclaim runs into dirty pages on a regular basis.
> 
> But it is important to get this right before tackling the problem on a
> per-zone level, where the distance between reclaim and the dirty pages
> is mostly much smaller in absolute numbers.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> ---
>  include/linux/mmzone.h |    1 +
>  mm/page-writeback.c    |    8 +++++---
>  mm/page_alloc.c        |    1 +
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1ed4116..e28f8e0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -316,6 +316,7 @@ struct zone {
>  	 * sysctl_lowmem_reserve_ratio sysctl changes.
>  	 */
>  	unsigned long		lowmem_reserve[MAX_NR_ZONES];
> +	unsigned long		totalreserve_pages;
>  

This is nit-picking but totalreserve_pages is a poor name because it's
a per-zone value that is one of the lowmem_reserve[] fields instead
of a total. After this patch, we have zone->totalreserve_pages and
totalreserve_pages but are not related to the same thing.
but they are not the same.

It gets confusing once you consider what the values are
for. lowmem_reserve is part of a placement policy that limits the
number of pages placed in lower zones that allocated from higher
zones. totalreserve_pages is related to the overcommit heuristic
where it is assuming that the most interesting type of allocation
is GFP_HIGHUSER.

This begs the question - what is this new field, where does it come
from, what does it want from us? Should we take it to our Patch Leader?

This field ultimately affects what zone is used to allocate a new
page so it's related to placement policy. That implies the naming then
should indicate it is related to lowmem_reserve - largest_lowmem_reserve?

Alternative, make it clear that it's one of the lowmem_reserve
values and store the index instead of the value - largest_reserve_idx?

>  #ifdef CONFIG_NUMA
>  	int node;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index da6d263..9f896db 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -169,8 +169,9 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
>  		struct zone *z =
>  			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
>  
> -		x += zone_page_state(z, NR_FREE_PAGES) +
> -		     zone_reclaimable_pages(z);
> +		x += zone_page_state(z, NR_FREE_PAGES) -
> +			zone->totalreserve_pages;
> +		x += zone_reclaimable_pages(z);
>  	}

This is highmem so zone->totalreserve_pages should always be 0.

Otherwise, the patch seems fine.

>  	/*
>  	 * Make sure that the number of highmem pages is never larger
> @@ -194,7 +195,8 @@ static unsigned long determine_dirtyable_memory(void)
>  {
>  	unsigned long x;
>  
> -	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> +	x = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
> +	x += global_reclaimable_pages();
>  
>  	if (!vm_highmem_is_dirtyable)
>  		x -= highmem_dirtyable_memory(x);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1dba05e..7e8e2ee 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5075,6 +5075,7 @@ static void calculate_totalreserve_pages(void)
>  
>  			if (max > zone->present_pages)
>  				max = zone->present_pages;
> +			zone->totalreserve_pages = max;
>  			reserve_pages += max;
>  		}
>  	}

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
