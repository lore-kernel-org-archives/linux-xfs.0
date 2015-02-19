Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1389E7F60
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:53:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3AD3304032
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:53:56 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id ku1M1QC5mEKMkWWY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:53:54 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<20150219125844.GI28427@dhcp22.suse.cz>
	<201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
In-Reply-To: <201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
Message-Id: <201502200653.FID73452.MtHVJLOFOFOFSQ@I-love.SAKURA.ne.jp>
Date: Fri, 20 Feb 2015 06:53:41 +0900
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

Tetsuo Handa wrote:
> Michal Hocko wrote:
> > On Thu 19-02-15 13:29:14, Michal Hocko wrote:
> > [...]
> > > Something like the following.
> > __GFP_HIGH doesn't seem to be sufficient so we would need something
> > slightly else but the idea is still the same:
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 8d52ab18fe0d..2d224bbdf8e8 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2599,6 +2599,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >  	enum migrate_mode migration_mode = MIGRATE_ASYNC;
> >  	bool deferred_compaction = false;
> >  	int contended_compaction = COMPACT_CONTENDED_NONE;
> > +	int oom = 0;
> >  
> >  	/*
> >  	 * In the slowpath, we sanity check order to avoid ever trying to
> > @@ -2635,6 +2636,15 @@ retry:
> >  	alloc_flags = gfp_to_alloc_flags(gfp_mask);
> >  
> >  	/*
> > +	 * __GFP_NOFAIL allocations cannot fail but yet the current context
> > +	 * might be blocking resources needed by the OOM victim to terminate.
> > +	 * Allow the caller to dive into memory reserves to succeed the
> > +	 * allocation and break out from a potential deadlock.
> > +	 */
> 
> We don't know how many callers will pass __GFP_NOFAIL. But if 1000
> threads are doing the same operation which requires __GFP_NOFAIL
> allocation with a lock held, wouldn't memory reserves deplete?
> 
> This heuristic can't continue if memory reserves depleted or
> continuous pages of requested order cannot be found.
> 

Even if the system seems to be stalled, deadlocks may not have occurred.
If the cause is (e.g.) virtio disk being stuck for unknown reason than
a deadlock, nobody should start consuming the memory reserves after
waiting for a while.

The memory reserves are something like a balloon. To guarantee forward
progress, the balloon must not become empty. Therefore, I think that
throttling heuristics for memory requester side (deflator of the balloon,
or SIGKILL receiver called processes) should be avoided and
throttling heuristics for memory releaser side (inflator of the balloon,
or SIGKILL sender called the OOM killer) should be used.
If heuristic is used on the deflator side, the memory allocator may
deliver a final blow via ALLOC_NO_WATERMARKS. If heuristic is used on
the inflator side, the OOM killer can act as a watchdog when nobody
volunteered memory within reasonable period.

> > +	if (oom > 10 && (gfp_mask & __GFP_NOFAIL))
> > +		alloc_flags |= ALLOC_NO_WATERMARKS;
> > +
> > +	/*
> >  	 * Find the true preferred zone if the allocation is unconstrained by
> >  	 * cpusets.
> >  	 */
> > @@ -2759,6 +2769,8 @@ retry:
> >  				goto got_pg;
> >  			if (!did_some_progress)
> >  				goto nopage;
> > +
> > +			oom++;
> >  		}
> >  		/* Wait for some write requests to complete then retry */
> >  		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
