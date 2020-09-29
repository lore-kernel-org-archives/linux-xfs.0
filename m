Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E2BC4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 18:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8F32075E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 18:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2/FeveT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgI2Spl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 14:45:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728166AbgI2Spk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 14:45:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601405137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nj9tvy+OCqqVq7RDM7yvNOO3Z9mdkXPMmVXnTFyKISU=;
        b=H2/FeveTTlAsMXDS2nNS/NSDgXpFT2qGVmEf2n9h0qvrUmpWLXxyqhYzbW/7ojw+6yTebb
        lU7gXbq3+luKtdCc2n5DBdhkCb2856609FfQjXWkUCowSJEGcefKENMJrNGUbJYWMCALyi
        Gmr4pMbupIDwQ+U/htoLKtVfK4YmiyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-55E6qHiqP-mqJ9KUl0NS5Q-1; Tue, 29 Sep 2020 14:45:33 -0400
X-MC-Unique: 55E6qHiqP-mqJ9KUl0NS5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1DCA84639D;
        Tue, 29 Sep 2020 18:45:31 +0000 (UTC)
Received: from bfoster (ovpn-113-202.rdu2.redhat.com [10.10.113.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 500935C1C4;
        Tue, 29 Sep 2020 18:45:31 +0000 (UTC)
Date:   Tue, 29 Sep 2020 14:45:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200929184529.GB103666@bfoster>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200927230823.GA14422@dread.disaster.area>
 <20200928151627.GA4883@bfoster>
 <20200928230910.GH14422@dread.disaster.area>
 <20200929122739.GA99116@bfoster>
 <20200929170113.GI49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929170113.GI49547@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:01:13AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 29, 2020 at 08:27:39AM -0400, Brian Foster wrote:
> > On Tue, Sep 29, 2020 at 09:09:10AM +1000, Dave Chinner wrote:
> > > On Mon, Sep 28, 2020 at 11:16:27AM -0400, Brian Foster wrote:
> > > > On Mon, Sep 28, 2020 at 09:08:23AM +1000, Dave Chinner wrote:
> > > > > On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
> > > > > > +xfs_defer_relog(
> > > > > > +	struct xfs_trans		**tpp,
> > > > > > +	struct list_head		*dfops)
> > > > > > +{
> > > > > > +	struct xfs_defer_pending	*dfp;
> > > > > > +	xfs_lsn_t			threshold_lsn;
> > > > > > +
> > > > > > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Figure out where we need the tail to be in order to maintain the
> > > > > > +	 * minimum required free space in the log.
> > > > > > +	 */
> > > > > > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > > > > > +	if (threshold_lsn == NULLCOMMITLSN)
> > > > > > +		return 0;
> > > > > 
> > > > > This smells of premature optimisation.
> > > > > 
> > > > > When we are in a tail-pushing scenario (i.e. any sort of
> > > > > sustained metadata workload) this will always return true, and so we
> > > > > will relog every intent that isn't in the current checkpoint every
> > > > > time this is called.  Under light load, we don't care if we add a
> > > > > little bit of relogging overhead as the CIL slowly flushes/pushes -
> > > > > it will have neglible impact on performance because there is little
> > > > > load on the journal.
> > > > > 
> > > > 
> > > > That seems like an overly broad and not necessarily correct assumption.
> > > > The threshold above is tail relative and hardcoded (with the zero param)
> > > > to the default AIL pushing threshold, which is 25% of the log. If we
> > > 
> > > The pushing threshold is 75% of the log space has been reserved by
> > > the grant head, not that there's only 25% of the log free. The
> > > reservation is typically much, much larger than the change that is
> > > actually written to the log, and so we can be tail pushing even when
> > > the log is largely empty and the CIL hasn't reached it's threshold
> > > for pushing.
> > > 
> > > Think about it - if we have a log with a 256kB log stripe unit,
> > > a itruncate reservation is somewhere around 1.5MB in size (700kB *
> > > 2), and if we have reflink/rmap enabled, it's closer to 6MB in size.
> > > Yet a typical modification will not use any of the 512kB*8 space
> > > reserved for the LSU (because CIL!) and might only use 10kB of new
> > > log space in the CIL because that's all that was newly dirtied.
> > > 
> > > That means we reserve 6MB of log space for each itruncate
> > > transaction in flight, (directory ops are almost as heavyweight) so
> > > it only takes 16 transactions in flight to consume 100MB of reserve
> > > grant head space. If we've got a log smaller than 130MB in this
> > > situation, we are into tail pushing -even if the physical log is
> > > empty-.
> > > 
> > > IOWs, tail pushing is not triggered by how much physical log space
> > > has been consumed - it is triggered by reservation pressure. And we
> > > can trivially drive the system into reservation pressure with
> > > concurrent workloads
> > > 
> > 
> > Yes, I understand. What I'm saying is that once we get past the
> > reservation head checks, there is a threshold lsn check that requires an
> > intent sit in that 25% range from the on-disk tail of the log for it to
> > be relogged. That _might_ unnecessarily relog in certain cases (i.e.
> > when the active range of the log is small), but it is not always the
> > case and I don't think it results in per CIL context relogging in
> > practice.
> 
> FWIW, I added a defer_relog stats counter and re-ran my nightly fstests
> runs (which at this point consist of):
> 
> A) upstream V5 with all features enabled
> B) same, but with 1k block size
> C) V4 filesystem
> D) V5 with DAX
> 
> With the first of the relogging patches enabled, we relog any time we
> find that an intent item is not in the current checkpoint.
> 
> A) defer_relog 26237
> B) defer_relog 81500
> C) defer_relog 15
> D) defer_relog 2660
> 
> With both enabled, we relog if the intent item is below the push
> threshold and the intent item isn't in the current checkpoint.
> 
> A) defer_relog 11345
> B) defer_relog 1
> C) defer_relog 945
> D) defer_relog 1805
> 

Those B and C numbers are definitely interesting. It's hard to say what
might be going on there since fstests can do so many crazy things
(including explicitly formatting filesystems with a version other than
what is specified in the config, IIRC).

> The runtime was about the same, though oddly the runtime has gone from
> 3.5h (last week) to 6h (this week) though I did just rebase fstests
> and... wow, there are some new tests that take forever to run.
> 
> From the ftrace data, the longest chains I see are from evil reflink
> tests that create a large extent, share it, punch out every other block
> of one of the copies, and then delete the other copy to stress CUI/EFI
> creation.
> 
> Those chains can run into the hundreds (~400 on the (A) config) though
> sadly they don't test the relogging mechanism since the removal is
> single-threaded, and the log doesn't checkpoint or hit the push
> thresholds.
> 

Ok, good to know. Any idea how large of a file generates that length of
chain?

Just some quick thoughts on the rest, since Dave should probably chime
in on some of the other bits..

> > > > assume sustained tail pushing conditions, a committed intent doesn't
> > > > trigger relog again until it falls within that threshold in the on-disk
> > > > log. The current CIL (nonblocking) size threshold is half that at 12.5%.
> > > 
> > > Or smaller. For small logs it is 12.5% of the log size. For larger
> > > logs, it caps at 32MB (8 * (256k << 4)).
> > > 
> > > > So relative to a given rolling transaction processing an intent chain,
> > > > there's a decent number of full CIL checkpoints that can occur before
> > > > any of those intents need to relog again (if at all), regardless of log
> > > > size.
> > > 
> > > Your logic is inverted because reservation pressure does not reflect
> > > CIL pressure.  Log space consumption and reservation pressure were
> > > decoupled by the in-memory relogging that the CIL enables, hence
> > > given a specific intent chain, the likely probability is that it
> > > will not span more than a single CIL context. i.e. it will complete
> > > rolling entirely within a single CIL commit.
> > > 
> > > As the log gets larger and the CIL increases in size, the
> > > probability that an intent chain completes within a single CIL
> > > commit goes up (e.g. 6MB reservation vs 32MB CIL push threshold).
> > > The lighter the load, the more likely it is that a transaction chain
> > > will complete within a single CIL checkpoint, even on small logs.
> > > 
> > 
> > Sure, I agree with that. That's not a major factor for intent chains
> > that pin the log tail long enough to cause deadlocks.
> > 
> > > > Without that logic, we're changing behavior to relog the entire chain in
> > > > every CIL checkpoint. That's a fairly significant change in behavior
> > > > with less predictable breakdown conditions. Do we know how long a single
> > > > chain is going to be?
> > > 
> > > Yes: the typical worst case chain length is defined by the
> > > transaction reservation log count. That is supposed to cover > %99
> > > of typical log space requirements for that operation.
> > > 
> > 
> > I don't think reservation log counts define worst case conditions for
> > intent chains. Darrick has documented cases in the commit logs that far
> > exceed those values. I'm assuming those are legitimate/observed
> > scenarios, but could be mistaken.
> 
> They're rare, but definitely the kinds of things (see above) that
> unprivileged userspace can create.
> 
> > > For any chain that is longer than this, we end up in the slow
> > > regrant path that reserves a unit of log space at a time, and these
> > > are the cases where the transaction must be careful about not
> > > pinning the tail of the log. i.e. long chains are exactly the case
> > > where we want to relog the intents in every new CIL context. This is
> > > no different to the way we relog the inode in -every transaction
> > > roll- whether it is modified or not so that we can guarantee it
> > > doesn't pin the tail of the log when we need to regrant space on
> > > commit....
> > > 
> > 
> > Yes, the relogging approach is the same. The difference is that in one
> > case we're logging a small, fixed size (inode) object repeatedly that is
> > already factored into the transaction reservation and in the other case,
> > we're logging a dynamic and non-deterministic number of (intent) objects
> > a non-deterministic number of times.
> > 
> > > > Do we know how many CPUs are concurrently
> > > > processing "long chain" operations?
> > > 
> > > Yes: as many as the grant head reservations will allow. That's
> > > always been the bound maximum transaction concurrency we can
> > > support.
> > > 
> > > > Do we know whether an external
> > > > workload is causing even more frequent checkpoints than governed by the
> > > > CIL size limit?
> > > 
> > > Irrelevant, because checkpoint frequency affects the relogging
> > > efficiency of -everything- that running transactions. i.e. the
> > > impact is not isolated to relogging a few small intents, it affects
> > > relogging of all metadata, from AG headers to btree blocks,
> > > directories and inodes. IOWs, the overhead of relogging intents
> > > will be lost in the overhead of completely relogging entire dirty
> > > metadata blocks that the transactions also touch, even though they
> > > may have only newly dirtied a few bytes in each buffer.
> 
> /me is confused, does this refer to transactions relogging dirty
> buffers because they dirtied something (aka xfs_trans_log_buf)?  Or does
> the checkpointing itself force relogging into the new checkpoint?
> 
> > > 
> > > > The examples in the commit logs in this series refer to
> > > > chains of hundreds of intents with hundreds of transaction rolls.
> > > 
> > > Truncating a file with 10 million extents will roll the transaction
> > > 10 million times. Having a long intent chain is no different from a
> > > "don't pin the tail of the log" perspective than truncating a
> > > badly fragmented file. Both need to relog their outstanding items
> > > that could pin the tail of the log as frequently as they commit...
> > > 
> > > This is a basic principle of permanent transactions: they must
> > > guarantee forwards progress by ensuring they can't pin the tail of
> > > the log at any time. That is, if you hold an item that *may* pin the
> > > tail of the log when you need to regrant log space, you need to move
> > > those items to the head of the log -before- you attempt to regrant
> > > log space. We do not do that with intents, and conditional relogging
> > > doesn't provide that guarantee, either.  Relogging the item once the
> > > item is no longer at the head of the log provides that forwards
> > > progress guarantee.
> > > 
> > 
> > It sounds like there's a correctness argument buried in here. If you
> > think the tail lsn threshold approach is not fundamentally correct, can
> > you please elaborate on that? I think fundamental correctness is far
> > more important at this early stage than the prospective impact of
> > cacheline contention caused by an implementation detail.
> 
> I've been wondering if this discussion could be summarized like this:
> 
> We don't want logged inode items to pin the tail on long running
> operations, so we tell everyone that if they're going to keep the inode
> locked across transaction rolls, they must relog the inode into the new
> transaction to keep it moving forward.  This is easy to spot and easy to
> think about, since we generally only operate on one inode at a time and
> the core is a fixed size.
> 
> For log intent items, the same general principle applies (anything that
> we want to hold onto across a roll must be relogged to avoid pinning the
> tail), but a transaction can have an arbitrary number of arbitrarily
> sized intent items, and the overhead of relogging (aka logging an intent
> done item and a new intent item) is much higher than relogging an inode.
> 
> Therefore, we add a new rule (A) that intent items must be relogged
> across checkpoints.  There's less overhead than doing it *every
> transaction* but this keeps the intents moving along.  This is still a
> bright line rule, albeit buried in the defer ops code, because we know
> exactly when it will trigger relogging.
> 

That all sounds about right to me.

> However, adding (B) the push threshold thing now makes it /harder/ to
> think about the intent item relogging because now we sort of have to
> merge two not-quite-the-same concepts (the push threshold of the actual
> log space usage vs. space usage according to the reservation grants)
> which just makes relogging less predictable.
> 

I'm not sure relogging is more or less predictable either way due to
external factors that can change behavior. The same intent chain might
relog many times if contending with 100 CPUs committing unrelated
transactions, doing fsyncs, etc. and not at all on an otherwise idle fs.
I'm also not sure how much that really matters since it's just a
characteristic of how the underlying log subsystem (delayed logging)
already works.

> From my POV, we don't currently do any relogging of deferred items, so
> applying either (A) or (B) seems like a benefit because at least we
> close off a theoretical deadlock vector.  (B) on its own makes me
> somewhat nervous because it sounds like the sort of thing that ends in
> "infrequently used code path explodes in subtle ways on $config that
> nobody tests", whereas (A) at least does it regularly enough that
> everyone will know its there.  OTOH, if checkpoints are small, that
> could result in a lot of unnecessary relogging, hence the attraction of
> (B) or (A+B).
> 

I think that last bit applies to both cases, TBH. As Dave mentioned
earlier, the common case is probably going to be that a chain is logged
entirely in a single checkpoint. I think the more important question is
whether we have sufficient tests to stress the underlying scheme.

E.g., if you guys prefer to just relog the entire chain (per
checkpoint), then I think we should at least make sure we have test
coverage for scenarios like long intent chains that result in excessive
relogging. Perhaps we could accomplish that with some creative
combination of error injection tags and variants of the existing tests
(i.e., set a tag to control relog frequency and run one or more of those
evil reflink workloads, or just combine the latter with an fsstress
workload, etc.). That would at least provide some tangible data on
questions like whether we're going to start blowing transaction
reservations or burning up CPUs processing huge intent chains.

> (I don't know anything about cacheline contention: I don't have quite
> enough fast hardware and perf-fu (or free time) to study that in depth.
> Since we're kind of lazy about locking around the grant head, it's
> probably fine to be even lazier and only read that stuff once per
> go-around, and only if we find an item that wasn't logged in the current
> checkpoint.  Anyone got numbers?)
> 
> > > I don't want to slap a band-aid over the problem in the name of
> > > "performance". Correctness comes first, then if we find a
> > > performance problem we'll address that without breaking correctness.
> > > 
> > ...
> > > > > However, when we are under heavy load the code will now be reading
> > > > > the grant head and log position accounting variables during every
> > > > > commit, hence greatly increasing the number and temporal
> > > > > distribution of accesses to the hotest cachelines in the log. We
> > > > > currently never access these cache lines during commit unless the
> > > > > unit reservation has run out and we have to regrant physical log
> > > > > space for the transaction to continue (i.e. we are into slow path
> > > > > commit code). IOWs, this is like causing far more than double the
> > > > > number of accesses to the grant head, the log tail, the
> > > > > last_sync_lsn, etc, all of which is unnecessary exactly when we care
> > > > > about minimising contention on the log space accounting variables...
> > > > > 
> > > > 
> > > > If we're under sustained tail pushing pressure, blocking transactions
> > > > have already hit this cacheline as well, FWIW.
> > > 
> > > No, tail pushing != blocking. If the AIL pushing is keeping up with
> > > the targets that are being set (as frequently happens with large
> > > logs and fast storage), then we rarely run out of log space and we
> > > do not block new reservations waiting for reservation space.
> > > 
> > 
> > Just pointing out that there's another prospective path for a
> > transaction to hit the cacheline. As you've already pointed out, it's
> > quite easy to reach reservation blocking conditions before the AIL is
> > even involved.
> > 
> > > > But if we're concerned about cacheline access in the commit path
> > > > specifically, I'm sure we could come up with any number of optimizations
> > > > to address that directly. E.g., we could sample the threshold
> > > > occasionally instead of on every roll, wait until the current
> > > > transaction has consumed all logres units (where we'll be hitting that
> > > > line anyways), shift state tracking over to xfsaild via setting a flag
> > > > on log items with an ->iop_relog() handler set that happen to pin the
> 
> I'm not sure what I think about the AIL reaching out to touch intent
> items that higher level code could also be accessing at the same time.
> Wouldn't that require more coordination?
> 

This already happens today. More traditional items (inodes, bufs, etc.)
mediate access through item specific locks, but the AIL does list
processing, flag updates, etc. outside of that. I don't think anything
prevents the AIL from setting an XFS_LI_AIL_PUSHED flag or some such
that the intent owner could use to identify an intent to relog. That
said, that was just a quick/handwavy thought wrt to avoiding l_tail_lsn
access and may or may not be a viable option.

Brian

> > > > tail, etc. etc. That said, I do think any such added complexity should
> > > > be justified with some accompanying profiling data (and I like the idea
> > > > of new stats counters mentioned in the separate mail).
> > > 
> > > Yes, there's lots of ways the pushing threshold could be done
> > > differently, but to focus on that misses the point that intents
> > > violate forwards progress guarantees rolling transactions are
> > > supposed to provide the log. I simply made the "access overhead"
> > > argument as a supporting point that this change is also likely to
> > > have unintended side effects...
> > > 
> > 
> > The argument stated was that the relog filtering was redundant logic. I
> > think that misinterprets the logic. If there's a correctness issue, then
> > I'd much prefer to focus on that..
> 
> I hope I didn't just stumble in and muddy things further. :)
> 
> --D
> 
> > Brian
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > 
> 

