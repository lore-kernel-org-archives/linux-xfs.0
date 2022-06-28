Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACD5C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiF1Xwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1Xwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:52:53 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1996E393F9
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:52:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 13AA410E7814;
        Wed, 29 Jun 2022 09:52:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6L0j-00CGEo-GN; Wed, 29 Jun 2022 09:52:49 +1000
Date:   Wed, 29 Jun 2022 09:52:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: implement percpu cil space used calculation
Message-ID: <20220628235249.GW227878@dread.disaster.area>
References: <20220615075330.3651541-1-david@fromorbit.com>
 <20220615075330.3651541-6-david@fromorbit.com>
 <YrteGNbRaCqLOY6g@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrteGNbRaCqLOY6g@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb9453
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=vGz2FzdIwsLSWSQPdeAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:01:28PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 15, 2022 at 05:53:21PM +1000, Dave Chinner wrote:
> > +/*
> > + * Aggregate the CIL per-cpu space used counters into the global atomic value.
> > + * This is called when the per-cpu counter aggregation will first pass the soft
> > + * limit threshold so we can switch to atomic counter aggregation for accurate
> > + * detection of hard limit traversal.
> > + */
> > +static void
> > +xlog_cil_insert_pcp_aggregate(
> > +	struct xfs_cil		*cil,
> > +	struct xfs_cil_ctx	*ctx)
> > +{
> > +	struct xlog_cil_pcp	*cilpcp;
> > +	int			cpu;
> > +	int			count = 0;
> > +
> > +	/* Trigger atomic updates then aggregate only for the first caller */
> > +	if (!test_and_clear_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags))
> 
> Hmm, this patch has changed a bit since the last time I looked at it.
> 
> Last time, IIRC, each CIL context gets a certain amount of space, and
> then you split that space evenly among the running CPUs; after we hit
> certain thresholds (the overall cil context has used more than the
> background push threshold; or this cpu's cil context has used more space
> than blocking push threshold divided by cpu count) we make everyone use
> the slow accounting.  Now I guess you've changed it a bit...

Yes, the previous version still tried to use per-cpu counters once
over the soft limit, but this had issues with:

- the wrong limit being used to calculate per-cpu count aggregate
  limits (used hard limit instead of soft)
- couldn't take into account the amount of space accounted to other
  CPUs when trying to detect hard limit excursions

The combination of the two could lead to the per-cpu aggregate
counts being 2x the difference between the soft and hard limits, so
it could blow through both the soft limit and the hard limit
without it being noticed that the thresholds had been exceeded.
This then caused problems with the over-hard limit reservation
mechanism to ensure that the CIL didn't run out of reservation for
header space. This was the problem that the hotplug CPU test kept
tripping over - the CIL would run out of reservation as CPUs came
and went, but the underlying problem was that the hard threshold
wasn't being detected accurately.

Hence the mechanism now runs fast (via per-cpu segment aggregation)
until the soft limit is exceeded, which then transitions all updates
to global atomic aggregation update until the hard limit is hit.
This means that by the time hard limit is reached, we've drained
all the per-cpu counters and all calculations and threshold
detections are performed on the atomic counter that everything is
now updating.

> > @@ -512,29 +609,31 @@ xlog_cil_insert_items(
> >  		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
> >  	}
> >  
> > -	spin_lock(&cil->xc_cil_lock);
> > -	tp->t_ticket->t_curr_res -= ctx_res + len;
> > -	ctx->ticket->t_unit_res += ctx_res;
> > -	ctx->ticket->t_curr_res += ctx_res;
> > -	ctx->space_used += len;
> > -
> > -	tp->t_ticket->t_curr_res += released_space;
> > -	ctx->space_used -= released_space;
> > -
> >  	/*
> > -	 * If we've overrun the reservation, dump the tx details before we move
> > -	 * the log items. Shutdown is imminent...
> > +	 * Accurately account when over the soft limit, otherwise fold the
> > +	 * percpu count into the global count if over the per-cpu threshold.
> >  	 */
> > -	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
> > -		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
> > -		xfs_warn(log->l_mp,
> > -			 "  log items: %d bytes (iov hdrs: %d bytes)",
> > -			 len, iovhdr_res);
> > -		xfs_warn(log->l_mp, "  split region headers: %d bytes",
> > -			 split_res);
> > -		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
> > -		xlog_print_trans(tp);
> > +	if (!test_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags)) {
> > +		atomic_add(len, &ctx->space_used);
> > +	} else if (cilpcp->space_used + len >
> > +			(XLOG_CIL_SPACE_LIMIT(log) / num_online_cpus())) {
> > +		space_used = atomic_add_return(cilpcp->space_used + len,
> > +						&ctx->space_used);
> > +		cilpcp->space_used = 0;
> > +
> > +		/*
> > +		 * If we just transitioned over the soft limit, we need to
> > +		 * transition to the global atomic counter.
> > +		 */
> > +		if (space_used >= XLOG_CIL_SPACE_LIMIT(log))
> > +			xlog_cil_insert_pcp_aggregate(cil, ctx);
> > +	} else {
> > +		cilpcp->space_used += len;
> >  	}
> 
> ...so I guess if the PCP_SPACE bit is cleared, everybody gets to do the
> slow accounting,

Yes.

> and if this cpu's cil context has used more than its
> share of the blocking push threshold, then we transition everyone to the
> slow paths until the next context.  Right?

Not quite - if this CPU's cil context has used more than it's share,
we aggregate the count and then check if we are over the soft limit.
If we are over the soft limit, we turn off per-cpu accounting for
everyone immediately and aggregate the per-cpu counts back into the
global counter.

The result is that, for the most part, we run with per-cpu counters
under the soft limit and only fall back to atomic counters after
we've already scheduled the background push to drain the CIL.

> If I've grokked all that, then
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
