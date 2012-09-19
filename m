Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JNXxH2001000 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 18:33:59 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	onWIEl1dYEr6IJMa for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 16:35:08 -0700 (PDT)
Date: Thu, 20 Sep 2012 09:34:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
Message-ID: <20120919233435.GF31501@dastard>
References: <20120919163133.097340199@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120919163133.097340199@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
> We have experience file system hangs on the IA64, X86_32 and X86_64
> environments caused by a deadlock on AGF buffers.
> 
> The below stack frames is a simple example of the deadlock. This example
> was taken from the current OSS Linux 3.6 sources on a x86_32 machine that
> was suffering from a daemon storm at the time:

I hit it last night via test 113 on a RHEL6 backport that has the
old workqueue implementation and so only has one worker per CPU.

> The holder of the lock:
....
> The worker that is blocked waiting for the lock:
> 
> PID: 30223  TASK: dfb86cb0  CPU: 3   COMMAND: "xfsalloc"
>  #0 [d4a45b9c] __schedule at c068a7e8
>  #1 [d4a45c24] schedule at c068abd9
>  #2 [d4a45c2c] schedule_timeout at c0689808
>  #3 [d4a45c90] __down_common at c068a1d4
>  #4 [d4a45cc0] __down at c068a25e
>  #5 [d4a45cc8] down at c02598ff
>  #6 [d4a45cd8] xfs_buf_lock at e1ebaa6d [xfs]
>  #7 [d4a45cf8] _xfs_buf_find at e1ebad0e [xfs]
>  #8 [d4a45d2c] xfs_buf_get_map at e1ebaf00 [xfs]
>  #9 [d4a45d58] xfs_buf_read_map at e1ebbce3 [xfs]
> #10 [d4a45d7c] xfs_trans_read_buf_map at e1f2974e [xfs]
> #11 [d4a45dac] xfs_read_agf at e1ed7d2c [xfs]
> #12 [d4a45dec] xfs_alloc_read_agf at e1ed7f2d [xfs]
> #13 [d4a45e0c] xfs_alloc_fix_freelist at e1ed84f6 [xfs]

So this has to be the first time we've tried to use this AG for
allocation in the transaction, otherwise we would have found it
attached to the transaction. I'll come back to this.

> #14 [d4a45e4c] check_preempt_curr at c0261c47
> #15 [d4a45e60] ttwu_do_wakeup at c0261c7e
> #16 [d4a45e8c] radix_tree_lookup at c0465ab5
> #17 [d4a45e94] xfs_perag_get at e1f19a36 [xfs]
> #18 [d4a45ec8] __xfs_alloc_vextent at e1ed899d [xfs]
> #19 [d4a45f1c] xfs_alloc_vextent_worker at e1ed8edb [xfs]
> #20 [d4a45f30] process_one_work at c024e39d
> #21 [d4a45f74] process_scheduled_works at c024e6ad
> #22 [d4a45f84] rescuer_thread at c024e7f0
> #23 [d4a45fbc] kthread at c0253c1b
> #24 [d4a45fe8] kernel_thread_helper at c0692af
> 
> The AGF buffer can be locked across multiple calls to xfs_alloc_vextent().
> This buffer must remained locked until the transaction is either committed or
> canceled. The deadlock occurs when other callers of xfs_alloc_vextent() block
> waiting for the AGF buffer lock and the workqueue manager cannot create another
> allocate worker to service the allocation request for the process that holds
> the lock, The default limit for the allocation worker is 256 workers and that
> limit can be increased to 512, but lack of resources before this limit is the
> real reason the workqueue manager cannot create another worker.

IOWs, the problem is that a worker thread that holds a resource cannot
get scheduled to make progress.

> The solution to this problem is to move the allocation worker so that the
> loops over xfs_alloc_vextent() for a single transaction, on non-metadata
> paths will happen in a single worker.

That just moves the problem. e.g. to unwritten extent conversion.
Say we only have 3 worker threads maximum:

	kworker 1		kworker 2	kworker 3
	end io			endio		end io
	ilock_excl		ilock_excl	ilock_excl
	(block)			(blocks)	(blocks)

<holder releases lock>

	(gets lock)
	bmapi_write(convert)
	queue work
	wait for work

So now we are stuck again.

> I traced the callers of xfs_alloc_vextent(), noting transaction creation,
> commits and cancels; I noted loops in the callers and which were marked
> as metadata/userdata. I can send this document to reviewers.

No need, I can see the (generic) problem now that it has been
pointed out.

Basically, this is what the rescuer thread is kind of for - it works
around the inability to allocate a new worker thread due to a OOM
situation. This doesn't help us here because that rescuer would
simply block like the others. Hence a rescuer thread concept doesn't
solve the problem at all.

So lets go back to the case at hand. We block because this is the
first attempt to lock the AGF in an allocation, and the
XFS_ALLOC_FLAG_TRYLOCK flag is not set. This indicates we are asking
for allocation in a specific AG from __xfs_alloc_vextent(), and we
can't do that until some other allocation completes. Given that AGF
locking orders are strictly enforced, we know that the holder of the
AGF will not deadlock as long as it can be scheduled to run.

IOWs, it is not safe to block forever on a lock in a worker thread
when there are outside dependencies on that lock being released to
make progress. To me that's not really a deadlock in the traditional
sense - it's more akin to a priority inversion that prevents the
resource holder from making progress. i.e. blocked threads hold the
worker resources, which prevent the lock holder from being able to
run and release the lock.

Hmmm. I think there are other ways to trigger this as well.
Anything that holds the AGF locked for a period of time is going to
cause allocations to back up like this, regardless of whether we
queue at xfs_alloc_vexent() or xfs_bmapi_write(). For example,
FITRIM holds the AGF locked for as long as it takes to issue all the
discard operations. That could stall enough allocations to run us
out of worker threads and hence effectively stop data allocations
from being run for some period of time. It won't deadlock, but it
certainly is sub-optimal behaviour.

I suspect the only way to fix this is to re-use the old workqueue
method of avoiding blocking on the workqueue indefinitely. That is,
if we fail to get the lock in this case, we return with EGAIN and
requeue the work. __xfs_alloc_vextent() and xfs_alloc_fix_freelist()
already have trylock support, so this should be fairly easy to do.
If I also convert the work to delayed work, I can easily add a
backoff that will prevent busy looping on the workqueue.

I'll have a quick look at this and see what falls out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
