Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN6TimX113010 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 00:29:45 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 592CE1CEEF89
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 22:31:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	jZRLEeeRSJYZR9sV for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 22:31:41 -0800 (PST)
Date: Thu, 23 Dec 2010 17:31:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] percpu_counter: only disable preemption if needed
	in add_unless_lt()
Message-ID: <20101223063138.GF18264@dastard>
References: <1293076602.2408.434.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293076602.2408.434.camel@doink>
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
Cc: xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 09:56:42PM -0600, Alex Elder wrote:
> In __percpu_counter_add_unless_lt() we don't need to disable
> preemption unless we're manipulating a per-cpu variable.  That only
> happens in a limited case, so narrow the scope of that preemption to
> surround that case.  This makes the "out" label rather unnecessary,
> so replace a couple "goto out" calls to just return.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  lib/percpu_counter.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> Index: b/lib/percpu_counter.c
> ===================================================================
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -232,8 +232,6 @@ int __percpu_counter_add_unless_lt(struc
>  	int	cpu;
>  	int	ret = -1;
>  
> -	preempt_disable();
> -
>  	/*
>  	 * Check to see if rough count will be sufficient for
>  	 * comparison.  First, if the upper bound is too low,
> @@ -241,7 +239,7 @@ int __percpu_counter_add_unless_lt(struc
>  	 */
>  	count = percpu_counter_read(fbc);
>  	if (count + error + amount < threshold)
> -		goto out;
> +		return -1;
>  
>  	/*
>  	 * Next, if the lower bound is above the threshold, we can
> @@ -251,12 +249,15 @@ int __percpu_counter_add_unless_lt(struc
>  	if (count - error + amount > threshold) {
>  		s32 *pcount = this_cpu_ptr(fbc->counters);
>  
> +		preempt_disable();
> +		pcount = this_cpu_ptr(fbc->counters);
>  		count = *pcount + amount;
>  		if (abs(count) < batch) {
>  			*pcount = count;
> -			ret = 1;
> -			goto out;
> +			preempt_enable();
> +			return 1;
>  		}
> +		preempt_enable();
>  	}

Regardless of the other changes, this is not valid. That is:

	amount = -1;
	count = fbc->count;
	.....

	<get preempted>

	<other operations may significantly change fbc->count (i.e
	lots more than error will catch), so the current value of
	count in this context is wrong and cannot be trusted>

	<start running again>

	if (count - error + amount > threshold) {
		<not valid to run this lockless optimisation based
		on a stale count value>
		
		....
	}

Effectively, if we want to be able to use lockless optimisations, we
need to ensure that the value of the global counter that we read
remains within the given error bounds until we have finished making
the lockless modification. That is done via disabling preemption
across the entire function...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
