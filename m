Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E298331ED0;
	Wed,  2 Sep 2026 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358863; cv=none; b=n3g9kOfZkK5lBc+IC3K/xrzsUcelrK/68XgVS1I/gNNEbEF9jkxrv5qyV2fXE3m9EDZxonSTGHqrw57kCqxvkzlRRpKmTe47duHAtE9mq+E9CzVn1AJ9kF1mNCGKpST/mgBVQBtPGRArvPrePtTk7LHmYFsU/jzZ9o768zPKtjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358863; c=relaxed/simple;
	bh=aZhU0Rn83EYD2FXVab26G/upwKxGi3CxJLh2BSWd4ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdTc+e3ZtxPnu+Hf+zo7By6udr/H49qZDGWFI+m1PNXDdhfaUQ1xgC1xrGjKsy4W2DuNT9Q+stFiaGJfp3tohCW2C1Z3rf8hDKfAVs/o5GQQa5EIdnzMo7mcztfM9OfM8jHcMu2I8XNi4jkIFCAZG0VxFZ3lQZ69tc1tH3VqjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FHJbqhrD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VnnLNmLd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hcdTjFp9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dXHEJmqi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FHJbqhrD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VnnLNmLd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hcdTjFp9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dXHEJmqi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E81621D04;
	Wed,  2 Sep 2026 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JBUo3ME3wyI0ZQVmNX5h+I+76TaDLBdEGr+wyuCbIwM=;
	b=FHJbqhrD+xjUn2UYuoV7SiD/V2XFZHvASzTkjf2r7FlFe1AS9erAnAnezaGMDKvrKs3euH
	yX24QkHrQaicy5QV62E++ujy/mDG6+rQKj1JnsGsERqHa4Ch9ftnKFvYhlykvvljKyKtC3
	RreVAGXD0zLe4P1Ks2YV/UNpa5vnLXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JBUo3ME3wyI0ZQVmNX5h+I+76TaDLBdEGr+wyuCbIwM=;
	b=VnnLNmLdxBzvk0HMn1LHVd9oEew09Rczar9OW+bqeMWYacQc+dZ+ZRixV2P4V6Gdvzq9+d
	FfpVS9yUGShcqsCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hcdTjFp9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dXHEJmqi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JBUo3ME3wyI0ZQVmNX5h+I+76TaDLBdEGr+wyuCbIwM=;
	b=hcdTjFp9jGoJRMGIPqNQha4hMuFI4Mbqhw2o56o9NgHtZKtI+TUf7xXGtY5hI/52uqQxmb
	Sm6uHJYptxCZiedWNujXJEOSHk73LoQNZ58L4T2PraU0JDYWAPzCC5rzbbINnXRg5sMNzz
	OhkAYQpxfZ/L3xcn75WmzMx3cMoVvMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JBUo3ME3wyI0ZQVmNX5h+I+76TaDLBdEGr+wyuCbIwM=;
	b=dXHEJmqisjICJkHYHRdG45p2P+afUua/u26dYOQ2Hd3A5BkaYUhxlgOtrYy6uMYClTi6u0
	8A1JzVtOCKbTUgCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38467136E6;
	Wed,  2 Sep 2026 14:20:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BR67DcMwmGonDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:20:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ABCCAA13B5; Wed, 02 Sep 2026 16:20:46 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:20:46 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Seth Forshee <sforshee@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	linux-security-module@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, 
	linux-integrity@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/27] fs: port inode_init_owner() to const mnt_idmap
Message-ID: <qm22joel424oc3pwaj573csesua6myjyniv44mefhn6jh4farg@w2zb2dh4iftw>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-10-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-10-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 5E81621D04
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:35, Christian Brauner wrote:
> Convert to const struct mnt_idmap.
> 
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/btrfs_inode.h         |  2 +-
>  fs/btrfs/inode.c               |  6 +++---
>  fs/btrfs/ioctl.c               |  2 +-
>  fs/ext4/ext4.h                 |  2 +-
>  fs/ext4/ialloc.c               |  2 +-
>  fs/ext4/namei.c                |  4 ++--
>  fs/f2fs/f2fs.h                 |  2 +-
>  fs/f2fs/namei.c                | 10 +++++-----
>  fs/hugetlbfs/inode.c           |  2 +-
>  fs/inode.c                     |  4 ++--
>  fs/namei.c                     |  2 +-
>  fs/overlayfs/dir.c             |  2 +-
>  fs/xfs/libxfs/xfs_inode_util.h |  2 +-
>  fs/xfs/xfs_inode.c             |  4 ++--
>  fs/xfs/xfs_inode.h             |  2 +-
>  fs/xfs/xfs_iops.c              |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  fs/xfs/xfs_symlink.h           |  2 +-
>  include/linux/fs.h             |  4 ++--
>  mm/shmem.c                     |  8 ++++----
>  20 files changed, 33 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1082fa92c145..26ce5319c7fc 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -559,7 +559,7 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>  			   struct btrfs_new_inode_args *args);
>  void btrfs_new_inode_args_destroy(struct btrfs_new_inode_args *args);
> -struct inode *btrfs_new_subvol_inode(struct mnt_idmap *idmap,
> +struct inode *btrfs_new_subvol_inode(const struct mnt_idmap *idmap,
>  				     struct inode *dir);
>   void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *state,
>  			        u32 bits);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3c10a0ef0002..d5a78d9027e2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8022,7 +8022,7 @@ static int btrfs_truncate(struct btrfs_inode *inode, bool skip_writeback)
>  	return ret;
>  }
>  
> -struct inode *btrfs_new_subvol_inode(struct mnt_idmap *idmap,
> +struct inode *btrfs_new_subvol_inode(const struct mnt_idmap *idmap,
>  				     struct inode *dir)
>  {
>  	struct inode *inode;
> @@ -8540,7 +8540,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
>  	return ret;
>  }
>  
> -static struct inode *new_whiteout_inode(struct mnt_idmap *idmap,
> +static struct inode *new_whiteout_inode(const struct mnt_idmap *idmap,
>  					struct inode *dir)
>  {
>  	struct inode *inode;
> @@ -8555,7 +8555,7 @@ static struct inode *new_whiteout_inode(struct mnt_idmap *idmap,
>  	return inode;
>  }
>  
> -static int btrfs_rename(struct mnt_idmap *idmap,
> +static int btrfs_rename(const struct mnt_idmap *idmap,
>  			struct inode *old_dir, struct dentry *old_dentry,
>  			struct inode *new_dir, struct dentry *new_dentry,
>  			unsigned int flags)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b34c6a8247e4..8eacdc2ee4de 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -534,7 +534,7 @@ static unsigned int create_subvol_num_items(const struct btrfs_qgroup_inherit *i
>  	return num_items;
>  }
>  
> -static noinline int create_subvol(struct mnt_idmap *idmap,
> +static noinline int create_subvol(const struct mnt_idmap *idmap,
>  				  struct inode *dir, struct dentry *dentry,
>  				  struct btrfs_qgroup_inherit *inherit)
>  {
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..aef86b1d10fa 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3044,7 +3044,7 @@ extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
>  
>  /* ialloc.c */
>  extern int ext4_mark_inode_used(struct super_block *sb, int ino);
> -extern struct inode *__ext4_new_inode(struct mnt_idmap *, handle_t *,
> +extern struct inode *__ext4_new_inode(const struct mnt_idmap *, handle_t *,
>  				      struct inode *, umode_t,
>  				      const struct qstr *qstr, __u32 goal,
>  				      uid_t *owner, __u32 i_flags,
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a5831fc536db..529623103ae7 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -930,7 +930,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
>   * For other inodes, search forward from the parent directory's block
>   * group to find a free inode.
>   */
> -struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
> +struct inode *__ext4_new_inode(const struct mnt_idmap *idmap,
>  			       handle_t *handle, struct inode *dir,
>  			       umode_t mode, const struct qstr *qstr,
>  			       __u32 goal, uid_t *owner, __u32 i_flags,
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a6386c1d237f..edc12599e64d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3753,7 +3753,7 @@ static void ext4_update_dir_count(handle_t *handle, struct ext4_renament *ent)
>  	}
>  }
>  
> -static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
> +static struct inode *ext4_whiteout_for_rename(const struct mnt_idmap *idmap,
>  					      struct ext4_renament *ent,
>  					      int credits, handle_t **h)
>  {
> @@ -3796,7 +3796,7 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
>   * while new_{dentry,inode) refers to the destination dentry/inode
>   * This comes from rename(const char *oldpath, const char *newpath)
>   */
> -static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
> +static int ext4_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
>  		       struct dentry *old_dentry, struct inode *new_dir,
>  		       struct dentry *new_dentry, unsigned int flags)
>  {
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 9940a6cecf1a..eefc886e3ffc 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3890,7 +3890,7 @@ void f2fs_destroy_evict_inode_work(void);
>  int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
>  							bool hot, bool set);
>  struct dentry *f2fs_get_parent(struct dentry *child);
> -int f2fs_get_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +int f2fs_get_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		     struct inode **new_inode);
>  
>  /*
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index ff86ee07290d..e33780294713 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -231,7 +231,7 @@ static void set_file_temperature(struct f2fs_sb_info *sbi, struct inode *inode,
>  		file_set_hot(inode);
>  }
>  
> -static struct inode *f2fs_new_inode(struct mnt_idmap *idmap,
> +static struct inode *f2fs_new_inode(const struct mnt_idmap *idmap,
>  						struct inode *dir, umode_t mode,
>  						const char *name)
>  {
> @@ -857,7 +857,7 @@ static int f2fs_mknod(struct mnt_idmap *idmap, struct inode *dir,
>  	return err;
>  }
>  
> -static int __f2fs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int __f2fs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			  struct file *file, umode_t mode, bool is_whiteout,
>  			  struct inode **new_inode, struct f2fs_filename *fname)
>  {
> @@ -944,7 +944,7 @@ static int f2fs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
>  	return finish_open_simple(file, err);
>  }
>  
> -static int f2fs_create_whiteout(struct mnt_idmap *idmap,
> +static int f2fs_create_whiteout(const struct mnt_idmap *idmap,
>  				struct inode *dir, struct inode **whiteout,
>  				struct f2fs_filename *fname)
>  {
> @@ -952,14 +952,14 @@ static int f2fs_create_whiteout(struct mnt_idmap *idmap,
>  						true, whiteout, fname);
>  }
>  
> -int f2fs_get_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +int f2fs_get_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		     struct inode **new_inode)
>  {
>  	return __f2fs_tmpfile(idmap, dir, NULL, S_IFREG,
>  				false, new_inode, NULL);
>  }
>  
> -static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
> +static int f2fs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
>  			struct dentry *old_dentry, struct inode *new_dir,
>  			struct dentry *new_dentry, unsigned int flags)
>  {
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7611a8470ea2..4bd3adc20a47 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -892,7 +892,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
>  static struct lock_class_key hugetlbfs_i_mmap_rwsem_key;
>  
>  static struct inode *hugetlbfs_get_inode(struct super_block *sb,
> -					struct mnt_idmap *idmap,
> +					const struct mnt_idmap *idmap,
>  					struct inode *dir,
>  					umode_t mode, dev_t dev)
>  {
> diff --git a/fs/inode.c b/fs/inode.c
> index 4313e9735c5c..99f1aab89eae 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2716,7 +2716,7 @@ EXPORT_SYMBOL(init_special_inode);
>   * and initializing i_uid and i_gid. On non-idmapped mounts or if permission
>   * checking is to be performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
> +void inode_init_owner(const struct mnt_idmap *idmap, struct inode *inode,
>  		      const struct inode *dir, umode_t mode)
>  {
>  	inode_fsuid_set(inode, idmap);
> @@ -3058,7 +3058,7 @@ EXPORT_SYMBOL(in_group_or_capable);
>   *
>   * Return: the new mode to use for the file
>   */
> -umode_t mode_strip_sgid(struct mnt_idmap *idmap,
> +umode_t mode_strip_sgid(const struct mnt_idmap *idmap,
>  			const struct inode *dir, umode_t mode)
>  {
>  	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
> diff --git a/fs/namei.c b/fs/namei.c
> index 603d43e4a961..db82daec3646 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4142,7 +4142,7 @@ EXPORT_SYMBOL(end_renaming);
>   *
>   * Returns: mode to be passed to the filesystem
>   */
> -static inline umode_t vfs_prepare_mode(struct mnt_idmap *idmap,
> +static inline umode_t vfs_prepare_mode(const struct mnt_idmap *idmap,
>  				       const struct inode *dir, umode_t mode,
>  				       umode_t mask_perms, umode_t type)
>  {
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 7beb0af26498..a022dc7781bf 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -688,7 +688,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>  	return err;
>  }
>  
> -static int ovl_create_object(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int ovl_create_object(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			     int mode, dev_t rdev, const char *link)
>  {
>  	int err;
> diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
> index 060242998a23..e9eac35159c3 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.h
> +++ b/fs/xfs/libxfs/xfs_inode_util.h
> @@ -27,7 +27,7 @@ prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
>   * idmap to NULL.  To create a tree root, set pip to NULL.
>   */
>  struct xfs_icreate_args {
> -	struct mnt_idmap	*idmap;
> +	const struct mnt_idmap	*idmap;
>  	struct xfs_inode	*pip;	/* parent inode or null */
>  	dev_t			rdev;
>  	umode_t			mode;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 030a7c8f2c12..6fcd1c5928f8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2084,7 +2084,7 @@ xfs_sort_inodes(
>   */
>  static int
>  xfs_rename_alloc_whiteout(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct xfs_name		*src_name,
>  	struct xfs_inode	*dp,
>  	struct xfs_inode	**wip)
> @@ -2130,7 +2130,7 @@ xfs_rename_alloc_whiteout(
>   */
>  int
>  xfs_rename(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct xfs_inode	*src_dp,
>  	struct xfs_name		*src_name,
>  	struct xfs_inode	*src_ip,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 34c1038ebfcd..12bc4573c52d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -568,7 +568,7 @@ int		xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
>  			   struct xfs_inode *ip);
>  int		xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
>  			 struct xfs_name *target_name);
> -int		xfs_rename(struct mnt_idmap *idmap,
> +int		xfs_rename(const struct mnt_idmap *idmap,
>  			   struct xfs_inode *src_dp, struct xfs_name *src_name,
>  			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
>  			   struct xfs_name *target_name,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 4a3299abf774..df5e7c1b2334 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -169,7 +169,7 @@ xfs_create_need_xattr(
>  
>  STATIC int
>  xfs_generic_create(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct inode		*dir,
>  	struct dentry		*dentry,
>  	umode_t			mode,
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 5585ac7f4d16..40a9bb1703b5 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -82,7 +82,7 @@ xfs_readlink(
>  
>  int
>  xfs_symlink(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct xfs_inode	*dp,
>  	struct xfs_name		*link_name,
>  	const char		*target_path,
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index 0d29a50e66fd..3c5a969f9fc5 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -7,7 +7,7 @@
>  
>  /* Kernel only symlink definitions */
>  
> -int xfs_symlink(struct mnt_idmap *idmap, struct xfs_inode *dp,
> +int xfs_symlink(const struct mnt_idmap *idmap, struct xfs_inode *dp,
>  		struct xfs_name *link_name, const char *target_path,
>  		umode_t mode, struct xfs_inode **ipp);
>  int xfs_readlink(struct xfs_inode *ip, char *link);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e2babddf755d..91a23c8dbbf6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1830,10 +1830,10 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
>  /*
>   * VFS file helper functions.
>   */
> -void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
> +void inode_init_owner(const struct mnt_idmap *idmap, struct inode *inode,
>  		      const struct inode *dir, umode_t mode);
>  extern bool may_open_dev(const struct path *path);
> -umode_t mode_strip_sgid(struct mnt_idmap *idmap,
> +umode_t mode_strip_sgid(const struct mnt_idmap *idmap,
>  			const struct inode *dir, umode_t mode);
>  bool in_group_or_capable(const struct mnt_idmap *idmap,
>  			 const struct inode *inode, vfsgid_t vfsgid);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 897fa2b61346..9ab5231c4dfe 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3022,7 +3022,7 @@ static struct offset_ctx *shmem_get_offset_ctx(struct inode *inode)
>  	return &SHMEM_I(inode)->dir_offsets;
>  }
>  
> -static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
> +static struct inode *__shmem_get_inode(const struct mnt_idmap *idmap,
>  				       struct super_block *sb,
>  				       struct inode *dir, umode_t mode,
>  				       dev_t dev, vma_flags_t flags)
> @@ -3102,7 +3102,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  }
>  
>  #ifdef CONFIG_TMPFS_QUOTA
> -static struct inode *shmem_get_inode(struct mnt_idmap *idmap,
> +static struct inode *shmem_get_inode(const struct mnt_idmap *idmap,
>  				     struct super_block *sb, struct inode *dir,
>  				     umode_t mode, dev_t dev, vma_flags_t flags)
>  {
> @@ -3130,7 +3130,7 @@ static struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>  	return ERR_PTR(err);
>  }
>  #else
> -static struct inode *shmem_get_inode(struct mnt_idmap *idmap,
> +static struct inode *shmem_get_inode(const struct mnt_idmap *idmap,
>  				     struct super_block *sb, struct inode *dir,
>  				     umode_t mode, dev_t dev, vma_flags_t flags)
>  {
> @@ -5792,7 +5792,7 @@ static inline void shmem_unacct_size(unsigned long flags, loff_t size)
>  {
>  }
>  
> -static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
> +static inline struct inode *shmem_get_inode(const struct mnt_idmap *idmap,
>  				struct super_block *sb, struct inode *dir,
>  				umode_t mode, dev_t dev, vma_flags_t flags)
>  {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
