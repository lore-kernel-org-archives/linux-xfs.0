Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CEC3FAE00
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782900135; cv=none; b=arjJ4UpvlaJvf9XEEvtIAq0IKwDApQbmite9PI5JxTVAjavYudB9LxmbMf1LPKQ918aJXJxO/hyu5RjJnpGUa2tUjrUoJmF3B/2MevSPJZV6rEO0QBxPVT4Xpy6gcfeONpThIe/mABJ38aX6WhtlQ6t1ImwFgzM/6qFt32jdidE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782900135; c=relaxed/simple;
	bh=dMpHBFOduG3Sxu6XYZ5n2Y1f4prbbTNBtXohgrAcPdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odsGCucGJbyXsnshvDnJzspKpyRz7Tn31PS0yyG2HDrHsCR7ZjV6P3WZznifZ4jHLn8b/uPPE25+NbRsvSo2pXL3CJWtB9T1TMvv0bGDS9nPrPUEGN4sNOS2tQeSCtfhv4V6zCpxd2TbLoJMmE2dqGD4aeDWYSLOTyHDgDD491s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UV8rUGFp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rix1xD73; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c5nGPwlr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FpU8xO5g; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UV8rUGFp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rix1xD73";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c5nGPwlr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FpU8xO5g"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C5CB175F59;
	Wed,  1 Jul 2026 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782900132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjPN4/0TRFREaL2VWbIHgZohnuhF5LOXeSUaf8UntOI=;
	b=UV8rUGFpxiRgjg41lxymz1YNfspj0KTJ5NJe3IF0lWtEActrD+Kte4mkUCAJQisz/Vkca8
	Aixe4jBkL6BFRvxLF/limHzzWDNDQVcu9WKwqKmI1M5hRVlFv3m+hIpO7Wozd5/mSSgK7P
	Vltw/GJtogYOVzZodPQ7BsuAffIxicg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782900132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjPN4/0TRFREaL2VWbIHgZohnuhF5LOXeSUaf8UntOI=;
	b=rix1xD73cgshXqcr7eNUQlz2eeHRUxxbhn/cCWjJo72v/xu163cPYdXYy+tAglR7rmO7wV
	Ifcg9QPwWhb2PXBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c5nGPwlr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FpU8xO5g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782900129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjPN4/0TRFREaL2VWbIHgZohnuhF5LOXeSUaf8UntOI=;
	b=c5nGPwlrJW7+w4sWKQarlls/Qo68fYROPHB8yh4pM1lBrRw5WS+TZaaxEoB9eWMEsAuUs0
	v3OS25qa8gTYHnsiasBS50G0buiN8DofkA9PN1+fkqSeyRxJKrBqsDvYfpVRiAJOLQScjW
	OrzO7JG7+MBvN6VimcPhFVh162tS2nY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782900129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjPN4/0TRFREaL2VWbIHgZohnuhF5LOXeSUaf8UntOI=;
	b=FpU8xO5goC/Evr2Q+1bHuUj6fMQ7+WtYQaNxTGa/q+BdFEyUPU3vqwUiAtKNJSHAVOd4Y5
	JtgHoIyP7FTDtjBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8F43779AC;
	Wed,  1 Jul 2026 10:02:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QWglLaHlRGq3NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Jul 2026 10:02:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69221A10B7; Wed, 01 Jul 2026 12:02:09 +0200 (CEST)
Date: Wed, 1 Jul 2026 12:02:09 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Jan Kara <jack@suse.com>, "open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/18] ext2: convert iomap ops to ->iomap_next()
Message-ID: <xveiytug2nqkae3qf3vjv24lmv2l6bwxqxlyeykshxhqxszjvg@6lupwavas4e5>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-10-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-10-joannelkoong@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C5CB175F59
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RSPAMD_EMAILBL_FAIL(0.00)[joannelkoong.gmail.com:server fail];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 30-06-26 17:09:24, Joanne Koong wrote:
> Convert ext2 iomap_ops to the new ->iomap_next() callback. This uses the
> iomap_process() helper, which finishes the previous mapping if needed
> and produces the next one. No functional changes are intended.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 29808629cce5..0693059caa35 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -860,9 +860,15 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
>  	return 0;
>  }
>  
> +static int ext2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
> +			   struct iomap *srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, ext2_iomap_begin,
> +			     ext2_iomap_end);
> +}
> +
>  const struct iomap_ops ext2_iomap_ops = {
> -	.iomap_begin		= ext2_iomap_begin,
> -	.iomap_end		= ext2_iomap_end,
> +	.iomap_next		= ext2_iomap_next,
>  };
>  
>  int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
