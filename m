Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF7351CF6B
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790171088; cv=none; b=bxQ3Avl+FLB7JizexoKTaRKjKqN7d1/ZBZ+rw5nLtJYjq2a2o+XlM9tL5F0Tkflm4y8HcTMN3+peVLPTg7PWm1rbqH2doeg7krMVDqCsiZlZ5te6LvTy6xignyQfg7grdgN2vPJyFq/OhJQh2MxExn8aAala3bgizx/iHpM8sLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790171088; c=relaxed/simple;
	bh=kE9Lyk8gNuMYMbH3LFiUp+OaSx9a97sEr0BuQW4+sYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFHTFhv9a39cKzQQlbU5rCFmDDh1Lhk3vthf2vs99xHRfLbKKH2dSC6XQdhqnFsUOEQc05SX/i5DrzkEd5prFsA05sWO+Ga1VjfKP4FobAf2Jxm+4U8rMkwCDvsYuVAoy+U79j8IYoHIwrM4zPvk/Yb01DrAUwJjhkQvA7wtMQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aCY4rq1n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aCY4rq1n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790171085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4OQMq1C0NOJobvtPRm2xkdzTOVK4hQpsY9hlZ3iTuGI=;
	b=aCY4rq1nR4nnZTWDyDRUYKgfJuAzPRjC9xcAithWsc1HboeAD9SC1LLkldhRv6vf7eKmxP
	YCxW8zodfXyV0qjmBMX9LsdJXZ/KuITerzRS6mdL0xFCVV7jiQ6r85sgyxnYqAmH/qzY5F
	V6ZFXHLaPJZdfREm+jjy/7vv+M0NROw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-6nzWd2aAPqi10Zgm4T2EUQ-1; Wed,
 23 Sep 2026 09:44:39 -0400
X-MC-Unique: 6nzWd2aAPqi10Zgm4T2EUQ-1
X-Mimecast-MFC-AGG-ID: 6nzWd2aAPqi10Zgm4T2EUQ_1790171077
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E15481944D31;
	Wed, 23 Sep 2026 13:44:36 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D723180057E;
	Wed, 23 Sep 2026 13:44:35 +0000 (UTC)
Date: Wed, 23 Sep 2026 09:44:32 -0400
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
Message-ID: <arPXwKnDMVMj-oMK@bfoster>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
 <arL9Xrmf5Q7wd3T4@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arL9Xrmf5Q7wd3T4@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Sep 23, 2026 at 08:12:46AM +1000, Dave Chinner wrote:
> On Tue, Sep 22, 2026 at 04:14:29PM +0800, MingTao Huang wrote:
> > From: MingTao Huang <mintaohuang@tencent.com>
> > 
> > Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
> > introduced a fast path in xfsaild_push() that uses
> > test_bit(XFS_LI_FLUSHING) to skip log items already being
> > flushed.  However, the fast path jumps directly to the
> > next_item label, bypassing flushing++, count++, and the
> > ail_last_pushed_lsn update.  This causes three problems:
> 
> Right, they get skipped because they are already flushing and we are
> not doing anything with them. i.e. they've already been accounted as
> flushing (e.g. inodes that were gathered into a single buffer flush
> by xfs_iflush_cluster()) and the buffer is already either on the
> delwri list for submission or under IO.
> 
> > 
> > 1. The loop exit condition "count > 1000" becomes much harder to
> >    trigger.  count was meant to track every item visited, but now it
> 
> No it isn't.
> 
> As the author of this code, I can say for certain that the intent of
> 'count' is to count the number of items we made pushing decisions
> about, not count the number of items we have iterated. 
> 
> The purpose of 'flushing' is to account for the number of buffers we
> accumulate on the delwri list before we submit it. As count is
> incremented whenever flushing is incremented, it currently forms
> an upper bound to the number of buffers that can be queued on the
> delwri list in a single push iteration.
> 
> The purpose of 'stuck' is to account for items that could not be
> placed on the delwri list because they were locked, pinned or
> otherwise unavailable for flushing.
> 
> 'success' is not directly counted, because there is no further
> action that needs to be taken for them; they are simply counted,
> and hence contribute to the flush/stuck ratio decisions later.
> 
> IOWs, every 'push decision' that could add a buffer to the delwri
> list is accounted by 'count', and flushing/stuck indicate what
> decision was made.
> 
> The point of LI_FLUSHING was simply to skip over all the items that
> would not change either count, flushing or stuck because they have
> already been accounted to 'count' and 'flushing' by a prior push
> decision.
> 
> >    only increments for non-flushing items that enter
> >    xfsaild_push_item().
> 
> Exactly - count is the number of items we made new pushing decsions
> about.
> 
> >    Each such item typically triggers an inode
> >    cluster flush that marks dozens of neighbouring inodes as flushing,
> >    so count effectively counts cluster flushes rather than individual
> >    items. 
> 
> Yes, that is exactly the intent - a single cluster buffer on the
> delwri list covers up to 32 inode items on the AIL. That is -one IO-
> for up to 32 items on the AIL, and it is -IO- that we are trying to
> account for and optimise here, not log items.
> 
> >    The threshold shifts from 1000 items to ~1000 clusters,
> 
> No, the count has always been '1000 new buffer IO decisions made',
> not '1000 items processed'.
> 
> >    letting the loop scan an order of magnitude more items per round.
> >    Each cluster flush adds a buffer to ail_buf_list, and the resulting
> >    oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
> >    list_sort() plus per-buffer trylock and IO submission -- to take so
> >    long that the watchdog fires.
> 
> How? count bounds the delwri list to 1000 buffers at most. That's
> very intentional, and the number is based on benchmarking results.
> 

I'm confused by some of the reasoning here. Maybe I'm missing something,
but that count check looks like it only limits the current pass. The
flushing value is basically just input into the thread throttling (i.e.
schedule timeout) behavior. So ISTM that if the majority of the AIL is
flushing, we'd historically want to schedule out and wait for I/O to
complete, whereas what this patch describes is a scenario where we now
spin around until enough items clear off the list in that particular
situation.

Prior to the optimization in ~2024, it looks like we'd account all these
flushing items and back off. Also FWIW, looking back at that commit it
doesn't say anything about bounding I/O (not to say this isn't a natural
side effect of xfaild throttling). That commit seems mainly focused on
reducing ->iop_push() call overhead and the implementation only focuses
on inode items, so altogether this strikes me as more of an (perfectly
valid) optimization than fundamental behavior change in how the
processing thread or ail accounting should work.

> i.e.  A thousand items on a list takes a couple of milliseconds to
> sort. I/O submission of that list takes a couple of milliseconds if
> it doesn't block (i.e. the IO subsystem has to be faster than the
> CPU IO submission loop to avoid block on a full queue), and if it
> does block, we want all the IO submission to merge as effectively as
> possible in the queue so that we use as few IO slots in the queue as
> possible.
> 
> Hence the submission code should not be running around in a hard
> loop for 22s because of a list that is too long. The buffer list
> length is -bounded- by count, and that should prevent these sorts of
> issues.
> 
> > 2. The timeout decision "(stuck + flushing) * 100 / count > 90" is
> >    computed without the fast-path flushing items, so the flushing ratio
> >    is severely under-reported.
> 
> No, the accounting this check is acting on is correct. The action we
> take is based on the all the items we tried to push this iteration,
> not the indirect LI_FLUSHING items that we didn't make a decision
> about or are still in progress from the previous iteration.
> 
> >    When most of the AIL is flushing, the
> >    ratio appears near 0%.
> 
> How did you get into a state where most of the AIL is flushing and
> no progress is being made transitioning items out of flushing state?
> 
> i.e. if delwri submission is not making progress, then the ail push
> will keep appending to the delwri list (by design, so we retry
> flushing items until submission succeeds). This will result in
> transitioning most of the AIL to flushing state and queued on the
> delwri list. This is a symptom of the delwri submission not
> making progress and rather than a problem with AIL flushing
> accounting.
> 
> i.e. we need to know why delwri submission is not making progress,
> as that is likely the real cause of the problem. i.e. it is unlikely
> that this has anythign to do with how we account for item push
> decisions, and it is likely your changes just slow down or change
> the timing of item pushing sufficiently to avoid whatever issue is
> occuring in delwri submission.
> 
> >    xfsaild therefore selects
> >    "tout = 0" when it should select "tout = 20" (20 ms
> >    back-off to let IO complete).  The zero-backoff tight loop compounds
> >    the ail_buf_list accumulation across rounds.
> > 
> > 3. ail_last_pushed_lsn is not advanced past flushing items, so the
> >    next push round restarts scanning from the same position, repeatedly
> >    traversing items that are still in-flight.
> 
> This is why we do not account for flushing items that we skip. It will
> walk over them as fast as possible until it reaches items that it
> can push. Those items will then be accounted as
> flushing/stuck/count. This will then move the last_lsn forwards
> appropriately or trigger a log force or backoff sleep and so it
> should not get stuck spinning for 22s in that case, either.
> 
> > We hit this as a soft lockup during stress testing on an internal
> > kernel that includes commit f3f7ae68a4ea ("xfs: skip flushing log
> > items during push").  The xfsaild kthread was stuck for
> > 22 seconds inside xfs_buf_delwri_submit_nowait(), called from
> > xfsaild_push(), processing an excessively large ail_buf_list:
> 
> Tell me how the delwri list got so long that it gets stuck inside
> xfs_buf_delwri_submit_nowait(). Whatever caused that is the bug that
> we need to understand and fix - changing accounting to make gross
> behavioural changes that result in exceedingly inefficient CPU usage
> and break IO optimisations is not the way to address a list length
> that has apparently excceeded the bounds built into the code...
> 

I think the presumption being made here is that the list is growing
excessively because xfsaild is failing to back off when the majority of
(inode) items on the list are in the flushing state.

I guess it would be interesting to know how long the buf list actually
is, and whether the soft lockup warning is purely due to buf list size,
or more of a combination of ail list size/state, buf list size, and
xfsaild thread spinning behavior (we also changed the default timeout to
0).

More of a side note to the discussion and related to the actual patch...
if we did go with something like this ISTM to make more sense to let
xfsaild_push_item() detect and return the flushing state (i.e. similar
to how we handle failed state) so the accounting all exists in one
place, rather than duplicating it for the optimization. Just my .02.

Brian

> -Dave.
> 
> 
> -- 
> Dave Chinner
> dgc@kernel.org
> 

