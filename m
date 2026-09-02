Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88E366042;
	Wed,  2 Sep 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363793; cv=none; b=i/RKM6PG+TWMz6Tk7X2cr5TQs7+180of/TzZCRKPx7ZBGDbuUQjGnK47GHABW2yQYpkUlOQDL8+aMuGUuvl9n5fwIgW45koGM68iZwme3gHHn7RSrkYRuaJ7mQT+tA3voFCOPKfhWHgZ5ICilv8Qe8Mld1pumvz5Du/JXrmVu5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363793; c=relaxed/simple;
	bh=Iij8gMh5z6lo4uc8kaJeIvV/ZAqgrNHNokT86C5nz0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRjgjI8nVd0xAnC7hdy5fxrJ2r53cvqc8tTX+1321akg2SwrWyIWhEQL8oBNDh4vVT59uPg8mOfawKd5UsJGICDs2BNTkuESrc9ArZVLWfDABNlmDt3Hvr2duA08BlprhU+wqSeZ9P864ZQ5DDCJvbYrlTrR/LSUcoyHcQca9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Zb8jn5f; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zNX1Oc4B; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ck+2N2ef; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XpPjwqr3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Zb8jn5f";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zNX1Oc4B";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ck+2N2ef";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XpPjwqr3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9379C1FAB5;
	Wed,  2 Sep 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pFDJP2xSLNpyYdjWrY//4H5cIu9vsO7oMMrNqNE2FU=;
	b=3Zb8jn5fygc+ExnQbo7R7ekkFI+lM25Rz5Bqj0G2zXai9dl3rcCsuCkoxIq7VtnDbuDj+a
	Hp4o7JVosa4XFkYfAyg1LMA/TtBkrGVuqc43BTzI5pcjE2yI7T6PLJSQI9I6hVO9J7LOAK
	7PRD7VCL1mbIdylXc8UAuYRGs4g0l+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pFDJP2xSLNpyYdjWrY//4H5cIu9vsO7oMMrNqNE2FU=;
	b=zNX1Oc4BNUMloEo4Lt3sXfhfm6QUeq9ytM/Xr9pZO2xRNTarqdNAj4IoZXnSx8hlXBHspl
	/ms+kXw5HyLy/ODQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ck+2N2ef;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XpPjwqr3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pFDJP2xSLNpyYdjWrY//4H5cIu9vsO7oMMrNqNE2FU=;
	b=Ck+2N2efUtT/qNe/OaZ+xzS4vIQr3MawoqiT9Ob9qqtvgkVFL2+LAN0mnNKyx9uBPwCtwI
	/Gh7YhCja2AxSfM62HGRehof6fgS6C03pKnqO2AOzRxUyBNBepTZ8hVQTHeEmnOL/dcshg
	iWsbGrCmcJJvpbkFgwERN0dIBATf0Lw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pFDJP2xSLNpyYdjWrY//4H5cIu9vsO7oMMrNqNE2FU=;
	b=XpPjwqr3aZ8lUYxQSbEmQWeLfYTszQEW1jz5jAq2EPzcPSNPzVAtEreGVvia2siNKQNOF4
	m+dlovN/p9M/eOBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EBB213515;
	Wed,  2 Sep 2026 15:43:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SYFGwREmGp2YgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:43:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 18E84A13B5; Wed, 02 Sep 2026 17:43:00 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:43:00 +0200
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
Subject: Re: [PATCH 14/27] fs: port ->fileattr_set() to pass const mnt_idmap
Message-ID: <qjq5iaeztvfthhdayssvz2ay52wyz2vso3bya5coslooo6nzsm@vr52zm2wkzyh>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-14-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-14-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 9379C1FAB5
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

On Tue 01-09-26 14:14:39, Christian Brauner wrote:
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
>  Documentation/filesystems/locking.rst | 2 +-
>  Documentation/filesystems/vfs.rst     | 2 +-
>  fs/btrfs/ioctl.c                      | 2 +-
>  fs/btrfs/ioctl.h                      | 2 +-
>  fs/ecryptfs/inode.c                   | 2 +-
>  fs/efivarfs/inode.c                   | 2 +-
>  fs/ext2/ext2.h                        | 2 +-
>  fs/ext2/ioctl.c                       | 2 +-
>  fs/ext4/ext4.h                        | 2 +-
>  fs/ext4/ioctl.c                       | 2 +-
>  fs/f2fs/f2fs.h                        | 2 +-
>  fs/f2fs/file.c                        | 2 +-
>  fs/file_attr.c                        | 2 +-
>  fs/fuse/fuse_i.h                      | 2 +-
>  fs/fuse/ioctl.c                       | 2 +-
>  fs/gfs2/file.c                        | 2 +-
>  fs/gfs2/inode.h                       | 2 +-
>  fs/hfsplus/hfsplus_fs.h               | 2 +-
>  fs/hfsplus/inode.c                    | 2 +-
>  fs/jfs/ioctl.c                        | 2 +-
>  fs/jfs/jfs_inode.h                    | 2 +-
>  fs/nilfs2/ioctl.c                     | 2 +-
>  fs/nilfs2/nilfs.h                     | 2 +-
>  fs/ntfs3/file.c                       | 2 +-
>  fs/ntfs3/ntfs_fs.h                    | 2 +-
>  fs/ocfs2/ioctl.c                      | 2 +-
>  fs/ocfs2/ioctl.h                      | 2 +-
>  fs/orangefs/inode.c                   | 2 +-
>  fs/overlayfs/inode.c                  | 2 +-
>  fs/overlayfs/overlayfs.h              | 2 +-
>  fs/ubifs/ioctl.c                      | 2 +-
>  fs/ubifs/ubifs.h                      | 2 +-
>  fs/xfs/xfs_ioctl.c                    | 2 +-
>  fs/xfs/xfs_ioctl.h                    | 2 +-
>  include/linux/fileattr.h              | 2 +-
>  include/linux/fs.h                    | 2 +-
>  mm/shmem.c                            | 2 +-
>  37 files changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 2a91bc9c15f5..b95cd4992896 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -88,7 +88,7 @@ prototypes::
>  				umode_t create_mode);
>  	int (*tmpfile) (struct mnt_idmap *, struct inode *,
>  			struct file *, umode_t);
> -	int (*fileattr_set)(struct mnt_idmap *idmap,
> +	int (*fileattr_set)(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct file_kattr *fa);
>  	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
>  	struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index b7e476f70185..c43bad400c30 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -441,7 +441,7 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
>  		struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
>  	        int (*set_acl)(struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
> -		int (*fileattr_set)(struct mnt_idmap *idmap,
> +		int (*fileattr_set)(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry, struct file_kattr *fa);
>  		int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
>  	        struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d6302547b12..94c98801800f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -278,7 +278,7 @@ int btrfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int btrfs_fileattr_set(struct mnt_idmap *idmap,
> +int btrfs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index ccf6bed9cc24..55f86aeb3500 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -17,7 +17,7 @@ struct btrfs_ioctl_balance_args;
>  long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  long btrfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  int btrfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int btrfs_fileattr_set(struct mnt_idmap *idmap,
> +int btrfs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa);
>  int btrfs_ioctl_get_supported_features(void __user *arg);
>  void btrfs_sync_inode_flags_to_i_flags(struct btrfs_inode *inode);
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 691b3a24b60a..b9c32e8f855a 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -1078,7 +1078,7 @@ static int ecryptfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return vfs_fileattr_get(ecryptfs_dentry_to_lower(dentry), fa);
>  }
>  
> -static int ecryptfs_fileattr_set(struct mnt_idmap *idmap,
> +static int ecryptfs_fileattr_set(const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index f0d009555fc6..f7dcd72e4a07 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -150,7 +150,7 @@ efivarfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  }
>  
>  static int
> -efivarfs_fileattr_set(struct mnt_idmap *idmap,
> +efivarfs_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	unsigned int i_flags = 0;
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 5642451bf191..702cb7aa1afd 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -748,7 +748,7 @@ extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  
>  /* ioctl.c */
>  extern int ext2_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -extern int ext2_fileattr_set(struct mnt_idmap *idmap,
> +extern int ext2_fileattr_set(const struct mnt_idmap *idmap,
>  			     struct dentry *dentry, struct file_kattr *fa);
>  extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
>  extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
> diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
> index c3fea55b8efa..f2218455fa47 100644
> --- a/fs/ext2/ioctl.c
> +++ b/fs/ext2/ioctl.c
> @@ -27,7 +27,7 @@ int ext2_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int ext2_fileattr_set(struct mnt_idmap *idmap,
> +int ext2_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index aef86b1d10fa..2c9a845ed0f8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3246,7 +3246,7 @@ extern int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  /* ioctl.c */
>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
>  extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
> -int ext4_fileattr_set(struct mnt_idmap *idmap,
> +int ext4_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa);
>  int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
>  extern void ext4_reset_inode_seed(struct inode *inode);
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 6de77da4203c..2719f20493c8 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1008,7 +1008,7 @@ int ext4_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int ext4_fileattr_set(struct mnt_idmap *idmap,
> +int ext4_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index eefc886e3ffc..245df8563256 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3858,7 +3858,7 @@ int f2fs_do_shutdown(struct f2fs_sb_info *sbi, unsigned int flag,
>  						bool readonly, bool need_lock);
>  int f2fs_precache_extents(struct inode *inode);
>  int f2fs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int f2fs_fileattr_set(struct mnt_idmap *idmap,
> +int f2fs_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa);
>  long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
>  long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 03bb3a9a449f..d0cc2ca1397a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -3580,7 +3580,7 @@ int f2fs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int f2fs_fileattr_set(struct mnt_idmap *idmap,
> +int f2fs_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index bfb00d256dd5..5393c4dfa4a8 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -265,7 +265,7 @@ static int fileattr_set_prepare(struct inode *inode,
>   *
>   * Return: 0 on success, or a negative error on failure.
>   */
> -int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		     struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 9ea346ea2e01..6ca56757869c 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1238,7 +1238,7 @@ long fuse_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
>  			    unsigned long arg);
>  int fuse_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int fuse_fileattr_set(struct mnt_idmap *idmap,
> +int fuse_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa);
>  
>  /* iomode.c */
> diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
> index 3614ea603913..3ee45b2e148f 100644
> --- a/fs/fuse/ioctl.c
> +++ b/fs/fuse/ioctl.c
> @@ -540,7 +540,7 @@ int fuse_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return err;
>  }
>  
> -int fuse_fileattr_set(struct mnt_idmap *idmap,
> +int fuse_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index b8c10de113ba..9487625a4166 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -275,7 +275,7 @@ static int do_gfs2_set_flags(struct inode *inode, u32 reqflags, u32 mask)
>  	return error;
>  }
>  
> -int gfs2_fileattr_set(struct mnt_idmap *idmap,
> +int gfs2_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
> index 373473eb091c..99196d3114e4 100644
> --- a/fs/gfs2/inode.h
> +++ b/fs/gfs2/inode.h
> @@ -109,7 +109,7 @@ extern const struct file_operations gfs2_file_fops_nolock;
>  extern const struct file_operations gfs2_dir_fops_nolock;
>  
>  int gfs2_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int gfs2_fileattr_set(struct mnt_idmap *idmap,
> +int gfs2_fileattr_set(const struct mnt_idmap *idmap,
>  		      struct dentry *dentry, struct file_kattr *fa);
>  void gfs2_set_inode_flags(struct inode *inode);
>  
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 1e5b58e6a13f..86fc1c1cdfd6 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -465,7 +465,7 @@ int hfsplus_getattr(struct mnt_idmap *idmap, const struct path *path,
>  int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
>  		       int datasync);
>  int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int hfsplus_fileattr_set(struct mnt_idmap *idmap,
> +int hfsplus_fileattr_set(const struct mnt_idmap *idmap,
>  			 struct dentry *dentry, struct file_kattr *fa);
>  
>  /* ioctl.c */
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index 2ce6de574fa6..9821662bfc1d 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -797,7 +797,7 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int hfsplus_fileattr_set(struct mnt_idmap *idmap,
> +int hfsplus_fileattr_set(const struct mnt_idmap *idmap,
>  			 struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
> index 563f148be8af..27d39cddaca6 100644
> --- a/fs/jfs/ioctl.c
> +++ b/fs/jfs/ioctl.c
> @@ -70,7 +70,7 @@ int jfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int jfs_fileattr_set(struct mnt_idmap *idmap,
> +int jfs_fileattr_set(const struct mnt_idmap *idmap,
>  		     struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
> index 2c6c81c8cb9f..88cfc3886282 100644
> --- a/fs/jfs/jfs_inode.h
> +++ b/fs/jfs/jfs_inode.h
> @@ -10,7 +10,7 @@ struct fid;
>  extern struct inode *ialloc(struct inode *, umode_t);
>  extern int jfs_fsync(struct file *, loff_t, loff_t, int);
>  extern int jfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -extern int jfs_fileattr_set(struct mnt_idmap *idmap,
> +extern int jfs_fileattr_set(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct file_kattr *fa);
>  extern long jfs_ioctl(struct file *, unsigned int, unsigned long);
>  extern struct inode *jfs_iget(struct super_block *, unsigned long);
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 01a04080ef70..f56a79767c69 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -135,7 +135,7 @@ int nilfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>   *
>   * Return: 0 on success, or a negative error code on failure.
>   */
> -int nilfs_fileattr_set(struct mnt_idmap *idmap,
> +int nilfs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 0eaa191f70b8..829df7be11fe 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -270,7 +270,7 @@ extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
>  
>  /* ioctl.c */
>  int nilfs_fileattr_get(struct dentry *dentry, struct file_kattr *m);
> -int nilfs_fileattr_set(struct mnt_idmap *idmap,
> +int nilfs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa);
>  long nilfs_ioctl(struct file *, unsigned int, unsigned long);
>  long nilfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> index 2abf334bfa0c..f7baa202dc28 100644
> --- a/fs/ntfs3/file.c
> +++ b/fs/ntfs3/file.c
> @@ -129,7 +129,7 @@ int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  /*
>   * ntfs_fileattr_set - inode_operations::fileattr_set
>   */
> -int ntfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index a2b74f41048f..e494bed87679 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -551,7 +551,7 @@ extern const struct file_operations ntfs_dir_operations;
>  
>  /* Globals from file.c */
>  int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int ntfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct file_kattr *fa);
>  int ntfs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, u32 flags);
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index cbe59d231666..36c7c9ac8b5d 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -82,7 +82,7 @@ int ocfs2_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return status;
>  }
>  
> -int ocfs2_fileattr_set(struct mnt_idmap *idmap,
> +int ocfs2_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
> index 4a1c2313b429..b1cb529fc5f9 100644
> --- a/fs/ocfs2/ioctl.h
> +++ b/fs/ocfs2/ioctl.h
> @@ -12,7 +12,7 @@
>  #define OCFS2_IOCTL_PROTO_H
>  
>  int ocfs2_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int ocfs2_fileattr_set(struct mnt_idmap *idmap,
> +int ocfs2_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa);
>  long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
>  long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index 8e6eeec501bc..536d5e842c55 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -934,7 +934,7 @@ static int orangefs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -static int orangefs_fileattr_set(struct mnt_idmap *idmap,
> +static int orangefs_fileattr_set(const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, struct file_kattr *fa)
>  {
>  	u64 val = 0;
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 1166381f1852..5f4e8b6d9722 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -650,7 +650,7 @@ int ovl_real_fileattr_set(const struct path *realpath, struct file_kattr *fa)
>  	return vfs_fileattr_set(mnt_idmap(realpath->mnt), realpath->dentry, fa);
>  }
>  
> -int ovl_fileattr_set(struct mnt_idmap *idmap,
> +int ovl_fileattr_set(const struct mnt_idmap *idmap,
>  		     struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 513ba93c7d1b..46a5cf5dae4c 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -914,7 +914,7 @@ extern const struct file_operations ovl_file_operations;
>  int ovl_real_fileattr_get(const struct path *realpath, struct file_kattr *fa);
>  int ovl_real_fileattr_set(const struct path *realpath, struct file_kattr *fa);
>  int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int ovl_fileattr_set(struct mnt_idmap *idmap,
> +int ovl_fileattr_set(const struct mnt_idmap *idmap,
>  		     struct dentry *dentry, struct file_kattr *fa);
>  struct ovl_file;
>  struct ovl_file *ovl_file_alloc(struct file *realfile);
> diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
> index 79536b2e3d7a..5c34f895bd4e 100644
> --- a/fs/ubifs/ioctl.c
> +++ b/fs/ubifs/ioctl.c
> @@ -144,7 +144,7 @@ int ubifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int ubifs_fileattr_set(struct mnt_idmap *idmap,
> +int ubifs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index 00db0d19a85e..af0ef3583aeb 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -2083,7 +2083,7 @@ void ubifs_destroy_size_tree(struct ubifs_info *c);
>  
>  /* ioctl.c */
>  int ubifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int ubifs_fileattr_set(struct mnt_idmap *idmap,
> +int ubifs_fileattr_set(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, struct file_kattr *fa);
>  long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  void ubifs_set_inode_flags(struct inode *inode);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1b53701bebea..0df67f0d573c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -748,7 +748,7 @@ xfs_ioctl_setattr_check_projid(
>  
>  int
>  xfs_fileattr_set(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct dentry		*dentry,
>  	struct file_kattr	*fa)
>  {
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index f5ed5cf9d3df..70c26cb05eb6 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -21,7 +21,7 @@ xfs_fileattr_get(
>  
>  extern int
>  xfs_fileattr_set(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct dentry		*dentry,
>  	struct file_kattr	*fa);
>  
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 58044b598016..09e32b84e02a 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -74,7 +74,7 @@ static inline bool fileattr_has_fsx(const struct file_kattr *fa)
>  }
>  
>  int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		     struct file_kattr *fa);
>  int ioctl_getflags(struct file *file, unsigned int __user *argp);
>  int ioctl_setflags(struct file *file, unsigned int __user *argp);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 08166900931a..764ef2d97a5d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2030,7 +2030,7 @@ struct inode_operations {
>  				     int);
>  	int (*set_acl)(struct mnt_idmap *, struct dentry *,
>  		       struct posix_acl *, int);
> -	int (*fileattr_set)(struct mnt_idmap *idmap,
> +	int (*fileattr_set)(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct file_kattr *fa);
>  	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
>  	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ed633b3bc38d..097699ea2762 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4159,7 +4159,7 @@ static int shmem_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -static int shmem_fileattr_set(struct mnt_idmap *idmap,
> +static int shmem_fileattr_set(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, struct file_kattr *fa)
>  {
>  	struct inode *inode = d_inode(dentry);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
