Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87FdDEK248666 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 10:39:14 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF41414EAD3C
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 08:51:04 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id uaFmzre6Nnoi8iFP for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 08:51:04 -0700 (PDT)
Message-ID: <4C865CC4.9070701@kernel.org>
Date: Tue, 07 Sep 2010 17:39:48 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<20100907124850.GP705@dastard>
In-Reply-To: <20100907124850.GP705@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

On 09/07/2010 02:48 PM, Dave Chinner wrote:
> On Tue, Sep 07, 2010 at 12:35:46PM +0200, Tejun Heo wrote:
>> Heh, sorry about that.  I'm writing it now.  The plan is to audit all
>> the create_*workqueue() users and replace them with alloc_workqueue()
>> w/ appropriate parameters.  Most of them would be fine with the
>> default set of parameters but there are a few which would need some
>> adjustments.
> 
> Ok. Do you have an advance draft of the docco I can read?

Including half-finished one at the end of this mail.

> Almost. What happens is that there is a queue of data IO
> completions on q0, say w1...wN where wX is in the middle of the
> queue. wX requires lock A, but lock A is held by a a transaction
> commit that is blocked by IO completion t1 on q1. The dependency
> chain we then have is:
> 
> 	wX on q0 -> lock A -> t1 on q1
> 
> To prevent wX from blocking q0, when lock A is not gained, we
> requeue wX to the tail of q0 such that the queue is not wX+1..wN,wX.
> this means that wX will not block completion processing of data IO.
> If wX is the only work on q0, then to stop the work queue from
> spinning processing wX, queueing wX, processing wX.... there is a
> delay(1) call to allow some time for other IOs to complete to occur
> before trying again to process wX again.
> 
> At some point, q1 is processed and t1 is run and lock A
> released. Once this happens, wX will gain lock A and finish the
> completion and be freed.
> 
> The issue I appear to be seeing is that while q0 is doing:
> 
> 	wX -> requeue on q0 -> delay(1) -> wX -> requeue q0 -> wX
> 
> q1 which contains t1 is never getting processed, and hence the q0/wX
> loop is never getting broken.

I see.  The use case itself shouldn't be problematic at all for cmwq
(sans bugs of course).  In the other reply, you said "the system is
100% unresponsive when the livelock occurs", which is kind of
puzzling.  It isn't really a livelock.  There's no busy loop.  sysrq
should work unless something else is going horribly wrong.  Are you
running with hangcheck timer enabled?  Anyways, please try with the
fixes from wq#for-linus branch pulled and gather as much information
as possible once such hang occurs.

>> Also, how does delay(1) help with chewing up CPU?  Are you talking
>> about avoiding constant lock/unlock ops starving other lockers?  In
>> such case, wouldn't cpu_relax() make more sense?
> 
> Basically delay(1) is used in many places in XFS as a "backoff and
> retry after a short period of time" mechanism in places where
> blocking would lead to deadlock or we need a state change to occur
> before retrying the operation that would have deadlocked. If we
> don't put a backoff in, then we simply burn CPU until the condition
> clears.
> 
> In the case of the data Io completion workqueue processing, the CPU
> burn occurred when the only item on the workqueue was the inode that
> we could not lock.  Hence the backoff. It's not a great solution,
> but it's the only one that could be sued without changing everything
> to use delayed works and hence suffer the associated structure bloat
> for what is a rare corner case....

Hmm... The point where I'm confused is that *delay()'s are busy waits.
They burn CPU cycles.  I suppose you're referring to *sleep()'s,
right?

> As I said, this is fine if the only thing that is delayed is data IO
> completion processing for XFS. When it is a generic kworker thread,
> it has much greater impact, I think....

As I wrote above, the new implementation won't have problem with such
usage, well, at least, not by design.  :-)

>> Yeap, that's just a random safety value I chose.  In most cases, the
>> level of concurrency is limited by the number of work_struct, so the
>> default limit is there just to survive complete runaway cases.
> 
> Ok, make sense now. I wish that was already in a comment in the code ;)

Will add a reference to the documentation.

>> I don't remember but once I increased maximum concurrency for every
>> workqueue (the limit was 128 or something) and xfs pretty quickly hit
>> the concurrency limit.  IIRC, there was a function which allocates
>> work_struct and schedules it.  I'll look through the emails.
> 
> How do you get concurrency requirements of 128 when you only have a
> small number of CPUs?

Probably I have overloaded the term 'concurrency' too much.  In this
case, I meant the number of workers assigned to work items of the wq.
If you fire off N work items which sleep at the same time, cmwq will
eventually try to create N workers as each previous worker goes to
sleep so that the CPU doesn't sit idle while there are work items to
process as long as N < @wq->nr->active.

Documentation follows.


Concurrency Managed Workqueue

September, 2010		Tejun Heo <tj@kernel.org>

CONTENTS

1. Overview
2. The Design
3. Workqueue Attributes
4. Examples and Pitfalls

1. Overview

There are many cases where an execution context is needed and there
already are several mechanisms for them.  The most commonly used one
is workqueue (wq).  In the original workqueue implementation, a multi
threaded (MT) wq had one thread per CPU and a single threaded (ST) wq
had one thread system-wide.  The kernel grew quite a number of wq
users and with the number of CPU cores continuously rising, some
systems saturated the default 32k PID space just booting up.

Although MT wq ended up spending a lot of resources, the level of
concurrency provided was unsatisfactory.  The limitation was common to
both ST and MT wq although it was less severe on MT ones.  Worker
pools of wq were separate from each other.  A MT wq provided one
execution context per CPU while a ST wq one for the whole system,
which led to various problems including proneness to deadlocks around
the single execution context and using ST wq when MT wq would fit
better to avoid creating a number of mostly idle threads.

The tension between the provided level of concurrency and resource
usage forced its users to make unnecessary tradeoffs like libata
choosing to use ST wq for polling PIOs and accepting an unnecessary
limitation that no two polling PIOs can progress at the same time.  As
MT wq don't provide much better concurrency, users which require
higher level of concurrency, like async or fscache, ended up having to
implement their own thread pool.

Concurrency Managed Workqueue (cmwq) extends wq with focus on the
following goals.

* Maintain compatibility with the original workqueue API while
  removing the above mentioned limitations and providing flexible
  level of concurrency on demand.

* Provide single unified worker pool per CPU which can be shared by
  all wq users.  The worker pool and level of concurrency should be
  regulated automatically so that the API users don't need to worry
  about such details.

* Use what's necessary and allocate resources lazily on demand while
  guaranteeing forward progress where necessary.


2. The Design

There's a single global cwq (gcwq) per each possible CPU and a pseudo
unbound CPU which actually serves out execution contexts.
cpu_workqueue's (cwq) of each wq are mostly simple frontends to the
associated gcwq.  When a work is queued, it's queued to the common
worklist of the target gcwq.  Each gcwq has its own pool of workers
which is used to process its unified worklist.

For any worker pool, managing the concurrency level (how many
execution contexts are active) is an important issue.  cmwq tries to
keep the concurrency at minimal but sufficient level.

For each gcwq bound to a specific CPU, concurrency management is
implemented by hooking into the scheduler.  The gcwq is notified
whenever a busy worker wakes up or sleeps and keeps track of the level
of concurrency.  Generally, works aren't supposed to be CPU cycle hogs
and maintaining just enough concurrency to prevent work processing
from stalling is optimal.  As long as there is one or more workers
running or ready to run on the CPU, no new worker is scheduled, but,
when the last running worker blocks, the gcwq immediately schedules a
new worker so that the CPU doesn't sit idle while there are pending
works.

This allows using minimal number of workers without losing execution
bandwidth.  Keeping idle workers around doesn't cost other than the
memory space for kthreads, so cmwq holds onto idle ones for a while
before killing them.

For unbound wq, the above concurrency management doesn't apply and the
unbound gcwq tries to increase the number of execution contexts until
all work items are executing.  The responsibility of regulating
concurrency level is on the users.  There is also a flag to mark bound
wq to ignore the default concurrency management.  Please refer to the
alloc_workqueue() section for details.

Forward progress guarantee relies on that workers can be created when
more execution contexts are necessary, which in turn is guaranteed
through the use of emergency workers.  All wq which might be used in
memory allocation path are required to have an emergency worker which
is reserved for execution of each such wq so that memory allocation
for worker creation doesn't deadlock waiting for execution contexts to
free up.


3. Workqueue Attributes

alloc_workqueue() is the function to allocate a wq.  The original
create_*workqueue() functions are deprecated and scheduled for
removal.  alloc_workqueue() takes three arguments - @name, @flags and
@max_active.  @name is the name of the wq and also used as the name of
the rescuer thread if there is one.

A wq no longer manages execution resources but serves as a domain for
forward progress guarantee, flush and work item attributes.  @flags
and @max_active control how work items are assigned execution
resources, scheduled and executed.

@flags:

 WQ_NON_REENTRANT

	By default, a wq guarantees non-reentrance only on the same
	CPU.  A work may not be executed concurrently on the same CPU
	by multiple workers but is allowed to be executed concurrently
	on multiple CPUs.  This flag makes sure non-reentrance is
	enforced across all the CPUs.  Work items queued to a
	non-reentrant wq are guaranteed to be executed by a single
	worker system-wide at any given time.

 WQ_UNBOUND

	Work items queued to an unbound wq are served by a special
	gcwq which hosts workers which are not bound to any specific
	CPU.  This makes the wq behave as a simple execution context
	provider without concurrency management.  Unbound workers will
	be created as long as there are pending work items and
	resources are available.  This sacrifices locality but is
	useful for the following cases.

	* High fluctuation in the concurrency requirement is expected
          and using bound wq may end up creating large number of
          mostly unused workers across different CPUs as the issuer
          hops through different CPUs.

	* Long running CPU intensive workloads which can be better
          managed by the system scheduler.

 WQ_FREEZEABLE

	A freezeable wq participates in the freeze phase during
	suspend operations.  Work items on the wq are drained and no
	new work item starts execution until thawed.

 WQ_RESCUER

	All wq which might be used in the allocation path _MUST_ have
	this flag set.  This reserves one worker exclusively for the
	execution of this wq under memory pressure.

 WQ_HIGHPRI

	Work items of a highpri wq are queued at the head of the
	worklist of the target gcwq and start execution regardless of
	concurrency level.  In other words, highpri work items will
	always start execution as soon as execution resource is
	available.

	Ordering among highpri work items are preserved - a highpri
	work item queued after another highpri work item will start
	execution after the earlier highpri work item starts.

	Although highpri work items are not held back by other
	runnable work items, they still contribute to the concurrency
	level.  Highpri work items in runnable state will prevent
	non-highpri work items from starting execution.

	This flag is meaningless for unbound wq.

 WQ_CPU_INTENSIVE

	Work items of a CPU intensive wq do not contribute to the
	concurrency level.  Runnable CPU intensive work items will not
	prevent other work items from starting execution.  This is
	useful for per-cpu work items which are expected to hog CPU
	cycles so they are solely regulated by the system scheduler.

	Although CPU intensive work items don't contribute to the
	concurrency level, start of their executions is still
	regulated by the concurrency management and runnable
	non-CPU-intensive work items can delay execution of CPU
	intensive work items.

	This flag is meaningless for unbound wq.

 WQ_HIGHPRI | WQ_CPU_INTENSIVE

	This combination makes the wq avoid interaction with
	concurrency management completely and behave as simple per-CPU
	execution context provider.  Work items queued on a highpri
	CPU-intensive wq start execution as soon as resources are
	available and don't affect execution of other work items.

@max_active:

It determines the maximum number of execution contexts per CPU which
can be assigned to the work items of the wq.  For example, with
@max_active of 16, at most 16 work items can execute per CPU at any
given time.

Currently the maximum value for @max_active is 512 and the default
value used when 0 is specified is 256.  Both are chosen sufficiently
high such that the available concurrency level is not the limiting
factor while providing protection in runaway cases.

The maximum number of active work items of a wq is usually regulated
by the users of the wq, more specifically, by how many work items the
users may queue at the same time.  Unless there is a specific need for
throttling the number of active work items, specifying '0' is
recommended.

Some users depend on the strict execution ordering of ST wq.  The
combination of @max_active of 1 and WQ_UNBOUND is used to achieve this
behavior.  Work items on such wq are always queued to the unbound gcwq
and only one work item can be active at any given time thus achieving
the same ordering property as ST wq.


4. Examples and Pitfalls

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
