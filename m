Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8ADC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 13:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07370206CD
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 13:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388670AbfIFNKR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 09:10:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21055 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbfIFNKR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 09:10:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AABF518C893C;
        Fri,  6 Sep 2019 13:10:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42B5D1EE;
        Fri,  6 Sep 2019 13:10:16 +0000 (UTC)
Date:   Fri, 6 Sep 2019 09:10:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190906131014.GA62719@bfoster>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
 <20190904193442.GA52970@bfoster>
 <20190904225056.GL1119@dread.disaster.area>
 <20190905162533.GA59149@bfoster>
 <20190906000205.GL1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906000205.GL1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Fri, 06 Sep 2019 13:10:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 10:02:05AM +1000, Dave Chinner wrote:
> On Thu, Sep 05, 2019 at 12:25:33PM -0400, Brian Foster wrote:
> > On Thu, Sep 05, 2019 at 08:50:56AM +1000, Dave Chinner wrote:
> > > On Wed, Sep 04, 2019 at 03:34:42PM -0400, Brian Foster wrote:
> > > > On Wed, Sep 04, 2019 at 02:24:51PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > +/*
> > > > > + * Completion of a iclog IO does not imply that a transaction has completed, as
> > > > > + * transactions can be large enough to span many iclogs. We cannot change the
> > > > > + * tail of the log half way through a transaction as this may be the only
> > > > > + * transaction in the log and moving the tail to point to the middle of it
> > > > > + * will prevent recovery from finding the start of the transaction. Hence we
> > > > > + * should only update the last_sync_lsn if this iclog contains transaction
> > > > > + * completion callbacks on it.
> > > > > + *
> > > > > + * We have to do this before we drop the icloglock to ensure we are the only one
> > > > > + * that can update it.
> > > > > + *
> > > > > + * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> > > > > + * the reservation grant head pushing. This is due to the fact that the push
> > > > > + * target is bound by the current last_sync_lsn value. Hence if we have a large
> > > > > + * amount of log space bound up in this committing transaction then the
> > > > > + * last_sync_lsn value may be the limiting factor preventing tail pushing from
> > > > > + * freeing space in the log. Hence once we've updated the last_sync_lsn we
> > > > > + * should push the AIL to ensure the push target (and hence the grant head) is
> > > > > + * no longer bound by the old log head location and can move forwards and make
> > > > > + * progress again.
> > > > > + */
> > > > > +static void
> > > > > +xlog_state_set_callback(
> > > > > +	struct xlog		*log,
> > > > > +	struct xlog_in_core	*iclog,
> > > > > +	xfs_lsn_t		header_lsn)
> > > > > +{
> > > > > +	iclog->ic_state = XLOG_STATE_CALLBACK;
> > > > > +
> > > > > +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn), header_lsn) <= 0);
> > > > > +
> > > > > +	if (list_empty_careful(&iclog->ic_callbacks))
> > > > > +		return;
> > > > > +
> > > > > +	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> > > > > +	xlog_grant_push_ail(log, 0);
> > > > > +
> > > > 
> > > > Nit: extra whitespace line above.
> > > 
> > > Fixed.
> > > 
> > > > This still seems racy to me, FWIW. What if the AIL is empty (i.e. the
> > > > push is skipped)?
> > > 
> > > If the AIL is empty, then it's a no-op because pushing on the AIL is
> > > not going to make more log space become free. Besides, that's not
> > > the problem being solved here - reservation wakeups on first insert
> > > into the AIL are already handled by xfs_trans_ail_update_bulk() and
> > > hence the first patch in the series. This patch is addressing the
> > 
> > Nothing currently wakes up reservation waiters on first AIL insertion.
> 
> Nor should it be necessary - it's the removal from the AIL that
> frees up log space, not insertion. The update operation is a
> remove followed by an insert - the remove part of that operation is
> what may free up log space, not the insert.
> 

Just above you wrote: "reservation wakeups on first insert into the AIL
are already handled by xfs_trans_ail_update_bulk()". My reply was just
to point out that there are no wakeups in that case.

> Hence if we need to wake the log reservation waiters on first AIL
> insert to fix a bug, we haven't found the underlying problem is
> preventing log space from being freed...
> >
> > > i.e. the AIL is for moving the tail of the log - this code moves the
> > > head of the log. But both impact on the AIL push target (it is based on
> > > the distance between the head and tail), so we need
> > > to update the push target just in case this commit does not move
> > > the tail...
> > > 
> > > > What if xfsaild completes this push before the
> > > > associated log items land in the AIL or we race with xfsaild emptying
> > > > the AIL? Why not just reuse/update the existing grant head wake up logic
> > > > in the iclog callback itself? E.g., something like the following
> > > > (untested):
> > > > 
> > 
> > And the raciness concerns..? AFAICT this still opens a race window where
> > the AIL can idle on the push target before AIL insertion.
> 
> I don't know what race you see - if the AIL completes a push before
> we insert new objects at the head from the current commit, then it
> does not matter one bit because the items are being inserted at the
> log head, not the log tail where the pushing occurs at. If we are
> inserting objects into the AIL within the push target window, then
> there is something else very wrong going on, because when the log is
> out of space the push target should be nowhere near the LSN we are
> inserting inew objects into the AIL at. (i.e. they should be 3/4s of
> the log apart...)
> 

I'm not following your reasoning. It sounds to me that you're arguing it
doesn't matter that the AIL is not populated from the current commit
because the push target should be much farther behind the head. If
that's the case, why does this patch order the AIL push after a
->l_last_sync_lsn update? That's the LSN of the most recent commit
record to hit the log and hence the new physical log head.

Side note: I think the LSN of the commit record iclog is different and
actually ahead of the LSN associated with AIL insertion. I don't
necessarily think that's a problem given how the log subsystem behaves
today, but it's another subtle/undocumented (and easily avoidable) quirk
that may not always be so benign.

> > > So, from #1 we see that unconditional wakeups are not necessary in
> > > the scenario you pose, and from #2 it's not a viable solution even
> > > if it was required.
> > > 
> > > However, #1 indicates other problems if a xfs_log_space_wake() call
> > > is necessary in this case. No reservations space and an empty AIL
> > > implies that the CIL pins the entire log - a pending commit that
> > > hasn't finished flushing and the current context that is
> > > aggregating. This implies we've violated a much more important rule
> > > of the on-disk log format: finding the head and tail of the log
> > > requires no individual commit be larger than 50% of the log.
> > > 
> > 
> > I described this exact problem days ago in the original thread. There's
> > no need to rehash it here. FWIW, I can reproduce much worse than 50% log
> > consumption aggregated outside of the AIL with the current code and it
> > doesn't depend on a nonpreemptible kernel (though the workqueue fix
> > looks legit to me).
> 
...
> 
> i.e. we changed the unlinked inode processing in a way that
> the kernel can now runs tens of thousands of unlink transactions
> without yeilding the CPU. That violated the "CIL push work will run
> within a few transactions of the background push occurring"
> mechanism the workqueue provided us with and that, fundamentally, is
> the underlying issue here. It's not a CIL vs empty AIL vs log
> reservation exhaustion race condition - that's just an observable
> symptom.
> 

Yes, but the point is that's not the only thing that can delay CIL push
work. Since the AIL is not populated until the commit record iclog is
written out, and background CIL pushing doesn't flush the commit record
for the associated checkpoint before it completes, and CIL pushing
itself is serialized, a stalled commit record iclog I/O is enough to
create "log full, empty AIL" conditions.

> To that end, I have been prototyping patches to fix this exact problem
> as part of the non-blocking inode reclaim series. I've been looking at
> this because the CIL pins so much memory on large logs and I wanted to
> put an upper bound on it that wasn't measured in GBs of RAM. Hence I'm
> planning to pull these out into a separate series now as it's clear
> that non-preemptible kernels and workqueues do not play well together
> and that the more we use workqueues for async processing, the more we
> introduce a potential real-world vector for CIL overruns...
> 

Yes, I think a separate series for CIL management makes sense.

Brian

> Cheers,
> 
> Dave.  -- Dave Chinner david@fromorbit.com
