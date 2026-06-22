Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5673AF676
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136137; cv=none; b=UBBeXar0yEEL48FzkApalVabMPoi3xyADN/wIF5l0AancTuysJadwnYo6tXWAXjgMIvNb75J4qrOikKUR6sbK0nJcmkkzvGTn64P9GYw3t8y7/4d/FDLSEK490uhqOsK2L0R+OfT33/1Hsr/C5+MFiY8X06mSSTQiQGXjcoxGbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136137; c=relaxed/simple;
	bh=eIFuwtcqEKriEEWLA35Im9u6Q0c3SQCm8I9nYfiWkLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPeQTQoAgIT0uoQgm8u3x9YEqy8lh2X1YXPAUZYY7mPMfehIeNEq9r4a6/ktgKGSEq1Uic9Gp2yIOb+/XrGrirHVWLnWNvPPdtpoPBceJLCnYZOb1PnW3/Pl3WHxH1WubvFj+ALfqQywf9T+TlDHrvaVGLkE9O5H+zSvMLcVYgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S6GhM5Mv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ki6GgB3f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S6GhM5Mv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ki6GgB3f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S6GhM5Mv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ki6GgB3f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S6GhM5Mv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ki6GgB3f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B13C575BCD;
	Mon, 22 Jun 2026 13:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUDX91MsVhUVFXr0iW6meWtexXLIRn9u12ppWWQ8ZtM=;
	b=S6GhM5Mvl0muVGAQvjp6ji4mhxU6HNVr+flCUaWJQBg9jCESmw5wR9aZuw+08k+iSC0bNR
	apozSNF2EGBLsKus6Tg54HwInUO/I533ytSpU4nquM3Z+hDjC9EzNciGYPzu2XjTRxqTWW
	hsbHvZTzr5hbHWwxXrst2PMZvV3ixmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUDX91MsVhUVFXr0iW6meWtexXLIRn9u12ppWWQ8ZtM=;
	b=Ki6GgB3fnd/LVz5LAy0KPbQ0tnyDaLgKoBX3qnycEJI5yL/FYbOvlrQmx8PTJawh93xY/+
	1YEMacP1LqyjmSAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S6GhM5Mv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ki6GgB3f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782136130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUDX91MsVhUVFXr0iW6meWtexXLIRn9u12ppWWQ8ZtM=;
	b=S6GhM5Mvl0muVGAQvjp6ji4mhxU6HNVr+flCUaWJQBg9jCESmw5wR9aZuw+08k+iSC0bNR
	apozSNF2EGBLsKus6Tg54HwInUO/I533ytSpU4nquM3Z+hDjC9EzNciGYPzu2XjTRxqTWW
	hsbHvZTzr5hbHWwxXrst2PMZvV3ixmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782136130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUDX91MsVhUVFXr0iW6meWtexXLIRn9u12ppWWQ8ZtM=;
	b=Ki6GgB3fnd/LVz5LAy0KPbQ0tnyDaLgKoBX3qnycEJI5yL/FYbOvlrQmx8PTJawh93xY/+
	1YEMacP1LqyjmSAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 994EB779A8;
	Mon, 22 Jun 2026 13:48:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iB9sJUI9OWp7OQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 13:48:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 487B6A093E; Mon, 22 Jun 2026 15:48:42 +0200 (CEST)
Date: Mon, 22 Jun 2026 15:48:42 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 02/18] super: convert s_count to refcount_t
 s_passive
Message-ID: <qwij4swmsnvwgdt6zxz5ymy2mdvzgillz2u7fwaol22mdc4kv4@c6pptdtzpqkt>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-2-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-2-7df6b864028e@kernel.org>
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
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B13C575BCD
X-Spam-Score: -4.01

On Tue 16-06-26 16:08:18, Christian Brauner wrote:
> The superblock carries two counters: s_active, the active reference
> count that keeps the filesystem usable, and s_count, the passive
> reference count that merely keeps the structure itself alive. Turn the
> passive count into a refcount_t and rename it to s_passive to make the
> pairing with s_active obvious.
> 
> Everything is still serialized by sb_lock, so there is no functional
> change; the conversion buys the usual refcount_t saturation and
> underflow checking. The following patches start dropping passive
> references without holding sb_lock and make the device-to-superblock
> table hold one passive reference per registered entry, which a plain
> integer cannot support.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Yeah, looks like a reasonable cleanup. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/super.c                     | 18 +++++++++---------
>  include/linux/fs/super_types.h |  2 +-
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index a8fd61136aaf..25dd72b550e0 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -102,7 +102,7 @@ static bool super_flags(const struct super_block *sb, unsigned int flags)
>   * creation will succeed and SB_BORN is set by vfs_get_tree() or we're
>   * woken and we'll see SB_DYING.
>   *
> - * The caller must have acquired a temporary reference on @sb->s_count.
> + * The caller must have acquired a temporary reference on @sb->s_passive.
>   *
>   * Return: The function returns true if SB_BORN was set and with
>   *         s_umount held. The function returns false if SB_DYING was
> @@ -367,7 +367,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  	spin_lock_init(&s->s_inode_wblist_lock);
>  	fserror_mount(s);
>  
> -	s->s_count = 1;
> +	refcount_set(&s->s_passive, 1);
>  	atomic_set(&s->s_active, 1);
>  	mutex_init(&s->s_vfs_rename_mutex);
>  	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
> @@ -407,7 +407,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>   */
>  static void __put_super(struct super_block *s)
>  {
> -	if (!--s->s_count) {
> +	if (refcount_dec_and_test(&s->s_passive)) {
>  		list_del_init(&s->s_list);
>  		WARN_ON(s->s_dentry_lru.node);
>  		WARN_ON(s->s_inode_lru.node);
> @@ -529,7 +529,7 @@ static bool grab_super(struct super_block *sb)
>  {
>  	bool locked;
>  
> -	sb->s_count++;
> +	refcount_inc(&sb->s_passive);
>  	spin_unlock(&sb_lock);
>  	locked = super_lock_excl(sb);
>  	if (locked) {
> @@ -556,7 +556,7 @@ static bool grab_super(struct super_block *sb)
>   *	lock held in read mode in case of success. On successful return,
>   *	the caller must drop the s_umount lock when done.
>   *
> - *	Note that unlike get_super() et.al. this one does *not* bump ->s_count.
> + *	Note that unlike get_super() et.al. this one does *not* bump ->s_passive.
>   *	The reason why it's safe is that we are OK with doing trylock instead
>   *	of down_read().  There's a couple of places that are OK with that, but
>   *	it's very much not a general-purpose interface.
> @@ -858,7 +858,7 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
>  	     sb = next_super(sb, flags)) {
>  		if (super_flags(sb, SB_DYING))
>  			continue;
> -		sb->s_count++;
> +		refcount_inc(&sb->s_passive);
>  		spin_unlock(&sb_lock);
>  
>  		if (flags & SUPER_ITER_UNLOCKED) {
> @@ -903,7 +903,7 @@ void iterate_supers_type(struct file_system_type *type,
>  		if (super_flags(sb, SB_DYING))
>  			continue;
>  
> -		sb->s_count++;
> +		refcount_inc(&sb->s_passive);
>  		spin_unlock(&sb_lock);
>  
>  		locked = super_lock_shared(sb);
> @@ -935,7 +935,7 @@ struct super_block *user_get_super(dev_t dev, bool excl)
>  		if (sb->s_dev != dev)
>  			continue;
>  
> -		sb->s_count++;
> +		refcount_inc(&sb->s_passive);
>  		spin_unlock(&sb_lock);
>  
>  		locked = super_lock(sb, excl);
> @@ -1369,7 +1369,7 @@ static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
>  
>  	/* Make sure sb doesn't go away from under us */
>  	spin_lock(&sb_lock);
> -	sb->s_count++;
> +	refcount_inc(&sb->s_passive);
>  	spin_unlock(&sb_lock);
>  
>  	mutex_unlock(&bdev->bd_holder_lock);
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index ef7941e9dc79..68747182abf9 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -145,7 +145,7 @@ struct super_block {
>  	unsigned long				s_magic;
>  	struct dentry				*s_root;
>  	struct rw_semaphore			s_umount;
> -	int					s_count;
> +	refcount_t				s_passive;
>  	atomic_t				s_active;
>  #ifdef CONFIG_SECURITY
>  	void					*s_security;
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
