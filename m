Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40951 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbeKACNY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 22:13:24 -0400
Date: Wed, 31 Oct 2018 13:14:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/7] workqueue: bound maximum queue depth
Message-ID: <20181031171426.GB16769@bfoster>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-5-david@fromorbit.com>
 <20181030175839.GM4135@magnolia>
 <20181030205320.GP19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030205320.GP19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Oct 31, 2018 at 07:53:20AM +1100, Dave Chinner wrote:
> On Tue, Oct 30, 2018 at 10:58:39AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 30, 2018 at 10:20:40PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Existing users of workqueues have bound maximum queue depths in
> > > their external algorithms (e.g. prefetch counts). For parallelising
> > > work that doesn't have an external bound, allow workqueues to
> > > throttle incoming requests at a maximum bound. bounded workqueues
> > > also need to distribute work over all worker threads themselves as
> > > there is no external bounding or worker function throttling
> > > provided.
> > > 
> > > Existing callers are not throttled and retain direct control of
> > > worker threads, only users of the new create interface will be
> > > throttled and concurrency managed.
> > > 

Might be helpful to add a sentence or two on what this is for.

> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  include/workqueue.h |  4 ++++
> > >  libfrog/workqueue.c | 30 +++++++++++++++++++++++++++---
> > >  2 files changed, 31 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/include/workqueue.h b/include/workqueue.h
> > > index c45dc4fbcf64..504da9403b85 100644
> > > --- a/include/workqueue.h
> > > +++ b/include/workqueue.h
> > > @@ -30,10 +30,14 @@ struct workqueue {
> > >  	unsigned int		item_count;
> > >  	unsigned int		thread_count;
> > >  	bool			terminate;
> > > +	int			max_queued;
> > > +	pthread_cond_t		queue_full;
> > >  };
> > >  
> > >  int workqueue_create(struct workqueue *wq, void *wq_ctx,
> > >  		unsigned int nr_workers);
> > > +int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
> > > +		unsigned int nr_workers, int max_queue);
> > 
> > What does negative max_queue mean?
> 
> Nothing. it can be made unsigned.
> 
> > 
> > >  int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
> > >  		uint32_t index, void *arg);
> > >  void workqueue_destroy(struct workqueue *wq);
> > > diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> > > index 7311477374b4..8fe0dc7249f5 100644
> > > --- a/libfrog/workqueue.c
> > > +++ b/libfrog/workqueue.c
> > > @@ -40,13 +40,21 @@ workqueue_thread(void *arg)
> > >  		}
> > >  
> > >  		/*
> > > -		 *  Dequeue work from the head of the list.
> > > +		 *  Dequeue work from the head of the list. If the queue was
> > > +		 *  full then send a wakeup if we're configured to do so.
> > >  		 */
> > >  		assert(wq->item_count > 0);
> > > +		if (wq->max_queued && wq->item_count == wq->max_queued)
> > > +			pthread_cond_signal(&wq->queue_full);
> > > +
> > >  		wi = wq->next_item;
> > >  		wq->next_item = wi->next;
> > >  		wq->item_count--;
> > >  
> > > +		if (wq->max_queued && wq->next_item) {
> > > +			/* more work, wake up another worker */
> > > +			pthread_cond_signal(&wq->wakeup);
> > > +		}
> > 
> > It seems a little funny to me that the worker thread wakes up other
> > worker threads when there is more work to do (vs. workqueue_add which
> > actually added more work)...
> 

FWIW, I had the same thought when looking at this patch..

> The problem is that workqueue_add() delegates all concurrency and
> queue throttling to the worker thread callback function. The work
> queue doesn't function as a "queue" at all - it functions as a
> method of starting long running functions that do there own work
> queuing and throttling.  Hence these externally co-ordinated worker
> threads only require kicking off when the first work item is queued,
> otherwise they completely manage themselves and never return to the
> worker thread itself until they are done.
> 

Ok, so the existing workqueue client code doesn't need additional
wakeups..

> This is one of the reasons the prefetch code is so damn complex - it
> has to do all this queue throttling and worker thread co-ordination
> itself with it's own infrastructure, rather than just having a
> thread walking the block maps calling "queue_work" on each object it
> needs read. Instead it's got counting semaphores,
> start/done/restart/maybe start/maybe stop logic to manage the queue
> depth, etc.
> 

It's been a while since I've looked at that cache prefetch code, but
that makes sense..

> What the above change does is enable us to use workqueues for
> queuing small pieces of work that need to be processed, and allows
> them to be processed concurrently without the caller having to do
> anything to manage that concurrency. This way the concurrency will
> grow automatically to the maximum bound of the workqueue and we
> don't have to worry about doing any extra wakeups or tracking
> anything in workqueue_add...
> 

Also makes sense, but I'm not sure this answers the original question:
why not do this in workqueue_add()? It looks like the current
workqueue_add() does exactly what you describe here in that it only
kicks the worker thread when the initial item is added. The above
explains why that's a problem, but why can't workqueue_add() kick the
worker on every add to a bounded queue (or any queue, if that doesn't
cause problems for !bounded)?

Also, have you considered whether pthread_cond_broadcast() may be more
appropriate than pthread_cond_signal() in the described use case with
multiple workers? The man page for the latter says it "unblocks at least
one of the threads that are blocked on the specified condition
variable," but that isn't exactly the most helpful description. :P

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
