Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F13AA4E4;
	Wed,  2 Sep 2026 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363969; cv=none; b=kAumorj98KVdLJCTyrkhJvJkeJeW9aG0ZMYj/V0ZwrRXN9Veuf19kg/3gz2tEGGbC/xHVo1Wse5dYevSaFyd0U83hdcs+ivjZ3e8Jp8TVoj5Z2rYqMPNfERtlfvMjHr2aiq3Vsvhflx6Xst3BTqMxndpk0V3p3okW672vXOIHOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363969; c=relaxed/simple;
	bh=+VQI0EIeAkec2bXvkqNxs8125wQqTQQVmSoddm0siJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FD0KIVUlSPVwGJJeq5fSw2K5swfttp1YqZ8LaDx50O0U7hXaRGweRIeQSvlTnuMRMv1JI0bH+x/fY0GnOSNDfZ/9lK6NpS8bkCTj3aNQ7s9szev0ta7dw7DL/UV4U6o7qBJ44TWvtHD7iBcrr2o/sszm5jiMydb9Teulb7tisIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MFh9iBtW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wVysAqsD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z4lw1rk9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RotPZP2l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MFh9iBtW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wVysAqsD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z4lw1rk9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RotPZP2l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5B12521D76;
	Wed,  2 Sep 2026 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WtAKaGoapOneX3IjTr16S7tzmln20eEn3yp1YdZlmP0=;
	b=MFh9iBtWcDhU0yA+feDzh2Xt4Ju+mbafrA+T8TmF56Nqi2LDKrzLgjdGHAojDd2wfWEIBV
	ELH6PJJxBP4gWPKwuI1FbmTJLJ2jrqnPyb2zmkefu+Ix2NEN2fsu/ztIe+T4a1GpbR+Yca
	HEo62TUFcNtf7aKTguHShAA2kMErGGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WtAKaGoapOneX3IjTr16S7tzmln20eEn3yp1YdZlmP0=;
	b=wVysAqsDMSJPTf/ukUMlFKKG2ILxadruMESEZuJbEBBLQejd6+4g0+SSWLS5/KzRQKAs61
	mVPe3IuXPbonOvCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WtAKaGoapOneX3IjTr16S7tzmln20eEn3yp1YdZlmP0=;
	b=z4lw1rk9aY3kWu0MtIJhnHxatupQGHa1fVZ78D6jqzmpqdLU5r0AzCEr+rneafn0IGbdph
	iZmoPzJLTEESPuMtAzdjej02CyKIqlPCHu0DnvRpC7o5icAvl/U7Ry+qFnLGHiGnz3Yblw
	/s5EsKw1LPPI0NdS4sQT2110Gtcq7p4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WtAKaGoapOneX3IjTr16S7tzmln20eEn3yp1YdZlmP0=;
	b=RotPZP2lvv/Xw/gqqKTuBBxNx+q4HoYLgyJdAZJ0k4Eov7MVs4eJsmox1nWrQBFDJk0et2
	mgiAwFGbThv2DrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 396BF13736;
	Wed,  2 Sep 2026 15:45:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oZwFDrREmGpwZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:45:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DDA46A13B5; Wed, 02 Sep 2026 17:45:51 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:45:51 +0200
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
Subject: Re: [PATCH 16/27] fs: port ->get_acl() to pass const mnt_idmap
Message-ID: <dgnphf2mjygiwnxdekze3sbeylr3yiuddybvzft44nbvpzt7dl@y63gzyyvdvi2>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-16-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-16-54ccd48e100b@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:41, Christian Brauner wrote:
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
>  fs/9p/acl.c                           | 2 +-
>  fs/9p/acl.h                           | 2 +-
>  fs/ecryptfs/inode.c                   | 2 +-
>  fs/fuse/acl.c                         | 2 +-
>  fs/fuse/fuse_i.h                      | 2 +-
>  fs/internal.h                         | 4 ++--
>  fs/ntfs/ea.c                          | 2 +-
>  fs/ntfs/ea.h                          | 2 +-
>  fs/ntfs3/ntfs_fs.h                    | 2 +-
>  fs/ntfs3/xattr.c                      | 2 +-
>  fs/overlayfs/overlayfs.h              | 2 +-
>  fs/posix_acl.c                        | 6 +++---
>  fs/smb/client/cifsacl.c               | 2 +-
>  fs/smb/client/cifsproto.h             | 2 +-
>  fs/xattr.c                            | 2 +-
>  include/linux/fs.h                    | 2 +-
>  include/linux/posix_acl.h             | 4 ++--
>  19 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index b95cd4992896..167988321a8c 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -91,7 +91,7 @@ prototypes::
>  	int (*fileattr_set)(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, struct file_kattr *fa);
>  	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
> -	struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
> +	struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
>  	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
>  
>  locking rules:
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index d0dd2be3885b..6adb1061a9b6 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -439,7 +439,7 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
>  		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
> -		struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
> +		struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
>  	        int (*set_acl)(const struct mnt_idmap *, struct dentry *, struct posix_acl *, int);
>  		int (*fileattr_set)(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry, struct file_kattr *fa);
> diff --git a/fs/9p/acl.c b/fs/9p/acl.c
> index d09a41336d0d..c6c7c47d32b9 100644
> --- a/fs/9p/acl.c
> +++ b/fs/9p/acl.c
> @@ -140,7 +140,7 @@ struct posix_acl *v9fs_iop_get_inode_acl(struct inode *inode, int type, bool rcu
>  
>  }
>  
> -struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *v9fs_iop_get_acl(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, int type)
>  {
>  	struct v9fs_session_info *v9ses;
> diff --git a/fs/9p/acl.h b/fs/9p/acl.h
> index 7de74704c465..2d1b24abcd3f 100644
> --- a/fs/9p/acl.h
> +++ b/fs/9p/acl.h
> @@ -10,7 +10,7 @@
>  int v9fs_get_acl(struct inode *inode, struct p9_fid *fid);
>  struct posix_acl *v9fs_iop_get_inode_acl(struct inode *inode, int type,
>  				   bool rcu);
> -struct posix_acl *v9fs_iop_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *v9fs_iop_get_acl(const struct mnt_idmap *idmap,
>  					  struct dentry *dentry, int type);
>  int v9fs_iop_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		     struct posix_acl *acl, int type);
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 1e5146485214..bd1187661d6d 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -1090,7 +1090,7 @@ static int ecryptfs_fileattr_set(const struct mnt_idmap *idmap,
>  	return rc;
>  }
>  
> -static struct posix_acl *ecryptfs_get_acl(struct mnt_idmap *idmap,
> +static struct posix_acl *ecryptfs_get_acl(const struct mnt_idmap *idmap,
>  					  struct dentry *dentry, int type)
>  {
>  	return vfs_get_acl(idmap, ecryptfs_dentry_to_lower(dentry),
> diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
> index c3813fff4f27..738abed9a816 100644
> --- a/fs/fuse/acl.c
> +++ b/fs/fuse/acl.c
> @@ -62,7 +62,7 @@ static inline bool fuse_no_acl(const struct fuse_conn *fc,
>  	return !fc->posix_acl && (i_user_ns(inode) != &init_user_ns);
>  }
>  
> -struct posix_acl *fuse_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *fuse_get_acl(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, int type)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 561ada21ea86..9bf4c738bd74 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1205,7 +1205,7 @@ extern const struct xattr_handler * const fuse_xattr_handlers[];
>  
>  struct posix_acl;
>  struct posix_acl *fuse_get_inode_acl(struct inode *inode, int type, bool rcu);
> -struct posix_acl *fuse_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *fuse_get_acl(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, int type);
>  int fuse_set_acl(const struct mnt_idmap *, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> diff --git a/fs/internal.h b/fs/internal.h
> index 8ba0a1613d20..8a1c7c05c5a2 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -304,7 +304,7 @@ int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
>  #ifdef CONFIG_FS_POSIX_ACL
>  int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	       const char *acl_name, const void *kvalue, size_t size);
> -ssize_t do_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   const char *acl_name, void *kvalue, size_t size);
>  #else
>  static inline int do_set_acl(const struct mnt_idmap *idmap,
> @@ -313,7 +313,7 @@ static inline int do_set_acl(const struct mnt_idmap *idmap,
>  {
>  	return -EOPNOTSUPP;
>  }
> -static inline ssize_t do_get_acl(struct mnt_idmap *idmap,
> +static inline ssize_t do_get_acl(const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, const char *acl_name,
>  				 void *kvalue, size_t size)
>  {
> diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
> index 063cc15f1626..ed31f0e9f5d2 100644
> --- a/fs/ntfs/ea.c
> +++ b/fs/ntfs/ea.c
> @@ -954,7 +954,7 @@ const struct xattr_handler * const ntfs_xattr_handlers[] = {
>  // clang-format on
>  
>  #ifdef CONFIG_NTFS_FS_POSIX_ACL
> -struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
> index 6d98e7487a2c..690fafe181fb 100644
> --- a/fs/ntfs/ea.h
> +++ b/fs/ntfs/ea.h
> @@ -17,7 +17,7 @@ int ntfs_ea_set_wsl_inode(struct inode *inode, dev_t rdev, __le16 *ea_size,
>  ssize_t ntfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
>  
>  #ifdef CONFIG_NTFS_FS_POSIX_ACL
> -struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type);
>  int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index 0a5e81d420f0..d89609a17886 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -963,7 +963,7 @@ unsigned long ntfs_names_hash(const u16 *name, size_t len, const u16 *upcase,
>  
>  /* globals from xattr.c */
>  #ifdef CONFIG_NTFS3_FS_POSIX_ACL
> -struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type);
>  int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
> index 2d17b80999ca..941d516ab8dd 100644
> --- a/fs/ntfs3/xattr.c
> +++ b/fs/ntfs3/xattr.c
> @@ -543,7 +543,7 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
>  /*
>   * ntfs_get_acl - inode_operations::get_acl
>   */
> -struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +struct posix_acl *ntfs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 8b335993bf56..1759221dcad5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -814,7 +814,7 @@ static inline struct posix_acl *ovl_get_inode_acl(struct inode *inode, int type,
>  {
>  	return do_ovl_get_acl(&nop_mnt_idmap, inode, type, rcu, true);
>  }
> -static inline struct posix_acl *ovl_get_acl(struct mnt_idmap *idmap,
> +static inline struct posix_acl *ovl_get_acl(const struct mnt_idmap *idmap,
>  					    struct dentry *dentry, int type)
>  {
>  	return do_ovl_get_acl(idmap, d_inode(dentry), type, false, false);
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index cec7fb557278..fe77934ea8f2 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -118,7 +118,7 @@ void forget_all_cached_acls(struct inode *inode)
>  }
>  EXPORT_SYMBOL(forget_all_cached_acls);
>  
> -static struct posix_acl *__get_acl(struct mnt_idmap *idmap,
> +static struct posix_acl *__get_acl(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, struct inode *inode,
>  				   int type)
>  {
> @@ -1168,7 +1168,7 @@ EXPORT_SYMBOL_GPL(vfs_set_acl);
>   *
>   * Return: On success POSIX ACLs in VFS format, on error negative errno.
>   */
> -struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, const char *acl_name)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -1286,7 +1286,7 @@ int do_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	return error;
>  }
>  
> -ssize_t do_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +ssize_t do_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   const char *acl_name, void *kvalue, size_t size)
>  {
>  	ssize_t error;
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index 0a05b6b0be5f..084a4460ca19 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -1867,7 +1867,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
>  	return rc;
>  }
>  
> -struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *cifs_get_acl(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, int type)
>  {
>  #if defined(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) && defined(CONFIG_CIFS_POSIX)
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 565697c233a9..e6beff8aafe0 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -212,7 +212,7 @@ struct smb_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
>  struct smb_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>  				     const struct cifs_fid *cifsfid,
>  				     u32 *pacllen, u32 info);
> -struct posix_acl *cifs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +struct posix_acl *cifs_get_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type);
>  int cifs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 758a7ffe3a86..d9f035610f0b 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -787,7 +787,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>   * Extended attribute GET operations
>   */
>  static ssize_t
> -do_getxattr(struct mnt_idmap *idmap, struct dentry *d,
> +do_getxattr(const struct mnt_idmap *idmap, struct dentry *d,
>  	struct kernel_xattr_ctx *ctx)
>  {
>  	ssize_t error;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9186d9bb2697..9809e7c3aa0d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2026,7 +2026,7 @@ struct inode_operations {
>  			   umode_t create_mode);
>  	int (*tmpfile) (struct mnt_idmap *, struct inode *,
>  			struct file *, umode_t);
> -	struct posix_acl *(*get_acl)(struct mnt_idmap *, struct dentry *,
> +	struct posix_acl *(*get_acl)(const struct mnt_idmap *, struct dentry *,
>  				     int);
>  	int (*set_acl)(const struct mnt_idmap *, struct dentry *,
>  		       struct posix_acl *, int);
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 9220fe0c965d..caf500bed993 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -107,7 +107,7 @@ static inline void cache_no_acl(struct inode *inode)
>  
>  int vfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		const char *acl_name, struct posix_acl *kacl);
> -struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
> +struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, const char *acl_name);
>  int vfs_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   const char *acl_name);
> @@ -148,7 +148,7 @@ static inline int vfs_set_acl(const struct mnt_idmap *idmap,
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline struct posix_acl *vfs_get_acl(struct mnt_idmap *idmap,
> +static inline struct posix_acl *vfs_get_acl(const struct mnt_idmap *idmap,
>  					    struct dentry *dentry,
>  					    const char *acl_name)
>  {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
