Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E84EDCC5
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776609; cv=none; b=R6FRq4C6PkKYVIKRx9mE6uzg8ylfSC1a7PGCVJClU89tnel1PmRSPwhcuJXi50EoNMNAEr3ZFHGw+Bj6Z7gTgLUil5e2Az3P5o9Wept9uoYFFW3IpWIDvOjxAnKcYpnq95CPWqmwTXmvjq30JpHDNWi3GSBx50sImjfLDKae5rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776609; c=relaxed/simple;
	bh=vYwMZtNUBzSJ/ZFEnC1dd7bI6KLm6WmptT9egU06178=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAbBbjbO9Rp2y6P92TYKVRNCBga2Fk8x+YrCPaHkMvTd5EXoLZRB3M2oxBWEC2ubCHEnwGLKyXfXJl6IOM9JnccJFBbPfCSGbH66g2xD1lmitAZIDxdb9zg85Ly/FCNH7oqGus9UXpS7M1dDzZOiXSZyXbCOW9J5bvUaA3QBx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aiD+fe/H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aiD+fe/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790776590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fCUHmToIui4SJ5pdG15zGMr9P3/or4HgMxSfQcuNHg=;
	b=aiD+fe/H3noxSlFCf1l5dKht/Nwwm4RIHY87fUIigySSs/an5qyQagXiLjr4Tq6qKUDvEO
	6eJgjs1/3L8TSho9COOu23rxOwUo62o8KR1KgG1hZalnRnbs9hCRwrY79yMHxohKLuG44T
	9bs+GZV3E8Y30nc0Ui9HRr+//1/Ul44=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-3JC54DFrO3qoF2x3AxtJAg-1; Wed,
 30 Sep 2026 09:56:26 -0400
X-MC-Unique: 3JC54DFrO3qoF2x3AxtJAg-1
X-Mimecast-MFC-AGG-ID: 3JC54DFrO3qoF2x3AxtJAg_1790776585
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C1B01840C57;
	Wed, 30 Sep 2026 13:56:25 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A416F180057E;
	Wed, 30 Sep 2026 13:56:23 +0000 (UTC)
Date: Wed, 30 Sep 2026 09:56:21 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: MingTao Huang <1037827920@qq.com>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	MingTao Huang <mintaohuang@tencent.com>
Subject: Re: [PATCH] xfs: fix skipped flushing items not counted in
 xfsaild_push()
Message-ID: <ar0VBbwULCzAQW2u@bfoster>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
 <arL9Xrmf5Q7wd3T4@dread>
 <arPXwKnDMVMj-oMK@bfoster>
 <arRv-SRK0nHHGBxM@dread>
 <arq3MsiNwf1R1QCL@bfoster>
 <arse0L6mA00ybLvf@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arse0L6mA00ybLvf@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Sep 29, 2026 at 12:13:36PM +1000, Dave Chinner wrote:
> On Mon, Sep 28, 2026 at 02:51:30PM -0400, Brian Foster wrote:
> > On Thu, Sep 24, 2026 at 10:34:01AM +1000, Dave Chinner wrote:
> > > On Wed, Sep 23, 2026 at 09:44:32AM -0400, Brian Foster wrote:
> > > > On Wed, Sep 23, 2026 at 08:12:46AM +1000, Dave Chinner wrote:
> > > > > On Tue, Sep 22, 2026 at 04:14:29PM +0800, MingTao Huang wrote:
> > > > > > From: MingTao Huang <mintaohuang@tencent.com>
> > > > > > 
> > > > > > Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
> > > > > > introduced a fast path in xfsaild_push() that uses
> > > > > > test_bit(XFS_LI_FLUSHING) to skip log items already being
> > > > > > flushed.  However, the fast path jumps directly to the
> > > > > > next_item label, bypassing flushing++, count++, and the
> > > > > > ail_last_pushed_lsn update.  This causes three problems:
> > > 
> > > [....]
> > > 
> > > > > >    letting the loop scan an order of magnitude more items per round.
> > > > > >    Each cluster flush adds a buffer to ail_buf_list, and the resulting
> > > > > >    oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
> > > > > >    list_sort() plus per-buffer trylock and IO submission -- to take so
> > > > > >    long that the watchdog fires.
> > > > > 
> > > > > How? count bounds the delwri list to 1000 buffers at most. That's
> > > > > very intentional, and the number is based on benchmarking results.
> > > > > 
> > > > 
> > > > I'm confused by some of the reasoning here. Maybe I'm missing something,
> > > > but that count check looks like it only limits the current pass.  The
> > > > flushing value is basically just input into the thread throttling (i.e.
> > > > schedule timeout) behavior.
> > > 
> > > It's much more complex than that.
> > > 
> > > The count bounds the number of buffers we can add to the list each
> > > pass.  We also submit the entire list for IO once per pass, hence we
> > > fill and drain the list once per pass. Hence in normal
> > > circumstances, the AIL buffer list should never grow very much
> > > beyond 1000 buffers.
> > > 
> > > Further, using xfs_buf_delwri_submit_nowait() doesn't mean that it
> > > won't block, it just won't wait for IO completion.  We can still
> > > block on IO submission when the request queue fills up.  i.e. the
> > > AIL push algorithm is designed to throttle writeback processing at
> > > IO submission time, not via the higher level backoff loops.
> > > 
> > 
> > Ok, but it also may not submit I/O at all.
> 
> In which case, it is either stuck (and so will backoff) or needs to
> continue iterating until it reaches the target or finds something to
> submit. In the latter case, we want that search to happen as quickly
> as possible to keep disk utilisation up and free up space in the log
> for modifications that are blocked waiting for log space.
> 
> Pushing items that are already in FLUSHING state and then sleeping
> for long periods on 'excessive flushing' heuristics does not acheive
> this.
> 
> > Also I'm not claiming the AIL push is not designed to throttle on I/O
> > submission, but I do think it's also historically implemented to
> > throttle its own execution based on push progress and/or list state, for
> > whatever variety of external reasons it might need to.
> 
> The original design was simply to provide efficient processing and
> IO submission of log items without external interruption. i.e there
> are no external reasons for things like backoffs existing; they
> exist only for efficient management of the AIL contents and IO
> submission in isolation from the rest of the filesystem.
> 
> > > Hence my request for details about the workload, fs geometry, etc,
> > > so I have some idea of how we are getting into this state in the
> > > first place.
> > > 
> > 
> > Yeah I mean I'm also interested in more detail here. I'm just not
> > convinced the proposed solution is fundamentally wrong.
> 
> The patch is definitely wrong. Whether changing the accounting is
> needed is unknown, because we don't have any confirmation of what
> the actual problem encountered is yet.
> 
> > > Hence, from the POV of the AIL control loop, this latter
> > > ITEM_FLUSHING metric is pure noise. We did not queue new IO, we did
> > > not update a buffer already queued for IO, and we do not know if the
> > > item has been recently modified, yet we still accounted it as
> > > "flushing".
> > > 
> > 
> > This all makes sense, but I wonder if it would be simpler to just let
> > the case of "new inode flushed to pre-queued cluster buffer" return
> > ITEM_SUCCESS instead of ITEM_FLUSHING.
> 
> That means we lose the 'this inode cluster is being actively
> modified' signal from the feedback loop. That makes it behave
> differently to buffer items, and so now we have confused and
> unbalanced signals being fed to the backoff control decision again.
> 

What do we do (or not do) with this signal?

ITEM_* implies state of the log item, so I don't see that as
inconsistent. They behave differently because they are different items.
What's the expectation for the push interface? If we flush an ili/dquot
and the buffer is already queued, did we push the item "successfully" or
was the item "flushing?"

> > > > More of a side note to the discussion and related to the actual patch...
> > > > if we did go with something like this ISTM to make more sense to let
> > > > xfsaild_push_item() detect and return the flushing state (i.e. similar
> > > > to how we handle failed state) so the accounting all exists in one
> > > > place, rather than duplicating it for the optimization. Just my .02.
> > > 
> > > I'm not sure it does - see my comment above about ITEM_FLUSHING
> > > being returned by inode items meaning two very different things, and
> > > LI_FLUSHING being used to remove the noisy/useless one from the
> > > control loop.
> > > 
> > 
> > ISTM this also significantly changed the execution logic in the process.
> > For example and if I follow this right, suppose the AIL makes a single
> > pass across multiple loop executions (i.e. multiple xfsaild_push()
> > calls) and submits multiple batches of I/O in the process. Assume that
> > the AIL is inode log item heavy with a good amount of cluster buffer
> > overlap.
> 
> Yup, and so will likley have thousands to tens of thousands of inode
> items per checkpoint LSN in the AIL.
> 
> > 
> > In this situation prior to the LI_FLUSHING change, we'd account for all
> > of the inodes that were batch flushed via xfs_iflush_cluster() by
> > tracking them in flushing/count, and we set the last pushed lsn marker
> > for successful/flushing items as we go, so each call to xfsaild_push()
> > progresses through the list.
> 
> We did, but it didn't make progress like you describe because the LSN
> would not change very often between iterations because of the sheer
> number of items per LSN in the AIL.
> 
> That is, we can have tens of thousands of inodes on the same LSN in
> the AIL. A CIL checkpoint on a large log is closed off at ~32MB in
> size, and an inode core takes up about 300 bytes in the journal. If
> we are logging nothing but inode cores (e.g. 'chown -R <somedir>'
> over millions of files) then a single checkpoint can contain up to
> ~100,000 inode log items. These are all inserted into the AIL at the
> same LSN.  Hence it is very common for there to be tens of thousands
> of inode in the FLUSHING state on the same LSN in the AIL.
> 

So in the current code what prevents from adding that many cluster
buffers to the delwri queue? The current count > 1000 logic only breaks
across an LSN change, so ISTM queue length is subject to the level of
cluster overlap in the dataset.

IOW, create millions of inodes in an fs, nefariously run through and
remove all but one inode per cluster, then run your chown workload
across the remaining set. What happens?

> This means that the updating the LSN when we hit lots of flushing
> inodes doesn't actually move the LSN for the next loop forwards.
> We start the next loop at the same LSN in this case, and the only
> reason we didn't tend to process the same flushing items a second
> time is the backoff allows IO completion to remove the items from
> the AIL.
> 

I get that the LSN bookmark is not granular, but the old algorithm only
broke the loop if we were stuck or hit the target. It resets the
bookmark if the 90% stuck+flushing threshold is met or we hit the
target. So the example described above sounds like one where we'd reset
the LSN pushed bookmark anyways, or otherwise we are stuck and intend to
repush locked/pinned items.

That said, I can see how accounting the flushing state for cluster
flushed inodes in the same push cycle inflates this metric into backing
off/restarting, which seems like a flaw/inefficiency in the old code.

> IOWs, any algorithm that requires the LSN to change per iteration to
> avoid reprocessing overhead is going to be highly inefficient.  The
> backoffs are what allowed the contents at each LSN to change per
> iteration in the old code by allowing IO to complete, but the new
> code uses LI_FLUSHING instead of backoffs to acheive the same
> purpose. The new code has much lower per-iteration latencies and
> higher IO submission rates in these situations, which leads to
> substantially better modification rates across the entire
> filesystem....
> 

Prior to this change we only broke out of the loop if we hit the target
or stuck (pinned/locked) was elevated. The stuck check appears to be the
same in the current code, but the resulting behavior is different.

If we became stuck in the original code before hitting the target, we
break out and if 90% of the visited items were stuck or flushing, we
back off and restart from the beginning. I.e., this resets the lsn
bookmark, so afaict basically blocks further pushing deeper into the
list until the stuck state clears or the 90% heuristic changes enough to
avoid resetting the lsn bookmark on the way out (the tout = 10 case).

Now we iterate but don't account those previously flushed items. The
stuck check is the same, so presumably we walk the same number of items
before we break out in the stuck case. But now we only back off if 90%
of the items we saw are either stuck or were flushed to cluster buffers
that were previously queued. If stuck is capped at 100, that means we
only need to see ~10-12 net positive of ITEM_SUCCESS items to avoid the
backoff, submit and spin back around to the last pushed lsn.

The bookmark is set in this case. We've spun through enough items to the
point of being stuck, sorted the delwri list and resubmitted some
unknown number of buffers, cycled back into xfsaild_push() with an lsn
bookmark, walk through the list to find the starting lip, walk back
through however many flushing items might exist at this LSN, and attempt
to find however much more work we can push before hitting stuck.

So.. I take it the expectation is that buffer submission is what is
supposed to throttle this whole thing, but given that submission is not
necessarily guaranteed or we might not see much additional I/O per full
push cycle, I'm still a little skeptical that we can't fall into a bit
of a death loop here (if submission throttling doesn't happen, for
whatever reason).

Note that I'm not disputing any claims about high level efficiency and
broader fs performance improvements allowed by this algorithm. I'm
looking at the current code and trying to reason about worst case
processing behaviors.

> > After this change, that first pass no longer tracks those items in
> > flushing or count. AFAICT this has a potential side effect of processing
> > and submitting more items per delwri submission in this particular
> > example, but otherwise doesn't seem all that problematic based on what
> > you describe above.
> 
> Not a side effect. That was the -intention- of the patch; to be able
> to submit more IO, faster, and using less CPU per item that needs
> to be processes.
> 
> > Once the push loops back (i.e. to the point where it resets last pushed
> > lsn), however, we're subject to whatever is on the list by virtue of
> > either not yet completing I/O or not submitting or whatever.
> 
> The old code was subject to that, too.
> 
> > At that
> > point it looks like we now may potentially walk through an increased
> > number of items in the while loop without any execution backoff because
> > we've made batches of the list fully invisible to the scheduling logic.
> 
> Which is just fine.
> 
> The historical method of handling these sort of "kernel thread has
> lots of work to do" cases was to sprinkle cond_resched() through the
> code. We've been told not to do that for several years now, and we
> also have proper kernel thread preemption now. That means
> long-running kernel processing tasks do not need to care about how
> long they hold the CPU for as the scheduler can preempt and
> reschedule them elsewhere if needed.
> 
> IOWs, we just don't care if there is so much work to do that the AIL
> just keeps running flat out without backing off. If there's more
> work to do, just keep running. It'll either run out of work or block
> somewhere eventually, until then it should just keep churning
> through the work as fast and efficiency as it can.
> 

Yeah.. I haven't wrapped my head around those cond_resched() changes
quite yet and had it in the back of my mind to wonder whether some
behavior change there might be related.

> > I think you could argue this is actually a loss of "signal" from a task
> > scheduling perspective. If this repeats over multiple cycles, it doesn't
> > seem all that far fetched for this to spin excessively either due to an
> > excessively large AIL list, delwri list, or both.
> 
> No, there was no 'task scheduling' signal to begin with. The
> original backoffs were purely a mechanism to allow IO to complete
> and remove flushing items from the AIL because there was no other
> way to efficiently skip them.
> 
> The LI_FLUSHING mechanism allowed those items to be efficiently
> skipped and ignored by the control loop, so the backoff to manage
> the same 'don't reprocess flushing items on the current push lsn'
> problem became unnecessary. i.e. there was no 'task management'
> consideration in the backoffs at all.
> 
> > I could see how the previous behavior is not necessarily the ideal
> > design for dealing with this, but just calling this previous state "not
> > viable" when it basically restores longstanding historical behavior and
> > preserves the optimization of the original change doesn't sound
> 
> The proposed fix doesn't restore the old behaviour. It just added
> the accounting back in. However, the old behaviour relied on unbound
> processing loops and backoffs to function correctly, neither of
> which are restored in the proposed patch.
> 

I'm mainly concerned about the accounting, not saying the patch is
perfectly correct as it is. If the accounting is an issue and there are
processing logic dependencies that conflict or are intertwined then
clearly that would need to be addressed as well.

> It might behave correctly when it triggers the flushed backoff, but
> for sparse flushing items, they will likely get processed and
> accounted over and over again until the flushing backoff threshold
> is triggered and the aild goes to sleep to allow IO to complete and
> remove flushing items from the AIL.
> 
> > technically accurate to me. I'm happy to hear more details, but based on
> > what we know so far I still suspect the most appropriate thing to do
> > would be some combination of restoring the original tracking like this
> > patch does, and then revisit these design tweaks in a followup
> > patch/series..
> 
> No. We need root cause analysis first. There is no general or
> widepsread problem with the code as it stands - one bug report
> without RCA does not equal "code is broken, must be reverted".
> 

Not what I'm saying. Let's just focus on the current code. If I refer
back to the old behavior, it's to try and reason about what might have
changed to cause this problem.

> Besides, if the problem really is "we are walking too many
> LI_FLUSHING items repeatedly because the LSN is not changing", then
> I'm pretty sure there's a relatively straight forward fix for that.
> i.e. we need fine grained tracking of the item we are up to across
> loop iterations where the AIL lock is not held and the AIL can
> change. We already do this within the processing loop itself...
> 

I'm curious what you're referring to here, if not the last lsn thing..
a cursor enhancement perhaps?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

