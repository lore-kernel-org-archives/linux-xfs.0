Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F363EAC74
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782900135; cv=none; b=tpE8+L2TWhkptUrlbW3I12yqiiFBmypfPQhCvBSiJy0+K+4+zY30wZJtGveiX35t59s5xoHj7K2IfsHOixWas5F5uNs06dVlnMbHhnTvvk5jY+l16C1W27cnXZABeeT+SGoyhkxEUuUAODc0ZSW2rPUnO8CHzkUG42DPhZpLRP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782900135; c=relaxed/simple;
	bh=J51rRfaxK8fGMmtvu+jD8gfjs+kdNXPq9pFXJhbevKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/CrNuNXIFkXKmj5dwU4fmdcwopB0SMX+3oplLG9je4qU/zeWC3b8mMf/1FjtHue4Pj33gqYml1boKDWzYOoFfeDVDAA58ydjhIfnjZS5VwCQJ3wENTN9YBZRt2AbA8o8515NQFBlh385EaGPHrBCCZTjvwSuoEJ1hrfoFtU7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mBY41Kjc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6NGPy9bo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cSkE1WeV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wVnFA7b2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mBY41Kjc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6NGPy9bo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cSkE1WeV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wVnFA7b2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 150AB6CDED;
	Wed,  1 Jul 2026 10:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782900127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWbI3HtdGc9mnVGm4GYK5isYuM5Z+XQSQQ3mx/FhgFw=;
	b=mBY41KjcjrCSuGlzYQAC/4rT6bAtRe5eGi40qUYj0M7eP0v+q/dGnVrpFPPCy01eyOf6VX
	TMONw6i5qc224Xv+KksK7vxLkQWuIKo5G5Nctkmcd9MuGzA3vlZB5fpORlZK0wO8nlOU/T
	8jz7WFZaWg3Sl9I4b3BXWvVj1hPhJY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782900127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWbI3HtdGc9mnVGm4GYK5isYuM5Z+XQSQQ3mx/FhgFw=;
	b=6NGPy9boRx6vLTWxNfCFFB99xzdkoZ1b4kx3C1RqSw+xiugiUOWSVrDsCgnhwpxbQW079x
	bbkORtTC1Ou3L7AA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cSkE1WeV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wVnFA7b2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782900122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWbI3HtdGc9mnVGm4GYK5isYuM5Z+XQSQQ3mx/FhgFw=;
	b=cSkE1WeVz3Eao+gjSJWywv93ZWbdcl3ZA8TWIkuKb62UKnGZfd3xACtBsROQuUTKs7r4hO
	H8FMuPac4HEe0D5qNGlAafl5X3djQooaOgrG0rlROpCCnmYiEEtPSw+nmQiZCka3nTudgn
	t5VuHjMa5iNYmHb7QSI0OCtN8yRKvWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782900122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWbI3HtdGc9mnVGm4GYK5isYuM5Z+XQSQQ3mx/FhgFw=;
	b=wVnFA7b25Qis0X1+IWNF/rpkFzLkc7DKq1CZ3W4+Mx6N+nPV008V6g7UfdtXCdoJwPjujb
	2gl7p1AH00U0p4CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0405E779AA;
	Wed,  1 Jul 2026 10:01:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /OD4AJXlRGqoNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Jul 2026 10:01:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 78D6EA10B7; Wed, 01 Jul 2026 12:01:56 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:01:56 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/18] ext4: convert iomap ops to ->iomap_next()
Message-ID: <wic5rrrhmet5dc3sbjy6iei4yn3h3ybszw4shwlf6yyy4xl2zl@4dy5hpvsrt6p>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-7-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-7-joannelkoong@gmail.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,lst.de,infradead.org,linux.alibaba.com,vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 150AB6CDED
X-Spam-Score: -2.51

On Tue 30-06-26 17:09:21, Joanne Koong wrote:
> Convert ext4 iomap_ops to the new ->iomap_next() callback. This uses the
> iomap_process() helper, which finishes the previous mapping if needed
> and produces the next one. No functional changes are intended.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c |  8 +++++++-
>  fs/ext4/inode.c   | 17 +++++++++++++++--
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b31..431298eca7e8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5171,8 +5171,14 @@ static int ext4_iomap_xattr_begin(struct inode *inode, loff_t offset,
>  	return error;
>  }
>  
> +static int ext4_iomap_xattr_next(const struct iomap_iter *iter,
> +				 struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, ext4_iomap_xattr_begin, NULL);
> +}
> +
>  static const struct iomap_ops ext4_iomap_xattr_ops = {
> -	.iomap_begin		= ext4_iomap_xattr_begin,
> +	.iomap_next		= ext4_iomap_xattr_next,
>  };
>  
>  static int ext4_fiemap_check_ranges(struct inode *inode, u64 start, u64 *len)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..cf7aa8275651 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3850,8 +3850,14 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	return 0;
>  }
>  
> +static int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +			   struct iomap *srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, ext4_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops ext4_iomap_ops = {
> -	.iomap_begin		= ext4_iomap_begin,
> +	.iomap_next		= ext4_iomap_next,
>  };
>  
>  static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
> @@ -3905,8 +3911,15 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static int ext4_iomap_next_report(const struct iomap_iter *iter,
> +				  struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, ext4_iomap_begin_report,
> +			     NULL);
> +}
> +
>  const struct iomap_ops ext4_iomap_report_ops = {
> -	.iomap_begin = ext4_iomap_begin_report,
> +	.iomap_next = ext4_iomap_next_report,
>  };
>  
>  /*
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
