Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C79B29DF5
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 12:33:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 604958F8052
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 10:33:26 -0700 (PDT)
Received: from g1t6214.austin.hp.com (g1t6214.austin.hp.com [15.73.96.122]) by
	cuda.sgi.com with ESMTP id Awg51iJhu98OC5D6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 10:33:24 -0700 (PDT)
Message-ID: <561405E1.8020008@hpe.com>
Date: Tue, 06 Oct 2015 13:33:21 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard>
In-Reply-To: <20151006002538.GO27164@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>

On 10/05/2015 08:25 PM, Dave Chinner wrote:
> On Mon, Oct 05, 2015 at 07:02:21PM -0400, Waiman Long wrote:
> ....
>>> Having less than 1GB of free space in an XFS filesystem is
>>> considered to be "almost ENOSPC" - when you have TB to PB of space,
>>> less than 1GB really "moments before ENOSPC".
>> We have systems with more than 500 CPUs (HT on). I think SGI has
>> systems with thousands of CPUs. For those large system, the slowpath
>> will be triggered if there is less than 4G or 10G for those thousand
>> CPUs systems.
> yes, I'm well aware of this. But systems with hundreds to thousands
> of CPUs simply do not operate their storage at this capacity.
> They'll have hundreds of TB or PBs of storage attached, so if we
> trigger the slow path at 10GB of free space, we are talking about
> having already used>  99.9% of that capacity.
>
> In which case, they are already in a world of pain because
> filesystem allocation performance starts to degrade at>90%
> capacity, and we start cutting back preallocations at>95% capacity,
> and we really start to throttle ispace allocations to their
> minimum possible sizes at>99% capacity. IOWs, hitting this slow
> path at>99.9% capacity is really irrelevant....
>

In the production environment, we do expect to see large storage 
attached to those big machines. However, in the testing environment, we 
may have such large pool of disks to be used. Alternatively, a user may 
create a small filesystem partition for certain specific use. Under 
those circumstances, the slowpath may be triggered.

>> What I am trying to do with my patch is to reduce the
>> performance overhead in those cases. I have no worry for systems
>> that have only a few CPUs. In essence, the per-cpu counter code
>> doesn't scale well for systems with large number of CPUs.
> Maybe so, but we don't tend ot optimise slow paths - we trade off a
> really fast fast path for a slow, more complex slow path all over
> the place. Not just in XFS, but all over the kernel.

I am not proposing any change to the fast path and they should have the 
same performance as before.

>>> XFS trades off low overhead for fast path allocation  with slowdowns
>>> as we near ENOSPC in allocation routines. It gets harder to find
>>> contiguous free space, files get more fragmented, IO takes longer
>>> because we seek more, etc. Hence we accept that performance slows
>>> down as as the need for precision increases as we near ENOSPC.
>>>
>>> I'd suggest you retry your benchmark with larger filesystems, and
>>> see what happens...
>> I don't think I am going to see the slowdown that I observed on
>> larger filesystems with more free space.
> So there is no problem that needs fixing.... ;)
>

Well, I am still worrying that corner cases when the slowpath is 
triggered. I would like to make it perform better in those cases.


>> However, I still think that
>> doing 2 precise count computations is wasteful.
> I really don't care about the CPU overhead, because it's far more
> important that:
>
> 	1) the zero threshold detection is precise and correct;
> 	2) the fast path is really fast; and
> 	3) I understand the code well enough to be able to debug
> 	   and maintain it.

I completely agree with that:-)

>> I am planning to rework my patch to disable precise count for the
>> first comparison in xfs_mod_fdblocks as that comparison is used to
>> gauge how far it is from ENOSPC.  So we don't really need to get
>> the precise count as long as number of CPUs are taken into
>> consideration in the comparison.
> I think you are looking in the wrong place. There is nothing
> wrong with XFS doing two compares here. If we are hitting the
> __percpu_counter_compare() slow path too much, then we should be
> understanding exactly why that slow path is being hit so hard so
> often. I don't see any analysis of the actual per-cpu counter
> behaviour and why the slow path is being taken so often....

I am thinking of making the following changes:

  fs/xfs/xfs_mount.c |   11 ++++++-----
  1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..bb2e0ef 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1183,12 +1183,13 @@ xfs_mod_fdblocks(
       * Taking blocks away, need to be more accurate the closer we
       * are to zero.
       *
-     * If the counter has a value of less than 2 * max batch size,
-     * then make everything serialise as we are real close to
-     * ENOSPC.
+     * The maximum error of imprecise counter is (nr_cpus * batch size).
+     * If the imprecise counter has a value less than (nr_cpus + 2) *
+     * max batch size, then make everything serialise as we may be real
+     * close to ENOSPC.
       */
-    if (__percpu_counter_compare(&mp->m_fdblocks, 2 * XFS_FDBLOCKS_BATCH,
-                     XFS_FDBLOCKS_BATCH) < 0)
+    if (percpu_counter_read(&mp->m_fdblocks) <
+       (num_online_cpus() + 2) * XFS_FDBLOCKS_BATCH)
          batch = 1;
      else
          batch = XFS_FDBLOCKS_BATCH;
-- 

Please let me know if you think that is acceptable to you.

> Indeed, have you considered using something like this in the precise
> path of __percpu_counter_compare() rather than percpu_counter_sum():
>
> /*
>   * Aggregate the per-cpu counter magazines back into the global
>   * counter. This avoids the need for repeated compare operations to
>   * run the slow path when the majority of the counter value is held
>   * in the per-cpu magazines. Folding them back into the global
>   * counter means we will continue to hit the fast
>   * percpu_counter_read() path until the counter value falls
>   * completely within the comparison limit passed to
>   * __percpu_counter_compare().
>   */
> static s64 percpu_counter_aggregate(struct percpu_counter *fbc)
> {
> 	s64 ret;
> 	int cpu;
> 	unsigned long flags;
>
> 	raw_spin_lock_irqsave(&fbc->lock, flags);
> 	ret = fbc->count;
> 	for_each_online_cpu(cpu) {
> 		s32 count = __this_cpu_read(*fbc->counters);
>                  ret += count;
> 		__this_cpu_sub(*fbc->counters, count)
> 	}
> 	fbc->count = ret;
> 	raw_spin_unlock_irqrestore(&fbc->lock, flags);
> 	return ret;
> }

I don't think that will work as some other CPUs may change the percpu 
counters values between percpu_counter_aggregate() and 
__percpu_counter_compare(). To be safe, the precise counter has to be 
compted whenever the comparison value difference is less than nr_cpus * 
batch size.

> Some perspective: you wouldn't have seen this behaviour with the
> previous per-cpu counter code in XFS near ENOSPC. By the time it got
> this close to ENOSPC it was completely serialising all access to the
> free space counters with a mutex and then doing per-cpu sums under
> that mutex (see commit 20b6428 ("[XFS] Reduction global superblock
> lock contention near ENOSPC.").  Hence it wouldn't have appeared in
> your profiles, even though it was much worse in terms of contention
> and lock hold times than the current code is.
>
> This looks to be the same fundamental problem - the per-cpu counter
> values are not being managed in a way that reduces minimises precise
> comparison overhead. Making the above change will tell us whether
> this is the case or not...

I have some thoughts on how to reduce precise comparison overhead, but I 
need more time to work out the details.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
