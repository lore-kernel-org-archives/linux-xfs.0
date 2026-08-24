Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B563911C7;
	Mon, 24 Aug 2026 21:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787606880; cv=none; b=hHAMNTxUWdPTfEr3yhaO+iYRg5RtAF+aN9EOtYSjfjT2+j9eEQSqab7llqPPfsQlXv6x/2WwhBO9FPsNyQ/s8RZTlDlMJkbWRfjjfEnNv52I+XTUmDkOlhFH5vxaw6B/2GpBY0fZGl/UKVKvKGbhkbux2wvI9H82aTEUJKsI10Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787606880; c=relaxed/simple;
	bh=yC+Wv7HBRoCXzo7loZ++ZcaEIHA82gt69dbqTBsAme0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQGK02e2oB0RwKEOYmhmj/zx1izU8J2eL/Y7IH5CehSaeR507uP01bJ8uNBHlP6rQ3Rq9V8wZ3ww72Yt6WYldGVNTOBwckvXKwlNKV3H33+LGU9gInxQ3vsZbxLVsA29Qg7FitXEBYBmPhpk42JYjiWnxlkbiCdvUY6oSj++ecg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=TmvqfSW/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=a/bi+feu; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="TmvqfSW/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a/bi+feu"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 6E8C2EC04EF;
	Mon, 24 Aug 2026 17:27:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 24 Aug 2026 17:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1787606877; x=1787693277; bh=eq5n8E8wl0
	gyQwxvErlBbHpGRNVBAbx8V0rwwpNu/V8=; b=TmvqfSW/oL//OTbI/BVMWYFWHk
	/phtGJrF1nVRL5gPwBv3K7229FmUqy/tRjRWqAnFWOzjfFqv1KcLh4xv3ieFgD/y
	w+WhNksRVEkE5VAwPFuYvJSF9mtt+DCrjPVQZyOIZqhWiry8fDV3SvyZKIB4ORkB
	EGxoKdNjdLQ9klpXMT0oeEhSOxaS1khtpUJyMBeqIIrE27is2tsiZHB4EcFg/7N0
	3MFcHy5fQtETo70wi4czm/m1NHyOaScTMsKGPCp92ry7lsRRFqtQOtNWjR/EINsB
	YAUzybZBbjbJ7hIhOPtVXUzKUZ13q/r377lk6lO4td60zlewwT7B7rv25Ucg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787606877; x=1787693277; bh=eq5n8E8wl0gyQwxvErlBbHpGRNVBAbx8V0r
	wwpNu/V8=; b=a/bi+feuoThbSSco9FLu3VH6Iq9UAXx/oL5JAglVy2A2deo5f+k
	uP2lwViM4rNHyTnhjOBxGChv+SeAwKvvmokCPEUdrvP3qRXGvQAdo67Ff7ElcyiG
	DbNycu5zorPwKlk/LGXP2zHNm1lUXyiQx083Nv2sNOg/UnmeVU4KMJGHwI/uNAdY
	PtHBq48Mza05cHb/BxjxYMxaEyFHBP6wRRjO+n5ucFDauh30kFskDhQ8QVKCMYtA
	FSPRBaE4AWL76LhDA81T07KjCNBzfBIDUR+uJOR5PwoK9Wf6vukQPjD5DKGCjjt1
	8qEu/1FVo2Nh4aQDezH3VvPjpYeBoAU8TnQ==
X-ME-Sender: <xms:W7eMai3ylPceQrVWY5iXwhlDUp7OC4-aTcn11JjNf2LKXKO2DLZ6Vw>
    <xme:W7eMakrKmSFMhRwYWAwjHZ8FT8e1t6VrnNR0ZLy-2nb_A-cwKzOlo177wgjLZCZOz
    KCI34qLTD7SBbB9jsdFMGO0t_0d4TTf6GzL67PzIgi1mpzN-P0MN1Y>
X-ME-Received: <xmr:W7eMavMw7QQoazijFzrVpA_xt6ttGuHmT2LPaVar_JPdh8kFrDMCsMRdEg5ETMJbZXooksJEyG5kx7zu4c1KW_IajPM>
X-ME-Proxy-Cause: dmFkZTFbQH54V+ttwf82sKhBlgJAGbLwoiQs8PwPHRJwZdDII33T6XgyYMrgg9uI/w+FXC
    eGzpYGS+ehYXdSfGZnBNxeLMbUDJ/Fw58Jr6skYiTZeMFqbzE+rvL9QpDW3N3EoEZuEb8U
    3csuH6q3LC2pPBx53SjdV37SaBmp0ntx7GjHnQkbbF8MELke2xAhZJsy6DqZoC7gMfjsU7
    8r46bKQDYLobOBnnP2Axy7GGNwK46pYe62wph8/B24HvsOg/BXrQqQT2arLkhOVlH+uwFE
    vd6lLBNmx6MqtemmJ0P1cm/i/ve6GPeVzOwSGCrjtYivYstgToBolzn/l2lFhc8ihyyRs2
    CMh1MHG9VrGN+i27vgbNdARFvloSbad/XqQ+r47iE/s2df9gvMhZ17adn06sX5fmyxGsSP
    IjvMqcxYHk09Doeb62DXrikOPbkvku8awlJ/hlz3Yniddkv5CVzgbGJYNUwUB7xbJpqFhT
    lnyYpJEYDR9CnAhQBL+Yh2E5m80Ga4DoJ6p17gWoke5WNXHS9sVhuxWCust7PKXc25Esy7
    xlnTtxhy2dH01DS1ElpMLLZDH3ptpHX0OtK2XJFM3tGebtwSD7+CcoE4VBMEO1awQXb278
    /V9n5/8t0SUFRUNcgEwJJTFsiu9cBlAJE7KsjTMGfY+2SvDOC7uakAEXcfLA
X-ME-Proxy: <xmx:W7eMamWp3E2gQ95wfBsXgHFNJD98xNF4v_FdTcA-Yp1mhujVTh199g>
    <xmx:W7eMaitv_GgGlPnVFnTMTKSQZekGlnGuqY3RBKkdpXlObAxrRY7W3g>
    <xmx:W7eMah0MNcyBWakR4J4OOgrW6LiuUFJEOeTfIHKh5w7GN_Qn4XKLCQ>
    <xmx:W7eMaj7W-pgrd6JZ5SLX28m1Z9ktbCY-UcR_dDOhLmMBcxx7QvRNvQ>
    <xmx:XbeMat-vLWBU2G_LlOobSUYfwkPYFvs8UUntDC2kVSoljJ3K-vj8oIi0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 17:27:55 -0400 (EDT)
Date: Mon, 24 Aug 2026 14:27:27 -0700
From: Boris Burkov <boris@bur.io>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260824212727.GA3664690@zen.localdomain>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>

On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> 
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
> 
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.

Can you elaborate on this part a bit more? I can't tell if you are
proposing a change or saying the existing behavior is fine if we drop
->dirty_folio(). I am also confused about exactly what sort of folio
dirtying you are referring to. Sorry if I am being obtuse.

When I was recently adding ->dirty_folio() to btrfs, one of the main
cases was the call to folio_mark_dirty() that came via
__iomap_dio_bio_end_io() calling bio_check_pages_dirty() which schedules
bio_dirty_fn(). (i.e., completion of a dio read into a shared mmap)

Is that the case you are referring to here, or are you referring to
someone just modifying a byte they faulted in from a shared mmap? The
latter I would expect to have called page_mkwrite in the fault and done
fs-specific work, so I assume it's the former that you are referring to?

Either way, I do believe that for the dio read endio case pinning is not
involved and btrfs relies on the ->dirty_folio() call, so I think
something would need to be done about that case too.

I believe you saw this patch since it was your idea for us to use
->dirty_folio(), but just for reference for anyone else who didn't see
it, the btrfs patch adding ->dirty_folio():
https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/

Thanks,
Boris

> 
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
> 
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> 
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.
