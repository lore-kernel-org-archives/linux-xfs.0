Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68541C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B72F64FE7
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCJGMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 01:12:21 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:35712 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhCJGL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 01:11:56 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 80DCE107900;
        Wed, 10 Mar 2021 17:11:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJs4V-000nT8-4Z; Wed, 10 Mar 2021 17:11:51 +1100
Date:   Wed, 10 Mar 2021 17:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/45] xfs: CIL work is serialised, not pipelined
Message-ID: <20210310061151.GF74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-16-david@fromorbit.com>
 <20210308231432.GD3419940@magnolia>
 <20210308233819.GA74031@dread.disaster.area>
 <20210309015540.GY7269@magnolia>
 <87ft14t0ox.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft14t0ox.fsf@linux.intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=eJfxgxciAAAA:8
        a=7-415B0cAAAA:8 a=NvfcQ1G7Lb4BHcPeJL8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=xM9caqqi1sUkTy8OJ5Uh:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 02:35:42PM -0800, Andi Kleen wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> > It might be nice to leave that as a breadcrumb, then, in case the
> > spinlock scalability problems ever get solved.
> 
> It might be already solved, depending on if Dave's rule of thumb
> was determined before the Linux spinlocks switched to MCS locks or not.

It's what I see on my current 2-socket, 32p/64t machine with a
handful of optane DC4800 SSDs attached to it running 5.12-rc1+.  MCS
doesn't make spin contention go away, just stops spinlocks from
bouncing the same cacheline all over the machine.

i.e. if you've got more than a single CPU's worth of critical
section to execute, then spinlocks are going to spin, not matter how
they are implemented. So AFAICT the contention I'm measuring is not
cacheline bouncing, but just the cost of multiple CPUs
spinning while queued waiting for the spinlock...

> In my experience spinlock scalability depends a lot on how long the
> critical section is (that is very important, short sections are a lot
> worse than long sections), as well as if the contention is inside a
> socket or over sockets, and the actual hardware behaves differently too.

Yup, and most of the critical sections that the icloglock is used
to protect are quite short.

> So I would be quite surprised if the "rule of 4" generally holds.

It's served me well for the past couple of decades, especially when
working with machines that have thousands of CPUs that can turn even
lightly trafficed spin locks into highly contended locks. That was
the lesson I learnt from this commit:

commit 249a8c1124653fa90f3a3afff869095a31bc229f
Author: David Chinner <dgc@sgi.com>
Date:   Tue Feb 5 12:13:32 2008 +1100

    [XFS] Move AIL pushing into it's own thread
    
    When many hundreds to thousands of threads all try to do simultaneous
    transactions and the log is in a tail-pushing situation (i.e. full), we
    can get multiple threads walking the AIL list and contending on the AIL
    lock.
 
Getting half a dozen simultaneous AIL pushes, and the AIL spinlock
would break down and burn an entire 2048p machine for half a day
doing what should only take half a second. Unbound concurrency
-always- finds spinlocks to contend on. And if the machine is large
enough, it will then block up the entire machine as more and more
CPUs hit the serialisation point.

As long as I've worked with 500+ cpu machines (since 2002),
scalability has always been about either removing spinlocks from
hot paths or controlling concurrency to a level below where a
spinlock breaks down. You see it again and again in XFS commit logs
where I've either changed something to be lockless or to strictly
constrain concurrency to be less than 4-8p across known hot and/or
contended spinlocks and mutexes.

And I've used it outside XFS, too. It was the basic concept behind
the NUMA aware shrinker infrastructure and the per-node LRU lists
that it uses. Even the internal spinlocks on those lists start to
break down when bashing on the inode and dentry caches on systems
with per-node CPU counts of 8-16...

Oh, another "rule of 4" I came across a couple of days ago. My test
machine has 4 node, so 4 kswapd threads. One buffered IO reader,
running 100% cpu bound at 2GB/s from a 6GB/s capable block device.
The reader was burning 12% of that CPU on the mapping spinlock
insert pages into the page cache..  The kswapds were each burning
12% of a CPU on the same mapping spinlock reclaiming page cache
pages. So, overall, the system was burning over 50% of a CPU
spinning on the mapping spinlock and really only doing about half a
CPU worth of real work.

Same workload with one kswapd (i.e. single node)? Contention on the
mapping lock is barely measurable.  IOws, at just 5 concurrent
threads doing repeated fast accesses to the inode mapping spinlock
we have reached lock breakdown conditions.

Perhaps we should consider spinlocks harmful these days...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
