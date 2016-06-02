Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47E767CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 18:23:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 190D330404E
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 16:23:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CE17isx9eKHRKX6P for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2016 16:23:37 -0700 (PDT)
Date: Fri, 3 Jun 2016 09:22:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160602232254.GR12670@dastard>
References: <20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160519081146.GS3193@twins.programming.kicks-ass.net>
	<20160520001714.GC26977@dastard>
	<20160601131758.GO26601@dhcp22.suse.cz>
	<20160601181617.GV3190@twins.programming.kicks-ass.net>
	<20160602145048.GS1995@dhcp22.suse.cz>
	<20160602151116.GD3190@twins.programming.kicks-ass.net>
	<20160602154619.GU1995@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160602154619.GU1995@dhcp22.suse.cz>
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
Cc: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, Qu Wenruo <quwenruo@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>

On Thu, Jun 02, 2016 at 05:46:19PM +0200, Michal Hocko wrote:
> On Thu 02-06-16 17:11:16, Peter Zijlstra wrote:
> > With scope I mostly meant the fact that you have two calls that you need
> > to pair up. That's not really nice as you can 'annotate' a _lot_ of code
> > in between. I prefer the narrower annotations where you annotate a
> > single specific site.
> 
> Yes, I can see you point. What I meant to say is that we would most
> probably end up with the following pattern
> 	lockdep_trace_alloc_enable()
> 	some_foo_with_alloc(gfp_mask);
> 	lockdep_trace_alloc_disable()
>
> and some_foo_with_alloc might be a lot of code.

That's the problem I see with this - the only way to make it
maintainable is to precede each enable/disable() pair with a comment
explaining *exactly* what those calls are protecting.  And that, in
itself, becomes a maintenance problem, because then code several
layers deep has no idea what context it is being called from and we
are likely to disable warnings in contexts where we probably
shouldn't be.

I think such an annotation approach really requires per-alloc site
annotation, the reason for it should be more obvious from the
context. e.g. any function that does memory alloc and takes an
optional transaction context needs annotation. Hence, from an XFS
perspective, I think it makes more sense to add a new KM_ flag to
indicate this call site requirement, then jump through whatever
lockdep hoop is required within the kmem_* allocation wrappers.
e.g, we can ignore the new KM_* flag if we are in a transaction
context and so the flag is only activated in the situations were
we currently enforce an external GFP_NOFS context from the call
site.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
