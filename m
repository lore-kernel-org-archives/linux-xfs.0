Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA823B9D93
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776852044; cv=none; b=nMTeZ1Y4q1yaiVzxi60dcbekwku45NCj7xif4spVaLYqy4gKjqdJlry5pNJG5R6+k0EoTvj24skKFsACO7Iwai232z0G2iP4wbQc03Z94mNjihmao7uAYL24gBLM31RsSdDSNoZZ+qfgICA3puQ6+hzhNJjngibqwNl//fgvuSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776852044; c=relaxed/simple;
	bh=L8E2MXrnAZeXCYBDrsxFx/d+tr+JEM50upnQQyFy07A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKi2R6nxPOMepk0dcjBanpa9Tacuisti264YRMk763oqTQcayc8gYKbH/ZAKgE8N5CRjfD7fkLpgSHDBVfzU3Oe7FADNLH99f+DUIJr/j3SjlZjG2hVIEasug+Udst0tLCncozEcGw18EeZHd0Px6IT/YGeKQh6RMTvI/J/j2Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SjVLdPKC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=73x/GLVl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SjVLdPKC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=73x/GLVl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SjVLdPKC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="73x/GLVl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SjVLdPKC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="73x/GLVl"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C0E66A81C;
	Wed, 22 Apr 2026 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=SjVLdPKC4/j27kw40iMX2JK0V6VseBXiSUfd+4TOCGS5X4cvfQuuyUD3cNC+z6b3Um5AyW
	FCZuZqGuOg1rhRbIZovbzw1kz3YFyR9YC7nmD/ZBwVuxw9MarF2IWHQP4W5vF5KaNOJWxu
	OttKY/agBQ0jd46ecgnZ+V+I7+eWDkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=73x/GLVljcjJrS9pKrvLri7z3sAmhL189LSOcVyD1SuE3XqkSCGmAngQhgrrIp/b1qDNIg
	Djn5enwMO245HABA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=SjVLdPKC4/j27kw40iMX2JK0V6VseBXiSUfd+4TOCGS5X4cvfQuuyUD3cNC+z6b3Um5AyW
	FCZuZqGuOg1rhRbIZovbzw1kz3YFyR9YC7nmD/ZBwVuxw9MarF2IWHQP4W5vF5KaNOJWxu
	OttKY/agBQ0jd46ecgnZ+V+I7+eWDkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=73x/GLVljcjJrS9pKrvLri7z3sAmhL189LSOcVyD1SuE3XqkSCGmAngQhgrrIp/b1qDNIg
	Djn5enwMO245HABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8291593AF;
	Wed, 22 Apr 2026 10:00:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d6ilOEKc6GkRVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 10:00:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1C59A0B60; Wed, 22 Apr 2026 12:00:34 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:00:34 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <eqbodkjxxg32ryxsdngx35yhv5fy4p44fmvlnlnoyib6bstlmf@4hzxnfwleynb>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
 <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,oracle.com,infradead.org,lst.de,gmail.com,mit.edu,samsung.com,anarazel.de,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 21-04-26 23:37:01, Ojaswin Mujoo wrote:
> On Mon, Apr 20, 2026 at 01:28:18PM +0200, Jan Kara wrote:
> > On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> > > On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > > > +
> > > > > +{
> 
> <...>
> 
> > > your comment but) after this email, I started diggin a bit more into why
> > > it is needed.  As per my understanding, it tackles 2 things:
> > > 
> > > Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> > > allows us to allocate new blocks which previously might not be allocated
> > > if bs < ps.
> > > 
> > > Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> > > old EOF to end of that folio so that readers dont read junk data after
> > > isize extension.
> > 
> > Correct.
> > 
> > > Another thing I noticed is that most users of
> > > iomap_file_buffered_write() do their own eof zeroing in the FS layer
> > > (eg, xfs_file_write_zero_eof(), ext4's new changes,
> > > ntfs_extend_initialized_size() etc). 
> > > I think this FS level zerooing should take care of mkcleaning the eof
> > > folio (problem 1), as they call iomap_zero_range() which would flush the
> > > eof range anyways. So am I right in assuming that for FSes that do their
> > > own zeroing, 1. is already taken care of?
> > 
> > Well, I don't see anything that would writeprotect the old tail page in
> > iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
> > address 2. Not only due to mmap but also possibly to clear whatever junk
> > there can be in the blocks after EOF.
> 
> Well I was thinking more like if the EOF page was mmap'd it would be
> dirty and blocks beyond EOF would be unmapped, so iomap_zero_range() will
> write it back which shall mkclean() the folio.
> 
> But I think the same race we discussed for problem 2 can also occur
> here.
> 
> Thread 1 (extending write)             Thread 2 (mmap writer)
> 
> iomap_zero_range()
> filemap_write_and_wait_range()
>                                        // mmaps & writes EOF range
> iomap_write_iter()
> isize = new_size
> // pagecache_isize_extended() is
>    needed to mkclean() old EOF page.

Yes, this race exists and unlike in the case of zeroing where it is mostly
harmless not guranteeing calling page_mkwrite() with updated i_size can
lead to filesystem tripping on assertions, data loss or similar.

> > > As for 2, I think after the EOF zeroing of the FS, there might be a
> > > window before iomap_write_iter() where an mmap writer can still dirty
> > > EOF blocks, hence the pagecache_isize_extended() would be needed here.
> > > But doesn't that then make the eof zeroing in the FS layer redundant? Am
> > > I missing something here?
> > 
> > Hmm, I agree the zeroing looks duplicit (for some users of
> > pagecache_isize_extended()). And yes, doing the zeroing from
> > xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
> > write non-zeros before we update i_size) but I'd have hard time to argue it
> > really practically matters - you are racing mmap writes with buffered
> > writes so any kind of write atomicity guarantees are not there. 
> 
> Yeah, seems like it is not enough to take care of either 1 or 2 and
> pagecache_isize_extended() should maybe be enough. I was just wondering
> if we could optimize it away even for normal extend path (no racing mmap),
> we can avoid the expensive folio_zero_range() calls.
> 
> Regardless, Ive not looked at this more closely and its a separate issue
> so we can revisit it later. For now I wanted some clarity around
> pagecache_isize_extended() so thanks for that.

Well, but pagecache_isize_extended() doesn't guarantee on disk blocks are
zeroed out as well as it doesn't dirty the page. Also
xfs_file_write_zero_eof() potentially handles zeroing of more than a tail
page. So you cannot simply drop one of these.

> > > Regardless, for our case I think we will also need to do the
> > > pagecache_isize_extended(), mainly to take care of problem 2, but where
> > > exactly should we do it now?  We currently change the isize in endio()
> > > but for aio, it can run outside inode or folio lock. I think this
> > > function needs to be called under inode lock(). Hmm.. its a bit late here so
> > > I'll revisit this tomorrow with a fresh mind :)
> > 
> > I think mainly to take care of problem 1... You are correct about
> > inode_lock but since we are updating i_size, we should be better holding
> > it, shouldn't we?
> 
> Yes you are correct. In the aio writethrough codepath, the inode update
> is happening without the inode lock which is wrong. I overlooked the
> fact that even aio dio uses IOMAP_DIO_FORCE_WAIT to force isize update
> under inode lock, and we should do something similar as well.

Yes.

> So in v3, I make the change that for extending writes we shall always
> finish them in "sync" fashion so ->endio() runs under inode lock. Then,
> after ->endio() in iomap_dio_complete(), I will call
> pagecache_isize_extended() to take care of this. Just like isize update
> right now, the isize_extension only runs when the IO was successful
> otherwise we return an error to the user. This gives us semantics like
> dio while handling extension properly.
> 
> Does that sound okay?

Yep, sounds fine.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
