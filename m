Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DBBC48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 22:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4346128B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 22:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFOWLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:11:53 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34802 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhFOWLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 18:11:52 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3665F1B0C56;
        Wed, 16 Jun 2021 08:09:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltHFg-00DCAH-1h; Wed, 16 Jun 2021 08:09:44 +1000
Date:   Wed, 16 Jun 2021 08:09:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <20210615220944.GW664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615161921.GC158209@locust>
 <YMjJZigzh3AbpOPA@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=7yxSLlwqS3lPvJho:21 a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=MHYTx9tbKSh7xjOA1ZUA:9 a=CjuIK1q_8ugA:10
        a=ryn_BjxYRQEVhTpXJPha:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 11:38:14AM -0400, Brian Foster wrote:
> On Tue, Jun 15, 2021 at 04:46:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The iclogbuf ring attached to the struct xlog is circular, hence the
> > first and last iclogs in the ring can only be determined by
> > comparing them against the log->l_iclog pointer.
> > 
> > In xfs_cil_push_work(), we want to wait on previous iclogs that were
> > issued so that we can flush them to stable storage with the commit
> > record write, and it simply waits on the previous iclog in the ring.
> > This, however, leads to CIL push hangs in generic/019 like so:
> > 
> > task:kworker/u33:0   state:D stack:12680 pid:    7 ppid:     2 flags:0x00004000
> > Workqueue: xfs-cil/pmem1 xlog_cil_push_work
> > Call Trace:
> >  __schedule+0x30b/0x9f0
> >  schedule+0x68/0xe0
> >  xlog_wait_on_iclog+0x121/0x190
> >  ? wake_up_q+0xa0/0xa0
> >  xlog_cil_push_work+0x994/0xa10
> >  ? _raw_spin_lock+0x15/0x20
> >  ? xfs_swap_extents+0x920/0x920
> >  process_one_work+0x1ab/0x390
> >  worker_thread+0x56/0x3d0
> >  ? rescuer_thread+0x3c0/0x3c0
> >  kthread+0x14d/0x170
> >  ? __kthread_bind_mask+0x70/0x70
> >  ret_from_fork+0x1f/0x30
> > 
> > With other threads blocking in either xlog_state_get_iclog_space()
> > waiting for iclog space or xlog_grant_head_wait() waiting for log
> > reservation space.
> > 
> > The problem here is that the previous iclog on the ring might
> > actually be a future iclog. That is, if log->l_iclog points at
> > commit_iclog, commit_iclog is the first (oldest) iclog in the ring
> > and there are no previous iclogs pending as they have all completed
> > their IO and been activated again. IOWs, commit_iclog->ic_prev
> > points to an iclog that will be written in the future, not one that
> > has been written in the past.
> > 
> > Hence, in this case, waiting on the ->ic_prev iclog is incorrect
> > behaviour, and depending on the state of the future iclog, we can
> > end up with a circular ABA wait cycle and we hang.
> > 
> > Fix this by only waiting on the previous iclog when the commit_iclog
> > is not the oldest iclog in the ring.
> > 
> > Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 705619e9dab4..398f00cf9cbf 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -1075,15 +1075,21 @@ xlog_cil_push_work(
> >  	ticket = ctx->ticket;
> >  
> >  	/*
> > -	 * If the checkpoint spans multiple iclogs, wait for all previous
> > -	 * iclogs to complete before we submit the commit_iclog. In this case,
> > -	 * the commit_iclog write needs to issue a pre-flush so that the
> > -	 * ordering is correctly preserved down to stable storage.
> > +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> > +	 * to complete before we submit the commit_iclog. If the commit iclog is
> > +	 * at the head of the iclog ring, then all other iclogs have completed
> > +	 * and are waiting on this one and hence we don't need to wait.
> > +	 *
> > +	 * Regardless of whether we need to wait or not, the the commit_iclog
> > +	 * write needs to issue a pre-flush so that the ordering for this
> > +	 * checkpoint is correctly preserved down to stable storage.
> >  	 */
> >  	spin_lock(&log->l_icloglock);
> >  	if (ctx->start_lsn != commit_lsn) {
> > -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > -		spin_lock(&log->l_icloglock);
> > +		if (commit_iclog != log->l_iclog) {
> > +			xlog_wait_on_iclog(commit_iclog->ic_prev);
> > +			spin_lock(&log->l_icloglock);
> > +		}

Brian says:

> I'm confused at what this is attempting to accomplish. If we have a
> single CIL force and that happens to span several iclogs, isn't the goal
> to wait on the previous iclog to ensure the previously written content
> of the current checkpoint is on-disk?

Yes. I wouldn't be surprised if I broke something, though, because I
was only looking at situation where the log hang was occurring.

I think I should have added a state check on the commit_iclog being
in ACTIVE state, too, because if it is active then there are no
future iclogs in flight and we should definitely wait. But that
doesn't solve the problem, either, because if it is in WANT_SYNC
there are future iclogs in flight (because
xlog_state_get_iclog_space() has switched iclogs) and then we're in
trouble because....


Darrick says:

> I'm confused.  How can you tell that we need to wait for
> commit_iclog->ic_prev to be written out by comparing commit_iclog to
> log->l_iclog?  Can't you determine this by checking ic_prev for DIRTY
> state?

.... the problem is that we can't tell if ->ic_prev is a future or
past iclog based on it's state. If it is in the past the ic_prev
iclog could be in any state from WANT_SYNC to ACTIVE, depending on
where the IO completion is. And if it's in the future, it could be
in any state from ACTIVE to SYNC_DONE. It's the overlap in
past/future states that causes the problem here.

Being in DIRTY state just means that IO completion is running,
callbacks are complete and we're about to run a ic_force_wait queue
wakeup and activate the iclog again. When the hang occurs, the
future iclogs are stuck in the DONE_SYNC state and can't progress
through to the callback state, let alone dirty...

Even an iclog in ACTIVE state doesn't mean it is in the past - it
just means that it's ready to be written to. It could be being
filled at this point in time by another checkpoint via xlog_write(),
and it, at any point in time, can transition to WANT_SYNC, SYNCING,
or SYNC_DONE.

xlog_wait_on_iclog() will ignore ACTIVE/DIRTY iclogs, anyway, but
the problem is that a future iclog can still transition at any time
to WANT_SYNC or any other state indicating IO is in progress. Hence
we just can't tell if it is a past or future iclog and so we can't
blindly wait on it. In the common case, ic_prev is a past iclog and
it won't get stuck on the commit_iclog being ACTIVE/WANT_SYNC at the
head of the log->l_iclog ring in xlog_state_do_callback() and so
will be processed and go back to ACTIVE state. However, in the rare
case it is a future iclog, then it gets stuck waiting for IO
completion of the commit_iclog to reach xlog_state_do_callback()....

----

What I was trying to take into account via the (commit_iclog !=
log->l_iclog) check was a measure of past/future tense. The hang
always occurs where commit_iclog == log->l_iclog and all ic_next
iclogs are future iclogs rather than being past iclogs. As Brian
notes, this probably just broke the single commit case, but because
the failure stress tests load up the log greatly, they don't
exercise that case.

So I went and looked at all the cases where we check
ic_prev->ic_state to make decisions. There's only one place that
does that: log forces. The sync transaction/log force aggregation
code is the only thing that checks the state of the previous iclog,
and it appears to avoid the "future iclog" problem in two ways.
First, it only checks the previous iclog state when the current head
iclog state is ACTIVE (i.e. no future iclogs). Secondly, even if it
ic-prev is a future iclog, it only waits on the ic_write_wait queue,
which means the log force gets woken when IO completion occurs and
the iclog transitions to DONE_SYNC, hence it never waits for
ordering of callbacks (other log force code does that).

IOWs, there's only one place that actually tries to use the previous
iclog state for making decisions, and it does doesn't really handle
the case we need to handle here which is determining if the previous
iclog is a past or future iclog. I does, however, handle the case of
incorrect waiting safely.

That is, what we need to wait for in the CIL push is the completion
of the physical IO to be signalled, not for the callbacks associated
with that iclog to run. IOWs, neat as it may be,
xlog_wait_on_iclog() is not the right function to be using here. We
should be waiting on the ic_write_wait queue to be woken when iclog
IO completion occurs, not the ic_force_wait queue that waits on
ordered completion of entire journal checkpoints. We just want to
ensure that all previous iclogs are physically completed before we
do the pre-flush on the commit record IO, we don't need software
processing of those IOs to be complete.

So, I think the right thing to do here is change this code to wait
on the ic_write_wait queue for completion of the previous iclog and
then we just don't care if commit_iclog->ic_prev is a past or future
iclog....



-- 
Dave Chinner
david@fromorbit.com
