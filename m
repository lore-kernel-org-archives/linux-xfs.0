Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E73C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18540206F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgELXgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:36:33 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60281 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgELXgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:36:33 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 88FD2108182;
        Wed, 13 May 2020 09:36:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYeRo-0000td-0F; Wed, 13 May 2020 09:36:28 +1000
Date:   Wed, 13 May 2020 09:36:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context
 counters
Message-ID: <20200512233627.GW2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-4-david@fromorbit.com>
 <20200512140544.GD37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200512140544.GD37029@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=IkcTkHD0fZMA:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Jz_xeEo1jXWets6QGoIA:9 a=xlsfCXzl7EKKGtjn:21 a=9n6JtNEmpB9VAvcK:21
        a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 10:05:44AM -0400, Brian Foster wrote:
> On Tue, May 12, 2020 at 07:28:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the m_active_trans atomic bottleneck out of the way, the CIL
> > xc_cil_lock is the next bottleneck that causes cacheline contention.
> > This protects several things, the first of which is the CIL context
> > reservation ticket and space usage counters.
> > 
> > We can lift them out of the xc_cil_lock by converting them to
> > percpu counters. THis involves two things, the first of which is
> > lifting calculations and samples that don't actually need protecting
> > from races outside the xc_cil lock.
> > 
> > The second is converting the counters to percpu counters and lifting
> > them outside the lock. This requires a couple of tricky things to
> > minimise initial state races and to ensure we take into account
> > split reservations. We do this by erring on the "take the
> > reservation just in case" side, which largely lost in the noise of
> > many frequent large transactions.
> > 
> > We use a trick with percpu_counter_add_batch() to ensure the global
> > sum is updated immediately on first reservation, hence allowing us
> > to use fast counter reads everywhere to determine if the CIL is
> > empty or not, rather than using the list itself. This is important
> > for later patches where the CIL is moved to percpu lists
> > and hence cannot use list_empty() to detect an empty CIL. Hence we
> > provide a low overhead, lockless mechanism for determining if the
> > CIL is empty or not via this mechanisms. All other percpu counter
> > updates use a large batch count so they aggregate on the local CPU
> > and minimise global sum updates.
> > 
> > The xc_ctx_lock rwsem protects draining the percpu counters to the
> > context's ticket, similar to the way it allows access to the CIL
> > without using the xc_cil_lock. i.e. the CIL push has exclusive
> > access to the CIL, the context and the percpu counters while holding
> > the xc_ctx_lock. This ensures that we can sum and zero the counters
> > atomically from the perspective of the transaction commit side of
> > the push. i.e. they reset to zero atomically with the CIL context
> > swap and hence we don't need to have the percpu counters attached to
> > the CIL context.
> > 
> > Performance wise, this increases the transaction rate from
> > ~620,000/s to around 750,000/second. Using a 32-way concurrent
> > create instead of 16-way on a 32p/16GB virtual machine:
> > 
> > 		create time	rate		unlink time
> > unpatched	  2m03s      472k/s+/-9k/s	 3m6s
> > patched		  1m56s	     533k/s+/-28k/s	 2m34
> > 
> > Notably, the system time for the create went from 44m20s down to
> > 38m37s, whilst going faster. There is more variance, but I think
> > that is from the cacheline contention having inconsistent overhead.
> > 
> > XXX: probably should split into two patches
> > 
> 
> Yes please. :)
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 99 ++++++++++++++++++++++++++++++-------------
> >  fs/xfs/xfs_log_priv.h |  2 +
> >  2 files changed, 72 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index b43f0e8f43f2e..746c841757ed1 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -393,7 +393,7 @@ xlog_cil_insert_items(
> >  	struct xfs_log_item	*lip;
> >  	int			len = 0;
> >  	int			diff_iovecs = 0;
> > -	int			iclog_space;
> > +	int			iclog_space, space_used;
> >  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> >  
> 
> fs/xfs//xfs_log_cil.c: In function ‘xlog_cil_insert_items’:
> fs/xfs//xfs_log_cil.c:396:21: warning: unused variable ‘space_used’ [-Wunused-variable]
> 
> >  	ASSERT(tp);
> > @@ -403,17 +403,16 @@ xlog_cil_insert_items(
> >  	 * are done so it doesn't matter exactly how we update the CIL.
> >  	 */
> >  	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
> > -
> > -	spin_lock(&cil->xc_cil_lock);
> > -
> >  	/* account for space used by new iovec headers  */
> > +
> >  	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
> >  	len += iovhdr_res;
> >  	ctx->nvecs += diff_iovecs;
> >  
> > -	/* attach the transaction to the CIL if it has any busy extents */
> > -	if (!list_empty(&tp->t_busy))
> > -		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> > +	/*
> > +	 * The ticket can't go away from us here, so we can do racy sampling
> > +	 * and precalculate everything.
> > +	 */
> >  
> >  	/*
> >  	 * Now transfer enough transaction reservation to the context ticket
> > @@ -421,27 +420,28 @@ xlog_cil_insert_items(
> >  	 * reservation has to grow as well as the current reservation as we
> >  	 * steal from tickets so we can correctly determine the space used
> >  	 * during the transaction commit.
> > +	 *
> > +	 * We use percpu_counter_add_batch() here to force the addition into the
> > +	 * global sum immediately. This will result in percpu_counter_read() now
> > +	 * always returning a non-zero value, and hence we'll only ever have a
> > +	 * very short race window on new contexts.
> >  	 */
> > -	if (ctx->ticket->t_curr_res == 0) {
> > +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
> >  		ctx_res = ctx->ticket->t_unit_res;
> > -		ctx->ticket->t_curr_res = ctx_res;
> >  		tp->t_ticket->t_curr_res -= ctx_res;
> > +		percpu_counter_add_batch(&cil->xc_curr_res, ctx_res, ctx_res - 1);
> >  	}
> 
> Ok, so we open a race here at the cost of stealing more reservation than
> necessary from the transaction. Seems harmless, but I would like to see
> some quantification/analysis on what a 'very short race window' is in
> this context.

About 20 instructions when the value is zero. The number of racers
will be dependent on how many threads are blocked in commit on the
xc_ctx_lock while a CIL push is in progress. The unit reservation
stolen here for the CIL is:

	xfs_log_calc_unit_res(mp, 0)
		~= 4 * sizeof(xlog_op_header) +
		   sizeof(xlog_trans_header) +
		   sizeof(sector) +
		   log stripe unit roundoff

So for a typical 4k log sector, we are talking about ~6kB of unit
reservation per thread that races here. For a 256k log stripe unit,
then it's going to be about 520kB per racing thread.

That said, every thread that races has this reservation available,
and the amount reserved adds to the space used in the CIL. Hence the
only downside of racing here is that the CIL background pushes
earlier because it hits the threshold sooner. That isn't a huge
issue - if we can't push immediately then the CIL will
run to the hard limit and block commits there; that overrun space is
larger than amount of space "wasted" by racing commits here.

> Particularly as it relates to percpu functionality. Does
> the window scale with cpu count, for example? It might not matter either

Not really. We need a thundering herd to cause issues, and this
occurs after formatting an item so we won't get a huge thundering
herd even when lots of threads block on the xc_ctx_lock waiting for
a push to complete.

> way because we expect any given transaction to accommodate the ctx res,
> but it would be good to understand the behavior here so we can think
> about potential side effects, if any.

I haven't been able to come up with any adverse side effects except
for "performance might drop a bit if we reserve too much and push
early", but that is tempered by the fact that performance goes up
much more than we might lose by getting rid of the xc_cil_lock
bottleneck.

> >  	/* do we need space for more log record headers? */
> > -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > -	if (len > 0 && (ctx->space_used / iclog_space !=
> > -				(ctx->space_used + len) / iclog_space)) {
> > +	if (len > 0 && !ctx_res) {
> > +		iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> >  		split_res = (len + iclog_space - 1) / iclog_space;
> >  		/* need to take into account split region headers, too */
> >  		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > -		ctx->ticket->t_unit_res += split_res;
> > -		ctx->ticket->t_curr_res += split_res;
> >  		tp->t_ticket->t_curr_res -= split_res;
> >  		ASSERT(tp->t_ticket->t_curr_res >= len);
> >  	}
> 
> Similarly here, assume additional split reservation for every
> context rather than checking each commit. Seems reasonable in
> principle, but just from a cursory glance this doesn't cover the
> case of the context expanding beyond more than two iclogs.  IOW,
> the current logic adds split_res if the size increase from the
> current transaction expands the ctx into another iclog than before
> the transaction. The new logic only seems to add split_res for the
> first transaction into the ctx. Also note

No, I changed it to apply to any vector length longer than a single
iclog except for transactions that have taken the unit reservation
above.

Sampling the space used isn't accurate here, and we do not want to
be doing an accurate sum across all CPUs, hence trying to detect a
reservation crossing an iclog boundary is difficult. Hence I just
took the reservation for anything that is guaranteed to cross an
iclog boundary. 

> that len seems to be a factor in the calculation of split_res, but it's
> not immediately clear to me what impact filtering the split_res
> calculation as such has in that regard.

The len used in the split_res calc guarantees that we always have at
least 1 log and op header accounted for by a split, and if the
vector length is greater than a single iclog it will include a
header for every iclog that the vector may span. i.e. if len >
iclog_space, it will reserve 2 extra iclog headers and op headers as
it may split across 3 iclogs....

> (BTW the comment above this hunk needs an update if we do end up with
> some special logic here.)

Definitely. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
