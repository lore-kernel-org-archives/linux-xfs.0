Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A680FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 21:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A728820575
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 21:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgEMVws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 17:52:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54576 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729487AbgEMVwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 17:52:47 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B2F237EAB5E;
        Thu, 14 May 2020 07:52:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYzIv-0000L4-FK; Thu, 14 May 2020 07:52:41 +1000
Date:   Thu, 14 May 2020 07:52:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context
 counters
Message-ID: <20200513215241.GG2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-4-david@fromorbit.com>
 <20200512140544.GD37029@bfoster>
 <20200512233627.GW2040@dread.disaster.area>
 <20200513120959.GB44225@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513120959.GB44225@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=creX0PhpFVbCOgQokKcA:9 a=ivJoMfNlN2Aev7iU:21 a=HeW0F-xwtoxtxgtl:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 08:09:59AM -0400, Brian Foster wrote:
> On Wed, May 13, 2020 at 09:36:27AM +1000, Dave Chinner wrote:
> > On Tue, May 12, 2020 at 10:05:44AM -0400, Brian Foster wrote:
> > > Particularly as it relates to percpu functionality. Does
> > > the window scale with cpu count, for example? It might not matter either
> > 
> > Not really. We need a thundering herd to cause issues, and this
> > occurs after formatting an item so we won't get a huge thundering
> > herd even when lots of threads block on the xc_ctx_lock waiting for
> > a push to complete.
> > 
> 
> It would be nice to have some debug code somewhere that somehow or
> another asserts or warns if the CIL reservation exceeds some
> insane/unexpected heuristic based on the current size of the context. I
> don't know what that code or heuristic looks like (i.e. multiple factors
> of the ctx size?) so I'm obviously handwaving. Just something to think
> about if we can come up with a way to accomplish that opportunistically.

I don't think there is a reliable mechanism that can be used here.
At one end of the scale we have the valid case of a synchronous
inode modification on a log with a 256k stripe unit. So it's valid
to have a CIL reservation of ~550kB for a single item that consumes
~700 bytes of log space.

OTOH, we might be freeing extents on a massively fragmented file and
filesystem, so we're pushing 200kB+ transactions into the CIL for
every rolling transaction. On a filesystem with a 512 byte log
sector size and no LSU, the CIL reservations are dwarfed by the
actual metadata being logged...

I'd suggest that looking at the ungrant trace for the CIL ticket
once it has committed will tell us exactly how much the reservation
was over-estimated, as the unused portion of the reservation will be
returned to the reserve grant head at this point in time.

> > > way because we expect any given transaction to accommodate the ctx res,
> > > but it would be good to understand the behavior here so we can think
> > > about potential side effects, if any.
> > 
> > I haven't been able to come up with any adverse side effects except
> > for "performance might drop a bit if we reserve too much and push
> > early", but that is tempered by the fact that performance goes up
> > much more than we might lose by getting rid of the xc_cil_lock
> > bottleneck.
> > 
> 
> FWIW, a more extreme test vector could be to steal the remainder of the
> transaction reservation for the CIL ticket and see how that affects
> things. That's probably more suited for a local test than something to
> live in the upstream code, though.

It will only affect performance. Worst case is that it degrades the
CIL to behave like the original logging code that wrote direct to
iclogs. i.e. it defeats the in memory aggregation of delayed logging
and effectively writes directly to the iclogs.

Which, really, is what using the -o wsync or -o dirsync largely do
by making a large number of transactions synchrnonous.

In short, performance goes down if we reserve too much, but nothing
incorrect should occur.

> 
> > > >  	/* do we need space for more log record headers? */
> > > > -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > > -	if (len > 0 && (ctx->space_used / iclog_space !=
> > > > -				(ctx->space_used + len) / iclog_space)) {
> > > > +	if (len > 0 && !ctx_res) {
> > > > +		iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > >  		split_res = (len + iclog_space - 1) / iclog_space;
> > > >  		/* need to take into account split region headers, too */
> > > >  		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > > > -		ctx->ticket->t_unit_res += split_res;
> > > > -		ctx->ticket->t_curr_res += split_res;
> > > >  		tp->t_ticket->t_curr_res -= split_res;
> > > >  		ASSERT(tp->t_ticket->t_curr_res >= len);
> > > >  	}
> > > 
> > > Similarly here, assume additional split reservation for every
> > > context rather than checking each commit. Seems reasonable in
> > > principle, but just from a cursory glance this doesn't cover the
> > > case of the context expanding beyond more than two iclogs.  IOW,
> > > the current logic adds split_res if the size increase from the
> > > current transaction expands the ctx into another iclog than before
> > > the transaction. The new logic only seems to add split_res for the
> > > first transaction into the ctx. Also note
> > 
> > No, I changed it to apply to any vector length longer than a single
> > iclog except for transactions that have taken the unit reservation
> > above.
> > 
> 
> Ok, I had the ctx_res logic inverted in my head. So it's not that
> split_res is only added for the first transaction, but rather we treat
> every transaction that didn't contribute unit res as if it crosses an
> iclog boundary. That seems much more reasonable, though it does add to
> the "overreservation" of the ticket so I'll reemphasize the request for
> some form of debug/trace check that helps analyze runtime CIL ticket
> reservation accounting. ;)

I can add some trace points, but I think we already have the
tracepoints we need to understand how much overestimation occurs.
i.e. trace_xfs_log_ticket_ungrant() from the CIL push worker
context.

> OTOH, this skips the split_res in the case where a single large
> multi-iclog transaction happens to be the first in the ctx, right?

True, that's easy enough to fix.

> That
> doesn't seem that unlikely a scenario considering minimum iclog and
> worst case transaction unit res sizes. It actually makes me wonder what
> happens if the CIL ticket underruns.. :P

xlog_write() will catch the underrun when we go to write the commit
record via xlog_commit_record(), dump the ticket and shutdown the
filesystem.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
