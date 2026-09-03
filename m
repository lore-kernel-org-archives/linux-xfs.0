Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80379397347;
	Thu,  3 Sep 2026 19:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788465364; cv=none; b=JZq03noHcCD1KyToB9gX1Uw9f7RjKAcWwA2FiSpvZpkL+FU70NvY4HxeGmqgn4RJzyILDheiouz3/07ZCMLxIm9twM67kd9TDanAKSiiBl5vTGicLKmtzOYGSMse3TQCtZ3V+KJxCIgjpqHpNr5SR1KQY7TC3ydrYvifLhvItpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788465364; c=relaxed/simple;
	bh=TgZZTTsZ6LqLUJkBT2c3k6hBKBn+yENi4da+hBRAVns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4AWQA+uBBnop2eedxR9nP7G4qRC0rxEGISx4XCP+7BlPCsivNT6iSi7DLzLJl8G6VSNVBVICYgq/AprhiqqM3pTpWlrjBPBtl6hXZMtkFvgtapndbs7ZQEOmQi29JWGm+n8EHIxwrw3G2c0g7TcAjFQS6ooNoUaCyx+3ACfoEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RTa9IYvW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CFg+9dYm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZZOpl9GX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SsuNNNEm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RTa9IYvW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CFg+9dYm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZZOpl9GX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SsuNNNEm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B310E22237;
	Thu,  3 Sep 2026 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788465343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=RTa9IYvWr7tGW2jZp+DEqsmOO4wo0p/zNOm3E98Fy7mcLnp1qoUJNo55E4KsNRznO+7ijg
	dMHsKqHVOGT49LMRn4yu1Ady01BVijv4bw7yRmLlRPUpxFhaF5H+QH+Z5ahgeSAaK2cpcv
	u2W8X+m7BwxK6s5yBJvSj7G4q0JVbCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788465343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=CFg+9dYmO96Hwaqod/zU66rVwAo5M4L0rNh7WS5r0GuLh/E1yZyKisoB6G7bArc8F3soPB
	fHjfdfnue0iR7yBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788465339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=ZZOpl9GXzWFguyRkJIL9k5Y/7whPO2Adk5/8ftBff3g+LhDqNJL6FiYqe084lCTI9uUBZL
	3IL0j5aYKlppzTTIRHWeG8yzuIam2xdSK56wfSPaFyJ9wFjOLlK3eqIcs9WWGTYRipDO8i
	AEWREz/4pNR0KEn80gfWpTowRheQWJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788465339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/Erzy3qipSog21XmSRx+P/p00l6BX/qJZPWZvzZbSI=;
	b=SsuNNNEmrr8o/kFytiLZzYYkZwBlE7YGMXNxL4Nxp7YKsR0qgS9kW+527BbOfaO83Tv21q
	16E6Z8iUVnnyVdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFF23136D9;
	Thu,  3 Sep 2026 19:55:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XGgBN7nQmWoHVgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 03 Sep 2026 19:55:37 +0000
Date: Thu, 3 Sep 2026 20:55:36 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <apnO6MyHhCilamqJ@pedro-suse.lan>
References: <20260903182943.662461-1-kirill@shutemov.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On Thu, Sep 03, 2026 at 07:29:38PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 

Hmm, I believe Willy already had some patches; I don't know what came of
them (I think he's out for now).

> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.

Help me out here: in which case does this happen? page fault handling is a
mess... I think page_mkwrite is always called, no? in do_shared_fault().

> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().

I think this goes against what we're trying to pull off. We want a single
method of dirtying folios, not 3.

Ideally(tm) we would have a single mkwrite interface.

> 
> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.

But the effects are definitely nice though :)

> 
> Not addressed here:
> 
>  - Dirty accounting stays folio-granular. A 4K store still counts as 2M
>    against dirty_ratio and balance_dirty_pages().

That is correct; I don't think doing subpage accounting makes any sense,
the whole folio is still dirty, and for reclaim purposes can't be thrown
away (unless you added gnarly split logic for file folios as well).

>  - iomap_page_mkwrite() still allocates blocks for the whole folio.
>  - Filesystems without per-block dirty state see no change.
> 
> Kiryl Shutsemau (Meta) (5):
>   mm: let folio_mkclean() report which pages had dirty PTEs
>   mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
>   mm: keep the mmap dirty range down to the faulting page
>   iomap: narrow page_mkwrite() dirtying to the faulting page
>   xfs: track mmap dirty state per block
> 
>  fs/iomap/buffered-io.c | 37 +++++++++++++-----
>  fs/xfs/xfs_aops.c      |  2 +-
>  include/linux/fs.h     |  3 ++
>  include/linux/iomap.h  |  2 +
>  include/linux/mm.h     |  1 +
>  include/linux/rmap.h   |  7 ++++
>  mm/memory.c            | 58 ++++++++++++++++++++++++++--
>  mm/page-writeback.c    | 87 +++++++++++++++++++++++++++++++++++++++---
>  mm/rmap.c              | 56 +++++++++++++++++++++------
>  9 files changed, 222 insertions(+), 31 deletions(-)
> 
> 
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> -- 
> 2.54.0
> 

-- 
Pedro
