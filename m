Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A77C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3FC64EE9
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCLCS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:18:26 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38105 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhCLCSF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 21:18:05 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7BCDD1041202;
        Fri, 12 Mar 2021 13:18:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKXNK-001Ush-FZ; Fri, 12 Mar 2021 13:18:02 +1100
Date:   Fri, 12 Mar 2021 13:18:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/45] xfs: convert CIL to unordered per cpu lists
Message-ID: <20210312021802.GI63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-41-david@fromorbit.com>
 <20210311011505.GN3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311011505.GN3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=LeHXpyoGwPcjRiw2vpIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 05:15:05PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:38PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So that we can remove the cil_lock which is a global serialisation
> > point. We've already got ordering sorted, so all we need to do is
> > treat the CIL list like the busy extent list and reconstruct it
> > before the push starts.
....
> > @@ -530,7 +511,6 @@ xlog_cil_insert_items(
> >  	 * the transaction commit.
> >  	 */
> >  	order = atomic_inc_return(&ctx->order_id);
> > -	spin_lock(&cil->xc_cil_lock);
> >  	list_for_each_entry(lip, &tp->t_items, li_trans) {
> >  
> >  		/* Skip items which aren't dirty in this transaction. */
> > @@ -540,10 +520,26 @@ xlog_cil_insert_items(
> >  		lip->li_order_id = order;
> >  		if (!list_empty(&lip->li_cil))
> >  			continue;
> > -		list_add(&lip->li_cil, &cil->xc_cil);
> > +		list_add(&lip->li_cil, &cilpcp->log_items);
> 
> Ok, so if I understand this correctly -- every time a transaction
> commits, it marks every dirty log item with a monotonically increasing
> counter.  If the log item isn't already on another CPU's CIL list, it
> gets added to the current CPU's CIL list...

Correct.

> > +	}
> > +	put_cpu_ptr(cilpcp);
> > +
> > +	/*
> > +	 * If we've overrun the reservation, dump the tx details before we move
> > +	 * the log items. Shutdown is imminent...
> > +	 */
> > +	tp->t_ticket->t_curr_res -= ctx_res + len;
> > +	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
> > +		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
> > +		xfs_warn(log->l_mp,
> > +			 "  log items: %d bytes (iov hdrs: %d bytes)",
> > +			 len, iovhdr_res);
> > +		xfs_warn(log->l_mp, "  split region headers: %d bytes",
> > +			 split_res);
> > +		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
> > +		xlog_print_trans(tp);
> >  	}
> >  
> > -	spin_unlock(&cil->xc_cil_lock);
> >  
> >  	if (tp->t_ticket->t_curr_res < 0)
> >  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> > @@ -806,6 +802,7 @@ xlog_cil_push_work(
> >  	bool			commit_iclog_sync = false;
> >  	int			cpu;
> >  	struct xlog_cil_pcp	*cilpcp;
> > +	LIST_HEAD		(log_items);
> >  
> >  	new_ctx = xlog_cil_ctx_alloc();
> >  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> > @@ -822,6 +819,9 @@ xlog_cil_push_work(
> >  			list_splice_init(&cilpcp->busy_extents,
> >  					&ctx->busy_extents);
> >  		}
> > +		if (!list_empty(&cilpcp->log_items)) {
> > +			list_splice_init(&cilpcp->log_items, &log_items);
> 
> ...and then at CIL push time, we splice each per-CPU list into a big
> list, sort the dirty log items by counter number, and process them.

Yup, that's pretty much it. I'm replacing insert time ordering with
push-time ordering to get rid of the serialisation overhead of
insert time ordering.

> The first thought I had was that it's a darn shame that _insert_items
> can't steal a log item from another CPU's CIL list, because you could
> then mergesort the per-CPU CIL lists into @log_items.  Unfortunately, I
> don't think there's a safe way to steal items from a per-CPU list
> without involving locks.

Yeah, it needs locks because we then have to serialise local inserts
with remote removals. It can be done fairly easily - I just need to
replace the "order ID" field with the CPU ID of the list it is on.

The problem is that relogging happens a lot, so in some workloads we
might be bouncing a set of commonly accessed log items around CPUs
frequently. That said, I'm not sure this would end up a huge
problem, but it still needs a mergesort to be performed in the push
code...

> The second thought I had was that we have the xfs_pwork mechanism for
> launching a bunch of worker threads.  A pwork workqueue is (probably)
> too costly when the item list is short or there aren't that many CPUs,
> but once list_sort starts getting painful, would it be faster to launch
> a bunch of threads in push_work to sort each per-CPU list and then merge
> sort them into the final list?

Not sure, because now you have N work threads competing with the
userspace workload for CPU to do maybe 10ms of work. The scheduling
latency when the system is CPU bound is likely to introduce more
latency than you save by spreading the work out....

I've largely put these sorts of questions aside because optimising
this code further can be done later. The code as it stands doubles
the throughput of the commit path and I don't think that further
optimisation is immediately necessary. Ensuring that the splitting
and recombining of the lists still results in correctly ordered log
items is more important right now, and I think it does that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
