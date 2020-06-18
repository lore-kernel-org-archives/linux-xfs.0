Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442BEC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 00:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295A021556
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 00:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFRACF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 20:02:05 -0400
Received: from [211.29.132.249] ([211.29.132.249]:53902 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbgFRACF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 20:02:05 -0400
Received: from dread.disaster.area (unknown [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0C11B3A771A;
        Thu, 18 Jun 2020 10:01:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jlhzS-0001Jw-NY; Thu, 18 Jun 2020 10:01:10 +1000
Date:   Thu, 18 Jun 2020 10:01:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] sched: Add PF_MEMALLOC_NOLOCKDEP flag
Message-ID: <20200618000110.GF2005@dread.disaster.area>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617175310.20912-2-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=g7D7g9E5PYaH7GLVyzwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 17, 2020 at 01:53:09PM -0400, Waiman Long wrote:
> There are cases where calling kmalloc() can lead to false positive
> lockdep splat. One notable example that can happen in the freezing of
> the xfs filesystem is as follows:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(sb_internal);
>                                lock(fs_reclaim);
>                                lock(sb_internal);
>   lock(fs_reclaim);
> 
>  *** DEADLOCK ***
> 
> This is a false positive as all the dirty pages are flushed out before
> the filesystem can be frozen. However, there is no easy way to modify
> lockdep to handle this situation properly.
> 
> One possible workaround is to disable lockdep by setting __GFP_NOLOCKDEP
> in the appropriate kmalloc() calls.  However, it will be cumbersome to
> locate all the right kmalloc() calls to insert __GFP_NOLOCKDEP and it
> is easy to miss some especially when the code is updated in the future.
> 
> Another alternative is to have a per-process global state that indicates
> the equivalent of __GFP_NOLOCKDEP without the need to set the gfp_t flag
> individually. To allow the latter case, a new PF_MEMALLOC_NOLOCKDEP
> per-process flag is now added. After adding this new bit, there are
> still 2 free bits left.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/sched.h    |  7 +++++++
>  include/linux/sched/mm.h | 15 ++++++++++-----
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b62e6aaf28f0..44247cbc9073 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1508,6 +1508,7 @@ extern struct pid *cad_pid;
>  #define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
>  #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
>  						 * I am cleaning dirty pages from some other bdi. */
> +#define __PF_MEMALLOC_NOLOCKDEP	0x00100000	/* All allocation requests will inherit __GFP_NOLOCKDEP */

Why is this considered a safe thing to do? Any context that sets
__PF_MEMALLOC_NOLOCKDEP will now behave differently in memory
reclaim as it will think that PF_LOCAL_THROTTLE is set when lockdep
is enabled.

>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>  #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
>  #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
> @@ -1519,6 +1520,12 @@ extern struct pid *cad_pid;
>  #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
>  #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
>  
> +#ifdef CONFIG_LOCKDEP
> +#define PF_MEMALLOC_NOLOCKDEP	__PF_MEMALLOC_NOLOCKDEP
> +#else
> +#define PF_MEMALLOC_NOLOCKDEP	0
> +#endif
> +
>  /*
>   * Only the _current_ task can read/write to tsk->flags, but other
>   * tasks can access tsk->flags in readonly mode for example
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 480a4d1b7dd8..4a076a148568 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -177,22 +177,27 @@ static inline bool in_vfork(struct task_struct *tsk)
>   * Applies per-task gfp context to the given allocation flags.
>   * PF_MEMALLOC_NOIO implies GFP_NOIO
>   * PF_MEMALLOC_NOFS implies GFP_NOFS
> + * PF_MEMALLOC_NOLOCKDEP implies __GFP_NOLOCKDEP
>   * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
>   */
>  static inline gfp_t current_gfp_context(gfp_t flags)
>  {
> -	if (unlikely(current->flags &
> -		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
> +	unsigned int pflags = current->flags;
> +
> +	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS |
> +			       PF_MEMALLOC_NOCMA | PF_MEMALLOC_NOLOCKDEP))) {

That needs a PF_MEMALLOC_MASK.

And, really, if we are playing "re-use existing bits" games because
we've run out of process flags, all these memalloc flags should be
moved to a new field in the task, say current->memalloc_flags. You
could also move PF_SWAPWRITE, PF_LOCAL_THROTTLE, and PF_KSWAPD into
that field as well as they are all memory allocation context process
flags...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
