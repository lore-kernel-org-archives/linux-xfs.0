Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40CE3ADBAF
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782385934; cv=none; b=E4xaZRx/+qakBNVCn6QEioew4epKruUjru3Kzry6Yo6gc3xBOqyXl54nsc1a7o35pm75ehakA/2VuVRhtPLaPjfzScSTKffPXG1KwRgYkFOzIjkBlPh7UIm7c9SSNDvXpLOEquwYGu1U1OoZ6PLpH4XmQrRUlvMLAe0r//M/9zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782385934; c=relaxed/simple;
	bh=Hy94OIjWzPLOlCFuuiSfmsBVT6ao6NxQiWi9DIM5Nq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIiywRbJOcaiUB3ZkhLP6mxBKaLIFSA7p5DaFlO/CgMLEoGI0H0K9RHgBrb6hBZsYDnne2zM4Mn59GEQXB6YXPQrlEjDCYIX00m8wvjBvXT0xb5w+rBLUH/FR1RBgY6HIydpMFx/RQxqkjeU04xuAn3Z4jKEJtw8Ro6VxsBfFLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oaMvIP7L; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=85NxXg4c; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TbuFXCjI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J9lxoYoW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oaMvIP7L";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="85NxXg4c";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TbuFXCjI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J9lxoYoW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 185EE761D1;
	Thu, 25 Jun 2026 11:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782385931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4apt3BUOgYQ5opq6befSCHQHemOIYVJiqJGVn18VK4=;
	b=oaMvIP7LZmEyqKNuF3XnUZ6XDhUdy+amife892yb5okmeSTRmjYRtgxhv4DNS8tn/hoDJj
	eagsMV5refAYdSny5KWNWS5wj7jRCaEsgx59vtdsHklGHD0GnPtGHx2FBW8JaTiTdfPgzo
	MSxQAns5zSc7kGZ6bpyp1Pg9sSmwJRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782385931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4apt3BUOgYQ5opq6befSCHQHemOIYVJiqJGVn18VK4=;
	b=85NxXg4cl5gljpWZM+CELJXW4D0lqDD7Ae0foStZXyzzZtJQBrEvK6r1zcnDcUEr1WP/gV
	b4SS2nB5X0i/WaDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TbuFXCjI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J9lxoYoW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782385930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4apt3BUOgYQ5opq6befSCHQHemOIYVJiqJGVn18VK4=;
	b=TbuFXCjIAyb1eNlD05GVAR2hQw5SJhlJhh5x+FQODiUpV87dwvTc6abVl52FiI7zFoqRmU
	WfdpjRwpcgWMbwisBpVPizidh/Pdh/c28U2KcUNsVfK+uCgNnSoa4IJWtZPBGN9w/MPKPL
	JzGArFrWeMXVWhiD//cRMSNktZmMXUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782385930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4apt3BUOgYQ5opq6befSCHQHemOIYVJiqJGVn18VK4=;
	b=J9lxoYoWEEoUo4zvBg7JE34eVrMDjkBsplk6UEFSg0aApu4R6FAxKDY0y+Cp6dWHeK/X1q
	+GopzP+YO/iWTrBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CC00779A8;
	Thu, 25 Jun 2026 11:12:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2YUXAwoNPWp2VwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 11:12:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9C5B9A10A3; Thu, 25 Jun 2026 13:12:05 +0200 (CEST)
Date: Thu, 25 Jun 2026 13:12:05 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>, 
	Filip Blagojevic <filip.blagojevic@wdc.com>, Matthew Wilcox <willy@infradead.org>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <ecyxpdw5jcqiw5lq26pi4af76tygoiqshj23hp7jkguvbn6o3z@bd3hnhglc4bo>
References: <20260623142109.1838702-1-hch@lst.de>
 <rbrncqfmzbnj5o2yvieqtpl3dkb4qzafsai3sarmbta4fsqc6f@yruai3zv5llu>
 <20260624134950.GA6471@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624134950.GA6471@lst.de>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 185EE761D1
X-Spam-Score: -4.01

On Wed 24-06-26 15:49:50, Christoph Hellwig wrote:
> On Wed, Jun 24, 2026 at 02:26:35PM +0200, Jan Kara wrote:
> > A cleaner but still relatively simple way how to fix your problem would be
> > to do something similar like e.g. btrfs does. That is when you have a
> > filesystem with multiple backing devices, you create a new BDI (using
> > super_setup_bdi()) and set its parameters based on the combination of
> > devices you have.
> 
> The big downside of that is that it breaks the userspace ABI - any
> previous changes to BDI paramters, most importantly the read-ahead size,
> would now only apply to the BDI for s_bdev which isn't actually used
> by anything.

Hum, right. XFS users are used to tweak
/sys/block/<dev>/queue/read_ahead_kb
which would stop influencing anything. I guess that could indeed break some
people's expectations.

> > >   1) support multiple BDIs per file system.
> > > 
> > > 	This would work pretty well for XFS, as data for a given file is
> > > 	always entirely on one device, and the VFS writeback code is not
> > > 	used for metadata.  But it probably doesn't work well for other
> > > 	cases
> > 
> > Since looking up the bdi is abstracted through inode_to_bdi() (which
> > currently goes through the superblock), this would be relatively easy to do
> > but either the inode would have to store the bdi pointer or we'd have to
> > have an operation to query it. Just at this point I'm not fully convinced
> > the additional complexity / memory cost is worth it compared to what can be
> > achieved with a synthetic bdi.
> 
> Same.

One more idea: We already cache bdi's ra_pages in struct file_ra_state on
file open. It wouldn't be that hard to allow filesystem to override the
values in its open method (currently it isn't possible only because
file_ra_state_init() is called after ->open). For io_pages we currently
always go to the bdi so we'd have to add it to struct file_ra_state.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
