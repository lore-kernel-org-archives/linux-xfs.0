Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09ED57CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 07:20:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFD838F8049
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 05:20:31 -0700 (PDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id tNfxSBbrSpoivkhf
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2016 05:20:26 -0700 (PDT)
Received: by mail-wm0-f50.google.com with SMTP id k184so3790737wme.1
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2016 05:20:26 -0700 (PDT)
Date: Mon, 6 Jun 2016 14:20:22 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160606122022.GH11895@dhcp22.suse.cz>
References: <20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160519081146.GS3193@twins.programming.kicks-ass.net>
	<20160520001714.GC26977@dastard>
	<20160601131758.GO26601@dhcp22.suse.cz>
	<20160601181617.GV3190@twins.programming.kicks-ass.net>
	<20160602145048.GS1995@dhcp22.suse.cz>
	<20160602151116.GD3190@twins.programming.kicks-ass.net>
	<20160602154619.GU1995@dhcp22.suse.cz>
	<20160602232254.GR12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160602232254.GR12670@dastard>
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
Cc: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, Qu Wenruo <quwenruo@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>

On Fri 03-06-16 09:22:54, Dave Chinner wrote:
> On Thu, Jun 02, 2016 at 05:46:19PM +0200, Michal Hocko wrote:
> > On Thu 02-06-16 17:11:16, Peter Zijlstra wrote:
> > > With scope I mostly meant the fact that you have two calls that you need
> > > to pair up. That's not really nice as you can 'annotate' a _lot_ of code
> > > in between. I prefer the narrower annotations where you annotate a
> > > single specific site.
> > 
> > Yes, I can see you point. What I meant to say is that we would most
> > probably end up with the following pattern
> > 	lockdep_trace_alloc_enable()
> > 	some_foo_with_alloc(gfp_mask);
> > 	lockdep_trace_alloc_disable()
> >
> > and some_foo_with_alloc might be a lot of code.
> 
> That's the problem I see with this - the only way to make it
> maintainable is to precede each enable/disable() pair with a comment
> explaining *exactly* what those calls are protecting.  And that, in
> itself, becomes a maintenance problem, because then code several
> layers deep has no idea what context it is being called from and we
> are likely to disable warnings in contexts where we probably
> shouldn't be.

I am not sure I understand what you mean here. I thought the problem is
that:

func_A (!trans. context)		func_B (trans. context)
 foo1()					  foo2()
   bar(inode, GFP_KERNEL)		    bar(inode, GFP_NOFS)

so bar(inode, gfp) can be called from two different contexts which
would confuse the lockdep. And the workaround would be annotating bar
depending on the context it is called from - either pass a special gfp
flag or do disable/enable thing. In both cases that anotation should be
global for the whole func_A, no? Or is it possible that something in
that path would really need a reclaim lockdep detection?

> I think such an annotation approach really requires per-alloc site
> annotation, the reason for it should be more obvious from the
> context. e.g. any function that does memory alloc and takes an
> optional transaction context needs annotation. Hence, from an XFS
> perspective, I think it makes more sense to add a new KM_ flag to
> indicate this call site requirement, then jump through whatever
> lockdep hoop is required within the kmem_* allocation wrappers.
> e.g, we can ignore the new KM_* flag if we are in a transaction
> context and so the flag is only activated in the situations were
> we currently enforce an external GFP_NOFS context from the call
> site.....

Hmm, I thought we would achive this by using the scope GFP_NOFS usage
which would mark those transaction related conctexts and no lockdep
specific workarounds would be needed...

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
