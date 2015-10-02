Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A9977F55
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 17:17:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2305E304039
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 15:16:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KgXs0ypOcrk4GWt4 for <xfs@oss.sgi.com>;
	Fri, 02 Oct 2015 15:16:52 -0700 (PDT)
Date: Sat, 3 Oct 2015 08:16:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151002221649.GL27164@dastard>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
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
To: Waiman Long <Waiman.Long@hpe.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>

On Fri, Oct 02, 2015 at 01:29:57PM -0400, Waiman Long wrote:
> In __percpu_counter_compare(), if the current imprecise count is
> within (batch*nr_cpus) of the input value to be compared, a call
> to percpu_counter_sum() will be made to get the precise count. The
> percpu_counter_sum() call, however, can be expensive especially on
> large systems where there are a lot of CPUs. Large systems also make
> it more likely that percpu_counter_sum() will be called.
> 
> The xfs_mod_fdblocks() function calls __percpu_counter_compare()
> twice. First to see if a smaller batch size should be used for
> __percpu_counter_add() and the second call to compare the actual
> size needed. This can potentially lead to 2 calls to the expensive
> percpu_counter_sum() function.

There should not be that much overhead in __percpu_counter_compare()
through this path in normal operation. The slow path is only taken
as you near ENOSPC...

> This patch added an extra argument to __percpu_counter_compare()
> to return the precise count, if computed. The caller will need to
> initialize it to an invalid value that it can tell if the precise
> count is being returned.

This doesn't work. ENOSPC detection is a lockless algorithm that
requires absolute precision. Assuming the XFS_ALLOC_SET_ASIDE()
definition of ENOSPC is 0 blocks free, your change allows this race:

free space: 1 block

thread 1		thread 2			free space
allocate 1 block	allocate 1 block		  1
sample pcount = 1					  1
			sample pcount = 1		  1
add fdblocks, -1, 1)					  0
			add fdblocks, -1, 1)		  -1
if (pcount - 1 >= 0)	if (pcount - 1 >= 0)
   OK!			    OK!				  -1

So, we've just failed to detect ENOSPC correct. One of those two
threads should have returned ENOSPC and failed the allocation,
but instead we've just allowed XFS to allocate a block that doesn't
exist. Hence we have to resample the percpu counter after the
modification to ensure that we don't miss this race condition.

Sure, the curent code could race on the second comparisions and
return ENOSPC to both threads, but that is a perfectly OK thing
to do. It is vitally important that we don't oversubscribe
filesystem space, because that will lead to all sorts of other
problems (deadlocks, hangs, shutdowns, etc) that are very difficult
to identify the cause of.

FWIW, I'm guessing that you didn't run this patch through xfstests?
xfstests will find these ENOSPC accounting bugs, and usually quite
quickly...

> Running the AIM7 disk workload with XFS filesystem, the jobs/min
> on a 40-core 80-thread 4-socket Haswell-EX system increases from
> 3805k to 4276k (12% increase) with this patch applied. As measured
> by the perf tool, the %CPU cycle consumed by __percpu_counter_sum()
> decreases from 12.64% to 7.08%.

XFS should only hit the slow __percpu_counter_sum() path patch as
the fs gets close to ENOSPC, which for your system will be less
than:

threshold = num_online_cpus * XFS_FDBLOCKS_BATCH * 2 blocks
	  = 80 * 1024 * 2 blocks
	  = 160,000 blocks
	  = 640MB of disk space.

Having less than 1GB of free space in an XFS filesystem is
considered to be "almost ENOSPC" - when you have TB to PB of space,
less than 1GB really "moments before ENOSPC".

XFS trades off low overhead for fast path allocation  with slowdowns
as we near ENOSPC in allocation routines. It gets harder to find
contiguous free space, files get more fragmented, IO takes longer
because we seek more, etc. Hence we accept that performance slows
down as as the need for precision increases as we near ENOSPC.

I'd suggest you retry your benchmark with larger filesystems, and
see what happens...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
