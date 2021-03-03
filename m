Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95151C4161F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6462C61477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351118AbhCCDQ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:26 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44151 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232972AbhCCAmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 19:42:12 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 4EBAD107F1B;
        Wed,  3 Mar 2021 11:41:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lHFZn-00CDvV-If; Wed, 03 Mar 2021 11:41:19 +1100
Date:   Wed, 3 Mar 2021 11:41:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210303004119.GL4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <YD0GCCPmCkoYBVK0@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD0GCCPmCkoYBVK0@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=7r87xiz7UFZlPemfZwkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 10:19:36AM -0500, Brian Foster wrote:
> On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To allow for iclog IO device cache flush behaviour to be optimised,
> > we first need to separate out the commit record iclog IO from the
> > rest of the checkpoint so we can wait for the checkpoint IO to
> > complete before we issue the commit record.
> > 
> > This separation is only necessary if the commit record is being
> > written into a different iclog to the start of the checkpoint as the
> > upcoming cache flushing changes requires completion ordering against
> > the other iclogs submitted by the checkpoint.
> > 
> > If the entire checkpoint and commit is in the one iclog, then they
> > are both covered by the one set of cache flush primitives on the
> > iclog and hence there is no need to separate them for ordering.
> > 
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
> >  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_log_cil.c  |  7 ++++++
> >  fs/xfs/xfs_log_priv.h |  2 ++
> >  3 files changed, 64 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index fa284f26d10e..ff26fb46d70f 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> > + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> > + * holds no log locks.
> > + *
> > + * We walk backwards through the iclogs to find the iclog with the highest lsn
> > + * in the range that we need to wait for and then wait for it to complete.
> > + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> > + * candidate iclog we need to sleep on have been complete by the time our
> > + * candidate has completed it's IO.
> > + *
> > + * Therefore we only need to find the first iclog that isn't clean within the
> > + * span of our flush range. If we come across a clean, newly activated iclog
> > + * with a lsn of 0, it means IO has completed on this iclog and all previous
> > + * iclogs will be have been completed prior to this one. Hence finding a newly
> > + * activated iclog indicates that there are no iclogs in the range we need to
> > + * wait on and we are done searching.
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
> > +
> > +		/* Don't need to wait on completed, clean iclogs */
> > +		if (prev->ic_state == XLOG_STATE_DIRTY ||
> > +		    prev->ic_state == XLOG_STATE_ACTIVE) {
> > +			continue;
> > +		}
> > +
> > +		/* wait for completion on this iclog */
> > +		xlog_wait(&prev->ic_force_wait, &log->l_icloglock);
> 
> You haven't addressed my feedback from the previous version. In
> particular the bit about whether it is safe to block on ->ic_force_wait
> from here considering some of our more quirky buffer locking behavior.

Sorry, first I've heard about this. I don't have any such email in
my inbox.

I don't know what waiting on an iclog in the middle of a checkpoint
has to do with buffer locking behaviour, because iclogs don't use
buffers and we block waiting on iclog IO completion all the time in
xlog_state_get_iclog_space(). If it's not safe to block on iclog IO
completion here, then it's not safe to block on an iclog in
xlog_state_get_iclog_space(). That's obviously not true, so I'm
really not sure what the concern here is...

> That aside, this iteration logic all seems a bit overengineered to me.
> We have the commit record iclog of the current checkpoint and thus the
> immediately previous iclog in the ring. We know that previous record
> isn't earlier than start_lsn because the caller confirmed that start_lsn
> != commit_lsn. We also know that iclog can't become dirty -> active
> until it and all previous iclog writes have completed because the
> callback ordering implemented by xlog_state_do_callback() won't clean
> the iclog until that point. Given that, can't this whole thing be
> replaced with a check of iclog->prev to either see if it's been cleaned
> or to otherwise xlog_wait() for that condition and return?

Maybe. I was more concerned about ensuring that it did the right
thing so I checked all the things that came to mind. There was more
than enough compexity in other parts of this patchset to fill my
brain that minimal implementation were not a concern. I'll go take
another look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
