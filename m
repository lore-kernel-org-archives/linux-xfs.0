Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:6739 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbeJaFs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:48:26 -0400
Date: Wed, 31 Oct 2018 07:53:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] workqueue: bound maximum queue depth
Message-ID: <20181030205320.GP19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-5-david@fromorbit.com>
 <20181030175839.GM4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030175839.GM4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:58:39AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 30, 2018 at 10:20:40PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Existing users of workqueues have bound maximum queue depths in
> > their external algorithms (e.g. prefetch counts). For parallelising
> > work that doesn't have an external bound, allow workqueues to
> > throttle incoming requests at a maximum bound. bounded workqueues
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
> >  include/workqueue.h |  4 ++++
> >  libfrog/workqueue.c | 30 +++++++++++++++++++++++++++---
> >  2 files changed, 31 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/workqueue.h b/include/workqueue.h
> > index c45dc4fbcf64..504da9403b85 100644
> > --- a/include/workqueue.h
> > +++ b/include/workqueue.h
> > @@ -30,10 +30,14 @@ struct workqueue {
> >  	unsigned int		item_count;
> >  	unsigned int		thread_count;
> >  	bool			terminate;
> > +	int			max_queued;
> > +	pthread_cond_t		queue_full;
> >  };
> >  
> >  int workqueue_create(struct workqueue *wq, void *wq_ctx,
> >  		unsigned int nr_workers);
> > +int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
> > +		unsigned int nr_workers, int max_queue);
> 
> What does negative max_queue mean?

Nothing. it can be made unsigned.

> 
> >  int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
> >  		uint32_t index, void *arg);
> >  void workqueue_destroy(struct workqueue *wq);
> > diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> > index 7311477374b4..8fe0dc7249f5 100644
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
> > +		}
> 
> It seems a little funny to me that the worker thread wakes up other
> worker threads when there is more work to do (vs. workqueue_add which
> actually added more work)...

The problem is that workqueue_add() delegates all concurrency and
queue throttling to the worker thread callback function. The work
queue doesn't function as a "queue" at all - it functions as a
method of starting long running functions that do there own work
queuing and throttling.  Hence these externally co-ordinated worker
threads only require kicking off when the first work item is queued,
otherwise they completely manage themselves and never return to the
worker thread itself until they are done.

This is one of the reasons the prefetch code is so damn complex - it
has to do all this queue throttling and worker thread co-ordination
itself with it's own infrastructure, rather than just having a
thread walking the block maps calling "queue_work" on each object it
needs read. Instead it's got counting semaphores,
start/done/restart/maybe start/maybe stop logic to manage the queue
depth, etc.

What the above change does is enable us to use workqueues for
queuing small pieces of work that need to be processed, and allows
them to be processed concurrently without the caller having to do
anything to manage that concurrency. This way the concurrency will
grow automatically to the maximum bound of the workqueue and we
don't have to worry about doing any extra wakeups or tracking
anything in workqueue_add...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
