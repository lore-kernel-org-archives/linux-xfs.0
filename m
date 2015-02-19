Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2B5F7F54
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 09:29:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91515304032
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 07:29:46 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id hnUVyIa7jCctoqKh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 07:29:44 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<20150219125844.GI28427@dhcp22.suse.cz>
In-Reply-To: <20150219125844.GI28427@dhcp22.suse.cz>
Message-Id: <201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
Date: Fri, 20 Feb 2015 00:29:29 +0900
Mime-Version: 1.0
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
To: mhocko@suse.cz, hannes@cmpxchg.org
Cc: dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

Michal Hocko wrote:
> On Thu 19-02-15 13:29:14, Michal Hocko wrote:
> [...]
> > Something like the following.
> __GFP_HIGH doesn't seem to be sufficient so we would need something
> slightly else but the idea is still the same:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8d52ab18fe0d..2d224bbdf8e8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2599,6 +2599,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	enum migrate_mode migration_mode = MIGRATE_ASYNC;
>  	bool deferred_compaction = false;
>  	int contended_compaction = COMPACT_CONTENDED_NONE;
> +	int oom = 0;
>  
>  	/*
>  	 * In the slowpath, we sanity check order to avoid ever trying to
> @@ -2635,6 +2636,15 @@ retry:
>  	alloc_flags = gfp_to_alloc_flags(gfp_mask);
>  
>  	/*
> +	 * __GFP_NOFAIL allocations cannot fail but yet the current context
> +	 * might be blocking resources needed by the OOM victim to terminate.
> +	 * Allow the caller to dive into memory reserves to succeed the
> +	 * allocation and break out from a potential deadlock.
> +	 */

We don't know how many callers will pass __GFP_NOFAIL. But if 1000
threads are doing the same operation which requires __GFP_NOFAIL
allocation with a lock held, wouldn't memory reserves deplete?

This heuristic can't continue if memory reserves depleted or
continuous pages of requested order cannot be found.

> +	if (oom > 10 && (gfp_mask & __GFP_NOFAIL))
> +		alloc_flags |= ALLOC_NO_WATERMARKS;
> +
> +	/*
>  	 * Find the true preferred zone if the allocation is unconstrained by
>  	 * cpusets.
>  	 */
> @@ -2759,6 +2769,8 @@ retry:
>  				goto got_pg;
>  			if (!did_some_progress)
>  				goto nopage;
> +
> +			oom++;
>  		}
>  		/* Wait for some write requests to complete then retry */
>  		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
> -- 
> Michal Hocko
> SUSE Labs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
