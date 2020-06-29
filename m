Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF89C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712BD2072A
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 23:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgF2Xzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:55:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:36356 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgF2Xzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 19:55:42 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 09D6A1A856E;
        Tue, 30 Jun 2020 09:55:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jq3cb-0001AE-C9; Tue, 30 Jun 2020 09:55:33 +1000
Date:   Tue, 30 Jun 2020 09:55:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200629235533.GL2005@dread.disaster.area>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627183042.GK4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=cKUjfnoX7QhgEAzzL2sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 27, 2020 at 08:30:42PM +0200, Peter Zijlstra wrote:
> On Sat, Jun 27, 2020 at 08:32:54AM +1000, Dave Chinner wrote:
> > Observation from the outside:
> > 
> > "However I'm having trouble convincing myself that's actually
> > possible on x86_64.... "
> 
> Using the weaker rules of LKMM (as relevant to Power) I could in fact
> make it happen, the 'problem' is that it's being observed on the much
> stronger x86_64.

Yes, I understand just enough about the LKMM(*) for this statement
to scare the crap out of me. :(

(*) "understand just enough" == write litmus tests to attempt to
validate memory barrier constructs I dream up....

> > Having looked at this code over the past 24 hours and the recent
> > history, I know that understanding it - let alone debugging and
> > fixing problem in it - is way beyond my capabilities.  And I say
> > that as an experienced kernel developer with a pretty good grasp
> > of concurrent programming and a record of implementing a fair
> > number of non-trivial lockless algorithms over the years....
> 
> All in the name of making it go fast, I suppose. It used to be
> much simpler... like much of the kernel.

Yup, and we're creating our own code maintenance nightmare as we go.

> The biggest problem I had with this thing was that the reproduction case
> we had (Paul's rcutorture) wouldn't readily trigger on my machines
> (altough it did, but at a much lower rate, just twice in a week's worth
> of runtime).
> 
> Also; I'm sure you can spot a problem in the I/O layer much faster than
> I possibly could :-)

Sure, but that misses the point I was making.

I regularly have to look deep into other subsystems to work out what
problem the filesystem is tripping over. I'm regularly
looking into parts of the IO stack, memory management, page
allocators, locking and atomics, workqueues, the scheduler, etc
because XFS makes extensive (and complex) use of the infrastructure
they provide. That means to debug filesystem issues, I have to be
able to understand what that infrastructure is trying to do and make
judgements as to whether that code behaving correctly or not.

And so when I find a reproducer for a bug that takes 20s to
reproduce and it points me at code that I honestily have no hope of
understanding well enough to determine if it is working correctly or
not, then we have a problem.  A lot of my time is spent doing root
cause analysis proving that such issues are -not- filesystem
problems (they just had "xfs" in the stack trace), hence being able
to read and understand the code in related core subsystems is
extremely important to performing my day job.

If more kernel code falls off the memory barrier cliff like this,
then the ability of people like me to find the root cause of complex
issues is going to be massively reduced. Writing code so smart that
almost no-one else can understand has always been a bad thing, and
memory barriers only make this problem worse... :(

> Anyway, let me know if you still observe any problems.

Seems to be solid so far. Thanks Peter!

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
