Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6CDC432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 22:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB5072146E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 22:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388541AbfIXWgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 18:36:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59072 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389629AbfIXWgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 18:36:32 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D3DC1363767;
        Wed, 25 Sep 2019 08:36:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iCtQ1-0005xQ-5W; Wed, 25 Sep 2019 08:36:25 +1000
Date:   Wed, 25 Sep 2019 08:36:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: hard limit the background CIL push
Message-ID: <20190924223625.GJ16973@dread.disaster.area>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-3-david@fromorbit.com>
 <20190916164255.GA2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916164255.GA2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=OLKw8n6I55EPgptPfn8A:9
        a=JP6k1ayD4DNY8uaW:21 a=U2o874eqEwj4DYp9:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 09:42:55AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 09, 2019 at 11:51:59AM +1000, Dave Chinner wrote:
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
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 30 +++++++++++++++++++++++++-----
> >  fs/xfs/xfs_log_priv.h |  1 +
> >  2 files changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index ef652abd112c..eec9b32f5e08 100644
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
> > @@ -898,7 +904,7 @@ xlog_cil_push_work(
> >   * checkpoint), but commit latency and memory usage limit this to a smaller
> >   * size.
> >   */
> > -static void
> > +static bool
> >  xlog_cil_push_background(
> >  	struct xlog	*log)
> >  {
> > @@ -915,14 +921,28 @@ xlog_cil_push_background(
> >  	 * space available yet.
> >  	 */
> >  	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> > -		return;
> > +		return false;
> >  
> >  	spin_lock(&cil->xc_push_lock);
> >  	if (cil->xc_push_seq < cil->xc_current_sequence) {
> >  		cil->xc_push_seq = cil->xc_current_sequence;
> >  		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> >  	}
> > +
> > +	/*
> > +	 * If we are well over the space limit, throttle the work that is being
> > +	 * done until the push work on this context has begun. This will prevent
> > +	 * the CIL from violating maximum transaction size limits if the CIL
> > +	 * push is delayed for some reason.
> > +	 */
> > +	if (cil->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log) * 2) {
> > +		up_read(&cil->xc_ctx_lock);
> > +		trace_printk("CIL space used %d", cil->xc_ctx->space_used);
> 
> Needs a real tracepoint before this drops RFC status.

Ok, that was just debugging stuff I forgot to remove, but I can turn
it into a real tracepoint if you want.

> 
> > +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> > +		return true;
> > +	}
> >  	spin_unlock(&cil->xc_push_lock);
> > +	return false;
> >  
> >  }
> >  
> > @@ -1038,9 +1058,8 @@ xfs_log_commit_cil(
> >  		if (lip->li_ops->iop_committing)
> >  			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> >  	}
> > -	xlog_cil_push_background(log);
> > -
> > -	up_read(&cil->xc_ctx_lock);
> > +	if (!xlog_cil_push_background(log))
> > +		up_read(&cil->xc_ctx_lock);
> 
> Hmmmm... the return value here tell us if ctx_lock has been dropped.
> /me wonders if this would be cleaner if xlog_cil_push_background
> returned having called up_read...?

I thought about that - was on the fence about what to do. I'll
change it to be unconditional.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
