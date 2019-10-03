Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129F2C4360C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF2221A4C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 01:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbfJCB0A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 21:26:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58577 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbfJCB0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Oct 2019 21:26:00 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2BA1043EA26;
        Thu,  3 Oct 2019 11:25:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iFpsS-0000nq-Ck; Thu, 03 Oct 2019 11:25:56 +1000
Date:   Thu, 3 Oct 2019 11:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191003012556.GW16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
 <20191002124139.GB2403@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002124139.GB2403@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=lxT9QNEntwGXYUcq0cgA:9 a=yNv5lPnGkZmJUYOC:21
        a=ZH54lDfDm8s7Jslu:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 02, 2019 at 08:41:39AM -0400, Brian Foster wrote:
> On Wed, Oct 02, 2019 at 09:14:33AM +1000, Dave Chinner wrote:
> > On Tue, Oct 01, 2019 at 09:13:36AM -0400, Brian Foster wrote:
> > > On Tue, Oct 01, 2019 at 01:42:07PM +1000, Dave Chinner wrote:
> > > > So typically groups of captures are hundreds of log cycles apart
> > > > (100 cycles x 32MB = ~3GB of log writes), then there will be a
> > > > stutter where the CIL dispatch is delayed, and then everything
> > > > continues on. These all show the log is always around the 75% full
> > > > (AIL tail pushing theshold) but the reservation grant wait lists are
> > > > always empty so we're not running out of reservation space here.
> > > > 
> > > 
> > > It's somewhat interesting that we manage to block every thread most of
> > > the time before the CIL push task starts. I wonder a bit if that pattern
> > > would hold for a system/workload with more CPUs (and if so, if there are
> > > any odd side effects of stalling and waking hundreds of tasks at the
> > > same time vs. our traditional queuing behavior).
> > 
> > If I increase the concurrency (e.g. 16->32 threads for fsmark on a
> > 64MB log), we hammer the spinlock on the grant head -hard-. i.e. CPU
> > usage goes up by 40%, performance goes down by 50%, and all that CPU
> > time is spent spinning on the reserve grant head lock. Basically,
> > the log reservation space runs out, and we end up queuing on the
> > reservation grant head and then we get reminded of just how bad
> > having a serialisation point in the reservation fast path actually
> > is for scalability...
> > 
> 
> The small log case is not really what I'm wondering about. Does this
> behavior translate to a similar test with a maximum sized log?

Nope, the transactions all hit the CIL throttle within a couple of
hundred microseconds of each other, then the CIL push schedules, and
then a couple of hundred microseconds later they are unblocked
because the CIL push has started.

> ...
> > 
> > Larger logs block more threads on the CIL throttle, but the 32MB CIL
> > window can soak up hundreds of max sized transaction reservations
> > before overflowing so even running several hundred concurrent
> > modification threads I haven't been able to drive enough concurrency
> > through the CIL to see any sort of adverse behaviour.  And the
> > workloads are running pretty consistently at less than 5,000 context
> > switches/sec so there's no evidence of repeated thundering heard
> > wakeup problems, either.
> > 
> 
> That speaks to the rarity of the throttle, which is good. But I'm
> wondering, for example, what might happen on systems where we could have
> hundreds of physical CPUs committing to the CIL, we block them all on
> the throttle and then wake them all at once. IOW, can we potentially
> create the contention conditions you reproduce above in scenarios where
> they might not have existed before?

I don't think it will create any new contention points - the
contention I described above can be triggered without the CIL
throttle in place, too. It just requires enough concurrent
transactions to exhaust the entire log reservation, and then we go
from a lockless grant head reservation algorithm to a spinlock
serialised waiting algorithm.  i.e. the contention starts when we
have enough concurrency to fall off the lockless fast path.

So with a 2GB log and fast storage, we likely need a sustained
workload of tens of thousands of concurrent transaction reservations
to exhaust log space and drive us into this situation. We generally
don't have applications that have this sort of concurrency
capability...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
