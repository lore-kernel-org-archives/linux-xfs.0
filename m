Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F77C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504652073E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cl5TMzJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgCZLeO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 07:34:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41177 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbgCZLeO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 07:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585222452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JN3AVebuD/n9mqrTuvHUaYoffSbAKY/v2fWXI2tdvCU=;
        b=cl5TMzJgMvtvodInaKmbQQw2xe0u/JuzIVwgZ9jPP3Pcnsb4m1qlK4bN8YuQcuUflfW0Y2
        U1pe2p5Eh67iiT05mFML1pK6RL0nsGiGNRtOl2vBPQlllRs+fNBVVSJWjZhA65+SuqMhMe
        1irGILNPLMpVMQPF9GZXflQ6VLXPNrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-1iKRgA6UN_61thrtu7QJ8Q-1; Thu, 26 Mar 2020 07:34:07 -0400
X-MC-Unique: 1iKRgA6UN_61thrtu7QJ8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0205A101FC90;
        Thu, 26 Mar 2020 11:34:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A78D5C241;
        Thu, 26 Mar 2020 11:34:00 +0000 (UTC)
Date:   Thu, 26 Mar 2020 07:33:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: Throttle commits on delayed background CIL push
Message-ID: <20200326113358.GC19262@bfoster>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-3-david@fromorbit.com>
 <20200326052435.GK29351@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326052435.GK29351@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 10:24:35PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 25, 2020 at 12:41:59PM +1100, Dave Chinner wrote:
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
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> This looks reasonable to me, though considering the big long thread that
> erupted a few versions ago I'm seriously wondering what he thinks of all
> this?
> 

Hmmmm... this was my reply to the last post of this one:

https://lore.kernel.org/linux-xfs/20191101120426.GC59146@bfoster/

... so I suspect that would still be my feedback if this patch wasn't
fixed up..? ;)

Brian

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_log_cil.c  | 37 +++++++++++++++++++++++++++++++++----
> >  fs/xfs/xfs_log_priv.h | 24 ++++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h    |  1 +
> >  3 files changed, 58 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 27de462d2ba40..ac43301ae2f43 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -668,6 +668,11 @@ xlog_cil_push_work(
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
> > @@ -744,6 +749,7 @@ xlog_cil_push_work(
> >  	 */
> >  	INIT_LIST_HEAD(&new_ctx->committing);
> >  	INIT_LIST_HEAD(&new_ctx->busy_extents);
> > +	init_waitqueue_head(&new_ctx->push_wait);
> >  	new_ctx->sequence = ctx->sequence + 1;
> >  	new_ctx->cil = cil;
> >  	cil->xc_ctx = new_ctx;
> > @@ -891,7 +897,7 @@ xlog_cil_push_work(
> >   */
> >  static void
> >  xlog_cil_push_background(
> > -	struct xlog	*log)
> > +	struct xlog	*log) __releases(cil->xc_ctx_lock)
> >  {
> >  	struct xfs_cil	*cil = log->l_cilp;
> >  
> > @@ -905,14 +911,36 @@ xlog_cil_push_background(
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
> > +		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> > +		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> > +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> > +		return;
> > +	}
> > +
> >  	spin_unlock(&cil->xc_push_lock);
> >  
> >  }
> > @@ -1032,9 +1060,9 @@ xfs_log_commit_cil(
> >  		if (lip->li_ops->iop_committing)
> >  			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> >  	}
> > -	xlog_cil_push_background(log);
> >  
> > -	up_read(&cil->xc_ctx_lock);
> > +	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
> > +	xlog_cil_push_background(log);
> >  }
> >  
> >  /*
> > @@ -1193,6 +1221,7 @@ xlog_cil_init(
> >  
> >  	INIT_LIST_HEAD(&ctx->committing);
> >  	INIT_LIST_HEAD(&ctx->busy_extents);
> > +	init_waitqueue_head(&ctx->push_wait);
> >  	ctx->sequence = 1;
> >  	ctx->cil = cil;
> >  	cil->xc_ctx = ctx;
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index 8c4be91f62d0d..dacab1817a1b0 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -240,6 +240,7 @@ struct xfs_cil_ctx {
> >  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
> >  	struct list_head	iclog_entry;
> >  	struct list_head	committing;	/* ctx committing list */
> > +	wait_queue_head_t	push_wait;	/* background push throttle */
> >  	struct work_struct	discard_endio_work;
> >  };
> >  
> > @@ -337,10 +338,33 @@ struct xfs_cil {
> >   *   buffer window (32MB) as measurements have shown this to be roughly the
> >   *   point of diminishing performance increases under highly concurrent
> >   *   modification workloads.
> > + *
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
> > index fbfdd9cf160df..575ca74532f79 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1015,6 +1015,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_sub);
> >  DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_exit);
> > +DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
> >  
> >  DECLARE_EVENT_CLASS(xfs_log_item_class,
> >  	TP_PROTO(struct xfs_log_item *lip),
> > -- 
> > 2.26.0.rc2
> > 
> 

