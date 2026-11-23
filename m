Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795423838;
	b=xwWVeioVDBBE6iT7XQQ+afU8un7a51p6CqW9obhmmEttiGx/+rHOyzyKZU/7reKOJK4q
	 fmCnhgnFBumTIjmY1C1drqNhib0hThRLV0GhBJ6ZES5nAoDhM8XWIt6YCN2Xg7sMDwdVU
	 743b+M3gs8OTgGdkJy5GIMMoJRRgYZgmXjHe2SAtHqRTi2L+VXteNjSp7ur2XAna0VbbA
	 wz0rC9EPb0+TOAAUwbA6WJwR3/kPjLwr71xVJQjC5qBmlpFCLs41SEs0bRBXc/iBSJBQe
	 gEjggOsKadCsDPdnxJ8q8hnDkHNugu/gVB+D3YOxkHi0IUqCknp8LG5Hf0h0WOZ/95g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795423838;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=P/CKK7Mms0zJAA5i4gpb92rqvvEnBlN6jA564M5z92E=;
	b=TI+yo6cKcxuTHbCqygwe1ULiEBOS6ojXDfqiYUnE+hocV4xD+cw0UdxZUHoNrJPAs/Lj
	 bkP2fqA4dO/E+NYOuarVwbmr8z1FPCQtX3+h0KQzyvaftpxzBWJsehqkkrMYoMw+B4NS5
	 JLtap+OfDxUjMPkbaxKNefQIC/847H7ZjViEyKAH5CsRnB6xFQYZR6t6b0SCDZneKwPd6
	 1ZbVudtiYCxDPNpWNO42NW1sM4MjAE5GOGoamQd/gJbM0XkscpK7i4Q0hUG6PASpfAhbG
	 GGxtTUfuoI4IRKe0xEvMw5f21TKNQYmPuSnz2T3sp7pAWzGDD9mJHYxEJHfHkTfLPkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="FeDdu/CP";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQAxJECC;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="KAgxtTa/";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q09KDOS8;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55555606A31A;
	Mon, 23 Nov 2026 08:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55555606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FeDdu/CP;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQAxJECC;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KAgxtTa/;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q09KDOS8
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF17D1F7E2;
	Mon, 23 Nov 2026 08:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795423830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P/CKK7Mms0zJAA5i4gpb92rqvvEnBlN6jA564M5z92E=;
	b=FeDdu/CPq7vOyW6qWgZM8/zsi1XBiSOQl4sf6fj6p0WfRHjoTSaHANbNW5+Cgzhf/GPkIX
	Z5rZw18hM4WRbT4cBxa1ROBgrOKzIatsMm69lvaI8u5kK3LWKQ85y0jTKGgXw34M1o7HIl
	d1JVQcVAFAg5g/5OA5GTLysDU0xSWpY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795423830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P/CKK7Mms0zJAA5i4gpb92rqvvEnBlN6jA564M5z92E=;
	b=EQAxJECCaU7sEPTQB5brc02NkR3UjP39dYiZ6sKegG5DMy607TRZwhDG3H1QqHO+duI0e+
	VrPZt/CbiWYhZMCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KAgxtTa/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q09KDOS8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795423829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P/CKK7Mms0zJAA5i4gpb92rqvvEnBlN6jA564M5z92E=;
	b=KAgxtTa/z9YofspAYPeqm6zW4tse8POl8i8uNwmQ9sdyqhGGWP+gwYYwnzct/fgR667e/N
	30eGfCRroPUn3/l8+wLPBFnc2MkSDaaijZ8EE+KRmUuXQAdaHwtfxd+wZ0zZveoMXr+lZz
	YFrJ6A53FlkWetPsGNtYCSjPXBHRUpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795423829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P/CKK7Mms0zJAA5i4gpb92rqvvEnBlN6jA564M5z92E=;
	b=Q09KDOS84c9GfH2HDr66k9U8tCIyytWJlD8B6UX6F4gYekzDZ5k6kDRbSlVBfzGy4H0Eau
	bwWDFSu6Wi0uWuBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4E081352B;
	Mon, 23 Nov 2026 08:50:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UmZ5JVX+A2uOegAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 08:50:29 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 221E8275F1; Mon, 23 Nov 2026 09:50:21 +0100 (CET)
Date: Mon, 23 Nov 2026 09:50:21 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, Qing Zhang <diasyzhangqing@gmail.com>, viro@zeniv.linux.org.uk, 
	jack@suse.cz, raven@themaw.net, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] namei: revalidate the symlink dentry before invoking
 get_link in RCU-walk
Message-ID: <d2w6jvflihqiyfbht3qv3mgjg3muuuvmhnss5j5dp4zh6axhn2@nsegavvnkpie>
References: <20261118083945.1449264-1-diasyzhang@tencent.com>
 <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
 <awB0RE6WN_v4YBbn@infradead.org>
 <awNlrO5A-kdDOYvO@dread>
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
In-Reply-To: <awNlrO5A-kdDOYvO@dread>
X-Rspamd-Queue-Id: DF17D1F7E2
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,gmail.com,zeniv.linux.org.uk,suse.cz,themaw.net,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.01

On Mon 23-11-26 08:59:08, Dave Chinner wrote:
> On Fri, Nov 20, 2026 at 08:24:36AM -0800, Christoph Hellwig wrote:
> > On Fri, Nov 20, 2026 at 02:59:42PM +0100, Christian Brauner wrote:
> > > This only makes the window smaller.
> > > 
> > > XFS can still reinitialize the inode right after this check and while
> > > get() is running. Then ->get_link() operates on an inode that is being
> > > reset underneath it. And the !get check only catches the case where the
> > > that re-init already finished before we loaded ->get_link.
> > > 
> > > RCU pathwalk relies on inode memory not being reused before a grace
> > > period has passed. XFS itself frees inodes via call_rcu() but the
> > > recycle path hands the same struct inode out again without waiting for
> > > existing RCU walkers.
> > > 
> > > So that should be fixed in XFS, either by not recycling an inode in
> > > place while RCU walkers can still see it or by keeping i_op and the link
> > > state valid across a recycle.
> > 
> > Not recycling the inode really isn't an option, as that means there
> > would cause duplicate inodes in the xfs inode cache.  Keeping i_op and
> > state in place sounds a bit more feasibly, but could be iffy as well.
> > 
> > The best thing would be to find a way to keep the inode alive at the VFS
> > level when XFS marks it reclaimable.  That would be a huge an invasive
> > change, but it would solve this and many other problems as well.
> 
> I don't think that's feasible without a massive rework of the VFS
> inode life cycle management and/or the way XFS tracks inode metadata
> dirtiness for writeback purposes.
> 
> Background:
> 
> The xfs_iget_recycle() code exists because dirty XFS_IRECLAIMABLE
> inodes are tied into the journal machinery and need writeback before
> they can be reclaimed. This is all invisible to the VFS, and it is
> done via lockless lookups and atomic state checks without the need
> for reference counts within XFS itself.
> 
> The issue is that reclaiming such an inode generally requires a log
> force to stabilise it in the journal before it can be written back,
> and the act of writing it back requires access to the inode state.
> Hence the journal requires the XFS inode to live in XFS_IRECLAIMABLE
> state until metadata writeback is complete, regardless of any other
> inode state changes.
> 
> xfs_ireclaim() can expedite the writeback portion of reclaim (by
> running an inode flush) but it does not expedite the required
> journal flush if the inode is still dirty in memory. On lookup
> of an XFS_IRECLAIMABLE inode in RCU mode, we cannot directly reclaim
> a dirty XFS_IRECLAIMABLE inode because it requires blocking on both
> a log force and metadata writeback. That's why the inode is sitting
> in the XFS_IRECLAIMABLE limbo in the first place...
> 
> That's where the xfs_iget_recycle() code stepped in - it
> reinitialises the VFS portion of the inode without affecting the
> internal journal state of the inode. This allows new modifications to
> be added to the inode and the attached log item without any
> discontinuities in journal state.
> 
> The reason it does a full initialisation of the VFS inode is that
> the inode can change identity whilst in XFS_IRECLAIMABLE. i.e. it
> could be unlinked and then reallocated as a different inode (same
> number, different generation), and so the type can change (e.g. REG
> -> DIR) and hence a full VFS init is required to recycle it.
> 
> And the reason that we've always done this recycle is for
> performance reasons - the inode allocation algorithms can prefer to
> allocate recently freed inodes (for locality reasons), and hence
> recently unlinked inodes in the IRECLAIMABLE state can be
> reallocated and need recycling because the final unlink state hasn't
> reached stable media before they are recycled.
> 
> Doing things like forcing logs, instant reclaim, RCU
> synchronisation, etc have all had significant performance impacts
> due to the additional latency these operations add to common
> workload patterns. Hence the rarity of this recycle issue hasn't
> outweighed the cost of the "simple" fixes to everyday operation.

I'd just mention one possible solution which you didn't mention below (I
don't know how complex it would get for XFS but we effectively do this in
ext4) - make the VFS part of the inode and the journalled portion of the
inode separate entities in memory (independently allocated & freed). Then
you can free the VFS portion of the inode while still keeping the
journalled portion allocated. If the inode location on disk gets
reallocated, you allocate fresh VFS part and recycle the journalled part.
In ext4 we have this natural separation between the buffer carrying the
inode structure on disk which is part of the journalling process and the
inode itself so this separation is easy there. For XFS I presume this is
complex or you wouldn't bother with all the separate inode lifetime logic
but I just wanted to toss this idea out.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
