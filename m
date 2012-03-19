Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2JGll0l145401 for <xfs@oss.sgi.com>; Mon, 19 Mar 2012 11:47:47 -0500
Message-ID: <4F676330.1070005@sgi.com>
Date: Mon, 19 Mar 2012 11:47:44 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/10] xfs: introduce an allocation workqueue
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-6-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/06/12 22:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> We currently have significant issues with the amount of stack that
> allocation in XFS uses, especially in the writeback path. We can
> easily consume 4k of stack between mapping the page, manipulating
> the bmap btree and allocating blocks from the free list. Not to
> mention btree block readahead and other functionality that issues IO
> in the allocation path.
>
> As a result, we can no longer fit allocation in the writeback path
> in the stack space provided on x86_64. To alleviate this problem,
> introduce an allocation workqueue and move all allocations to a
> seperate context. This can be easily added as an interposing layer
> into xfs_alloc_vextent(), which takes a single argument structure
> and does not return until the allocation is complete or has failed.
>
> To do this, add a work structure and a completion to the allocation
> args structure. This allows xfs_alloc_vextent to queue the args onto
> the workqueue and wait for it to be completed by the worker. This
> can be done completely transparently to the caller.
>
> The worker function needs to ensure that it sets and clears the
> PF_TRANS flag appropriately as it is being run in an active
> transaction context. Work can also be queued in a memory reclaim
> context, so a rescuer is needed for the workqueue.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>


#include <std/disclaimer>	# speaking for myself

As the problem is described above, it sounds like the STANDARD x86_64
configuration is in stack crisis needing to put a worker in-line to
solve the stack issue.

Adding an in-line worker to fix a "stack crisis" without any other
measures and the Linux's implementation of the kernel stack (not
configurable on compilation, and requiring order of magnitude physical
allocation), sent me into a full blown rant last week. The standard,
what? when? why? how? WTF? - you know the standard rant. I even
generated a couple yawns of response from people! :)


x86_64, x86_32 (and untested ARM) code can be sent to anyone who wants
to try this at home. I would say, a generic configuration is using at
most 3KB of the stack is being used by the time xfs_alloc_vextent()
is being called and that includes the nested calls of the routine. So
for most setups, we can say the standard 8KB stacks is in no danger of
depletion and will not benefit from this feature.

Let us talk about 4KB stacks....people may need to use them because
the embedded environment has less memory, it is more sensitive to the
physical contiguous nature of the multi-page stacks, and the smaller
memory amounts may cause the allocation routines to nest more. If XFS
can't optimize the stack use enough to be much help, and going to
8KB stacks is too expensive, then extra-ordinary operations such as
this feature may be needed but please make it a configurable option
for 4KB stacks and not the default code.

I believe that the kernel stacks do not need to be physically
contiguous. Would 8KB stacks be used in this environment if the Linux
did not implement them as physically contiguous? What is the plan
when the 8KB limits become threatened?

This feature and the related nuances are good topics for the
upcoming Linux Filesystem and MM forum next month.

Mark Tinguely


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
