Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26E1CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 23:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748F020659
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 23:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfJYXjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 19:39:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48331 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbfJYXjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 19:39:39 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9CBE943F208;
        Sat, 26 Oct 2019 10:39:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iO9B8-0007CY-7H; Sat, 26 Oct 2019 10:39:34 +1100
Date:   Sat, 26 Oct 2019 10:39:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question about logbsize default value
Message-ID: <20191025233934.GI4614@dread.disaster.area>
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
 <20191024215027.GC4614@dread.disaster.area>
 <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb0ef021-27be-c0bd-5950-103cd8b04594@assyoma.it>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=3nZs4vVixnWYJ0OWBKYA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 09:10:28AM +0200, Gionatan Danti wrote:
> On 24/10/19 23:50, Dave Chinner wrote:
> > On Wed, Oct 23, 2019 at 11:40:33AM +0200, Gionatan Danti wrote:
> > Defaults are for best compatibility and general behaviour, not
> > best performance. A log stripe unit of 32kB allows the user to
> > configure a logbsize appropriate for their workload, as it supports
> > logbsize of 32kB, 64kB, 128kB and 256kB. If we chose 256kB as the
> > default log stripe unit, then you have no opportunity to set the
> > logbsize appropriately for your workload.
> > 
> > remember, LSU determines how much padding is added to every non-full
> > log write - 32kB pads out ot 32kB, 256kB pads out to 256kB. Hence if
> > you have a workload that frequnetly writes non-full iclogs (e.g.
> > regular fsyncs) then a small LSU results in much better performance
> > as there is less padding that needs to be initialised and the IOs
> > are much smaller.
> > 
> > Hence for the general case (i.e. what the defaults are aimed at), a
> > small LSU is a much better choice. you can still use a large
> > logbsize mount option and it will perform identically to a large LSU
> > filesystem on full iclog workloads (like the above fsmark workload
> > that doesn't use fsync). However, a small LSU is likely to perform
> > better over a wider range of workloads and storage than a large LSU,
> > and so small LSU is a better choice for the default....
> 
> Hi Dave, thank you for your explanation. The observed behavior of a large
> LSU surely matches what you described - less-than-optimal fsync perf.
> 
> That said, I was wondering why *logbsize* (rather than LSU) has a low
> default of 32k (or, better, its default is to match LSU size).

The default is to match LSU size, otherwise if LSU is < 32kB (e.g.
not set) it will use 32kB. If you try to set a logbsize smaller than
the LSU at mount time, it should throw an error.

> If I
> understand it correctly, a large logbsize (eg: 256k) on top of a small LSU
> (32k) would give high performance on both full-log-writes and
> partial-log-writes (eg: frequent fsync).

Again, it's a trade-off.

256kB iclogs mean that a crash can leave an unrecoverable 2MB hole
in the journal, while 32kB iclogs means it's only 256kB.

256kB iclogs mean 2MB of memory usage per filesystem, 32kB is only
256kB. We have users with hundreds of individual XFS filesystems
mounted on single machines, and so 256kB iclogs is a lot of wasted
memory...

On small logs and filesystems, 256kB iclogs doesn't provide any real
benefit because throughput is limited by log tail pushing (metadata
writeback), not async transaction throughput.

It's not uncommon for modern disks to have best throughput and/or
lowest latency at IO sizes of 128kB or smaller.

If you have lots of NVRAM in front of your spinning disks, then log
IO sizes mostly don't matter - they end up bandwidth limited before
the iclog size is an issue.

Testing on a pristine filesystem doesn't show what happens as the
filesystem ages over years of constant use, and so what provides
"best performance on empty filesystem" often doesn't provide best
long term production performance.

And so on.

Storage is complex, filesystems are complex, and no one setting is
right for everyone. The defaults are intended to be "good enough" in
the majority of typical user configs. 

> Is my understanding correct?

For you're specific storage setup, yes.

> If you, do you suggest to always set logbsize
> to the maximum supported value?

No. I recommend that people use the defaults, and only if there are
performance issues with their -actual production workload- should
they consider changing anything.

Benchmarks rarely match the behaviour of production workloads -
tuning for benchmarks can actively harm production performance,
especially over the long term...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
