Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6077F39
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776039298; cv=none; b=Coz95a+f6uQPHBvIZW7U1nfD7tGR/EP/KDFderVELT516HNMhhMU/IE6spAI+4+ddVMo1e9kr4C+UbTO1TRdJ93QXj4ARlKlP36NMF+moRINLVUJ4IaJrpcwzS/T3W4Cg98E/c+ryJ9wxQAd0viqDAxyl7l9u8aINylqRtLoAa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776039298; c=relaxed/simple;
	bh=bQHG97NvXxmRYe3ADvBJpoklFRaDQu2cYyKZsFQIeVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXdlPm0q4uCtRphOWTC49qcGM5MuS+8SjVzwl6ge4AWBYFzh1r6SFuq6vEp65uQB5WVARu36L2SAQZpgBaJOlhHvL0MOVccEW1U0dTt/or1xRSb0jN8Y5tGFiGRgKsoC/MYV3iDteCaIm5h+JfxwYOH/a6aYGNz+L2UZFwMHKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtKKQYMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtKKQYMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3088C19424;
	Mon, 13 Apr 2026 00:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776039297;
	bh=bQHG97NvXxmRYe3ADvBJpoklFRaDQu2cYyKZsFQIeVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZtKKQYMjXBxp+Ibhpf8xZjX8n8QKVU6KdHyo0oN5591eE66PtM9gy/X5GSSPT7ewp
	 sVdRo6F37CL1u3+PbYiq7qPS0kBvG+nRw7PVp+epllvgqpOg6JDwES3C5zGrmlGczo
	 IrjB2S1vlOVEMf75ODt2cI8WOsL45pLHPQnn8Ip7i1sqn3avfkqY8AvaWt6rKfMwl/
	 vlbLNbThJ8bDgc2MVKCPu+fbMm4Vu1pVTXOm+WrMZ5gfSqkMMNuwO1xEM4TAt1Oiec
	 CuvFZw4lIkXiAXoCpZtGxU90i8BgpqOVan5hnO+xsAY0SZylCE387gM4AnqkFPRyjz
	 GfDz5x5GmsKHQ==
Date: Mon, 13 Apr 2026 10:14:45 +1000
From: Dave Chinner <dgc@kernel.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, alexjlzheng@tencent.com
Subject: Re: [XFS] Question: can xfs_agfl_free_finish_item exhaust AGFL
 during bnobt/cntbt split?
Message-ID: <adw1dY3MZWzTclIS@dread>
References: <20260412163252.3359028-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260412163252.3359028-1-alexjlzheng@tencent.com>

On Mon, Apr 13, 2026 at 12:32:50AM +0800, Jinliang Zheng wrote:
> Hi,
> 
> I have a question about the deferred AGFL block freeing path and whether it is
> safe from AGFL exhaustion during bnobt/cntbt btree splits.
> 
> When `xfs_agfl_free_finish_item` runs, it calls:
> 
>     xfs_agfl_free_finish_item
>       -> xfs_free_agfl_block
>            -> xfs_free_ag_extent   (fs/xfs/libxfs/xfs_alloc.c)
> 
> `xfs_free_ag_extent` directly manipulates bnobt and cntbt, and inserting a new
> free extent record can trigger a btree split. A split will try to allocate a
> block from the AGFL via `xfs_allocbt_alloc_block` -> `xfs_alloc_get_freelist`.
> If the AGFL is empty at that point, `xfs_alloc_get_freelist` returns
> NULLAGBLOCK and the split fails.

And then the filesystem will shut down because of a fatal error in a
dirty transaction.

My first question is this: is this actually happening in practice,
or is this a theoretical concern?

We don't attempt to provide a 100% guarantee of correctness in free
space accounting, alloction or freeing algorithms in XFS. Complexity
is high, and there are lots of corner cases that are extremely
difficult to reason about. The cost of providing aboslute guarantees
is ... prohibitive. 

Hence I'd pretty much guarantee the logic and/or math isn't
comprehensive or water-tight. We won't try to handle the
really convoluted "many weird things have to align exactly right"
corner cases, and instead will use things like reservation pools to
handle them instead. The AGFL is a good example of a reservation
pool that we make deep enough to handle real world usage without
needing to care about the complexities of trying to guarantee
behaviour in exceedingly rare corner cases.

For example, we changed the AGFL reservations for the first time in
2023 - they were introduced almost 30 years ago (1994), and had
remained unchanged until then. i.e. commit f63a5b3769ad ("xfs: fix
internal error from AGFL exhaustion") changed the reservation pool
to consider two full height splits instead of just one.

i.e. double allocbt splits of enough height to empty the AGFL pool
are sufficient rare that it took almost 30 years for a single height
reservation to be found insufficient in practice.

With that change, failing to split during the deferred
AGFL free would now require two full height splits on the rmap
btree + two full height splits on both the bnobt and cntbt in the
-same transaction- to exhaust the AGFL, then the very next
transaction needs to be a deferred AGFL free that requires another
bnobt or cntbt split to occur. Those conditions are not going to
occur very often by chance....

Hence my question: are you actually seeing allocbt splits on
deferred AGFL frees running out of AGFL blocks in practice, or is
this a theoretical concern?

> The normal extent-freeing path (`__xfs_free_extent`) guards against this by
> calling `xfs_free_extent_fix_freelist` first, which invokes
> `xfs_alloc_fix_freelist(..., XFS_ALLOC_FLAG_FREEING)` to ensure the AGFL holds
> at least `xfs_alloc_min_freelist(mp, pag)` blocks before touching the btrees.

Yes, because the AGFL has not been prepared for the extent freeing
operation that is about to take place. xfs_alloc_min_freelist()
makes sure the AGFL is long enough to handle two full allobct
splits, one of which accounts for a split during AGFL refill/free
operations.

> However, `xfs_agfl_free_finish_item` does not call fix_freelist at all.

Because the AGFL size that xfs_alloc_min_freelist() prepared should
have already taken this into account. And calling fix_freelist() to
fixup the free list for freeing a block that was taken from the
freelist means we now have to consider the possibility of recursive
freeing fixup accounting problems when AGs are near ENOSPC.

> The deferred AGFL frees are created by `xfs_alloc_fix_freelist` during its
> shrink phase: blocks are removed from the AGFL immediately (pagf_flcount is
> decremented synchronously by `xfs_alloc_get_freelist`), and their actual return
> to the free space btrees is deferred via `xfs_defer_agfl_block`. After the
> shrink loop, the AGFL sits at exactly `need` blocks.

Right, so the deferred free should be the first deferred operation
in the allocation intent chain. i.e. the generated EFI it will be
the first intent in the alloc chain processed on transaction commit.
It should be run before any other pending CUI, RUI and EFI operation
for that allocation operation will be processed. Hence the AGFL
should still be in the same state as the initial extent free
operation left it, and hence should have sufficient remaining blocks
in the AGFL for a split during the defered AGFL free operation.

> But before `xfs_agfl_free_finish_item` executes, `xfs_defer_finish_noroll`
> rolls the transaction. Other deferred operations that execute in between—for
> example, regular extent frees (`XFS_DEFER_OPS_TYPE_FREE`) that themselves call
> fix_freelist and may re-shrink the AGFL, or rmapbt operations—could consume
> AGFL blocks and leave the count below `need` by the time our deferred AGFL free
> runs.

Even if we run RUIs, CUIs or other EFIs before the AGFL deferred
free, they fix up the freelist for their operations first, and that
reserves space for a deferred AGFL free from the free list.

If any other extent allocation/free on that AG is run between the
two transactions (e.g. high level transactions racing on AGF buffer
access) they will also reserve space in the AGFL for a split during
a deferred free.

IOWs, the deferred frees typically always run with a AGFL block
reservation guaranteed by the previous extent alloc/free operation
that was just completed. It is a rare situtation where the AGFL
would not have enough blocks on it to perform allocbt splits
sucessfully, and to have multiple deferred AGFL frees chained
together is quite unlikely because of the order of intent
processing...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
