Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTKsSOv123066 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 14:54:28 -0600
Subject: Re: [PATCH 1/5] percpu_counter: fix test in
	__percpu_counter_add_unless_lt()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101223060652.GE18264@dastard>
References: <1293076575.2408.425.camel@doink> <20101223060652.GE18264@dastard>
Date: Wed, 29 Dec 2010 14:56:28 -0600
Message-ID: <1293656188.1961.470.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, 2010-12-23 at 17:06 +1100, Dave Chinner wrote:
> On Wed, Dec 22, 2010 at 09:56:15PM -0600, Alex Elder wrote:
> > In __percpu_counter_add_unless_lt(), there is a test to see if
> > a call to __percpu_counter_add() can be made, knowing the result
> > will not be less than the given threshhold and the called function
> > will do the addition without taking a lock.

. . .

> > ===================================================================
> > --- a/lib/percpu_counter.c
> > +++ b/lib/percpu_counter.c
> > @@ -239,10 +239,10 @@ int __percpu_counter_add_unless_lt(struc
> >  		goto out;
> >  
> >  	/*
> > -	 * If the counter is over the threshold and the change is less than the
> > -	 * batch size, we might be able to avoid locking.
> > +	 * If the updated counter will be over the threshold we know
> > +	 * we can safely add, and might be able to avoid locking.
> >  	 */
> > -	if (count > threshold + error && abs(amount) < batch) {
> > +	if (count + amount > threshold + error) {
> >  		__percpu_counter_add(fbc, amount, batch);
> >  		ret = 1;
> >  		goto out;
> 
> What you have is what I first implemented following your exact
> logic. However, after having several assert failures n the XFS code,
> I realised that the logic fails when there are concurrent modifications
> with abs(amount) > batch. To demonstrate, take the initial conditions:

I think we're both wrong.  First I'll point out a think-o
you did, then I'll lay out a counterexample to your approach.

> threshold = 0
> amount = -39 (for ease of maths)
> batch = 32
> error = 256 (2 * 32 * 4 cpus)
> 
> with the per CPU counter values:
> 
> fbc->count = 296
> 
> CPU	0	1	2	3
> value	-31	-31	-31	-31
> 
> And the start the concurrent modification such that every racing CPU
> sees fbc->count = 296 at their initial sample. All evaluate it as:
> 
> 	count = 296
> 	if (296 - 39 > 0 + 256) {
> 
> and so take the __percpu_counter_add() path. Assuming CPUs 1-3
> complete before CPU 0, the counter changes value like:
> 
> 
> 					cpu 1 pcp_cnt_add_lt(-39)
> CPU	0	1	2	3
> value	-31	0	-31	-31
> fbc->count = 216

No.

fbc->count + *pcount + amount = 296 + (-31) + (-39) = 226.

You're mis-computing (*pcount + amount), which is -70, not -80.

> 					cpu 2 pcp_cnt_add_lt(-39)
> CPU	0	1	2	3
> value	-31	0	0	-31
> fbc->count = 136

fbc->count = 156

> 					cpu 3 pcp_cnt_add_lt(-39)
> CPU	0	1	2	3
> value	-31	0	0	0
> fbc->count = 56

fbc->count = 86

> And the we run the counter add on CPU 0:
> 
> 		__percpu_counter_add(fbc, -39, 32);
> 
> CPU	0	1	2	3
> value	0	0	0	0
> fbc->count = -24

fbc->count = 16, so all is well.

> And we've just blown through the threshold. We modified the counter
> and pushed the result less than the threshold which we are not
> supposed to be, and worst yet is the fact we returning a positive
> number indicating that we _didn't_ bust the threshold.

Now here's an example that will fail with your version, which is:

     if (count > threshold + error && abs(amount) < batch) {
               __percpu_counter_add(fbc, amount, batch);

My example is not symmetric like yours is.

threshold = 0
batch = 32
4 cpus, so (your) error = 2 * 4 * 32 = 256

We'll start with 0 for all per-cpu counter values
for simplicity, but we'll not assume that the
amount being added by all CPU's is the same.  So
here are both the current per-cpu counter values and
the amount each racing CPU is going to try to add.

fbc->count = 257
CPU	 0	 1	 2	 3
value	  0	 0	 0	 0
amount	-31	-76	-76	-76

As in your example, all CPU's enter at the same time and
start with the same initial value from fbc->count, 257.

First, CPU 0 checks the condition and finds it holds:
     if (count > threshold + error && abs(amount) < batch) {
          257  >     0     +  256  &&   abs(-31)  <   32

Now, before CPU 0 gets its chance to call __percpu_counter_add(),
CPU's 1, 2, and 3 reach this point, find the condition does
not hold, and proceed with adding their values to fbc->count
under lock.

Net result is:      (-76 * 3 = -228; 257 - 228 = 29)

fbc->count = 29
CPU	  0	 1	 2	 3
value	  0	 0	 0	 0
amount	-31	(done)	(done)	(done)

Now CPU 0 proceeds with its __percpu_counter_add(), and
inside that it finds that *pcount + amount = -31, which
is < batch and > -batch, so it simply records the result
in the local "delta" counter for CPU 0.  Net result: 


fbc->count = 29
CPU	  0	 1	 2	 3
value	-31	 0	 0	 0
amount	(done)	(done)	(done)	(done)

So although the test made it seem OK to add
the value, the "net" result has gone negative.
I.e, percpu_counter_sum() would produce -2.

The whole point of these bounds checking things
is to ensure the net value (not just fbc->count)
of the counter stays above the threshold.

The same problem exists if the amount being added
on CPU 0 was -76 like the others.  The add would
be done under lock, but the result would still go
below the threshold.  Your approach embeds in it an
assumption that "amount" will be within a certain
range across all CPU's--specifically, less than
the batch size (I think).


The real problem is that we're caching the value of
fbc->count, and as soon as we've done that it
could be out of date.  To get around it we need
to examine it under lock--preferably a reader/writer
lock I suppose.  You'll notice that fbc->count is
only ever read under the protection of the spinlock
everywhere else in the file.  Locking is avoided
only when checking whether it is possible to add to
a per-cpu value, and that is done with preemption
disabled.

It may be that the only way around this is to
compute the accurate sum except in the simple
case where we know that the maximum possible net
value of the counter will produce a too-low value
when the amount is added.  Otherwise you have to
compute the sum under lock, and then complete the
assignment only if the threshold condition is met.

I think that--unless you impose a range bound on
"amount"--you can't escape the fact that other CPU's
can screw up the result by updating fbc->count
after you've sampled it.

I have a little more below.

> Analysis of the failures lead me to this lead me to this logic
> for the unlocked check in my proposed patch:
> 
> We can do unlocked modifications concurrently on all CPUs IFF
> 
> 	1. the code cannot be preempted between sampling fbc->count
> 	and calling __percpu_counter_add()

This I agree with (you convinced me in your response
to my patch 5/5).

> 	2. -batch < amount < batch

This isn't right, or maybe just isn't relevant.  The
reason is that it neither takes into account this CPU's
counter value, nor what a concurrent call on the other
CPU's might be adding to the net value.

> 	3. the error bound is set to 2 * batch * nr_cpus

I think this assumes that all the CPU's are adding a limited
amount to the counter.  And I still think you're doubling
the error bound unnecessarily (but that may reflect the
implied limit).

Below I have a version of the code that I think would work,
but it unfortunately requires a lock in the (presumably)
normal case.

> To demonstrate the worst case initial conditions, but being bound by
> the above rules:

. . .

					-Alex

int
__percpu_counter_add_unless_lt(
	struct percpu_counter	*fbc,
	s64			amount,
	s64			threshold,
	s32			batch)
{
	s64			error = batch * num_online_cpus();
	s64			new_count;
	int			cpu;
	int			ret = -1;

        /*
         * The maximum value the counter holds is bounded by its
         * current count plus the error magnitude computed above.
         * If that plus the amount to be added is less than the
         * threshold, we can't do the add because the result would
         * be too low.
         */
        if (percpu_counter_read(fbc) + error + amount < threshold)
                return -1;

        /*
         * Otherwise, compute the accurate sum.  If and adding the
         * given amount doesn't exceed the threshold, add it.  In
         * that case, just add the amount to the global counter.
         */
        spin_lock(&fbc->lock);
        new_count = fbc->count + amount;
        for_each_online_cpu(cpu) {
                s32 *pcount = per_cpu_ptr(fbc->counters, cpu);

                new_count += *pcount;
        }
        if (new_count >= threshold) {
                ret = new_count > threshold;
                fbc->count = fbc_count + amount;
        } 
        spin_unlock(&fbc->lock);

        return ret;
}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
