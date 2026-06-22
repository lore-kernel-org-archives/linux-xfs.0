Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3D28F949
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136092; cv=none; b=CZgtAhH4FTl4qiToEsKKJl1HOdai4TDZ45XXGDTSZWzmHNH8uBE0WX3h0KsRgN+9VGdekkoPnkJSdK91OITVrk340jmWJn/xo1hk/Fd/tRb4lCpRxuFlOtavycXL1rYkXNs60QnJ04BnwRFTYgl8pZnMY20APT7x6Up5cyyRZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136092; c=relaxed/simple;
	bh=ZTqtNc5eESp8CRU/R/a/wv3cAl9k4MwHQQ0UzlB0zgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNSv4ryioo7jH3oHKPkkBzwwkour1ACo5kb6rrri3YA6RqBoi65KiU+D3e0HMiguLV9P671vYCvpEbOHYWBY1QnOfbtIyVO7bC9z4n2+jI3MWNU60XQN/wNUzgsY0WtvNZ3DkqkYzNQAVivTkoACr6qJoOxMfBbyfQPbR6mbbGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zi09dilP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hhFzMdR4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zi09dilP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hhFzMdR4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zi09dilP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hhFzMdR4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zi09dilP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hhFzMdR4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B60F275ACD;
	Mon, 22 Jun 2026 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FD3a5+Dlc8iVEzpk26bJLyDG0mIWGxFvtnGI5a59jFQ=;
	b=zi09dilPo/o7bMTIqTQMWBrS0Ww5BkSMS4ntuDm/DBom4GnhSfY8/5ORphXDTSK1lip7iP
	FnHN5LnP3TRKH7evkjpobYt/cpF5rveSl1tf6wqeXIm/wvM7Q56gWgPe2ut83wi805T1HK
	qUgrn6cGVZJx28TlP9SOCdW2lK42bLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136089;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FD3a5+Dlc8iVEzpk26bJLyDG0mIWGxFvtnGI5a59jFQ=;
	b=hhFzMdR4Si7T+awj4+Q8h6Djh9pthLfOOxt6nY9n+3VQEzJ78RAh5FmFkESC4TpR1lLA8x
	hWqVkGIn/0ds6IAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zi09dilP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hhFzMdR4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FD3a5+Dlc8iVEzpk26bJLyDG0mIWGxFvtnGI5a59jFQ=;
	b=zi09dilPo/o7bMTIqTQMWBrS0Ww5BkSMS4ntuDm/DBom4GnhSfY8/5ORphXDTSK1lip7iP
	FnHN5LnP3TRKH7evkjpobYt/cpF5rveSl1tf6wqeXIm/wvM7Q56gWgPe2ut83wi805T1HK
	qUgrn6cGVZJx28TlP9SOCdW2lK42bLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136089;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FD3a5+Dlc8iVEzpk26bJLyDG0mIWGxFvtnGI5a59jFQ=;
	b=hhFzMdR4Si7T+awj4+Q8h6Djh9pthLfOOxt6nY9n+3VQEzJ78RAh5FmFkESC4TpR1lLA8x
	hWqVkGIn/0ds6IAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC4AC779A8;
	Mon, 22 Jun 2026 13:48:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 85UNKhk9OWpKOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 13:48:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5435FA093E; Mon, 22 Jun 2026 15:48:05 +0200 (CEST)
Date: Mon, 22 Jun 2026 15:48:05 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 05/18] ext4: use anonymous devices for KUnit test
 superblocks
Message-ID: <zct2xodvpkv5lfpdlepjd64hwune5ufwcttrojikdjihddssvu@s2o7qnij5cr5>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-5-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-5-7df6b864028e@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B60F275ACD
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 16-06-26 16:08:21, Christian Brauner wrote:
> The mballoc and extents KUnit tests create superblocks through
> sget_fc() with a set callback that never assigns s_dev and a kill_sb
> that only calls generic_shutdown_super().
> 
> The upcoming global device-to-superblock table registers every
> superblock under its s_dev, so each superblock needs a unique device
> number. Allocate a proper anonymous device via set_anon_super_fc() and
> release it through kill_anon_super().
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Ok. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents-test.c | 9 ++-------
>  fs/ext4/mballoc-test.c | 9 ++-------
>  2 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a82607..c3836ecb89f9 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -126,11 +126,6 @@ struct kunit_ext_test_param {
>  	struct kunit_ext_data_state exp_data_state[3];
>  };
>  
> -static void ext_kill_sb(struct super_block *sb)
> -{
> -	generic_shutdown_super(sb);
> -}
> -
>  static int ext_init_fs_context(struct fs_context *fc)
>  {
>  	return 0;
> @@ -138,13 +133,13 @@ static int ext_init_fs_context(struct fs_context *fc)
>  
>  static int ext_set(struct super_block *sb, struct fs_context *fc)
>  {
> -	return 0;
> +	return set_anon_super_fc(sb, fc);
>  }
>  
>  static struct file_system_type ext_fs_type = {
>  	.name		 = "extents test",
>  	.init_fs_context = ext_init_fs_context,
> -	.kill_sb	 = ext_kill_sb,
> +	.kill_sb	 = kill_anon_super,
>  };
>  
>  static void extents_kunit_exit(struct kunit *test)
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index d90da44aadbd..a3b33ed2c172 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -59,11 +59,6 @@ static const struct super_operations mbt_sops = {
>  	.free_inode	= mbt_free_inode,
>  };
>  
> -static void mbt_kill_sb(struct super_block *sb)
> -{
> -	generic_shutdown_super(sb);
> -}
> -
>  static int mbt_init_fs_context(struct fs_context *fc)
>  {
>  	return 0;
> @@ -72,7 +67,7 @@ static int mbt_init_fs_context(struct fs_context *fc)
>  static struct file_system_type mbt_fs_type = {
>  	.name			= "mballoc test",
>  	.init_fs_context	= mbt_init_fs_context,
> -	.kill_sb		= mbt_kill_sb,
> +	.kill_sb		= kill_anon_super,
>  };
>  
>  static int mbt_mb_init(struct super_block *sb)
> @@ -136,7 +131,7 @@ static void mbt_mb_release(struct super_block *sb)
>  
>  static int mbt_set(struct super_block *sb, struct fs_context *fc)
>  {
> -	return 0;
> +	return set_anon_super_fc(sb, fc);
>  }
>  
>  static struct super_block *mbt_ext4_alloc_super_block(void)
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
