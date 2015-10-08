Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A42207F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 20:04:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 885C1304039
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 18:03:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FBThLelwBwkkKzyj for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 18:03:55 -0700 (PDT)
Date: Thu, 8 Oct 2015 12:02:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151008010218.GT27164@dastard>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard> <561579EA.60507@hpe.com>
	<20151007230441.GG32150@dastard>
	<20151007232010.GA21142@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007232010.GA21142@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hpe.com>, xfs@oss.sgi.com

On Wed, Oct 07, 2015 at 04:20:10PM -0700, Tejun Heo wrote:
> Hello, Dave.
> 
> On Thu, Oct 08, 2015 at 10:04:42AM +1100, Dave Chinner wrote:
> ...
> > As it is, the update race you pointed out is easy to solve with
> > __this_cpu_cmpxchg rather than _this_cpu_sub (similar to mod_state()
> > in the MM percpu counter stats code, perhaps).
> 
> percpu cmpxchg is no different from sub or any other operations
> regarding cross-CPU synchronization.  They're safe iff the operations
> are on the local CPU.  They have to be made atomics if they need to be
> manipulated from remote CPUs.

Again, another trivially solvable problem, but still irrelevant
because we don't have the data that tells us whether changing the
counter behaviour solves the problem....

> That said, while we can't manipulate the percpu counters directly, we
> can add a separate global counter to cache sum result from the
> previous run which gets automatically invalidated when any percpu
> counter overflows.
>
> That should give better and in case of
> back-to-back invocations pretty good precision compared to just
> returning the global overflow counter.  Interface-wise, that'd be a
> lot easier to deal with although I have no idea whether it'd fit this
> particular use case or whether this use case even exists.

No, it doesn't help - it's effectively what Waiman's original patch
did by returning the count from the initial comparison and using
that for ENOSPC detection instead of doing a second comparison...

FWIW, XFS has done an expensive per-cpu counter sum in this ENOSPC
situation since 2006, but in 2007 ENOSPC was wrapped in a mutex to
prevent spinlock contention on the aggregated global counter:

commit 20b642858b6bb413976ff13ae6a35cc596967bab
Author: David Chinner <dgc@sgi.com>
Date:   Sat Feb 10 18:35:09 2007 +1100

    [XFS] Reduction global superblock lock contention near ENOSPC.
    
    The existing per-cpu superblock counter code uses the global superblock
    spin lock when we approach ENOSPC for global synchronisation. On larger
    machines than this code was originally tested on this can still get
    catastrophic spinlock contention due increasing rebalance frequency near
    ENOSPC.
    
    By introducing a sleeping lock that is used to serialise balances and
    modifications near ENOSPC we prevent contention from needlessly from
    wasting the CPU time of potentially hundreds of CPUs.
    
    To reduce the number of balances occuring, we separate the need rebalance
    case from the slow allocate case. Now, a counter running dry will trigger
    a rebalance during which counters are disabled. Any thread that sees a
    disabled counter enters a different path where it waits on the new mutex.
    When it gets the new mutex, it checks if the counter is disabled. If the
    counter is disabled, then we _know_ that we have to use the global counter
    and lock and it is safe to do so immediately. Otherwise, we drop the mutex
    and go back to trying the per-cpu counters which we know were re-enabled.
    
    SGI-PV: 952227
    SGI-Modid: xfs-linux-melb:xfs-kern:27612a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

This is effectively the same symptoms that what we are seeing with
the new "lockless" generic percpu counteri algorithm, which is why
I'm trying to find out if it an issue with the counter
implementation before I do anything else...

FWIW, the first comparison doesn't need to be that precise as it
just changes the batch passed to percpu_counter_add() to get the
value folded back into the global counter immediately near ENOSPC.
This is done so percpu_counter_read() becomes more accurate as
ENOSPC is approached as that is used for monitoring and reporting
(e.g. via vfsstat). If we want to avoid a counter sum, then this
is the comparison we will need to modify in XFS.

However, the second comparison needs to be precise as that's the one
that does the ENOSPC detection. That sum needs to be done after the
counter add that "uses" the space and so there is no avoiding having
an expensive counter sum as we near ENOSPC....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
