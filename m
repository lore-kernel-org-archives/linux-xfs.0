Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7563C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B87C207E0
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfIEQZg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfIEQZg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 12:25:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 803843DFCD;
        Thu,  5 Sep 2019 16:25:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C6B60BE1;
        Thu,  5 Sep 2019 16:25:35 +0000 (UTC)
Date:   Thu, 5 Sep 2019 12:25:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190905162533.GA59149@bfoster>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
 <20190904193442.GA52970@bfoster>
 <20190904225056.GL1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904225056.GL1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 05 Sep 2019 16:25:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:50:56AM +1000, Dave Chinner wrote:
> On Wed, Sep 04, 2019 at 03:34:42PM -0400, Brian Foster wrote:
> > On Wed, Sep 04, 2019 at 02:24:51PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > +/*
> > > + * Completion of a iclog IO does not imply that a transaction has completed, as
> > > + * transactions can be large enough to span many iclogs. We cannot change the
> > > + * tail of the log half way through a transaction as this may be the only
> > > + * transaction in the log and moving the tail to point to the middle of it
> > > + * will prevent recovery from finding the start of the transaction. Hence we
> > > + * should only update the last_sync_lsn if this iclog contains transaction
> > > + * completion callbacks on it.
> > > + *
> > > + * We have to do this before we drop the icloglock to ensure we are the only one
> > > + * that can update it.
> > > + *
> > > + * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> > > + * the reservation grant head pushing. This is due to the fact that the push
> > > + * target is bound by the current last_sync_lsn value. Hence if we have a large
> > > + * amount of log space bound up in this committing transaction then the
> > > + * last_sync_lsn value may be the limiting factor preventing tail pushing from
> > > + * freeing space in the log. Hence once we've updated the last_sync_lsn we
> > > + * should push the AIL to ensure the push target (and hence the grant head) is
> > > + * no longer bound by the old log head location and can move forwards and make
> > > + * progress again.
> > > + */
> > > +static void
> > > +xlog_state_set_callback(
> > > +	struct xlog		*log,
> > > +	struct xlog_in_core	*iclog,
> > > +	xfs_lsn_t		header_lsn)
> > > +{
> > > +	iclog->ic_state = XLOG_STATE_CALLBACK;
> > > +
> > > +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn), header_lsn) <= 0);
> > > +
> > > +	if (list_empty_careful(&iclog->ic_callbacks))
> > > +		return;
> > > +
> > > +	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> > > +	xlog_grant_push_ail(log, 0);
> > > +
> > 
> > Nit: extra whitespace line above.
> 
> Fixed.
> 
> > This still seems racy to me, FWIW. What if the AIL is empty (i.e. the
> > push is skipped)?
> 
> If the AIL is empty, then it's a no-op because pushing on the AIL is
> not going to make more log space become free. Besides, that's not
> the problem being solved here - reservation wakeups on first insert
> into the AIL are already handled by xfs_trans_ail_update_bulk() and
> hence the first patch in the series. This patch is addressing the

Nothing currently wakes up reservation waiters on first AIL insertion. I
pointed this out in the original thread along with the fact that the
push is a no-op for an empty AIL. What wasn't clear to me is whether it
matters for the problem this patch is trying to fix. It sounds like not,
but that's a separate question from whether this is a problem itself.

> situation where the bulk insert that occurs from the callbacks that
> are about to run -does not modify the tail of the log-. i.e. the
> commit moved the head but not the tail, so we have to update the AIL
> push target to take into account the new log head....
> 

Ok, I figured based on process of elimination. xfs_ail_push() ignores
the push on an empty AIL and we obviously already have wakeups on tail
updates.

> i.e. the AIL is for moving the tail of the log - this code moves the
> head of the log. But both impact on the AIL push target (it is based on
> the distance between the head and tail), so we need
> to update the push target just in case this commit does not move
> the tail...
> 
> > What if xfsaild completes this push before the
> > associated log items land in the AIL or we race with xfsaild emptying
> > the AIL? Why not just reuse/update the existing grant head wake up logic
> > in the iclog callback itself? E.g., something like the following
> > (untested):
> > 

And the raciness concerns..? AFAICT this still opens a race window where
the AIL can idle on the push target before AIL insertion.

> > @@ -740,12 +740,10 @@ xfs_trans_ail_update_bulk(
> >  	if (mlip_changed) {
> >  		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> >  			xlog_assign_tail_lsn_locked(ailp->ail_mount);
> > -		spin_unlock(&ailp->ail_lock);
> > -
> > -		xfs_log_space_wake(ailp->ail_mount);
> > -	} else {
> > -		spin_unlock(&ailp->ail_lock);
> >  	}
> > +
> > +	spin_unlock(&ailp->ail_lock);
> > +	xfs_log_space_wake(ailp->ail_mount);
> 
> Two things that I see straight away:
> 
> 1. if the AIL is empty, the first insert does not set mlip_changed =
> true and and so there will be no wakeup in the scenario you are
> posing. This would be easy to fix - if (!mlip || changed) - so that
> a wakeup is triggered in this case.
> 

This (again) was what I suggested originally in Chandan's thread for the
empty AIL case.

> 2. if we have not moved the tail, then calling xfs_log_space_wake()
> will, at best, just burn CPU. At worst, it wll cause hundreds of
> thousands of spurious wakeups a seconds because the waiting
> transaction reservation will be woken continuously when there isn't
> space available and there hasn't been any space made available.
> 

Yes, I can see how that would be problematic with the diff I posted
above. It's also something that can be easily fixed. Note that I think
there's another potential side effect of that diff in terms of
amplifying pressure on the AIL because we don't know whether the waiters
were blocked because of pent up in-core reservation consumption or
simply because the tail is pinned. That said, I think both patches share
that particular quirk.

Either way, this doesn't address the raciness concern I have with this
patch. If you're wedded to this particular approach, then the simplest
fix is probably to just reorder the xlog_grans_push_ail() call properly
after processing iclog callbacks. A more appropriate fix, IMO, would be
to either export this logic to where the AIL update happens and/or
enhance the existing log space wake up logic to filter wakeups in the
scenarios where it is not necessary (i.e. no tail update &&
xa_push_target == max_lsn), but this is more subjective...

> So, from #1 we see that unconditional wakeups are not necessary in
> the scenario you pose, and from #2 it's not a viable solution even
> if it was required.
> 
> However, #1 indicates other problems if a xfs_log_space_wake() call
> is necessary in this case. No reservations space and an empty AIL
> implies that the CIL pins the entire log - a pending commit that
> hasn't finished flushing and the current context that is
> aggregating. This implies we've violated a much more important rule
> of the on-disk log format: finding the head and tail of the log
> requires no individual commit be larger than 50% of the log.
> 

I described this exact problem days ago in the original thread. There's
no need to rehash it here. FWIW, I can reproduce much worse than 50% log
consumption aggregated outside of the AIL with the current code and it
doesn't depend on a nonpreemptible kernel (though the workqueue fix
looks legit to me).

Brian

> So if we are actually stalling on trasnaction reservations with an
> empty AIL and an uncommitted CIL, screwing around with tail pushing
> wakeups does not address the bigger problem being seen...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
