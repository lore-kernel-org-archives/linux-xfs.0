Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 639DD7F37
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2015 18:02:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E345BAC005
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2015 16:02:24 -0700 (PDT)
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123]) by
	cuda.sgi.com with ESMTP id dbejrbFjtnIiEAAr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Oct 2015 16:02:22 -0700 (PDT)
Message-ID: <5613017D.7080909@hpe.com>
Date: Mon, 05 Oct 2015 19:02:21 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard>
In-Reply-To: <20151002221649.GL27164@dastard>
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

On 10/02/2015 06:16 PM, Dave Chinner wrote:
> On Fri, Oct 02, 2015 at 01:29:57PM -0400, Waiman Long wrote:
>> In __percpu_counter_compare(), if the current imprecise count is
>> within (batch*nr_cpus) of the input value to be compared, a call
>> to percpu_counter_sum() will be made to get the precise count. The
>> percpu_counter_sum() call, however, can be expensive especially on
>> large systems where there are a lot of CPUs. Large systems also make
>> it more likely that percpu_counter_sum() will be called.
>>
>> The xfs_mod_fdblocks() function calls __percpu_counter_compare()
>> twice. First to see if a smaller batch size should be used for
>> __percpu_counter_add() and the second call to compare the actual
>> size needed. This can potentially lead to 2 calls to the expensive
>> percpu_counter_sum() function.
> There should not be that much overhead in __percpu_counter_compare()
> through this path in normal operation. The slow path is only taken
> as you near ENOSPC...

Yes, it is for optimizing the case there the filesystem is near ENOSP.

>> This patch added an extra argument to __percpu_counter_compare()
>> to return the precise count, if computed. The caller will need to
>> initialize it to an invalid value that it can tell if the precise
>> count is being returned.
> This doesn't work. ENOSPC detection is a lockless algorithm that
> requires absolute precision. Assuming the XFS_ALLOC_SET_ASIDE()
> definition of ENOSPC is 0 blocks free, your change allows this race:
>
> free space: 1 block
>
> thread 1		thread 2			free space
> allocate 1 block	allocate 1 block		  1
> sample pcount = 1					  1
> 			sample pcount = 1		  1
> add fdblocks, -1, 1)					  0
> 			add fdblocks, -1, 1)		  -1
> if (pcount - 1>= 0)	if (pcount - 1>= 0)
>     OK!			    OK!				  -1
>
> So, we've just failed to detect ENOSPC correct. One of those two
> threads should have returned ENOSPC and failed the allocation,
> but instead we've just allowed XFS to allocate a block that doesn't
> exist. Hence we have to resample the percpu counter after the
> modification to ensure that we don't miss this race condition.
>
> Sure, the curent code could race on the second comparisions and
> return ENOSPC to both threads, but that is a perfectly OK thing
> to do. It is vitally important that we don't oversubscribe
> filesystem space, because that will lead to all sorts of other
> problems (deadlocks, hangs, shutdowns, etc) that are very difficult
> to identify the cause of.
>
> FWIW, I'm guessing that you didn't run this patch through xfstests?
> xfstests will find these ENOSPC accounting bugs, and usually quite
> quickly...

Thanks for the review. I did miss the case that there was a race 
condition here. I also haven't run xfstests with this patch. I will do 
so next time.

>> Running the AIM7 disk workload with XFS filesystem, the jobs/min
>> on a 40-core 80-thread 4-socket Haswell-EX system increases from
>> 3805k to 4276k (12% increase) with this patch applied. As measured
>> by the perf tool, the %CPU cycle consumed by __percpu_counter_sum()
>> decreases from 12.64% to 7.08%.
> XFS should only hit the slow __percpu_counter_sum() path patch as
> the fs gets close to ENOSPC, which for your system will be less
> than:
>
> threshold = num_online_cpus * XFS_FDBLOCKS_BATCH * 2 blocks
> 	  = 80 * 1024 * 2 blocks
> 	  = 160,000 blocks
> 	  = 640MB of disk space.
>
> Having less than 1GB of free space in an XFS filesystem is
> considered to be "almost ENOSPC" - when you have TB to PB of space,
> less than 1GB really "moments before ENOSPC".

We have systems with more than 500 CPUs (HT on). I think SGI has systems 
with thousands of CPUs. For those large system, the slowpath will be 
triggered if there is less than 4G or 10G for those thousand CPUs 
systems. What I am trying to do with my patch is to reduce the 
performance overhead in those cases. I have no worry for systems that 
have only a few CPUs. In essence, the per-cpu counter code doesn't scale 
well for systems with large number of CPUs.

> XFS trades off low overhead for fast path allocation  with slowdowns
> as we near ENOSPC in allocation routines. It gets harder to find
> contiguous free space, files get more fragmented, IO takes longer
> because we seek more, etc. Hence we accept that performance slows
> down as as the need for precision increases as we near ENOSPC.
>
> I'd suggest you retry your benchmark with larger filesystems, and
> see what happens...

I don't think I am going to see the slowdown that I observed on larger 
filesystems with more free space. However, I still think that doing 2 
precise count computations is wasteful. I am planning to rework my patch 
to disable precise count for the first comparison in xfs_mod_fdblocks as 
that comparison is used to gauge how far it is from ENOSPC. So we don't 
really need to get the precise count as long as number of CPUs are taken 
into consideration in the comparison. This change should enable the new 
patch to have similar performance overhead reduction effect as the old 
one without the racing condition you mentioned above.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
