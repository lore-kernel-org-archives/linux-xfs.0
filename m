Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7254A43F7;
	Wed,  2 Sep 2026 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364899; cv=none; b=bfT9djYa9/6/ZWGsxEg8ChlE+EibmZ5zVhx/+JGq3yYS9YGNpRGUZXaW5ASVDnzZQdAIYvRIkXalisSF7qSqUxW8dn7wtTvq5aiaXGYAQFo0Z0xV0z4uve+na4H9N/xjCGAN7dnvmydvXPdOUrVm5ONuRZPzeZ6QACnCjxiwO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364899; c=relaxed/simple;
	bh=eWcgt6BJY76sObDa1oVBvpzjDmccvq9+pdQvup+Lzs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGqAHZFZxPgQ3waXBRH0vLz0DU/yEoldp8BA2vTfZ+SJ/KcRJCwx8vGlXaouf4HZ9ciIKMdqeM86n0zNNQ0mukdaDclqrlKcLaIwm6LF+TRmtEYJhOIZvcATG1T+4x5OVs2o/Uk+i4er0naNglEam+T5Ok2zRU4vQGA/8v6IGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F9dmPdkw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qQSWe3A3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZyG4+jXL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oy3qwJqZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F9dmPdkw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qQSWe3A3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZyG4+jXL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oy3qwJqZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E5AE91FB3F;
	Wed,  2 Sep 2026 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLs0ICvdPnTV/+IwHIRn1iCWu4csZN9wLSnyPxl4O3U=;
	b=F9dmPdkwEfMNJMGR+x1OcMB6lqjwsxeNBEyMXb1DORnpudwNPA58Q4QoUSV7mKmkBnBhj5
	LiRudJyDbCImgUPlvbudHaC3o8de5WqPtkzZqQ7qi0cTc/4Nv7n4RTg4IJGDmAyML7bFGf
	NgIqneO7V9mwwrJbnC32VZ9t1PetWIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLs0ICvdPnTV/+IwHIRn1iCWu4csZN9wLSnyPxl4O3U=;
	b=qQSWe3A3IZS2pO3VvECpsNWmpbd2H0f8a2TwPwXUNkkIkW9d2zskPbCUPul9PSg/3MsjAW
	suQrWo59j4sjAXBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZyG4+jXL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Oy3qwJqZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLs0ICvdPnTV/+IwHIRn1iCWu4csZN9wLSnyPxl4O3U=;
	b=ZyG4+jXLzy1GZ5ZO8aSoZ3vvDBND/opS9eQVfCH5jytnRu/L+5PGA/OWk/b0bLGK0aPpmc
	TwBFp6au+uA0friEBW6Cx0pA+qfNIXlpRJVlGn35WJWknXItXdW/lV3yn2tGZeJaXwSLel
	LImkjVV1T7EFbLrz4zZVyU6cPh0E06E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fLs0ICvdPnTV/+IwHIRn1iCWu4csZN9wLSnyPxl4O3U=;
	b=Oy3qwJqZ5330r+87eCu3IkxZBiQQ+CrgfJT+t4GCbINxSnlXFLjyTGiK9qxWaU9TT4N5XX
	/Bx/tIvnmD6o8/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99D3A13738;
	Wed,  2 Sep 2026 16:01:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oL6NJVNImGrpdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 16:01:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2D903A13B5; Wed, 02 Sep 2026 18:01:23 +0200 (CEST)
Date: Wed, 2 Sep 2026 18:01:23 +0200
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
Subject: Re: [PATCH 24/27] fs: port ->setattr() to pass const mnt_idmap
Message-ID: <yxtit7qtchcplgfa3fjikh47h2ovjaluqxxlwr63i6dbqb745c@doyraok2ykyj>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-24-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E5AE91FB3F
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 01-09-26 14:14:49, Christian Brauner wrote:
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
>  Documentation/filesystems/locking.rst     | 2 +-
>  Documentation/filesystems/vfs.rst         | 2 +-
>  arch/powerpc/platforms/cell/spufs/inode.c | 2 +-
>  fs/9p/v9fs_vfs.h                          | 2 +-
>  fs/9p/vfs_inode.c                         | 2 +-
>  fs/9p/vfs_inode_dotl.c                    | 2 +-
>  fs/adfs/adfs.h                            | 2 +-
>  fs/adfs/inode.c                           | 2 +-
>  fs/affs/affs.h                            | 2 +-
>  fs/affs/inode.c                           | 2 +-
>  fs/afs/inode.c                            | 2 +-
>  fs/afs/internal.h                         | 2 +-
>  fs/anon_inodes.c                          | 2 +-
>  fs/attr.c                                 | 2 +-
>  fs/bad_inode.c                            | 2 +-
>  fs/btrfs/inode.c                          | 2 +-
>  fs/ceph/inode.c                           | 2 +-
>  fs/ceph/super.h                           | 2 +-
>  fs/coda/coda_linux.h                      | 2 +-
>  fs/coda/inode.c                           | 2 +-
>  fs/configfs/configfs_internal.h           | 2 +-
>  fs/configfs/inode.c                       | 2 +-
>  fs/debugfs/inode.c                        | 2 +-
>  fs/ecryptfs/inode.c                       | 2 +-
>  fs/efivarfs/inode.c                       | 2 +-
>  fs/exfat/exfat_fs.h                       | 2 +-
>  fs/exfat/file.c                           | 2 +-
>  fs/ext2/ext2.h                            | 2 +-
>  fs/ext2/inode.c                           | 2 +-
>  fs/ext4/ext4.h                            | 2 +-
>  fs/ext4/inode.c                           | 2 +-
>  fs/f2fs/f2fs.h                            | 2 +-
>  fs/f2fs/file.c                            | 2 +-
>  fs/fat/fat.h                              | 2 +-
>  fs/fat/file.c                             | 2 +-
>  fs/fuse/dir.c                             | 2 +-
>  fs/gfs2/inode.c                           | 2 +-
>  fs/hfs/hfs_fs.h                           | 2 +-
>  fs/hfs/inode.c                            | 2 +-
>  fs/hfsplus/inode.c                        | 2 +-
>  fs/hostfs/hostfs_kern.c                   | 2 +-
>  fs/hpfs/hpfs_fn.h                         | 2 +-
>  fs/hpfs/inode.c                           | 2 +-
>  fs/hugetlbfs/inode.c                      | 2 +-
>  fs/inode.c                                | 2 +-
>  fs/internal.h                             | 2 +-
>  fs/jffs2/fs.c                             | 2 +-
>  fs/jffs2/os-linux.h                       | 2 +-
>  fs/jfs/file.c                             | 2 +-
>  fs/jfs/jfs_inode.h                        | 2 +-
>  fs/kernfs/inode.c                         | 2 +-
>  fs/kernfs/kernfs-internal.h               | 2 +-
>  fs/libfs.c                                | 4 ++--
>  fs/minix/file.c                           | 2 +-
>  fs/nfs/inode.c                            | 2 +-
>  fs/nfs/namespace.c                        | 2 +-
>  fs/nilfs2/inode.c                         | 2 +-
>  fs/nilfs2/nilfs.h                         | 2 +-
>  fs/ntfs/file.c                            | 2 +-
>  fs/ntfs/inode.h                           | 2 +-
>  fs/ntfs3/file.c                           | 2 +-
>  fs/ntfs3/ntfs_fs.h                        | 2 +-
>  fs/ocfs2/dlmfs/dlmfs.c                    | 2 +-
>  fs/ocfs2/file.c                           | 2 +-
>  fs/ocfs2/file.h                           | 2 +-
>  fs/omfs/file.c                            | 2 +-
>  fs/orangefs/inode.c                       | 2 +-
>  fs/orangefs/orangefs-kernel.h             | 2 +-
>  fs/overlayfs/inode.c                      | 2 +-
>  fs/overlayfs/overlayfs.h                  | 2 +-
>  fs/pidfs.c                                | 2 +-
>  fs/proc/base.c                            | 2 +-
>  fs/proc/generic.c                         | 2 +-
>  fs/proc/internal.h                        | 2 +-
>  fs/proc/proc_sysctl.c                     | 2 +-
>  fs/ramfs/file-nommu.c                     | 4 ++--
>  fs/smb/client/cifsfs.h                    | 2 +-
>  fs/smb/client/inode.c                     | 2 +-
>  fs/tracefs/event_inode.c                  | 2 +-
>  fs/tracefs/inode.c                        | 2 +-
>  fs/ubifs/file.c                           | 2 +-
>  fs/ubifs/ubifs.h                          | 2 +-
>  fs/udf/file.c                             | 2 +-
>  fs/ufs/inode.c                            | 2 +-
>  fs/ufs/ufs.h                              | 2 +-
>  fs/vboxsf/utils.c                         | 2 +-
>  fs/vboxsf/vfsmod.h                        | 2 +-
>  fs/xfs/xfs_iops.c                         | 2 +-
>  fs/zonefs/super.c                         | 2 +-
>  include/linux/fs.h                        | 6 +++---
>  include/linux/lsm_hook_defs.h             | 4 ++--
>  include/linux/nfs_fs.h                    | 2 +-
>  include/linux/security.h                  | 8 ++++----
>  mm/secretmem.c                            | 2 +-
>  mm/shmem.c                                | 2 +-
>  net/socket.c                              | 2 +-
>  security/integrity/evm/evm_main.c         | 4 ++--
>  security/integrity/ima/ima_appraise.c     | 2 +-
>  security/security.c                       | 4 ++--
>  security/selinux/hooks.c                  | 2 +-
>  security/smack/smack_lsm.c                | 2 +-
>  virt/kvm/guest_memfd.c                    | 2 +-
>  102 files changed, 112 insertions(+), 112 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index f11bfc2e0c13..6330653287d5 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -76,7 +76,7 @@ prototypes::
>  	void (*truncate) (struct inode *);
>  	int (*permission) (const struct mnt_idmap *, struct inode *, int, unsigned int);
>  	struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
> -	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> +	int (*setattr) (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  	int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 98aefc5d399e..7b9475b1282f 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -430,7 +430,7 @@ As of kernel 2.6.22, the following members are defined:
>  					 struct delayed_call *);
>  		int (*permission) (const struct mnt_idmap *, struct inode *, int);
>  		struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
> -		int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> +		int (*setattr) (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  		int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  		void (*update_time)(struct inode *inode, enum fs_update_time type,
> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index 2b54afb31529..a7b2df936c90 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -92,7 +92,7 @@ spufs_new_inode(struct super_block *sb, umode_t mode)
>  }
>  
>  static int
> -spufs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +spufs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	      struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
> index 1856d91f8703..5e7b60042498 100644
> --- a/fs/9p/v9fs_vfs.h
> +++ b/fs/9p/v9fs_vfs.h
> @@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode, struct file *file);
>  int v9fs_uflags2omode(int uflags, int extended);
>  
>  void v9fs_blank_wstat(struct p9_wstat *wstat);
> -int v9fs_vfs_setattr_dotl(struct mnt_idmap *idmap,
> +int v9fs_vfs_setattr_dotl(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct iattr *iattr);
>  int v9fs_file_fsync_dotl(struct file *filp, loff_t start, loff_t end,
>  			 int datasync);
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 0c280342f8e9..c95e653344f6 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1014,7 +1014,7 @@ v9fs_vfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>   *
>   */
>  
> -static int v9fs_vfs_setattr(struct mnt_idmap *idmap,
> +static int v9fs_vfs_setattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct iattr *iattr)
>  {
>  	int retval, use_dentry = 0;
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index e37854ee6346..2cd2898580a9 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -508,7 +508,7 @@ static int v9fs_mapped_iattr_valid(int iattr_valid)
>   *
>   */
>  
> -int v9fs_vfs_setattr_dotl(struct mnt_idmap *idmap,
> +int v9fs_vfs_setattr_dotl(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct iattr *iattr)
>  {
>  	int retval, use_dentry = 0;
> diff --git a/fs/adfs/adfs.h b/fs/adfs/adfs.h
> index 0d32b7cd99b4..6003832277f8 100644
> --- a/fs/adfs/adfs.h
> +++ b/fs/adfs/adfs.h
> @@ -144,7 +144,7 @@ struct adfs_discmap {
>  /* Inode stuff */
>  struct inode *adfs_iget(struct super_block *sb, struct object_info *obj);
>  int adfs_write_inode(struct inode *inode, struct writeback_control *wbc);
> -int adfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int adfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr);
>  
>  /* map.c */
> diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
> index 4ac442d0a8c0..34598b499372 100644
> --- a/fs/adfs/inode.c
> +++ b/fs/adfs/inode.c
> @@ -299,7 +299,7 @@ adfs_iget(struct super_block *sb, struct object_info *obj)
>   * later.
>   */
>  int
> -adfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry, struct iattr *attr)
> +adfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
>  	struct super_block *sb = inode->i_sb;
> diff --git a/fs/affs/affs.h b/fs/affs/affs.h
> index 8d4ca16c7891..2518de96a0c8 100644
> --- a/fs/affs/affs.h
> +++ b/fs/affs/affs.h
> @@ -184,7 +184,7 @@ extern int	affs_rename2(const struct mnt_idmap *idmap,
>  /* inode.c */
>  
>  extern struct inode		*affs_new_inode(struct inode *dir);
> -extern int			 affs_setattr(struct mnt_idmap *idmap,
> +extern int			 affs_setattr(const struct mnt_idmap *idmap,
>  					struct dentry *dentry, struct iattr *attr);
>  extern void			 affs_evict_inode(struct inode *inode);
>  extern struct inode		*affs_iget(struct super_block *sb,
> diff --git a/fs/affs/inode.c b/fs/affs/inode.c
> index d4a3f381c4bc..2a48d7422091 100644
> --- a/fs/affs/inode.c
> +++ b/fs/affs/inode.c
> @@ -213,7 +213,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
>  }
>  
>  int
> -affs_setattr(struct mnt_idmap *idmap, struct dentry *dentry, struct iattr *attr)
> +affs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
>  	int error;
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 7b8a2adc3f59..8e6ca6b45c6b 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -759,7 +759,7 @@ static const struct afs_operation_ops afs_setattr_operation = {
>  /*
>   * set the attributes of an inode
>   */
> -int afs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int afs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr)
>  {
>  	const unsigned int supported =
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 7a8cdde9e0ad..0bd851f00bbe 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -1260,7 +1260,7 @@ extern struct inode *afs_iget(struct afs_operation *, struct afs_vnode_param *);
>  extern struct inode *afs_root_iget(struct super_block *, struct key *);
>  extern int afs_getattr(const struct mnt_idmap *idmap, const struct path *,
>  		       struct kstat *, u32, unsigned int);
> -extern int afs_setattr(struct mnt_idmap *idmap, struct dentry *, struct iattr *);
> +extern int afs_setattr(const struct mnt_idmap *idmap, struct dentry *, struct iattr *);
>  extern void afs_evict_inode(struct inode *);
>  extern int afs_drop_inode(struct inode *);
>  
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index d4a7e0b67289..8f07c8d9bda0 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -57,7 +57,7 @@ int anon_inode_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  	return 0;
>  }
>  
> -int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int anon_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/fs/attr.c b/fs/attr.c
> index 1845d145fe4c..9706d370f34a 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -424,7 +424,7 @@ EXPORT_SYMBOL(may_setattr);
>   * permissions. On non-idmapped mounts or if permission checking is to be
>   * performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -int notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
> +int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr, struct delegated_inode *delegated_inode)
>  {
>  	struct inode *inode = dentry->d_inode;
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index e740b4e658bf..bea9f4876ee0 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -102,7 +102,7 @@ static int bad_inode_getattr(const struct mnt_idmap *idmap,
>  	return -EIO;
>  }
>  
> -static int bad_inode_setattr(struct mnt_idmap *idmap,
> +static int bad_inode_setattr(const struct mnt_idmap *idmap,
>  			     struct dentry *direntry, struct iattr *attrs)
>  {
>  	return -EIO;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index da143f9376ee..149ec3b23063 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5479,7 +5479,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>  	return ret;
>  }
>  
> -static int btrfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int btrfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 185d713218e6..a695dba82554 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2921,7 +2921,7 @@ int __ceph_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  /*
>   * setattr
>   */
> -int ceph_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ceph_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 0a5e3916e855..a033331bb151 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1175,7 +1175,7 @@ struct ceph_iattr {
>  
>  extern int __ceph_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  			  struct iattr *attr, struct ceph_iattr *cia);
> -extern int ceph_setattr(struct mnt_idmap *idmap,
> +extern int ceph_setattr(const struct mnt_idmap *idmap,
>  			struct dentry *dentry, struct iattr *attr);
>  extern int ceph_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
> diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
> index 5dc9e392079f..0c0d5f81653c 100644
> --- a/fs/coda/coda_linux.h
> +++ b/fs/coda/coda_linux.h
> @@ -51,7 +51,7 @@ int coda_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  int coda_revalidate_inode(struct inode *);
>  int coda_getattr(const struct mnt_idmap *, const struct path *, struct kstat *,
>  		 u32, unsigned int);
> -int coda_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +int coda_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  
>  /* this file:  helpers */
>  char *coda_f2s(struct CodaFid *f);
> diff --git a/fs/coda/inode.c b/fs/coda/inode.c
> index f83ebd94c6be..c449954e23c2 100644
> --- a/fs/coda/inode.c
> +++ b/fs/coda/inode.c
> @@ -304,7 +304,7 @@ int coda_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  	return err;
>  }
>  
> -int coda_setattr(struct mnt_idmap *idmap, struct dentry *de,
> +int coda_setattr(const struct mnt_idmap *idmap, struct dentry *de,
>  		 struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(de);
> diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
> index 63d70dc05444..860f1b695921 100644
> --- a/fs/configfs/configfs_internal.h
> +++ b/fs/configfs/configfs_internal.h
> @@ -76,7 +76,7 @@ extern int configfs_make_dirent(struct configfs_dirent *, struct dentry *,
>  extern int configfs_dirent_is_ready(struct configfs_dirent *);
>  
>  extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
> -extern int configfs_setattr(struct mnt_idmap *idmap,
> +extern int configfs_setattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct iattr *iattr);
>  
>  extern struct dentry *configfs_pin_fs(void);
> diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
> index 68290fe0e374..6ba125d25c66 100644
> --- a/fs/configfs/inode.c
> +++ b/fs/configfs/inode.c
> @@ -32,7 +32,7 @@ static const struct inode_operations configfs_inode_operations ={
>  	.setattr	= configfs_setattr,
>  };
>  
> -int configfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int configfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		     struct iattr *iattr)
>  {
>  	struct inode * inode = d_inode(dentry);
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index e054e62919ec..287ec424ceed 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -42,7 +42,7 @@ static bool debugfs_enabled __ro_after_init = IS_ENABLED(CONFIG_DEBUG_FS_ALLOW_A
>   * so that we can use the file mode as part of a heuristic to determine whether
>   * to lock down individual files.
>   */
> -static int debugfs_setattr(struct mnt_idmap *idmap,
> +static int debugfs_setattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct iattr *ia)
>  {
>  	int ret;
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index e70a8d73d137..48e520960d66 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -869,7 +869,7 @@ ecryptfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>   * All other metadata changes will be passed right to the lower filesystem,
>   * and we will just update our inode to look like the lower.
>   */
> -static int ecryptfs_setattr(struct mnt_idmap *idmap,
> +static int ecryptfs_setattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct iattr *ia)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index d87091b92776..07602cd5d33c 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -170,7 +170,7 @@ efivarfs_fileattr_set(const struct mnt_idmap *idmap,
>  }
>  
>  /* copy of simple_setattr except that it doesn't do i_size updates */
> -static int efivarfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int efivarfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
> index 5165a0df068a..5acfe7ef57d6 100644
> --- a/fs/exfat/exfat_fs.h
> +++ b/fs/exfat/exfat_fs.h
> @@ -555,7 +555,7 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range);
>  /* file.c */
>  extern const struct file_operations exfat_file_operations;
>  int __exfat_truncate(struct inode *inode);
> -int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int exfat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
>  int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, unsigned int request_mask,
> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index c072a0663e69..3867e78c2312 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
> @@ -347,7 +347,7 @@ int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  	return 0;
>  }
>  
> -int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int exfat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr)
>  {
>  	struct exfat_sb_info *sbi = EXFAT_SB(dentry->d_sb);
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index f4bb8b888052..cf2796e5703e 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -739,7 +739,7 @@ extern int ext2_sync_inode_metadata(struct inode *, struct writeback_control *);
>  extern void ext2_evict_inode(struct inode *);
>  void ext2_write_failed(struct address_space *mapping, loff_t to);
>  extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
> -extern int ext2_setattr (struct mnt_idmap *, struct dentry *, struct iattr *);
> +extern int ext2_setattr (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  extern int ext2_getattr (const struct mnt_idmap *, const struct path *,
>  			 struct kstat *, u32, unsigned int);
>  extern void ext2_set_inode_flags(struct inode *inode);
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index d4b2a2dec35e..b52ded333aa9 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1617,7 +1617,7 @@ int ext2_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  	return 0;
>  }
>  
> -int ext2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ext2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index eb7cf19f606a..cbc59d03ca81 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3179,7 +3179,7 @@ extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
>  
>  extern int  ext4_write_inode(struct inode *, struct writeback_control *);
>  extern int  ext4_sync_inode_metadata(struct inode *, struct writeback_control *);
> -extern int  ext4_setattr(struct mnt_idmap *, struct dentry *,
> +extern int  ext4_setattr(const struct mnt_idmap *, struct dentry *,
>  			 struct iattr *);
>  extern u32  ext4_dio_alignment(struct inode *inode);
>  extern int  ext4_getattr(const struct mnt_idmap *, const struct path *,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 045f5385f26e..3c39bb945821 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6006,7 +6006,7 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>   *
>   * Called with inode->i_rwsem down.
>   */
> -int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ext4_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 06538f5fd725..128813d4f6e3 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3850,7 +3850,7 @@ int f2fs_truncate_blocks(struct inode *inode, u64 from, bool lock);
>  int f2fs_truncate(struct inode *inode);
>  int f2fs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags);
> -int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int f2fs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
>  int f2fs_truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end);
>  void f2fs_truncate_data_blocks_range(struct dnode_of_data *dn, int count);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 267a3a191d54..fb8b03a9972d 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1121,7 +1121,7 @@ static void __setattr_copy(const struct mnt_idmap *idmap,
>  #define __setattr_copy setattr_copy
>  #endif
>  
> -int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int f2fs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 202f209a544b..dbbcfc90a9c2 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -404,7 +404,7 @@ extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
>  			      unsigned long arg);
>  extern const struct file_operations fat_file_operations;
>  extern const struct inode_operations fat_file_inode_operations;
> -extern int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +extern int fat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr);
>  extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
>  extern int fat_getattr(const struct mnt_idmap *idmap,
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index b37bc637945f..2c6aee9f0305 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -514,7 +514,7 @@ static int fat_allow_set_time(const struct mnt_idmap *idmap,
>  /* valid file mode bits */
>  #define FAT_VALID_MODE	(S_IFREG | S_IFDIR | S_IRWXUGO)
>  
> -int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int fat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr)
>  {
>  	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index dd267d9498bc..6d23878cfae5 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2324,7 +2324,7 @@ int fuse_do_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	return err;
>  }
>  
> -static int fuse_setattr(struct mnt_idmap *idmap, struct dentry *entry,
> +static int fuse_setattr(const struct mnt_idmap *idmap, struct dentry *entry,
>  			struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(entry);
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 5ddac2f50f30..a040da86d8ed 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2095,7 +2095,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
>   * Returns: errno
>   */
>  
> -static int gfs2_setattr(struct mnt_idmap *idmap,
> +static int gfs2_setattr(const struct mnt_idmap *idmap,
>  			struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
> index e250f87a5e33..fdfa5d303d5e 100644
> --- a/fs/hfs/hfs_fs.h
> +++ b/fs/hfs/hfs_fs.h
> @@ -212,7 +212,7 @@ extern struct inode *hfs_new_inode(struct inode *dir, const struct qstr *name,
>  extern void hfs_inode_write_fork(struct inode *inode, struct hfs_extent *ext,
>  				 __be32 *log_size, __be32 *phys_size);
>  extern int hfs_write_inode(struct inode *inode, struct writeback_control *wbc);
> -extern int hfs_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +extern int hfs_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			     struct iattr *attr);
>  extern void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
>  				__be32 __log_size, __be32 phys_size,
> diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
> index 2aef3c36a150..c81314f668ac 100644
> --- a/fs/hfs/inode.c
> +++ b/fs/hfs/inode.c
> @@ -643,7 +643,7 @@ static int hfs_file_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -int hfs_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int hfs_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index 2807b29c7028..aed0866499b2 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -305,7 +305,7 @@ static int hfsplus_file_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static int hfsplus_setattr(struct mnt_idmap *idmap,
> +static int hfsplus_setattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index c8ad58be047e..613146e76dec 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -801,7 +801,7 @@ static int hostfs_permission(const struct mnt_idmap *idmap,
>  	return err;
>  }
>  
> -static int hostfs_setattr(struct mnt_idmap *idmap,
> +static int hostfs_setattr(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
> index 237c1c23e855..a398dd8bdf30 100644
> --- a/fs/hpfs/hpfs_fn.h
> +++ b/fs/hpfs/hpfs_fn.h
> @@ -280,7 +280,7 @@ void hpfs_init_inode(struct inode *);
>  void hpfs_read_inode(struct inode *);
>  void hpfs_write_inode(struct inode *);
>  void hpfs_write_inode_nolock(struct inode *);
> -int hpfs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +int hpfs_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  void hpfs_write_if_changed(struct inode *);
>  void hpfs_evict_inode(struct inode *);
>  
> diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
> index 1b4fcf760aad..396773d0b669 100644
> --- a/fs/hpfs/inode.c
> +++ b/fs/hpfs/inode.c
> @@ -257,7 +257,7 @@ void hpfs_write_inode_nolock(struct inode *i)
>  	brelse(bh);
>  }
>  
> -int hpfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int hpfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 0b95be14d3ee..6656807ce437 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -828,7 +828,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  	return error;
>  }
>  
> -static int hugetlbfs_setattr(struct mnt_idmap *idmap,
> +static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
>  			     struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/inode.c b/fs/inode.c
> index 99f1aab89eae..bd9808f07eb8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2356,7 +2356,7 @@ int dentry_needs_remove_privs(const struct mnt_idmap *idmap,
>  	return mask;
>  }
>  
> -static int __remove_privs(struct mnt_idmap *idmap,
> +static int __remove_privs(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, int kill)
>  {
>  	struct iattr newattrs;
> diff --git a/fs/internal.h b/fs/internal.h
> index 88d9296c2a48..2b8cffc22fb3 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -359,7 +359,7 @@ struct dentry *find_next_child(struct dentry *parent, struct dentry *prev);
>  int anon_inode_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		       struct kstat *stat, u32 request_mask,
>  		       unsigned int query_flags);
> -int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int anon_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr);
>  void pidfs_get_root(struct path *path);
>  void nsfs_get_root(struct path *path);
> diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
> index 6ada8369a762..05cf860307c7 100644
> --- a/fs/jffs2/fs.c
> +++ b/fs/jffs2/fs.c
> @@ -190,7 +190,7 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
>  	return 0;
>  }
>  
> -int jffs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int jffs2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
> index 86ab014a349c..bff2134d771d 100644
> --- a/fs/jffs2/os-linux.h
> +++ b/fs/jffs2/os-linux.h
> @@ -164,7 +164,7 @@ long jffs2_ioctl(struct file *, unsigned int, unsigned long);
>  extern const struct inode_operations jffs2_symlink_inode_operations;
>  
>  /* fs.c */
> -int jffs2_setattr (struct mnt_idmap *, struct dentry *, struct iattr *);
> +int jffs2_setattr (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  int jffs2_do_setattr (struct inode *, struct iattr *);
>  struct inode *jffs2_iget(struct super_block *, unsigned long);
>  void jffs2_evict_inode (struct inode *);
> diff --git a/fs/jfs/file.c b/fs/jfs/file.c
> index 246568cb9a6e..2f5bb79c0591 100644
> --- a/fs/jfs/file.c
> +++ b/fs/jfs/file.c
> @@ -89,7 +89,7 @@ static int jfs_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -int jfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int jfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
> index 88cfc3886282..5a118b07fbff 100644
> --- a/fs/jfs/jfs_inode.h
> +++ b/fs/jfs/jfs_inode.h
> @@ -28,7 +28,7 @@ extern struct dentry *jfs_fh_to_parent(struct super_block *sb, struct fid *fid,
>  	int fh_len, int fh_type);
>  extern void jfs_set_inode_flags(struct inode *);
>  extern int jfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
> -extern int jfs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +extern int jfs_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  
>  extern const struct address_space_operations jfs_aops;
>  extern const struct inode_operations jfs_dir_inode_operations;
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index 6a92aa789ce5..b9dbb504d226 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -107,7 +107,7 @@ int kernfs_setattr(struct kernfs_node *kn, const struct iattr *iattr)
>  	return ret;
>  }
>  
> -int kernfs_iop_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int kernfs_iop_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index 8af7849f2c9c..d0c68ec2d236 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -173,7 +173,7 @@ extern const struct xattr_handler * const kernfs_xattr_handlers[];
>  void kernfs_evict_inode(struct inode *inode);
>  int kernfs_iop_permission(const struct mnt_idmap *idmap,
>  			  struct inode *inode, int mask);
> -int kernfs_iop_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int kernfs_iop_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *iattr);
>  int kernfs_iop_getattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, struct kstat *stat,
> diff --git a/fs/libfs.c b/fs/libfs.c
> index b70977b10a7c..8e2cc627bc7f 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -913,7 +913,7 @@ EXPORT_SYMBOL(simple_rename);
>   * on simple regular filesystems.  Anything that needs to change on-disk
>   * or wire state on size changes needs its own setattr method.
>   */
> -int simple_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int simple_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -1727,7 +1727,7 @@ static struct dentry *empty_dir_lookup(struct inode *dir, struct dentry *dentry,
>  	return ERR_PTR(-ENOENT);
>  }
>  
> -static int empty_dir_setattr(struct mnt_idmap *idmap,
> +static int empty_dir_setattr(const struct mnt_idmap *idmap,
>  			     struct dentry *dentry, struct iattr *attr)
>  {
>  	return -EPERM;
> diff --git a/fs/minix/file.c b/fs/minix/file.c
> index 02aabbdb5dea..c0929fc38fbc 100644
> --- a/fs/minix/file.c
> +++ b/fs/minix/file.c
> @@ -23,7 +23,7 @@ const struct file_operations minix_file_operations = {
>  	.splice_read	= filemap_splice_read,
>  };
>  
> -static int minix_setattr(struct mnt_idmap *idmap,
> +static int minix_setattr(const struct mnt_idmap *idmap,
>  			 struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index b114488715fb..3c9b2ec4e244 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -690,7 +690,7 @@ EXPORT_SYMBOL_GPL(nfs_update_delegated_mtime);
>  #define NFS_VALID_ATTRS (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_SIZE|ATTR_ATIME|ATTR_ATIME_SET|ATTR_MTIME|ATTR_MTIME_SET|ATTR_FILE|ATTR_OPEN)
>  
>  int
> -nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +nfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	    struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
> index 17f54d79efa7..c50d59c52c50 100644
> --- a/fs/nfs/namespace.c
> +++ b/fs/nfs/namespace.c
> @@ -235,7 +235,7 @@ nfs_namespace_getattr(const struct mnt_idmap *idmap,
>  }
>  
>  static int
> -nfs_namespace_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +nfs_namespace_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct iattr *attr)
>  {
>  	if (NFS_FH(d_inode(dentry))->size != 0)
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 9342f651bf9b..8953719c4950 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -904,7 +904,7 @@ void nilfs_evict_inode(struct inode *inode)
>  	 */
>  }
>  
> -int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int nilfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *iattr)
>  {
>  	struct nilfs_transaction_info ti;
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 829df7be11fe..28d35b2fa7f7 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -299,7 +299,7 @@ struct inode *nilfs_iget_for_shadow(struct inode *inode);
>  extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
>  extern void nilfs_truncate(struct inode *);
>  extern void nilfs_evict_inode(struct inode *);
> -extern int nilfs_setattr(struct mnt_idmap *, struct dentry *,
> +extern int nilfs_setattr(const struct mnt_idmap *, struct dentry *,
>  			 struct iattr *);
>  extern void nilfs_write_failed(struct address_space *mapping, loff_t to);
>  int nilfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 40e01704ea8f..da85cbae2420 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -294,7 +294,7 @@ static int ntfs_setattr_size(struct inode *vi, struct iattr *attr)
>   * NOTE: Changes in inode size are not supported yet for compressed or
>   * encrypted files.
>   */
> -int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *vi = d_inode(dentry);
> diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
> index 9cf923911825..45a396c97846 100644
> --- a/fs/ntfs/inode.h
> +++ b/fs/ntfs/inode.h
> @@ -330,7 +330,7 @@ int ntfs_read_inode_mount(struct inode *vi);
>  int ntfs_show_options(struct seq_file *sf, struct dentry *root);
>  int ntfs_truncate_vfs(struct inode *vi, loff_t new_size, loff_t i_size);
>  
> -int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
>  int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, unsigned int request_mask,
> diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> index f4d08346d25d..52e1cd969e06 100644
> --- a/fs/ntfs3/file.c
> +++ b/fs/ntfs3/file.c
> @@ -703,7 +703,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
>  /*
>   * ntfs_setattr - inode_operations::setattr
>   */
> -int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index 262b7ff2d6e1..ea24126c70db 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -555,7 +555,7 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct file_kattr *fa);
>  int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, u32 flags);
> -int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
>  int ntfs_file_open(struct inode *inode, struct file *file);
>  int ntfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index fef79b21a4a5..d3bfcada3e3b 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -188,7 +188,7 @@ static int dlmfs_file_release(struct inode *inode,
>   * We do ->setattr() just to override size changes.  Our size is the size
>   * of the LVB and nothing else.
>   */
> -static int dlmfs_file_setattr(struct mnt_idmap *idmap,
> +static int dlmfs_file_setattr(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, struct iattr *attr)
>  {
>  	int error;
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index befc6ebb2a06..62f45a1b5ca1 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1117,7 +1117,7 @@ static int ocfs2_extend_file(struct inode *inode,
>  	return ret;
>  }
>  
> -int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ocfs2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr)
>  {
>  	int status = 0, size_change;
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index b51c8e77dad7..97492ee5789e 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -50,7 +50,7 @@ int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
>  			  u64 new_i_size, u64 zero_to);
>  int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
>  		      loff_t zero_to);
> -int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ocfs2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
>  int ocfs2_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags);
> diff --git a/fs/omfs/file.c b/fs/omfs/file.c
> index 28f3b113340e..79a413f1dc0d 100644
> --- a/fs/omfs/file.c
> +++ b/fs/omfs/file.c
> @@ -338,7 +338,7 @@ const struct file_operations omfs_file_operations = {
>  	.splice_read = filemap_splice_read,
>  };
>  
> -static int omfs_setattr(struct mnt_idmap *idmap,
> +static int omfs_setattr(const struct mnt_idmap *idmap,
>  			struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index 100669ee5862..75ac1e485e35 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -828,7 +828,7 @@ int __orangefs_setattr_mode(struct dentry *dentry, struct iattr *iattr)
>  /*
>   * Change attributes of an object referenced by dentry.
>   */
> -int orangefs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int orangefs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		     struct iattr *iattr)
>  {
>  	int ret;
> diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
> index 3bf01c0c763b..348fe340c5d5 100644
> --- a/fs/orangefs/orangefs-kernel.h
> +++ b/fs/orangefs/orangefs-kernel.h
> @@ -352,7 +352,7 @@ struct inode *orangefs_new_inode(struct super_block *sb,
>  
>  int __orangefs_setattr(struct inode *, struct iattr *);
>  int __orangefs_setattr_mode(struct dentry *dentry, struct iattr *iattr);
> -int orangefs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +int orangefs_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  
>  int orangefs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		     struct kstat *stat, u32 request_mask, unsigned int flags);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index b765780686e6..622e9bb833af 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -18,7 +18,7 @@
>  #include "overlayfs.h"
>  
>  
> -int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ovl_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr)
>  {
>  	int err;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 02a822dc8e5e..f0eac9ae1e38 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -948,7 +948,7 @@ static inline bool ovl_force_readonly(struct ovl_fs *ofs)
>  /* xattr.c */
>  
>  const struct xattr_handler * const *ovl_xattr_handlers(struct ovl_fs *ofs);
> -int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ovl_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr);
>  int ovl_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int flags);
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index 38868ac99950..c37c17bcdbdc 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -823,7 +823,7 @@ static struct vfsmount *pidfs_mnt __ro_after_init;
>   * implemented. Let's reject it completely until we have a clean
>   * permission concept for pidfds.
>   */
> -static int pidfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int pidfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			 struct iattr *attr)
>  {
>  	return anon_inode_setattr(idmap, dentry, attr);
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3278c37e5cde..5a18636ba81f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -702,7 +702,7 @@ static int proc_pid_syscall(struct seq_file *m, struct pid_namespace *ns,
>  /*                       Here the fs part begins                        */
>  /************************************************************************/
>  
> -int proc_nochmod_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int proc_nochmod_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr)
>  {
>  	int error;
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 4c4f1e63f68f..2b1971da4a85 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -117,7 +117,7 @@ static bool pde_subdir_insert(struct proc_dir_entry *dir,
>  	return true;
>  }
>  
> -static int proc_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int proc_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 706fae7d30be..b9aaac41c283 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -260,7 +260,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
>  extern const struct dentry_operations pid_dentry_operations;
>  extern int pid_getattr(const struct mnt_idmap *, const struct path *,
>  		       struct kstat *, u32, unsigned int);
> -int proc_nochmod_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int proc_nochmod_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			struct iattr *attr);
>  extern void proc_pid_evict_inode(struct proc_inode *);
>  extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index bd6730000b27..d1cfd2941359 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -817,7 +817,7 @@ static int proc_sys_permission(const struct mnt_idmap *idmap,
>  	return error;
>  }
>  
> -static int proc_sys_setattr(struct mnt_idmap *idmap,
> +static int proc_sys_setattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
> index fb471bf88ab7..7ed6fba134c6 100644
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -22,7 +22,7 @@
>  #include <linux/uaccess.h>
>  #include "internal.h"
>  
> -static int ramfs_nommu_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +static int ramfs_nommu_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
>  						   unsigned long addr,
>  						   unsigned long len,
> @@ -161,7 +161,7 @@ static int ramfs_nommu_resize(struct inode *inode, loff_t newsize, loff_t size)
>   * handle a change of attributes
>   * - we're specifically interested in a change of size
>   */
> -static int ramfs_nommu_setattr(struct mnt_idmap *idmap,
> +static int ramfs_nommu_setattr(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, struct iattr *ia)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index c0adc5219213..51692e14c4dd 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -80,7 +80,7 @@ int cifs_revalidate_mapping(struct inode *inode);
>  int cifs_zap_mapping(struct inode *inode);
>  int cifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags);
> -int cifs_setattr(struct mnt_idmap *idmap, struct dentry *direntry,
> +int cifs_setattr(const struct mnt_idmap *idmap, struct dentry *direntry,
>  		 struct iattr *attrs);
>  int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
>  		u64 len);
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 132f9e072b77..248b7891e687 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3549,7 +3549,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>  }
>  
>  int
> -cifs_setattr(struct mnt_idmap *idmap, struct dentry *direntry,
> +cifs_setattr(const struct mnt_idmap *idmap, struct dentry *direntry,
>  	     struct iattr *attrs)
>  {
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
> diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
> index 6e3513b13cfa..6f6daac88621 100644
> --- a/fs/tracefs/event_inode.c
> +++ b/fs/tracefs/event_inode.c
> @@ -182,7 +182,7 @@ static void update_attr(struct eventfs_attr *attr, struct iattr *iattr)
>  	}
>  }
>  
> -static int eventfs_set_attr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int eventfs_set_attr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			    struct iattr *iattr)
>  {
>  	const struct eventfs_entry *entry;
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 44448f1a2bb1..5020365ca704 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -207,7 +207,7 @@ static int tracefs_getattr(const struct mnt_idmap *idmap,
>  	return 0;
>  }
>  
> -static int tracefs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int tracefs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			   struct iattr *attr)
>  {
>  	unsigned int ia_valid = attr->ia_valid;
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index bfc1bd0203ad..244b835fc82a 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1251,7 +1251,7 @@ static int do_setattr(struct ubifs_info *c, struct inode *inode,
>  	return err;
>  }
>  
> -int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ubifs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr)
>  {
>  	int err;
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index d455a67fe411..b85b45a0564b 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -2020,7 +2020,7 @@ int ubifs_calc_dark(const struct ubifs_info *c, int spc);
>  
>  /* file.c */
>  int ubifs_fsync(struct file *file, loff_t start, loff_t end, int datasync);
> -int ubifs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ubifs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
>  int ubifs_update_time(struct inode *inode, enum fs_update_time type,
>  		      unsigned int flags);
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 57d11606a2a7..02e9314818dc 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -212,7 +212,7 @@ const struct file_operations udf_file_operations = {
>  	.setlease		= generic_setlease,
>  };
>  
> -static int udf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int udf_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
> index 440d014cc5ed..c9ff8673fa66 100644
> --- a/fs/ufs/inode.c
> +++ b/fs/ufs/inode.c
> @@ -1195,7 +1195,7 @@ static int ufs_truncate(struct inode *inode, loff_t size)
>  	return err;
>  }
>  
> -int ufs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int ufs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
> index 788e025056b2..541566f5b5fb 100644
> --- a/fs/ufs/ufs.h
> +++ b/fs/ufs/ufs.h
> @@ -120,7 +120,7 @@ extern struct inode *ufs_iget(struct super_block *, unsigned long);
>  extern int ufs_write_inode (struct inode *, struct writeback_control *);
>  extern int ufs_sync_inode (struct inode *);
>  extern void ufs_evict_inode (struct inode *);
> -extern int ufs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +extern int ufs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr);
>  
>  /* namei.c */
> diff --git a/fs/vboxsf/utils.c b/fs/vboxsf/utils.c
> index 6a5a47a32075..8775fbee1ce6 100644
> --- a/fs/vboxsf/utils.c
> +++ b/fs/vboxsf/utils.c
> @@ -258,7 +258,7 @@ int vboxsf_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  	return 0;
>  }
>  
> -int vboxsf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int vboxsf_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   struct iattr *iattr)
>  {
>  	struct vboxsf_inode *sf_i = VBOXSF_I(d_inode(dentry));
> diff --git a/fs/vboxsf/vfsmod.h b/fs/vboxsf/vfsmod.h
> index 9c713b8e7aa2..59a4e44c4005 100644
> --- a/fs/vboxsf/vfsmod.h
> +++ b/fs/vboxsf/vfsmod.h
> @@ -101,7 +101,7 @@ int vboxsf_inode_revalidate(struct dentry *dentry);
>  int vboxsf_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		   struct kstat *kstat, u32 request_mask,
>  		   unsigned int query_flags);
> -int vboxsf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int vboxsf_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   struct iattr *iattr);
>  struct shfl_string *vboxsf_path_from_dentry(struct vboxsf_sbi *sbi,
>  					    struct dentry *dentry);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 19fd83cea18b..535e8a9e071e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1130,7 +1130,7 @@ xfs_vn_setattr_size(
>  
>  STATIC int
>  xfs_vn_setattr(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct dentry		*dentry,
>  	struct iattr		*iattr)
>  {
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index ff43d6d1ea30..b97f1f2b8dda 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -533,7 +533,7 @@ static int zonefs_show_options(struct seq_file *seq, struct dentry *root)
>  	return 0;
>  }
>  
> -static int zonefs_inode_setattr(struct mnt_idmap *idmap,
> +static int zonefs_inode_setattr(const struct mnt_idmap *idmap,
>  				struct dentry *dentry, struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c79fd3776bbf..55d8e7e473ff 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2012,7 +2012,7 @@ struct inode_operations {
>  		      umode_t,dev_t);
>  	int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
>  			struct inode *, struct dentry *, unsigned int);
> -	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> +	int (*setattr) (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  	int (*getattr) (const struct mnt_idmap *, const struct path *,
>  			struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> @@ -2707,7 +2707,7 @@ static inline int bmap(struct inode *inode,  sector_t *block)
>  }
>  #endif
>  
> -int notify_change(struct mnt_idmap *, struct dentry *,
> +int notify_change(const struct mnt_idmap *, struct dentry *,
>  		  struct iattr *, struct delegated_inode *);
>  int inode_permission(const struct mnt_idmap *, struct inode *, int);
>  int generic_permission(const struct mnt_idmap *, struct inode *, int);
> @@ -3261,7 +3261,7 @@ extern int dcache_dir_open(struct inode *, struct file *);
>  extern int dcache_dir_close(struct inode *, struct file *);
>  extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
>  extern int dcache_readdir(struct file *, struct dir_context *);
> -extern int simple_setattr(struct mnt_idmap *, struct dentry *,
> +extern int simple_setattr(const struct mnt_idmap *, struct dentry *,
>  			  struct iattr *);
>  extern int simple_getattr(const struct mnt_idmap *, const struct path *,
>  			  struct kstat *, u32, unsigned int);
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index ad05971e6137..194084f60746 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -140,9 +140,9 @@ LSM_HOOK(int, 0, inode_readlink, struct dentry *dentry)
>  LSM_HOOK(int, 0, inode_follow_link, struct dentry *dentry, struct inode *inode,
>  	 bool rcu)
>  LSM_HOOK(int, 0, inode_permission, struct inode *inode, int mask)
> -LSM_HOOK(int, 0, inode_setattr, struct mnt_idmap *idmap, struct dentry *dentry,
> +LSM_HOOK(int, 0, inode_setattr, const struct mnt_idmap *idmap, struct dentry *dentry,
>  	 struct iattr *attr)
> -LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, struct mnt_idmap *idmap,
> +LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, int ia_valid)
>  LSM_HOOK(int, 0, inode_getattr, const struct path *path)
>  LSM_HOOK(int, 0, inode_xattr_skipcap, const char *name)
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index 7b307dea7ce7..d2c716322c6f 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -450,7 +450,7 @@ extern int nfs_clear_invalid_mapping(struct address_space *mapping);
>  extern bool nfs_mapping_need_revalidate_inode(struct inode *inode);
>  extern int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping);
>  extern int nfs_revalidate_mapping_rcu(struct inode *inode);
> -extern int nfs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
> +extern int nfs_setattr(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  extern void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr, struct nfs_fattr *);
>  extern void nfs_setsecurity(struct inode *inode, struct nfs_fattr *fattr);
>  extern struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index d4100396da27..c7691feb8f8e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -422,9 +422,9 @@ int security_inode_readlink(struct dentry *dentry);
>  int security_inode_follow_link(struct dentry *dentry, struct inode *inode,
>  			       bool rcu);
>  int security_inode_permission(struct inode *inode, int mask);
> -int security_inode_setattr(struct mnt_idmap *idmap,
> +int security_inode_setattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct iattr *attr);
> -void security_inode_post_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				 int ia_valid);
>  int security_inode_getattr(const struct path *path);
>  int security_inode_setxattr(const struct mnt_idmap *idmap,
> @@ -979,7 +979,7 @@ static inline int security_inode_permission(struct inode *inode, int mask)
>  	return 0;
>  }
>  
> -static inline int security_inode_setattr(struct mnt_idmap *idmap,
> +static inline int security_inode_setattr(const struct mnt_idmap *idmap,
>  					 struct dentry *dentry,
>  					 struct iattr *attr)
>  {
> @@ -987,7 +987,7 @@ static inline int security_inode_setattr(struct mnt_idmap *idmap,
>  }
>  
>  static inline void
> -security_inode_post_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			    int ia_valid)
>  { }
>  
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index d29865075b6e..7bb6e426ac6e 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -161,7 +161,7 @@ const struct address_space_operations secretmem_aops = {
>  	.migrate_folio	= secretmem_migrate_folio,
>  };
>  
> -static int secretmem_setattr(struct mnt_idmap *idmap,
> +static int secretmem_setattr(const struct mnt_idmap *idmap,
>  			     struct dentry *dentry, struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b27e5f23dc93..2c086c2b604e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1326,7 +1326,7 @@ static int shmem_getattr(const struct mnt_idmap *idmap,
>  	return 0;
>  }
>  
> -static int shmem_setattr(struct mnt_idmap *idmap,
> +static int shmem_setattr(const struct mnt_idmap *idmap,
>  			 struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/net/socket.c b/net/socket.c
> index 052273ad081a..c0ab6a3ad8ed 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -670,7 +670,7 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
>  	return used;
>  }
>  
> -static int sockfs_setattr(struct mnt_idmap *idmap,
> +static int sockfs_setattr(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct iattr *iattr)
>  {
>  	int err = simple_setattr(&nop_mnt_idmap, dentry, iattr);
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 10a0b39dd9b7..9bfea858df2d 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -956,7 +956,7 @@ static int evm_attr_change(const struct mnt_idmap *idmap,
>   * Permit update of file attributes when files have a valid EVM signature,
>   * except in the case of them having an immutable portable signature.
>   */
> -static int evm_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int evm_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			     struct iattr *attr)
>  {
>  	unsigned int ia_valid = attr->ia_valid;
> @@ -1008,7 +1008,7 @@ static int evm_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>   * This function is called from notify_change(), which expects the caller
>   * to lock the inode's i_mutex.
>   */
> -static void evm_inode_post_setattr(struct mnt_idmap *idmap,
> +static void evm_inode_post_setattr(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, int ia_valid)
>  {
>  	if (!evm_revalidate_status(NULL))
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index cfc20c63a814..659b71e77ac8 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -634,7 +634,7 @@ void ima_update_xattr(struct ima_iint_cache *iint, struct file *file)
>   * This function is called from notify_change(), which expects the caller
>   * to lock the inode's i_mutex.
>   */
> -static void ima_inode_post_setattr(struct mnt_idmap *idmap,
> +static void ima_inode_post_setattr(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, int ia_valid)
>  {
>  	struct inode *inode = d_backing_inode(dentry);
> diff --git a/security/security.c b/security/security.c
> index 9a3ae6746fb3..304048f26d03 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1855,7 +1855,7 @@ int security_inode_permission(struct inode *inode, int mask)
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_setattr(struct mnt_idmap *idmap,
> +int security_inode_setattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct iattr *attr)
>  {
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> @@ -1872,7 +1872,7 @@ EXPORT_SYMBOL_GPL(security_inode_setattr);
>   *
>   * Update inode security field after successful setting file attributes.
>   */
> -void security_inode_post_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				 int ia_valid)
>  {
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index b7c6eba08fdc..1e59fb67dffb 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3297,7 +3297,7 @@ static int selinux_inode_permission(struct inode *inode, int requested)
>  	return rc;
>  }
>  
> -static int selinux_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int selinux_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				 struct iattr *iattr)
>  {
>  	const struct cred *cred = current_cred();
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index df4fc6ff26aa..bb78569b3d5b 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1270,7 +1270,7 @@ static int smack_inode_permission(struct inode *inode, int mask)
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int smack_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       struct iattr *iattr)
>  {
>  	struct smk_audit_info ad;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 625e62e1a031..5c084d5393a6 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -506,7 +506,7 @@ static const struct address_space_operations kvm_gmem_aops = {
>  #endif
>  };
>  
> -static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int kvm_gmem_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			    struct iattr *attr)
>  {
>  	return -EINVAL;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
