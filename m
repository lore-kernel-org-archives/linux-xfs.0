Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92CB57CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 10:11:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53844304062
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 08:11:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3aEehPxLDhXVC6pc (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 08:11:20 -0700 (PDT)
Date: Thu, 2 Jun 2016 17:11:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160602151116.GD3190@twins.programming.kicks-ass.net>
References: <20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
	<20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160519081146.GS3193@twins.programming.kicks-ass.net>
	<20160520001714.GC26977@dastard>
	<20160601131758.GO26601@dhcp22.suse.cz>
	<20160601181617.GV3190@twins.programming.kicks-ass.net>
	<20160602145048.GS1995@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160602145048.GS1995@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>

On Thu, Jun 02, 2016 at 04:50:49PM +0200, Michal Hocko wrote:
> On Wed 01-06-16 20:16:17, Peter Zijlstra wrote:

> > So my favourite is the dedicated GFP flag, but if that's unpalatable for
> > the mm folks then something like the below might work. It should be
> > similar in effect to your proposal, except its more limited in scope.
> [...]
> > @@ -2876,11 +2883,36 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
> >  	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
> >  		return;
> >  
> > +	/*
> > +	 * Skip _one_ allocation as per the lockdep_skip_alloc() request.
> > +	 * Must be done last so that we don't loose the annotation for
> > +	 * GFP_ATOMIC like things from IRQ or other nesting contexts.
> > +	 */
> > +	if (current->lockdep_reclaim_gfp & __GFP_SKIP_ALLOC) {
> > +		current->lockdep_reclaim_gfp &= ~__GFP_SKIP_ALLOC;
> > +		return;
> > +	}
> > +
> >  	mark_held_locks(curr, RECLAIM_FS);
> >  }
> 
> I might be missing something but does this work actually? Say you would
> want a kmalloc(size), it would call
> slab_alloc_node
>   slab_pre_alloc_hook
>     lockdep_trace_alloc
> [...]
>   ____cache_alloc_node
>     cache_grow_begin
>       kmem_getpages
>         __alloc_pages_node
> 	  __alloc_pages_nodemask
> 	    lockdep_trace_alloc

Bugger :/ You're right, that would fail.

So how about doing:

#define __GFP_NOLOCKDEP	(1u << __GFP_BITS_SHIFT)

this means it cannot be part of address_space::flags or
radix_tree_root::gfp_mask, but that might not be a bad thing.

And this solves the scarcity thing, because per pagemap we need to have
5 'spare' bits anyway.

> I understand your concerns about the scope but usually all allocations
> have to be __GFP_NOFS or none in the same scope so I would see it as a
> huge deal.

With scope I mostly meant the fact that you have two calls that you need
to pair up. That's not really nice as you can 'annotate' a _lot_ of code
in between. I prefer the narrower annotations where you annotate a
single specific site.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
