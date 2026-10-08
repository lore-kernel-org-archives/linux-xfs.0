Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391CD49B446
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462849; cv=none; b=YK4brs6aTgqISOekJOJ1o6TV0NOGT2HmVcnpsiZYewDUbu1t4de67ZO7uMrLarZjLwoKwuiiZNWlzO4BRdXVdCXlT/29U9uuEN3SmgRuFu/yS3o/a/I1f9Ki7lol7c2PJci+8tY0Ue6HPezxd54zXtV3gtrZA7xsrYPSk1rlIr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462849; c=relaxed/simple;
	bh=AGszSjoCjaIDSHO0H56sQ2h/hYs0oq7dn3O2LJuCupU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+43gJ9XrD1z8cEwDSp0kmvt4GJK5jvskz8cfcAZpPBWsIKP4HduSmB+iDAaxdwt8T+5KbvgHgx7NS2wGSLPTUoQC1dR69/FUtefFFabHufXrT0tXClRDJM4sYDtqKxyPITwV627BTuax79t0E3gwiiBk66mFogi4cvK4gbhBIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSewVXus; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSewVXus"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791462846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sl228m5pfmzrEf0xxmHM+2u5vzx7rVcCe/qp2YvfpqY=;
	b=MSewVXusTDbct4iNjYuJCrzBDkLu5wgj0WH/fDl+AJ2qp1u5pqGZRQ5ZVAWkj5a5OrHY07
	pXRiardmkWiOgI7lOVG7uBPsKcXcc516u05u3fMITzh4DTaQMueUohKUIwcvto7QpNTQ7H
	azNDHFMeG61nC2iXxwIYzA0GyvBjAxU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-o3xzxnnBPeWG7ZXrb76iTQ-1; Thu,
 08 Oct 2026 08:34:03 -0400
X-MC-Unique: o3xzxnnBPeWG7ZXrb76iTQ-1
X-Mimecast-MFC-AGG-ID: o3xzxnnBPeWG7ZXrb76iTQ_1791462842
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F37CA180ABEF;
	Thu,  8 Oct 2026 12:34:01 +0000 (UTC)
Received: from bfoster (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59BB219560AB;
	Thu,  8 Oct 2026 12:34:00 +0000 (UTC)
Date: Thu, 8 Oct 2026 08:33:58 -0400
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
Message-ID: <aseNtqNcruhTeOEd@bfoster>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
 <arL9Xrmf5Q7wd3T4@dread>
 <arPXwKnDMVMj-oMK@bfoster>
 <arRv-SRK0nHHGBxM@dread>
 <arq3MsiNwf1R1QCL@bfoster>
 <arse0L6mA00ybLvf@dread>
 <ar0VBbwULCzAQW2u@bfoster>
 <asR23Qk3uXtTSTKr@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asR23Qk3uXtTSTKr@dread>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Oct 06, 2026 at 03:19:41PM +1100, Dave Chinner wrote:
> On Wed, Sep 30, 2026 at 09:56:21AM -0400, Brian Foster wrote:
> > On Tue, Sep 29, 2026 at 12:13:36PM +1000, Dave Chinner wrote:
> > > > > Hence, from the POV of the AIL control loop, this latter
> > > > > ITEM_FLUSHING metric is pure noise. We did not queue new IO, we did
> > > > > not update a buffer already queued for IO, and we do not know if the
> > > > > item has been recently modified, yet we still accounted it as
> > > > > "flushing".
> > > > 
> > > > This all makes sense, but I wonder if it would be simpler to just let
> > > > the case of "new inode flushed to pre-queued cluster buffer" return
> > > > ITEM_SUCCESS instead of ITEM_FLUSHING.
> > > 
> > > That means we lose the 'this inode cluster is being actively
> > > modified' signal from the feedback loop. That makes it behave
> > > differently to buffer items, and so now we have confused and
> > > unbalanced signals being fed to the backoff control decision again.
> > 
> > What do we do (or not do) with this signal?
> 
> That triggers a larger backoff - the "flushing" part of the
> "if (stuck + flushing > count * 0.9)" of the check. If we get lots
> of newly dirtied inodes pushed to already queued inode buffers,
> then we backoff for 20ms because it implies we are reaching the
> active head of the AIL where journal commits are inserting newly
> committed dirty items.
> 
> This is very similar to when LOCKED starts to show up - the only
> difference between FLUSHING and LOCKED in this situation is that
> FLUSHING means the inode buffer is still queued for IO, whilst
> LOCKED means one of two things:
> 
> 1. It is being actively accessed and maybe modified (i.e. locked in
> a transaction), and so it is about to be relogged and pinned, in
> which case we can't flush it. It is likely "stuck" until some time
> passes.
> 
> 2. it is locked and under writeback IO. In this case, it was likely
> pushed on the previous AIL push iteration. i.e. we are iterating
> recently pushed items that are still under IO. If we get lots of
> locked items, then we are likely 'stuck' needing them to complete IO
> for progress to be made. Hence we need to back off.
> 
> PINNED is very similar LOCKED case 1, only it has been relogged and
> is dirty in the CIL.
> 
> Hence there is a simlar relationship between pinned, locked and
> flushing - the only difference between them is where in the
> 'recently modified and/or submitted for IO' cycle the objects are
> in.
> 
> These all indicate we have push vs access/modification contention on
> the log items, and we give the active modifications processing
> preference by backing off. i.e. we prioritise relogging over
> pushing because it avoids unnecessary writeback IO, and to do that
> we need pushing to back off when contention signals are detected.
> 

Ok. I get this in principle. Does this reflect a realistic workload for
inodes?

According to the current code, flushing inodes are those that have
landed in the AIL since or were otherwise not flushed (i.e. pinned,
locked) during a previous cluster flush, where the cluster was delwri
queued but has not yet submitted.

The only use of this value is as input to the 90% stuck heuristic. For
inodes, this strikes me as rare enough to wonder why we track this at
all..?

> > ITEM_* implies state of the log item, so I don't see that as
> > inconsistent. They behave differently because they are different items.
> > What's the expectation for the push interface? If we flush an ili/dquot
> > and the buffer is already queued, did we push the item "successfully" or
> > was the item "flushing?"
> 
> It's an indication that there is active modification occurring on
> the inodes/dquots on the cluster buffer, and so we have to make a
> decision to push immediately or back off to allow further
> aggregation.
> 
> push immediately (i.e ignore flushing signal) means the inode
> cluster gets submitted for IO, and the next inode we modify on that
> cluster blocks waiting for cluster IO to finish. If we get the
> timing wrong, we end up doing lots of individual inode pushes and
> repeated cluster buffer IO, instead of aggregating them all into a
> single IO. the "flushing" signal is a sign of the push algorithm to
> back off to allow  modification to continue unhindered and hance
> allow the next push of a item on that cluster buffer to sweep all
> the modifications in one go.
> 
> i.e. the decision is "push immediately and repeatedly" or "backoff
> on modification contention and push once". Doing it once is more CPU
> and IO efficient, push immediately causes modification latency
> issues in xfs_inode_item_precommit() locking the cluster
> buffer...
> 
> > > That is, we can have tens of thousands of inodes on the same LSN in
> > > the AIL. A CIL checkpoint on a large log is closed off at ~32MB in
> > > size, and an inode core takes up about 300 bytes in the journal. If
> > > we are logging nothing but inode cores (e.g. 'chown -R <somedir>'
> > > over millions of files) then a single checkpoint can contain up to
> > > ~100,000 inode log items. These are all inserted into the AIL at the
> > > same LSN.  Hence it is very common for there to be tens of thousands
> > > of inode in the FLUSHING state on the same LSN in the AIL.
> > > 
> > 
> > So in the current code what prevents from adding that many cluster
> > buffers to the delwri queue? The current count > 1000 logic only breaks
> > across an LSN change, so ISTM queue length is subject to the level of
> > cluster overlap in the dataset.
> 
> <looks closer>
> 
> Ok, that's probably a real bug. I think it should be an || not an
> &&. i.e. I'd intended it to submit the buffer list when we completed
> flushing a checkpoint (i.e. the LSN changes) or if we'd gathered
> enough items on the buffer list for submission (count > 1000).
> 

Wouldn't that mean we'd only process 1k items per pass, rather than
creating a delwri queue limit? It also seems to me this could lead to
situations we've already discussed like spinning around on the same
subset of items if they happen to land in the same LSN (unless we do the
cursor thing).

> This points out the difference between "knowing the intent" and
> "reading the code". One cannot tell the difference between bug and
> intended behaviour from reading the code....
> 

I'd have expected intent to be documented in the commit log.

> As it is, this could result in longer buffer submission lists, but
> that makes it even less likely to trigger a hangcheck timer. i.e.
> submission to the request queue is typically faster than hardware IO
> completion, hence the more we have to submit, the more likely we are
> to block on a full request queue.
> 

Hm.. not sure about that. I played around with this a bit last week. I
couldn't exactly reproduce what is reported here, but if I run this sort
of workload on a slightly older kernel with preempt=none, I could
definitely reproduce observable multi-second (~3-5s) stalls where the
target system would appear locked up completely. Tracing shows that the
delwri queue can easily grow to ~250k+ buffers and the xfsaild task can
spin in short intervals.

I could corroborate this by reducing the watchdog threshold to a few
seconds and trigger softlockup warnings/stack traces that way, but
obviously this is a little different from a 20+ second lockup using
system defaults.

IIRC this behavior went away with the lazy preempt mode, so perhaps that
is a mitigating factor here. It would be good to know whether these
settings are relevant to the original reproducer or not.

> > > inodes doesn't actually move the LSN for the next loop forwards.
> > > We start the next loop at the same LSN in this case, and the only
> > > reason we didn't tend to process the same flushing items a second
> > > time is the backoff allows IO completion to remove the items from
> > > the AIL.
> > > 
> > 
> > I get that the LSN bookmark is not granular, but the old algorithm only
> > broke the loop if we were stuck or hit the target. It resets the
> > bookmark if the 90% stuck+flushing threshold is met or we hit the
> > target. So the example described above sounds like one where we'd reset
> > the LSN pushed bookmark anyways, or otherwise we are stuck and intend to
> > repush locked/pinned items.
> > 
> > That said, I can see how accounting the flushing state for cluster
> > flushed inodes in the same push cycle inflates this metric into backing
> > off/restarting, which seems like a flaw/inefficiency in the old code.
> 
> It's not just the backoff, it's all the extra code that has to be
> executed to get to the point of realising the inode has already been
> flushed to the cluster buffer. THis change made it a single bit
> check in the outer loop, vs going into ->iop_push and taking a cache
> miss to pull the buffer from the ILI, then another to pull the inode
> and i_flags from the ILI, then another to pull the pincount from the
> inode, then another to pull the pin count from the buffer,
> 

I get that, but we can easily separate iop_push() overhead from the
question of flushing inode accounting.

> IOWs, the LI_FLUSHING check runs hot in cache, whilst iop_push()
> takes multiple dependent cacheline misses for every inode it checks
> for STALE/pinned/flushing....
> 
> <snip>
> 
> > > Besides, if the problem really is "we are walking too many
> > > LI_FLUSHING items repeatedly because the LSN is not changing", then
> > > I'm pretty sure there's a relatively straight forward fix for that.
> > > i.e. we need fine grained tracking of the item we are up to across
> > > loop iterations where the AIL lock is not held and the AIL can
> > > change. We already do this within the processing loop itself...
> > 
> > I'm curious what you're referring to here, if not the last lsn thing..
> > a cursor enhancement perhaps?
> 
> Yeah, get rid of last_pushed_lsn, and keep the cursor active across
> push iterations. The only reason for last_pushed_lsn existing is to
> re-seed the cursor on the next iteration. It's a bit of a wart, and
> it's quite inefficient because we have to walk the entire list from
> the head or tail to find the LSN we need to start at.
> 
> To replace last_push_lsn, we can store a lsn in the cursor on item
> deletion to act as a reseed value for the next iteration instead of
> starting from the [still valid] item in the cursor...
> 

That sounds reasonable, but perhaps non-trivial due to locking.

So all in all we have a situation where there's an unknown soft lockup
issue, a potential bug in iteration logic, an unclear requirement for
more complicated cursor management, and from my perspective a lack of
documentation on design intent (so we're reverse engineering it
piecemeal).

I still think the right approach here may be to rework the original
optimization in a way that retains prior iteration behavior, and then
revisit whatever algorithmic changes that were intended here in followon
patches with more clear documentation. I don't need to know what the
precise issue being reported here is to reason that there's probably
more complexity to this change than originally anticipated. All this is
saying is that it can't hurt to take a more careful approach. 

I also think this makes life easier for stable kernels where it might
take longer for more conservative users to run into the sort of problems
reported here (particularly with older preemption behavior).

This is just my .02. I cooked up a patch for reference:

https://lore.kernel.org/linux-xfs/20261008123141.358649-1-bfoster@redhat.com/

I forgot to label it RFC, but this is mainly for posterity. I'm
operating under the assumption this is NAK'd, so it is untested unless
there's indication we want to do something with it.

Brian

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

