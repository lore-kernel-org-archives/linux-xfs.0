Received: from skyblue.cherry.relay.mailchannels.net (skyblue.cherry.relay.mailchannels.net [23.83.223.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A3EF9FE
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726528837; cv=pass; b=MHd8yB2SEyhQISZecx8Fzg2GKPLEEnFTiWbnHGmRjNvGbS2g4xDUyZAqOvtIM3hhLpag7Kw8h67w9/Dejlb72IcCygkCHAvmP63jYIcVkFGW6vNGjR8wE/m1Ta9niZcVxetLQo8OcatDoMX32zbhPkGf/uxwG1tJ4KBaz0tUzqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726528837; c=relaxed/simple;
	bh=t9ZP1FiFXLlFYvPM7MkrQlgqvhUaFYqZXISLo+klK6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XqLZ+Xn+jRoq/ZI7k0NTsWeeJyphwgTVBAD+oVFVNZhOw6ZcIoQpJpWrmFJeaMNujcIckr6jrkdqrFTEHbXAtqv0N3DaqkSMLyaSmBsbL5b1Sp15ea4+2rH/UJN9vaybC+ZYrIpoLEHc4NAp/YIkw/YKZXHkl2hcQylVzBBVugQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=gjMMZwDh; arc=pass smtp.client-ip=23.83.223.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="gjMMZwDh"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EC61A5C6EB1
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 23:01:22 +0000 (UTC)
Received: from pdx1-sub0-mail-a294.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9DEA15C6B88
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 23:01:22 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1726527682; a=rsa-sha256;
	cv=none;
	b=04k/L8JHsf0KZFn6eKCbL6QfvlBJfDpsLL4lDAULHe5WxcSFXN/tD+aPghKjzL5K4eIvs8
	xgq6tXaF0Kj/HLk7t1poQ98688tNqwHE4/+3KHAZFWGLS7Rbw+ledO1sMR3FubCiLFcHyr
	AZsydtLQ25R77ifT54Lq2Bpj2253p+9jnTPNnrfLO5J8AoRHFJxOuCrxb7JoFroe4v72EV
	dLWBMXOXEmK7ABHi0FSBmTPrYQCiUWSzQWZhP0BPgKNOHCPS5F9SINJzXZd5qYi8VA0BJF
	K49kVLiDQJ7OrPRXYCEBZGWDg+XlQi7Wj4980zVcY7hl0GEW2DbBaKiAXkPY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1726527682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKUbI0YXGDBXeWQn5x6b/wad2RcJLJWIroXCN6p5AYE=;
	b=7JIWo2zb/NvHYkSkZaqlvjQEmozbxCIDTIz2HdXJ8LfC05bAWao5d28D9GEdZTjHIt1Fah
	GmSemwtbNGjMIZCiWjDYlUySrBeaVfV3PXhBlZifB6kttgK+Joyplir8lvjuQPhMoKaBy9
	Qd6fhXNBFV4kdytZlkAWXo/qiYERBeTO3NVeVLsIUuwvHRBiaEvSwEWR8QdF8+q+zW1fBQ
	YI7iL8ePi68auzh2Xdi7WPYPmP1T9j/dTwW29GH0ZzlDyNrMMDU+VeIpQjQo+tyy2wMDeX
	ke4aHF08bu568niX9PIcl9FLhNhAuFdpX0hRde4koaiH2TAvdoTI9fa6yOnCdA==
ARC-Authentication-Results: i=1;
	rspamd-b5ccff48b-bzk5b;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Eight-Inform: 2e4395123a0b6015_1726527682863_2326413011
X-MC-Loop-Signature: 1726527682863:356420220
X-MC-Ingress-Time: 1726527682862
Received: from pdx1-sub0-mail-a294.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.106.198.189 (trex/7.0.2);
	Mon, 16 Sep 2024 23:01:22 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a294.dreamhost.com (Postfix) with ESMTPSA id 4X70lQ2lm4zyQ
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 16:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1726527682;
	bh=UKUbI0YXGDBXeWQn5x6b/wad2RcJLJWIroXCN6p5AYE=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=gjMMZwDh8NmyBzQc1ANpRS6Y4HoOk9F+pb1u20EnUFu7ls79ZTJjHukaOYfdmBj7R
	 cdqc9OYRdPsTYMUoCfwU5jrHsgTV2ptFHL3rGKN8UCckv67XXCpdRUWQ4x3zQDPP/u
	 OF5wFBj0jGB6vSxaq4VKzQrJIbAgSn1m1/AOd6e/RE4wcyh5KvYEAUClUu/SWEFp0Q
	 kgrFqSvy1yUiropQRpA/woBxZbozCnOW4zCeVGHbdWmAEuCo6PW3MpmAhImjEO7Efi
	 PmmIP7oUhUO1O5M4Ju17wpY0bpJ2IDg8hnWarQHPCDB1uMaGZ1QMoYieoo00TGPwyw
	 8KmzV/MT4s2wg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e01cd
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Mon, 16 Sep 2024 16:01:20 -0700
Date: Mon, 16 Sep 2024 16:01:20 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <20240916230120.GA1899@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
 <ZmuyFCG/jQrrRb6N@dread.disaster.area>
 <20240617234631.GC2044@templeofstupid.com>
 <ZoyeYBW7CvWJdWsu@dread.disaster.area>
 <20240723065125.GA2039@templeofstupid.com>
 <ZqrccEio9/s4LHKU@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqrccEio9/s4LHKU@dread.disaster.area>

On Thu, Aug 01, 2024 at 10:53:04AM +1000, Dave Chinner wrote:
> On Mon, Jul 22, 2024 at 11:51:25PM -0700, Krister Johansen wrote:
> > I've got something that sets the mp->m_ag_max_usable and
> > alloc_set_aside() to the values discussed above.  For demonstration
> > purposes, since I was ending up with numbers that were smaller than
> > XFS_ALLOCBT_AGFL_RESERVE + 4, I just picked some slightly different math
> > that inflated these numbers a bit to validate the assumptions.
> > 
> > I'm still able to run AG low enough on space to hit the bug with these
> > modifcations in place, partly because mp->m_ag_max_usable seems to place
> > an upper bound on large contiguous allocations in
> > xfs_alloc_space_available().  E.g. if I allocate in small chunks <
> > m_ag_max_usable, I can still run pagf_freeblks down to about the per-ag
> > reservation.  The test is explicit about only using space from a single
> > AG, which defeats the global reservation checks, since enough space
> > remains free in the other AGs that we don't hit any of the
> > per-filesystem reservation limits.
> > 
> > It seems like we've got the right general concept, but may need to make
> > a few more tweaks to the implementation.
> >
> > In terms of where to go next, I have a few ideas, but would certainly
> > appreciate additional input.
> > 
> > One was to investigate propagating the per-AG set-aside into
> > xfs_alloc_space_available() so that it's only eligible for consumption
> > by a dependent allocation.  (Is the correct way to determine that by
> > checking tp->t_highest_agno != NULLAGNUMBER?)
> 
> Yes, I suspect that we aren't taking into account the correct
> set-aside value when checking if the AG has enough space available
> for the allocation to proceed. i.e. xfs_alloc_space_available()
> isn't getting the reserved space correct - it may be that
> xfs_ag_resv_needed() should be taking into account the set aside
> amount for XFS_AG_RESV_NONE allocations.
> 
> > The other was to determine if I needed add the quantity from
> > xfs_alloc_min_freelist(free space height) to the set-aside.  The reason
> > for this was that if the reserved free space can be indexed by a tree of
> > height 2, then the full split only needs 2 blocks, but once we've split
> > to a tree of that height, xfs_alloc_min_freelist() requires 12 blocks
> > free (with rmap off) to continue the allocation chain, even if we're
> > never going to allocate that many.
> 
> Yes, that is definitely -one- of the problems here.
> 
> > It's that edge case that these tests
> > always manage to hit: run the pagf_freeblks within a block or two of the
> > per-ag reservation, and then split a free-space b-tree right before a
> > BMBT split.  IOW, I need both the blocks for the b-tree expansion and
> > enough to satisfy the xfs_alloc_min_freelist() checks.  If you explained
> > this earlier, and I'm reading the equations too pedantically, my
> > apologies.
> 
> No, I think you're getting deeper into the underlying issues that
> we haven't really solved properly as this code has grown organically
> to solve corner case issue after corner case issue.
> 
> Looking at it, and considering the concept of dependent allocation
> chains and reserve pools for different types of allocations I've
> previously explained, I think the calculation in
> xfs_alloc_min_freelist() is wrong.
> 
> That is, xfs_alloc_min_freelist() looks to assume that all AGFL
> blocks for a free space modification need to be reserved up front
> and placed in the AGFL before we start. Historically speaking, this
> was how allocation used to work. Then we introduced intent based
> operations for freeing extents in 1998 so the BMBT modifications
> were in a separate transaction to the extent freeing. Each now had
> their own AGFL refill requirements in completely decoupled
> transactions.
> 
> Then we added reflink and rmapbt as additional operations that are
> decoupled from the BMBT allocations and transactions by intents.
> They all run in their own allocation contexts and require their own
> independent AGFL fill operations.
> 
> However, xfs_alloc_min_freelist() makes the assumption that the AGFL
> must be large enough to handle both free space btree and rmapbt
> splits for every allocation, even though the space for an rmapbt
> split will only ever be needed when running a XFS_AG_RESV_RMAPBT
> allocation.  IOWs, it is over-calculating the required AGFL size for
> most allocations.
> 
> Further, it is calculating this number for every allocation in a
> transaction, without taking into account the "dependent allocation
> chain" context. This is more difficult to do, because the required
> AGFL size only goes down when a full split is done in the chain.
> 
> I think we actually need to track the number of blocks we may need
> and have consumed for the AGFL within a transaction. We initialise
> that in the first transaction and ensure that we have that amount of
> space remaining in the AG, and then we always check that the
> remaining reservation is greater than the minimum free list size
> required for this allocation (it should always be).
> 
> Whenever we move blocks to/from the AGFL, we account for that in the
> transaction. Hence we have a direct accounting of the AGFL
> consumption across dependent allocations within that AG. When we
> complete one of the dependent allocations in a chain, we can reduce
> the reservation held the transaction by the number of AGFL blocks
> reserved but not consumed by that allocation, thereby allowing us to
> use more the remaining free space the further through the allocation
> chain we get....
> 
> IOWs, we need to track the total AGFL reservation/usage within the
> AG across the transaction, not just individual allocations. We need
> xfs_alloc_min_freelist() to be aware of allocation context and not
> reserve RMAPBT space for allocations that aren't modifying the
> rmapbt. We need xfs_alloc_space_available() to initialise and use
> transaction context based AGFL block reservations for considering
> whether there is space available or not. We need to account for AGFL
> blocks consumed during an AGFL grow operation.
> 
> Lifting the AGFL reservation tracking to the transaction structure
> for dependent allocation chains should alleviate these "but we don't
> know what happened on the previous allocation" and "what might be
> needed for the next allocation" issues. If we do this correctly,
> then we should never need to switch AGs during a dependent
> allocation chain because the first allocation in an will be rejected
> with ENOSPC because there isn't enough space for the dependent chain
> to complete....

I like the idea of moving the AGFL reservation tracking into the
transacation, though I'm not certain I understand all the particulars
yet.

In your mental model for how this might work, is the idea that the space
for the AGFL reservation will be added to the transaction once an AG is
selected for the allocations?  Even with this approach, it will still be
necessary to make some worst-case estimates about how much space might
be used in a transaction chain, correct?  E.g. the worst-case AGFL
equations from earlier in this thread still apply, it's just that the
space would be reserved _once_ at the beginning of the first
transaction.

For the rmapbt allocations, it doesn't look like code calls into the
allocator with XFS_AG_RESV_RMAPBT set.  The code that allocates rmapbt
blocks pulls a blocks from the AGFL and then deducts that from its
per-AG reservation.  I tried walking myself through a few examples, but
it looks like it's possible to do an rmap allocation in a dependent
allocation in a transaction even if the first allocation in the chain is
not allocating a rmap record.

To give a specific example: allocating bmbt blocks associate a rmap
entry with the inode for which the bmbt block is being allocated, but
the first allocation may well set XFS_RMAP_OINFO_SKIP_UPDATE, like
xfs_bmap_btalloc does.

It might be possible to use the oinfo in the xfs_alloc_arg structure to
determine if a particular allocation can allocate a rmap entry.
However, it also looks like allocating blocks to refill the AGFL can
itself allocate these blocks.  Is this a situation where we'd need to
audit the different operations and add specific attributes to their
existing xfs_trans_res to account for whether or not they'd allocate
rmap entries? Or is there a better way to do this that I'm overlooking?

Thanks,

-K
