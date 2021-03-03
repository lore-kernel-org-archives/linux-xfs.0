Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31949C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061D164E90
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353666AbhCDARz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1574776AbhCCReQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 12:34:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614792766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M0WHp4c+jNjWQB9Xfy8pW6/PAaOqqS+k24y0t0MlGzY=;
        b=XgVbzJ14eEVrjH3wAueSGrtZlQrB/oArH40R2lS/Pup1eT22XB7kiQNjOWKO0yeZgOjQz2
        NHCh6PX6kSQLm5QUK4IhliYwcpFO4tAlKCkpLR+Ad5MGL0jUsSxXWLCHOtbM2SzhIg97nF
        DT3HqGppNQYO/ffszbK4l1to602d6OM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-24y2L9l4P_S5qGwviZk90Q-1; Wed, 03 Mar 2021 12:32:42 -0500
X-MC-Unique: 24y2L9l4P_S5qGwviZk90Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E47BB801993;
        Wed,  3 Mar 2021 17:32:41 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6757910023AB;
        Wed,  3 Mar 2021 17:32:41 +0000 (UTC)
Date:   Wed, 3 Mar 2021 12:32:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YD/IN66S3aM1lEQh@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303005752.GM4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 11:57:52AM +1100, Dave Chinner wrote:
> On Tue, Mar 02, 2021 at 04:44:12PM -0500, Brian Foster wrote:
> > On Thu, Feb 25, 2021 at 10:26:00AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The AIL pushing is stalling on log forces when it comes across
> > > pinned items. This is happening on removal workloads where the AIL
> > > is dominated by stale items that are removed from AIL when the
> > > checkpoint that marks the items stale is committed to the journal.
> > > This results is relatively few items in the AIL, but those that are
> > > are often pinned as directories items are being removed from are
> > > still being logged.
> > > 
> > > As a result, many push cycles through the CIL will first issue a
> > > blocking log force to unpin the items. This can take some time to
> > > complete, with tracing regularly showing push delays of half a
> > > second and sometimes up into the range of several seconds. Sequences
> > > like this aren't uncommon:
> > > 
> > ...
> > > 
> > > In each of these cases, every AIL pass saw 101 log items stuck on
> > > the AIL (pinned) with very few other items being found. Each pass, a
> > > log force was issued, and delay between last/first is the sleep time
> > > + the sync log force time.
> > > 
> > > Some of these 101 items pinned the tail of the log. The tail of the
> > > log does slowly creep forward (first lsn), but the problem is that
> > > the log is actually out of reservation space because it's been
> > > running so many transactions that stale items that never reach the
> > > AIL but consume log space. Hence we have a largely empty AIL, with
> > > long term pins on items that pin the tail of the log that don't get
> > > pushed frequently enough to keep log space available.
> > > 
> > > The problem is the hundreds of milliseconds that we block in the log
> > > force pushing the CIL out to disk. The AIL should not be stalled
> > > like this - it needs to run and flush items that are at the tail of
> > > the log with minimal latency. What we really need to do is trigger a
> > > log flush, but then not wait for it at all - we've already done our
> > > waiting for stuff to complete when we backed off prior to the log
> > > force being issued.
> > > 
> > > Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
> > > still do a blocking flush of the CIL and that is what is causing the
> > > issue. Hence we need a new interface for the CIL to trigger an
> > > immediate background push of the CIL to get it moving faster but not
> > > to wait on that to occur. While the CIL is pushing, the AIL can also
> > > be pushing.
> > > 
> > 
> > So I think I follow what you're describing wrt to the xfsaild delay, but
> > what I'm not clear on is what changing this behavior actually fixes.
> > IOW, if the xfsaild is cycling through and finding mostly stuck items,
> > then we see a delay because of the time spent in a log force (because of
> > those stuck items), what's the advantage to issue an async force over a
> > sync force? Won't xfsaild effectively continue to spin on these stuck
> > items until the log force completes, regardless?
> 
> When buffers get flushed and then pinned and can't be written back,
> we issue sync log forces from the AIL because the delwri list is not
> empty and the force count is non-zero.
> 
> So it's not just pinned items in the AIL that trigger this - it's
> stuff that gets pinned after it has been flushed but before it gets
> written that causes problems, too.
> 
> And if it's pinned buffers in the delwri list that are the issue,
> then we stop flushing other items from the list while we wait for
> the log force. hence if the tail pinning items are not actually
> pinned, but other buffers are, then we block on the log force when
> we could have been flushing and writing the items that pin the tail
> of the log.
> 
> > Is the issue not so much the throughput of xfsaild, but just the fact
> > that the task stalls are large enough to cause other problems? I.e., the
> > comment you add down in the xfsaild code refers to tail pinning causing
> > reservation stalls.  IOW, the purpose of this patch is then to keep
> > xfsaild sleeps to a predictable latency to ensure we come around again
> > quickly enough to keep the tail moving forward (even though the AIL
> > itself might remain in a state where the majority of items are stuck).
> > Yes?
> 
> Yup, largely because there are multiple triggers for log forces. 
> There's a difference between buffers that can't be flushed because
> they are pinned and flushed buffers that can't be written because
> they are pinned. The prior prevents the AIL from making push progress,
> the latter doesn't.
> 
> > > +trace_printk("seq %llu, curseq %llu, ctxseq %llu pushseq %llu flags 0x%x",
> > > +		sequence, cil->xc_current_sequence, cil->xc_ctx->sequence,
> > > +		cil->xc_push_seq, flags);
> > > +
> > > +	trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
> > >  	/*
> > >  	 * check to see if we need to force out the current context.
> > >  	 * xlog_cil_push() handles racing pushes for the same sequence,
> > >  	 * so no need to deal with it here.
> > >  	 */
> > >  restart:
> > > -	xlog_cil_push_now(log, sequence);
> > > +	xlog_cil_push_now(log, sequence, flags & XFS_LOG_SYNC);
> > > +	if (!(flags & XFS_LOG_SYNC))
> > > +		return commit_lsn;
> > 
> > Hm, so now we have sync and async log force and sync and async CIL push.
> > A log force always requires a sync CIL push and commit record submit;
> > the difference is simply whether or not we wait on commit record I/O
> > completion. The sync CIL push drains the CIL of log items but does not
> > switch out the commit record iclog, while the async CIL push executes in
> > the workqueue context so the drain is async, but it does switch out the
> > commit record iclog before it completes. IOW, the async CIL push is
> > basically a "more async" async log force.
> 
> Yes.
> 
> > I can see the need for the behavior of the async CIL push here, but that
> > leaves a mess of interfaces and behavior matrix. Is there any reason we
> > couldn't just make async log forces unconditionally behave equivalent to
> > the async CIL push as defined by this patch? There's only a handful of
> > existing users and I don't see any obvious reason why they might care
> > whether the underlying CIL push is synchronous or not...
> 
> I'm not touching the rest of the log force code in this series - it
> is out of scope of this bug fix and the rest of the series that it
> is part of.
> 

But you already have altered the log force code by changing
xlog_cil_force_seq(), which implicitly changes how xfs_log_force_seq()
behaves. So not only does this patch expose subsystem internals to
external layers and create more log forcing interfaces/behaviors to
maintain, it invokes one or the other from the preexisting async log
force variants purely based on whether the caller had a target sequence
number or not. This doesn't make a whole lot of sense to me.

> Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> changing things like log force behaviour and implementation is for
> a future series.
> 

TBH I think this patch is kind of a mess on its own. I think the
mechanism it wants to provide is sane, but I've not even got to the
point of reviewing _that_ yet because of the seeming dismissal of higher
level feedback. I'd rather not go around in circles on this so I'll just
offer my summarized feedback to this patch...

I think this patch should be broken down into two, possibly three
sub-patches that generally do the following (not necessarily in this
order):

1. Implement the new underlying async CIL push mechanism (i.e. the
   ->xc_push_async bits and new commit iclog switching behavior).
2. Change the behavior of existing async log forces to use the new
   mechanism consistently. Document the change in behavior for historical
   reference.
3. Switch xfsaild to use an async log force instead of the current sync
   log force. Document why this might depend on the updated async
   behavior.

Further log subsystem cleanup or consolidation that this might
facilitate between the historical async log force and the newer CIL
based async log force can occur separately in future patches..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

