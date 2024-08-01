Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F36F1CA81
	for <linux-xfs@vger.kernel.org>; Thu,  1 Aug 2024 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722473590; cv=none; b=dCjtNosbgf714cJvOe8c65BMiQ+45QbrhRHmO0fEBMDOUtZWsQ55UaeL6jCvLYmftCBn2z7Nprm948fN7an10t+aJPPxQ4mSPeuy08Vpupo3kxtnS47O/R6zbOufnZ+9SXY+NWuL/ErGzLqsSB1CKwyvABkl/f95EfbrKjhhGNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722473590; c=relaxed/simple;
	bh=azrN0GyOsnA070IZBYhZpQFm9NOfqeYTgEsQ/WoC2lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dz5ukD5pEvnl3LXgXqQs5yQf29D2GFJAXBobGXjjt5kWGqxZLa6ZN9jGQGuKaDfvVDY0MXJxN49WZtjpFz/Npl7ae3do24Tor6hzRIdkkqBjHFG59bcl0CD7nczBl12pgk9TjYdhJqI2rIg/2C9DfsYrxbPOZ0RRMp79LVSZeYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=v8+mVOyv; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="v8+mVOyv"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5d5d077c60aso3028749eaf.1
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 17:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722473587; x=1723078387; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQRu+si4LvmG42knnLIQ2qJPed18E+8LNhr9Ck/uX3I=;
        b=v8+mVOyvuLH1+mqDsmbKLsS8EjwIe3Pe3ByRUUzzKNaN3mCP0oCqQ1kh9pEe/YLBti
         J/YM4MQAb46/b5K9MsSWhS5snRq7FG7g3QAkDmyppoFwRpZ8H0SzVwWRS59Zc2Zi5HjR
         6G54J0jmbUYS7C/S99DvyNYK+Q0FmdL0u43ynPeAOJIyF36JBYq+0n7S0/rG9Ba9eOo4
         Axt07sIbgPKoe8KPPQ0VT5zPMtOqNgQg4EdDb1d6KJ6YMEeeGaNAC5WW3NnVvu0Wa/Cm
         +OhGo4wCeS6roWyH7IETxhnrkEjrPxLGPxaB/qwXNfG7Y/EpQpPio+oD5kKOVwgxNNgA
         iefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722473587; x=1723078387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQRu+si4LvmG42knnLIQ2qJPed18E+8LNhr9Ck/uX3I=;
        b=QQjFBPx9Qk7G8wVHngCgZBX0upKU8XRkdPa2gllnRKUf7qQ+Ypo+KdcoxEOKJdrDkn
         L9A5QqKLdwwM9IUkN/jdKV84G2glGf2D7IEyWbLy6I93tRxaspb8aBDmuqa6fcyflob0
         +ZKr9EJ5tXZFT1CnqynJTfUL1YJZUTC7JcEuBGhq2XTAuWOj/NsYavtNPA+9q53cT9/Y
         6kInIuAiaGMe8pyjxxjR03s5FsjOyTUNwN8lhGIj5RD7S++5S4kyJyF0bKrrLpaNgC4k
         1CDETd40U6Ce5vt6uzcOxZjHjyB+NadVfOOcRFaxmjDRw/uw7JTj4AY9x77MWN3Cfakp
         RY+g==
X-Forwarded-Encrypted: i=1; AJvYcCVVBMjKUb8XatTjGvAtmbqWk1HMR+9Yyp2O3QyGFzAFDMt0P47JhM+loR/xzOKYUwFWk7XzojehX6H//vtga1gGk2LaRmaVS/Rs
X-Gm-Message-State: AOJu0Yz3TyHuhf4w0qfwHEc6hzyVrfIkt0yJ94r47vCViImDOUL7XzR5
	BqP4q1ed4vt02jDaO77HYzYD674BDSUQG2Ch+9gAyLxxGX3Ey9BEfbKhmrJSvd4=
X-Google-Smtp-Source: AGHT+IGUyg9VCwPqMvv7xfCBTy4E0hs/LkWCfMyTa7G9Nt/rYUhrarcJuUJtnX5Hr4IZ9crpda6irA==
X-Received: by 2002:a05:6870:328c:b0:262:32b0:dede with SMTP id 586e51a60fabf-2687a3b9c71mr1169582fac.7.1722473587244;
        Wed, 31 Jul 2024 17:53:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead712f1asm10514768b3a.61.2024.07.31.17.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 17:53:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZK40-000uSe-0N;
	Thu, 01 Aug 2024 10:53:04 +1000
Date: Thu, 1 Aug 2024 10:53:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <ZqrccEio9/s4LHKU@dread.disaster.area>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
 <ZmuyFCG/jQrrRb6N@dread.disaster.area>
 <20240617234631.GC2044@templeofstupid.com>
 <ZoyeYBW7CvWJdWsu@dread.disaster.area>
 <20240723065125.GA2039@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723065125.GA2039@templeofstupid.com>

On Mon, Jul 22, 2024 at 11:51:25PM -0700, Krister Johansen wrote:
> [ My turn to apologize.  I had a couple of short weeks at the beginning
> of July, but have finally been able to get back to this. ]
> 
> On Tue, Jul 09, 2024 at 12:20:16PM +1000, Dave Chinner wrote:
> > So the worst case AGFL requirement for a data extent allocation or
> > free will be:
> > 
> > 	1. data extent - full free space tree split * 2 + rmapbt
> > 	2. BMBT leaf split - (free space height - 2) * 2 + rmapbt
> > 	3. BMBT node split - (free space height - 2) * 2 + rmapbt
> > 	....
> > 	N. BMBT root split - (free space height - 2) * 2 + rmapbt
> > 
> > So the maximum number of chained allocations is likely going to be
> > something like:
> > 
> > 	(max AGFL for one allocation) +
> > 	((max bmbt/refcountbt height) * (max agfl for dependent allocation))
> > 
> > Which is likely to be in the order of...
> > 
> > > > So I wouldn't expect the AGFL reserve pool to be any larger than a
> > > > couple of hundred blocks in the worst case.
> > 
> > ... this.
> 
> Thanks for the detailed explanation.  It helps.
> 
> I do have a few followup questions on this part.
> 
> What strategy would you recommend we use to calculate the 'rmapbt'
> portion of this equation?  I've defaulted to the same strategy of a
> single full-space rmapbt tree split, plus N (height - 2) splits, but
> instead of using the free space height I used the maxlevel in
> m_rmap_maxlevels.  Does that sound correct to you?

The rmapbt already has space reservations already set aside for it,
and because the rmapbt updates are run in a separate transaction
reservation context (i.e. they are done via deferred ops using
intent chaining), I don't think they need to be considered a
dependent allocation.

i.e. the issue we have right now is multiple allocations within a
single transaction context failing part way through due to not
having enough space to refill the AGFL in the middle of the
transaction. This is typically happening because the rmapbt
reservation is causing the AG to appear empty when it actually still
has lots of space free in it. When the rmapbt update occurs, all
it's allocations and AGFL refills come from that reserved space that
the original allocation was not allowed to dip into.

Hence I don't think that the rmapbt space requirements actually
impact on the data+BMBT dependent allocation chain AGFL space
requirements.

> For trees that are short, like a free-space reservation with a max
> height of 2, this math actually yields a smaller number of blocks than
> the constants it might replace below.  In the case of a b-tree with a
> max height of 2, do we assume then that we'd only need 2 blocks to
> handle the full split, and the remaining dependent allocations would not
> consume any more space as records are added to the tree?  (It sounds like
> yes, but wanted to confirm)

If the max height of the btree is two, then it can only contain a
root block and leaf blocks. Hence once we've gone from a single
block to a root + 2 half full leaf blocks, the rest of the updates
are going to fit in either of the two leaf blocks. So, yes, I think
the math works out in that case, too.

> > <ding!>
> > 
> > Ah, now I get it. It's only taken me 18 years to really understand
> > how this value was originally derived and why it is wrong.
> > 
> > It assumed 4 blocks for the AGFL for the initial allocation to fill
> > and empty AGFL, and then 4 more blocks for the AGFL to allow a
> > refill for the subsequent BMBT block allocation to refill the AGFL.
> > IOWs, it wasn't reserving blocks for the BMBT itself, it was
> > reserving blocks for a second AGFL refill in the allocation chain....
> > 
> > Right, so I think what we need to change is XFS_ALLOCBT_AGFL_RESERVE
> > and xfs_alloc_set_aside() to reflect the worst case size of the free
> > space trees when we hit ENOSPC for user data, not a hard coded 4 + 4.
> > 
> > The worst case free space tree size is going to be single block free
> > records when all the per-ag reservations are at their maximum
> > values. So we need to calculate maximum reservation sizes for the
> > AG, then calculate how many btree blocks that will require to index
> > as single block free space extents, then calculate the hieght of the
> > btrees needs to index that. That gives us out "free space tree
> > height at ENOSPC", and then we can calculate how many AGFL blocks we
> > need at ENOSPC to handle a split of both trees. That value replaces
> > XFS_ALLOCBT_AGFL_RESERVE.
> 
> Just to confirm, this would be
> xfs_btree_compute_maxlevels(mp->m_alloc_mnr, n_perag_resvd_blocks),
> correct?

That sounds correct.

> > Fair summary. this is already long, and I think what I discovered
> > above kinda comes under:
> > 
> > > 4. Implement a less ambitious AGFL reserve
> > 
> > That's what we did back in 2006 - we just carved out the smallest
> > amount of blocks we needed from the free space pool to ensure the
> > failing case worked.
> > 
> > > The draft in this thread tried to track all AGFL blocks from their
> > > allocation and continued to account for them during their lifetime in
> > > the bnobt and cnobt.  Instead of trying to build a reserve for all free
> > > space management blocks that aren't rmapbt, reduce the scope of the AGFL
> > > reserve to be just the number of blocks needed to satsify a single
> > > transaction with multiple allocations that occurs close to an AG's
> > > ENOSPC.
> > 
> > Yes, and that's what I suggest we extend xfs_alloc_set_aside() and
> > mp->m_ag_max_usable to encompass. That way we don't actually need to
> > track anything, the AGs will always have that space available to use
> > because mp->m_ag_max_usable prevents them from being used by
> > anything else.
> > 
> > > Do any of these approaches stand out as clearly better (or worse) to
> > > you?
> > 
> > I think I've convinced myself that we already use option 4 and the
> > accounting just needs extending to reserve the correct amount of
> > blocks...
> 
> I've got something that sets the mp->m_ag_max_usable and
> alloc_set_aside() to the values discussed above.  For demonstration
> purposes, since I was ending up with numbers that were smaller than
> XFS_ALLOCBT_AGFL_RESERVE + 4, I just picked some slightly different math
> that inflated these numbers a bit to validate the assumptions.
> 
> I'm still able to run AG low enough on space to hit the bug with these
> modifcations in place, partly because mp->m_ag_max_usable seems to place
> an upper bound on large contiguous allocations in
> xfs_alloc_space_available().  E.g. if I allocate in small chunks <
> m_ag_max_usable, I can still run pagf_freeblks down to about the per-ag
> reservation.  The test is explicit about only using space from a single
> AG, which defeats the global reservation checks, since enough space
> remains free in the other AGs that we don't hit any of the
> per-filesystem reservation limits.
> 
> It seems like we've got the right general concept, but may need to make
> a few more tweaks to the implementation.
>
> In terms of where to go next, I have a few ideas, but would certainly
> appreciate additional input.
> 
> One was to investigate propagating the per-AG set-aside into
> xfs_alloc_space_available() so that it's only eligible for consumption
> by a dependent allocation.  (Is the correct way to determine that by
> checking tp->t_highest_agno != NULLAGNUMBER?)

Yes, I suspect that we aren't taking into account the correct
set-aside value when checking if the AG has enough space available
for the allocation to proceed. i.e. xfs_alloc_space_available()
isn't getting the reserved space correct - it may be that
xfs_ag_resv_needed() should be taking into account the set aside
amount for XFS_AG_RESV_NONE allocations.

> The other was to determine if I needed add the quantity from
> xfs_alloc_min_freelist(free space height) to the set-aside.  The reason
> for this was that if the reserved free space can be indexed by a tree of
> height 2, then the full split only needs 2 blocks, but once we've split
> to a tree of that height, xfs_alloc_min_freelist() requires 12 blocks
> free (with rmap off) to continue the allocation chain, even if we're
> never going to allocate that many.

Yes, that is definitely -one- of the problems here.

> It's that edge case that these tests
> always manage to hit: run the pagf_freeblks within a block or two of the
> per-ag reservation, and then split a free-space b-tree right before a
> BMBT split.  IOW, I need both the blocks for the b-tree expansion and
> enough to satisfy the xfs_alloc_min_freelist() checks.  If you explained
> this earlier, and I'm reading the equations too pedantically, my
> apologies.

No, I think you're getting deeper into the underlying issues that
we haven't really solved properly as this code has grown organically
to solve corner case issue after corner case issue.

Looking at it, and considering the concept of dependent allocation
chains and reserve pools for different types of allocations I've
previously explained, I think the calculation in
xfs_alloc_min_freelist() is wrong.

That is, xfs_alloc_min_freelist() look sto assume that all AGFL
blocks for a free space modification need to be reserved up front
and placed in the AGFL before we start. Historically speaking, this
was how allocation used to work. Then we introduced intent based
operations for freeing extents in 1998 so the BMBT modifications
were in a separate transaction to the extent freeing. Each now had
their own AGFL refill requirements in completely decoupled
transactions.

Then we added reflink and rmapbt as additional operations that are
decoupled from the BMBT allocations and transactions by intents.
They all run in their own allocation contexts and require their own
independent AGFL fill operations.

However, xfs_alloc_min_freelist() makes the assumption that the AGFL
must be large enough to handle both free space btree and rmapbt
splits for every allocation, even though the space for an rmapbt
split will only ever be needed when running a XFS_AG_RESV_RMAPBT
allocation.  IOWs, it is over-calculating the required AGFL size for
most allocations.

Further, it is calculating this number for every allocation in a
transaction, without taking into account the "dependent allocation
chain" context. This is more difficult to do, because the required
AGFL size only goes down when a full split is done in the chain.

I think we actually need to track the number of blocks we may need
and have consumed for the AGFL within a transaction. We initialise
that in the first transaction and ensure that we have that amount of
space remaining in the AG, and then we always check that the
remaining reservation is greater than the minimum free list size
required for this allocation (it should always be).

Whenever we move blocks to/from the AGFL, we account for that in the
transaction. Hence we have a direct accounting of the AGFL
consumption across dependent allocations within that AG. When we
complete one of the dependent allocations in a chain, we can reduce
the reservation held the transaction by the number of AGFL blocks
reserved but not consumed by that allocation, thereby allowing us to
use more the remaining free space the further through the allocation
chain we get....

IOWs, we need to track the total AGFL reservation/usage within the
AG across the transaction, not just individual allocations. We need
xfs_alloc_min_freelist() to be aware of allocation context and not
reserve RMAPBT space for allocations that aren't modifying the
rmapbt. We need xfs_alloc_space_available() to initialise and use
transaction context based AGFL block reservations for considering
whether there is space available or not. We need to account for AGFL
blocks consumed during an AGFL grow operation.

Lifting the AGFL reservation tracking to the transaction structure
for dependent allocation chains should alleviate these "but we don't
know what happened on the previous allocation" and "what might be
needed for the next allocation" issues. If we do this correctly,
then we should never need to switch AGs during a dependent
allocation chain because the first allocation in an will be rejected
with ENOSPC because there isn't enough space for the dependent chain
to complete....

> I also ran into a bit of a snag in the testing department after merging
> with 673cd885bbbf ("xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs")
> I understand broadly why this is needed, but it does modify when an
> inode converts from extents to b-tree.  I couldn't find a way to disable
> this behavior via mkfs or a mount option for testing purposes.  Are you
> aware of a switch I may have missed?

Just revert it for testing purposes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
