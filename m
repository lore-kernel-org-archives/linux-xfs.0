Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ED0C47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 03:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD4BB21721
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 03:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfJHDek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 23:34:40 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40004 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729772AbfJHDek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 23:34:40 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B9C0543EA0B;
        Tue,  8 Oct 2019 14:34:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iHgGh-0003sX-Vx; Tue, 08 Oct 2019 14:34:35 +1100
Date:   Tue, 8 Oct 2019 14:34:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191008033435.GF16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001131304.GA62428@bfoster>
 <20191001223107.GT16973@dread.disaster.area>
 <20191002124056.GA2403@bfoster>
 <20191003005310.GV16973@dread.disaster.area>
 <20191003143934.GA2105@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003143934.GA2105@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=Z51WgZ1jWCa_DjXJQ_sA:9 a=S5k1dAiiInwQsvxk:21
        a=ld3CmRsrNQ8elIF3:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 10:39:34AM -0400, Brian Foster wrote:
> On Thu, Oct 03, 2019 at 10:53:10AM +1000, Dave Chinner wrote:
> > On Wed, Oct 02, 2019 at 08:40:56AM -0400, Brian Foster wrote:
> > > Ok, that's not quite what I was concerned about when you mentioned
> > > waiting on the CIL to flush to disk. No matter, the important bit here
> > > is the performance cost of including the extra blocking on log I/O (to
> > > cycle iclogs back to active for reuse) in the throttle.
> > > 
> > > I'm curious about how noticeable this extra blocking would be because
> > > it's one likely cause of the CIL pressure buildup in the first place. My
> > > original tests reproduced huge CIL checkpoints purely based on one CIL
> > > push being blocked behind the processing of another, the latter taking
> > > relatively more time due to log I/O.
> > 
> > It's very noticable. I dropped that as a throttle mechanism because
> > even on a SSD at 200us per write, a 32MB CIL flush takes for
> > 20-30ms. And it stops everything dead for that time because it
> > stalls all async transaction commits while the log flushes.
> > 
> > When several CIL flushes a second occur (pushing 100-150MB/s to the
> > log), I start seeing a substantial amount of additional time
> > (15-20% of total CPU time) being spent idle just waiting for CIL
> > flush completion. And it only gets worse as the storage gets
> > slower...
> > 
> > The throttle that these patches implement are typically only
> > stalling incoming transactions for a couple of hundred microseconds.
> > The timestamps from the groups of log events show the blocking of
> > all threads are very close together in time, and the push work to
> > switch over to the new context to allow them to unblock and continue
> > happens within another 200-300 microseconds. And the worst case I've
> > seen, this is happening once or twice a second. IOWs, the blocking
> > time of the throttle is very short and largely unnoticable, and the
> > difference to performance it causes is far, far less than the noise
> > threshold of the benchmarks.
> > 
> 
> Ok, thanks for the info. Is that 200-300us delay reliable on a sustained
> workload (where the throttle triggers multiple times)? If so, I suppose
> that longer delay I was wondering about is not as likely in practice.

THe more threads there are, the longer the capture and delay time,
but I'm not seeing delays that are long enough to measurably reduce
the CPU consumption of the workloads nor the throughput of the
benchmark outside of the normal noise floor.

> > > This is not to say there aren't other causes of excessively sized
> > > checkpoints. Rather, if we're at a point where we've blocked
> > > transactions on this new threshold, that means we've doubled the
> > > background threshold in the time we've first triggered a background CIL
> > > push and the push actually started. From that, it seems fairly likely
> > > that we could replenish the CIL to the background threshold once
> > > threads are unblocked but before the previous push completes.
> > 
> > That's just fine. The CIL is actually designed to allow that sort of
> > overlap between multiple committing background contexts and the
> > current aggregating context. As long as each individual CIL commit
> > size doesn't go over half the log and there's always a complete
> > commit in the log (which there should be via head/tail limits),
> > the only limit on the number of concurrent committing CIL contexts
> > on the fly at once is the amount of log space we have available....
> > 
> 
> Right, but if we're blocking transactions on the start of a CIL push and
> the start of a CIL push blocks on completion of the previous push, it's
> possible to indirectly block transactions on completion of a CIL push.
> There is some staggering there compared to blocking a transaction
> directly on a CIL push start to finish, however, so perhaps that keeps
> the delay down in practice.

*nod*

The idea is that this all works as a multi-stage pipeline so there
is always overlap and work being done, even if there are short
stalls in individual work units in the pipeline:

reservation
  modification
    commit
      cil insert
	Cil push
	  iclog write
	    iclog completion
	      AIL insert
	        AIL push
		  metadata IO completion
		    AIL removal
		      log tail updates

Given that CPUs are generally much faster than the IO part of the
pipeline, short CPU scheduling delays don't introduce stalls in the
IO parts of the pipeline and so largely don't affect throughput.
It's when delays become long enough to fill the buffers of the
previous stage and stall multiple stages that performance goes down.
Ideally, there should be no stalls or pipeline delays after the
transaction has a reservation as those are bound by the final stage
throughput (log tail updates).

What we are doing here is adding more feedback between smaller parts
of the pipeline to manage the flow of modifications within the
pipeline. In this case, it is between the iclog writes and the CIL
insert stages so that we don't buffer the entire pipeline's work on
the CIL insert stage when CIL pushes stall on iclog writes due to
slowness in iclog completion and (perhaps) AIL insertion stages.

So, yeah, we can commit and insert in the CIL while a push is
occurring, and mostly they will happen at the same time and the CIL
is large enough that a typical push will complete at the same time
the cil inserts fill a new queue to be pushed....

> > > That sounds more involved than what I was thinking. My thought is that
> > > this throttle is already not predictable or deterministic (i.e. we're
> > > essentially waiting on a scheduler event) and so might not require the
> > > extra complexity of a new waitqueue. It certainly could be the case that
> > > blocking on the entire push is just too long in practice, but since this
> > 
> > I've made that sort of change here and measured the regression.
> > Then I discarded it as an unworkable option and looked for other
> > solutions.
> 
> Ok. What was the regression that resulted from the longer throttle
> delay, out of curiosity?

Well, I tried two things. The first was throttling by waiting for
the entire CIL push by issuing a flush_work() similar to the
xlog_cil_push_now() code. That introduced substantial pipeline
stalls at the CIL insert point, and performance went way down.

The second was moving the up_write() in xlog_cil_push() down to
after then CIL had been formatted and written to the iclogs
entirely. This didn't wait on the commit record write, so removed
taht part of the serialisation from the throttling. i.e. this stalls
incoming inserts (commits) on the down_read() of the context lock
until the CIL push had processed the CIL. This didn't make much
difference, because all the work is in formatting the thousands of
CIL logvecs into the iclogs and writing them to disk.

Basically, blocking the CIL insert on CIL pushes and iclog IO
creates pipeline stalls and prevents us from committing new changes
while the CIL is flushing. Hence we reduce concurrency in the
transaction commit path, and performance goes down accordingly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
