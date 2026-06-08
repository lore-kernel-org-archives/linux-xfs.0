Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47FB3C276D
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912650; cv=none; b=RT9qAzALNjsjZSFiQAsrcLJT9mxRFI2KU65g95xC+dBcGh0e2qAZ6T+u+FhiB7SCuOWmahfADbhKMmCt6VTDK43YmI33dUZBUvlMYu5ddxgY/MwRBJsYWbkat2t499jC5zzYx/sc89ZET/YgrCQ4CqhkjyFI4vzMFI7Sab858nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912650; c=relaxed/simple;
	bh=7cIt5qqEelwEsbsbjYdQKQ3wfCqycNd4eQmWTQXlhVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=im7h0j49/eGs47+913Gl2dtnrjROFi0Xa9uVRAu5zHu3jkVP6SK1APTY0PBrdBr9H/c4w3ses63BG2IM+49FrKu2HfbI+t2Zn1XU/HwgWQHcE4jIodxrZ/OQVYzogcLFXOBrCFWLk1+K7nt4LbAJUz4XEpeHk/0OyPhFvUiTCVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z9sED5ks; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AvA9Fjba; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z9sED5ks; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AvA9Fjba; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z9sED5ks";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AvA9Fjba";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z9sED5ks";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AvA9Fjba"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0407867406;
	Mon,  8 Jun 2026 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780912646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WHC6YGWDqkZpp81mnN/Um769+dyiH1mIzuumkwpAA4=;
	b=Z9sED5ksn+jtJc+hanT/IkmuDu3WcKNq4PGFSKY0FAWt0PqhgRyeVRBbrjq/XlNdTl73Z8
	BgcggrpMbrGlE9XqwyZDpYQxrXH7V9gH6EH0XoBh+zSz3bWp0hmIyOY62ESblhfqxPmPhd
	yrMn+qH3xT3ML9drFhf3TSOtZj9vaxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780912646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WHC6YGWDqkZpp81mnN/Um769+dyiH1mIzuumkwpAA4=;
	b=AvA9FjbaHx+Q41IJi1iHbubM1CWkC8j/PksWMoXIGAvcZIYjafEMnk2ZnCBLhorGQ20ore
	FyGA37dv0xCQ8aDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780912646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WHC6YGWDqkZpp81mnN/Um769+dyiH1mIzuumkwpAA4=;
	b=Z9sED5ksn+jtJc+hanT/IkmuDu3WcKNq4PGFSKY0FAWt0PqhgRyeVRBbrjq/XlNdTl73Z8
	BgcggrpMbrGlE9XqwyZDpYQxrXH7V9gH6EH0XoBh+zSz3bWp0hmIyOY62ESblhfqxPmPhd
	yrMn+qH3xT3ML9drFhf3TSOtZj9vaxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780912646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WHC6YGWDqkZpp81mnN/Um769+dyiH1mIzuumkwpAA4=;
	b=AvA9FjbaHx+Q41IJi1iHbubM1CWkC8j/PksWMoXIGAvcZIYjafEMnk2ZnCBLhorGQ20ore
	FyGA37dv0xCQ8aDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA7DF779A7;
	Mon,  8 Jun 2026 09:57:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kVk3OQWSJmrZIgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 09:57:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 954F9A10CB; Mon, 08 Jun 2026 11:57:21 +0200 (CEST)
Date: Mon, 8 Jun 2026 11:57:21 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 1/8] fs, block: move blk_mode_t and fop_flags_t into
 <linux/types.h>
Message-ID: <lcq56poi7ebfdzbjevobd7fhbture7tn234wsxkk7q6kmr4cbx@zbit7mxburgd>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-1-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-1-bb0fd82f3861@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Level: 

On Tue 02-06-26 12:10:07, Christian Brauner wrote:
> blk_mode_t and fop_flags_t are both plain 'unsigned int __bitwise' flag
> typedefs, exactly like the gfp_t, slab_flags_t and fmode_t that already
> live in <linux/types.h>. Move them there so they are available
> everywhere without having to drag in a subsystem header.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/blkdev.h | 2 --
>  include/linux/fs.h     | 2 --
>  include/linux/types.h  | 2 ++
>  3 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 890128cdea1c..c8494d64a69d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -126,8 +126,6 @@ struct blk_integrity {
>  	unsigned char				pi_tuple_size;
>  };
>  
> -typedef unsigned int __bitwise blk_mode_t;
> -
>  /* open for reading */
>  #define BLK_OPEN_READ		((__force blk_mode_t)(1 << 0))
>  /* open for writing */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..e9346be8470f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1921,8 +1921,6 @@ struct dir_context {
>  struct io_uring_cmd;
>  struct offset_ctx;
>  
> -typedef unsigned int __bitwise fop_flags_t;
> -
>  struct file_operations {
>  	struct module *owner;
>  	fop_flags_t fop_flags;
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 608050dbca6a..ef026585420b 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -163,6 +163,8 @@ typedef u32 dma_addr_t;
>  typedef unsigned int __bitwise gfp_t;
>  typedef unsigned int __bitwise slab_flags_t;
>  typedef unsigned int __bitwise fmode_t;
> +typedef unsigned int __bitwise blk_mode_t;
> +typedef unsigned int __bitwise fop_flags_t;
>  
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>  typedef u64 phys_addr_t;
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
