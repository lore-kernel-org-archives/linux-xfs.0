Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40442E8E6;
	Mon, 21 Sep 2026 08:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977991; cv=none; b=Dz/wTfPzwihvVERSs3NtvUOayMYe2+SSwULWH452RbrSeUU9OJV9evo/OY75VAjmRgUAHZqMFA6bXciwGb1kApu0Pkx96WlUXqD1qd8D49sUaI1wCg99TSlY276dg7pcThe6t99ZOIvwSeeMlivA9QO78B2ZN46hU9acae64n20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977991; c=relaxed/simple;
	bh=WIQrpDCCx3ENMjfWsa2SNZRhsesCGAy+ijQXVKqbrF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3Woo1pmouK5t93u3OvSkZMFCtB/n24+lvWckIfYizO/nxSpjCtFgl4zMeO7TdmSovS1YSLfv1YC6xvOr7DKkv5RzSjxVxV9tUQBgzxLaRmJ17LRjPfEXgFOT5FCf2PlYqjYaFsNZaEsPmME122vt0SDlYTmwsecbsIC4GE9b48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PB/bRjpv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V3j/k6IB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RRb2nd6M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aGB9y2oj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PB/bRjpv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V3j/k6IB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RRb2nd6M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aGB9y2oj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA8D41F451;
	Mon, 21 Sep 2026 08:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789977982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=PB/bRjpvJulpMdcPRExe+EJrOHfb6btWjlhBoZk7iWU9ygSQ+g/5WA5amnvwprOwnlwXXw
	EA/3rzmME5ET5buBn861pP1ESrArwKqPG7ej4rC1HyPCTMTYBz7f48CM59hgmKqkEyREGc
	6gMoPz9GLNTsMNTpyYw1MsgIwwOcfR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789977982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=V3j/k6IBn+5rsUvHZcFjg+3NawNmj0iSoJXk82U00+Fb+GuxMLtdXNPlzny5VpIJxe3ZQE
	ujeTKXag2xZwoVAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRb2nd6M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aGB9y2oj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789977978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=RRb2nd6M2AGjT42rjUtZoUh1VyDCbhS8pu6t0KkTSVZNIU8KYd0jrVwPbWDHqMucUo/ka8
	y/ApUCmx+ZuvoWciuyp6yj9+0yS+7yyn5w2mRqWDQyD5gpDqqmU1a/KsbCvlatKAVLBc18
	KoygRWcj7w2kkvNSXkBcC4XgteWaXIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789977978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w6xQTiJC4A3BGG4SAmqxQEE2oUyi9a4MKJpUqTuQ2l8=;
	b=aGB9y2ojkxPjjVQd6mLGf/SLxxr0G+9/jjD84hyJ4gRVKOseXAWCqs6ctxKaYBs2Cj58iA
	GSZMb3vtMORvRKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A3761368D;
	Mon, 21 Sep 2026 08:06:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugHVGXrlsGr4GQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 08:06:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 10B47A13D5; Mon, 21 Sep 2026 10:06:14 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:06:14 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, akpm@linux-foundation.org, 
	David Hildenbrand <david@kernel.org>, Boris Burkov <boris@bur.io>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <5kirwmtqsf2pjoknqjlnsognhdukv42w65drtqsiigf4hoki2u@kmecm2oqgdqk>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <ap6LFvuOuWf_BkGi@thinkstation>
 <aqrDfoFFr8o0Mf0G@casper.infradead.org>
 <aqrJAX6nMTIo6Vnn@thinkstation>
 <aqrPobWbuOdsCnMc@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqrPobWbuOdsCnMc@casper.infradead.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: BA8D41F451
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLuei44pbx3j4kuwi484771zm8)];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

On Wed 16-09-26 18:19:29, Matthew Wilcox wrote:
> On Wed, Sep 16, 2026 at 06:09:17PM +0100, Kiryl Shutsemau wrote:
> > On Wed, Sep 16, 2026 at 05:27:42PM +0100, Matthew Wilcox wrote:
> > > On Mon, Sep 07, 2026 at 11:15:15AM +0100, Kiryl Shutsemau wrote:
> > > > My proposal makes the distinction between making the folio writable and
> > > > making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
> > > > on the filesystem side to track dirty state and drive writeback for the
> > > > *folio*, while ->dirty_folio_range() marks part of the folio dirty.
> > > 
> > > Why do you think that's a meaningful distinction?  We create a writable
> > > PTE because we've taken a page fault for write.  There's probably a few
> > > naoseconds where the PTE is writable+clean before it becomes
> > > writable+dirty, but even then sometimes we do both pte_mkwrite() and
> > > pte_mkdirty() as an optimisation in the write fault path.
> > 
> > This is true for the PTE that the fault was for. But we don't necessarily
> > want to dirty the other 511 pages at the same time.
> > 
> > The basic idea is to make the whole folio writable at fault and shift
> > dirtying to be per-PTE on write to it.
> 
> Hmm.  Is that something that filesystem people want?  I suspect not.
> I think they'd prefer to be told when we write-fault on each page.
> But let's see if we can gather feedback from FS people.

Well, learning about write-fault of each page is certainly a simpler model
for filesystems to deal with. What Kirill currently does is that the fs
learns about write-fault of the whole folio (so it prepares space for it)
but then dirtying happens only for some pages (so under the rest of the
folio just remain unwritten extents / delalloc reservations). Filesystems
can accommodate that although it will currently somewhat upset ext4's
delayed allocation reservation system. We will have there unreclaimable
in-memory extents tracking these reservations and on inode eviction we'll
complain they were never used.

What might get ugly with current Kirill's approach is if some simpler
filesystem doesn't have a concept of unwritten extents and delayed
allocation (like old ext2 or vfat) but still allocates blocks in
.page_mkwrite to make sure we don't hit ENOSPC / EDQUOT during writeback.
Then it implicitely relies on current MM behavior of calling .page_mkwrite
only on pages that cannot be evicted without writeback - if the eviction
happens, we've just exposed uninitialized on disk data. In fact this is
what would happen with current ext4 when you turn off delalloc and have old
indirect-block based inode format, except that ext4 is careful enough to
dirty all the buffers underlying the folio (and the folio itself) on its
own so there's no data exposure, we just loose Kirill's optimization.

So overall I don't find unsolvable issues with this but it will certainly
require some tweaking on fs side.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
