Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DFCC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 13:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B91D20727
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 13:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCwjBQvV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgENNnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 09:43:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbgENNnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 09:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589463788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ljbjzzPuT5luVa2+wI6OrLuHvBs4LaTrgN2hGEbHPA=;
        b=VCwjBQvVCG57tnJxL8hxs5OOW9MtFtH/X3xOO9WX8SnSzobZRsxJBETv082SgYzacUTGDo
        SEyUYxw99PPziIJzaCuPKNFeGeXr/pJsRAxtvTigqv9kfeUJ5j2Aq3vDQacHCTWLIiLc74
        Rqy8Ccy3F7b7KOgHzI5p1V7dNqFAfo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-izSVusqYPRyrnEFgU22vrg-1; Thu, 14 May 2020 09:43:07 -0400
X-MC-Unique: izSVusqYPRyrnEFgU22vrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C7A5106B259;
        Thu, 14 May 2020 13:43:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B68B160BF1;
        Thu, 14 May 2020 13:43:05 +0000 (UTC)
Date:   Thu, 14 May 2020 09:43:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context
 counters
Message-ID: <20200514134303.GB50441@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-4-david@fromorbit.com>
 <20200512140544.GD37029@bfoster>
 <20200512233627.GW2040@dread.disaster.area>
 <20200513120959.GB44225@bfoster>
 <20200513215241.GG2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513215241.GG2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 07:52:41AM +1000, Dave Chinner wrote:
> On Wed, May 13, 2020 at 08:09:59AM -0400, Brian Foster wrote:
> > On Wed, May 13, 2020 at 09:36:27AM +1000, Dave Chinner wrote:
> > > On Tue, May 12, 2020 at 10:05:44AM -0400, Brian Foster wrote:
> > > > Particularly as it relates to percpu functionality. Does
> > > > the window scale with cpu count, for example? It might not matter either
> > > 
> > > Not really. We need a thundering herd to cause issues, and this
> > > occurs after formatting an item so we won't get a huge thundering
> > > herd even when lots of threads block on the xc_ctx_lock waiting for
> > > a push to complete.
> > > 
> > 
> > It would be nice to have some debug code somewhere that somehow or
> > another asserts or warns if the CIL reservation exceeds some
> > insane/unexpected heuristic based on the current size of the context. I
> > don't know what that code or heuristic looks like (i.e. multiple factors
> > of the ctx size?) so I'm obviously handwaving. Just something to think
> > about if we can come up with a way to accomplish that opportunistically.
> 
> I don't think there is a reliable mechanism that can be used here.
> At one end of the scale we have the valid case of a synchronous
> inode modification on a log with a 256k stripe unit. So it's valid
> to have a CIL reservation of ~550kB for a single item that consumes
> ~700 bytes of log space.
> 

Perhaps ctx size isn't a sufficient baseline by itself. That said, log
stripe unit is still fixed and afaict centralized to the base unit res
calculation of the CIL ctx and regular transaction tickets. So I'm not
convinced we couldn't come up with something useful on the push side
that factors lsunit into the metric. It doesn't have to be perfect, just
something conservative enough to catch consuming reservation beyond
expected worst case conditions without causing false positives.

Re: your followups, I'll put more thought into it when the percpu
algorithm is more settled..

> OTOH, we might be freeing extents on a massively fragmented file and
> filesystem, so we're pushing 200kB+ transactions into the CIL for
> every rolling transaction. On a filesystem with a 512 byte log
> sector size and no LSU, the CIL reservations are dwarfed by the
> actual metadata being logged...
> 
> I'd suggest that looking at the ungrant trace for the CIL ticket
> once it has committed will tell us exactly how much the reservation
> was over-estimated, as the unused portion of the reservation will be
> returned to the reserve grant head at this point in time.
> 

Yeah, that works for me.

> > > > way because we expect any given transaction to accommodate the ctx res,
> > > > but it would be good to understand the behavior here so we can think
> > > > about potential side effects, if any.
> > > 
> > > I haven't been able to come up with any adverse side effects except
> > > for "performance might drop a bit if we reserve too much and push
> > > early", but that is tempered by the fact that performance goes up
> > > much more than we might lose by getting rid of the xc_cil_lock
> > > bottleneck.
> > > 
> > 
> > FWIW, a more extreme test vector could be to steal the remainder of the
> > transaction reservation for the CIL ticket and see how that affects
> > things. That's probably more suited for a local test than something to
> > live in the upstream code, though.
> 
> It will only affect performance. Worst case is that it degrades the
> CIL to behave like the original logging code that wrote direct to
> iclogs. i.e. it defeats the in memory aggregation of delayed logging
> and effectively writes directly to the iclogs.
> 
> Which, really, is what using the -o wsync or -o dirsync largely do
> by making a large number of transactions synchrnonous.
> 
> In short, performance goes down if we reserve too much, but nothing
> incorrect should occur.
> 

Ok.

> > 
> > > > >  	/* do we need space for more log record headers? */
> > > > > -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > > > -	if (len > 0 && (ctx->space_used / iclog_space !=
> > > > > -				(ctx->space_used + len) / iclog_space)) {
> > > > > +	if (len > 0 && !ctx_res) {
> > > > > +		iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > > >  		split_res = (len + iclog_space - 1) / iclog_space;
> > > > >  		/* need to take into account split region headers, too */
> > > > >  		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > > > > -		ctx->ticket->t_unit_res += split_res;
> > > > > -		ctx->ticket->t_curr_res += split_res;
> > > > >  		tp->t_ticket->t_curr_res -= split_res;
> > > > >  		ASSERT(tp->t_ticket->t_curr_res >= len);
> > > > >  	}
> > > > 
> > > > Similarly here, assume additional split reservation for every
> > > > context rather than checking each commit. Seems reasonable in
> > > > principle, but just from a cursory glance this doesn't cover the
> > > > case of the context expanding beyond more than two iclogs.  IOW,
> > > > the current logic adds split_res if the size increase from the
> > > > current transaction expands the ctx into another iclog than before
> > > > the transaction. The new logic only seems to add split_res for the
> > > > first transaction into the ctx. Also note
> > > 
> > > No, I changed it to apply to any vector length longer than a single
> > > iclog except for transactions that have taken the unit reservation
> > > above.
> > > 
> > 
> > Ok, I had the ctx_res logic inverted in my head. So it's not that
> > split_res is only added for the first transaction, but rather we treat
> > every transaction that didn't contribute unit res as if it crosses an
> > iclog boundary. That seems much more reasonable, though it does add to
> > the "overreservation" of the ticket so I'll reemphasize the request for
> > some form of debug/trace check that helps analyze runtime CIL ticket
> > reservation accounting. ;)
> 
> I can add some trace points, but I think we already have the
> tracepoints we need to understand how much overestimation occurs.
> i.e. trace_xfs_log_ticket_ungrant() from the CIL push worker
> context.
> 

Sure..

> > OTOH, this skips the split_res in the case where a single large
> > multi-iclog transaction happens to be the first in the ctx, right?
> 
> True, that's easy enough to fix.
> 
> > That
> > doesn't seem that unlikely a scenario considering minimum iclog and
> > worst case transaction unit res sizes. It actually makes me wonder what
> > happens if the CIL ticket underruns.. :P
> 
> xlog_write() will catch the underrun when we go to write the commit
> record via xlog_commit_record(), dump the ticket and shutdown the
> filesystem.
> 

Ah, right. Note that's not the last place we take from ->t_curr_res in
the xlog_write() path. xlog_state_get_iclog_space() steals a bit as well
if we're at the top of an iclog so it might be worth bolstering that
check.

Brian

> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

