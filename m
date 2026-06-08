Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA823BFAF0
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913683; cv=none; b=TzUwwwvTPRWg+uQgO6/QJ9UwMCSbh2sHJE9AVviZQH1FKeyzMkHPXpGnY4TWrVEXJpE8RlHekYngryK7a51evoq1HlTBdEyHxcVWvu1THEuwmXwiL23GDzfEvU0+mhbv5b52VV9NbmYjzz2pHvWZ1CeEZMIsM6l0aVOR9khrtgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913683; c=relaxed/simple;
	bh=/oc99M5xw0cA6yksanu6mxaEE+LPuw4+e6cDumGLiYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUHxhz+1YLzbqmB9/uFEgwX1Q89wPGYLNUD+/D+HyvvEfzwP+EILJJn5BkBusmfIcf2XXrKoTt7tlXdNznJN3xIMSWAyp/C8YFLJJ9oW4Aa/kCp/jlD9r5h70zrD70ZGPbW1Lwup7lvtpFwVO5ZUqqa0pgh78Na1yva4TcTkl5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aYCpqdJm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7mBh6ZTH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aYCpqdJm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7mBh6ZTH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aYCpqdJm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7mBh6ZTH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aYCpqdJm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7mBh6ZTH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 269236A8F7;
	Mon,  8 Jun 2026 10:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHnKrqfEkSw6cxvRmiBXYjm8sn9LrWGnz5XNRnMJLKM=;
	b=aYCpqdJmR/P1uPLo9nBbTneYkHy6wepxPb5f+/b4SdFxUs+7faUZmLqLllV88k4Z9SYm11
	pU5i0A4pnFcX5Id9eLjCCdPxkK73pzg+CJEO6iIfNRMyFP/ut6vCH2JCzLMYEcf2zF9VzF
	KGuvOOCYvtoxK/dbRC4bjmbwyGAIs48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHnKrqfEkSw6cxvRmiBXYjm8sn9LrWGnz5XNRnMJLKM=;
	b=7mBh6ZTH4mgql3lBfbx8ZJty29CQpida59plMx3W8Qa7cbjU1fR3fjV+gcs9H8nYzbYoLr
	vMKXpPd+KFwSfVDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHnKrqfEkSw6cxvRmiBXYjm8sn9LrWGnz5XNRnMJLKM=;
	b=aYCpqdJmR/P1uPLo9nBbTneYkHy6wepxPb5f+/b4SdFxUs+7faUZmLqLllV88k4Z9SYm11
	pU5i0A4pnFcX5Id9eLjCCdPxkK73pzg+CJEO6iIfNRMyFP/ut6vCH2JCzLMYEcf2zF9VzF
	KGuvOOCYvtoxK/dbRC4bjmbwyGAIs48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHnKrqfEkSw6cxvRmiBXYjm8sn9LrWGnz5XNRnMJLKM=;
	b=7mBh6ZTH4mgql3lBfbx8ZJty29CQpida59plMx3W8Qa7cbjU1fR3fjV+gcs9H8nYzbYoLr
	vMKXpPd+KFwSfVDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17BF4779A7;
	Mon,  8 Jun 2026 10:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VuzGBQmWJmpFNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 10:14:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B5D75A10CB; Mon, 08 Jun 2026 12:14:32 +0200 (CEST)
Date: Mon, 8 Jun 2026 12:14:32 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
Message-ID: <ow5phrszinggpreojwavck566nhzdh2tfdt7aju3wftogjvp57@ov24urf5tjwg>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -3.80

On Tue 02-06-26 12:10:08, Christian Brauner wrote:
> fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> forces the holder to be exactly one superblock and prevents several
> superblocks from sharing one block device. That's what erofs is doing.
> 
> Introduce a global dev_t-keyed rhltable mapping each block device to the
> superblock(s) using it. The holder argument becomes purely the block
> layer's exclusivity token (a superblock, or a file_system_type for
> shared devices) and is no longer needed by the fs specific callbacks.
> 
> Registration keeps one entry per (device, superblock). When a filesystem
> claims a device it already uses (xfs with its log on the data device), no
> second entry is added, so each superblock is acted on once.
> 
> Each table entry holds a passive reference (s_count) on its superblock,
> so the struct stays valid for as long as the entry is reachable. The
> callbacks look the device up in the table and act on every superblock
> using it:
> 
> Unlinking an entry is deferred to the last unpin, so a cursor never
> resumes from a removed node. After this it's possible to act on all
> superblocks that share a given device.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! One comment below:

>  static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
>  {
> -	struct super_block *sb;
> +	struct fs_bdev_holder *h;
> +	dev_t dev = bdev->bd_dev;
>  
> -	sb = bdev_super_lock(bdev, false);
> -	if (!sb)
> -		return;
> +	mutex_unlock(&bdev->bd_holder_lock);

The moment we drop bd_holder_lock, there's nothing which prevents the bdev
owner from changing. So this can lead to a situation where we miss calling
->mark_dead callback of the new holder. Similarly for all the other holder
ops. I didn't find a situation where it would actually matter so I think
we're fine but it's a potential catch. Anyway, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

>  
> -	if (sb->s_op->remove_bdev) {
> -		int ret;
> +	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
> +		struct super_block *sb = h->sb;
>  
> -		ret = sb->s_op->remove_bdev(sb, bdev);
> -		if (!ret) {
> -			super_unlock_shared(sb);
> -			return;
> +		if (!super_lock_shared(sb))
> +			continue;
> +		if (sb->s_root && (sb->s_flags & SB_ACTIVE)) {
> +			if (!sb->s_op->remove_bdev ||
> +			    sb->s_op->remove_bdev(sb, bdev)) {
> +				if (!surprise)
> +					sync_filesystem(sb);
> +				shrink_dcache_sb(sb);
> +				evict_inodes(sb);
> +				if (sb->s_op->shutdown)
> +					sb->s_op->shutdown(sb);
> +			}
>  		}
> -		/* Fallback to shutdown. */
> +		super_unlock_shared(sb);
>  	}
> -
> -	if (!surprise)
> -		sync_filesystem(sb);
> -	shrink_dcache_sb(sb);
> -	evict_inodes(sb);
> -	if (sb->s_op->shutdown)
> -		sb->s_op->shutdown(sb);
> -
> -	super_unlock_shared(sb);
>  }
>  
>  static void fs_bdev_sync(struct block_device *bdev)
>  {
> -	struct super_block *sb;
> +	struct fs_bdev_holder *h;
> +	dev_t dev = bdev->bd_dev;
>  
> -	sb = bdev_super_lock(bdev, false);
> -	if (!sb)
> -		return;
> +	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	sync_filesystem(sb);
> -	super_unlock_shared(sb);
> -}
> +	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
> +		struct super_block *sb = h->sb;
>  
> -static struct super_block *get_bdev_super(struct block_device *bdev)
> -{
> -	bool active = false;
> -	struct super_block *sb;
> -
> -	sb = bdev_super_lock(bdev, true);
> -	if (sb) {
> -		active = atomic_inc_not_zero(&sb->s_active);
> -		super_unlock_excl(sb);
> +		if (!super_lock_shared(sb))
> +			continue;
> +		if (sb->s_root && (sb->s_flags & SB_ACTIVE))
> +			sync_filesystem(sb);
> +		super_unlock_shared(sb);
>  	}
> -	if (!active)
> -		return NULL;
> -	return sb;
>  }
>  
>  /**
> - * fs_bdev_freeze - freeze owning filesystem of block device
> + * fs_bdev_freeze - freeze every superblock using a block device
>   * @bdev: block device
>   *
> - * Freeze the filesystem that owns this block device if it is still
> - * active.
> - *
> - * A filesystem that owns multiple block devices may be frozen from each
> - * block device and won't be unfrozen until all block devices are
> - * unfrozen. Each block device can only freeze the filesystem once as we
> - * nest freezes for block devices in the block layer.
> + * Freeze each live superblock using @bdev.  A superblock owning several block
> + * devices is frozen once per device and stays frozen until all are thawed; the
> + * block layer nests these freezes so the count stays balanced.
>   *
> - * Return: If the freeze was successful zero is returned. If the freeze
> - *         failed a negative error code is returned.
> + * Return: 0, or the error from the one superblock on a single-fs device.  When
> + *         several superblocks share @bdev a per-superblock failure is swallowed
> + *         (see below), but a sync_blockdev() failure is always reported.
>   */
>  static int fs_bdev_freeze(struct block_device *bdev)
>  {
> -	struct super_block *sb;
> -	int error = 0;
> +	dev_t dev = bdev->bd_dev;
> +	struct fs_bdev_holder *h;
> +	unsigned int count = 0;
> +	int error = 0, err;
>  
>  	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
>  
> -	sb = get_bdev_super(bdev);
> -	if (!sb)
> -		return -EINVAL;
> +	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	if (sb->s_op->freeze_super)
> -		error = sb->s_op->freeze_super(sb,
> -				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
> -	else
> -		error = freeze_super(sb,
> -				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
> +	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
> +		if (!atomic_inc_not_zero(&h->sb->s_active))
> +			continue;
> +		err = fs_super_freeze(h->sb);
> +		if (err && !error)
> +			error = err;
> +		deactivate_super(h->sb);
> +		count++;
> +	}
> +
> +	/*
> +	 * When several superblocks share the device, keep it frozen even if some
> +	 * of them failed to freeze and swallow the error: rolling the rest back
> +	 * via thaw_super() can fail too, so neither is a clear win. A single
> +	 * filesystem (count == 1) still reports its error.
> +	 */
> +	if (error && count > 1)
> +		error = 0;
>  	if (!error)
>  		error = sync_blockdev(bdev);
> -	deactivate_super(sb);
>  	return error;
>  }
>  
>  /**
> - * fs_bdev_thaw - thaw owning filesystem of block device
> + * fs_bdev_thaw - thaw every superblock using a block device
>   * @bdev: block device
>   *
> - * Thaw the filesystem that owns this block device.
> + * The counterpart to fs_bdev_freeze(): thaw each live superblock using @bdev.
> + * A zero return does not imply a superblock is fully unfrozen; it may have been
> + * frozen more than once (by the kernel or via another device).
>   *
> - * A filesystem that owns multiple block devices may be frozen from each
> - * block device and won't be unfrozen until all block devices are
> - * unfrozen. Each block device can only freeze the filesystem once as we
> - * nest freezes for block devices in the block layer.
> - *
> - * Return: If the thaw was successful zero is returned. If the thaw
> - *         failed a negative error code is returned. If this function
> - *         returns zero it doesn't mean that the filesystem is unfrozen
> - *         as it may have been frozen multiple times (kernel may hold a
> - *         freeze or might be frozen from other block devices).
> + * Return: 0, or the first error on a single-fs device; a shared device swallows
> + *         per-superblock errors, as fs_bdev_freeze() does.
>   */
>  static int fs_bdev_thaw(struct block_device *bdev)
>  {
> -	struct super_block *sb;
> -	int error;
> +	dev_t dev = bdev->bd_dev;
> +	struct fs_bdev_holder *h;
> +	unsigned int count = 0;
> +	int error = 0, err;
>  
>  	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
>  
> -	/*
> -	 * The block device may have been frozen before it was claimed by a
> -	 * filesystem. Concurrently another process might try to mount that
> -	 * frozen block device and has temporarily claimed the block device for
> -	 * that purpose causing a concurrent fs_bdev_thaw() to end up here. The
> -	 * mounter is already about to abort mounting because they still saw an
> -	 * elevanted bdev->bd_fsfreeze_count so get_bdev_super() will return
> -	 * NULL in that case.
> -	 */
> -	sb = get_bdev_super(bdev);
> -	if (!sb)
> -		return -EINVAL;
> +	mutex_unlock(&bdev->bd_holder_lock);
>  
> -	if (sb->s_op->thaw_super)
> -		error = sb->s_op->thaw_super(sb,
> -				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
> -	else
> -		error = thaw_super(sb,
> -				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
> -	deactivate_super(sb);
> +	for (h = fs_bdev_first(dev); h; h = fs_bdev_next(h)) {
> +		if (!atomic_inc_not_zero(&h->sb->s_active))
> +			continue;
> +		err = fs_super_thaw(h->sb);
> +		if (err && !error)
> +			error = err;
> +		deactivate_super(h->sb);
> +		count++;
> +	}
> +
> +	/* Shared device: swallow per-superblock errors, like fs_bdev_freeze(). */
> +	if (error && count > 1)
> +		error = 0;
>  	return error;
>  }
>  
> @@ -1602,6 +1651,131 @@ const struct blk_holder_ops fs_holder_ops = {
>  };
>  EXPORT_SYMBOL_GPL(fs_holder_ops);
>  
> +static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
> +{
> +	dev_t dev = file_bdev(bdev_file)->bd_dev;
> +	struct rhlist_head *list, *pos;
> +	struct fs_bdev_holder *h;
> +	int err;
> +
> +	/*
> +	 * A superblock may claim one device more than once (xfs with its log on
> +	 * the data device).  Keep a single entry per (device, superblock) and
> +	 * count the claims in @fs_bdev_active; the entry lives until the last one
> +	 * is released.
> +	 */
> +	scoped_guard(rcu) {
> +		list = rhltable_lookup(&fs_bdev_supers, &dev, fs_bdev_params);
> +		rhl_for_each_entry_rcu(h, pos, list, node)
> +			if (h->sb == sb && refcount_inc_not_zero(&h->fs_bdev_active))
> +				return 0;
> +	}
> +
> +	h = kmalloc(sizeof(*h), GFP_KERNEL);
> +	if (!h)
> +		return -ENOMEM;
> +	h->dev = dev;
> +	h->sb = sb;
> +	refcount_set(&h->fs_bdev_passive, 1);
> +	refcount_set(&h->fs_bdev_active, 1);
> +
> +	err = rhltable_insert(&fs_bdev_supers, &h->node, fs_bdev_params);
> +	if (err) {
> +		kfree(h);
> +		return err;
> +	}
> +
> +	/* The sb->s_count ref keeps @h->sb valid for as long as the entry exists. */
> +	spin_lock(&sb_lock);
> +	sb->s_count++;
> +	spin_unlock(&sb_lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * fs_bdev_file_open_by_dev - claim a block device on behalf of a superblock
> + * @dev: block device number
> + * @mode: open mode
> + * @holder: block-layer exclusivity token (a superblock, or the file_system_type
> + *          when the device may be shared by several superblocks of that type)
> + * @sb: superblock to drive fs_holder_ops events for
> + *
> + * Open @dev with &fs_holder_ops and register that @sb uses it, so device
> + * removal/sync/freeze/thaw are propagated to @sb (and any other superblock
> + * sharing @dev).  Must be paired with fs_bdev_file_release().
> + *
> + * Return: an opened block-device file or an ERR_PTR().
> + */
> +struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
> +				      struct super_block *sb)
> +{
> +	struct file *bdev_file;
> +	int err;
> +
> +	bdev_file = bdev_file_open_by_dev(dev, mode, holder, &fs_holder_ops);
> +	if (IS_ERR(bdev_file))
> +		return bdev_file;
> +
> +	err = fs_bdev_register(bdev_file, sb);
> +	if (err) {
> +		bdev_fput(bdev_file);
> +		return ERR_PTR(err);
> +	}
> +	return bdev_file;
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_dev);
> +
> +struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
> +				       void *holder, struct super_block *sb)
> +{
> +	struct file *bdev_file;
> +	int err;
> +
> +	bdev_file = bdev_file_open_by_path(path, mode, holder, &fs_holder_ops);
> +	if (IS_ERR(bdev_file))
> +		return bdev_file;
> +
> +	err = fs_bdev_register(bdev_file, sb);
> +	if (err) {
> +		bdev_fput(bdev_file);
> +		return ERR_PTR(err);
> +	}
> +	return bdev_file;
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_open_by_path);
> +
> +/**
> + * fs_bdev_file_release - release a block device claimed for a superblock
> + * @bdev_file: file returned by fs_bdev_file_open_by_{dev,path}()
> + * @sb: superblock the device was claimed for
> + *
> + * Drop one claim on the {dev, @sb} entry; the last claim unregisters it (a
> + * pinning cursor defers the actual unlink).  Then close the block device.
> + */
> +void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb)
> +{
> +	dev_t dev = file_bdev(bdev_file)->bd_dev;
> +	struct fs_bdev_holder *h, *found = NULL;
> +	struct rhlist_head *list, *pos;
> +
> +	rcu_read_lock();
> +	list = rhltable_lookup(&fs_bdev_supers, &dev, fs_bdev_params);
> +	rhl_for_each_entry_rcu(h, pos, list, node) {
> +		if (h->sb != sb)
> +			continue;
> +		/* At most one entry per (dev, sb); the last claim drops the bias. */
> +		if (refcount_dec_and_test(&h->fs_bdev_active))
> +			found = h;
> +		break;
> +	}
> +	rcu_read_unlock();
> +	if (found)
> +		fs_bdev_holder_put(found);
> +	bdev_fput(bdev_file);
> +}
> +EXPORT_SYMBOL_GPL(fs_bdev_file_release);
> +
>  int setup_bdev_super(struct super_block *sb, int sb_flags,
>  		struct fs_context *fc)
>  {
> @@ -1609,7 +1783,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	struct file *bdev_file;
>  	struct block_device *bdev;
>  
> -	bdev_file = bdev_file_open_by_dev(sb->s_dev, mode, sb, &fs_holder_ops);
> +	bdev_file = fs_bdev_file_open_by_dev(sb->s_dev, mode, sb, sb);
>  	if (IS_ERR(bdev_file)) {
>  		if (fc)
>  			errorf(fc, "%s: Can't open blockdev", fc->source);
> @@ -1623,7 +1797,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	 * writable from userspace even for a read-only block device.
>  	 */
>  	if ((mode & BLK_OPEN_WRITE) && bdev_read_only(bdev)) {
> -		bdev_fput(bdev_file);
> +		fs_bdev_file_release(bdev_file, sb);
>  		return -EACCES;
>  	}
>  
> @@ -1634,7 +1808,7 @@ int setup_bdev_super(struct super_block *sb, int sb_flags,
>  	if (atomic_read(&bdev->bd_fsfreeze_count) > 0) {
>  		if (fc)
>  			warnf(fc, "%pg: Can't mount, blockdev is frozen", bdev);
> -		bdev_fput(bdev_file);
> +		fs_bdev_file_release(bdev_file, sb);
>  		return -EBUSY;
>  	}
>  	spin_lock(&sb_lock);
> @@ -1725,7 +1899,7 @@ void kill_block_super(struct super_block *sb)
>  	generic_shutdown_super(sb);
>  	if (bdev) {
>  		sync_blockdev(bdev);
> -		bdev_fput(sb->s_bdev_file);
> +		fs_bdev_file_release(sb->s_bdev_file, sb);
>  	}
>  }
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c8494d64a69d..43d37c02febf 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1760,13 +1760,6 @@ struct blk_holder_ops {
>  	int (*thaw)(struct block_device *bdev);
>  };
>  
> -/*
> - * For filesystems using @fs_holder_ops, the @holder argument passed to
> - * helpers used to open and claim block devices via
> - * bd_prepare_to_claim() must point to a superblock.
> - */
> -extern const struct blk_holder_ops fs_holder_ops;
> -
>  /*
>   * Return the correct open flags for blkdev_get_by_* for super block flags
>   * as stored in sb->s_flags.
> diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
> index f21ffbb6dea5..721d842e3b24 100644
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -235,4 +235,11 @@ int freeze_super(struct super_block *super, enum freeze_holder who,
>  int thaw_super(struct super_block *super, enum freeze_holder who,
>  	       const void *freeze_owner);
>  
> +struct file;
> +struct file *fs_bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
> +				      struct super_block *sb);
> +struct file *fs_bdev_file_open_by_path(const char *path, blk_mode_t mode,
> +				       void *holder, struct super_block *sb);
> +void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb);
> +
>  #endif /* _LINUX_FS_SUPER_H */
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
