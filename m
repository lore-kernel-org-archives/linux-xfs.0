Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 412A17F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 14:30:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD4DBAC003
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 12:30:30 -0700 (PDT)
Received: from flmx07.ccur.com (flmx07.ccur.com [173.221.59.12]) by
	cuda.sgi.com with ESMTP id Fu7ZhRjF5fj8R139 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 12:30:25 -0700 (PDT)
Message-ID: <537CFECF.9070701@ccur.com>
Date: Wed, 21 May 2014 14:30:23 -0500
From: John Blackwood <john.blackwood@ccur.com>
MIME-Version: 1.0
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
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
To: Richard Weinberger <richard.weinberger@gmail.com>, Austin Schuh <austin@peloton-tech.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

 > Date: Wed, 21 May 2014 03:33:49 -0400
 > From: Richard Weinberger <richard.weinberger@gmail.com>
 > To: Austin Schuh <austin@peloton-tech.com>
 > CC: LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, rt-users
 > 	<linux-rt-users@vger.kernel.org>
 > Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
 >
 > CC'ing RT folks
 >
 > On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com> wrote:
 > > > On Tue, May 13, 2014 at 7:29 PM, Austin Schuh <austin@peloton-tech.com> wrote:
 > >> >> Hi,
 > >> >>
 > >> >> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
 > >> >> patched kernel.  I have currently only triggered it using dpkg.  Dave
 > >> >> Chinner on the XFS mailing list suggested that it was a rt-kernel
 > >> >> workqueue issue as opposed to a XFS problem after looking at the
 > >> >> kernel messages.
 > >> >>
 > >> >> The only modification to the kernel besides the RT patch is that I
 > >> >> have applied tglx's "genirq: Sanitize spurious interrupt detection of
 > >> >> threaded irqs" patch.
 > > >
 > > > I upgraded to 3.14.3-rt4, and the problem still persists.
 > > >
 > > > I turned on event tracing and tracked it down further.  I'm able to
 > > > lock it up by scping a new kernel debian package to /tmp/ on the
 > > > machine.  scp is locking the inode, and then scheduling
 > > > xfs_bmapi_allocate_worker in the work queue.  The work then never gets
 > > > run.  The kworkers then lock up waiting for the inode lock.
 > > >
 > > > Here are the relevant events from the trace.  ffff8803e9f10288
 > > > (blk_delay_work) gets run later on in the trace, but ffff8803b4c158d0
 > > > (xfs_bmapi_allocate_worker) never does.  The kernel then warns about
 > > > blocked tasks 120 seconds later.

Austin and Richard,

I'm not 100% sure that the patch below will fix your problem, but we
saw something that sounds pretty familiar to your issue involving the
nvidia driver and the preempt-rt patch.  The nvidia driver uses the
completion support to create their own driver's notion of an internally
used semaphore.

Some tasks were failing to ever wakeup from wait_for_completion() calls
due to a race in the underlying do_wait_for_common() routine.

This is the patch that we used to fix this issue:

------------------- -------------------

Fix a race in the PRT wait for completion simple wait code.

A wait_for_completion() waiter task can be awoken by a task calling
complete(), but fail to consume the 'done' completion resource if it
looses a race with another task calling wait_for_completion() just as
it is waking up.

In this case, the awoken task will call schedule_timeout() again
without being in the simple wait queue.

So if the awoken task is unable to claim the 'done' completion resource,
check to see if it needs to be re-inserted into the wait list before
waiting again in schedule_timeout().

Fix-by: John Blackwood <john.blackwood@ccur.com>
Index: b/kernel/sched/core.c
===================================================================
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3529,11 +3529,19 @@ static inline long __sched
  do_wait_for_common(struct completion *x,
  		   long (*action)(long), long timeout, int state)
  {
+	int again = 0;
+
  	if (!x->done) {
  		DEFINE_SWAITER(wait);

  		swait_prepare_locked(&x->wait, &wait);
  		do {
+			/* Check to see if we lost race for 'done' and are
+			 * no longer in the wait list.
+			 */
+			if (unlikely(again) && list_empty(&wait.node))
+				swait_prepare_locked(&x->wait, &wait);
+
  			if (signal_pending_state(state, current)) {
  				timeout = -ERESTARTSYS;
  				break;
@@ -3542,6 +3550,7 @@ do_wait_for_common(struct completion *x,
  			raw_spin_unlock_irq(&x->wait.lock);
  			timeout = action(timeout);
  			raw_spin_lock_irq(&x->wait.lock);
+			again = 1;
  		} while (!x->done && timeout);
  		swait_finish_locked(&x->wait, &wait);
  		if (!x->done)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
