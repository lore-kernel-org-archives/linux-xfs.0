Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o888JpL4022242 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 03:19:51 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B82F31B3461A
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 01:20:35 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id Jyca1CcovllmlC7J for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 01:20:35 -0700 (PDT)
Message-ID: <4C87474B.3050405@kernel.org>
Date: Wed, 08 Sep 2010 10:20:27 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org>
	<20100908073428.GR705@dastard>
In-Reply-To: <20100908073428.GR705@dastard>
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

On 09/08/2010 09:34 AM, Dave Chinner wrote:
>> I see.  The use case itself shouldn't be problematic at all for cmwq
>> (sans bugs of course).  In the other reply, you said "the system is
>> 100% unresponsive when the livelock occurs", which is kind of
>> puzzling.  It isn't really a livelock.
> 
> Actually, it is. You don't need to burn CPU to livelock, you just
> need a loop in the state machine that cannot be broken by internal
> or external events to be considered livelocked.

Yeah, but for the system to be completely unresponsive even to sysrq,
the system needs to be live/dead locked in a pretty specific way.

> However, this is not what I was calling the livelock problem - this
> is what I was calling the deadlock problem because to all external
> appearences the state machine is deadlocked on the inode lock....
> 
> The livelock case I described where the system is completely
> unresponsive is the one I'm testing the WQ_HIGHPRI mod against.
> 
> FWIW, having considered the above case again, and seeing what the
> WQ_HIGHPRI mod does in terms of queuing, I think that it may also
> solve this deadlock as the log IO completionwill always be queued
> ahead of the data IO completion now.

Cool, but please keep in mind that the nr_active underflow bug may end
up stalling or loosening ordering rules for a workqueue.  Linus has
pulled in the pending fixes today.

>> Hmm... The point where I'm confused is that *delay()'s are busy waits.
>> They burn CPU cycles.  I suppose you're referring to *sleep()'s,
>> right?
> 
> fs/xfs/linux-2.6/time.h:
> 
> static inline void delay(long ticks)
> {
>         schedule_timeout_uninterruptible(ticks);
> }

Heh yeah, there's my confusion.

>> Probably I have overloaded the term 'concurrency' too much.  In this
>> case, I meant the number of workers assigned to work items of the wq.
>> If you fire off N work items which sleep at the same time, cmwq will
>> eventually try to create N workers as each previous worker goes to
>> sleep so that the CPU doesn't sit idle while there are work items to
>> process as long as N < @wq->nr->active.
> 
> Ok, so if I queue N items on a single CPU when max_active == N, they
> get spread across N worker threads on different CPUs? 

They may if necessary to keep the workqueue progressing.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
