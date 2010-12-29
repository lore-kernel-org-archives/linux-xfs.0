Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTKs5u5123040 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 14:54:06 -0600
Subject: Re: [PATCH 2/5] percpu_counter: avoid potential underflow in
	add_unless_lt
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101223063957.GG18264@dastard>
References: <1293076587.2408.431.camel@doink> <20101223063957.GG18264@dastard>
Date: Wed, 29 Dec 2010 14:56:05 -0600
Message-ID: <1293656165.1961.469.camel@doink>
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

On Thu, 2010-12-23 at 17:39 +1100, Dave Chinner wrote:
> On Wed, Dec 22, 2010 at 09:56:27PM -0600, Alex Elder wrote:
> > In __percpu_counter_add_unless_lt(), an assumption is made that
> > under certain conditions it's possible to determine that an amount
> > can be safely added to a counter, possibly without having to acquire
> > the lock.  This assumption is not valid, however.
> > 
> > These lines encode the assumption:
> > 	if (count + amount > threshold + error) {
> > 		__percpu_counter_add(fbc, amount, batch);
> > 
> > Inside __percpu_counter_add(), the addition is performed
> > without acquiring the lock if the *sum* of the batch size
> > and the CPU-local delta is within the batch size.  Otherwise
> > it does the addition after acquiring the lock.
> > 
> > The problem is that *that* sum may actually end up being greater
> > than the batch size, forcing the addition to be performed under
> > protection of the lock.  And by the time the lock is acquired, the
> > value of fbc->count may have been updated such that adding the given
> > amount allows the result to go negative.
> > 
> > Fix this by open-coding the portion of the __percpu_counter_add()
> > that avoids the lock.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > ---
> >  lib/percpu_counter.c |   11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > Index: b/lib/percpu_counter.c
> > ===================================================================
> > --- a/lib/percpu_counter.c
> > +++ b/lib/percpu_counter.c
> > @@ -243,9 +243,14 @@ int __percpu_counter_add_unless_lt(struc
> >  	 * we can safely add, and might be able to avoid locking.
> >  	 */
> >  	if (count + amount > threshold + error) {
> > -		__percpu_counter_add(fbc, amount, batch);
> > -		ret = 1;
> > -		goto out;
> > +		s32 *pcount = this_cpu_ptr(fbc->counters);
> > +
> > +		count = *pcount + amount;
> > +		if (abs(count) < batch) {
> > +			*pcount = count;
> > +			ret = 1;
> > +			goto out;
> > +		}
> >  	}
> 
> The problem with this is that it never zeros pcount. That means
> after a bunch of increments or decrements, abs(*pcount) == 31,
> and ever further increment/decrement will drop through to the path
> that requires locking. Then we simply have a very expensive global
> counter.

I see what you mean.

Perhaps the code (below this) that acquires the lock should
zero *pcount while it's updating fbc->count.  It's already
paying the price of the lock anyway, might as well get the
most value out of doing so.  Anyway, I have stuff of greater
significance in the next note...

> We need to take the lock to zero the pcount value because it has to
> be added to fbc->count. i.e. if you want this path to remain mostly
> lockless, then it needs to do exactly what __percpu_counter_add()
> does....
> 
> Cheers,
> 
> Dave.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
