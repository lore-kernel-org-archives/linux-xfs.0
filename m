Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F4DC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 15:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC4520E65
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 15:16:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+Y0KFnC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgI1PQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgI1PQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 11:16:35 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601306192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BuDxc3INwAtMeDV4K7+l7k9HwJnmeY0MB2Md1baoLag=;
        b=c+Y0KFnCvABU8zXs2WQ90zFBjJoy6FKKgvveMssFQ9yt1paTpBBenvYQhZjw1jcJcdHg4K
        MsK7y+fLb8L3E3FTKM1/jP2bkuw1TgzChjMa8HIfrbrZ47eGDTN9IYlqaig2leQ8PthDJD
        SBfqPG6U/pv+Q7oH2lrI5taQ4qabebs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-hpTPqCUrP-GQUx6kLf2eLg-1; Mon, 28 Sep 2020 11:16:30 -0400
X-MC-Unique: hpTPqCUrP-GQUx6kLf2eLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA0271009442;
        Mon, 28 Sep 2020 15:16:29 +0000 (UTC)
Received: from bfoster (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25692756AB;
        Mon, 28 Sep 2020 15:16:29 +0000 (UTC)
Date:   Mon, 28 Sep 2020 11:16:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200928151627.GA4883@bfoster>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927230823.GA14422@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle design flaw in the deferred log item code that can lead
> > to pinning the log tail.  Taking up the defer ops chain examples from
> > the previous commit, we can get trapped in sequences like this:
> > 
> > Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> > chain will look like the following if the transaction rolls succeed:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > In transaction 9, we finish d9 and try to roll to t10 while holding onto
> > an intent item for D3 that we logged in t0.
> > 
> > The previous commit changed the order in which we place new defer ops in
> > the defer ops processing chain to reduce the maximum chain length.  Now
> > make xfs_defer_finish_noroll capable of relogging the entire chain
> > periodically so that we can always move the log tail forward.  Most
> > chains will never get relogged, except for operations that generate very
> > long chains (large extents containing many blocks with different sharing
> > levels) or are on filesystems with small logs and a lot of ongoing
> > metadata updates.
> > 
> > Callers are now required to ensure that the transaction reservation is
> > large enough to handle logging done items and new intent items for the
> > maximum possible chain length.  Most callers are careful to keep the
> > chain lengths low, so the overhead should be minimal.
> > 
> > The decision to relog an intent item is made based on whether or not the
> > intent was added to the current checkpoint.  If so, the checkpoint is
> > still open and there's no point in relogging.  Otherwise, the old
> > checkpoint is closed and we relog the intent to add it to the current
> > one.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++
> >  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h         |    1 +
> >  fs/xfs/xfs_trans.h         |   10 ++++++++
> >  7 files changed, 173 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..c601cc2af254 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_inode_item.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > +#include "xfs_log.h"
> >  
> >  /*
> >   * Deferred Operations in XFS
> > @@ -361,6 +362,52 @@ xfs_defer_cancel_list(
> >  	}
> >  }
> >  
> > +/*
> > + * Prevent a log intent item from pinning the tail of the log by logging a
> > + * done item to release the intent item; and then log a new intent item.
> > + * The caller should provide a fresh transaction and roll it after we're done.
> > + */
> > +static int
> > +xfs_defer_relog(
> > +	struct xfs_trans		**tpp,
> > +	struct list_head		*dfops)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +	xfs_lsn_t			threshold_lsn;
> > +
> > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +
> > +	/*
> > +	 * Figure out where we need the tail to be in order to maintain the
> > +	 * minimum required free space in the log.
> > +	 */
> > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > +	if (threshold_lsn == NULLCOMMITLSN)
> > +		return 0;
> 
> This smells of premature optimisation.
> 
> When we are in a tail-pushing scenario (i.e. any sort of
> sustained metadata workload) this will always return true, and so we
> will relog every intent that isn't in the current checkpoint every
> time this is called.  Under light load, we don't care if we add a
> little bit of relogging overhead as the CIL slowly flushes/pushes -
> it will have neglible impact on performance because there is little
> load on the journal.
> 

That seems like an overly broad and not necessarily correct assumption.
The threshold above is tail relative and hardcoded (with the zero param)
to the default AIL pushing threshold, which is 25% of the log. If we
assume sustained tail pushing conditions, a committed intent doesn't
trigger relog again until it falls within that threshold in the on-disk
log. The current CIL (nonblocking) size threshold is half that at 12.5%.
So relative to a given rolling transaction processing an intent chain,
there's a decent number of full CIL checkpoints that can occur before
any of those intents need to relog again (if at all), regardless of log
size.

Without that logic, we're changing behavior to relog the entire chain in
every CIL checkpoint. That's a fairly significant change in behavior
with less predictable breakdown conditions. Do we know how long a single
chain is going to be? Do we know how many CPUs are concurrently
processing "long chain" operations? Do we know whether an external
workload is causing even more frequent checkpoints than governed by the
CIL size limit? The examples in the commit logs in this series refer to
chains of of hundreds of intents with hundreds of transaction rolls.
Those types of scenarios are hard enough to reason about, particularly
when we consider boxes with hundreds of CPUs, so I'm somewhat skeptical
of us accurately predicting performance/behavior over an implementation
that bounds processing more explicitly.

ISTM that these are all essentially undefined contributing factors. For
those reasons, I don't really consider this is an optimization at all.
Rather IMO it's a component of sane/predictable functional behavior. I
don't think concerns over cacheline contention on the log tail field
justify removing it entirely.

> However, when we are under heavy load the code will now be reading
> the grant head and log position accounting variables during every
> commit, hence greatly increasing the number and temporal
> distribution of accesses to the hotest cachelines in the log. We
> currently never access these cache lines during commit unless the
> unit reservation has run out and we have to regrant physical log
> space for the transaction to continue (i.e. we are into slow path
> commit code). IOWs, this is like causing far more than double the
> number of accesses to the grant head, the log tail, the
> last_sync_lsn, etc, all of which is unnecessary exactly when we care
> about minimising contention on the log space accounting variables...
> 

If we're under sustained tail pushing pressure, blocking transactions
have already hit this cacheline as well, FWIW.

But if we're concerned about cacheline access in the commit path
specifically, I'm sure we could come up with any number of optimizations
to address that directly. E.g., we could sample the threshold
occasionally instead of on every roll, wait until the current
transaction has consumed all logres units (where we'll be hitting that
line anyways), shift state tracking over to xfsaild via setting a flag
on log items with an ->iop_relog() handler set that happen to pin the
tail, etc. etc. That said, I do think any such added complexity should
be justified with some accompanying profiling data (and I like the idea
of new stats counters mentioned in the separate mail).

Brian

> Given that it is a redundant check under heavy load journal load
> when access to the log grant/head/tail are already contended,
> I think we should just be checking the "in current checkpoint" logic
> and not making it conditional on the log being near full.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

