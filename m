Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN64w2F108865 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 00:04:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7D4E1479154
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 22:06:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	EHHKAFOUpYqt8cLi for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 22:06:55 -0800 (PST)
Date: Thu, 23 Dec 2010 17:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] percpu_counter: fix test in
	__percpu_counter_add_unless_lt()
Message-ID: <20101223060652.GE18264@dastard>
References: <1293076575.2408.425.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293076575.2408.425.camel@doink>
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

On Wed, Dec 22, 2010 at 09:56:15PM -0600, Alex Elder wrote:
> In __percpu_counter_add_unless_lt(), there is a test to see if
> a call to __percpu_counter_add() can be made, knowing the result
> will not be less than the given threshhold and the called function
> will do the addition without taking a lock.
> 
> Unfortunately, it is using the wrong value in its comparison--the
> amount to add is not properly being taken into account.  As a
> result, __percpu_counter_add() could end up adding a value when it
> should not.  And even if the result will be non-negative, the called
> function may take the lock anyway because it does so if the *sum* of
> the (percpu) delta count and the given amount (and not just the amount
> alone) is greater than the batch size (or less than its negative).
> 
> Fix the comparison, and since it __percpu_counter_add() will do
> the right thing (and might lock anyway), just call it regardless
> of what amount is getting added.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  lib/percpu_counter.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: b/lib/percpu_counter.c
> ===================================================================
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -239,10 +239,10 @@ int __percpu_counter_add_unless_lt(struc
>  		goto out;
>  
>  	/*
> -	 * If the counter is over the threshold and the change is less than the
> -	 * batch size, we might be able to avoid locking.
> +	 * If the updated counter will be over the threshold we know
> +	 * we can safely add, and might be able to avoid locking.
>  	 */
> -	if (count > threshold + error && abs(amount) < batch) {
> +	if (count + amount > threshold + error) {
>  		__percpu_counter_add(fbc, amount, batch);
>  		ret = 1;
>  		goto out;

What you have is what I first implemented following your exact
logic. However, after having several assert failures n the XFS code,
I realised that the logic fails when there are concurrent modifications
with abs(amount) > batch. To demonstrate, take the initial conditions:

threshold = 0
amount = -39 (for ease of maths)
batch = 32
error = 256 (2 * 32 * 4 cpus)

with the per CPU counter values:

fbc->count = 296

CPU	0	1	2	3
value	-31	-31	-31	-31

And the start the concurrent modification such that every racing CPU
sees fbc->count = 296 at their initial sample. All evaluate it as:

	count = 296
	if (296 - 39 > 0 + 256) {

and so take the __percpu_counter_add() path. Assuming CPUs 1-3
complete before CPU 0, the counter changes value like:


					cpu 1 pcp_cnt_add_lt(-39)
CPU	0	1	2	3
value	-31	0	-31	-31
fbc->count = 216
					cpu 2 pcp_cnt_add_lt(-39)
CPU	0	1	2	3
value	-31	0	0	-31
fbc->count = 136
					cpu 3 pcp_cnt_add_lt(-39)
CPU	0	1	2	3
value	-31	0	0	0
fbc->count = 56

And the we run the counter add on CPU 0:

		__percpu_counter_add(fbc, -39, 32);

CPU	0	1	2	3
value	0	0	0	0
fbc->count = -24

And we've just blown through the threshold. We modified the counter
and pushed the result less than the threshold which we are not
supposed to be, and worst yet is the fact we returning a positive
number indicating that we _didn't_ bust the threshold.

Analysis of the failures lead me to this lead me to this logic
for the unlocked check in my proposed patch:

We can do unlocked modifications concurrently on all CPUs IFF

	1. the code cannot be preempted between sampling fbc->count
	and calling __percpu_counter_add()
	2. -batch < amount < batch
	3. the error bound is set to 2 * batch * nr_cpus

To demonstrate the worst case initial conditions, but being bound by
the above rules:

threshold = 0
amount = -31
batch = 32
error = 256 (2 * 32 * 4 cpus)

per CPU counters are at worst case lower edge for lt detection:

CPU	0	1	2	3
value	-31	-31	-31	-31
fbc->count = 258

and the racing CPUs are all doing equivalent add_unless_lt of -31.
Every racing CPU sees fbc->count = 258 at their initial sample.

what we end up with is:

	CPU 0:				Racing CPUs

	count = 258
	if (258 > 0 + 256) {

					cpu 1 pcp_cnt_add_lt(-31)
CPU	0	1	2	3
value	-31	0	-31	-31
fbc->count = 196
					cpu 2 pcp_cnt_add_lt(-31)
CPU	0	1	2	3
value	-31	0	0	-31
fbc->count = 134
					cpu 3 pcp_cnt_add_lt(-31)
CPU	0	1	2	3
value	-31	0	0	0
fbc->count = 70

		__percpu_counter_add(fbc, -31, 32);

CPU	0	1	2	3
value	0	0	0	0
fbc->count = 6

And so the return value of 1 is valid because 6 > 0. Indeed, looking
at this I can probably change the rule to -batch <= amount <= batch,
because the above with amount = -32 would give and end value of
fbc->count = 2....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
