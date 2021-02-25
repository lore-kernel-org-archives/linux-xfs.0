Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420CCC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 21:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBDB64E90
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 21:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhBYVIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 16:08:37 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48970 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233974AbhBYVG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 16:06:59 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 826B81040BB3;
        Fri, 26 Feb 2021 08:06:17 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFNpw-004GH0-RZ; Fri, 26 Feb 2021 08:06:16 +1100
Date:   Fri, 26 Feb 2021 08:06:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210225210616.GM4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
 <YDdmwiLsEwrazwBH@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdmwiLsEwrazwBH@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=Q8EjymgQ801yHBcBpfQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:58:42AM +0100, Christoph Hellwig wrote:
> > As a result:
> > 
> > 	logbsize	fsmark create rate	rm -rf
> > before	32kb		152851+/-5.3e+04	5m28s
> > patched	32kb		221533+/-1.1e+04	5m24s
> > 
> > before	256kb		220239+/-6.2e+03	4m58s
> > patched	256kb		228286+/-9.2e+03	5m06s
> > 
> > The rm -rf times are included because I ran them, but the
> > differences are largely noise. This workload is largely metadata
> > read IO latency bound and the changes to the journal cache flushing
> > doesn't really make any noticable difference to behaviour apart from
> > a reduction in noiclog events from background CIL pushing.
> 
> The 256b rm -rf case actually seems like a regression not in the noise
> here.  Does this reproduce over multiple runs?

It's noise. The unlink repeat times on this machine at 16 threads
are at least +/-15s because the removals are not synchronised in
groups like the creates are.

These are CPU bound workloads when the log is not limiting the
transaction rate (only the {before, 32kB} numbers in this test are
log IO bound) so there's always some variation in performance due to
non-deterministic factors like memory reclaim, AG lock-stepping
between threads, etc.

Hence there's a bit of unfairness between the threads and often the
first thread finishes 30s before the last thread. The times are for
the last thread completing and there can be significant variation on
that.

> > @@ -2009,13 +2010,14 @@ xlog_sync(
> >  	 * synchronously here; for an internal log we can simply use the block
> >  	 * layer state machine for preflushes.
> >  	 */
> > -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> > +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> > +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
> >  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> > -		need_flush = false;
> > +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> 
> Once you touch all the buffer flags anyway we should optimize the
> log wraparound case here - insteaad of th synchronous flush we just
> need to set REQ_PREFLUSH on the first log bio, which should be nicely
> doable with your infrastruture.

That sounds like another patch because it's a change of behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
