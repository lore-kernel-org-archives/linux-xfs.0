Return-Path: <SRS0=zZKn=X3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B042C352AA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 12:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68BF02133F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Oct 2019 12:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfJBMk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Oct 2019 08:40:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfJBMk7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Oct 2019 08:40:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D136018CB8FE;
        Wed,  2 Oct 2019 12:40:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66348194B6;
        Wed,  2 Oct 2019 12:40:58 +0000 (UTC)
Date:   Wed, 2 Oct 2019 08:40:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191002124056.GA2403@bfoster>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001131304.GA62428@bfoster>
 <20191001223107.GT16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001223107.GT16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 02 Oct 2019 12:40:58 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 02, 2019 at 08:31:07AM +1000, Dave Chinner wrote:
> On Tue, Oct 01, 2019 at 09:13:04AM -0400, Brian Foster wrote:
> > On Tue, Oct 01, 2019 at 07:53:36AM +1000, Dave Chinner wrote:
> > > On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> > > > Have you done similar testing for small/minimum sized logs?
> > > 
> > > Yes. I've had the tracepoint active during xfstests runs on test
> > > filesystems using default log sizes on 5-15GB filesystems. The only
> > > test in all of xfstests that has triggered it is generic/017, and it
> > > only triggered once.
> > > 
> > 
> > Ok, interesting. I guess it would be nice if we had a test that somehow
> > or another more effectively exercised this codepath.
> 
> *nod*
> 
> But it's essentially difficult to predict in any way because
> behaviour is not just a function of log size. :/
> 
> > > > Also, if this is so limited in occurrence, had you given any thought to
> > > > something even more simple like flushing the CIL push workqueue when
> > > > over the throttle threshold?
> > > 
> > > Yes, I've tried that - flush_workqueue() blocks /everything/ until
> > > all the queued work is complete. That means it waits for the CIL to
> > > flush to disk and write a commit record, and every modification in
> > > the filesystem is stopped dead in it's tracks until the CIL push is
> > > complete.
> > > 
> > > The problem is that flushing workqueues is a synchronous operation,
> > > and it can't wait for partial work completion. We only need to wait
> > > for the CIL context to be swapped out - this is done by the push
> > > code before it starts all the expensive iclog formating and waiting
> > > for iclog space...
> > > 
> > 
> > I know it waits on the work to complete. I poked around a bit for an
> > interface to "kick" a workqueue, so to speak (as opposed to flush), but
> > I didn't see anything (not surprisingly, since it probably wouldn't be a
> > broadly useful mechanism).
> 
> *nod*
> 
> > That aside, where would this wait on the CIL to flush to disk? AFAICT
> > the only thing that might happen here is log buffer submission. That
> > only happens when the log buffer is full (regardless of the current CIL
> > push writing its commit record). In fact if we did wait on I/O anywhere
> > in here, then that suggests potential problems with async log force.
> 
> There is no such thing as a "async log force". The log force always
> waits on the CIL flush - XFS_LOG_SYNC only defines whether it waits
> on all iclogbufs post CIL flush to hit the disk.
> 

I'm just referring to the semantics/naming of the existing interface. I
suppose I could have used "a log force that doesn't wait on all
iclogbufs to hit the disk," but that doesn't quite roll off the tongue.
;)

> Further, when the CIL flushes, it's normally flushing more metadata that we
> can hold in 8x iclogbufs. The default is 32kB iclogbufs, so if we've
> got more than 256kB of checkpoint data to be written, then we end up
> waiting on iclogbuf completion to write more then 256kB.
> 
> Typically I see a sustainted ratio of roughly 4 iclog writes to 1
> noiclogbufs in the metric graphs on small logs - just measured 700
> log writes/s, 250 noiclogs/s for a 64MB log and 256kB logbuf size.
> IOWs, CIL flushes are regularly waiting in xlog_get_iclog_space() on
> iclog IO completion to occur...
> 

Ok, that's not quite what I was concerned about when you mentioned
waiting on the CIL to flush to disk. No matter, the important bit here
is the performance cost of including the extra blocking on log I/O (to
cycle iclogs back to active for reuse) in the throttle.

I'm curious about how noticeable this extra blocking would be because
it's one likely cause of the CIL pressure buildup in the first place. My
original tests reproduced huge CIL checkpoints purely based on one CIL
push being blocked behind the processing of another, the latter taking
relatively more time due to log I/O.

This is not to say there aren't other causes of excessively sized
checkpoints. Rather, if we're at a point where we've blocked
transactions on this new threshold, that means we've doubled the
background threshold in the time we've first triggered a background CIL
push and the push actually started. From that, it seems fairly likely
that we could replenish the CIL to the background threshold once
threads are unblocked but before the previous push completes.

The question is: can we get all the way to the blocking threshold before
that happens? That doesn't seem unrealistic to me, but it's hard to
reason about without having tested it. If so, I think it means we end up
blocking on completion of the first push to some degree anyways.

> > > > That would wait longer to fill the iclogs,
> > > > but would eliminate the need for another waitqueue that's apparently
> > > > only used for throttling. It may also facilitate reuse of
> > > > xlog_cil_push_now() in the >= XLOG_CIL_SPACE_BLOCKING_LIMIT() case
> > > > (actually, I think this could facilitate the elimination of
> > > > xlog_cil_push_background() entirely).
> > > 
> > > xlog_cil_push_now() uses flush_work() to push any pending work
> > > before it queues up the CIL flush that the caller is about to wait
> > > for.  i.e. the callers of xlog_cil_push_now() must ensure that all
> > > CIL contexts are flushed for the purposes of a log force as they are
> > > going to wait for all pending CIL flushes to complete. If we've
> > > already pushed the CIL to the sequence that we are asking to push
> > > to, we still have to wait for that previous push to be
> > > done. This is what the flush_work() call in xlog_cil_push_now()
> > > acheives.
> > > 
> > 
> > Yes, I'm just exploring potential to reuse this code..
> 
> Yeah, I have a few prototype patches for revamping this, including
> an actual async CIL flush. I do some work here, but it didn't solve
> any of the problems I needed to fix so it put it aside. See below.
> 

That sounds more involved than what I was thinking. My thought is that
this throttle is already not predictable or deterministic (i.e. we're
essentially waiting on a scheduler event) and so might not require the
extra complexity of a new waitqueue. It certainly could be the case that
blocking on the entire push is just too long in practice, but since this
is already based on empirical evidence and subject to unpredictability,
ISTM that testing is the only way to know for sure. For reference, I
hacked up something to reuse xlog_cil_push_now() for background pushing
and throttling that ends up removing 20 or so lines of code by the time
it's in place, but I haven't given it any testing.

That said, this is just an observation and an idea. I'm fine with the
proposed implementation with the other nits and whatnot fixed up.

Brian

> > > > > +	/*
> > > > > +	 * If we are well over the space limit, throttle the work that is being
> > > > > +	 * done until the push work on this context has begun.
> > > > > +	 */
> > > > > +	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> > > > 
> > > > Can we use consistent logic with the rest of the function? I.e.
> > > > 
> > > > 	up_read(..);
> > > > 	if (space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> > > > 		spin_unlock(..);
> > > > 		return;
> > > > 	}
> > > 
> > > I did it this way because code inside the if() statement is
> > > typically pushed out of line by the compiler if it finished with a
> > > return statement (i.e. the compiler makes an "unlikely" static
> > > prediction). Hence it's best to put the slow path code inside thei
> > > if(), not the fast path code.
> > > 
> > 
> > It looks to me that occurs regardless of whether there's a return
> > statement or not. AFAICT, this branching aready happens in the fast exit
> > path of this function as well as for the queue_work() branch. So if it
> > matters that much, perhaps the rest of the function should change
> > appropriately..
> > 
> > > I can change it, but then we're into ugly likely()/unlikely() macro
> > > territory and I much prefer to structure the code so things like
> > > that are completely unnecessary.
> > > 
> > 
> > Hasn't the [un]likely() stuff been considered bogus for a while now?
> 
> Yes, mainly because they are often wrongi and often the compiler and
> hardware do a much better job with static and/or dynamic prediction.
> Nobody ever profiles the branch predictions to check the manual
> annotations are correct and valid, and code can change over time
> meaning the static prediction is wrong...
> 
> > Either way, we're already under spinlock at this point so this isn't a
> > fast exit path. We're talking about branching to an exit path that
> > still requires a function call (i.e. branch) to unlock the spinlock
> > before we return. Combine that with the rest of the function and I'm
> > having a hard time seeing how the factoring affects performance in
> > practice. Maybe it does, but I guess I'd want to see some data to grok
> > that the very least.
> 
> I'm not wedded to a specific layout, just explaining the reasoning.
> I'll change it for the next revision...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: Don't block tail pushing on CIL forces
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When AIL tail pushing encounters a pinned item, it forces the log
> and waits for it to complete before it starts walking items again.
> However, in forcing the log it waits for all the dirty objects in
> memory to be written to the log, hence waiting for (potentially) a
> lot of log IO to complete when the CIL contains thousands of dirty
> objects. This can block processing of the AIL for seconds and
> prevent the tail of the log from being moved forward while the AIL
> is blocked.
> 
> To prevent the log tail pushing from waiting on log flushes, just
> trigger a CIL push from the xfsaild instead of a full log force.
> This will get the majority of the items pinned moving via teh CIL
> workqueue and so won't cause the xfsaild to wait for it to complete
> before it can do it's own work.
> 
> Further, the AIL has it's own backoff waits, so move the CIL push
> to before the AIL backoff wait rather than afterwards, so the CIL
> has time to do some work before the AIL will start scanning again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c   | 13 ++++++++-----
>  fs/xfs/xfs_log_priv.h  | 22 ++++++++++++++++++----
>  fs/xfs/xfs_trans_ail.c | 29 +++++++++++++++--------------
>  3 files changed, 41 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2f4cfd5b707e..a713f58e9e86 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -931,7 +931,7 @@ xlog_cil_push_background(
>   * @push_seq, but it won't be completed. The caller is expected to do any
>   * waiting for push_seq to complete if it is required.
>   */
> -static void
> +void
>  xlog_cil_push_now(
>  	struct xlog	*log,
>  	xfs_lsn_t	push_seq)
> @@ -941,21 +941,24 @@ xlog_cil_push_now(
>  	if (!cil)
>  		return;
>  
> -	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
> -
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> -	 * there's no work we need to do.
> +	 * there's no work we need to do. If push_seq is not set, someone is
> +	 * just giving us the hurry up (e.g. to unpin objects without otherwise
> +	 * waiting on completion) so just push the current context.
>  	 */
>  	spin_lock(&cil->xc_push_lock);
> +	if (!push_seq)
> +		push_seq = cil->xc_current_sequence;
> +
>  	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
>  
>  	cil->xc_push_seq = push_seq;
> -	spin_unlock(&cil->xc_push_lock);
>  	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> +	spin_unlock(&cil->xc_push_lock);
>  }
>  
>  bool
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f66043853310..7842f923b3a1 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -520,11 +520,25 @@ bool	xlog_cil_empty(struct xlog *log);
>  
>  /*
>   * CIL force routines
> + *
> + * If you just want to schedule a CIL context flush to get things moving but
> + * not wait for anything (not an integrity operation!), use
> + *
> + *		xlog_cil_push_now(log, 0);
> + *
> + * Blocking or integrity based CIL forces should not be called directly, but
> + * instead be marshalled through xfs_log_force(). i.e. if you want to:
> + *
> + *	- flush and wait for the entire CIL to be submitted to the log, use
> + *		xfs_log_force(mp, 0);
> + *
> + *	- flush and wait for the CIL to be stable on disk and all items to be
> + *	  inserted into the AIL, use
> + *		xfs_log_force(mp, XFS_LOG_SYNC);
>   */
> -xfs_lsn_t
> -xlog_cil_force_lsn(
> -	struct xlog *log,
> -	xfs_lsn_t sequence);
> +void xlog_cil_push_now(struct xlog *log, xfs_lsn_t sequence);
> +
> +xfs_lsn_t xlog_cil_force_lsn(struct xlog *log, xfs_lsn_t sequence);
>  
>  static inline void
>  xlog_cil_force(struct xlog *log)
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 5802139f786b..c9d8d05c3594 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -13,6 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_trace.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> @@ -381,20 +382,6 @@ xfsaild_push(
>  	int			flushing = 0;
>  	int			count = 0;
>  
> -	/*
> -	 * If we encountered pinned items or did not finish writing out all
> -	 * buffers the last time we ran, force the log first and wait for it
> -	 * before pushing again.
> -	 */
> -	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
> -	    (!list_empty_careful(&ailp->ail_buf_list) ||
> -	     xfs_ail_min_lsn(ailp))) {
> -		ailp->ail_log_flush = 0;
> -
> -		XFS_STATS_INC(mp, xs_push_ail_flush);
> -		xfs_log_force(mp, XFS_LOG_SYNC);
> -	}
> -
>  	spin_lock(&ailp->ail_lock);
>  
>  	/* barrier matches the ail_target update in xfs_ail_push() */
> @@ -528,6 +515,20 @@ xfsaild_push(
>  		tout = 10;
>  	}
>  
> +	/*
> +	 * If we encountered pinned items or did not finish writing out all
> +	 * buffers the last time we ran, give the CIL a nudge to start
> +	 * unpinning the blocked items while we wait for a while...
> +	 */
> +	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
> +	    (!list_empty_careful(&ailp->ail_buf_list) ||
> +	     xfs_ail_min_lsn(ailp))) {
> +		ailp->ail_log_flush = 0;
> +
> +		XFS_STATS_INC(mp, xs_push_ail_flush);
> +		xlog_cil_push_now(mp->m_log, 0);
> +	}
> +
>  	return tout;
>  }
>  
