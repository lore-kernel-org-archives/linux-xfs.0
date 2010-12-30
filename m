Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUMXPSG041223 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 16:33:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8C4AF920B4
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:35:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	t0XeCVCqPqkc4CCC for <xfs@oss.sgi.com>;
	Thu, 30 Dec 2010 14:35:20 -0800 (PST)
Date: Fri, 31 Dec 2010 09:35:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] percpu_counter: fix test in
	__percpu_counter_add_unless_lt()
Message-ID: <20101230223516.GB15179@dastard>
References: <1293076575.2408.425.camel@doink> <20101223060652.GE18264@dastard>
	<1293656188.1961.470.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293656188.1961.470.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, Dec 29, 2010 at 02:56:28PM -0600, Alex Elder wrote:
> On Thu, 2010-12-23 at 17:06 +1100, Dave Chinner wrote:
> > On Wed, Dec 22, 2010 at 09:56:15PM -0600, Alex Elder wrote:
> > > In __percpu_counter_add_unless_lt(), there is a test to see if
> > > a call to __percpu_counter_add() can be made, knowing the result
> > > will not be less than the given threshhold and the called function
> > > will do the addition without taking a lock.
> 
> . . .
> 
> > > ===================================================================
> > > --- a/lib/percpu_counter.c
> > > +++ b/lib/percpu_counter.c
> > > @@ -239,10 +239,10 @@ int __percpu_counter_add_unless_lt(struc
> > >  		goto out;
> > >  
> > >  	/*
> > > -	 * If the counter is over the threshold and the change is less than the
> > > -	 * batch size, we might be able to avoid locking.
> > > +	 * If the updated counter will be over the threshold we know
> > > +	 * we can safely add, and might be able to avoid locking.
> > >  	 */
> > > -	if (count > threshold + error && abs(amount) < batch) {
> > > +	if (count + amount > threshold + error) {
> > >  		__percpu_counter_add(fbc, amount, batch);
> > >  		ret = 1;
> > >  		goto out;
> > 
> > What you have is what I first implemented following your exact
> > logic. However, after having several assert failures n the XFS code,
> > I realised that the logic fails when there are concurrent modifications
> > with abs(amount) > batch. To demonstrate, take the initial conditions:
> 
> I think we're both wrong.  First I'll point out a think-o
> you did, then I'll lay out a counterexample to your approach.

Argh, you're right. However, if you change amount to -49 and the initial
fbc->count to 306, we get 226, 146, 66, -14, so the problem I was
pointing out still stands.

> > And we've just blown through the threshold. We modified the counter
> > and pushed the result less than the threshold which we are not
> > supposed to be, and worst yet is the fact we returning a positive
> > number indicating that we _didn't_ bust the threshold.
> 
> Now here's an example that will fail with your version, which is:
> 
>      if (count > threshold + error && abs(amount) < batch) {
>                __percpu_counter_add(fbc, amount, batch);
> 
> My example is not symmetric like yours is.
> 
> threshold = 0
> batch = 32
> 4 cpus, so (your) error = 2 * 4 * 32 = 256
> 
> We'll start with 0 for all per-cpu counter values
> for simplicity, but we'll not assume that the
> amount being added by all CPU's is the same.  So
> here are both the current per-cpu counter values and
> the amount each racing CPU is going to try to add.
> 
> fbc->count = 257
> CPU	 0	 1	 2	 3
> value	  0	 0	 0	 0
> amount	-31	-76	-76	-76

Granted, that is a possible state that can occur at the sampling
point, but it assumes that the race condition of CPUs 1, 2 and 3
complete the fbc->count modification before seeing the CPU 0
modification of the local CPU value can occur.

I don't think that race condition can occur, because CPUs 1, 2 and 3
will take the slow path because abs(amount) >= batch and serialise
on the fbc->lock, whilst CPU 0 will not be serialised, is running
under preempt_disable() and so should complete first....

> The real problem is that we're caching the value of
> fbc->count, and as soon as we've done that it
> could be out of date.  To get around it we need
> to examine it under lock--preferably a reader/writer
> lock I suppose.

No, new locks are not an option. The point of percpu counters is to
avoid locking where possible. memory barriers, OTOH....

> You'll notice that fbc->count is
> only ever read under the protection of the spinlock
> everywhere else in the file.

It isn't, in fact. percpu_counter_read(), for example.

> Locking is avoided
> only when checking whether it is possible to add to
> a per-cpu value, and that is done with preemption
> disabled.

Sure, that's the rules for using per-cpu data structures (i.e.
preemption needs to be disabled). That doesn't mean we can't avoid
locking where possible....

> I have a little more below.
> 
> > Analysis of the failures lead me to this lead me to this logic
> > for the unlocked check in my proposed patch:
> > 
> > We can do unlocked modifications concurrently on all CPUs IFF
> > 
> > 	1. the code cannot be preempted between sampling fbc->count
> > 	and calling __percpu_counter_add()
> 
> This I agree with (you convinced me in your response
> to my patch 5/5).
> 
> > 	2. -batch < amount < batch
> 
> This isn't right, or maybe just isn't relevant.  The
> reason is that it neither takes into account this CPU's
> counter value, nor what a concurrent call on the other
> CPU's might be adding to the net value.

It is supposed to take into account whether the local addition
will transgress the error bound for this CPU....

> > 	3. the error bound is set to 2 * batch * nr_cpus
> 
> I think this assumes that all the CPU's are adding a limited
> amount to the counter.  And I still think you're doubling
> the error bound unnecessarily (but that may reflect the
> implied limit).

It is the limit that is supposed to take into account the current
counter and the amount being added. I think this the the cause of
the issue - the error doesn't correctly take into account amount -
it assumes that -batch < amount < batch is always true. We can
change the error bound to take amount into account, but that still
doesn't work if another CPU is adding a larger abs(amount).  So for
it to work in all cases we need to set a maximum bound on amount,
which is impractical.

However, I think this error bound is still valid if we modify the
lockless code to detect if fbc->count has changed before we make the
modification. It's only when fbc->count changes that the error bound
is invalidated if abs(amount) < batch, so checking that it hasn't
changed before applying the modification seems to solve the problem
to me.  And rather than using locking, we can use memory barriers to
ensure that we pick up any racing changes to fbc->count. i.e
something like:

restart:
	smp_mb();
	count = fbc->count;
	if (count > threshold + error && abs(amount) < batch) {
		s64 lcount;

		pcount = this_cpu_ptr(fbc->counters);
		lcount = *pcount + amount;
		if (lcount >= batch || lcount <= -batch) {
			spin_lock(&fbc->lock);
			if (fbc->count != count) {
				/* raced with other modifications */
				spin_unlock(&fbc->lock);
				goto restart;
			}
			fbc->count += lcount;
			*pcount = 0;
			spin_unlock(&fbc->lock);
		} else {
			smp_mb();
			if (fbc->count != count)
				goto restart;
			*pcount = lcount;
		}
		ret = 1;
		got out;
	}

This means that in your example (and indeed any example where
fbc->count is modified directly on another CPU), we will detect
it and redo the unlocked checks.

> Below I have a version of the code that I think would work,
> but it unfortunately requires a lock in the (presumably)
> normal case.

Which, unfortunately, defeats the primary purpose of using a percpu
counter in the first place (i.e. to reduce lock contention on a
global counter) and so if that is the best that can be done, there
is no point making any change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
