Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA50C10F14
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 02:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD492086A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 02:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbfJDC2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 22:28:01 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33879 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731522AbfJDC2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 22:28:01 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8EE1243E1F1;
        Fri,  4 Oct 2019 12:27:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iGDJz-0001gr-Ag; Fri, 04 Oct 2019 12:27:55 +1000
Date:   Fri, 4 Oct 2019 12:27:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191004022755.GY16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
 <20191002124139.GB2403@bfoster>
 <20191003012556.GW16973@dread.disaster.area>
 <20191003144114.GB2105@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003144114.GB2105@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=f0_rMKWd_Tumdud9jP4A:9 a=g8HaRn-OtdQ6JnFh:21
        a=7FFscznymeYou2k6:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 10:41:14AM -0400, Brian Foster wrote:
> On Thu, Oct 03, 2019 at 11:25:56AM +1000, Dave Chinner wrote:
> > On Wed, Oct 02, 2019 at 08:41:39AM -0400, Brian Foster wrote:
> > > On Wed, Oct 02, 2019 at 09:14:33AM +1000, Dave Chinner wrote:
> > > > On Tue, Oct 01, 2019 at 09:13:36AM -0400, Brian Foster wrote:
> > > > > On Tue, Oct 01, 2019 at 01:42:07PM +1000, Dave Chinner wrote:
> > > > > > So typically groups of captures are hundreds of log cycles apart
> > > > > > (100 cycles x 32MB = ~3GB of log writes), then there will be a
> > > > > > stutter where the CIL dispatch is delayed, and then everything
> > > > > > continues on. These all show the log is always around the 75% full
> > > > > > (AIL tail pushing theshold) but the reservation grant wait lists are
> > > > > > always empty so we're not running out of reservation space here.
> > > > > > 
> > > > > 
> > > > > It's somewhat interesting that we manage to block every thread most of
> > > > > the time before the CIL push task starts. I wonder a bit if that pattern
> > > > > would hold for a system/workload with more CPUs (and if so, if there are
> > > > > any odd side effects of stalling and waking hundreds of tasks at the
> > > > > same time vs. our traditional queuing behavior).
> > > > 
> > > > If I increase the concurrency (e.g. 16->32 threads for fsmark on a
> > > > 64MB log), we hammer the spinlock on the grant head -hard-. i.e. CPU
> > > > usage goes up by 40%, performance goes down by 50%, and all that CPU
> > > > time is spent spinning on the reserve grant head lock. Basically,
> > > > the log reservation space runs out, and we end up queuing on the
> > > > reservation grant head and then we get reminded of just how bad
> > > > having a serialisation point in the reservation fast path actually
> > > > is for scalability...
> > > > 
> > > 
> > > The small log case is not really what I'm wondering about. Does this
> > > behavior translate to a similar test with a maximum sized log?
> > 
> > Nope, the transactions all hit the CIL throttle within a couple of
> > hundred microseconds of each other, then the CIL push schedules, and
> > then a couple of hundred microseconds later they are unblocked
> > because the CIL push has started.
> > 
> > > ...
> > > > 
> > > > Larger logs block more threads on the CIL throttle, but the 32MB CIL
> > > > window can soak up hundreds of max sized transaction reservations
> > > > before overflowing so even running several hundred concurrent
> > > > modification threads I haven't been able to drive enough concurrency
> > > > through the CIL to see any sort of adverse behaviour.  And the
> > > > workloads are running pretty consistently at less than 5,000 context
> > > > switches/sec so there's no evidence of repeated thundering heard
> > > > wakeup problems, either.
> > > > 
> > > 
> > > That speaks to the rarity of the throttle, which is good. But I'm
> > > wondering, for example, what might happen on systems where we could have
> > > hundreds of physical CPUs committing to the CIL, we block them all on
> > > the throttle and then wake them all at once. IOW, can we potentially
> > > create the contention conditions you reproduce above in scenarios where
> > > they might not have existed before?
> > 
> > I don't think it will create any new contention points - the
> > contention I described above can be triggered without the CIL
> > throttle in place, too. It just requires enough concurrent
> > transactions to exhaust the entire log reservation, and then we go
> > from a lockless grant head reservation algorithm to a spinlock
> > serialised waiting algorithm.  i.e. the contention starts when we
> > have enough concurrency to fall off the lockless fast path.
> > 
> > So with a 2GB log and fast storage, we likely need a sustained
> > workload of tens of thousands of concurrent transaction reservations
> > to exhaust log space and drive us into this situation. We generally
> > don't have applications that have this sort of concurrency
> > capability...
> > 
> 
> That there are some systems/configurations out there that are fast
> enough to avoid this condition doesn't really answer the question. If
> you assume something like a 1TB fs and 500MB log, with 1/4 the log
> consumed in the AIL and 64MB in the CIL (such that transaction commits
> start to block), the remaining log reservation can easily be consumed by
> something on the order of 100 open transactions.

If individual reservations in in the order of 3MB on a 4kB
filesystem, then we've screwed reservations up really badly.

/me goes looking

Reservation sizes for 1TB AGs and reflink enabled show:

 xfs_trans_resv_calc:  dev 253:32 type 0 logres 201976 logcount 8 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 1 logres 361344 logcount 8 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 2 logres 307936 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 3 logres 187760 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 4 logres 197760 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 5 logres 303616 logcount 3 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 6 logres 302464 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 7 logres 319488 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 8 logres 302464 logcount 3 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 9 logres 337784 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 10 logres 2168 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 11 logres 90624 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 12 logres 116856 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 13 logres 760 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 14 logres 360576 logcount 1 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 15 logres 23288 logcount 3 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 16 logres 13312 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 17 logres 181376 logcount 3 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 18 logres 640 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 19 logres 111864 logcount 2 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 20 logres 4224 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 21 logres 6512 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 22 logres 232 logcount 1 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 23 logres 206199 logcount 8 flags 0x4
 xfs_trans_resv_calc:  dev 253:32 type 24 logres 976 logcount 1 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 25 logres 336 logcount 1 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 26 logres 640 logcount 1 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type 27 logres 760 logcount 0 flags 0x0
 xfs_trans_resv_calc:  dev 253:32 type -1 logres 361344 logcount 8 flags 0x4

Oh, wow, those are actually massive. A write reservation should
not need a 200kB reservation - it used to be in the order of 100kB
and with a log count of 3. And that truncate reservation @ 360kB is
way more than it needs to be.

I'm going to have a deeper look into this, because I strongly
suspect we've screwed things up here with respect to rmap/reflink
and deferred ops.

> Hmm, I'm also not sure the lockless reservation algorithm is totally
> immune to increased concurrency in this regard. What prevents multiple
> tasks from racing through xlog_grant_head_check() and blowing past the
> log head, for example?

Nothing. Debug kernels even emit a "xlog_verify_grant_tail: space >
BBTOB(tail_blocks)" messages when that happens. It's pretty
difficult to do this in real world conditions, even when there is
lots of concurrency being used.

But here's the rub: it's not actually the end of the world because
the reservation doesn't actually determine how much of the log is
currently being used by running transactions - the reservation is
for a maximal rolling iteration of a permanent transaction, not the
initial transaction will be running. Hence if we overrun
occassionally we don't immediately run out of log space and corrupt
the log.

Yes, if none of the rolling transactions complete and they all need
to use their entire reservation, and the tail of the log cannot be
moved forward because it is pinned by one of the transactions that
is running, then we'll likely get a log hang on a regrant on the
write head. But if any of the transactions don't use all of their
reservation, then the overrun gets soaked up by the unused parts of
the transactions that are completed and returned to reservation
head, and nobody even notices taht there was a temporary overrun of
the grant head space.

Hence occasional overruns on the reservation head before they start
blocking isn't really a problem in practice because the probability
of all the transaction reservation of all transactions running being
required to make forwards progress is extremely small.

Basically, we gave up "perfect reservation space grant accounting"
because performance was extremely important and risk of log hangs as
a result of overruns was considered to be extremely low and worth
taking for the benefits the algorithm provided. This was just a
simple, pragmatic risk based engineering decision.

> I gave this a quick test out of curiosity and with a 15GB fs with a 10MB
> log, I should only be able to send 5 or so truncate transactions through
> xfs_log_reserve() before blocking. With a couple injected delays, I'm
> easily able to send 32 into the grant space modification code and that
> eventually results in something like this:

Yup, we can break lots of things by injecting artificial delays, but
that doesn't mean there is a practical real world problem with the
algorithm we need to fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
