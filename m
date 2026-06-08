Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0893D3C4563
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913912; cv=none; b=VhQmZDGRE6DIaWx0mCZMxSpCaU5hPvhieLzMpQr/Yq5SzWwrC+W95NTsbY9+8MAQgQjT9GxTEggaNBczC61gx9TyEJCkhjd7I7hEvNopbnqlHSEc2bn2lVcyYHc8v2+vhodSG+67JegUr4BrMoMcsEXvBZyXpyslv4zv8006Dms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913912; c=relaxed/simple;
	bh=xFKpdG5ImdbEEufAxHnfc2L+yZMoGZXIuJoxAy9FzUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5grRIJMatg1kwDuYOqLThop6exFd2ehlFe6mHvMGaYKesL4Wy0QJM5EPlpXh0NmHu1iq7M4LSzekwxKJnYNWAA7tYpF0CieHaOwS0Louolbzsu0wiqQCH9Ut1FCi44d2t6ttTDrwP0sNeZB3fPZ/8cmTX7UUZZ9qFGVurbcv1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fmWFwg0R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9p6LZuJE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HbH2uNiL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=v8BXrYN1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fmWFwg0R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9p6LZuJE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HbH2uNiL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="v8BXrYN1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE3E66A98D;
	Mon,  8 Jun 2026 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u4J/INQm6w0zsScCVOuflChG7PGIHtgYgrf1etqt+0g=;
	b=fmWFwg0R1ImFHrVE8fCxlBgs/n0QKU1SGaRET1jImnhMHb8WilKLoJKNXbqa3XyHRMsYhZ
	IZriXOj/HH4AuEiGWdYdlP72tkph8ZAtutVIyEkQe/LAsyuBdmlrAuC6FgCKvNsopCP3kA
	3aUOfb/J5C22X1OV+eypKwrikWIENIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u4J/INQm6w0zsScCVOuflChG7PGIHtgYgrf1etqt+0g=;
	b=9p6LZuJE04ePCSCYBTYQNFmOFo7Gzl1BltehgSANqzxjhCrNKAHIXK+VDVlkyEEGGaT/9L
	O+rmGcUyEhIyLsDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HbH2uNiL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v8BXrYN1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u4J/INQm6w0zsScCVOuflChG7PGIHtgYgrf1etqt+0g=;
	b=HbH2uNiLtvvmnNBjSCzdEcPXezZgQVhGc4sgHnNbgzYyY2zNiqDhLHDCkprjW8v/MhLR5C
	FzWv6FGhbovkOhjrjU6KsDSp5VHJebuZ1iRqZy4QSwmgLhktJvsmLJcfaB9RLelR7L+eGP
	CiM0Rrxz5mxm/ajKqeCtboAr73a1res=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u4J/INQm6w0zsScCVOuflChG7PGIHtgYgrf1etqt+0g=;
	b=v8BXrYN1129lsltaA4PXw8Xj/VaVKNKzaGfRLONI60IPGQ4oL4hY4mUDboy5Vc2YhWsJds
	aXZi7GWgKfPPu5Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1E08779A7;
	Mon,  8 Jun 2026 10:18:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OC8kN/KWJmpTOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 10:18:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93609A10CB; Mon, 08 Jun 2026 12:18:22 +0200 (CEST)
Date: Mon, 8 Jun 2026 12:18:22 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 8/8] super: make fs_holder_ops private
Message-ID: <ux3pfx6tgtzaetd4k4olikh26jsm6waefynimwlefxdxcxrgbp@f45tuvzujiuh>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-8-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-8-bb0fd82f3861@kernel.org>
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
	RCPT_COUNT_TWELVE(0.00)[17];
	MISSING_XM_UA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email];
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
X-Rspamd-Queue-Id: EE3E66A98D
X-Spam-Score: -4.01

On Tue 02-06-26 12:10:14, Christian Brauner wrote:
> There's no need to expose it anymore.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index cea743f699e4..983c2fbf5202 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1643,13 +1643,12 @@ static int fs_bdev_thaw(struct block_device *bdev)
>  	return error;
>  }
>  
> -const struct blk_holder_ops fs_holder_ops = {
> +static const struct blk_holder_ops fs_holder_ops = {
>  	.mark_dead		= fs_bdev_mark_dead,
>  	.sync			= fs_bdev_sync,
>  	.freeze			= fs_bdev_freeze,
>  	.thaw			= fs_bdev_thaw,
>  };
> -EXPORT_SYMBOL_GPL(fs_holder_ops);
>  
>  static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  {
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
