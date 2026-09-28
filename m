Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A33BED7B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621520; cv=none; b=LK7me2ssJ8spZOVaW6wirdPAAt/N0wfjY1ODFnX1OsQXDZ24F6IU8bv9thGSs3KSqCsmECZdW14WGCabf7XKlAszyxlxY3j8P8SXiN8P+5eo4BuzOWY65jJvstuTCOCiGT14/RozOFqdnrNFna3MZk0RMO1Jj7Rw7JfqvQPXEMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621520; c=relaxed/simple;
	bh=izysCqjo84rAmPEvES9ib0nsruMlz5EGfsHKwE2Uh7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miBwkuUZ9/AhaP/t/ILkz3GXFIVCHDUvvcJDOeCIEYdM0M66TIl2Ts1DLdO10DLDm1pvzuso0xl9DCUB/ISL6gF67H7xmH4R32GlvBbwe6moLsgIBxucRST34aqmW9lbtA7+TYzek2keSIZFcws7k/g5j8lYxMj1Qg98EKbSTGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcy7VR3Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcy7VR3Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790621499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZwFTUuKCYYlgId3Kr1I8ulXZItlFWyZ/X4RGi1wsuU=;
	b=fcy7VR3QyAmnrZ485b/ggz7juQzEHzf36db06vNLHF1LwcfYu2ayqs2WW37Qv8trPEHmyA
	zoqOqrDkUJOio3j1bpt5zdjWCz8MjC6p1S8ao0XyVTekSEBrh0p1Azp3IFGDJgNt9kobQL
	Yr4Z9X+IlP59XRDDtqd9LDRgaqpor4c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-leSOVlVLPMOdwYvWpTm74w-1; Mon,
 28 Sep 2026 14:51:36 -0400
X-MC-Unique: leSOVlVLPMOdwYvWpTm74w-1
X-Mimecast-MFC-AGG-ID: leSOVlVLPMOdwYvWpTm74w_1790621494
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54A971978F7C;
	Mon, 28 Sep 2026 18:51:34 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88A6530000E8;
	Mon, 28 Sep 2026 18:51:32 +0000 (UTC)
Date: Mon, 28 Sep 2026 14:51:30 -0400
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
Message-ID: <arq3MsiNwf1R1QCL@bfoster>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
 <arL9Xrmf5Q7wd3T4@dread>
 <arPXwKnDMVMj-oMK@bfoster>
 <arRv-SRK0nHHGBxM@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arRv-SRK0nHHGBxM@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Sep 24, 2026 at 10:34:01AM +1000, Dave Chinner wrote:
> On Wed, Sep 23, 2026 at 09:44:32AM -0400, Brian Foster wrote:
> > On Wed, Sep 23, 2026 at 08:12:46AM +1000, Dave Chinner wrote:
> > > On Tue, Sep 22, 2026 at 04:14:29PM +0800, MingTao Huang wrote:
> > > > From: MingTao Huang <mintaohuang@tencent.com>
> > > > 
> > > > Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
> > > > introduced a fast path in xfsaild_push() that uses
> > > > test_bit(XFS_LI_FLUSHING) to skip log items already being
> > > > flushed.  However, the fast path jumps directly to the
> > > > next_item label, bypassing flushing++, count++, and the
> > > > ail_last_pushed_lsn update.  This causes three problems:
> 
> [....]
> 
> > > >    letting the loop scan an order of magnitude more items per round.
> > > >    Each cluster flush adds a buffer to ail_buf_list, and the resulting
> > > >    oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
> > > >    list_sort() plus per-buffer trylock and IO submission -- to take so
> > > >    long that the watchdog fires.
> > > 
> > > How? count bounds the delwri list to 1000 buffers at most. That's
> > > very intentional, and the number is based on benchmarking results.
> > > 
> > 
> > I'm confused by some of the reasoning here. Maybe I'm missing something,
> > but that count check looks like it only limits the current pass.  The
> > flushing value is basically just input into the thread throttling (i.e.
> > schedule timeout) behavior.
> 
> It's much more complex than that.
> 
> The count bounds the number of buffers we can add to the list each
> pass.  We also submit the entire list for IO once per pass, hence we
> fill and drain the list once per pass. Hence in normal
> circumstances, the AIL buffer list should never grow very much
> beyond 1000 buffers.
> 
> Further, using xfs_buf_delwri_submit_nowait() doesn't mean that it
> won't block, it just won't wait for IO completion.  We can still
> block on IO submission when the request queue fills up.  i.e. the
> AIL push algorithm is designed to throttle writeback processing at
> IO submission time, not via the higher level backoff loops.
> 

Ok, but it also may not submit I/O at all.

Also I'm not claiming the AIL push is not designed to throttle on I/O
submission, but I do think it's also historically implemented to
throttle its own execution based on push progress and/or list state, for
whatever variety of external reasons it might need to.

> If the disk is really that fast, then all the items in FLUSHING
> state should be completing -really fast- and being removed from the
> AIL just as fast. Hence we should not be spinning on the same items
> over and over again if we are never blocking in delwri buffer
> submission. If we are spinning on the same items, that implies a
> problem with IO completion (ie not removing flushing items), not the
> AIL push algorithm.
> 
> The AIl control loop is also intended to sleep unconditionally when
> it reaches the target LSN. Therefore, not sleeping for a long time
> implies that the target is continually being moved forward faster
> than the AIL can push items to the disk. This also implies that the
> disk is sufficiently fast or has sufficiently deep request queues
> that it never blocks on IO submission.
> 
> Spinning without AIL level backoff or IO submission blocking
> occuring therefore implies journal reservations must be full (i.e.
> lots of userspace modifcation concurrency on a small journal) or we
> are under severe memory pressure triggering repeated full AIL
> pushes.  These are really the only two ways to guarantee the push
> target always keeps ahead of the aild pushing and so keeps it
> permanently busy.
> 
> Hence my request for details about the workload, fs geometry, etc,
> so I have some idea of how we are getting into this state in the
> first place.
> 

Yeah I mean I'm also interested in more detail here. I'm just not
convinced the proposed solution is fundamentally wrong.

> > So ISTM that if the majority of the AIL is
> > flushing, we'd historically want to schedule out and wait for I/O to
> > complete, whereas what this patch describes is a scenario where we now
> > spin around until enough items clear off the list in that particular
> > situation.
> 
> We will only "spin" if pushing is not making progress. If IO is
> being submitted, the the LI_FLUSHING state is transient, and the
> items will be removed from the AIL when the IO completes. We skip
> over them because waiting on LI_FLUSHING items when we are not yet
> at the push target LSN means leaving the disk idle when we could be
> pushing more writeback to it. i.e. we take longer to submit all the
> items we need to get to the target and so end up with lower disk
> utilisation, longer journal reservation latency and lower
> performance/throughput.
> 
> i.e. we only want to throttle processing on IO submission,
> not on the number of items we have flushed to IO buffers. Only when
> we hit AIL congestion do we want to back off at the AIL level.
> 
> > Prior to the optimization in ~2024, it looks like we'd account all these
> > flushing items and back off.
> 
> Yes, that was broken behaviour, and not what I'd originally intended
> for the flush accounting. That commit was when I realised that I'd
> overlooked the fact that ITEM_FLUSHING was reporting two completely
> different things for inode items. i.e. I realised that the
> predominant behaviour being accounted was not the feedback metric
> the control loop was designed to use.
> 
> The control loop attempts to maximise speed and efficiency of
> IO submission - it is not intended to maximise/optimise the number
> of items that get processed. Inodes reporting ITEM_FLUSHING when
> XFS_IFLUSHING was set was essentially just counting the number of
> inodes we attempt to push, and had nothing correlation to IO
> submission behaviour.
> 
> When the inode is first pushed to the cluster buffer it has
> XFS_IFLUSHING set, and if the buffer is successfully queued, it
> returns ITEM_SUCCESS. However, if the buffer was already queued (i.e some
> other inode has already been pushed to it this cycle), then it will
> return ITEM_FLUSHING.
> 
> This ITEM_FLUSHING return value indicates that newly dirty inodes
> have entered the AIL between when the inode cluster buffer was first
> flushed and queued in this processing loop (and returned
> ITEM_SUCESS) and now.
> 
> IOWs, ITEM_FLUSHING is supposed to be an indication that the the
> item is under active modification (i.e. that it has been flushed
> multiple times this processing loop), and so there is active
> access/modification vs writeback contention on the item.
> 
> The other case that inode item push returns ITEM_FLUSHING is if the
> inode already has XFS_IFLUSHING set on it. This indicates that the
> inode has already been flushed to the cluster buffer via a another
> inode push on the same cluster buffer, but by itself it tells us
> -nothing- about whether that inode is being actively modified.
> 
> That is because xfs_iflush_cluster() gathers all inodes in the
> buffer, regardless of where they are in the AIL. So may be older,
> some newer, and so encountering a XFS_IFLUSHING inode carries no
> signal about whether it is being actively modified, nor does it tell
> us that the queued cluster buffer has been updated whilst it was
> already queued.
> 
> Hence, from the POV of the AIL control loop, this latter
> ITEM_FLUSHING metric is pure noise. We did not queue new IO, we did
> not update a buffer already queued for IO, and we do not know if the
> item has been recently modified, yet we still accounted it as
> "flushing".
> 

This all makes sense, but I wonder if it would be simpler to just let
the case of "new inode flushed to pre-queued cluster buffer" return
ITEM_SUCCESS instead of ITEM_FLUSHING.

> Hence the LI_FLUSHING tag: it separates the signal the control loop
> wants (how many objects we pushed multiple times in this processing
> loop) from the noise (how many inodes we've encountered that are
> already either queued for submission, under IO or queued for
> completion processing from the current and/or any previous
> processing loop iteration).
> 
> IOWs, the AIL push loop backoffs are not really about waiting for IO
> completion - IO completion occurs as a side effect of backing off.
> The purpose is to reduce the amount of unnecessary writeback and log
> forces we do for objects in the AIL that are under active
> modification.
> 
> By allowing time for such objects to be relogged and moved forward
> in the AIL instead of written back, we minimise the amount of
> repeated metadata IO we will need to reach the target LSN. Relogging
> is far more IO efficient (sequential journal IO) that metadata
> writeback (random small write IO), and this is one of the key IO
> optimisations the back-offs are trying to achieve.
> 
> TL;DR: the flush backoff is supposed to address the case where the
> AIL is contending with active modifications to items that need
> writeback. It backs off to allow the IO to complete and allow the
> actively modified objects to be relogged and moved well away from
> the current LSN the AIL is processing. This avoids repeated
> mod->journal->writeback->mod->journal->writeback... cycles,
> encouraging mod->journal->mod->journal->... behaviour instead.
> 
> > Also FWIW, looking back at that commit it
> > doesn't say anything about bounding I/O (not to say this isn't a natural
> > side effect of xfaild throttling).
> 
> It's not a side effect of xfsaild throttling. It's a natural
> behaviour from the 1:1 "fill queue, drain queue" IO processing loop.
> I thought that was obvious from the "block on IO submission" part of
> the commit message and never needed more explanation, but I guess it
> wasn't.
> 
> > That commit seems mainly focused on
> > reducing ->iop_push() call overhead and the implementation only focuses
> > on inode items, so altogether this strikes me as more of an (perfectly
> > valid) optimization than fundamental behavior change in how the
> > processing thread or ail accounting should work.
> 
> Commit messages can never tell the whole story. They have to walk a
> line between describing the problem being solved and reviewers
> needing to understand all the subtle intricacies of how a tiny tweak
> fixes a problem with a complex algorithm....
> 
> Reading that commit message back now, the iop_push() cpu consumption
> was the measurable symptom that exposed the issue (i.e excessive CPU
> usage processing a million 'no-op' ITEM_FLUSHING pushes every
> second). However, the second half of the commit message is all about
> how the LI_FLUSHING accounting change exposed other mitigations we'd
> made to handle the noise the inode flushing accounting generated,
> and why they weren't necessary anymore.
> 
> > > > We hit this as a soft lockup during stress testing on an internal
> > > > kernel that includes commit f3f7ae68a4ea ("xfs: skip flushing log
> > > > items during push").  The xfsaild kthread was stuck for
> > > > 22 seconds inside xfs_buf_delwri_submit_nowait(), called from
> > > > xfsaild_push(), processing an excessively large ail_buf_list:
> > > 
> > > Tell me how the delwri list got so long that it gets stuck inside
> > > xfs_buf_delwri_submit_nowait(). Whatever caused that is the bug that
> > > we need to understand and fix - changing accounting to make gross
> > > behavioural changes that result in exceedingly inefficient CPU usage
> > > and break IO optimisations is not the way to address a list length
> > > that has apparently excceeded the bounds built into the code...
> > > 
> > 
> > I think the presumption being made here is that the list is growing
> > excessively because xfsaild is failing to back off when the majority of
> > (inode) items on the list are in the flushing state.
> 
> I don't want to presume anything.
> 
> i.e. I don't know how the problem manifests yet, and the proposed
> solution is not viable. We need to find the root cause of the issue
> before going any further.
> 
> > I guess it would be interesting to know how long the buf list actually
> > is, and whether the soft lockup warning is purely due to buf list size,
> > or more of a combination of ail list size/state, buf list size, and
> > xfsaild thread spinning behavior (we also changed the default timeout to
> > 0).
> 
> Yes.
> 
> > More of a side note to the discussion and related to the actual patch...
> > if we did go with something like this ISTM to make more sense to let
> > xfsaild_push_item() detect and return the flushing state (i.e. similar
> > to how we handle failed state) so the accounting all exists in one
> > place, rather than duplicating it for the optimization. Just my .02.
> 
> I'm not sure it does - see my comment above about ITEM_FLUSHING
> being returned by inode items meaning two very different things, and
> LI_FLUSHING being used to remove the noisy/useless one from the
> control loop.
> 

ISTM this also significantly changed the execution logic in the process.
For example and if I follow this right, suppose the AIL makes a single
pass across multiple loop executions (i.e. multiple xfsaild_push()
calls) and submits multiple batches of I/O in the process. Assume that
the AIL is inode log item heavy with a good amount of cluster buffer
overlap.

In this situation prior to the LI_FLUSHING change, we'd account for all
of the inodes that were batch flushed via xfs_iflush_cluster() by
tracking them in flushing/count, and we set the last pushed lsn marker
for successful/flushing items as we go, so each call to xfsaild_push()
progresses through the list.

After this change, that first pass no longer tracks those items in
flushing or count. AFAICT this has a potential side effect of processing
and submitting more items per delwri submission in this particular
example, but otherwise doesn't seem all that problematic based on what
you describe above.

Once the push loops back (i.e. to the point where it resets last pushed
lsn), however, we're subject to whatever is on the list by virtue of
either not yet completing I/O or not submitting or whatever. At that
point it looks like we now may potentially walk through an increased
number of items in the while loop without any execution backoff because
we've made batches of the list fully invisible to the scheduling logic.
I think you could argue this is actually a loss of "signal" from a task
scheduling perspective. If this repeats over multiple cycles, it doesn't
seem all that far fetched for this to spin excessively either due to an
excessively large AIL list, delwri list, or both.

I could see how the previous behavior is not necessarily the ideal
design for dealing with this, but just calling this previous state "not
viable" when it basically restores longstanding historical behavior and
preserves the optimization of the original change doesn't sound
technically accurate to me. I'm happy to hear more details, but based on
what we know so far I still suspect the most appropriate thing to do
would be some combination of restoring the original tracking like this
patch does, and then revisit these design tweaks in a followup
patch/series..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

