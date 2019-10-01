Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF3C32793
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 03:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F4820842
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 03:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJADmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:42:13 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44432 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfJADmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 23:42:13 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EECE8362DF4;
        Tue,  1 Oct 2019 13:42:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iF939-0007Fa-G7; Tue, 01 Oct 2019 13:42:07 +1000
Date:   Tue, 1 Oct 2019 13:42:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191001034207.GS16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930215336.GR16973@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=5COPqPJM9SPeMnsJfIkA:9
        a=lftmRN-5WYEbW2oJ:21 a=PN_aqTHRB56inR-x:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 01, 2019 at 07:53:36AM +1000, Dave Chinner wrote:
> On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> > On Mon, Sep 30, 2019 at 04:03:44PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > In certain situations the background CIL push can be indefinitely
> > > delayed. While we have workarounds from the obvious cases now, it
> > > doesn't solve the underlying issue. This issue is that there is no
> > > upper limit on the CIL where we will either force or wait for
> > > a background push to start, hence allowing the CIL to grow without
> > > bound until it consumes all log space.
> > > 
> > > To fix this, add a new wait queue to the CIL which allows background
> > > pushes to wait for the CIL context to be switched out. This happens
> > > when the push starts, so it will allow us to block incoming
> > > transaction commit completion until the push has started. This will
> > > only affect processes that are running modifications, and only when
> > > the CIL threshold has been significantly overrun.
> > > 
> > > This has no apparent impact on performance, and doesn't even trigger
> > > until over 45 million inodes had been created in a 16-way fsmark
> > > test on a 2GB log. That was limiting at 64MB of log space used, so
> > > the active CIL size is only about 3% of the total log in that case.
> > > The concurrent removal of those files did not trigger the background
> > > sleep at all.
> > > 
> > 
> > Have you done similar testing for small/minimum sized logs?
> 
> Yes. I've had the tracepoint active during xfstests runs on test
> filesystems using default log sizes on 5-15GB filesystems. The only
> test in all of xfstests that has triggered it is generic/017, and it
> only triggered once.
> 
> e.g.
> 
> # trace-cmd start -e xfs_log_cil_wait
> <run xfstests>
> # trace-cmd show
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 1/1   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>           xfs_io-2158  [001] ...1   309.285959: xfs_log_cil_wait: dev 8:96 t_ocnt 1 t_cnt 1 t_curr_res 67956 t_unit_res 67956 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 75 grant_reserve_bytes 12878480 grant_write_cycle 75 grant_write_bytes 12878480 curr_cycle 75 curr_block 10448 tail_cycle 75 tail_block 3560
> #
> 
> And the timestamp matched the time that generic/017 was running.

SO I've run this on my typical 16-way fsmark workload with different
size logs. It barely triggers on log sizes larger than 64MB, on 32MB
logs I can see it capturing all 16 fsmark processes while waiting
for the CIL context to switch. This will give you an idea of the
log cycles the capture is occuring on, and the count of processes
being captured:

$ sudo trace-cmd show | awk -e '/^ / {print $23}' | sort -n |uniq -c
     16 251
     32 475
     16 494
     32 870
     15 1132
     15 1166
     14 1221
      1 1222
     16 1223
      7 1307
      8 1308
     16 1315
     16 1738
     16 1832
      9 2167
      7 2168
     16 2200
     16 2375
     16 2383
     16 2700
     16 2797
     16 2798
     16 2892
$

So typically groups of captures are hundreds of log cycles apart
(100 cycles x 32MB = ~3GB of log writes), then there will be a
stutter where the CIL dispatch is delayed, and then everything
continues on. These all show the log is always around the 75% full
(AIL tail pushing theshold) but the reservation grant wait lists are
always empty so we're not running out of reservation space here.

If I make the log even smaller - 16MB - the log is always full, the
AIL is always tail pushing, and there is a constant stream of log
forces (30-40/s) because tail pushing is hitting pinned items
several thousand times a second.  IOWs, the frequency of the log
forces means that CIL is almost never growing large enough to do a
background push, let alone overrun the blocking threshold. Same
trace for the same workload as above:

$ sudo trace-cmd show | awk -e '/^ / {print $23}' | sort -n |uniq -c
     16 1400
     16 5284
     16 5624
     16 5778
     16 6159
     10 6477
$

So when we have lots of concurrency and modification, tiny logs
appear to be less susceptible to CIL overruns than small logs
because they are constantly tail pushing and issuing log forces that
trigger trigger flushes of the CIL before an overruns could occur.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
