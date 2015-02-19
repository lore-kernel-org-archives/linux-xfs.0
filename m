Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89D137F66
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 16:04:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59B348F8064
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 14:04:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9Dr3O47EyclSdjM8 for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 14:04:10 -0800 (PST)
Date: Fri, 20 Feb 2015 09:03:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150219220355.GX12722@dastard>
References: <20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150218213118.GN12722@dastard>
	<20150219094020.GE28427@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219094020.GE28427@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Thu, Feb 19, 2015 at 10:40:20AM +0100, Michal Hocko wrote:
> On Thu 19-02-15 08:31:18, Dave Chinner wrote:
> > On Wed, Feb 18, 2015 at 01:16:02PM +0100, Michal Hocko wrote:
> > > On Wed 18-02-15 21:48:59, Dave Chinner wrote:
> > > > On Wed, Feb 18, 2015 at 09:25:02AM +0100, Michal Hocko wrote:
> > This is why GFP_NOFAIL is not a solution to the "never fail"
> > alloation problem. The caller doing the "no fail" allocation _must
> > be able to set failure policy_. i.e. the choice of aborting and
> > shutting down because progress cannot be made, or continuing and
> > hoping for forwards progress is owned by the allocating context, no
> > the allocator.
> 
> I completely agree that the failure policy is the caller responsibility
> and I would have no objections to something like:
> 
> 	do {
> 		ptr = kmalloc(size, GFP_NOFS);
> 		if (ptr)
> 			return ptr;
> 		if (fatal_signal_pending(current))
> 			break;
> 		if (looping_too_long())
> 			break;
> 	} while (1);
> 
> 	fallback_solution();
> 
> But this is not the case in kmem_alloc which is essentially GFP_NOFAIL
> allocation with a warning and congestion_wait. There is no failure
> policy defined there. The warning should be part of the allocator and
> the NOFAIL policy should be explicit. So why exactly do you oppose to
> changing kmem_alloc (and others which are doing essentially the same)?

I'm opposing changing kmem_alloc() to GFP_NOFAIL precisely because
doing so is *broken*, *and* it removes the policy decision from the
calling context where it belongs.

We are in the process of discussing - at an XFS level - how to
handle errors in a configurable manner. See, for example, this
discussion:

http://oss.sgi.com/archives/xfs/2015-02/msg00343.html

Where we are trying to decide how to expose failure policy to admins
to make decisions about error handling behaviour:

http://oss.sgi.com/archives/xfs/2015-02/msg00346.html

There is little doubt in my mind that this stretches to ENOMEM
handling; it is another case where we consider ENOMEM to be a
transient error and hence retry forever until it succeeds. But some
people are going to want to configure that behaviour, and the API
above allows peopel to configure exactly how many repeated memory
allocations we'd fail before considering the situation hopeless,
failing, and risking a filesystem shutdown....

Converting the code to use GFP_NOFAIL takes us in exactly the
opposite direction to our current line of development w.r.t. to
filesystem error handling.

> The reason I care about GFP_NOFAIL is that there are apparently code
> paths which do not tell allocator they are basically GFP_NOFAIL without
> any fallback. This leads to two main problems 1) we do not have a good
> overview how many code paths have such a strong requirements and so
> cannot estimate e.g. how big memory reserves should be and

Right, when GFP_NOFAIL got deprecated we lost the ability to document
such behaviour and find it easily. People just put retry loops in
instead of using GFP_NOFAIL. Good luck finding them all :/

> 2) allocator
> cannot help those paths (e.g. by giving them access to reserves to break
> out of the livelock).

Allocator should not help. Global reserves are unreliable - make the
allocation context reserve the amount it needs before it enters the
context where it can't back out....

> > IOWs, we have need for forward allocation progress guarantees on
> > (potentially) several megabytes of allocations from slab caches, the
> > heap and the page allocator, with all allocations all in
> > unpredictable order, with objects of different life times and life
> > cycles, and at which may, at any time, get stuck behind
> > objects locked in other transactions and hence can randomly block
> > until some other thread makes forward progress and completes a
> > transaction and unlocks the object.
> 
> Thanks for the clarification, I have to think about it some more,
> though. My thinking was that mempools could be used for an emergency
> pool with a pre-allocated memory which would be used in the non failing
> contexts.

The other problem with mempools is that they aren't exclusive to the
context that needs the reservation. i.e. we can preallocate to the
mempool, but then when the preallocating context goes to allocate,
that preallocation may have already been drained by other contexts.

The memory reservation needs to be follow to the transaction - we
can pass them between tasks, and they need to persist across
sleeping locks, IO, etc, and mempools simply too constrainted to be
usable in this environment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
