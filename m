Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35781C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F8664E6C
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346884AbhCDARl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1448128AbhCCPXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 10:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614784935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=29R/YrkKjTgVYvKeyDh5PyX3uX/w95M88Tpns6QJVvA=;
        b=glCaLQhOz4XESgHu+T0y66D0RaNOT/l9CnjbvHs1cE/bSbCFfGInE/Kx1NQrGmQfSlt03M
        HG0ZRTCuPI2+lUHO5/1EENJe0EU3M2MVXNgC6mn+bKHfc6KcP9WgjWtQ67ORqrcQ4wKEcZ
        BnpNW72dhm6/2zMFXw+KIou7zYxtxTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-ZM4izBG7MYKTaQ8dRkn07Q-1; Wed, 03 Mar 2021 10:22:12 -0500
X-MC-Unique: ZM4izBG7MYKTaQ8dRkn07Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E6E8100A8F9;
        Wed,  3 Mar 2021 15:22:11 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9FBC5C241;
        Wed,  3 Mar 2021 15:22:10 +0000 (UTC)
Date:   Wed, 3 Mar 2021 10:22:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <YD+pnbuyyup8tBRN@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
 <YD0GCCPmCkoYBVK0@bfoster>
 <20210303004119.GL4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303004119.GL4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 11:41:19AM +1100, Dave Chinner wrote:
> On Mon, Mar 01, 2021 at 10:19:36AM -0500, Brian Foster wrote:
> > On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > To allow for iclog IO device cache flush behaviour to be optimised,
> > > we first need to separate out the commit record iclog IO from the
> > > rest of the checkpoint so we can wait for the checkpoint IO to
> > > complete before we issue the commit record.
> > > 
> > > This separation is only necessary if the commit record is being
> > > written into a different iclog to the start of the checkpoint as the
> > > upcoming cache flushing changes requires completion ordering against
> > > the other iclogs submitted by the checkpoint.
> > > 
> > > If the entire checkpoint and commit is in the one iclog, then they
> > > are both covered by the one set of cache flush primitives on the
> > > iclog and hence there is no need to separate them for ordering.
> > > 
> > > Otherwise, we need to wait for all the previous iclogs to complete
> > > so they are ordered correctly and made stable by the REQ_PREFLUSH
> > > that the commit record iclog IO issues. This guarantees that if a
> > > reader sees the commit record in the journal, they will also see the
> > > entire checkpoint that commit record closes off.
> > > 
> > > This also provides the guarantee that when the commit record IO
> > > completes, we can safely unpin all the log items in the checkpoint
> > > so they can be written back because the entire checkpoint is stable
> > > in the journal.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_log_cil.c  |  7 ++++++
> > >  fs/xfs/xfs_log_priv.h |  2 ++
> > >  3 files changed, 64 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index fa284f26d10e..ff26fb46d70f 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> > > + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> > > + * holds no log locks.
> > > + *
> > > + * We walk backwards through the iclogs to find the iclog with the highest lsn
> > > + * in the range that we need to wait for and then wait for it to complete.
> > > + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> > > + * candidate iclog we need to sleep on have been complete by the time our
> > > + * candidate has completed it's IO.
> > > + *
> > > + * Therefore we only need to find the first iclog that isn't clean within the
> > > + * span of our flush range. If we come across a clean, newly activated iclog
> > > + * with a lsn of 0, it means IO has completed on this iclog and all previous
> > > + * iclogs will be have been completed prior to this one. Hence finding a newly
> > > + * activated iclog indicates that there are no iclogs in the range we need to
> > > + * wait on and we are done searching.
> > > + */
> > > +int
> > > +xlog_wait_on_iclog_lsn(
> > > +	struct xlog_in_core	*iclog,
> > > +	xfs_lsn_t		start_lsn)
> > > +{
> > > +	struct xlog		*log = iclog->ic_log;
> > > +	struct xlog_in_core	*prev;
> > > +	int			error = -EIO;
> > > +
> > > +	spin_lock(&log->l_icloglock);
> > > +	if (XLOG_FORCED_SHUTDOWN(log))
> > > +		goto out_unlock;
> > > +
> > > +	error = 0;
> > > +	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
> > > +
> > > +		/* Done if the lsn is before our start lsn */
> > > +		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
> > > +				start_lsn) < 0)
> > > +			break;
> > > +
> > > +		/* Don't need to wait on completed, clean iclogs */
> > > +		if (prev->ic_state == XLOG_STATE_DIRTY ||
> > > +		    prev->ic_state == XLOG_STATE_ACTIVE) {
> > > +			continue;
> > > +		}
> > > +
> > > +		/* wait for completion on this iclog */
> > > +		xlog_wait(&prev->ic_force_wait, &log->l_icloglock);
> > 
> > You haven't addressed my feedback from the previous version. In
> > particular the bit about whether it is safe to block on ->ic_force_wait
> > from here considering some of our more quirky buffer locking behavior.
> 
> Sorry, first I've heard about this. I don't have any such email in
> my inbox.
> 

For reference, the last bit of this mail:

https://lore.kernel.org/linux-xfs/20210201160737.GA3252048@bfoster/

> I don't know what waiting on an iclog in the middle of a checkpoint
> has to do with buffer locking behaviour, because iclogs don't use
> buffers and we block waiting on iclog IO completion all the time in
> xlog_state_get_iclog_space(). If it's not safe to block on iclog IO
> completion here, then it's not safe to block on an iclog in
> xlog_state_get_iclog_space(). That's obviously not true, so I'm
> really not sure what the concern here is...
> 

I think the broader question is not so much whether it's safe to block
here or not, but whether our current use of async log forces might have
a deadlock vector (which may or may not also include the
_get_iclog_space() scenario, I'd need to stare at that one a bit). I
referred to buffer locking because the buffer ->iop_unpin() handler can
attempt to acquire a buffer lock.

Looking again, that is the only place I see that blocks in iclog
completion callbacks and it's actually an abort scenario, which means
shutdown. I am slightly concerned that introducing more regular blocking
in the CIL push might lead to more frequent async log forces that block
on callback iclogs and thus exacerbate that issue (i.e. somebody might
be able to now reproduce yet another shutdown deadlock scenario to track
down that might not have been reproducible before, for whatever reason),
but that's probably not a serious enough problem to block this patch and
the advantages of the series overall.

Brian

> > That aside, this iteration logic all seems a bit overengineered to me.
> > We have the commit record iclog of the current checkpoint and thus the
> > immediately previous iclog in the ring. We know that previous record
> > isn't earlier than start_lsn because the caller confirmed that start_lsn
> > != commit_lsn. We also know that iclog can't become dirty -> active
> > until it and all previous iclog writes have completed because the
> > callback ordering implemented by xlog_state_do_callback() won't clean
> > the iclog until that point. Given that, can't this whole thing be
> > replaced with a check of iclog->prev to either see if it's been cleaned
> > or to otherwise xlog_wait() for that condition and return?
> 
> Maybe. I was more concerned about ensuring that it did the right
> thing so I checked all the things that came to mind. There was more
> than enough compexity in other parts of this patchset to fill my
> brain that minimal implementation were not a concern. I'll go take
> another look at it.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

