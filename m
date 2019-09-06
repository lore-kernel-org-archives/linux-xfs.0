Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96544C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 02:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A134A20820
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 02:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404310AbfIFCBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 22:01:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40916 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404307AbfIFCBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 22:01:37 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A6EE0362C10;
        Fri,  6 Sep 2019 12:01:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i63Z7-0004La-19; Fri, 06 Sep 2019 12:01:33 +1000
Date:   Fri, 6 Sep 2019 12:01:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: prevent CIL push holdoff in log recovery
Message-ID: <20190906020132.GM1119@dread.disaster.area>
References: <20190906000553.6740-1-david@fromorbit.com>
 <20190906000553.6740-4-david@fromorbit.com>
 <20190906001550.GM2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906001550.GM2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=qTWQaP3TW4R-k1jyzssA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 05:15:50PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 06, 2019 at 10:05:48AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > generic/530 on a machine with enough ram and a non-preemptible
> > kernel can run the AGI processing phase of log recovery enitrely out
> > of cache. This means it never blocks on locks, never waits for IO
> > and runs entirely through the unlinked lists until it either
> > completes or blocks and hangs because it has run out of log space.
> > 
> > It runs out of log space because the background CIL push is
> > scheduled but never runs. queue_work() queues the CIL work on the
> > current CPU that is busy, and the workqueue code will not run it on
> > any other CPU. Hence if the unlinked list processing never yields
> > the CPU voluntarily, the push work is delayed indefinitely. This
> > results in the CIL aggregating changes until all the log space is
> > consumed.
> > 
> > When the log recoveyr processing evenutally blocks, the CIL flushes
> > but because the last iclog isn't submitted for IO because it isn't
> > full, the CIL flush never completes and nothing ever moves the log
> > head forwards, or indeed inserts anything into the tail of the log,
> > and hence nothing is able to get the log moving again and recovery
> > hangs.
> > 
> > There are several problems here, but the two obvious ones from
> > the trace are that:
> > 	a) log recovery does not yield the CPU for over 4 seconds,
> > 	b) binding CIL pushes to a single CPU is a really bad idea.
> > 
> > This patch addresses just these two aspects of the problem, and are
> > suitable for backporting to work around any issues in older kernels.
> > The more fundamental problem of preventing the CIL from consuming
> > more than 50% of the log without committing will take more invasive
> > and complex work, so will be done as followup work.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 1 +
> >  fs/xfs/xfs_super.c       | 3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index f05c6c99c4f3..c9665455431e 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -5080,6 +5080,7 @@ xlog_recover_process_iunlinks(
> >  			while (agino != NULLAGINO) {
> >  				agino = xlog_recover_process_one_iunlink(mp,
> >  							agno, agino, bucket);
> > +				cond_resched();
> 
> <urk> Now I wish I'd asked for a comment explaining why we
> cond_resched()....
> 
> /* Don't let other workqueues (including the CIL ones) starve. */

That doesn't really tell us why  we are doing it, just what the
effect is. And it will starve more than workqueues - anything that
not scheduled as a soft or hard interrupt will be held off.

I'd put something like this in the comment describing
xlog_recover_process_iunlinks():

 ....
 *
 * If everything we touch in the agi processing loop is already in
 * memory, this loop can hold the cpu for a long time. It runs
 * without lock contention, memory allocation contention, the need
 * wait for IO, etc, and so will run until we either run out of
 * inodes to process or we run out of log space. This is bad for
 * latency on single CPU and non-preemptible kernels, and can
 * prevent other filesytem work (such as CIL pushes) from running.
 * This can lead to deadlocks when it runs out of log reservation
 * space. Hence we need to yield the CPU periodically when there is
 * other kernel work scheduled on this CPU to ensure other scheduled
 * work can run without undue latency.
 */

> 
> (Dunno if you want to respin or if I'll just end up fixing it on the way
> in...)

The whole comment needs reformatting, so I'll respin it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
