Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3704C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 23:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F26613E4
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 23:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFBXtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 19:49:51 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41745 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhFBXtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 19:49:50 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5DC2080ACA6;
        Thu,  3 Jun 2021 09:47:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loaaR-008HNQ-Ei; Thu, 03 Jun 2021 09:47:47 +1000
Date:   Thu, 3 Jun 2021 09:47:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/39] xfs: implement percpu cil space used calculation
Message-ID: <20210602234747.GY664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-31-david@fromorbit.com>
 <20210527184121.GM202144@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527184121.GM202144@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=CvLPHAObR4kuEECnKC0A:9 a=OUczCybpxjvJcYIB:21 a=HRNJJQIf49I5UGVb:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 11:41:21AM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have the CIL percpu structures in place, implement the
> > space used counter with a fast sum check similar to the
> > percpu_counter infrastructure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 61 ++++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/xfs_log_priv.h |  2 +-
> >  2 files changed, 55 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index ba1c6979a4c7..72693fba929b 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -76,6 +76,24 @@ xlog_cil_ctx_alloc(void)
> >  	return ctx;
> >  }
> >  
> > +/*
> > + * Aggregate the CIL per cpu structures into global counts, lists, etc and
> > + * clear the percpu state ready for the next context to use.
> > + */
> > +static void
> > +xlog_cil_pcp_aggregate(
> > +	struct xfs_cil		*cil,
> > +	struct xfs_cil_ctx	*ctx)
> > +{
> > +	struct xlog_cil_pcp	*cilpcp;
> > +	int			cpu;
> > +
> > +	for_each_online_cpu(cpu) {
> > +		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> > +		cilpcp->space_used = 0;
> 
> How does this aggregate anything?  All I see here is zeroing a counter?

Yup, zeroing all the percpu counters is an aggregation function....

By definition "aggregate != sum".

An aggregate is formed by the collection of discrete units into a
larger whole; the collective definition involves manipulating all
discrete units as a single whole entity. e.g. a percpu counter is
an aggregate of percpu variables that, via aggregation, can sum the
discrete variables into a single value. IOWs, percpu_counter_sum()
is an aggregation function that sums...

> I see that we /can/ add the percpu space_used counter to the cil context
> if we're over the space limits, but I don't actually see where...

In this case, the global CIL space used counter is summed by the
per-cpu counter update context and not an aggregation context. For
it to work as a global counter since a distinct point in time, it
needs an aggregation operation that zeros all the discrete units of
the counter at a single point in time. IOWs, the aggregation
function of this counter is a zeroing operation, not a summing
operation. This is what xlog_cil_pcp_aggregate() is doing here.

Put simply, an aggregation function is not a summing function, but a
function that operates on all the discrete units of the
aggregate so that it can operate correctly as a single unit....

I don't know of a better way of describing what this function does.
At the end of the series, this function will zero some units. In
other cases it will sum units. In some cases it will do both. Not to
mention that it will merge discrete lists into a global list. And so
on. The only common thing between these operations is that they are
all aggregation functions that allow the CIL context to operate as a
whole unit...

If you've got a better name, then I'm all ears :)

....

> > @@ -480,16 +501,34 @@ xlog_cil_insert_items(
> >  		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
> >  	}
> >  
> > +	/*
> > +	 * Update the CIL percpu pointer. This updates the global counter when
> > +	 * over the percpu batch size or when the CIL is over the space limit.
> > +	 * This means low lock overhead for normal updates, and when over the
> > +	 * limit the space used is immediately accounted. This makes enforcing
> > +	 * the hard limit much more accurate. The per cpu fold threshold is
> > +	 * based on how close we are to the hard limit.
> > +	 */
> > +	cilpcp = get_cpu_ptr(cil->xc_pcp);
> > +	cilpcp->space_used += len;
> > +	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
> > +	    cilpcp->space_used >
> > +			((XLOG_CIL_BLOCKING_SPACE_LIMIT(log) - space_used) /
> > +					num_online_cpus())) {
> > +		atomic_add(cilpcp->space_used, &ctx->space_used);
> > +		cilpcp->space_used = 0;
> > +	}
> > +	put_cpu_ptr(cilpcp);
> > +
> >  	spin_lock(&cil->xc_cil_lock);
> > -	tp->t_ticket->t_curr_res -= ctx_res + len;
> >  	ctx->ticket->t_unit_res += ctx_res;
> >  	ctx->ticket->t_curr_res += ctx_res;
> > -	ctx->space_used += len;
> 
> ...this update happens if we're not over the space limit?

It's the second case in the above if statement. As the space used in
the percpu pointer goes over it's fraction of the remaining space
limit (limit remaining / num_cpus_online), then it adds the
pcp counter back into the global counter. Essentially it is:

	if (over push threshold ||
>>>>>>	    pcp->used > ((hard limit - ctx->space_used) / cpus)) {
		ctx->space_used += pcp->used;
		pcp->used = 0;
	}

Hence, to begin with, the percpu counter is allowed to sum a large
chunk of space before it trips the per CPU summing threshold. When
summing occurs, the per-cpu threshold goes down, meaning there pcp
counters will trip sooner in the next cycle.

IOWs, the summing threshold gets closer to zero the closer the
global count gets to the hard limit. Hence when there's lots of
space available, we have little summing contention, but when we
are close to the blocking limit we essentially update the global
counter on every modification.

As such, we get scalability when the CIL is empty by trading off
accuracy, but we get accuracy when it is nearing full by trading off
scalability. We might need to tweak it for really large CPU counts
(maybe use log2(num_online_cpus()), but fundamentally the algorithm
is designed to scale according to how close we are to the push
thresholds....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
