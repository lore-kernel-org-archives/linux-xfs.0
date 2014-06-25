Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8056E7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 22:16:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE6ADAC002
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 20:16:48 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	BkQpG6DetgXhjFX3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 20:16:47 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id tr6so1091080ieb.24
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 20:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140624032521.GA12164@htj.dyndns.org>
References: <CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
	<CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
	<CANGgnMZ8OwzfBj5m9H7c6q2yahGhU7oFZLsJfVxnWoqZExkZmQ@mail.gmail.com>
	<20140624030240.GB9508@dastard> <20140624032521.GA12164@htj.dyndns.org>
From: Austin Schuh <austin@peloton-tech.com>
Date: Tue, 24 Jun 2014 20:16:26 -0700
Message-ID: <CANGgnMa99dCKmFkVAY1XdXVY-UVdbg7Ey8-8iTbs5tm=bYS3uA@mail.gmail.com>
Subject: Re: On-stack work item completion race? (was Re: XFS crash?)
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
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>

[Adding tglx to the cc.  Sorry for any double sends]

On Mon, Jun 23, 2014 at 8:25 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Jun 24, 2014 at 01:02:40PM +1000, Dave Chinner wrote:
>> start_flush_work() is effectively a special queue_work()
>> implementation, so if if it's not safe to call complete() from the
>> workqueue as the above patch implies then this code has the same
>> problem.
>>
>> Tejun - is this "do it yourself completion" a known issue w.r.t.
>> workqueues? I can't find any documentation that says "don't do
>> that" so...?
>
> It's more complex than using flush_work() but there's nothing
> fundamentally wrong with it.  A work item is completely unlinked
> before its execution starts.  It's safe to free the work item once its
> work function started, whether through kfree() or returning.
>
> One difference between flush_work() and manual completion would be
> that if the work item gets requeued, flush_work() would wait for the
> queued one to finish but given the work item is one-shot this doesn't
> make any difference.
>
> I can see no reason why manual completion would behave differently
> from flush_work() in this case.

I went looking for a short trace in my original log to show the
problem, and instead found evidence of the second problem.  I still
like the shorter flush_work call, but that's not my call.

I did find this comment in the process_one_work function.  Sounds like
this could be better documented.

  /*
   * It is permissible to free the struct work_struct from
   * inside the function that is called from it, this we need to
   * take into account for lockdep too.  To avoid bogus "held
   * lock freed" warnings as well as problems when looking into
   * work->lockdep_map, make a copy and use that here.
   */

>> As I understand it, what then happens is that the workqueue code
>> grabs another kworker thread and runs the next work item in it's
>> queue. IOWs, work items can block, but doing that does not prevent
>> execution of other work items queued on other work queues or even on
>> the same work queue. Tejun, did I get that correct?
>
> Yes, as long as the workqueue is under its @max_active limit and has
> access to an existing kworker or can create a new one, it'll start
> executing the next work item immediately; however, the guaranteed
> level of concurrency is 1 even for WQ_RECLAIM workqueues.  IOW, the
> work items queued on a workqueue must be able to make forward progress
> with single work item if the work items are being depended upon for
> memory reclaim.

I mentioned this to Dave when I initially started this thread, but I'm
running a RT patched kernel.  I don't see forwards progress.  The
workqueue is only used in 1 spot (xfs_alloc_wq), and has
WQ_MEM_RECLAIM set.  I started with a 10,000,000 line trace and pulled
out the entries which referenced the workqueue and pool leading up to
the lockup.

             scp-4110  [001] ....1.3   101.184640:
workqueue_queue_work: work struct=ffff8803c782d900
function=xfs_bmapi_allocate_worker workqueue=ffff88040c9f5a00
pool=ffff88042dae3fc0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.3   101.184641:
workqueue_activate_work: work struct ffff8803c782d900
     kworker/1:1-89    [001] ....1.1   101.184883:
workqueue_nr_running: pool=ffff88042dae3fc0 nr_running=1
     kworker/1:1-89    [001] ....1..   101.184885:
workqueue_execute_start: work struct ffff8803c782d900: function
xfs_bmapi_allocate_worker
     irq/44-ahci-275   [001] ....1.5   101.185086:
workqueue_queue_work: work struct=ffff8800ae3f01e0 function=xfs_end_io
workqueue=ffff88040b459a00 pool=ffff88042dae3fc0 req_cpu=512 cpu=1
     irq/44-ahci-275   [001] ....1.5   101.185088:
workqueue_activate_work: work struct ffff8800ae3f01e0
             scp-4110  [001] ....1..   101.187911: xfs_ilock: dev 8:5
ino 0xf9e flags ILOCK_EXCL caller xfs_iomap_write_allocate
             scp-4110  [001] ....1.3   101.187914:
workqueue_queue_work: work struct=ffff8803c782d900
function=xfs_bmapi_allocate_worker workqueue=ffff88040c9f5a00
pool=ffff88042dae3fc0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.3   101.187915:
workqueue_activate_work: work struct ffff8803c782d900
             scp-4110  [001] ....1.4   101.187926:
workqueue_queue_work: work struct=ffff88040a6a01c8
function=blk_delay_work workqueue=ffff88040c9f4a00
pool=ffff88042dae44c0 req_cpu=512 cpu=1
             scp-4110  [001] ....1.4   101.187926:
workqueue_activate_work: work struct ffff88040a6a01c8
     kworker/1:1-89    [001] ....1..   101.187998:
workqueue_execute_end: work struct ffff8803c782d900
     kworker/1:1-89    [001] ....1..   101.188000:
workqueue_execute_start: work struct ffff8800ae3f01e0: function
xfs_end_io
     kworker/1:1-89    [001] ....1..   101.188001: xfs_ilock: dev 8:5
ino 0xf9e flags ILOCK_EXCL caller xfs_setfilesize

The last work never runs.  Hangcheck triggers shortly after.

I spent some more time debugging, and I am seeing that
tsk_is_pi_blocked is returning 1 in sched_submit_work
(kernel/sched/core.c).  It looks like sched_submit_work is not
detecting that the worker task is blocked on a mutex.

This looks very RT related right now.  I see 2 problems from my
reading (and experimentation).  The first is that the second worker
isn't getting started because tsk_is_pi_blocked is reporting that the
task isn't blocked on a mutex.  The second is that even if another
worker needs to be scheduled because the original worker is blocked on
a mutex, we need the pool lock to schedule another worker.  The pool
lock can be acquired by any CPU, and is a spin_lock.  If we end up on
the slow path for the pool lock, we hit
BUG_ON(rt_mutex_real_waiter(task->pi_blocked_on)) in
task_blocks_on_rt_mutex in rtmutex.c.  I'm not sure how to deal with
either problem.  Thomas, any ideas?

Hopefully I've got all my facts right...  Debugging kernel code is a
whole new world from userspace code.

Thanks!
Austin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
