Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7709E7CA0
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 00:35:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1AE3AC001
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 22:34:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uKZEE01rfohXq7fv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 22:34:56 -0800 (PST)
Date: Sat, 5 Mar 2016 17:34:47 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [RFC PATCH 0/2] percpu_counter: Enable switching to global counter
Message-ID: <20160305063447.GB2235@devil.localdomain>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
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
Cc: Christoph Lameter <cl@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>, Tejun Heo <tj@kernel.org>

On Fri, Mar 04, 2016 at 09:51:37PM -0500, Waiman Long wrote:
> This patchset allows the degeneration of per-cpu counters back to
> global counters when:
> 
>  1) The number of CPUs in the system is large, hence a high cost for
>     calling percpu_counter_sum().
>  2) The initial count value is small so that it has a high chance of
>     excessive percpu_counter_sum() calls.
> 
> When the above 2 conditions are true, this patchset allows the user of
> per-cpu counters to selectively degenerate them into global counters
> with lock. This is done by calling the new percpu_counter_set_limit()
> API after percpu_counter_set(). Without this call, there is no change
> in the behavior of the per-cpu counters.
> 
> Patch 1 implements the new percpu_counter_set_limit() API.
> 
> Patch 2 modifies XFS to call the new API for the m_ifree and m_fdblocks
> per-cpu counters.
> 
> Waiman Long (2):
>   percpu_counter: Allow falling back to global counter on large system
>   xfs: Allow degeneration of m_fdblocks/m_ifree to global counters

NACK.

This change to turns off per-counter free block counters for 32p for
the XFS free block counters.  We proved 10 years ago that a global
lock for these counters was a massive scalability limitation for
concurrent buffered writes on 16p machines.

IOWs, this change is going to cause fast path concurrent sequential
write regressions for just about everyone, even on empty
filesystems.

The behaviour you are seeing only occurs when the filesystem is near
to ENOSPC. As i asked you last time - if you want to make this
problem go away, please increase the size of the filesystem you are
running your massively concurrent benchmarks on.

IOWs, please stop trying to optimise a filesystem slow path that:

	a) 99.9% of production workloads never execute,
	b) where we expect performance to degrade as allocation gets
	   computationally expensive as we close in on ENOSPC,
	c) we start to execute blocking data flush operations that
	   slow everything down massively, and
	d) is indicative that the workload is about to suffer
	   from a fatal, unrecoverable error (i.e. ENOSPC)

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
