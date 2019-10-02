Return-Path: <SRS0=zZKn=X3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26FCC352AA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 12:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2DC121A4C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 12:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfJBMlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 08:41:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfJBMlm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Oct 2019 08:41:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBF278A1C96;
        Wed,  2 Oct 2019 12:41:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 646996013A;
        Wed,  2 Oct 2019 12:41:41 +0000 (UTC)
Date:   Wed, 2 Oct 2019 08:41:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191002124139.GB2403@bfoster>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
 <20191001231433.GU16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001231433.GU16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 02 Oct 2019 12:41:41 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 02, 2019 at 09:14:33AM +1000, Dave Chinner wrote:
> On Tue, Oct 01, 2019 at 09:13:36AM -0400, Brian Foster wrote:
> > On Tue, Oct 01, 2019 at 01:42:07PM +1000, Dave Chinner wrote:
> > > On Tue, Oct 01, 2019 at 07:53:36AM +1000, Dave Chinner wrote:
> > > > On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> > > > > Have you done similar testing for small/minimum sized logs?
> > > > 
> > > > Yes. I've had the tracepoint active during xfstests runs on test
> > > > filesystems using default log sizes on 5-15GB filesystems. The only
> > > > test in all of xfstests that has triggered it is generic/017, and it
> > > > only triggered once.
> > > > 
> > > > e.g.
> > > > 
> > > > # trace-cmd start -e xfs_log_cil_wait
> > > > <run xfstests>
> > > > # trace-cmd show
> > > > # tracer: nop
> > > > #
> > > > # entries-in-buffer/entries-written: 1/1   #P:4
> > > > #
> > > > #                              _-----=> irqs-off
> > > > #                             / _----=> need-resched
> > > > #                            | / _---=> hardirq/softirq
> > > > #                            || / _--=> preempt-depth
> > > > #                            ||| /     delay
> > > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > > > #              | |       |   ||||       |         |
> > > >           xfs_io-2158  [001] ...1   309.285959: xfs_log_cil_wait: dev 8:96 t_ocnt 1 t_cnt 1 t_curr_res 67956 t_unit_res 67956 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 75 grant_reserve_bytes 12878480 grant_write_cycle 75 grant_write_bytes 12878480 curr_cycle 75 curr_block 10448 tail_cycle 75 tail_block 3560
> > > > #
> > > > 
> > > > And the timestamp matched the time that generic/017 was running.
> > > 
> > > SO I've run this on my typical 16-way fsmark workload with different
> > > size logs. It barely triggers on log sizes larger than 64MB, on 32MB
> > > logs I can see it capturing all 16 fsmark processes while waiting
> > > for the CIL context to switch. This will give you an idea of the
> > > log cycles the capture is occuring on, and the count of processes
> > > being captured:
> > > 
> > > $ sudo trace-cmd show | awk -e '/^ / {print $23}' | sort -n |uniq -c
> > >      16 251
> [snip]
> > >      16 2892
> > > $
> > 
> > Thanks. I assume I'm looking at cycle numbers and event counts here?
> 
> Yes.
> 
> > > So typically groups of captures are hundreds of log cycles apart
> > > (100 cycles x 32MB = ~3GB of log writes), then there will be a
> > > stutter where the CIL dispatch is delayed, and then everything
> > > continues on. These all show the log is always around the 75% full
> > > (AIL tail pushing theshold) but the reservation grant wait lists are
> > > always empty so we're not running out of reservation space here.
> > > 
> > 
> > It's somewhat interesting that we manage to block every thread most of
> > the time before the CIL push task starts. I wonder a bit if that pattern
> > would hold for a system/workload with more CPUs (and if so, if there are
> > any odd side effects of stalling and waking hundreds of tasks at the
> > same time vs. our traditional queuing behavior).
> 
> If I increase the concurrency (e.g. 16->32 threads for fsmark on a
> 64MB log), we hammer the spinlock on the grant head -hard-. i.e. CPU
> usage goes up by 40%, performance goes down by 50%, and all that CPU
> time is spent spinning on the reserve grant head lock. Basically,
> the log reservation space runs out, and we end up queuing on the
> reservation grant head and then we get reminded of just how bad
> having a serialisation point in the reservation fast path actually
> is for scalability...
> 

The small log case is not really what I'm wondering about. Does this
behavior translate to a similar test with a maximum sized log?

...
> 
> Larger logs block more threads on the CIL throttle, but the 32MB CIL
> window can soak up hundreds of max sized transaction reservations
> before overflowing so even running several hundred concurrent
> modification threads I haven't been able to drive enough concurrency
> through the CIL to see any sort of adverse behaviour.  And the
> workloads are running pretty consistently at less than 5,000 context
> switches/sec so there's no evidence of repeated thundering heard
> wakeup problems, either.
> 

That speaks to the rarity of the throttle, which is good. But I'm
wondering, for example, what might happen on systems where we could have
hundreds of physical CPUs committing to the CIL, we block them all on
the throttle and then wake them all at once. IOW, can we potentially
create the contention conditions you reproduce above in scenarios where
they might not have existed before?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
