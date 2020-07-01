Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D75C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 02:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2D32074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 02:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGAC0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 22:26:53 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36016 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgGAC0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 22:26:53 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7FA713A4123;
        Wed,  1 Jul 2020 12:26:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqSSU-000246-KP; Wed, 01 Jul 2020 12:26:46 +1000
Date:   Wed, 1 Jul 2020 12:26:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200701022646.GO2005@dread.disaster.area>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
 <20200629235533.GL2005@dread.disaster.area>
 <20200630085732.GT4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630085732.GT4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=WyWJDwBIb6W5-FMhlnsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 10:57:32AM +0200, Peter Zijlstra wrote:
> On Tue, Jun 30, 2020 at 09:55:33AM +1000, Dave Chinner wrote:
> > Sure, but that misses the point I was making.
> > 
> > I regularly have to look deep into other subsystems to work out what
> > problem the filesystem is tripping over. I'm regularly
> > looking into parts of the IO stack, memory management, page
> > allocators, locking and atomics, workqueues, the scheduler, etc
> > because XFS makes extensive (and complex) use of the infrastructure
> > they provide. That means to debug filesystem issues, I have to be
> > able to understand what that infrastructure is trying to do and make
> > judgements as to whether that code behaving correctly or not.
> > 
> > And so when I find a reproducer for a bug that takes 20s to
> > reproduce and it points me at code that I honestily have no hope of
> 
> 20s would've been nice to have a week and a half ago, the reproduce I
> debugged this with took days to trigger.. a well, such is life.
> 
> > understanding well enough to determine if it is working correctly or
> > not, then we have a problem.  A lot of my time is spent doing root
> > cause analysis proving that such issues are -not- filesystem
> > problems (they just had "xfs" in the stack trace), hence being able
> > to read and understand the code in related core subsystems is
> > extremely important to performing my day job.
> > 
> > If more kernel code falls off the memory barrier cliff like this,
> > then the ability of people like me to find the root cause of complex
> > issues is going to be massively reduced. Writing code so smart that
> > almost no-one else can understand has always been a bad thing, and
> > memory barriers only make this problem worse... :(
> 
> How about you try and give me a hint about where you gave up and I'll
> try and write better comments?

Hard to explain. Background: we (XFS developers) got badly burnt a
few years back by memory barrier bugs in rwsems that we could not
prove were memory barrier bugs in rwsems as instrumentation made
them go away. But they were most definitely bugs in rwsems that the
maintainers said could not exist. While I could read the the rwsem
code and understand how it was supposed to work, identifying the
missing memory barrier in the code was beyond my capability. It was
also beyond the capability of the people who wrote the code, too.

As such, I'm extremely sceptical that maintainers actually
understand their complex ordering constructs as well as they think
they do, and your comments about "can't explain how it can happen on
x86-64" do nothing but re-inforce my scepticism.

To your specific question: I gave up looking at the code when I
realised I had no idea what the relationships between objects and
logic that the memory barriers were ordering against, nor what
fields within objects were protected by locks, acquire/release
depedencies, explicit memory barriers, some combination of all
three or even something subtle enough that I hadn't noticed yet.

Yes, the code explains the ordering constraints between
object A and object B, but there's nothing to to actually explain
what, say, p->on_cpu means, what it's valid states are, when teh
different values mean, and how it relates to, say, p->on_rq...

e.g. take this comment in ttwu:

       /*
         * Ensure we load p->on_rq _after_ p->state, otherwise it would
         * be possible to, falsely, observe p->on_rq == 0 and get stuck
         * in smp_cond_load_acquire() below.
         *
         * sched_ttwu_pending()                 try_to_wake_up()
         *   STORE p->on_rq = 1                   LOAD p->state
         *   UNLOCK rq->lock
         *
         * __schedule() (switch to task 'p')
         *   LOCK rq->lock                        smp_rmb();
         *   smp_mb__after_spinlock();
         *   UNLOCK rq->lock
         *
         * [task p]
         *   STORE p->state = UNINTERRUPTIBLE     LOAD p->on_rq
         *
         * Pairs with the LOCK+smp_mb__after_spinlock() on rq->lock in
         * __schedule().  See the comment for smp_mb__after_spinlock().
         *
         * A similar smb_rmb() lives in try_invoke_on_locked_down_task().
         */
        smp_rmb();

The comment explains -what the code is ordering against-. I
understand that this is a modified message passing pattern that
requires explicit memory barriers because there isn't a direct
release/acquire relationship between store and load of the different
objects.

I then spent an hour learning about smp_cond_load_acquire() because this
is the first time I'd seen that construct and I had no idea what it did.
But then I understood what that specific set of ordering constraints
actually does.

And then I completely didn't understand this code, because the code
the comment references is this:

	smp_cond_load_acquire(&p->on_cpu, !VAL);

that's *on_cpu* that the load is being done from, but the comment
that references the load_acquire is talking about ordering *on_rq*
against p->state.

So after thinking I understood what the code is doing, I realise
either the comment is wrong or *I don't have a clue what this code
is doing*. And that I have no way of finding out which it might be
from looking at the code.

Contrast that to code that just uses basic locks.

Putting the little pieces of critical sections together is
relatively straight forward to do. The code inside the locks is what
is being serialised and memory barriers are unlock-to-lock, and so
assumptions about how entire objects interact can be made and in
general they are going to be valid because critical sections are
straight forward and obvious.

For more complex locking constructs - nesting of locks, different
locks protecting different parts of the same objects, etc , we end
up documenting what fields in major objects are protected by which
lock and what order the locks nest in. e.g. in fs/inode.c:

/*
 * Inode locking rules:
 *
 * inode->i_lock protects:
 *   inode->i_state, inode->i_hash, __iget()
 * Inode LRU list locks protect:
 *   inode->i_sb->s_inode_lru, inode->i_lru
 * inode->i_sb->s_inode_list_lock protects:
 *   inode->i_sb->s_inodes, inode->i_sb_list
 * bdi->wb.list_lock protects:
 *   bdi->wb.b_{dirty,io,more_io,dirty_time}, inode->i_io_list
 * inode_hash_lock protects:
 *   inode_hashtable, inode->i_hash
 *
 * Lock ordering:
 *
 * inode->i_sb->s_inode_list_lock
 *   inode->i_lock
 *     Inode LRU list locks
 *
 * bdi->wb.list_lock
 *   inode->i_lock
 *
 * inode_hash_lock
 *   inode->i_sb->s_inode_list_lock
 *   inode->i_lock
 *
 * iunique_lock
 *   inode_hash_lock
 */

There's nothing like this in the scheduler code that I can find that
explains the expected overall ordering/serialisation mechanisms and
relationships used in the subsystem. Hence when I comes across
something that doesn't appear to make sense, there's nothign I can
refer to that would explain whether it is a bug or whether the
comment is wrong or whether I've just completely misunderstood what
the comment is referring to.

Put simply: the little details are great, but they aren't sufficient
by themselves to understand the relationships being maintained
between the various objects.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
