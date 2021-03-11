Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119A7C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 06:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EED64F4D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 06:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhCKGvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 01:51:33 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59540 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231328AbhCKGvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 01:51:10 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 46A1A827CDF;
        Thu, 11 Mar 2021 17:51:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKFA1-001Bh7-P6; Thu, 11 Mar 2021 17:51:05 +1100
Date:   Thu, 11 Mar 2021 17:51:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/45] xfs: implement percpu cil space used calculation
Message-ID: <20210311065105.GU74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-37-david@fromorbit.com>
 <20210311002054.GJ3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311002054.GJ3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=3Lr4401Ltf3c0OxPFzYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 04:20:54PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:34PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have the CIL percpu structures in place, implement the
> > space used counter with a fast sum check similar to the
> > percpu_counter infrastructure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 42 ++++++++++++++++++++++++++++++++++++------
> >  fs/xfs/xfs_log_priv.h |  2 +-
> >  2 files changed, 37 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 1bcf0d423d30..5519d112c1fd 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -433,6 +433,8 @@ xlog_cil_insert_items(
> >  	struct xfs_log_item	*lip;
> >  	int			len = 0;
> >  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
> > +	int			space_used;
> > +	struct xlog_cil_pcp	*cilpcp;
> >  
> >  	ASSERT(tp);
> >  
> > @@ -469,8 +471,9 @@ xlog_cil_insert_items(
> >  	 *
> >  	 * This can steal more than we need, but that's OK.
> >  	 */
> > +	space_used = atomic_read(&ctx->space_used);
> >  	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> > -	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> > +	    space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> >  		int	split_res = log->l_iclog_hsize +
> >  					sizeof(struct xlog_op_header);
> >  		if (ctx_res)
> > @@ -480,16 +483,34 @@ xlog_cil_insert_items(
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
> 
> What happens if the log is very small and there are hundreds of CPUs?
> Can we end up on this slow path on a regular basis even if the amount of
> space used is not that large?

AFAICT, no big deal - the transaction reservations limit the the
amount of space and concurrency that we can have here. A small log
will not allow many more than a handful of transactions through at a
time.  IOWs, we'll already be on the transaction reservation slow
path that limits concurrency via the grant head spin lock in
xlog_grant_head_check() and sleeping in xlog_grant_head_wait()...

> Granted I can't think of a good way out of that, since I suspect that if
> you do that you're already going to be hurting in 5 other places anyway.
> That said ... I /do/ keep getting bugs from people with tiny logs on big
> iron.  Some day I'll (ha!) stomp out all the bugs that are "NO do not
> let your deployment system growfs 10000x, this is not ext4"...

Yeah, that hurts long before we get to this transaction commit
path...

> 
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
> >  
> >  	/*
> >  	 * If we've overrun the reservation, dump the tx details before we move
> >  	 * the log items. Shutdown is imminent...
> >  	 */
> > +	tp->t_ticket->t_curr_res -= ctx_res + len;
> 
> Is moving this really necessary?

Not really, just gets it out of the way. I moved it because it
doesn't need to be inside the spinlock and in the end it needs to
be associated with the underrun check. So I moved it here first so
that it didn't have to keep moving every time I moved the spinlock
or changed the order of the code from this point onwards....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
