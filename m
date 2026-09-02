Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCB64A440F;
	Wed,  2 Sep 2026 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364063; cv=none; b=nTXBVyILDAImGDm5dbOR+B3xvYVMrsH0F5L71KlIhc2j+dGlU9NCOFVOlLZ30SZ7uQKohbxLhhvD/M7UDj+XC4U3Ala5g0qd2HQCIZ9phu6hRIESQn2qF4hG+4o9Ea3pvu5GEKaNMwqIMvIlcOgOdnTAUQhrgBk34DDRVGLVelo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364063; c=relaxed/simple;
	bh=Z0fX+wgbIeEzEfNrqvL5RCMpjm9qoAjfTb+vmSdbDjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWV987RC+bHAoG6CTi0V0xVrVbBepelqOzINNA8j1SC5DivlOe/d02tamsRvwiaS8IwRvkYyZC8mrfq1MOsPqBYNAPHNppAJCwoKqbHmP/L6080czcOsrjK6TLXXG0Un4PGzdp2sw7lDZgniW/K//3liPh1mdl92DjUAZlgfgv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s7gNbYa+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DZUyr04F; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ndJUPKED; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kTM8+ZnE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s7gNbYa+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DZUyr04F";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ndJUPKED";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kTM8+ZnE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2099A21D7C;
	Wed,  2 Sep 2026 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IO//pErO82MWEC8YATAMzSM5u7FPofhkdNzDgTkZL/I=;
	b=s7gNbYa+GAmqFcU2hVhE9eeNeh4AoGPrNo8yFkCMDGtOwBDsASClBCU3Y4pxiKIl6s1pOx
	Ws5QQt3JBhmbZBmc5MkDPNjghzOKr+W9t4MIAP2+MHwh8pY7MTNn1VBU3vWxmwoq+AN6tj
	em6hyli7KiFZvKaAJ2lveI5zAhPYMGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IO//pErO82MWEC8YATAMzSM5u7FPofhkdNzDgTkZL/I=;
	b=DZUyr04F9dkqwlyPOVl3joE6paflfyGn7Gi8NRF/2OjZTW7z5o90nNTmqQ2HGTnm0geycm
	84NnoQfTJ4rf1jAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IO//pErO82MWEC8YATAMzSM5u7FPofhkdNzDgTkZL/I=;
	b=ndJUPKEDRVCHdldPff4tH5azwBb1FKWoozqYK3rOq88lT35sgFJhGq6TydsiniJ/rKiUU5
	/+ro/+kinbm06GouC9qnpzPQEtRo6JYmenYYNfJ3aB2+MILL+XOoQhZowW8vtgWscQ086g
	E1GiQ3GWPD1fn5NF7jk6awhwVPrgFoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IO//pErO82MWEC8YATAMzSM5u7FPofhkdNzDgTkZL/I=;
	b=kTM8+ZnEuZyjpMLSqIdbwayfjMRphoYkjeMSEcgZtFBSPU93ku++n67jOmbTyRq76Hw6GW
	/mtOsb0+cWIjMiCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F21E113515;
	Wed,  2 Sep 2026 15:47:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5fgaOxFFmGpwZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:47:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9BF53A13B5; Wed, 02 Sep 2026 17:47:25 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:47:25 +0200
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
Subject: Re: [PATCH 17/27] fs: port ->tmpfile() to pass const mnt_idmap
Message-ID: <cevke2xhnjojn6z6aas4t2byaixyfwndcyxbx5jrrshoihvh6p@o6v6xgb7kjl4>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-17-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-17-54ccd48e100b@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:42, Christian Brauner wrote:
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
>  fs/bad_inode.c                        | 2 +-
>  fs/btrfs/inode.c                      | 2 +-
>  fs/ext2/namei.c                       | 2 +-
>  fs/ext4/namei.c                       | 2 +-
>  fs/f2fs/namei.c                       | 2 +-
>  fs/fuse/dir.c                         | 2 +-
>  fs/hugetlbfs/inode.c                  | 2 +-
>  fs/minix/namei.c                      | 2 +-
>  fs/overlayfs/dir.c                    | 2 +-
>  fs/ramfs/inode.c                      | 2 +-
>  fs/smb/client/cifsfs.h                | 2 +-
>  fs/smb/client/dir.c                   | 2 +-
>  fs/ubifs/dir.c                        | 2 +-
>  fs/udf/namei.c                        | 2 +-
>  fs/xfs/xfs_iops.c                     | 2 +-
>  include/linux/fs.h                    | 2 +-
>  include/linux/lsm_hook_defs.h         | 2 +-
>  include/linux/security.h              | 4 ++--
>  mm/shmem.c                            | 2 +-
>  security/integrity/ima/ima_main.c     | 2 +-
>  security/security.c                   | 2 +-
>  23 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 167988321a8c..e4948ddc0a5f 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -86,7 +86,7 @@ prototypes::
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  				struct file *, unsigned open_flag,
>  				umode_t create_mode);
> -	int (*tmpfile) (struct mnt_idmap *, struct inode *,
> +	int (*tmpfile) (const struct mnt_idmap *, struct inode *,
>  			struct file *, umode_t);
>  	int (*fileattr_set)(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct file_kattr *fa);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 6adb1061a9b6..e960257ef14a 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -438,7 +438,7 @@ As of kernel 2.6.22, the following members are defined:
>  		void (*sync_lazytime)(struct inode *inode);
>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
> -		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
> +		int (*tmpfile) (const struct mnt_idmap *, struct inode *, struct file *, umode_t);
>  		struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
>  	        int (*set_acl)(const struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
>  		int (*fileattr_set)(const struct mnt_idmap *idmap,
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 6e116810f66d..d8c0ce62cc63 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -146,7 +146,7 @@ static int bad_inode_atomic_open(struct inode *inode, struct dentry *dentry,
>  	return -EIO;
>  }
>  
> -static int bad_inode_tmpfile(struct mnt_idmap *idmap,
> +static int bad_inode_tmpfile(const struct mnt_idmap *idmap,
>  			     struct inode *inode, struct file *file,
>  			     umode_t mode)
>  {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7bf38f069116..092057508ae9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9391,7 +9391,7 @@ static int btrfs_permission(const struct mnt_idmap *idmap,
>  	return generic_permission(idmap, inode, mask);
>  }
>  
> -static int btrfs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int btrfs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct file *file, umode_t mode)
>  {
>  	struct btrfs_fs_info *fs_info = inode_to_fs_info(dir);
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 8666233ec63b..108dc52cedfc 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -117,7 +117,7 @@ static int ext2_create (struct mnt_idmap * idmap,
>  	return ext2_add_nondir(dentry, inode);
>  }
>  
> -static int ext2_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int ext2_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct file *file, umode_t mode)
>  {
>  	struct inode *inode = ext2_new_inode(dir, mode, NULL);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index edc12599e64d..0bff01fb052a 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2881,7 +2881,7 @@ static int ext4_mknod(struct mnt_idmap *idmap, struct inode *dir,
>  	return err;
>  }
>  
> -static int ext4_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int ext4_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct file *file, umode_t mode)
>  {
>  	handle_t *handle;
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index e33780294713..3adc2345a204 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -928,7 +928,7 @@ static int __f2fs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  	return err;
>  }
>  
> -static int f2fs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int f2fs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct file *file, umode_t mode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 0dbe3c6560f8..14dc9318cd57 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1098,7 +1098,7 @@ static int fuse_create(struct mnt_idmap *idmap, struct inode *dir,
>  	return fuse_mknod(idmap, dir, entry, mode, 0);
>  }
>  
> -static int fuse_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int fuse_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct file *file, umode_t mode)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(dir);
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 4bd3adc20a47..8a07a3f18c05 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -984,7 +984,7 @@ static int hugetlbfs_create(struct mnt_idmap *idmap,
>  	return hugetlbfs_mknod(idmap, dir, dentry, mode | S_IFREG, 0);
>  }
>  
> -static int hugetlbfs_tmpfile(struct mnt_idmap *idmap,
> +static int hugetlbfs_tmpfile(const struct mnt_idmap *idmap,
>  			     struct inode *dir, struct file *file,
>  			     umode_t mode)
>  {
> diff --git a/fs/minix/namei.c b/fs/minix/namei.c
> index 5525ba367ed7..0575dea16a3b 100644
> --- a/fs/minix/namei.c
> +++ b/fs/minix/namei.c
> @@ -50,7 +50,7 @@ static int minix_mknod(struct mnt_idmap *idmap, struct inode *dir,
>  	return add_nondir(dentry, inode);
>  }
>  
> -static int minix_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int minix_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct file *file, umode_t mode)
>  {
>  	struct inode *inode = minix_new_inode(dir, mode);
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index a022dc7781bf..4f3f1e2bafff 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -1420,7 +1420,7 @@ static int ovl_dummy_open(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static int ovl_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int ovl_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct file *file, umode_t mode)
>  {
>  	int err;
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index 0a88ede48e0a..fc9a79af4840 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -163,7 +163,7 @@ static int ramfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  	return error;
>  }
>  
> -static int ramfs_tmpfile(struct mnt_idmap *idmap,
> +static int ramfs_tmpfile(const struct mnt_idmap *idmap,
>  			 struct inode *dir, struct file *file, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 0c85daa8386e..255f478d3a18 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -57,7 +57,7 @@ int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *direntry, umode_t mode);
>  int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
>  		     struct file *file, unsigned int oflags, umode_t mode);
> -int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +int cifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		 struct file *file, umode_t mode);
>  struct dentry *cifs_lookup(struct inode *parent_dir_inode,
>  			   struct dentry *direntry, unsigned int flags);
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 6fa6d48fdfd3..56a3e1966257 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -1059,7 +1059,7 @@ static int set_tmpfile_attr(const unsigned int xid, unsigned int oflags,
>   * The initial dentry state is unhashed-negative.  On success, dentry will
>   * become unhashed-positive by calling d_instantiate().
>   */
> -int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +int cifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		 struct file *file, umode_t mode)
>  {
>  	struct dentry *dentry = file->f_path.dentry;
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 23ec924162d6..0e1a4de9bb18 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -440,7 +440,7 @@ static void unlock_2_inodes(struct inode *inode1, struct inode *inode2)
>  	mutex_unlock(&ubifs_inode(inode1)->ui_mutex);
>  }
>  
> -static int ubifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int ubifs_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct file *file, umode_t mode)
>  {
>  	struct dentry *dentry = file->f_path.dentry;
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index b90841ac0a40..8b5873b53324 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -386,7 +386,7 @@ static int udf_create(struct mnt_idmap *idmap, struct inode *dir,
>  	return udf_add_nondir(dentry, inode);
>  }
>  
> -static int udf_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +static int udf_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct file *file, umode_t mode)
>  {
>  	struct inode *inode = udf_new_inode(dir, mode);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 25d4d42fbc7f..06ca999d0927 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1250,7 +1250,7 @@ xfs_vn_fiemap(
>  
>  STATIC int
>  xfs_vn_tmpfile(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct inode		*dir,
>  	struct file		*file,
>  	umode_t			mode)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9809e7c3aa0d..92161c224856 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2024,7 +2024,7 @@ struct inode_operations {
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  			   struct file *, unsigned open_flag,
>  			   umode_t create_mode);
> -	int (*tmpfile) (struct mnt_idmap *, struct inode *,
> +	int (*tmpfile) (const struct mnt_idmap *, struct inode *,
>  			struct file *, umode_t);
>  	struct posix_acl *(*get_acl)(const struct mnt_idmap *, struct dentry *,
>  				     int);
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index e8638f7d2245..470de3fb22c1 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -122,7 +122,7 @@ LSM_HOOK(int, 0, inode_init_security_anon, struct inode *inode,
>  	 const struct qstr *name, const struct inode *context_inode)
>  LSM_HOOK(int, 0, inode_create, struct inode *dir, struct dentry *dentry,
>  	 umode_t mode)
> -LSM_HOOK(void, LSM_RET_VOID, inode_post_create_tmpfile, struct mnt_idmap *idmap,
> +LSM_HOOK(void, LSM_RET_VOID, inode_post_create_tmpfile, const struct mnt_idmap *idmap,
>  	 struct inode *inode)
>  LSM_HOOK(int, 0, inode_link, struct dentry *old_dentry, struct inode *dir,
>  	 struct dentry *new_dentry)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index d5832750418a..b07a85e6aed4 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -405,7 +405,7 @@ int security_inode_init_security_anon(struct inode *inode,
>  				      const struct qstr *name,
>  				      const struct inode *context_inode);
>  int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
> -void security_inode_post_create_tmpfile(struct mnt_idmap *idmap,
> +void security_inode_post_create_tmpfile(const struct mnt_idmap *idmap,
>  					struct inode *inode);
>  int security_inode_link(struct dentry *old_dentry, struct inode *dir,
>  			 struct dentry *new_dentry);
> @@ -910,7 +910,7 @@ static inline int security_inode_create(struct inode *dir,
>  }
>  
>  static inline void
> -security_inode_post_create_tmpfile(struct mnt_idmap *idmap, struct inode *inode)
> +security_inode_post_create_tmpfile(const struct mnt_idmap *idmap, struct inode *inode)
>  { }
>  
>  static inline int security_inode_link(struct dentry *old_dentry,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 097699ea2762..a107940660a8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3857,7 +3857,7 @@ shmem_mknod(struct mnt_idmap *idmap, struct inode *dir,
>  }
>  
>  static int
> -shmem_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
> +shmem_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  	      struct file *file, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 8d9c92dc8825..72ecacda7528 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -846,7 +846,7 @@ EXPORT_SYMBOL_GPL(ima_inode_hash);
>   * Skip calling process_measurement(), but indicate which newly, created
>   * tmpfiles are in policy.
>   */
> -static void ima_post_create_tmpfile(struct mnt_idmap *idmap,
> +static void ima_post_create_tmpfile(const struct mnt_idmap *idmap,
>  				    struct inode *inode)
>  
>  {
> diff --git a/security/security.c b/security/security.c
> index e3a14c958bc4..4e4ef1c496ad 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1638,7 +1638,7 @@ EXPORT_SYMBOL_GPL(security_inode_create);
>   *
>   * Update inode security data after a tmpfile has been created.
>   */
> -void security_inode_post_create_tmpfile(struct mnt_idmap *idmap,
> +void security_inode_post_create_tmpfile(const struct mnt_idmap *idmap,
>  					struct inode *inode)
>  {
>  	if (unlikely(IS_PRIVATE(inode)))
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
