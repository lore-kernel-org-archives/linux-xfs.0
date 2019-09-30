Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A53C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB5C120842
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 21:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfI3Vxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 17:53:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54136 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726784AbfI3Vxm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 17:53:42 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9DC4843E507;
        Tue,  1 Oct 2019 07:53:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iF3bs-00054v-O7; Tue, 01 Oct 2019 07:53:36 +1000
Date:   Tue, 1 Oct 2019 07:53:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20190930215336.GR16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930170358.GD57295@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=m1S6xmcsovPORud5T34A:9
        a=XO2GlyMPIpsmX4uH:21 a=BZRvIHGQFGncD-0l:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> On Mon, Sep 30, 2019 at 04:03:44PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In certain situations the background CIL push can be indefinitely
> > delayed. While we have workarounds from the obvious cases now, it
> > doesn't solve the underlying issue. This issue is that there is no
> > upper limit on the CIL where we will either force or wait for
> > a background push to start, hence allowing the CIL to grow without
> > bound until it consumes all log space.
> > 
> > To fix this, add a new wait queue to the CIL which allows background
> > pushes to wait for the CIL context to be switched out. This happens
> > when the push starts, so it will allow us to block incoming
> > transaction commit completion until the push has started. This will
> > only affect processes that are running modifications, and only when
> > the CIL threshold has been significantly overrun.
> > 
> > This has no apparent impact on performance, and doesn't even trigger
> > until over 45 million inodes had been created in a 16-way fsmark
> > test on a 2GB log. That was limiting at 64MB of log space used, so
> > the active CIL size is only about 3% of the total log in that case.
> > The concurrent removal of those files did not trigger the background
> > sleep at all.
> > 
> 
> Have you done similar testing for small/minimum sized logs?

Yes. I've had the tracepoint active during xfstests runs on test
filesystems using default log sizes on 5-15GB filesystems. The only
test in all of xfstests that has triggered it is generic/017, and it
only triggered once.

e.g.

# trace-cmd start -e xfs_log_cil_wait
<run xfstests>
# trace-cmd show
# tracer: nop
#
# entries-in-buffer/entries-written: 1/1   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          xfs_io-2158  [001] ...1   309.285959: xfs_log_cil_wait: dev 8:96 t_ocnt 1 t_cnt 1 t_curr_res 67956 t_unit_res 67956 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 75 grant_reserve_bytes 12878480 grant_write_cycle 75 grant_write_bytes 12878480 curr_cycle 75 curr_block 10448 tail_cycle 75 tail_block 3560
#

And the timestamp matched the time that generic/017 was running.

> Also, if this is so limited in occurrence, had you given any thought to
> something even more simple like flushing the CIL push workqueue when
> over the throttle threshold?

Yes, I've tried that - flush_workqueue() blocks /everything/ until
all the queued work is complete. That means it waits for the CIL to
flush to disk and write a commit record, and every modification in
the filesystem is stopped dead in it's tracks until the CIL push is
complete.

The problem is that flushing workqueues is a synchronous operation,
and it can't wait for partial work completion. We only need to wait
for the CIL context to be swapped out - this is done by the push
code before it starts all the expensive iclog formating and waiting
for iclog space...

> That would wait longer to fill the iclogs,
> but would eliminate the need for another waitqueue that's apparently
> only used for throttling. It may also facilitate reuse of
> xlog_cil_push_now() in the >= XLOG_CIL_SPACE_BLOCKING_LIMIT() case
> (actually, I think this could facilitate the elimination of
> xlog_cil_push_background() entirely).

xlog_cil_push_now() uses flush_work() to push any pending work
before it queues up the CIL flush that the caller is about to wait
for.  i.e. the callers of xlog_cil_push_now() must ensure that all
CIL contexts are flushed for the purposes of a log force as they are
going to wait for all pending CIL flushes to complete. If we've
already pushed the CIL to the sequence that we are asking to push
to, we still have to wait for that previous push to be
done. This is what the flush_work() call in xlog_cil_push_now()
acheives.

> That aside...
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 37 +++++++++++++++++++++++++++++++++----
> >  fs/xfs/xfs_log_priv.h | 24 ++++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h    |  1 +
> >  3 files changed, 58 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index ef652abd112c..4a09d50e1368 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -670,6 +670,11 @@ xlog_cil_push(
> >  	push_seq = cil->xc_push_seq;
> >  	ASSERT(push_seq <= ctx->sequence);
> >  
> > +	/*
> > +	 * Wake up any background push waiters now this context is being pushed.
> > +	 */
> > +	wake_up_all(&ctx->push_wait);
> > +
> >  	/*
> >  	 * Check if we've anything to push. If there is nothing, then we don't
> >  	 * move on to a new sequence number and so we have to be able to push
> > @@ -746,6 +751,7 @@ xlog_cil_push(
> >  	 */
> >  	INIT_LIST_HEAD(&new_ctx->committing);
> >  	INIT_LIST_HEAD(&new_ctx->busy_extents);
> > +	init_waitqueue_head(&new_ctx->push_wait);
> >  	new_ctx->sequence = ctx->sequence + 1;
> >  	new_ctx->cil = cil;
> >  	cil->xc_ctx = new_ctx;
> > @@ -900,7 +906,7 @@ xlog_cil_push_work(
> >   */
> >  static void
> >  xlog_cil_push_background(
> > -	struct xlog	*log)
> > +	struct xlog	*log) __releases(cil->xc_ctx_lock)
> >  {
> >  	struct xfs_cil	*cil = log->l_cilp;
> >  
> > @@ -914,14 +920,36 @@ xlog_cil_push_background(
> >  	 * don't do a background push if we haven't used up all the
> >  	 * space available yet.
> >  	 */
> > -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> > +	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> > +		up_read(&cil->xc_ctx_lock);
> >  		return;
> > +	}
> >  
> >  	spin_lock(&cil->xc_push_lock);
> >  	if (cil->xc_push_seq < cil->xc_current_sequence) {
> >  		cil->xc_push_seq = cil->xc_current_sequence;
> >  		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> >  	}
> > +
> > +	/*
> > +	 * Drop the context lock now, we can't hold that if we need to sleep
> > +	 * because we are over the blocking threshold. The push_lock is still
> > +	 * held, so blocking threshold sleep/wakeup is still correctly
> > +	 * serialised here.
> > +	 */
> > +	up_read(&cil->xc_ctx_lock);
> > +
> > +	/*
> > +	 * If we are well over the space limit, throttle the work that is being
> > +	 * done until the push work on this context has begun.
> > +	 */
> > +	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> 
> Can we use consistent logic with the rest of the function? I.e.
> 
> 	up_read(..);
> 	if (space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> 		spin_unlock(..);
> 		return;
> 	}

I did it this way because code inside the if() statement is
typically pushed out of line by the compiler if it finished with a
return statement (i.e. the compiler makes an "unlikely" static
prediction). Hence it's best to put the slow path code inside thei
if(), not the fast path code.

I can change it, but then we're into ugly likely()/unlikely() macro
territory and I much prefer to structure the code so things like
that are completely unnecessary.

> 
> 	...
> 	xlog_wait(...);
> 
> > +		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> > +		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> > +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> > +		return;
> > +	}
> > +
> 
> Also, I find it slightly annoying that even with all of this locking
> quirkiness we still manage to read ->space_used unprotected (now twice).
> IMO, the simple thing would be to let xlog_cil_insert_items() return the
> size immediately after the current transaction inserts and pass that
> into this function as a parameter.

Yes, I noticed this and thought about it a bit, but it doesn't
really matter if the read is racy. It never really has mattered
because it's not a hard limit where accuracy is vitally important
for correct functioning. Locking and/or atomics are really only
necessary if we care about exact accuracy, but we care only about
avoiding fast path locking overhead as much as possible here.

I'll deal with that in a separate patchset when I have some spare
time.

> > + * To prevent the CIL from overflowing upper commit size bounds, we introduce a
> > + * new threshold at which we block committing transactions until the background
> > + * CIL commit commences and switches to a new context. While this is not a hard
> > + * limit, it forces the process committing a transaction to the CIL to block and
> > + * yeild the CPU, giving the CIL push work a chance to be scheduled and start
> > + * work. This prevents a process running lots of transactions from overfilling
> > + * the CIL because it is not yielding the CPU. We set the blocking limit at
> > + * twice the background push space threshold so we keep in line with the AIL
> > + * push thresholds.
> > + *
> > + * Note: this is not a -hard- limit as blocking is applied after the transaction
> > + * is inserted into the CIL and the push has been triggered. It is largely a
> > + * throttling mechanism that allows the CIL push to be scheduled and run. A hard
> > + * limit will be difficult to implement without introducing global serialisation
> > + * in the CIL commit fast path, and it's not at all clear that we actually need
> > + * such hard limits given the ~7 years we've run without a hard limit before
> > + * finding the first situation where a checkpoint size overflow actually
> > + * occurred. Hence the simple throttle, and an ASSERT check to tell us that
> > + * we've overrun the max size.
> >   */
> 
> I appreciate the extra documentation here, but I think most of the
> second paragraph is better commit log description material than
> something worth lengthening this already huge comment for. I'd suggest
> something like the following, but feel free to rework of course:

Darrick asked for me include some of the information I had in the
commit description directly in the comment, so I did exaclty what he
asked....

>  *
>  * Since the CIL push threshold only triggers a background push, a
>  * second threshold triggers transaction commit blocking until the
>  * background push initiates and switches the CIL context. The blocking
>  * threshold is set to twice the background push threshold to keep in
>  * line with AIL push thresholds. Note that this is not a CIL context
>  * size limit. This is a throttle threshold to slow the growth of the
>  * context and yield the CPU for a background push under overload
>  * conditions.

Sure, but that doesn't tell us *why* it is implemented as a throttle
threshold instead of a hard limit. This text tells us what the code
does, not why it was implemented that way. I'll let darrick decide
on this.

Cheers,

Dave.


>  */
> 
> Brian
> 
> >  #define XLOG_CIL_SPACE_LIMIT(log)	\
> >  	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
> >  
> > +#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
> > +	(XLOG_CIL_SPACE_LIMIT(log) * 2)
> > +
> >  /*
> >   * ticket grant locks, queues and accounting have their own cachlines
> >   * as these are quite hot and can be operated on concurrently.
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index eaae275ed430..e7087ede2662 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1011,6 +1011,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
> > +DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
> >  
> >  DECLARE_EVENT_CLASS(xfs_log_item_class,
> >  	TP_PROTO(struct xfs_log_item *lip),
> > -- 
> > 2.23.0.rc1
> > 
> 

-- 
Dave Chinner
david@fromorbit.com
