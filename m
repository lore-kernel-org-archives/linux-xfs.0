Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E96A35E936
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785780350; cv=none; b=ksS0wxpf04JTqpSWAYI6fxoD1aHRi/VMvfc2t1H93VdJnBgLJEi+vSg2yok7DJ28JMJA0wDHN8PyhXKMNWwZAyAaNqzlKUIebxuf4eFVEcMeGKzQqeUm0pPoobavx4qyHavJDPsWVDGDorhSLmltaXcykMGoteZ/5u9vl9ylG40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785780350; c=relaxed/simple;
	bh=9r/dI+7rLXxhacoTxCH1kCzAn10vbgP9Cj2y1pZrvgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZMAZvwHqWlkYTWzLvRF4fbch+tBtOTdH0Ct81xdTgI8qnqh7ar1JtVZQbI8ep+C3doH8OR/VM8zOHhSbT6iEZIXaQGKLB5RGBN5Hy+yzR1WpQRwXpHz/sMKMChmKdqY/WynpJvYArlcq9W9ggqgrlwvlwF3pjyb3u4WR3tZx2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C7Ycq7by; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C7Ycq7by"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785780348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/6UHAcFwsI8/yrOR6Rt4jw4SXH6FP9ebkvA52rYwZY=;
	b=C7Ycq7byMwxRcocIvm0iwPfjSdr3crb2ATZezekZLGqV/4ll58ezMxg1kfVORX6bDtpZLL
	bPCC3RDBqrVCj/dv79/4Xx+0eN+9lEYMWNcXceqM0LzGY6UGqXyL+iAJyrMVs4ysVEZfGa
	TRNkvAge1byzj6VwtxpOhR/RlKoTo68=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-6aCqBdlNM6mXVk0R71EO3w-1; Mon,
 03 Aug 2026 14:05:46 -0400
X-MC-Unique: 6aCqBdlNM6mXVk0R71EO3w-1
X-Mimecast-MFC-AGG-ID: 6aCqBdlNM6mXVk0R71EO3w_1785780345
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5423C1956094;
	Mon,  3 Aug 2026 18:05:45 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.193])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A361C1800480;
	Mon,  3 Aug 2026 18:05:44 +0000 (UTC)
Date: Mon, 3 Aug 2026 14:05:42 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH 2/2] xfs: consistent low ag space behavior for sparse
 inode chunk allocs
Message-ID: <anDYdgP6y2537cY_@bfoster>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-3-bfoster@redhat.com>
 <am05vzAntuhAKXgr@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <am05vzAntuhAKXgr@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sat, Aug 01, 2026 at 10:11:43AM +1000, Dave Chinner wrote:
> Hi Brian,
> 
> On Fri, Jul 31, 2026 at 12:33:37PM -0400, Brian Foster wrote:
> > Matt Fleming reports a filesystem shutdown due to inobt block
> > allocation failure during sparse chunk allocation. Inode creation
> > can involve multiple allocations in a transaction via the initial
> > chunk allocation and inode btree growth via the subsequent inobt
> > record insertion. Technically this should be safe as the chunk
> > allocation sets the allocation minleft parameter to the max depth of
> > the inode btree, which means the allocation selects an AG only if
> > there is enough free space for record insertion after the
> > allocation. The record insertion naturally occurs in the same AG as
> > the allocation and the associated AGF is locked and held by the
> > current transaction.
> > 
> > The situation that reproduces this failure is a bit of a corner
> > case. The allocation and inode btrees are all completely full and
> > require a split on the next insertion. The AG has just enough
> > available space to satisfy inode creation through sparse allocation
> > (i.e. 7 blocks in this example). The block allocation occurs within
> > an existing free space record, splitting the free space record into
> > two and triggering the aforementioned allocbt splits.
> > 
> > The sparse chunk allocation consumes 4 blocks for the chunk, and 4
> > blocks from the AGFL for the two allocbt splits. This leaves the
> > AGFL with 4 remaining blocks and 3 available blocks in the AG. The
> > record insertion attempts block allocation for the inobt split, but
> > even though space is available, the geometry change has changed the
> > minimum allocation requirements enforced by
> > xfs_alloc_fix_freelist(). The min freelist value jumps from 8 to 12
> > due to the alloc btree level increases, so the available space
> > calculation goes from something like this before the allocation:
> 
> Ok, in my own words, the problem is that the minleft takes into
> account the space needed by the inobt/finobt allocations, but the
> allocator doesn't take into account that the AGFL requirement may
> increase for the second allocation in the transaction because the
> first allocation split the free space trees?
> 
> Is that an accurate summary of the issue?
> 

Yup.

> If that is the case, then I think the root cause of the issue is
> that amount we are reserving for the AGFL on the first transaction
> is insufficient. ENOSPC needs to be detected before we modify
> anything, so it has to be done at the first allocation. However, it
> appears to be based on the current level of the bno/cnt btrees, not
> the potential for the level to increase and the AGFL require a
> larger block reservation than we've accounted for with minleft.
> 
> Therefore, we need to account for the AGFL demand increase in the
> first reservation that might occur for the second (and subsequent
> allocations.
> 
> i.e. if minleft != 0, then the agfl btree block reservations need to
> be done for (current level + 1) to take into account space for the
> trees to split during the dependent allocation chain that minleft !=
> 0 implies is about to occur.
> 

Ok, this more aligns with what the LLM had suggested, at least in terms
of fixing the problem at the first AGFL check via the minfree
calculation. IIRC it wanted to bump minleft internally and that came out
rather uglier than bumping min_free (as below).

> This isn't an issue just for inobt/finobt blocks on inode chunk
> alloc, it's also an issue for anything that sets minleft for a
> dependent, multi-allocation operation (e.g. data extent allocation +
> BMBT block allocation). 
> 

Yeah, I noticed we had a handful of other cases that use minleft like
this. I wonder if the main reason we don't hit this from the bmapi path
is that it's usually open to multiple AGs for bmbt allocs and not fixed
to a single AG like inode chunk and corresponding inobt block allocs
obviously are.

> So from this perspective, I think the fix needs to be made to the
> calculation in xfs_alloc_min_freelist() to take into account minleft
> needing a larger AGFL reservation if any of the allocations in the
> chain splits.
> 
> Hmmmm. I'm not sure the calculation in xfs_alloc_min_freelist() is
> correct, either:
> 
>         /*
>          * For a btree shorter than the maximum height, the worst case is that
>          * every level gets split and a new level is added, then while inserting
>          * another entry to refill the AGFL, every level under the old root gets
>          * split again. This is:
>          *
>          *   (full height split reservation) + (AGFL refill split height)
>          * = (current height + 1) + (current height - 1)
>          * = (new height) + (new height - 2)
>          * = 2 * new height - 2
> 
> i.e. I think the AGFL refill split height is wrong.
> 
> Look at it this way: we do the AGFL refill -first-, so if that
> splits, we consume (current height + 1) blocks, and then new_height
> = (current height + 1). Then if the actual data allocation does a
> full split again (i.e. all except for the root block), that needs
> (new_height -1) blocks. So that becomes:
> 
> 	new_height = current height + 1;
> 	blocks = new_height + (new_height - 1)
> 	       = 2 * new_height - 1.
> 
> IOWs, I think there's an existing off-by one in the AGFL btree block
> reservation calculation that contributes to this problem as well.
> 

Hmm.. I need to stare at this a little more, but I think that makes
sense.

> Put these two things together:
> 
> 	/*
> 	 * if minleft is set, we are going to do multiple * allocations in this
> 	 * transaction (e.g. inode chunk followed by inobt). Hence
> 	 * we need to make sure we have enough space for fixing up
> 	 * the freelists after the split as the btree level
> 	 * increases the AGFL reservation size mid-transaction. If
> 	 * we are close to ENOSPC, this AGFL reservation increase may
> 	 * trigger ENOSPC from the subsequent allocation attempt,
> 	 * and then we shutdown the filesystem. Hence if minleft is
> 	 * set, reserve enough AGFL space for a potential split
> 	 * during the allocation chain in this transaction up front.
> 	 */
> 	split_space = 1;
> 	if (minleft)
> 		split_space = 2;
> 
>         /* space needed by-bno freespace btree */
>         min_free = min(bno_level + split_space, mp->m_alloc_maxlevels) * 2 - 1;
>         /* space needed by-size freespace btree */
>         min_free += min(cnt_level + split_space, mp->m_alloc_maxlevels) * 2 - 1;
>         /* space needed reverse mapping used space btree */
>         if (xfs_has_rmapbt(mp))
>                 min_free += min(rmap_level + split_space, mp->m_rmap_maxlevels) * 2 - 1;
>         return min_free;
> 
> This is all off the top of my head, I haven't verified it so it'll
> need checking. However, I think handling this situation generically
> in the allocator is a better solution than trying to work around it
> with caller-based minleft heuristics.
> 

I think this is reasonable. The thing that stands out a little bit is
that technically we're reserving for the worst case min_free allocation
requirement of the second alloc, not necessarily the actual number of
blocks needed, right? That seems fine if so. I just want to make sure
we're clear and we document the updated calculation appropriately (i.e.
noting how minleft > 0 is a somewhat special case).

The off-by-one thing aside, IIUC the current min_free calculation
correctly accounts the actual number of blocks we'd consume in the worst
case for both allocations, it just doesn't account for how the min_free
requirements change upon reentry into the allocator after a minleft > 0
allocation.

I'll throw some testing at this. Thanks for the feedback.

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> dgc@kernel.org
> 

