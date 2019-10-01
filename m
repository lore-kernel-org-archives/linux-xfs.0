Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36AAECE587
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 23:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54292086A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 23:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfJAXOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 19:14:40 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34826 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbfJAXOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Oct 2019 19:14:39 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DB58B361DC0;
        Wed,  2 Oct 2019 09:14:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iFRLl-0006C9-HW; Wed, 02 Oct 2019 09:14:33 +1000
Date:   Wed, 2 Oct 2019 09:14:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191001231433.GU16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001034207.GS16973@dread.disaster.area>
 <20191001131336.GB62428@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001131336.GB62428@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=iUpzoX_YdVpua_-eI5IA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 01, 2019 at 09:13:36AM -0400, Brian Foster wrote:
> On Tue, Oct 01, 2019 at 01:42:07PM +1000, Dave Chinner wrote:
> > On Tue, Oct 01, 2019 at 07:53:36AM +1000, Dave Chinner wrote:
> > > On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> > > > Have you done similar testing for small/minimum sized logs?
> > > 
> > > Yes. I've had the tracepoint active during xfstests runs on test
> > > filesystems using default log sizes on 5-15GB filesystems. The only
> > > test in all of xfstests that has triggered it is generic/017, and it
> > > only triggered once.
> > > 
> > > e.g.
> > > 
> > > # trace-cmd start -e xfs_log_cil_wait
> > > <run xfstests>
> > > # trace-cmd show
> > > # tracer: nop
> > > #
> > > # entries-in-buffer/entries-written: 1/1   #P:4
> > > #
> > > #                              _-----=> irqs-off
> > > #                             / _----=> need-resched
> > > #                            | / _---=> hardirq/softirq
> > > #                            || / _--=> preempt-depth
> > > #                            ||| /     delay
> > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > > #              | |       |   ||||       |         |
> > >           xfs_io-2158  [001] ...1   309.285959: xfs_log_cil_wait: dev 8:96 t_ocnt 1 t_cnt 1 t_curr_res 67956 t_unit_res 67956 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 75 grant_reserve_bytes 12878480 grant_write_cycle 75 grant_write_bytes 12878480 curr_cycle 75 curr_block 10448 tail_cycle 75 tail_block 3560
> > > #
> > > 
> > > And the timestamp matched the time that generic/017 was running.
> > 
> > SO I've run this on my typical 16-way fsmark workload with different
> > size logs. It barely triggers on log sizes larger than 64MB, on 32MB
> > logs I can see it capturing all 16 fsmark processes while waiting
> > for the CIL context to switch. This will give you an idea of the
> > log cycles the capture is occuring on, and the count of processes
> > being captured:
> > 
> > $ sudo trace-cmd show | awk -e '/^ / {print $23}' | sort -n |uniq -c
> >      16 251
[snip]
> >      16 2892
> > $
> 
> Thanks. I assume I'm looking at cycle numbers and event counts here?

Yes.

> > So typically groups of captures are hundreds of log cycles apart
> > (100 cycles x 32MB = ~3GB of log writes), then there will be a
> > stutter where the CIL dispatch is delayed, and then everything
> > continues on. These all show the log is always around the 75% full
> > (AIL tail pushing theshold) but the reservation grant wait lists are
> > always empty so we're not running out of reservation space here.
> > 
> 
> It's somewhat interesting that we manage to block every thread most of
> the time before the CIL push task starts. I wonder a bit if that pattern
> would hold for a system/workload with more CPUs (and if so, if there are
> any odd side effects of stalling and waking hundreds of tasks at the
> same time vs. our traditional queuing behavior).

If I increase the concurrency (e.g. 16->32 threads for fsmark on a
64MB log), we hammer the spinlock on the grant head -hard-. i.e. CPU
usage goes up by 40%, performance goes down by 50%, and all that CPU
time is spent spinning on the reserve grant head lock. Basically,
the log reservation space runs out, and we end up queuing on the
reservation grant head and then we get reminded of just how bad
having a serialisation point in the reservation fast path actually
is for scalability...

+   41.05%    37.93%  [kernel]            [k] __pv_queued_spin_lock_slowpath
....
-   30.37%     0.02%  [kernel]            [k] xlog_grant_head_check
   - 17.98% xlog_grant_head_check
      - 14.17% _raw_spin_lock
         + 14.47% __pv_queued_spin_lock_slowpath
      + 8.39% xlog_grant_head_wait
      + 1.17% xlog_grant_head_wake
+   26.47%     0.10%  [kernel]            [k] __xfs_trans_commit
-   26.06%     1.15%  [kernel]            [k] xfs_log_commit_cil
   - 15.69% xfs_log_commit_cil
      - 9.90% xfs_log_done
         + 9.83% xfs_log_space_wake
      + 2.28% xfs_buf_item_format
      + 0.57% _raw_spin_lock
-   16.50%     0.01%  [kernel]            [k] xfs_log_done
   - 9.90% xfs_log_done
      - 9.84% xfs_log_space_wake
         + 13.63% _raw_spin_lock
         + 1.39% xlog_grant_head_wake
-   16.22%     0.02%  [kernel]            [k] xfs_log_space_wake
   - 9.83% xfs_log_space_wake
      + 13.64% _raw_spin_lock
      + 1.40% xlog_grant_head_wake

So, essentially, increasing the concurrency on a small log quickly
hits the log reservation limits (because tail pushing!) and that
largely prevents the CIL from overrrunning, too. Compared to the
16-way/64MB log output I snipped above, here's the 32-way CIL
blocking:

$ sudo trace-cmd show | awk -e '/^ / {print $23}' | sort -n |uniq -c
     30 994
     28 1610
      4 1611
$

Much less, but it still tends to block most threads when it occurs.
I think we can largely ignore the potential thundering heard here
because it seems quite rare comapred to the amount of throttling
being done by the grant head...

Larger logs block more threads on the CIL throttle, but the 32MB CIL
window can soak up hundreds of max sized transaction reservations
before overflowing so even running several hundred concurrent
modification threads I haven't been able to drive enough concurrency
through the CIL to see any sort of adverse behaviour.  And the
workloads are running pretty consistently at less than 5,000 context
switches/sec so there's no evidence of repeated thundering heard
wakeup problems, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
