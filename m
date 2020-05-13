Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2847C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 23:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C862C2065C
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 23:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbgEMXeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 19:34:05 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44256 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732705AbgEMXeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 19:34:04 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 979021087DC;
        Thu, 14 May 2020 09:33:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jZ0sw-00011v-8G; Thu, 14 May 2020 09:33:58 +1000
Date:   Thu, 14 May 2020 09:33:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200513233358.GH2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
 <20200513170237.GB45326@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513170237.GB45326@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=_Y4RK2BSnBka7LqxYg0A:9 a=jHZlESlBkjjGtMxI:21 a=_VlKy759-wTcBFpL:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 01:02:37PM -0400, Brian Foster wrote:
> On Tue, May 12, 2020 at 07:28:10PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Next on the list to getting rid of the xc_cil_lock is making the CIL
> > itself per-cpu.
> > 
> > This requires a trade-off: we no longer move items forward in the
> > CIL; once they are on the CIL they remain there as we treat the
> > percpu lists as lockless.
> > 
> > XXX: preempt_disable() around the list operations to ensure they
> > stay local to the CPU.
> > 
> > XXX: this needs CPU hotplug notifiers to clean up when cpus go
> > offline.
> > 
> > Performance now increases substantially - the transaction rate goes
> > from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
> > for the first time.
> > 
> > Using a 32-way concurrent create/unlink on a 32p/16GB virtual
> > machine:
> > 
> > 	    create time     rate            unlink time
> > unpatched	1m56s      533k/s+/-28k/s      2m34s
> > patched		1m49s	   523k/s+/-14k/s      2m00s
> > 
> > Notably, the system time for the create went up, while variance went
> > down. This indicates we're starting to hit some other contention
> > limit as we reduce the amount of time we spend contending on the
> > xc_cil_lock.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
> >  fs/xfs/xfs_log_priv.h |  2 +-
> >  2 files changed, 45 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 746c841757ed1..af444bc69a7cd 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> ...
> > @@ -687,7 +689,7 @@ xlog_cil_push_work(
> >  	 * move on to a new sequence number and so we have to be able to push
> >  	 * this sequence again later.
> >  	 */
> > -	if (list_empty(&cil->xc_cil)) {
> > +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
> 
> It seems reasonable, but I need to think a bit more about the whole
> percpu list thing. In the meantime, one thing that comes to mind is the
> more of these list_empty() -> percpu_counter_read() translations I see
> the less I like it because we're leaking this inherent raciness to
> different contexts. Whether it's ultimately safe or not, it's subject to
> change and far too subtle and indirect for my taste. 

Well, all the critical list_empty(&cil->xc_cil) checks are done
under the xc_push_lock, so I'd suggest that if we zero the counters
under the push lock when switching contexts, and put the initial
zero->non-zero counter transition to under the same lock we'll get
exact checks without requiring a spinlock/atomic in the fast
path and have all the right memory barriers in place such that races
can't happen...

> Could we replace all of the direct ->xc_cil list checks with an atomic
> bitop (i.e. XLOG_CIL_EMPTY) or something similar in the xfs_cil? AFAICT,
> that could be done in a separate patch and we could ultimately reuse it
> to close the race with the initial ctx reservation (via
> test_and_set_bit()) because it's otherwise set in the same function. Hm?

test_and_set_bit() still locks the memory bus and so requires
exclusive access to the cacheline. Avoiding locked bus ops
(atomics, spinlocks, etc) in the fast path is the problem
I'm trying to solve with this patchset. IOWs, this isn't a viable
solution to a scalability problem caused by many CPUs all trying to
access the same cacheline exclusively.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
