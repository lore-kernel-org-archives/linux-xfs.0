Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9C3DDAF4;
	Tue, 25 Aug 2026 08:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646368; cv=none; b=KfDHwH8apNe9yzKRxAO1AjNEQOgsPGCGHCKOPABGgc2ITw/MTfi54QUIa4OwgnaRSi/O0QSiu87lsW0kXteedE8Zdi6r+ApxpnrY022IwpbxGj6CX4CTx8a4DrP3eM/dHV9wa4JT6nKsWyXxo+x0djc7IRCcAG6bglhqYIACcFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646368; c=relaxed/simple;
	bh=jq0/BN5fBNh7s2ImmzclgEWLpFxzqbJ30gpyp4NPnSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mq7DMPYOoAF7JoFIcCUosMwW8u73RghbNbix107MWtHs8kqHW/fqfKfRy9vKcB2QsI/ik6qbaPpoQMTyb/4D+7BbkAHfcthWTsPFLBaTs/1efAVPSHp/gRH7MlrLc+9hmvXOulXmB8Qd3iTu0InXHvY7DLbM+0wqEGbTo+0ndCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=us4Z6weh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6YnH89Py; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xWsSSuj5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nG04rm6S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="us4Z6weh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6YnH89Py";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xWsSSuj5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nG04rm6S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BE3D1F769;
	Tue, 25 Aug 2026 08:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787646360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=us4Z6wehV1zJOnbgd+wLk9dBc+b+Lhebd9tctl1a2i+5C6CyWPxBUWszlO2YAgz2nDFbZE
	G8CeCsqerh5u5vDwtMKc1LS3COE0W1yPONHrVmq6CY5MFSbG4Z/j/Bv+i7Si0LU3pPh0PI
	4jQqwV8n11YnnzMC6lmOWXBnA3yW4Cc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787646360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=6YnH89PyKzHmLHbEeuuzJ7xzmi/U+DZXYKVdLuHwXpY6O+Z2kXZfZkhKeB1+QH4lKD6pVv
	FlYvKSNgMy1h5yDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWsSSuj5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nG04rm6S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787646356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=xWsSSuj52XuRC9BXOjAbr92F5naYxlTePRPxt5kOvq4/soZrDGT2WWdmMVenPCjY3rdLJx
	DZXPYQCqbsCU8K5h/57YnVVNLKCbBo5LbuP2Lr3XBwMC7el0J/PtUEsCx+rVCvEKsMF5MP
	T/W95s2v1+eJGjsH6RRSoSsVD+gBcIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787646356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=nG04rm6SXjrdYR3jrQs8AQX1hxMpXe0h2YmFm8+pQxihuqd+rNZIXM4h0kS3OXUssyBBTZ
	RKh24vuJnrhUWUBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA8CC13331;
	Tue, 25 Aug 2026 08:25:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hBxAJpNRjWoYDAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Aug 2026 08:25:55 +0000
Date: Tue, 25 Aug 2026 09:25:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao1Lo6TKhPcqV42B@pedro-suse>
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
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 8BE3D1F769
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

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

I don't think you can do this for stable writes. It's probably ok for
!stable writes filesystem stacks, as long as the filesystem & writeback
can handle making no progress at all. But since stable writes' writeback
can't race with "writes", I don't think you can Just Do It as long as the
folio is DMA pinned.

Perhaps we should give up trying to writeback these folios, and start
writeback right after they're unpinned? at least on the stable case.

>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().

This sounds like a problem. You don't want users expecting writeback to make
progress to suddenly stall on e.g folio_wait_writeback() indefinitely.

> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

I don't quite understand what your plan for getting rid of dirty_folio,
et al is. page_mkwrite has the fatal flaw of being directly tied to VM
page faults; I don't think it's the ideal interface for notifying filesystems.
It's also the case that page_mkwrite can trivially sleep, and GUP calls it under
the PTE lock. So how can we replace that? Would callers need to manually dirty
folios after GUP, in process context?

-- 
Pedro
