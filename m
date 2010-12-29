Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTGRcOa089216 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 10:27:38 -0600
Subject: Re: [PATCH 5/5] percpu_counter: only disable preemption if needed
	in add_unless_lt()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101223063138.GF18264@dastard>
References: <1293076602.2408.434.camel@doink> <20101223063138.GF18264@dastard>
Date: Wed, 29 Dec 2010 10:29:38 -0600
Message-ID: <1293640178.1961.62.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-12-23 at 17:31 +1100, Dave Chinner wrote:
> On Wed, Dec 22, 2010 at 09:56:42PM -0600, Alex Elder wrote:
> > In __percpu_counter_add_unless_lt() we don't need to disable
> > preemption unless we're manipulating a per-cpu variable.  That only
> > happens in a limited case, so narrow the scope of that preemption to
> > surround that case.  This makes the "out" label rather unnecessary,
> > so replace a couple "goto out" calls to just return.

. . .

> 
> Regardless of the other changes, this is not valid. That is:

You're right.  I was thinking about updates to fbc->count
being protected by the spinlock, but that doesn't address
the cached value getting stale if this CPU gets preempted
and another thread passes through this code before the
first one gets resumed.

I'm also looking at the other patches and your responses
and will be done with it today.  I don't want to hold
up your pull request any longer.

If you found anything of value in the little series I posted
feel free to incorporate it into your own changes.

					-Alex

> 	amount = -1;
> 	count = fbc->count;
> 	.....
> 
> 	<get preempted>
> 
> 	<other operations may significantly change fbc->count (i.e
> 	lots more than error will catch), so the current value of
> 	count in this context is wrong and cannot be trusted>
> 
> 	<start running again>
> 
> 	if (count - error + amount > threshold) {
> 		<not valid to run this lockless optimisation based
> 		on a stale count value>
> 		
> 		....
> 	}
> 
> Effectively, if we want to be able to use lockless optimisations, we
> need to ensure that the value of the global counter that we read
> remains within the given error bounds until we have finished making
> the lockless modification. That is done via disabling preemption
> across the entire function...
> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
