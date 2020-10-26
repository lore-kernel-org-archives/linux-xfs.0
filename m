Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984CEC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6173B2087C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391448AbgJZW3r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:29:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57878 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394447AbgJZW3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 18:29:47 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 402B958C338;
        Tue, 27 Oct 2020 09:29:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXAzn-004g09-IR; Tue, 27 Oct 2020 09:29:43 +1100
Date:   Tue, 27 Oct 2020 09:29:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201026222943.GV7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
 <20201025044114.GA347246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025044114.GA347246@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=x0LLTTe_3G05Sdl5dqgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 24, 2020 at 09:41:14PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 04:15:31PM +1100, Dave Chinner wrote:
> > @@ -140,6 +164,7 @@ workqueue_add(
> >  
> >  	/* Now queue the new work structure to the work queue. */
> >  	pthread_mutex_lock(&wq->lock);
> > +restart:
> >  	if (wq->next_item == NULL) {
> >  		assert(wq->item_count == 0);
> >  		ret = -pthread_cond_signal(&wq->wakeup);
> > @@ -150,6 +175,16 @@ workqueue_add(
> >  		}
> >  		wq->next_item = wi;
> >  	} else {
> > +		/* throttle on a full queue if configured */
> > +		if (wq->max_queued && wq->item_count == wq->max_queued) {
> > +			pthread_cond_wait(&wq->queue_full, &wq->lock);
> 
> I ported xfs_scrub to use max_queued for the inode scanner, and got a
> hang here.  It uses two workqueues -- the first is an unbouned workqueue
> that receives one work item per AG in which each work item calls
> INUMBERS, creates a work item for the returned inode chunk, and throws
> it at the second workqueue.  The second workqueue is a bounded workqueue
> that calls BULKSTAT on the INUMBERS work item and then calls the
> iteration function on each bulkstat record returned.
> 
> The hang happens when the inumbers workqueue has more than one thread
> running.

IIUC, that means you have multiple producer threads? IIRC, he usage
in this patchset is single producer, so it won't hit this problem...

> Both* threads notice the full workqueue and wait on
> queue_full.  One of the workers in the second workqueue goes to pull off
> the next work item, ends up in this if body, signals one of the sleeping
> threads, and starts calling bulkstat.
> 
> In the time it takes to wake up the sleeping thread from wq 1, the
> second workqueue pulls far enough ahead that the single thread from wq1
> never manages to fill wq2 again.  Often, the wq1 thread was sleeping so
> that it could add the last inode chunk of that AG to wq2.  We therefore
> never wake up the *other* sleeping thread from wq1, and the whole app
> stalls.
> 
> I dunno if that's a sane way to structure an inumbers/bulkstat scan, but
> it seemed reasonable to me.  I can envision two possible fixes here: (1)
> use pthread_cond_broadcast to wake everything up; or (2) always call
> pthread_cond_wait when we pull a work item off the queue.  Thoughts?

pthread_cond_broadcast() makes more sense, but I suspect there will
be other issues with multiple producers that render the throttling
ineffective. I suspect supporting multiple producers should be a
separate patchset...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
