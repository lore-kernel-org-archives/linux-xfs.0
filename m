Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256A13FC5AB
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 09:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588495; cv=none; b=qFLgMeKQdTmjwQUneP2EOYX22jHTH3yc/SEYhiOH0vOfJpoJQUuPYiJtHRtKhYfmOJA6i0dovv+H7bzlxy8IZb6epNx6viqHG0gMdCgcFzZr/GvJfy50JrATnCGJAU0CblAWG0KmYTioNtoyxuMG/dGmFO6Krw2xZIrcg/3thnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588495; c=relaxed/simple;
	bh=o0I0OjPFe4LmYKdueZYmtVzeFX7nC29HCEypr39F0oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hs3k8D5X09OtX7pgP7k48GdbmrnBPTtKqsxoHvueAYC1k8wp7uFRJkPkv1vcVVmkr0Cl05Xibtmzlr5XtYizLibWyjfBJSdR8tybIrw8xQA4FjXg21R262LRh0Y63F1tHs1I0wzoGPTSxRpYaUtqGudKfv312cn8VDRvs/MFWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UHPw56Oy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IA7TR7wq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UHPw56Oy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IA7TR7wq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UHPw56Oy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IA7TR7wq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UHPw56Oy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IA7TR7wq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3501F7609E;
	Thu,  9 Jul 2026 09:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783588492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ay+n3JYalJzW9RHZobonYNYRCZVSzmMR1IGHyNCWzyY=;
	b=UHPw56OyPmIjWA+2nG7gQU0hzHfzejIpg4uq9GjDmPFCk4bR3mdzIyAkSg/3eNos7ROXLz
	ENHztyCFutKlONYqBVszG7usJBWEhYg0vWAHWdVYg+VC97ed9rKMPdboMhTg/yC2oP9aNE
	ORoYQUf1OXjTBCNPffkjBfYcLkpilKQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783588492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ay+n3JYalJzW9RHZobonYNYRCZVSzmMR1IGHyNCWzyY=;
	b=IA7TR7wqvGR4RJHVc0YWNq4bzAOoEHUQx3XnyccXR22re+Pj9Z7TBoPaIME4o0d2iquKWo
	SEIiuus8l2UVxCBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHPw56Oy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IA7TR7wq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783588492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ay+n3JYalJzW9RHZobonYNYRCZVSzmMR1IGHyNCWzyY=;
	b=UHPw56OyPmIjWA+2nG7gQU0hzHfzejIpg4uq9GjDmPFCk4bR3mdzIyAkSg/3eNos7ROXLz
	ENHztyCFutKlONYqBVszG7usJBWEhYg0vWAHWdVYg+VC97ed9rKMPdboMhTg/yC2oP9aNE
	ORoYQUf1OXjTBCNPffkjBfYcLkpilKQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783588492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ay+n3JYalJzW9RHZobonYNYRCZVSzmMR1IGHyNCWzyY=;
	b=IA7TR7wqvGR4RJHVc0YWNq4bzAOoEHUQx3XnyccXR22re+Pj9Z7TBoPaIME4o0d2iquKWo
	SEIiuus8l2UVxCBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BD86779AA;
	Thu,  9 Jul 2026 09:14:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FJusCoxmT2paMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 09:14:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C4D2BA12D7; Thu, 09 Jul 2026 11:14:47 +0200 (CEST)
Date: Thu, 9 Jul 2026 11:14:47 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, jack@suse.cz, 
	brauner@kernel.org, cem@kernel.org, jaegeuk@kernel.org, aalbersh@kernel.org, 
	tytso@mit.edu, Keith Busch <kbusch@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <neamg3phll7hjwd765ddtqebtxasdvkoskff75dqzmgzv2xy5i@mf4agr6yoizn>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709071352.GA20180@lst.de>
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
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MISSING_XM_UA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3501F7609E
X-Spam-Score: -4.01

On Thu 09-07-26 09:13:52, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > +		u32 dio_align = ext4_dio_alignment(inode);
> > +
> > +		if (dio_align != 0) {
> 
> 
> > +			struct block_device *bdev = inode->i_sb->s_bdev;
> > +
> > +			if (dio_align == 1) {
> > +				fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> > +				fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> > +				fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> > +			} else {
> > +				fa->fsx_dio_mem_align = dio_align;
> > +				fa->fsx_dio_offset_align = dio_align;
> > +				fa->fsx_dio_read_offset_align = dio_align;
> > +			}
> 
> Call bdev_fileattr and override the relevant field as needed?
> 
> Question to the ext4 maintainers: why does ext4_dio_alignment
> affect the in-memory alignment?  If it does so, it should probably
> also affect the virt boundry alignment..

I guess that is mostly a historical accident. ext4_dio_alignment() returns
1 (iomap alignment is used and that's different for memory and file offset
alignment), 0 (dio not supported, memory and file offset alignment is
indeed the same), and blocksize (a special case which can happen for
fscrypt if it supports dio and where I believe memory alignment
requirements may be in fact different). I'm adding Eric to CC to answer
what actual requirements fscrypt has for memory buffers for direct IO. I'd
expect with inline encryption we would have the same requirements as
ordinary iomap direct IO and for other code paths I'm not sure... Eric?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
