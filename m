Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D1AC4741F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 12:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 958DA20848
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 12:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UajketNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgI2M2J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:28:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729745AbgI2M1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 08:27:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601382465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=txyQFxqj6vOMHKmfYAkJwYWUYe/Tpw9jxOKDjclCm84=;
        b=UajketNrAkFaVyTRx+VYNFt7Q49mILnvK/ri3BG5ji9cnsUNAyTL/qZAKpTTCwWORfOM4S
        WlbDVxl2nR6CbK9GB8i93MU1zjkMngvll2ptrcPghTt3iPQl9tLiPRIKomt5jdnxgs5fj5
        HSSL7yP3sYr+4x9fRZqZHLMfVmnLOUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-ccNQOfz9PiaeVO9XnexDsg-1; Tue, 29 Sep 2020 08:27:43 -0400
X-MC-Unique: ccNQOfz9PiaeVO9XnexDsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DC83800683;
        Tue, 29 Sep 2020 12:27:42 +0000 (UTC)
Received: from bfoster (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8258C60F96;
        Tue, 29 Sep 2020 12:27:41 +0000 (UTC)
Date:   Tue, 29 Sep 2020 08:27:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200929122739.GA99116@bfoster>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
 <20200928151627.GA4883@bfoster>
 <20200928230910.GH14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928230910.GH14422@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 09:09:10AM +1000, Dave Chinner wrote:
> On Mon, Sep 28, 2020 at 11:16:27AM -0400, Brian Foster wrote:
> > On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> > > On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > > > +xfs_defer_relog(
> > > > +	struct xfs_trans		**tpp,
> > > > +	struct list_head		*dfops)
> > > > +{
> > > > +	struct xfs_defer_pending	*dfp;
> > > > +	xfs_lsn_t			threshold_lsn;
> > > > +
> > > > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > > +
> > > > +	/*
> > > > +	 * Figure out where we need the tail to be in order to maintain the
> > > > +	 * minimum required free space in the log.
> > > > +	 */
> > > > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > > > +	if (threshold_lsn == NULLCOMMITLSN)
> > > > +		return 0;
> > > 
> > > This smells of premature optimisation.
> > > 
> > > When we are in a tail-pushing scenario (i.e. any sort of
> > > sustained metadata workload) this will always return true, and so we
> > > will relog every intent that isn't in the current checkpoint every
> > > time this is called.  Under light load, we don't care if we add a
> > > little bit of relogging overhead as the CIL slowly flushes/pushes -
> > > it will have neglible impact on performance because there is little
> > > load on the journal.
> > > 
> > 
> > That seems like an overly broad and not necessarily correct assumption.
> > The threshold above is tail relative and hardcoded (with the zero param)
> > to the default AIL pushing threshold, which is 25% of the log. If we
> 
> The pushing threshold is 75% of the log space has been reserved by
> the grant head, not that there's only 25% of the log free. The
> reservation is typically much, much larger than the change that is
> actually written to the log, and so we can be tail pushing even when
> the log is largely empty and the CIL hasn't reached it's threshold
> for pushing.
> 
> Think about it - if we have a log with a 256kB log stripe unit,
> a itruncate reservation is somewhere around 1.5MB in size (700kB *
> 2), and if we have reflink/rmap enabled, it's closer to 6MB in size.
> Yet a typical modification will not use any of the 512kB*8 space
> reserved for the LSU (because CIL!) and might only use 10kB of new
> log space in the CIL because that's all that was newly dirtied.
> 
> That means we reserve 6MB of log space for each itruncate
> transaction in flight, (directory ops are almost as heavyweight) so
> it only takes 16 transactions in flight to consume 100MB of reserve
> grant head space. If we've got a log smaller than 130MB in this
> situation, we are into tail pushing -even if the physical log is
> empty-.
> 
> IOWs, tail pushing is not triggered by how much physical log space
> has been consumed - it is triggered by reservation pressure. And we
> can trivially drive the system into reservation pressure with
> concurrent workloads
> 

Yes, I understand. What I'm saying is that once we get past the
reservation head checks, there is a threshold lsn check that requires an
intent sit in that 25% range from the on-disk tail of the log for it to
be relogged. That _might_ unnecessarily relog in certain cases (i.e.
when the active range of the log is small), but it is not always the
case and I don't think it results in per CIL context relogging in
practice.

> > assume sustained tail pushing conditions, a committed intent doesn't
> > trigger relog again until it falls within that threshold in the on-disk
> > log. The current CIL (nonblocking) size threshold is half that at 12.5%.
> 
> Or smaller. For small logs it is 12.5% of the log size. For larger
> logs, it caps at 32MB (8 * (256k << 4)).
> 
> > So relative to a given rolling transaction processing an intent chain,
> > there's a decent number of full CIL checkpoints that can occur before
> > any of those intents need to relog again (if at all), regardless of log
> > size.
> 
> Your logic is inverted because reservation pressure does not reflect
> CIL pressure.  Log space consumption and reservation pressure were
> decoupled by the in-memory relogging that the CIL enables, hence
> given a specific intent chain, the likely probability is that it
> will not span more than a single CIL context. i.e. it will complete
> rolling entirely within a single CIL commit.
> 
> As the log gets larger and the CIL increases in size, the
> probability that an intent chain completes within a single CIL
> commit goes up (e.g. 6MB reservation vs 32MB CIL push threshold).
> The lighter the load, the more likely it is that a transaction chain
> will complete within a single CIL checkpoint, even on small logs.
> 

Sure, I agree with that. That's not a major factor for intent chains
that pin the log tail long enough to cause deadlocks.

> > Without that logic, we're changing behavior to relog the entire chain in
> > every CIL checkpoint. That's a fairly significant change in behavior
> > with less predictable breakdown conditions. Do we know how long a single
> > chain is going to be?
> 
> Yes: the typical worst case chain length is defined by the
> transaction reservation log count. That is supposed to cover > %99
> of typical log space requirements for that operation.
> 

I don't think reservation log counts define worst case conditions for
intent chains. Darrick has documented cases in the commit logs that far
exceed those values. I'm assuming those are legitimate/observed
scenarios, but could be mistaken.

> For any chain that is longer than this, we end up in the slow
> regrant path that reserves a unit of log space at a time, and these
> are the cases where the transaction must be careful about not
> pinning the tail of the log. i.e. long chains are exactly the case
> where we want to relog the intents in every new CIL context. This is
> no different to the way we relog the inode in -every transaction
> roll- whether it is modified or not so that we can guarantee it
> doesn't pin the tail of the log when we need to regrant space on
> commit....
> 

Yes, the relogging approach is the same. The difference is that in one
case we're logging a small, fixed size (inode) object repeatedly that is
already factored into the transaction reservation and in the other case,
we're logging a dynamic and non-deterministic number of (intent) objects
a non-deterministic number of times.

> > Do we know how many CPUs are concurrently
> > processing "long chain" operations?
> 
> Yes: as many as the grant head reservations will allow. That's
> always been the bound maximum transaction concurrency we can
> support.
> 
> > Do we know whether an external
> > workload is causing even more frequent checkpoints than governed by the
> > CIL size limit?
> 
> Irrelevant, because checkpoint frequency affects the relogging
> efficiency of -everything- that running transactions. i.e. the
> impact is not isolated to relogging a few small intents, it affects
> relogging of all metadata, from AG headers to btree blocks,
> directories and inodes. IOWs, the overhead of relogging intents
> will be lost in the overhead of completely relogging entire dirty
> metadata blocks that the transactions also touch, even though they
> may have only newly dirtied a few bytes in each buffer.
> 
> > The examples in the commit logs in this series refer to
> > chains of hundreds of intents with hundreds of transaction rolls.
> 
> Truncating a file with 10 million extents will roll the transaction
> 10 million times. Having a long intent chain is no different from a
> "don't pin the tail of the log" perspective than truncating a
> badly fragmented file. Both need to relog their outstanding items
> that could pin the tail of the log as frequently as they commit...
> 
> This is a basic principle of permanent transactions: they must
> guarantee forwards progress by ensuring they can't pin the tail of
> the log at any time. That is, if you hold an item that *may* pin the
> tail of the log when you need to regrant log space, you need to move
> those items to the head of the log -before- you attempt to regrant
> log space. We do not do that with intents, and conditional relogging
> doesn't provide that guarantee, either.  Relogging the item once the
> item is no longer at the head of the log provides that forwards
> progress guarantee.
> 

It sounds like there's a correctness argument buried in here. If you
think the tail lsn threshold approach is not fundamentally correct, can
you please elaborate on that? I think fundamental correctness is far
more important at this early stage than the prospective impact of
cacheline contention caused by an implementation detail.

> I don't want to slap a band-aid over the problem in the name of
> "performance". Correctness comes first, then if we find a
> performance problem we'll address that without breaking correctness.
> 
...
> > > However, when we are under heavy load the code will now be reading
> > > the grant head and log position accounting variables during every
> > > commit, hence greatly increasing the number and temporal
> > > distribution of accesses to the hotest cachelines in the log. We
> > > currently never access these cache lines during commit unless the
> > > unit reservation has run out and we have to regrant physical log
> > > space for the transaction to continue (i.e. we are into slow path
> > > commit code). IOWs, this is like causing far more than double the
> > > number of accesses to the grant head, the log tail, the
> > > last_sync_lsn, etc, all of which is unnecessary exactly when we care
> > > about minimising contention on the log space accounting variables...
> > > 
> > 
> > If we're under sustained tail pushing pressure, blocking transactions
> > have already hit this cacheline as well, FWIW.
> 
> No, tail pushing != blocking. If the AIL pushing is keeping up with
> the targets that are being set (as frequently happens with large
> logs and fast storage), then we rarely run out of log space and we
> do not block new reservations waiting for reservation space.
> 

Just pointing out that there's another prospective path for a
transaction to hit the cacheline. As you've already pointed out, it's
quite easy to reach reservation blocking conditions before the AIL is
even involved.

> > But if we're concerned about cacheline access in the commit path
> > specifically, I'm sure we could come up with any number of optimizations
> > to address that directly. E.g., we could sample the threshold
> > occasionally instead of on every roll, wait until the current
> > transaction has consumed all logres units (where we'll be hitting that
> > line anyways), shift state tracking over to xfsaild via setting a flag
> > on log items with an ->iop_relog() handler set that happen to pin the
> > tail, etc. etc. That said, I do think any such added complexity should
> > be justified with some accompanying profiling data (and I like the idea
> > of new stats counters mentioned in the separate mail).
> 
> Yes, there's lots of ways the pushing threshold could be done
> differently, but to focus on that misses the point that intents
> violate forwards progress guarantees rolling transactions are
> supposed to provide the log. I simply made the "access overhead"
> argument as a supporting point that this change is also likely to
> have unintended side effects...
> 

The argument stated was that the relog filtering was redundant logic. I
think that misinterprets the logic. If there's a correctness issue, then
I'd much prefer to focus on that..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

