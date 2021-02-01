Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E65FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 16:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CE064E9E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 16:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhBAQJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 11:09:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229636AbhBAQJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 11:09:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612195663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wz2Iay3RwpCL+csS0EtqHj+q6+3BpNICiuPQRozlVM=;
        b=C9SsTwmFJ/jKUG6Mt2hCch4oOPUacaemMu3ogA0XNiO01H8OjSFHZLGuQP7DcwtWjz5jZg
        yWozK8p+d6ITCNakeLi9EVYeAuS5AqN6ydXpTBrBcG5U0gztqEBr/kEvOGOpdv7q6vvElV
        KaD4GR7x7VwFlSVeNoXTvnrwElPfHb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-F7ojeC5eP6mz4Kbf6WP6BA-1; Mon, 01 Feb 2021 11:07:41 -0500
X-MC-Unique: F7ojeC5eP6mz4Kbf6WP6BA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6235D1015C86;
        Mon,  1 Feb 2021 16:07:40 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D91421346F;
        Mon,  1 Feb 2021 16:07:39 +0000 (UTC)
Date:   Mon, 1 Feb 2021 11:07:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate CIL commit record IO
Message-ID: <20210201160737.GA3252048@bfoster>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-3-david@fromorbit.com>
 <20210128150741.GB2599027@bfoster>
 <20210128212221.GO4662@dread.disaster.area>
 <20210129145851.GB2660974@bfoster>
 <20210129222559.GT4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129222559.GT4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 30, 2021 at 09:25:59AM +1100, Dave Chinner wrote:
> On Fri, Jan 29, 2021 at 09:58:51AM -0500, Brian Foster wrote:
> > On Fri, Jan 29, 2021 at 08:22:21AM +1100, Dave Chinner wrote:
> > > On Thu, Jan 28, 2021 at 10:07:41AM -0500, Brian Foster wrote:
> > > > FYI, I finally got to reading your prior log cache flushing thread
> > > > yesterday afternoon. I was planning to revisit that and probably reply
> > > > this morning after having some time to digest, but saw this and so will
> > > > reply here..
> > > > 
> > > > On Thu, Jan 28, 2021 at 03:41:51PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > To allow for iclog IO device cache flush behaviour to be optimised,
> > > > > we first need to separate out the commit record iclog IO from the
> > > > > rest of the checkpoint so we can wait for the checkpoint IO to
> > > > > complete before we issue the commit record.
> > > > > 
> > > > > This separate is only necessary if the commit record is being
> > > > > written into a different iclog to the start of the checkpoint. If
> > > > > the entire checkpoint and commit is in the one iclog, then they are
> > > > > both covered by the one set of cache flush primitives on the iclog
> > > > > and hence there is no need to separate them.
> > > > > 
> > > > 
> > > > I find the description here a bit vague.. we have to separate out the
> > > > commit record I/O, but only if it's already separate..?
> > > 
> > > Yes, because if the commit record is in a different iclog to the
> > > start of the checkpoint, we have to ensure that the start of the
> > > checkpoint has been written and completed before we issue a
> > > PREFLUSH, otherwise the cache flush is not guaranteed to capture
> > > that IO. i.e. the block layer cache flushing mechanisms do not order
> > > against IOs in flight, only completed IOs. Hence if the commit
> > > record is in a different iclog, we have to wait for the other iclogs
> > > to complete before flushign the cache. If the checkpoint is wholly
> > > contained within a single iclog, then we don't have to wait for
> > > anything, the single journal IO has all the cache flushes we need.
> > > 
> > 
> > Yeah, I get the functional behavior. I think the commit log would do
> > better to refer to serializing or ordering the commit record (when split
> > or separate) as opposed to separating it.
> 
> Except we already have "ordering the commit record" functionality
> implemented in the CIL push code, where it explicitly orders the
> commit record for the push against the commit records of other
> pushes in progress.
> 
> SO I don't think naming it "ordering the commit record" improves the
> situation because it introduces ambiguity into what that means. It's
> also not serialisation...
> 

I'm not sure we can get much more vague than "separate commit record
IO." :P We can fairly easily distinguish between ordering of independent
commit records and ordering a particular commit record against log I/O
of its associated checkpoint. For example:

  xfs: block commit record iclog submission on previous iclog completion

... but feel free to come up with something better, use the term
ordering instead of blocking, etc.

> > > > > +int
> > > > > +xlog_wait_on_iclog_lsn(
> > > > > +	struct xlog_in_core	*iclog,
> > > > > +	xfs_lsn_t		start_lsn)
> > > > > +{
> > > > > +	struct xlog		*log = iclog->ic_log;
> > > > > +	struct xlog_in_core	*prev;
> > > > > +	int			error = -EIO;
> > > > > +
> > > > > +	spin_lock(&log->l_icloglock);
> > > > > +	if (XLOG_FORCED_SHUTDOWN(log))
> > > > > +		goto out_unlock;
> > > > > +
> > > > > +	error = 0;
> > > > > +	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
> > > > > +
> > > > > +		/* Done if the lsn is before our start lsn */
> > > > > +		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
> > > > > +				start_lsn) < 0)
> > > > > +			break;
> > > > 
> > > > Hmm.. that logic looks a bit dodgy when you consider that the iclog
> > > > header lsn is reset to zero on activation. I think it actually works as
> > > > intended because iclog completion reactivates iclogs in LSN order and
> > > > this loop walks in reverse order, but that is a very subtle connection
> > > > that might be useful to document.
> > > 
> > > It is documented in the comment above the function "We walk
> > > backwards through the iclogs to find the iclog....". A newly
> > > activated iclog will have an LSN of zero, and that means there are
> > > no prior iclogs in the list in the range we need to flush because of
> > > the completion ordering guarantees we have for iclog IO (i.e. they
> > > are always completed in ring order, not IO completion order).
> > > 
> > 
> > Can you update the comment with that sentence to be more explicit about
> > the zero LSN case?
> 
> 
> > 
> > > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > > index b0ef071b3cb5..c5cc1b7ad25e 100644
> > > > > --- a/fs/xfs/xfs_log_cil.c
> > > > > +++ b/fs/xfs/xfs_log_cil.c
> > > > > @@ -870,6 +870,13 @@ xlog_cil_push_work(
> > > > >  	wake_up_all(&cil->xc_commit_wait);
> > > > >  	spin_unlock(&cil->xc_push_lock);
> > > > >  
> > > > > +	/*
> > > > > +	 * If the checkpoint spans multiple iclogs, wait for all previous
> > > > > +	 * iclogs to complete before we submit the commit_iclog.
> > > > > +	 */
> > > > > +	if (ctx->start_lsn != commit_lsn)
> > > > > +		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> > > > > +
> > > > 
> > > > This is an interesting serialization point because we don't necessarily
> > > > submit the iclog that holds the commit record. I actually think in most
> > > > cases the separate commit record won't land on disk until the next CIL
> > > > push causes a sync of the current head iclog (assuming it fills it up).
> > > 
> > > Which is exactly what happens now. It's not a big deal, because if
> > > we are running a sync transaction, the log force will push it to
> > > disk and wait for it. CIL pushes are not synchronous and never have
> > > been - the log force is what creates the appearance of synchronous
> > > behaviour to the caller...
> > > 
> > 
> > Right, but otherwise the CIL push blocks on previous checkpoints (and
> > now the majority of the current checkpoint) only to write the commit
> > record into an iclog and probably not submit it until the next CIL
> > checkpoint.
> 
> That's exactly the same behaviour we have now. Nothing guarantees
> that the iclog containing a commit record is written immediately.
> So this simply isn't a concern because we are not changing
> behaviour.
> 
> > I agree it's probably not a big deal. The same behavior
> > likely repeats for subsequent CIL pushes, so it may not even be
> > noticeable. This is just an observation that we're compounding more
> > serialization
> 
> This does not add serialisation!
> 
> Serialisation means you do something that will stall *other tasks*
> because they have to wait for the current task to finish before they
> can proceed. Adding an _ordering delay_ into an unserialised task
> does not create new serialisation points, it just lengthens the
> runtime of that task.
> 

Perhaps serialization is not the right term... I/O synchronization
perhaps? I don't know, but calling it an ordering delay is certainly not
comprehensive because it has functional ramifications..

> > on another bit of a historical impedance mismatch between
> > delayed logging and the underlying layer. We've potentially just wrote
> > out a large context, yet none of the attached items can be processed
> > until another checkpoint occurs because the callbacks that do AIL
> > insertion and whatnot don't run until the iclog with the commit record
> > hits the disk.
> 
> Yup, classic two phase commit algorithm behaviour right there. We
> already have this occurring and it most definitely is not a problem
> that we need to solve. Indeed, this behaviour is the prime reason
> for log covering to exist...
> 
> > This isn't necessarily a commentary on this patch, but it would be nice
> > if we could start thinking about handling that situation better;
> > particularly if we've just blocked waiting for the majority of that
> > checkpoint I/O to complete.
> 
> The thing is, we are already blocking  waiting for iclog IO to
> complete. We're doing it at a rate of at lease 1 in every 4 iclogs
> we need to fill in long running checkpoints. So the CIL push that
> needs to write a thousand iclogs before the commit record is written
> has already blocked on iclog IO completion at least 250 times.
> 
> In comaprison, with the cache flush changes and this commit record
> separation, I'm seeing the iclog block rate drop to 1 in 100 iclogs
> written. The fact is that cache flushing is -far more expensive- and
> results is far more blocking and IO completion waiting in the CIL
> push than this code that orders the commit record by waiting for
> iclog completion to occur.
> 

What exactly is "iclog block rate?" Does the calculation of the new rate
factor in the implicit iclog blocking we now have by default?

> CIL checkpoint submission is far more IO efficient and *much lower
> latency* with this single software level ordering delay than using
> hardware cache flushes to guarantee ordering. To focus on "this
> new ordering delay might add latency" completely misses the bigger
> picture that we just replaced 2-3 orders of magnitude of IO blocking
> delays with a single ordering delay.
> 
> That's what's important here - it's not that we've added a single
> ordering delay into the checkpoint, but that we've removed
> *hundreds* of IO blocking delays in the checkpoint writing process.
> 

Ok. I think Christoph raised a good point around storage without
volatile caches, but otherwise I find the performance tradeoff analysis
reasonable for the applicable case. Thanks.

> > That means there's an increased chance that
> > the next iclog in the ring may be active. Perhaps we could introduce
> > some logic to switch out the commit record iclog before the CIL push
> > returns in those particular cases.  For example, switch out if the
> > current checkpoint hit multiple iclogs..? Or hit multiple iclogs and the
> > next iclog in the ring is clean..?
> 
> We could just call xlog_state_switch_iclogs() to mark it WANT_SYNC,
> but then we can't aggregate more changes into it and fill it up. If
> someone starts waiting on that iclog (i.e. a log force), then it
> immediately gets marked WANT_SYNC and submitted to disk when it is
> released. But if there is no-one waiting on it, then we largely
> don't care if an asynchronous checkpoint is committed immediately,
> at the start of the next checkpoint, or at worst, within 30s when
> the log worker next kicks a log force....
> 
> It's just not necessary to ensure the commit record hits the disk
> with minimal latency...
> 
> > > > From a performance perspective, it seems like this makes the CIL push
> > > > _nearly_ synchronous by default.
> > > 
> > > Nope, not at all. There is nothing waiting on the CIL push to
> > > complete, except maybe a log force waiting for the iclogs to be
> > > synced to disk and completed.
> > > 
> > 
> > Right, that's sort of the point... we have various places that issue
> > async log forces. These async log forces push the CIL, which
> > historically only ever blocks on log I/O by virtue of waiting on iclog
> > space. IOW, there is a bit of runway between an async CIL push blocking
> > on I/O or not provided by the iclog mechanism.
> > 
> > With this patch, a CIL push (and thus an async log force) now does not
> > return until all but the commit record iclog have been submitted for I/O
> > and completed.
> 
> Same as right now. I have not changed anything.
> 
> > The log force will then submit the commit record log, but
> > then not wait on it. This is obviously not a functional problem since a
> > CIL push was never guaranteed to not block at all (iclogs are a limited
> > resource), but there's clearly a change in behavior here worth reasoning
> > about for async forces..
> 
> No, there is no change in behaviour at all. The log force in both
> cases submits the commit record.
> 

But it also blocks where it didn't before. I'm not sure why I can't seem
to get this point across. Having thought more about this, here is a more
concrete example of the behavior change wrt to async log forces:

- Various operations populate the CIL, eventually triggers background
  CIL push.
- Background CIL push writes out the majority of checkpoint A, writes
  the commit record of checkpoint A into the current head iclog and
  returns without submitting it for I/O.
- More transactions commit and some task issues an async log force (i.e.
  xfs_log_force(.., 0);):
	- xlog_cil_push_work() submits the iclog with the commit record
	  for checkpoint A as it writes out checkpoint B.
	- xlog_wait_on_iclog_lsn() waits on ->ic_force_wait of the
	  commit record iclog for checkpoint A.
  ...

At this point, we've blocked async log force on completion processing of
a previous checkpoint because ->ic_force_wait isn't woken until the
iclog is cleaned, which doesn't occur until completion callbacks
attached to the iclog complete. This means we've technically just
changed the locking semantics for async log forces as callers must be
cognizant of locks used in the log I/O completion path.

Is this a problem? I don't know. Perhaps not, but we've had similar
issues in the past[1] in cases where an async log force unexpectedly
blocked on callback processing. The example cited was a different
waitqueue associated with the CIL context as well as being a shutdown
case that I think is no longer relevant due to more recent inode flush
reworks, etc., but it's just an example that raises concern.

So unless I'm missing something in the sequence above, I think this
requires more audit and analysis than we currently have for this
particular patch. I.e., we still have oddball cases like how
xfs_buf_lock() of a stale buffer invokes an async log force (while
potentially holding other locked items/buffers in a transaction) while
similarly an unpin of a staled buffer can cycle the buffer lock on the
log I/O completion side. Is that safe or a rathole of landmines (now and
for future code)? Perhaps a more robust option is to create a new
waitqueue specifically for the purpose of blocking iclog I/O so
historical async force rules/behavior is preserved. (We do have
->ic_write_wait, though that doesn't appear to provide ordering..).

Brian

[1] 545aa41f5cba ("xfs: wake commit waiters on CIL abort before log item abort")

> > > > I.e., if we have a several hundred MB
> > > > CIL context,
> > > 
> > > Not possible. A 2GB log has a hard throttle limit now of 64MB.
> > > 
> > 
> > Well, I don't think the throttle guarantees an upper bound on the
> > context size, but that's a different topic.
> 
> Sure, it's a bit lazy. But once you capture the user tasks that run
> commits on the throttle, the size stops growing.
> 
> > That was just an example of
> > a largish sized checkpoint. 64MB is still plenty enough to require
> > multiple passes through the set of iclogs. Regardless, I think the
> > before and after change is not significant given that a 64MB checkpoint
> > already requires internal blocking to reuse iclog space as the
> > checkpoint flushes anyways. So it's really just (l_iclog_bufs - 1) of
> > additional I/O we're waiting for in the worst case.
> 
> I put the metrics that prove this assertion wrong are in the commit
> message of the next patch. i.e. I measured how many "noiclog" events
> are occuring during CIL checkpoints. I mentioned that above already
> - reducing the IO blocking rate from hundreds of events per
> checkpoint down to a small handful is a major win....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

