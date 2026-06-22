Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D563BCD23
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782143993; cv=none; b=LFkdEshmcIC4/DTOM/5kZLIrNlBYGUNzhrxJJGN4/3uaNZIN/ser3V/PTsAs0UfbNQ5XO5ypBX9B1013ye9GqUD2iyhkSf40ffANrAqvlN+QeYcG7bw98TlNK5LEw+A5QqrEDBRLm7BxfEn9fpfG+Cq0MWNhGsprtJFn/E2LBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782143993; c=relaxed/simple;
	bh=9mKa2WAl5ViN7X+OGrei6y32MmRr0GwUqxw86NmWYNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gidw80YIkhrJkpIRaKAvE7eKpYKmMfeqRK9veLiM5VMziIS7IwK/YBLgOcepcI7tir9kdbRvmwdUnzuKv01gkBX0Ptv4279/3V6zrL5egEyYAiC3cbUP2YjUWfoXuqmV9U1bic1aRmnBug0OpcyqAxuqc2PW6hjRVI9/QeXZbrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Cabax5Pl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OIAY1LiX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Cabax5Pl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OIAY1LiX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Cabax5Pl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OIAY1LiX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Cabax5Pl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OIAY1LiX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15ED575A6F;
	Mon, 22 Jun 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782143989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h6knUy8F3m1oXi5b+TXPJbgR+BITHS6opkZcdu/3iK0=;
	b=Cabax5Pl3wsru4Et0M8skqd3LegoRFWpPxZ6xjCKkmOTiAS/5LoHvcglH3yg/XzRbeDSQZ
	rMucXdDy5LPmohjhZ6cIn0A+tzgGVIEag/IW68+y/HxSCUmJlDmhPI6o0XdvVxDPFOouPV
	7YPnCGlEo7oIUaW8s9UdFFELCRsJrgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782143989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h6knUy8F3m1oXi5b+TXPJbgR+BITHS6opkZcdu/3iK0=;
	b=OIAY1LiXDw1e08TdfKG7mni+mYA/LJ97FfGIQz617LpXVuK6HEX+9C9b/K4NygjynAJ6EK
	qDqnleINAj8vdlDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cabax5Pl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OIAY1LiX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782143989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h6knUy8F3m1oXi5b+TXPJbgR+BITHS6opkZcdu/3iK0=;
	b=Cabax5Pl3wsru4Et0M8skqd3LegoRFWpPxZ6xjCKkmOTiAS/5LoHvcglH3yg/XzRbeDSQZ
	rMucXdDy5LPmohjhZ6cIn0A+tzgGVIEag/IW68+y/HxSCUmJlDmhPI6o0XdvVxDPFOouPV
	7YPnCGlEo7oIUaW8s9UdFFELCRsJrgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782143989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h6knUy8F3m1oXi5b+TXPJbgR+BITHS6opkZcdu/3iK0=;
	b=OIAY1LiXDw1e08TdfKG7mni+mYA/LJ97FfGIQz617LpXVuK6HEX+9C9b/K4NygjynAJ6EK
	qDqnleINAj8vdlDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 083E0779A8;
	Mon, 22 Jun 2026 15:59:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EF0BAvVbOWr3OAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 15:59:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A86EA093E; Mon, 22 Jun 2026 17:59:44 +0200 (CEST)
Date: Mon, 22 Jun 2026 17:59:44 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 07/18] fs: maintain a global device-to-superblock
 table
Message-ID: <oeagmkdw57p4xevvqobz7fuszjjmvosab45gfos4eas7iqus3l@6abhneekgchc>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
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
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 15ED575A6F
X-Spam-Score: -4.01

On Tue 16-06-26 16:08:23, Christian Brauner wrote:
> fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> forces the holder to be exactly one superblock and prevents several
> superblocks from sharing one block device. That's what erofs is doing.
> 
> As a first step introduce a global dev_t-keyed rhltable mapping each
> device to the superblock(s) using it. The entry is preallocated in
> alloc_super() and registered under sb->s_dev by the set callback through
> set_anon_super() and set_bdev_super(), the two helpers every set
> callback assigns s_dev through. Registration is the final fallible act
> of a set callback, so an insert failure unwinds through sget_fc()'s
> existing set-failure path: the fs_context keeps ownership of s_fs_info
> and the callers' error paths stay correct. set_anon_super() releases
> the anonymous dev it allocated when registration fails. Unwinding
> through deactivate_locked_super() instead would run kill_sb() and free
> s_fs_info behind the caller's back: nfs and ceph free that object
> through a local pointer when sget_fc() fails and would double-free.
> 
> The superblock stashes the entry in sb->s_super_dev and
> kill_super_notify() drops the claim through it, so teardown doesn't
> depend on s_dev staying stable; an entry that was never registered is
> freed together with the superblock in destroy_super_work().
> 
> Each table entry holds a passive reference (s_passive) on its
> superblock, so the struct stays valid for as long as the entry is
> reachable. Entries are claim-counted through sd_ref: additional claims
> on the same (device, superblock) pair share the entry, and the unlink
> is deferred to the last put, so a later iteration cursor never resumes
> from a removed node.
> 
> The table is initialized from mnt_init(): the first superblocks (the
> tmpfs shm mount and rootfs) are created from start_kernel() long before
> any initcall runs, so an initcall would be too late.
> 
> The table has no readers yet; the fs_holder_ops callbacks are switched
> over once all devices a filesystem claims are registered.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/internal.h                  |   1 +
>  fs/namespace.c                 |   2 +
>  fs/super.c                     | 102 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/fs/super_types.h |   2 +
>  4 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index d77578d66d42..83eb3e2a0f85 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -137,6 +137,7 @@ extern int reconfigure_super(struct fs_context *);
>  extern bool super_trylock_shared(struct super_block *sb);
>  struct super_block *user_get_super(dev_t, bool excl);
>  void put_super(struct super_block *sb);
> +void __init super_dev_init(void);
>  extern bool mount_capable(struct fs_context *);
>  int sb_init_dio_done_wq(struct super_block *sb);
>  
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 3d5cd5bf3b05..7cef6dae0854 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -6262,6 +6262,8 @@ void __init mnt_init(void)
>  	if (!mount_hashtable || !mountpoint_hashtable)
>  		panic("Failed to allocate mount hash table\n");
>  
> +	super_dev_init();
> +
>  	kernfs_init();
>  
>  	err = sysfs_init();
> diff --git a/fs/super.c b/fs/super.c
> index a771a0ad4c9a..ff5e305d0ab4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,6 +24,7 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/rhashtable.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -272,6 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  	return total_objects;
>  }
>  
> +static struct super_dev *super_dev_alloc(dev_t dev, struct super_block *sb);
> +
>  static void destroy_super_work(struct work_struct *work)
>  {
>  	struct super_block *s = container_of(work, struct super_block,
> @@ -279,6 +282,8 @@ static void destroy_super_work(struct work_struct *work)
>  	fsnotify_sb_free(s);
>  	security_sb_free(s);
>  	put_user_ns(s->s_user_ns);
> +	/* Only an unregistered entry is still owned by the superblock. */
> +	kfree(s->s_super_dev);
>  	kfree(s->s_subtype);
>  	for (int i = 0; i < SB_FREEZE_LEVELS; i++)
>  		percpu_free_rwsem(&s->s_writers.rw_sem[i]);
> @@ -392,6 +397,10 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  		goto fail;
>  	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
>  		goto fail;
> +	s->s_super_dev = super_dev_alloc(0, s);
> +	if (!s->s_super_dev)
> +		goto fail;
> +
>  	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
>  	return s;
>  
> @@ -421,6 +430,77 @@ void put_super(struct super_block *s)
>  	}
>  }
>  
> +struct super_dev {
> +	dev_t			sd_dev;
> +	struct super_block	*sd_sb;
> +	refcount_t		sd_ref;
> +	struct rhlist_head	sd_node;
> +	struct rcu_head		sd_rcu;
> +};
> +
> +static struct rhltable super_dev_table;
> +static const struct rhashtable_params super_dev_params = {
> +	.key_len	= sizeof(dev_t),
> +	.key_offset	= offsetof(struct super_dev, sd_dev),
> +	.head_offset	= offsetof(struct super_dev, sd_node),
> +};
> +
> +static struct super_dev *super_dev_alloc(dev_t dev, struct super_block *sb)
> +{
> +	struct super_dev *fsd;
> +
> +	fsd = kzalloc_obj(*fsd);
> +	if (!fsd)
> +		return NULL;
> +	fsd->sd_dev = dev;
> +	fsd->sd_sb = sb;
> +	refcount_set(&fsd->sd_ref, 1);
> +	return fsd;
> +}
> +
> +static void super_dev_put(struct super_dev *fsd)
> +{
> +	/* Unlink only once unpinned, so a cursor never resumes from a removed node. */
> +	if (fsd && refcount_dec_and_test(&fsd->sd_ref)) {
> +		rhltable_remove(&super_dev_table, &fsd->sd_node, super_dev_params);
> +		put_super(fsd->sd_sb);
> +		kfree_rcu(fsd, sd_rcu);
> +	}
> +}
> +
> +void __init super_dev_init(void)
> +{
> +	if (rhltable_init(&super_dev_table, &super_dev_params))
> +		panic("VFS: Cannot initialise super_dev_table\n");
> +}
> +
> +static int super_dev_insert(struct super_dev *fsd)
> +{
> +	int err;
> +
> +	err = rhltable_insert(&super_dev_table, &fsd->sd_node, super_dev_params);
> +	if (!err)
> +		refcount_inc(&fsd->sd_sb->s_passive);
> +	return err;
> +}
> +
> +/* Register @sb under @sb->s_dev as the final fallible act of a set callback. */
> +static int super_dev_register(struct super_block *sb)
> +{
> +	struct super_dev *fsd = sb->s_super_dev;
> +	int err;
> +
> +	lockdep_assert_held(&sb_lock);
> +	VFS_WARN_ON_ONCE(!sb->s_dev);
> +	VFS_WARN_ON_ONCE(!fsd || fsd->sd_dev);
> +
> +	fsd->sd_dev = sb->s_dev;
> +	err = super_dev_insert(fsd);
> +	if (err)
> +		fsd->sd_dev = 0;
> +	return err;
> +}
> +
>  static void kill_super_notify(struct super_block *sb)
>  {
>  	lockdep_assert_not_held(&sb->s_umount);
> @@ -440,6 +520,12 @@ static void kill_super_notify(struct super_block *sb)
>  	hlist_del_init(&sb->s_instances);
>  	spin_unlock(&sb_lock);
>  
> +	/* Drop sget_fc()'s claim; a never-registered entry stays with the sb. */
> +	if (sb->s_super_dev->sd_dev) {
> +		super_dev_put(sb->s_super_dev);
> +		sb->s_super_dev = NULL;
> +	}
> +
>  	/*
>  	 * Let concurrent mounts know that this thing is really dead.
>  	 * We don't need @sb->s_umount here as every concurrent caller
> @@ -750,6 +836,7 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	}
>  	if (!s) {
>  		spin_unlock(&sb_lock);
> +
>  		s = alloc_super(fc->fs_type, fc->sb_flags, user_ns);
>  		if (!s)
>  			return ERR_PTR(-ENOMEM);
> @@ -759,11 +846,13 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	s->s_fs_info = fc->s_fs_info;
>  	err = set(s, fc);
>  	if (err) {
> +		VFS_WARN_ON_ONCE(s->s_super_dev->sd_dev);
>  		s->s_fs_info = NULL;
>  		spin_unlock(&sb_lock);
>  		destroy_unused_super(s);
>  		return ERR_PTR(err);
>  	}
> +	VFS_WARN_ON_ONCE(!s->s_super_dev->sd_dev);
>  	fc->s_fs_info = NULL;
>  	s->s_type = fc->fs_type;
>  	s->s_iflags |= fc->s_iflags;
> @@ -1217,7 +1306,16 @@ EXPORT_SYMBOL(free_anon_bdev);
>  
>  int set_anon_super(struct super_block *s, void *data)
>  {
> -	return get_anon_bdev(&s->s_dev);
> +	int error;
> +
> +	error = get_anon_bdev(&s->s_dev);
> +	if (error)
> +		return error;
> +
> +	error = super_dev_register(s);
> +	if (error)
> +		free_anon_bdev(s->s_dev);
> +	return error;
>  }
>  EXPORT_SYMBOL(set_anon_super);
>  
> @@ -1303,7 +1401,7 @@ EXPORT_SYMBOL(get_tree_keyed);
>  static int set_bdev_super(struct super_block *s, void *data)
>  {
>  	s->s_dev = *(dev_t *)data;
> -	return 0;
> +	return super_dev_register(s);
>  }
>  
>  static int super_s_dev_set(struct super_block *s, struct fs_context *fc)
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index 68747182abf9..c8172558750f 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -30,6 +30,7 @@ struct mount;
>  struct mtd_info;
>  struct quotactl_ops;
>  struct shrinker;
> +struct super_dev;
>  struct unicode_map;
>  struct user_namespace;
>  struct workqueue_struct;
> @@ -132,6 +133,7 @@ struct super_operations {
>  struct super_block {
>  	struct list_head			s_list;		/* Keep this first */
>  	dev_t					s_dev;		/* search index; _not_ kdev_t */
> +	struct super_dev			*s_super_dev;	/* sget_fc()'s device table claim */
>  	unsigned char				s_blocksize_bits;
>  	unsigned long				s_blocksize;
>  	loff_t					s_maxbytes;	/* Max file size */
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
