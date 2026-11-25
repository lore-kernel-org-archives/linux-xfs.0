Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795601749;
	b=wEyY1r6H6+UzX6SkaLnVM4QQNRhl9Ts4Y5pAp/BA3YvDz7uF+uWLk7FMtfGG+7cb56Su
	 hHP3zWVNzYmhvRRNJrYXDYKSkWVhIvZpvOhp3SjHhkr6hepdG5AnyAsELRgx/J6idrZQR
	 /di1iGkzxLBf49ItBT5vk6/SR3a/FglUGOR1jXL03QXFBwoPJ+1RvLKaIwMsoPeS7Wku9
	 f7z02bmY95B8dhXnZwqr6lXZGKJLUVJnylDYdiKYmefW/FArTg2k5Cx2TfgVhsGU80qzc
	 zt4Ftv4vx9VKK6wBdNUOkBM+wRDGNy0aThjQqH+oqSpB+pCwt9SQpaFjqgpxZ/jVvIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795601749;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=gV4MvidqXRVYNfguwkjsi9yDG6npxl+lAGf1l84Yiemx0KhN+hjAQCDI+OAN+tPvLTJo
	 NeVnabe2Dfs1qYYsJZrr7Hyf+F9bHRAOCbzhyeV0WpR1DGl3hcUbCHJHhR1fOD7Dr+vwr
	 gpWO11xcBw0ovQjdXY4OW1msAHYW6iFiCDf4zRLUaZ0yH4ulTvw9ZFZLBNhvEKWyVvkdA
	 KWqOHIsNQoWL6sPFsO/pBROusydFL5GxAFiMEr+KHZp8D1J+4a8UMgYHZzb30n+A8oVbl
	 XFcvKWmfiY17URtWt7dDsO32KyipMigcfi847vp/iWgZA5OROyjO49S6605exGrzrkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z06kVsav;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YAvQYBkQ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HhT85ONG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="vX/h8QqE";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6093E606A323;
	Wed, 25 Nov 2026 10:15:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6093E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z06kVsav;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YAvQYBkQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HhT85ONG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vX/h8QqE
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2EA141F7AB;
	Wed, 25 Nov 2026 10:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795601742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=Z06kVsavmP7JScicGhz4PLwxBu3Dex4qiFvXFQcw6hiBXSgAPrY31rGsLOeD8I/afpGxWJ
	QqvbieM8a3SnCpA7Y6NvO/lh3yjke/TCCdWF5sXAa71+xF7URX+YmX/guYIaETRth2VdQ8
	X+SZ14rjsBbQF8ej4TrovKNBc078KcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795601742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=YAvQYBkQHWlLyq/pc6sxjMqrMqDGJezvFVbuvPSz/Ar7h1bOwCSdmBMoEZ2smb9B8M8JBC
	ODHaG9GFSZ3kR0AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795601741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=HhT85ONGGnzQc8EzNUw9bIL19KxpV6xykb0gpdQl0kCw8mIPbOdunsyJcQSXg0b1GormL1
	lRw59Xh0TSaLua+iR8MJPm0XaefZaMjMOcSx3P3W3vJ6YYGgrJvJhcKtoZt0fzweZQ+Faz
	rUqtUBs61FQpsWJiUV2N90/xs5lEjHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795601741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=vX/h8QqEnMmoIVMqKy2xoZTwAcXtH8GK1fsnluYevvaejjH6oEbpgTXu0WSyCAsOPElHfr
	3Mo54VbDLlNzkbBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2408134CA;
	Wed, 25 Nov 2026 10:15:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gu3dMky1BmtxWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 10:15:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7F82427BF7; Wed, 25 Nov 2026 11:15:40 +0100 (CET)
Date: Wed, 25 Nov 2026 11:15:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
 <20260826050733.GB15122@lst.de>
 <20261125085814.GA24887@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125085814.GA24887@lst.de>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Wed 25-11-26 09:58:14, Christoph Hellwig wrote:
> Bringing this back as we're having another slightly discussion of
> GUP semantics right now and this discussion stopped before it really
> started.
> 
> Any comments on my idea in here?  If someone on the mm side could
> come up with a way to figure out if a folio is pinned longterm or
> not and we get a pre-pin method into the fs I could start looking
> into the fs and writeback side of this.

I think we agree regarding the direction where this should be going :).
Regarding the tracking of longterm pins, I remember when we started working
of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
to take pinned pages off the LRU (they cannot be freed anyway) and use that
space in struct folio for the tracking we need. John? even had patches for
that but the performance overhead was too big (primarily due to LRU locks
contention) for direct IO. But for longterm pins, the additional overhead
of the setup could be acceptable and that would significantly increase our
maneuvering space in what we can do (because longterm pins are yet another
page refcount in the end).

								Honza
> 
> On Wed, Aug 26, 2026 at 07:07:33AM +0200, Christoph Hellwig wrote:
> > [adding rdma/hmm folks]
> > 
> > On Tue, Aug 25, 2026 at 08:54:25PM +0100, Matthew Wilcox wrote:
> > > On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > > > The problem is GUP.  We have no way to force the GUP caller to go
> > > > > through page_mkwrite again.  So instead we make the GUP caller call
> > > > > folio_mark_dirty_lock() which many just don't, and generally we get away
> > > > > with it.  But it's a bug, and a bad interface.
> > > > 
> > > > We currently have get_user_pages*() and pin_user_pages*(), where only
> > > > the pin_*() version is properly usable for write access, right? And
> > > > dropping such pins should always go through unpin_*() helpers?
> > > 
> > > Right.  I'm stuffing cheese into my ears and pretending that people
> > > aren't calling get_user_pages() to do write accesses.  We should be
> > > able to use this work to flush out the last remaining ones -- we
> > > can put in various assertions that folios should still be dirty where
> > > we currently have folio_mark_dirty() calls.
> > 
> > Last time I checked quite a few places still did.  Including various
> > network file system O_DIRECT implementations (some got fixed, and
> > for NFS a series is outstanding) and some really odd looking networking
> > code.
> > 
> > I wish we could somehow force them to stop doing that, but I can't
> > think of any. 
> > 
> > > Yes.  I think the only alternative would be storing a checksum of the
> > > contents of the folio and seeing if it changed since the last write.
> > > As you say, this is userspace doing something incredibly odd (I really
> > > don't think people make a habit of mmap()ing files shared writable and
> > > then giving RDMA longterm write accesses to them.  Not on machines with
> > > poor quality flash storage anyway).
> > > 
> > > Or we could say "these pages only get written back on requested fsync()
> > > rather than periodically".
> > 
> > Take one step back.  For regular pins we should be able to just wait for
> > them given that they are by definition short lived, where short lived
> > is defined by typical I/O latency for a wide range of "typical".
> > We'll need the right helpers from the MM for that, and make sure
> > we have a good way to debug file system hangs caused by incorrect
> > use of the pinning, but all that is a solvable problem.
> > Splitting read vs write pincounts would be really helpful to reduce
> > the overhead of that.
> > 
> > The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
> > longer time.  And that also means IFF the user of FOLL_LONGTERM actually
> > wants to be able to persist data on a shared mmap, it has to manually
> > dirty folios one or more times during the FOLL_LONGTERM pin, because
> > otherwise the file system would never know there is dirty data.
> > The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
> > for that.
> > 
> > So what we'll need is:
> > 
> >  - a way for the file system to know if a dma pin on a folio is for a
> >    short-term writable pin vs everything else.
> >  - for the short term writable pin wait for it for data integrity syncs,
> >    or otherwise just skip it.
> >  - for FOLL_LONGTERM users we need an interface to (re-dirty) folios
> >    while the long term pin persists.  This also needs a way for the
> >    file system to reserve space.  Either as a rolling / bank switched
> >    reservation for the whole life time of the mapping (although for
> >    large mappings this might use up a lot of space), or to do that
> >    ahead of whatever triggers the dirtying.
> >    And maybe a way for file systems (or vm ops) to reject long
> >    term writable pins if they don't want to deal with all this.
> ---end quoted text---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
