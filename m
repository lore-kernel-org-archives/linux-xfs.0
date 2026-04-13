Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A328C231C91
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 02:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776048538; cv=none; b=clX8atXu1UXS40msvrz7AvSD5ltEslrv1qzL91RP2ptvt2BsWgytVvmRlW09relnbRBuyCRaeFCHekEebVPQvwrw5NTE7wfWXHi6mY1vOrPEAvY3iASXZVAhrdW0YE2tU8S2JDaCDerZvNKxtfs3LAMwldSBWhEA9YbLkb6Qndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776048538; c=relaxed/simple;
	bh=GU9sO80vUBjZsM8laJC9pwR4fm3BYQs3JcJSOLCk/7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcpWdE2t3Fg/hIrixjejhXCtoEur/T9zOxdCfcS+emQy3faaGeMVRLG7BmDs1r/JKmYprvyn2/Ubv99gNV6k2ub4/aPApx8vQOoim9bDGnzyrnQySLxgGr25pLheZp6R/dL8HKxYYEDWFVjkftDEyIyBua3r1b28MZKz01xKgsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGbX6szt; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGbX6szt"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c287eb77fso3560691c88.1
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 19:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776048536; x=1776653336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGhc1ZIjSeii4I72bV4i7FGsqGrtNAEQe0Mn7Hwob14=;
        b=TGbX6szthSh3QIpI6tz0SejA3fpR8h0lTEPp9CoOJdFYo5ShL73Enx/KLRSAXux+wj
         sCMUagkm2ynLYl5U41pvVtHDKdQUoFKHqUwUigVMT7hlSEoptSRuYCOvtHq4u14QehYN
         zqTNt8hQxqrUTMQ6LBbxBsBeinHQpbqpqRTgP+L+xTCpOvFJVi0pKy0U2WS8wS29ueem
         dnoiYrdq8ya+FunHOY4okyndPl4E1hqu6s9KTdHJcEcsfGD1Vz08GQEN9GjvfEDqXww4
         TXCeFkgqgaz/McNjNJKyu5WGims/NDbEmqt95Z/c1vRcXg/Fe5WifKOTFNuaJS0FS7pO
         oIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776048536; x=1776653336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eGhc1ZIjSeii4I72bV4i7FGsqGrtNAEQe0Mn7Hwob14=;
        b=M8/Ztsq2lqKB4DBdw6VSnGXUYvBGyluoQ69LZsR3KRJmvBBQG7nI4mhsKJcyCQ3KgM
         0nbIwa1vaf3WoIQTwExRo80GKgW4qGzZHlz1ibVl0GMhReawJ1Yikv/AHTXklvxUQwpE
         0SC/IYwVwm7Y1g8x/Rz6Ds5fE0MpXsdvOYydwtg3UTgLT/tTU37KR4YYCelLntgtVGgO
         MLz+eiullU2A9vq2z8kOWSv5B/wcHEx3TwPn2lZWeklQnahSL2OZb9R2VojIg6vEr4Ll
         LyJlUK2rYMhn+lEn2X87zK0TxfGiWbYpCFl3MtgzgQSYJrLndU1p8gl2EYghU+IJrwy2
         v5jw==
X-Forwarded-Encrypted: i=1; AJvYcCX52PegMe+9u7UGfhm3gW9lhYePZjR4DJ4EjEf6cOwDciHTCyKTxMoUb4eXYtGz/iiyMkoiQ8R6O2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQNcvwAcSFVgNmKV3xa19Iw/zS5r9+KKRmY8GnvoyC8u43snhd
	M61Ejbb88PwCj86HrdEugTtZ2XRdestYxQ9wSE9Mnqo7xfw+EQsrQ4JA
X-Gm-Gg: AeBDievNnjis29orQq9QtkrDFLjFhbQG1YWpdivTuho5WHG/eN86uM2+V3Z0mRF2Dby
	v3L0nHy6/L4v8jjPMbh7YlvWouu6wYU55pX2Cp9g2wBozQiiCuJGKdTwM2c1CbQGoh3n9d4rzwU
	vVwqUH5LeDn3rc2TMB9DmL6QqYNvLEpB4keCfBAn9Pkl8i9lNQoLw3Rvhtl8IZcD+wo3a4Z1Y+j
	0yeYSxeXL1g0hOt2iaORaFqpW9WrdhKoY4WxWM/JJsxtzZpcNmAu9d5kDpBf2jM4c39RheOCqPX
	ypuza458j5XZDd4efRXL/Tl7QocE0nV7RoI4Af4iHkeIbR/2vMF3Ztl1VnVmaPPR4zFVOLsf2IN
	S7CJejULVzEvqRcdKj3zbWltuY9LRslev51BvFI+MuFzNp1EpnOesfoqDPISPBfPzv3ux38n45A
	/ICnhiZmlGK2l28WaKlJn7i2mJgeSdQ9BtHgiAo/YrStsCKw==
X-Received: by 2002:a05:7022:faa:b0:127:3915:76b2 with SMTP id a92af1059eb24-12c34f07f1fmr6379082c88.27.1776048535611;
        Sun, 12 Apr 2026 19:48:55 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c34acb077sm11534592c88.6.2026.04.12.19.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 19:48:54 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dgc@kernel.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [XFS] Question: can xfs_agfl_free_finish_item exhaust AGFL during bnobt/cntbt split?
Date: Mon, 13 Apr 2026 10:48:51 +0800
Message-ID: <20260413024852.3506926-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <adw1dY3MZWzTclIS@dread>
References: <adw1dY3MZWzTclIS@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 10:14:45 +1000, dgc@kernel.org wrote:
> On Mon, Apr 13, 2026 at 12:32:50AM +0800, Jinliang Zheng wrote:
> > Hi,
> > 
> > I have a question about the deferred AGFL block freeing path and whether it is
> > safe from AGFL exhaustion during bnobt/cntbt btree splits.
> > 
> > When `xfs_agfl_free_finish_item` runs, it calls:
> > 
> >     xfs_agfl_free_finish_item
> >       -> xfs_free_agfl_block
> >            -> xfs_free_ag_extent   (fs/xfs/libxfs/xfs_alloc.c)
> > 
> > `xfs_free_ag_extent` directly manipulates bnobt and cntbt, and inserting a new
> > free extent record can trigger a btree split. A split will try to allocate a
> > block from the AGFL via `xfs_allocbt_alloc_block` -> `xfs_alloc_get_freelist`.
> > If the AGFL is empty at that point, `xfs_alloc_get_freelist` returns
> > NULLAGBLOCK and the split fails.
> 
> And then the filesystem will shut down because of a fatal error in a
> dirty transaction.
> 
> My first question is this: is this actually happening in practice,
> or is this a theoretical concern?

Thank you for your reply.

Just a theoretical concern. :)

> 
> We don't attempt to provide a 100% guarantee of correctness in free
> space accounting, alloction or freeing algorithms in XFS. Complexity
> is high, and there are lots of corner cases that are extremely
> difficult to reason about. The cost of providing aboslute guarantees
> is ... prohibitive. 
> 
> Hence I'd pretty much guarantee the logic and/or math isn't
> comprehensive or water-tight. We won't try to handle the
> really convoluted "many weird things have to align exactly right"
> corner cases, and instead will use things like reservation pools to
> handle them instead. The AGFL is a good example of a reservation
> pool that we make deep enough to handle real world usage without
> needing to care about the complexities of trying to guarantee
> behaviour in exceedingly rare corner cases.
> 
> For example, we changed the AGFL reservations for the first time in
> 2023 - they were introduced almost 30 years ago (1994), and had
> remained unchanged until then. i.e. commit f63a5b3769ad ("xfs: fix
> internal error from AGFL exhaustion") changed the reservation pool
> to consider two full height splits instead of just one.
> 
> i.e. double allocbt splits of enough height to empty the AGFL pool
> are sufficient rare that it took almost 30 years for a single height
> reservation to be found insufficient in practice.
> 
> With that change, failing to split during the deferred
> AGFL free would now require two full height splits on the rmap
> btree + two full height splits on both the bnobt and cntbt in the
> -same transaction- to exhaust the AGFL, then the very next
> transaction needs to be a deferred AGFL free that requires another
> bnobt or cntbt split to occur. Those conditions are not going to
> occur very often by chance....
> 
> Hence my question: are you actually seeing allocbt splits on
> deferred AGFL frees running out of AGFL blocks in practice, or is
> this a theoretical concern?
> 
> > The normal extent-freeing path (`__xfs_free_extent`) guards against this by
> > calling `xfs_free_extent_fix_freelist` first, which invokes
> > `xfs_alloc_fix_freelist(..., XFS_ALLOC_FLAG_FREEING)` to ensure the AGFL holds
> > at least `xfs_alloc_min_freelist(mp, pag)` blocks before touching the btrees.
> 
> Yes, because the AGFL has not been prepared for the extent freeing
> operation that is about to take place. xfs_alloc_min_freelist()
> makes sure the AGFL is long enough to handle two full allobct
> splits, one of which accounts for a split during AGFL refill/free
> operations.
> 
> > However, `xfs_agfl_free_finish_item` does not call fix_freelist at all.
> 
> Because the AGFL size that xfs_alloc_min_freelist() prepared should
> have already taken this into account. And calling fix_freelist() to
> fixup the free list for freeing a block that was taken from the
> freelist means we now have to consider the possibility of recursive
> freeing fixup accounting problems when AGs are near ENOSPC.
> 
> > The deferred AGFL frees are created by `xfs_alloc_fix_freelist` during its
> > shrink phase: blocks are removed from the AGFL immediately (pagf_flcount is
> > decremented synchronously by `xfs_alloc_get_freelist`), and their actual return
> > to the free space btrees is deferred via `xfs_defer_agfl_block`. After the
> > shrink loop, the AGFL sits at exactly `need` blocks.
> 
> Right, so the deferred free should be the first deferred operation
> in the allocation intent chain. i.e. the generated EFI it will be
> the first intent in the alloc chain processed on transaction commit.
> It should be run before any other pending CUI, RUI and EFI operation
> for that allocation operation will be processed. Hence the AGFL
> should still be in the same state as the initial extent free
> operation left it, and hence should have sufficient remaining blocks
> in the AGFL for a split during the defered AGFL free operation.
> 
> > But before `xfs_agfl_free_finish_item` executes, `xfs_defer_finish_noroll`
> > rolls the transaction. Other deferred operations that execute in between—for
> > example, regular extent frees (`XFS_DEFER_OPS_TYPE_FREE`) that themselves call
> > fix_freelist and may re-shrink the AGFL, or rmapbt operations—could consume
> > AGFL blocks and leave the count below `need` by the time our deferred AGFL free
> > runs.
> 
> Even if we run RUIs, CUIs or other EFIs before the AGFL deferred
> free, they fix up the freelist for their operations first, and that
> reserves space for a deferred AGFL free from the free list.
> 
> If any other extent allocation/free on that AG is run between the
> two transactions (e.g. high level transactions racing on AGF buffer
> access) they will also reserve space in the AGFL for a split during
> a deferred free.

Thank you for the detailed explanation. I have a follow-up question about
the case where fix_freelist shrinks the AGFL by more than one block.

When `xfs_alloc_fix_freelist` shrinks an oversized AGFL, it may call
`xfs_defer_agfl_block` multiple times in a loop, adding N deferred AGFL
free items into the same `xfs_defer_pending` (up to max_items=16 per
pending entry).

In `xfs_defer_finish_noroll`, all N items within that single
`xfs_defer_pending` are processed consecutively in the same rolled
transaction via `list_for_each_safe`, with no intervening fix_freelist
call between them. Each call to `xfs_agfl_free_finish_item` invokes
`xfs_free_ag_extent`, which may trigger a full-height split of both bnobt
and cntbt, consuming up to `(bnobt_levels + 1) + (cntbt_levels + 1)`
AGFL blocks.

The initial fix_freelist leaves the AGFL at exactly `need` blocks. If
the first deferred free triggers a full-height bnobt+cntbt split and
consumes those blocks, the AGFL may already be below `need` — or even
exhausted — by the time the second deferred free runs and needs to split.

Is this scenario considered?

thanks,
Jinliang Zheng

> 
> IOWs, the deferred frees typically always run with a AGFL block
> reservation guaranteed by the previous extent alloc/free operation
> that was just completed. It is a rare situtation where the AGFL
> would not have enough blocks on it to perform allocbt splits
> sucessfully, and to have multiple deferred AGFL frees chained
> together is quite unlikely because of the order of intent
> processing...
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
