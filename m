Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B559C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBEE64DE8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhA1VXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:23:19 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34050 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhA1VXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:23:07 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 01F4D10766C;
        Fri, 29 Jan 2021 08:22:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5Ek9-003Vet-NT; Fri, 29 Jan 2021 08:22:21 +1100
Date:   Fri, 29 Jan 2021 08:22:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate CIL commit record IO
Message-ID: <20210128212221.GO4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-3-david@fromorbit.com>
 <20210128150741.GB2599027@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128150741.GB2599027@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=yDh1VcyqrphKO662BxAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 10:07:41AM -0500, Brian Foster wrote:
> FYI, I finally got to reading your prior log cache flushing thread
> yesterday afternoon. I was planning to revisit that and probably reply
> this morning after having some time to digest, but saw this and so will
> reply here..
> 
> On Thu, Jan 28, 2021 at 03:41:51PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To allow for iclog IO device cache flush behaviour to be optimised,
> > we first need to separate out the commit record iclog IO from the
> > rest of the checkpoint so we can wait for the checkpoint IO to
> > complete before we issue the commit record.
> > 
> > This separate is only necessary if the commit record is being
> > written into a different iclog to the start of the checkpoint. If
> > the entire checkpoint and commit is in the one iclog, then they are
> > both covered by the one set of cache flush primitives on the iclog
> > and hence there is no need to separate them.
> > 
> 
> I find the description here a bit vague.. we have to separate out the
> commit record I/O, but only if it's already separate..?

Yes, because if the commit record is in a different iclog to the
start of the checkpoint, we have to ensure that the start of the
checkpoint has been written and completed before we issue a
PREFLUSH, otherwise the cache flush is not guaranteed to capture
that IO. i.e. the block layer cache flushing mechanisms do not order
against IOs in flight, only completed IOs. Hence if the commit
record is in a different iclog, we have to wait for the other iclogs
to complete before flushign the cache. If the checkpoint is wholly
contained within a single iclog, then we don't have to wait for
anything, the single journal IO has all the cache flushes we need.


> Glancing at the
> code, I don't see any new "separation" happening, so it's not clear to
> me what that really refers to. This looks more like we're introducing
> serialization to provide checkpoint -> commit record ordering (when the
> commit record happens to be in a separate iclog).

Yes, that's exactly the separation that is being done by the call to
xlog_wait_on_iclog_lsn() from the CIL push code once we hold a
reference to the commit iclog...

> 
> > Otherwise, we need to wait for all the previous iclogs to complete
> > so they are ordered correctly and made stable by the REQ_PREFLUSH
> > that the commit record iclog IO issues. This guarantees that if a
> > reader sees the commit record in the journal, they will also see the
> > entire checkpoint that commit record closes off.
> > 
> > This also provides the guarantee that when the commit record IO
> > completes, we can safely unpin all the log items in the checkpoint
> > so they can be written back because the entire checkpoint is stable
> > in the journal.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      | 47 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_log_cil.c  |  7 +++++++
> >  fs/xfs/xfs_log_priv.h |  2 ++
> >  3 files changed, 56 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index c5f507c24577..c5e3da23961c 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -808,6 +808,53 @@ xlog_wait_on_iclog(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Wait on any iclogs that are still flushing in the range of start_lsn to
> > + * the current iclog's lsn. The caller holds a reference to the iclog, but
> > + * otherwise holds no log locks.
> > + *
> > + * We walk backwards through the iclogs to find the iclog with the highest lsn
> > + * in the range that we need to wait for and then wait for it to complete.
> > + * Completion ordering of iclog IOs ensures that all prior iclogs to this IO are
> > + * complete by the time our candidate has completed.
> > + */
> > +int
> > +xlog_wait_on_iclog_lsn(
> > +	struct xlog_in_core	*iclog,
> > +	xfs_lsn_t		start_lsn)
> > +{
> > +	struct xlog		*log = iclog->ic_log;
> > +	struct xlog_in_core	*prev;
> > +	int			error = -EIO;
> > +
> > +	spin_lock(&log->l_icloglock);
> > +	if (XLOG_FORCED_SHUTDOWN(log))
> > +		goto out_unlock;
> > +
> > +	error = 0;
> > +	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
> > +
> > +		/* Done if the lsn is before our start lsn */
> > +		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
> > +				start_lsn) < 0)
> > +			break;
> 
> Hmm.. that logic looks a bit dodgy when you consider that the iclog
> header lsn is reset to zero on activation. I think it actually works as
> intended because iclog completion reactivates iclogs in LSN order and
> this loop walks in reverse order, but that is a very subtle connection
> that might be useful to document.

It is documented in the comment above the function "We walk
backwards through the iclogs to find the iclog....". A newly
activated iclog will have an LSN of zero, and that means there are
no prior iclogs in the list in the range we need to flush because of
the completion ordering guarantees we have for iclog IO (i.e. they
are always completed in ring order, not IO completion order).

> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index b0ef071b3cb5..c5cc1b7ad25e 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -870,6 +870,13 @@ xlog_cil_push_work(
> >  	wake_up_all(&cil->xc_commit_wait);
> >  	spin_unlock(&cil->xc_push_lock);
> >  
> > +	/*
> > +	 * If the checkpoint spans multiple iclogs, wait for all previous
> > +	 * iclogs to complete before we submit the commit_iclog.
> > +	 */
> > +	if (ctx->start_lsn != commit_lsn)
> > +		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> > +
> 
> This is an interesting serialization point because we don't necessarily
> submit the iclog that holds the commit record. I actually think in most
> cases the separate commit record won't land on disk until the next CIL
> push causes a sync of the current head iclog (assuming it fills it up).

Which is exactly what happens now. It's not a big deal, because if
we are running a sync transaction, the log force will push it to
disk and wait for it. CIL pushes are not synchronous and never have
been - the log force is what creates the appearance of synchronous
behaviour to the caller...

> Granted, this is the last point we have context of the commit record
> being written, so it makes sense from an opportunistic standpoint to
> serialize here (just as we already block to ensure commit record
> ordering across checkpoints). That said, with the aggressive batching
> ability of the CIL I think blocking on prior pushes is potentially less
> heavy handed than unconditionally blocking on all prior iclog I/O. I
> wonder if this might be something to address if we're going to compound
> this path with more serialization.

This adds ordering to a CIL push, not serialisation across pushes.
The CIL pipeline at this point is running fully asynchronously to
user operations and other pushes. The only serialisation point with user
operations is a log force as we've already ordered the commit record
in the iclogs against other CIL flushes that haven't completed.

i.e. there's nothing here to serialise against other CIL operations
in progress - pushes or commits - it's just internal push IO ordering
that we are waiting on here.

> From a performance perspective, it seems like this makes the CIL push
> _nearly_ synchronous by default.

Nope, not at all. There is nothing waiting on the CIL push to
complete, except maybe a log force waiting for the iclogs to be
synced to disk and completed.

> I.e., if we have a several hundred MB
> CIL context,

Not possible. A 2GB log has a hard throttle limit now of 64MB.

> we're going to wait for all but the final iclog to complete
> before we return. Of course we'll be waiting for much of that anyways to
> reuse limited iclog space, but I have to think more about what that
> means in general (maybe not much) and get through the subsequent
> patches. In the meantime, have you put thought into any potential
> negative performance impact from this that might or might not be offset
> by subsequent flush optimizations?

This isn't a stand-alone change - it's only separated out from the
cache flush changes to make them easier to see. I do not expect
there to be any performance degradation due to this change because
of the fact that the CIL will only block things waiting on a
synchronous log force at this point. In the case where there are
lots of sync log forces, checkpoints will be small and single
iclogs, so no change of behaviour. For checkpoints that are large,
the reduction in IO latency and the ability for the block layer to
now merge adjacent journal IO because they don't require FUA or
cache flushes more than makes up for any additional latency the
ordering might introduce.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
