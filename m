Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFB4C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 23:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0D12076A
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 23:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgI1Xes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:34:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56913 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgI1Xes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 19:34:48 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7CB923AAEDB;
        Tue, 29 Sep 2020 09:09:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kN2Gc-0007AH-9z; Tue, 29 Sep 2020 09:09:10 +1000
Date:   Tue, 29 Sep 2020 09:09:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200928230910.GH14422@dread.disaster.area>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
 <20200928151627.GA4883@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928151627.GA4883@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=eJfxgxciAAAA:8 a=7-415B0cAAAA:8
        a=pqlqNcGz_VZVua4l6aUA:9 a=NytZxH15jsp84EeW:21 a=EHmayZst4U5jbfoL:21
        a=CjuIK1q_8ugA:10 a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 28, 2020 at 11:16:27AM -0400, Brian Foster wrote:
> On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> > On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > > +xfs_defer_relog(
> > > +	struct xfs_trans		**tpp,
> > > +	struct list_head		*dfops)
> > > +{
> > > +	struct xfs_defer_pending	*dfp;
> > > +	xfs_lsn_t			threshold_lsn;
> > > +
> > > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > +
> > > +	/*
> > > +	 * Figure out where we need the tail to be in order to maintain the
> > > +	 * minimum required free space in the log.
> > > +	 */
> > > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > > +	if (threshold_lsn == NULLCOMMITLSN)
> > > +		return 0;
> > 
> > This smells of premature optimisation.
> > 
> > When we are in a tail-pushing scenario (i.e. any sort of
> > sustained metadata workload) this will always return true, and so we
> > will relog every intent that isn't in the current checkpoint every
> > time this is called.  Under light load, we don't care if we add a
> > little bit of relogging overhead as the CIL slowly flushes/pushes -
> > it will have neglible impact on performance because there is little
> > load on the journal.
> > 
> 
> That seems like an overly broad and not necessarily correct assumption.
> The threshold above is tail relative and hardcoded (with the zero param)
> to the default AIL pushing threshold, which is 25% of the log. If we

The pushing threshold is 75% of the log space has been reserved by
the grant head, not that there's only 25% of the log free. The
reservation is typically much, much larger than the change that is
actually written to the log, and so we can be tail pushing even when
the log is largely empty and the CIL hasn't reached it's threshold
for pushing.

Think about it - if we have a log with a 256kB log stripe unit,
a itruncate reservation is somewhere around 1.5MB in size (700kB *
2), and if we have reflink/rmap enabled, it's closer to 6MB in size.
Yet a typical modification will not use any of the 512kB*8 space
reserved for the LSU (because CIL!) and might only use 10kB of new
log space in the CIL because that's all that was newly dirtied.

That means we reserve 6MB of log space for each itruncate
transaction in flight, (directory ops are almost as heavyweight) so
it only takes 16 transactions in flight to consume 100MB of reserve
grant head space. If we've got a log smaller than 130MB in this
situation, we are into tail pushing -even if the physical log is
empty-.

IOWs, tail pushing is not triggered by how much physical log space
has been consumed - it is triggered by reservation pressure. And we
can trivially drive the system into reservation pressure with
concurrent workloads

> assume sustained tail pushing conditions, a committed intent doesn't
> trigger relog again until it falls within that threshold in the on-disk
> log. The current CIL (nonblocking) size threshold is half that at 12.5%.

Or smaller. For small logs it is 12.5% of the log size. For larger
logs, it caps at 32MB (8 * (256k << 4)).

> So relative to a given rolling transaction processing an intent chain,
> there's a decent number of full CIL checkpoints that can occur before
> any of those intents need to relog again (if at all), regardless of log
> size.

Your logic is inverted because reservation pressure does not reflect
CIL pressure.  Log space consumption and reservation pressure were
decoupled by the in-memory relogging that the CIL enables, hence
given a specific intent chain, the likely probability is that it
will not span more than a single CIL context. i.e. it will complete
rolling entirely within a single CIL commit.

As the log gets larger and the CIL increases in size, the
probability that an intent chain completes within a single CIL
commit goes up (e.g. 6MB reservation vs 32MB CIL push threshold).
The lighter the load, the more likely it is that a transaction chain
will complete within a single CIL checkpoint, even on small logs.

> Without that logic, we're changing behavior to relog the entire chain in
> every CIL checkpoint. That's a fairly significant change in behavior
> with less predictable breakdown conditions. Do we know how long a single
> chain is going to be?

Yes: the typical worst case chain length is defined by the
transaction reservation log count. That is supposed to cover > %99
of typical log space requirements for that operation.

For any chain that is longer than this, we end up in the slow
regrant path that reserves a unit of log space at a time, and these
are the cases where the transaction must be careful about not
pinning the tail of the log. i.e. long chains are exactly the case
where we want to relog the intents in every new CIL context. This is
no different to the way we relog the inode in -every transaction
roll- whether it is modified or not so that we can guarantee it
doesn't pin the tail of the log when we need to regrant space on
commit....

> Do we know how many CPUs are concurrently
> processing "long chain" operations?

Yes: as many as the grant head reservations will allow. That's
always been the bound maximum transaction concurrency we can
support.

> Do we know whether an external
> workload is causing even more frequent checkpoints than governed by the
> CIL size limit?

Irrelevant, because checkpoint frequency affects the relogging
efficiency of -everything- that running transactions. i.e. the
impact is not isolated to relogging a few small intents, it affects
relogging of all metadata, from AG headers to btree blocks,
directories and inodes. IOWs, the overhead of relogging intents
will be lost in the overhead of completely relogging entire dirty
metadata blocks that the transactions also touch, even though they
may have only newly dirtied a few bytes in each buffer.

> The examples in the commit logs in this series refer to
> chains of hundreds of intents with hundreds of transaction rolls.

Truncating a file with 10 million extents will roll the transaction
10 million times. Having a long intent chain is no different from a
"don't pin the tail of the log" perspective than truncating a
badly fragmented file. Both need to relog their outstanding items
that could pin the tail of the log as frequently as they commit...

This is a basic principle of permanent transactions: they must
guarantee forwards progress by ensuring they can't pin the tail of
the log at any time. That is, if you hold an item that *may* pin the
tail of the log when you need to regrant log space, you need to move
those items to the head of the log -before- you attempt to regrant
log space. We do not do that with intents, and conditional relogging
doesn't provide that guarantee, either.  Relogging the item once the
item is no longer at the head of the log provides that forwards
progress guarantee.

I don't want to slap a band-aid over the problem in the name of
"performance". Correctness comes first, then if we find a
performance problem we'll address that without breaking correctness.

> Those types of scenarios are hard enough to reason about,
> particularly when we consider boxes with hundreds of CPUs, so I'm
> somewhat skeptical of us accurately predicting
> performance/behavior over an implementation that bounds processing
> more explicitly.  ISTM that these are all essentially undefined
> contributing factors.

I don't find these things hard to reason about, nor do I consider
them undefined factors. This is largely because I've been dealing
with journalling and AIL issues at this scale for the best part of
15 years. Everything I think about in this area starts with the
requirement "this needs to scale to 10,000+ concurrent transactions
across thousands of CPUs". The reason for that can be found in
ancient history, such as:

commit 249a8c1124653fa90f3a3afff869095a31bc229f
Author: David Chinner <dgc@sgi.com>
Date:   Tue Feb 5 12:13:32 2008 +1100

    [XFS] Move AIL pushing into it's own thread
    
    When many hundreds to thousands of threads all try to do simultaneous
    transactions and the log is in a tail-pushing situation (i.e. full), we
    can get multiple threads walking the AIL list and contending on the AIL
    lock.
....

commit 28f1bc4aabea316d01ca7a59c38d619bc17e3550
Author: Dave Chinner <dgc@sgi.com>
Date:   Fri Feb 15 15:19:57 2008 +0000

    Prevent AIL lock contention during transaction completion
    
    When hundreds of processors attempt to commit transactions at the
    same time, they can contend on the AIL lock when updating the tail
    LSN held in the in-core log structure.
....

The workload that lead to the lockless grant head reservation code,
the single threaded, cursor based AIL traversals, the atomic tail
accounting, etc was a MPI workload on a 2048p machine doing an MPI
synchronised close on ~6 fds per CPU on all CPUs at once. The
lockless log code reduced this part of the workload from 4 hours to
4 seconds....

Servers these days are still small compared to the SGI machines that
XFS ran on in the mid-2000s....

> > However, when we are under heavy load the code will now be reading
> > the grant head and log position accounting variables during every
> > commit, hence greatly increasing the number and temporal
> > distribution of accesses to the hotest cachelines in the log. We
> > currently never access these cache lines during commit unless the
> > unit reservation has run out and we have to regrant physical log
> > space for the transaction to continue (i.e. we are into slow path
> > commit code). IOWs, this is like causing far more than double the
> > number of accesses to the grant head, the log tail, the
> > last_sync_lsn, etc, all of which is unnecessary exactly when we care
> > about minimising contention on the log space accounting variables...
> > 
> 
> If we're under sustained tail pushing pressure, blocking transactions
> have already hit this cacheline as well, FWIW.

No, tail pushing != blocking. If the AIL pushing is keeping up with
the targets that are being set (as frequently happens with large
logs and fast storage), then we rarely run out of log space and we
do not block new reservations waiting for reservation space.

> But if we're concerned about cacheline access in the commit path
> specifically, I'm sure we could come up with any number of optimizations
> to address that directly. E.g., we could sample the threshold
> occasionally instead of on every roll, wait until the current
> transaction has consumed all logres units (where we'll be hitting that
> line anyways), shift state tracking over to xfsaild via setting a flag
> on log items with an ->iop_relog() handler set that happen to pin the
> tail, etc. etc. That said, I do think any such added complexity should
> be justified with some accompanying profiling data (and I like the idea
> of new stats counters mentioned in the separate mail).

Yes, there's lots of ways the pushing threshold could be done
differently, but to focus on that misses the point that intents
violate forwards progress guarantees rolling transactions are
supposed to provide the log. I simply made the "access overhead"
argument as a supporting point that this change is also likely to
have unintended side effects...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
