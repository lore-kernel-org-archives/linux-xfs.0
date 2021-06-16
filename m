Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFADC48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 22:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C01A613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 22:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhFPWXG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 18:23:06 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43556 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231702AbhFPWXG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 18:23:06 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A410B3107;
        Thu, 17 Jun 2021 08:20:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltdu2-00Da10-3Z; Thu, 17 Jun 2021 08:20:54 +1000
Date:   Thu, 17 Jun 2021 08:20:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <20210616222054.GZ664593@dread.disaster.area>
References: <20210615161921.GC158209@locust>
 <YMjJZigzh3AbpOPA@bfoster>
 <20210615220944.GW664593@dread.disaster.area>
 <YMoRWWI6Yt7FWySc@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMoRWWI6Yt7FWySc@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=7yxSLlwqS3lPvJho:21 a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=A61yMnrHXFwgtIV5dy8A:9 a=CjuIK1q_8ugA:10 a=ryn_BjxYRQEVhTpXJPha:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 10:57:29AM -0400, Brian Foster wrote:
> On Wed, Jun 16, 2021 at 08:09:44AM +1000, Dave Chinner wrote:
> > On Tue, Jun 15, 2021 at 11:38:14AM -0400, Brian Foster wrote:
> > > On Tue, Jun 15, 2021 at 04:46:58PM +1000, Dave Chinner wrote:
> > So I went and looked at all the cases where we check
> > ic_prev->ic_state to make decisions. There's only one place that
> > does that: log forces. The sync transaction/log force aggregation
> > code is the only thing that checks the state of the previous iclog,
> > and it appears to avoid the "future iclog" problem in two ways.
> > First, it only checks the previous iclog state when the current head
> > iclog state is ACTIVE (i.e. no future iclogs). Secondly, even if it
> > ic-prev is a future iclog, it only waits on the ic_write_wait queue,
> > which means the log force gets woken when IO completion occurs and
> > the iclog transitions to DONE_SYNC, hence it never waits for
> > ordering of callbacks (other log force code does that).
> > 
> > IOWs, there's only one place that actually tries to use the previous
> > iclog state for making decisions, and it does doesn't really handle
> > the case we need to handle here which is determining if the previous
> > iclog is a past or future iclog. I does, however, handle the case of
> > incorrect waiting safely.
> > 
> > That is, what we need to wait for in the CIL push is the completion
> > of the physical IO to be signalled, not for the callbacks associated
> > with that iclog to run. IOWs, neat as it may be,
> > xlog_wait_on_iclog() is not the right function to be using here. We
> > should be waiting on the ic_write_wait queue to be woken when iclog
> > IO completion occurs, not the ic_force_wait queue that waits on
> > ordered completion of entire journal checkpoints. We just want to
> > ensure that all previous iclogs are physically completed before we
> > do the pre-flush on the commit record IO, we don't need software
> > processing of those IOs to be complete.
> > 
> 
> Ok, but doesn't that leave a gap in scenarios where iclog completion
> occurs out of order? I thought the reason for waiting on the force of
> the previous iclog was to encapsulate that the entire content of the
> checkpoint has been written to disk, not just the content in the
> immediately previous iclog.

Yes. We either have to wait for all the iclogs to be written or
we have to use ic_force_wait for sequencing.

> If the issue is past/future tense, is there any reason we can't filter
> against the record header lsn of the previous iclog? E.g., assuming the
> iclog hasn't been cleaned/reactivated (i.e. h_lsn != 0), then only block
> on the previous iclog if XFS_LSN_CMP(prev_lsn, commit_lsn) <= 0?

That's what the patch I left running overnight does:

        /*
         * If the checkpoint spans multiple iclogs, wait for all previous iclogs
         * to complete before we submit the commit_iclog. We can't use state
         * checks for this - ACTIVE can be either a past completed iclog or a
         * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
         * past or future iclog awaiting IO or ordered IO completion to be run.
         * In the latter case, if it's a future iclog and we wait on it, the we
         * will hang because it won't get processed through to ic_force_wait
         * wakeup until this commit_iclog is written to disk.  Hence we use the
         * iclog header lsn and compare it to the commit lsn to determine if we
         * need to wait on iclogs or not.
         */
        spin_lock(&log->l_icloglock);
        if (ctx->start_lsn != ctx->commit_lsn) {
                struct xlog_in_core     *iclog;

                for (iclog = commit_iclog->ic_prev;
                     iclog != commit_iclog;
                     iclog = iclog->ic_prev) {
                        xfs_lsn_t       hlsn;

                        /*
                         * If the LSN of the iclog is zero or in the future it
                         * means it has passed through IO completion and
                         * activation and hence all previous iclogs have also
                         * done so. We do not need to wait at all in this case.
                         */
                        hlsn = be64_to_cpu(iclog->ic_header.h_lsn);
                        if (!hlsn || XFS_LSN_CMP(hlsn, ctx->commit_lsn) > 0)
                                break;

                        /*
                         * If the LSN of the iclog is older than the commit lsn,
                         * we have to wait on it. Waiting on this via the
                         * ic_force_wait should also order the completion of all
                         * older iclogs, too, but we leave checking that to the
                         * next loop iteration.
                         */
                        ASSERT(XFS_LSN_CMP(hlsn, ctx->commit_lsn) < 0);
                        xlog_wait_on_iclog(iclog);
                        spin_lock(&log->l_icloglock);
                }

                /*
                 * Regardless of whether we need to wait or not, the the
                 * commit_iclog write needs to issue a pre-flush so that the
                 * ordering for this checkpoint is correctly preserved down to
                 * stable storage.
                 */
                commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
        }


> Hmm.. that also has me wondering if it's possible that the previous
> iclog might be some other future checkpoint, but then skipping the wait
> entirely means the checkpoint might not actually be on-disk [1]. I

If the previous iclog is a future iclog, then all iclogs are future
iclogs and this iclog is the oldest. The iclog ring only ages in one
direction....

> wonder if we need to do something like track the last lsn and/or iclog
> touched by the current checkpoint and make sure we wait on that,
> regardless of where it is in the ring (but as above, I'm still wrapping
> my head around all of this).

We have to guarantee the log is completely stable up to the commit
record, regardless of which checkpoint the iclogs belong to.  If we
don't do that, then log recovery will consider that the checkpoint
in the log is not complete before it finds the commit record. i.e.
there will be a hole in the log where the previous cycle numbers
show through between the end of the checkpoint and the commit
record, and hence the head of the log will be pointed at the last
fully completed checkpoint, not this one.

Hence we have to ensure all prior iclogs have completed to stable
storage before writing the commit record, regardless of whether the
previous iclogs are part of the current checkpoint or not.

> [1] Once we work out the functional behavior one way or another, how do
> we actually test/confirm that the flush behavior works as expected? I
> feel as though the discussions going all the way to the initial review
> feedback on this change have provided constant reminders that things
> like the I/O flush / ordering dependencies are very easy to get wrong.
> If that is ever the case, it's not clear to me we have any way to detect
> it. Not that I'd expect to have some explicit 5 second fstest for that
> problem, but have we analyzed whether the few decent crash recovery
> tests we do have are sensitive enough to fail? I wonder if we could come
> up with something clever and more explicit via error injection..

Given that we've found these problems soon after the code was
integrated and made available for wider testing, I think it shows
that, at the integration level, we have sufficiently sensitive crash
and crash recovery tests to discover issues like this. It's not
surprising that we may not find things like this at the
individual developer level because they only have so much time and
resources at their disposal.

IOWs, I think the process is working exactly the way it should be
working. It is expected that complex, subtle problems like these
will be found (if they exist) once more people are actively using
and testing the code in a variety of different environments. THis is
exactly the function that integration testing is supposed to
provide...

So while it's possible that we could have more reliable test to
exercise this stuff (no real idea how, though), the way we are
developing and merging and finding much harder to trigger problems
once the code is available for wider testing shows that our
engineering process is working as it should be....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
