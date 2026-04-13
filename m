Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95E6346AE8
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776118762; cv=none; b=k0QvjKtNjRgCyjXlApG1iQpxjIvtkpThN1uzuT2oWIh48kNQOCwdVPG6NlTwVjfSJ3rW1Nbk+CYrRDLZ5X3DxzPfF2zigsMmSLVyZcgRf/eFCV3p6DmKQtqShkaeA8Ct/u5i4OnKw+goOADqxL0rojDzjyLjWB5m6eUdQwbwVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776118762; c=relaxed/simple;
	bh=mn5Nie46b7EiSBlO8RAue0pw4yXGG85ddyUQnniBPd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/sH4niaQG8B/YDWkR6vjT01cqto/CeNVjkZgs+vZL5okD58ifuRno0yGDurd+wzT3WtMqhcSWfNkT/lQ8lEpU9JEwtVMWLnul9GIqJOItjgDBH+8P1XOaIkdS+dYu//eDZBqxaSpAycScyrs/y3DNrJ9edg8tKM8KcN27BwIg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHlc6bkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHlc6bkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EF1C2BCB5;
	Mon, 13 Apr 2026 22:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776118762;
	bh=mn5Nie46b7EiSBlO8RAue0pw4yXGG85ddyUQnniBPd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rHlc6bkYD6zCkdFNM0l9uKxYG5MaLTF+cX+WBjff6hqX9JQFAhxBpvEpuHiJSF9UC
	 hV3phgoUVRKDNcMcnIQTj5dSXrzxzFu55sEVtVWkF0ox2fuqnV3BalRyE0F1NZIv0J
	 Aylr3jYc6AsFMOmlv1Y6+6+r38zR6g4R9ic6d7G3GJaHv7Ob4Qtk0ByTRaj6XQd6kr
	 v+Qs2mwB65uV9ZM6aI7icKnkedS7WWbfR6IPwzsRkDf/A8K9ftDZpXGXuRzLGh8vP2
	 erHkvJ0It6V3X34w2iLpp8nEX/eLLy2YjLc6L95SNrG3lhfaucEmXr/AJTHe2GEJ9a
	 iSrw10aVvqq9Q==
Date: Tue, 14 Apr 2026 08:19:01 +1000
From: Dave Chinner <dgc@kernel.org>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: alexjlzheng@tencent.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [XFS] Question: can xfs_agfl_free_finish_item exhaust AGFL
 during bnobt/cntbt split?
Message-ID: <ad1r1fm8LjFVxi9_@dread>
References: <adw1dY3MZWzTclIS@dread>
 <20260413024852.3506926-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413024852.3506926-1-alexjlzheng@tencent.com>

On Mon, Apr 13, 2026 at 10:48:51AM +0800, Jinliang Zheng wrote:
> On Mon, 13 Apr 2026 10:14:45 +1000, dgc@kernel.org wrote:
> > On Mon, Apr 13, 2026 at 12:32:50AM +0800, Jinliang Zheng wrote:
> > > But before `xfs_agfl_free_finish_item` executes, `xfs_defer_finish_noroll`
> > > rolls the transaction. Other deferred operations that execute in between—for
> > > example, regular extent frees (`XFS_DEFER_OPS_TYPE_FREE`) that themselves call
> > > fix_freelist and may re-shrink the AGFL, or rmapbt operations—could consume
> > > AGFL blocks and leave the count below `need` by the time our deferred AGFL free
> > > runs.
> > 
> > Even if we run RUIs, CUIs or other EFIs before the AGFL deferred
> > free, they fix up the freelist for their operations first, and that
> > reserves space for a deferred AGFL free from the free list.
> > 
> > If any other extent allocation/free on that AG is run between the
> > two transactions (e.g. high level transactions racing on AGF buffer
> > access) they will also reserve space in the AGFL for a split during
> > a deferred free.
> 
> Thank you for the detailed explanation. I have a follow-up question about
> the case where fix_freelist shrinks the AGFL by more than one block.
> 
> When `xfs_alloc_fix_freelist` shrinks an oversized AGFL, it may call
> `xfs_defer_agfl_block` multiple times in a loop, adding N deferred AGFL
> free items into the same `xfs_defer_pending` (up to max_items=16 per
> pending entry).
> 
> In `xfs_defer_finish_noroll`, all N items within that single
> `xfs_defer_pending` are processed consecutively in the same rolled
> transaction via `list_for_each_safe`, with no intervening fix_freelist
> call between them. Each call to `xfs_agfl_free_finish_item` invokes
> `xfs_free_ag_extent`, which may trigger a full-height split of both bnobt
> and cntbt, consuming up to `(bnobt_levels + 1) + (cntbt_levels + 1)`
> AGFL blocks.
>
> The initial fix_freelist leaves the AGFL at exactly `need` blocks. If
> the first deferred free triggers a full-height bnobt+cntbt split and
> consumes those blocks, the AGFL may already be below `need` — or even
> exhausted — by the time the second deferred free runs and needs to split.
> 
> Is this scenario considered?

I have considered it, yes.

Remember what I said about considering the probability of something
occurring before adding complexity to guarantee it will never
happen.

The above scenario requires both allocbts and the AGFL to be set up
in such a way that it has multiple full subtrees ready to split in
both trees, and that the same block frees (from the AGFL) will
trigger those subtree splits with the same free space record insert.

And the AGFL has to have exactly the right blocks on it *in excess
of what is required* in to get them deferred in the right order to
then trigger these subtree splits.

And this has to happen multiple times in consecutive operations.

Can the above happen? Yes.

Will it happen by chance before the heat death of the universe? Probably.

Will it happen in production workloads?  Not very likely at all.

That's the difference between providing theoretical guarantees vs
practical guarantees.

We can keep playing "but what if we had N+1" type theoretical
scenarios endlessly here, but reality has to step in at some point.
We set reservation sizes for "unbound excursions" at a size that is
large enough for normal operation and largely ignore the cases with
10^(large negative N) probabilites.

If, in practice, we find the reservation pools are getting exhausted
in normal production workloads, then we'll either change the
behaviour that is causing the exhaustion or increase the reservation
pool size to handle that case.

-Dave.

-- 
Dave Chinner
dgc@kernel.org
