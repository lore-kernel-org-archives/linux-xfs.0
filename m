Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9172C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BC220780
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394947AbgJZW53 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:57:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41293 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392761AbgJZW53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 18:57:29 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D781858C1CA;
        Tue, 27 Oct 2020 09:57:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXBQa-004gOX-Qa; Tue, 27 Oct 2020 09:57:24 +1100
Date:   Tue, 27 Oct 2020 09:57:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201026225724.GW7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
 <20201025044114.GA347246@magnolia>
 <20201026222943.GV7391@dread.disaster.area>
 <20201026224051.GC347246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026224051.GC347246@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=duPjQ_5v1xQNCubYSZIA:9 a=M4ZSqxEH3aYrv8pD:21 a=ULw1nz7Jr2M8GuMN:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 03:40:51PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 27, 2020 at 09:29:43AM +1100, Dave Chinner wrote:
> > On Sat, Oct 24, 2020 at 09:41:14PM -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 22, 2020 at 04:15:31PM +1100, Dave Chinner wrote:
> > > > @@ -140,6 +164,7 @@ workqueue_add(
> > > >  
> > > >  	/* Now queue the new work structure to the work queue. */
> > > >  	pthread_mutex_lock(&wq->lock);
> > > > +restart:
> > > >  	if (wq->next_item == NULL) {
> > > >  		assert(wq->item_count == 0);
> > > >  		ret = -pthread_cond_signal(&wq->wakeup);
> > > > @@ -150,6 +175,16 @@ workqueue_add(
> > > >  		}
> > > >  		wq->next_item = wi;
> > > >  	} else {
> > > > +		/* throttle on a full queue if configured */
> > > > +		if (wq->max_queued && wq->item_count == wq->max_queued) {
> > > > +			pthread_cond_wait(&wq->queue_full, &wq->lock);
> > > 
> > > I ported xfs_scrub to use max_queued for the inode scanner, and got a
> > > hang here.  It uses two workqueues -- the first is an unbouned workqueue
> > > that receives one work item per AG in which each work item calls
> > > INUMBERS, creates a work item for the returned inode chunk, and throws
> > > it at the second workqueue.  The second workqueue is a bounded workqueue
> > > that calls BULKSTAT on the INUMBERS work item and then calls the
> > > iteration function on each bulkstat record returned.
> > > 
> > > The hang happens when the inumbers workqueue has more than one thread
> > > running.
> > 
> > IIUC, that means you have multiple producer threads? IIRC, he usage
> > in this patchset is single producer, so it won't hit this problem...
> 
> Right, there are multiple producers, because that seemed like fun.
> At this stage, I'm merely using this patch in anger (as it were) to
> prototype a fix to scrub.
> 
> I'm not even sure it's a reasonable enhancement for xfs_scrub since each
> of those bulkstat workers will then fight with the inumbers workers for
> the AGI, but so it goes.  It does seem to eliminate the problem of one
> thread working hard on an AG that has one huge fragmented file while the
> other threads sit idle, but otherwise I mostly just see more buffer lock
> contention.

Yeah, that's exactly the problem it solves for phase6, too. i.e. it
stops a single huge directory from preventing other directories in
that AG from being processed even when everything else is done.

> The total runtime doesn't change on more balanced
> filesystems, at least. :P

That's a start :)

> > > I dunno if that's a sane way to structure an inumbers/bulkstat scan, but
> > > it seemed reasonable to me.  I can envision two possible fixes here: (1)
> > > use pthread_cond_broadcast to wake everything up; or (2) always call
> > > pthread_cond_wait when we pull a work item off the queue.  Thoughts?
> > 
> > pthread_cond_broadcast() makes more sense, but I suspect there will
> > be other issues with multiple producers that render the throttling
> > ineffective. I suspect supporting multiple producers should be a
> > separate patchset...
> 
> <nod> Making change (2) seems to work for multiple producers, but I
> guess I'll keep poking at perf to see if I discover anything exciting.

I'll look at the multiple producer thing in a bit more detail later
today...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
