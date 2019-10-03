Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20A0C10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B30215EA
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 14:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbfJCOlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 10:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbfJCOlR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Oct 2019 10:41:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0391105787F;
        Thu,  3 Oct 2019 14:41:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96ACF1001956;
        Thu,  3 Oct 2019 14:41:16 +0000 (UTC)
Date:   Thu, 3 Oct 2019 10:41:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191003144114.GB2105@bfoster>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
 <20191002124139.GB2403@bfoster>
 <20191003012556.GW16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003012556.GW16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 03 Oct 2019 14:41:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 11:25:56AM +1000, Dave Chinner wrote:
> On Wed, Oct 02, 2019 at 08:41:39AM -0400, Brian Foster wrote:
> > On Wed, Oct 02, 2019 at 09:14:33AM +1000, Dave Chinner wrote:
> > > On Tue, Oct 01, 2019 at 09:13:36AM -0400, Brian Foster wrote:
> > > > On Tue, Oct 01, 2019 at 01:42:07PM +1000, Dave Chinner wrote:
> > > > > So typically groups of captures are hundreds of log cycles apart
> > > > > (100 cycles x 32MB = ~3GB of log writes), then there will be a
> > > > > stutter where the CIL dispatch is delayed, and then everything
> > > > > continues on. These all show the log is always around the 75% full
> > > > > (AIL tail pushing theshold) but the reservation grant wait lists are
> > > > > always empty so we're not running out of reservation space here.
> > > > > 
> > > > 
> > > > It's somewhat interesting that we manage to block every thread most of
> > > > the time before the CIL push task starts. I wonder a bit if that pattern
> > > > would hold for a system/workload with more CPUs (and if so, if there are
> > > > any odd side effects of stalling and waking hundreds of tasks at the
> > > > same time vs. our traditional queuing behavior).
> > > 
> > > If I increase the concurrency (e.g. 16->32 threads for fsmark on a
> > > 64MB log), we hammer the spinlock on the grant head -hard-. i.e. CPU
> > > usage goes up by 40%, performance goes down by 50%, and all that CPU
> > > time is spent spinning on the reserve grant head lock. Basically,
> > > the log reservation space runs out, and we end up queuing on the
> > > reservation grant head and then we get reminded of just how bad
> > > having a serialisation point in the reservation fast path actually
> > > is for scalability...
> > > 
> > 
> > The small log case is not really what I'm wondering about. Does this
> > behavior translate to a similar test with a maximum sized log?
> 
> Nope, the transactions all hit the CIL throttle within a couple of
> hundred microseconds of each other, then the CIL push schedules, and
> then a couple of hundred microseconds later they are unblocked
> because the CIL push has started.
> 
> > ...
> > > 
> > > Larger logs block more threads on the CIL throttle, but the 32MB CIL
> > > window can soak up hundreds of max sized transaction reservations
> > > before overflowing so even running several hundred concurrent
> > > modification threads I haven't been able to drive enough concurrency
> > > through the CIL to see any sort of adverse behaviour.  And the
> > > workloads are running pretty consistently at less than 5,000 context
> > > switches/sec so there's no evidence of repeated thundering heard
> > > wakeup problems, either.
> > > 
> > 
> > That speaks to the rarity of the throttle, which is good. But I'm
> > wondering, for example, what might happen on systems where we could have
> > hundreds of physical CPUs committing to the CIL, we block them all on
> > the throttle and then wake them all at once. IOW, can we potentially
> > create the contention conditions you reproduce above in scenarios where
> > they might not have existed before?
> 
> I don't think it will create any new contention points - the
> contention I described above can be triggered without the CIL
> throttle in place, too. It just requires enough concurrent
> transactions to exhaust the entire log reservation, and then we go
> from a lockless grant head reservation algorithm to a spinlock
> serialised waiting algorithm.  i.e. the contention starts when we
> have enough concurrency to fall off the lockless fast path.
> 
> So with a 2GB log and fast storage, we likely need a sustained
> workload of tens of thousands of concurrent transaction reservations
> to exhaust log space and drive us into this situation. We generally
> don't have applications that have this sort of concurrency
> capability...
> 

That there are some systems/configurations out there that are fast
enough to avoid this condition doesn't really answer the question. If
you assume something like a 1TB fs and 500MB log, with 1/4 the log
consumed in the AIL and 64MB in the CIL (such that transaction commits
start to block), the remaining log reservation can easily be consumed by
something on the order of 100 open transactions.

Hmm, I'm also not sure the lockless reservation algorithm is totally
immune to increased concurrency in this regard. What prevents multiple
tasks from racing through xlog_grant_head_check() and blowing past the
log head, for example?

I gave this a quick test out of curiosity and with a 15GB fs with a 10MB
log, I should only be able to send 5 or so truncate transactions through
xfs_log_reserve() before blocking. With a couple injected delays, I'm
easily able to send 32 into the grant space modification code and that
eventually results in something like this:

  truncate-1233  [002] ...1  1520.396545: xfs_log_reserve_exit: dev 253:4 t_ocnt 8 t_cnt 8 t_curr_res 266260 t_unit_res 266260 t_flags XLOG_TIC_INITED|XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 7 grant_reserve_bytes 5306880 grant_write_cycle 7 grant_write_bytes 5306880 curr_cycle 1 curr_block 115 tail_cycle 1 tail_block 115

... where the grant heads have not only blown the tail, but cycled
around the log multiple times. :/

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
