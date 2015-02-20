Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38BAC7F55
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 03:13:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA6FC8F8040
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 01:13:29 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 8ehhrHEDLWWN5LE7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 01:13:28 -0800 (PST)
Date: Fri, 20 Feb 2015 10:13:26 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150220091326.GD21248@dhcp22.suse.cz>
References: <20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<20150219125844.GI28427@dhcp22.suse.cz>
	<201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201502200029.DEG78137.QFVLHFFOJMtOOS@I-love.SAKURA.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, hannes@cmpxchg.org, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

On Fri 20-02-15 00:29:29, Tetsuo Handa wrote:
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

We shouldn't have an unbounded number of GFP_NOFAIL allocations at the
same time. This would be even more broken. If a load is known to use
such allocations excessively then the administrator can enlarge the
memory reserves.

> This heuristic can't continue if memory reserves depleted or
> continuous pages of requested order cannot be found.

Once memory reserves are depleted we are screwed anyway and we might
panic.

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
