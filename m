Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN6c2KV114698 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 00:38:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D0A8147954B
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 22:40:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	wAjUc8V3f66hIMeb for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 22:40:00 -0800 (PST)
Date: Thu, 23 Dec 2010 17:39:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] percpu_counter: avoid potential underflow in
	add_unless_lt
Message-ID: <20101223063957.GG18264@dastard>
References: <1293076587.2408.431.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293076587.2408.431.camel@doink>
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

On Wed, Dec 22, 2010 at 09:56:27PM -0600, Alex Elder wrote:
> In __percpu_counter_add_unless_lt(), an assumption is made that
> under certain conditions it's possible to determine that an amount
> can be safely added to a counter, possibly without having to acquire
> the lock.  This assumption is not valid, however.
> 
> These lines encode the assumption:
> 	if (count + amount > threshold + error) {
> 		__percpu_counter_add(fbc, amount, batch);
> 
> Inside __percpu_counter_add(), the addition is performed
> without acquiring the lock if the *sum* of the batch size
> and the CPU-local delta is within the batch size.  Otherwise
> it does the addition after acquiring the lock.
> 
> The problem is that *that* sum may actually end up being greater
> than the batch size, forcing the addition to be performed under
> protection of the lock.  And by the time the lock is acquired, the
> value of fbc->count may have been updated such that adding the given
> amount allows the result to go negative.
> 
> Fix this by open-coding the portion of the __percpu_counter_add()
> that avoids the lock.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  lib/percpu_counter.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: b/lib/percpu_counter.c
> ===================================================================
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -243,9 +243,14 @@ int __percpu_counter_add_unless_lt(struc
>  	 * we can safely add, and might be able to avoid locking.
>  	 */
>  	if (count + amount > threshold + error) {
> -		__percpu_counter_add(fbc, amount, batch);
> -		ret = 1;
> -		goto out;
> +		s32 *pcount = this_cpu_ptr(fbc->counters);
> +
> +		count = *pcount + amount;
> +		if (abs(count) < batch) {
> +			*pcount = count;
> +			ret = 1;
> +			goto out;
> +		}
>  	}

The problem with this is that it never zeros pcount. That means
after a bunch of increments or decrements, abs(*pcount) == 31,
and ever further increment/decrement will drop through to the path
that requires locking. Then we simply have a very expensive global
counter.

We need to take the lock to zero the pcount value because it has to
be added to fbc->count. i.e. if you want this path to remain mostly
lockless, then it needs to do exactly what __percpu_counter_add()
does....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
