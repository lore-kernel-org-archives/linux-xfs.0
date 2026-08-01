Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809BC286A7
	for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2026 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785543113; cv=none; b=WbfCUrBotEz8cmNZ/r1ZqQNYfzXuihKEaT96y7QCgYhaJcdNx07vdWEQ3yEIEkLlD1vQkYLd+rolyK+Lgc5PnPkUdUyzrHCS4TNzB/HXMC+PtRPyUyS3l0zud2T3bYy4q0jldZq6ZwsyX31WNf3zCu+EvN2karHiDwjog7VfHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785543113; c=relaxed/simple;
	bh=bScoIUgtWg6PufG47wdSvgoXTyp6XK7e2C5jPey84bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYQXzqHSdOl+EaVM8yLtGbxdaLaBvaa56ogNBWt7u2Kte9NjOTarnLQTg3C5Bk2Yt4S748YOsPvkZhryCZOHTDLKRK9qf4cw2LEyCZAiTvK01a6P+NmWJEWyqumArBw0knJ0LIbwdIm+VQs5hYBDOjiEOkNs7Hh534Vvch07OMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhuIPimQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhuIPimQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCCB1F00AC4;
	Sat,  1 Aug 2026 00:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785543112;
	bh=tgUOxXrX8a7rgOw03cLio8WgBDADNPx876jHBwMAnuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PhuIPimQ215LwA1SsQ0ZSiVefgeazOULolLLKAVMH4HUyhKrkB1pUA2cwXhDQ8S39
	 T0i9mj9dX2ETWqHLuYwSGBjvtwXg6LPFiCBfvqsOwOa8SSKS/Fse1N2TxiOspitXWw
	 +HCVKzhGosdHEHzVZM/fia5lmkUZLPqtWMIDlSaRkWuki+lgBFukUY4h/IXwqVO1Ps
	 fJHKIfkh2sUdhrucuPTF0laK0dOv3wpnjnH7VwNGOlYdziJiBDy4Ha+pKNOIPp4WSi
	 EkL6UjuUWq6m3N7D2QNLnrmAxEhrdSHd5ulOx9o/Uqw59fnXyhc3t/gfQXNO03l2T+
	 zFi1Fvfr7Sxdg==
Date: Sat, 1 Aug 2026 10:11:43 +1000
From: Dave Chinner <dgc@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH 2/2] xfs: consistent low ag space behavior for sparse
 inode chunk allocs
Message-ID: <am05vzAntuhAKXgr@dread>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731163337.152522-3-bfoster@redhat.com>

Hi Brian,

On Fri, Jul 31, 2026 at 12:33:37PM -0400, Brian Foster wrote:
> Matt Fleming reports a filesystem shutdown due to inobt block
> allocation failure during sparse chunk allocation. Inode creation
> can involve multiple allocations in a transaction via the initial
> chunk allocation and inode btree growth via the subsequent inobt
> record insertion. Technically this should be safe as the chunk
> allocation sets the allocation minleft parameter to the max depth of
> the inode btree, which means the allocation selects an AG only if
> there is enough free space for record insertion after the
> allocation. The record insertion naturally occurs in the same AG as
> the allocation and the associated AGF is locked and held by the
> current transaction.
> 
> The situation that reproduces this failure is a bit of a corner
> case. The allocation and inode btrees are all completely full and
> require a split on the next insertion. The AG has just enough
> available space to satisfy inode creation through sparse allocation
> (i.e. 7 blocks in this example). The block allocation occurs within
> an existing free space record, splitting the free space record into
> two and triggering the aforementioned allocbt splits.
> 
> The sparse chunk allocation consumes 4 blocks for the chunk, and 4
> blocks from the AGFL for the two allocbt splits. This leaves the
> AGFL with 4 remaining blocks and 3 available blocks in the AG. The
> record insertion attempts block allocation for the inobt split, but
> even though space is available, the geometry change has changed the
> minimum allocation requirements enforced by
> xfs_alloc_fix_freelist(). The min freelist value jumps from 8 to 12
> due to the alloc btree level increases, so the available space
> calculation goes from something like this before the allocation:

Ok, in my own words, the problem is that the minleft takes into
account the space needed by the inobt/finobt allocations, but the
allocator doesn't take into account that the AGFL requirement may
increase for the second allocation in the transaction because the
first allocation split the free space trees?

Is that an accurate summary of the issue?

If that is the case, then I think the root cause of the issue is
that amount we are reserving for the AGFL on the first transaction
is insufficient. ENOSPC needs to be detected before we modify
anything, so it has to be done at the first allocation. However, it
appears to be based on the current level of the bno/cnt btrees, not
the potential for the level to increase and the AGFL require a
larger block reservation than we've accounted for with minleft.

Therefore, we need to account for the AGFL demand increase in the
first reservation that might occur for the second (and subsequent
allocations.

i.e. if minleft != 0, then the agfl btree block reservations need to
be done for (current level + 1) to take into account space for the
trees to split during the dependent allocation chain that minleft !=
0 implies is about to occur.

This isn't an issue just for inobt/finobt blocks on inode chunk
alloc, it's also an issue for anything that sets minleft for a
dependent, multi-allocation operation (e.g. data extent allocation +
BMBT block allocation). 

So from this perspective, I think the fix needs to be made to the
calculation in xfs_alloc_min_freelist() to take into account minleft
needing a larger AGFL reservation if any of the allocations in the
chain splits.

Hmmmm. I'm not sure the calculation in xfs_alloc_min_freelist() is
correct, either:

        /*
         * For a btree shorter than the maximum height, the worst case is that
         * every level gets split and a new level is added, then while inserting
         * another entry to refill the AGFL, every level under the old root gets
         * split again. This is:
         *
         *   (full height split reservation) + (AGFL refill split height)
         * = (current height + 1) + (current height - 1)
         * = (new height) + (new height - 2)
         * = 2 * new height - 2

i.e. I think the AGFL refill split height is wrong.

Look at it this way: we do the AGFL refill -first-, so if that
splits, we consume (current height + 1) blocks, and then new_height
= (current height + 1). Then if the actual data allocation does a
full split again (i.e. all except for the root block), that needs
(new_height -1) blocks. So that becomes:

	new_height = current height + 1;
	blocks = new_height + (new_height - 1)
	       = 2 * new_height - 1.

IOWs, I think there's an existing off-by one in the AGFL btree block
reservation calculation that contributes to this problem as well.

Put these two things together:

	/*
	 * if minleft is set, we are going to do multiple * allocations in this
	 * transaction (e.g. inode chunk followed by inobt). Hence
	 * we need to make sure we have enough space for fixing up
	 * the freelists after the split as the btree level
	 * increases the AGFL reservation size mid-transaction. If
	 * we are close to ENOSPC, this AGFL reservation increase may
	 * trigger ENOSPC from the subsequent allocation attempt,
	 * and then we shutdown the filesystem. Hence if minleft is
	 * set, reserve enough AGFL space for a potential split
	 * during the allocation chain in this transaction up front.
	 */
	split_space = 1;
	if (minleft)
		split_space = 2;

        /* space needed by-bno freespace btree */
        min_free = min(bno_level + split_space, mp->m_alloc_maxlevels) * 2 - 1;
        /* space needed by-size freespace btree */
        min_free += min(cnt_level + split_space, mp->m_alloc_maxlevels) * 2 - 1;
        /* space needed reverse mapping used space btree */
        if (xfs_has_rmapbt(mp))
                min_free += min(rmap_level + split_space, mp->m_rmap_maxlevels) * 2 - 1;
        return min_free;

This is all off the top of my head, I haven't verified it so it'll
need checking. However, I think handling this situation generically
in the allocator is a better solution than trying to work around it
with caller-based minleft heuristics.

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org
