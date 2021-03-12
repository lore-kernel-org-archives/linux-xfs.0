Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD95C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 00:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB8C64F8E
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 00:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCLArd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 19:47:33 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41912 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhCLArJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 19:47:09 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1C33263077;
        Fri, 12 Mar 2021 11:47:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKVxI-001TQn-Me; Fri, 12 Mar 2021 11:47:04 +1100
Date:   Fri, 12 Mar 2021 11:47:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/45] xfs: track CIL ticket reservation in percpu
 structure
Message-ID: <20210312004704.GG63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-38-david@fromorbit.com>
 <20210311002610.GK3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311002610.GK3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Dhs8RxifOZkinYDzEEwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 04:26:10PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:35PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To get it out from under the cil spinlock.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 11 ++++++-----
> >  fs/xfs/xfs_log_priv.h |  2 +-
> >  2 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 5519d112c1fd..a2f93bd7644b 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -492,6 +492,7 @@ xlog_cil_insert_items(
> >  	 * based on how close we are to the hard limit.
> >  	 */
> >  	cilpcp = get_cpu_ptr(cil->xc_pcp);
> > +	cilpcp->space_reserved += ctx_res;
> >  	cilpcp->space_used += len;
> >  	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
> >  	    cilpcp->space_used >
> > @@ -502,10 +503,6 @@ xlog_cil_insert_items(
> >  	}
> >  	put_cpu_ptr(cilpcp);
> >  
> > -	spin_lock(&cil->xc_cil_lock);
> > -	ctx->ticket->t_unit_res += ctx_res;
> > -	ctx->ticket->t_curr_res += ctx_res;
> > -
> >  	/*
> >  	 * If we've overrun the reservation, dump the tx details before we move
> >  	 * the log items. Shutdown is imminent...
> > @@ -527,6 +524,7 @@ xlog_cil_insert_items(
> >  	 * We do this here so we only need to take the CIL lock once during
> >  	 * the transaction commit.
> >  	 */
> > +	spin_lock(&cil->xc_cil_lock);
> >  	list_for_each_entry(lip, &tp->t_items, li_trans) {
> >  
> >  		/* Skip items which aren't dirty in this transaction. */
> > @@ -798,10 +796,13 @@ xlog_cil_push_work(
> >  
> >  	down_write(&cil->xc_ctx_lock);
> >  
> > -	/* Reset the CIL pcp counters */
> > +	/* Aggregate and reset the CIL pcp counters */
> >  	for_each_online_cpu(cpu) {
> >  		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
> > +		ctx->ticket->t_curr_res += cilpcp->space_reserved;
> 
> Why isn't it necessary to update ctx->ticket->t_unit_res any more?

Because t_unit_res is never used by the CIL ticket becuse they
aren't permanent transaction reservations. The unit res is only
for granting new space to a ticket, yet the CIL only ever "steals"
granted space from an existing ticket. When
the ticket is dropped, we return unused reservations from the
CIL ticket, but never touch or look at the unit reservation.

I can add it back in here if you want, but it's largely dead code...

> (Admittedly I'm struggling to figure out why it matters to keep it
> updated even in the current code base...)

I think I originally did it a decade ago because I probably wasn't
100% sure on what impact not setting it would have. Getting the rest
of the delayed logging code right was far more important than
sweating on a tiny, largely insignificant detail like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
