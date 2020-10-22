Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4D1C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65360223BF
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509263AbgJVIL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:11:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45454 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2442145AbgJVIL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 04:11:27 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CCE3A3A7E74;
        Thu, 22 Oct 2020 19:11:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVVgx-0036vt-U3; Thu, 22 Oct 2020 19:11:23 +1100
Date:   Thu, 22 Oct 2020 19:11:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201022081123.GS7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
 <20201022055425.GN9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022055425.GN9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=408XRwoYcR06VO31nuMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 10:54:25PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 04:15:31PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Existing users of workqueues have bound maximum queue depths in
> > their external algorithms (e.g. prefetch counts). For parallelising
> > work that doesn't have an external bound, allow workqueues to
> > throttle incoming requests at a maximum bound. bounded workqueues
> 
> Nit: capitalize the 'B' in 'bounded'.
> 
> > also need to distribute work over all worker threads themselves as
> > there is no external bounding or worker function throttling
> > provided.
> > 
> > Existing callers are not throttled and retain direct control of
> > worker threads, only users of the new create interface will be
> > throttled and concurrency managed.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  libfrog/workqueue.c | 42 +++++++++++++++++++++++++++++++++++++++---
> >  libfrog/workqueue.h |  4 ++++
> >  2 files changed, 43 insertions(+), 3 deletions(-)
> > 
> > diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> > index fe3de4289379..e42b2a2f678b 100644
> > --- a/libfrog/workqueue.c
> > +++ b/libfrog/workqueue.c
> > @@ -40,13 +40,21 @@ workqueue_thread(void *arg)
> >  		}
> >  
> >  		/*
> > -		 *  Dequeue work from the head of the list.
> > +		 *  Dequeue work from the head of the list. If the queue was
> > +		 *  full then send a wakeup if we're configured to do so.
> >  		 */
> >  		assert(wq->item_count > 0);
> > +		if (wq->max_queued && wq->item_count == wq->max_queued)
> > +			pthread_cond_signal(&wq->queue_full);
> > +
> >  		wi = wq->next_item;
> >  		wq->next_item = wi->next;
> >  		wq->item_count--;
> >  
> > +		if (wq->max_queued && wq->next_item) {
> > +			/* more work, wake up another worker */
> > +			pthread_cond_signal(&wq->wakeup);
> 
> Hmm.  The net effect of this is that we wake up workers faster when a
> ton of work comes in, right?

Effectively. What it does is increase the concurrency of processing
only when the current worker threads cannot keep up with the
incoming work....

> And I bet none of the current workqueue
> users have suffered from this because they queue a bunch of work and
> then call workqueue_terminate, which wakes all the threads, and they
> never go to sleep again.
> 
> Does it make sense to simplify the test to "if (wq->next_item) {"?

Perhaps so, but I didn't want to make subtle changes to the way the
prefetch stuff works - that's a tangled ball of string that is easy
to deadlock and really hard to debug....

> Other than that, looks good!

Ta!

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
