Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DGf6w5092515 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 11:41:06 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 345511501DC7
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 09:41:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rQJOkBWsCnxgl6Jw for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 09:41:04 -0700 (PDT)
Date: Wed, 13 Jul 2011 18:40:40 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 4/5] mm: vmscan: Immediately reclaim end-of-LRU dirty
	pages when writeback completes
Message-ID: <20110713164040.GA13972@redhat.com>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310567487-15367-5-git-send-email-mgorman@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Wed, Jul 13, 2011 at 03:31:26PM +0100, Mel Gorman wrote:
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim using
> deactivate_page() so that the page gets reclaimed almost immediately
> after the page gets cleaned. This is to avoid reclaiming clean pages
> that are younger than a dirty page encountered at the end of the LRU
> that might have been something like a use-once page.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/linux/mmzone.h |    2 +-
>  mm/vmscan.c            |   10 ++++++++--
>  mm/vmstat.c            |    2 +-
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c4508a2..bea7858 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -100,7 +100,7 @@ enum zone_stat_item {
>  	NR_UNSTABLE_NFS,	/* NFS unstable pages */
>  	NR_BOUNCE,
>  	NR_VMSCAN_WRITE,
> -	NR_VMSCAN_WRITE_SKIP,
> +	NR_VMSCAN_INVALIDATE,
>  	NR_VMSCAN_THROTTLED,
>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
>  	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9826086..8e00aee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -834,8 +834,13 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			 */
>  			if (page_is_file_cache(page) &&
>  					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
> -				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> -				goto keep_locked;
> +				inc_zone_page_state(page, NR_VMSCAN_INVALIDATE);
> +
> +				/* Immediately reclaim when written back */
> +				unlock_page(page);
> +				deactivate_page(page);
> +
> +				goto keep_dirty;
>  			}
>  
>  			if (references == PAGEREF_RECLAIM_CLEAN)
> @@ -956,6 +961,7 @@ keep:
>  		reset_reclaim_mode(sc);
>  keep_lumpy:
>  		list_add(&page->lru, &ret_pages);
> +keep_dirty:
>  		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
>  	}

I really like the idea behind this patch, but I think all those pages
are lost as PageLRU is cleared on isolation and lru_deactivate_fn
bails on them in turn.

If I'm not mistaken, the reference from the isolation is also leaked.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
