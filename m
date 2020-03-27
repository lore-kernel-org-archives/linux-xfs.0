Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1296C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 00:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F2420719
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 00:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgC0AkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 20:40:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55530 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgC0AkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 20:40:06 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 035347EBA49;
        Fri, 27 Mar 2020 11:40:02 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHd2X-0006GX-Mn; Fri, 27 Mar 2020 11:40:01 +1100
Date:   Fri, 27 Mar 2020 11:40:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: Throttle commits on delayed background CIL push
Message-ID: <20200327004001.GO10776@dread.disaster.area>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-3-david@fromorbit.com>
 <20200326052435.GK29351@magnolia>
 <20200326113358.GC19262@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326113358.GC19262@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=RTNtLFkZ65nuxMM6XqYA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 07:33:58AM -0400, Brian Foster wrote:
> On Wed, Mar 25, 2020 at 10:24:35PM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 25, 2020 at 12:41:59PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > In certain situations the background CIL push can be indefinitely
> > > delayed. While we have workarounds from the obvious cases now, it
> > > doesn't solve the underlying issue. This issue is that there is no
> > > upper limit on the CIL where we will either force or wait for
> > > a background push to start, hence allowing the CIL to grow without
> > > bound until it consumes all log space.
> > > 
> > > To fix this, add a new wait queue to the CIL which allows background
> > > pushes to wait for the CIL context to be switched out. This happens
> > > when the push starts, so it will allow us to block incoming
> > > transaction commit completion until the push has started. This will
> > > only affect processes that are running modifications, and only when
> > > the CIL threshold has been significantly overrun.
> > > 
> > > This has no apparent impact on performance, and doesn't even trigger
> > > until over 45 million inodes had been created in a 16-way fsmark
> > > test on a 2GB log. That was limiting at 64MB of log space used, so
> > > the active CIL size is only about 3% of the total log in that case.
> > > The concurrent removal of those files did not trigger the background
> > > sleep at all.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > This looks reasonable to me, though considering the big long thread that
> > erupted a few versions ago I'm seriously wondering what he thinks of all
> > this?
> > 
> 
> Hmmmm... this was my reply to the last post of this one:
> 
> https://lore.kernel.org/linux-xfs/20191101120426.GC59146@bfoster/
> 
> ... so I suspect that would still be my feedback if this patch wasn't
> fixed up..? ;)

Which actually took me some time to find because that email just
points some other email.... :/

I think in the end, that entire discussion ended up at two things
once the behaviour of the throttle was iterated over and agreed upon
as a decent compromise. I'll summarise below in line.


> > > @@ -905,14 +911,36 @@ xlog_cil_push_background(
> > >  	 * don't do a background push if we haven't used up all the
> > >  	 * space available yet.
> > >  	 */
> > > -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> > > +	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> > > +		up_read(&cil->xc_ctx_lock);
> > >  		return;
> > > +	}
> > >  
> > >  	spin_lock(&cil->xc_push_lock);
> > >  	if (cil->xc_push_seq < cil->xc_current_sequence) {
> > >  		cil->xc_push_seq = cil->xc_current_sequence;
> > >  		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> > >  	}
> > > +
> > > +	/*
> > > +	 * Drop the context lock now, we can't hold that if we need to sleep
> > > +	 * because we are over the blocking threshold. The push_lock is still
> > > +	 * held, so blocking threshold sleep/wakeup is still correctly
> > > +	 * serialised here.
> > > +	 */
> > > +	up_read(&cil->xc_ctx_lock);
> > > +
> > > +	/*
> > > +	 * If we are well over the space limit, throttle the work that is being
> > > +	 * done until the push work on this context has begun.
> > > +	 */
> > > +	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> > > +		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> > > +		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> > > +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> > > +		return;
> > > +	}

Biran asked to change this to a "<" check and switch the code in the
branch and the function tail around. The code is not wrong or
inconsistent with other code, and the change doesn't result in a
reduction of code, just a different layout.

OTOH, personal taste on my side is to prefer to keep lock/unlock
pairs at the same indent level so at a glance it is obvious that
they are paired and balanced.

IOWs, this is just a question of personal taste...

> > > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > > index 8c4be91f62d0d..dacab1817a1b0 100644
> > > --- a/fs/xfs/xfs_log_priv.h
> > > +++ b/fs/xfs/xfs_log_priv.h
> > > @@ -240,6 +240,7 @@ struct xfs_cil_ctx {
> > >  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
> > >  	struct list_head	iclog_entry;
> > >  	struct list_head	committing;	/* ctx committing list */
> > > +	wait_queue_head_t	push_wait;	/* background push throttle */
> > >  	struct work_struct	discard_endio_work;
> > >  };
> > >  
> > > @@ -337,10 +338,33 @@ struct xfs_cil {
> > >   *   buffer window (32MB) as measurements have shown this to be roughly the
> > >   *   point of diminishing performance increases under highly concurrent
> > >   *   modification workloads.
> > > + *
> > > + * To prevent the CIL from overflowing upper commit size bounds, we introduce a
> > > + * new threshold at which we block committing transactions until the background
> > > + * CIL commit commences and switches to a new context. While this is not a hard
> > > + * limit, it forces the process committing a transaction to the CIL to block and
> > > + * yeild the CPU, giving the CIL push work a chance to be scheduled and start
> > > + * work. This prevents a process running lots of transactions from overfilling
> > > + * the CIL because it is not yielding the CPU. We set the blocking limit at
> > > + * twice the background push space threshold so we keep in line with the AIL
> > > + * push thresholds.
> > > + *
> > > + * Note: this is not a -hard- limit as blocking is applied after the transaction
> > > + * is inserted into the CIL and the push has been triggered. It is largely a
> > > + * throttling mechanism that allows the CIL push to be scheduled and run. A hard
> > > + * limit will be difficult to implement without introducing global serialisation
> > > + * in the CIL commit fast path, and it's not at all clear that we actually need
> > > + * such hard limits given the ~7 years we've run without a hard limit before
> > > + * finding the first situation where a checkpoint size overflow actually
> > > + * occurred. Hence the simple throttle, and an ASSERT check to tell us that
> > > + * we've overrun the max size.
> > >   */

Brian also asked for this note to be removed and put into the commit
message, which I had pulled out of the commit message and put into
the code because someone else requested that....

https://lore.kernel.org/linux-xfs/20190916163325.GZ2229799@magnolia/

So, when personal tastes collide, the submitter has to choose
between them. When review comments conflict, the submitter has
to choose between them.

I chose not to modify the patch, and that's the long and short of
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
