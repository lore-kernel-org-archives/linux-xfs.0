Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0959A331ED0;
	Wed,  2 Sep 2026 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358941; cv=none; b=nhwwzD9YChVNDnzh9K8JoNHVH6W55CZ3zHujHX9anG1/0KVEELJFNt0nFg711NV5+KNbwigprFfk7NqKuryvEVctgi6qVLb6tdsNcDMS9PhU8n2JkaYPAP9fs1td8ovsk/4/MeEFYnUgpKolTIuyBMOHR/niND1SDApUnwXoHGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358941; c=relaxed/simple;
	bh=qbcCGEVG/JY7HT0s4r2rliekdpw4C65GjwOVd9Bx/oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEUX3iEKy8lxd00InoE1ekv1L9qPVeiDXnFZVcqSFFzKD/nZO/929Rc2f/OHt24Vp1+SoQmbBFOSgZt+xkpIBk4y0EHTa43o1GVBwBHPt8oy1yinIkdrdjFmWnwR9iakVqTiOLpH5qVAqrymCYuDuPkdZhd1rxZlBZjFiQj5LlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ztQ4lkZa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4m/MVv9S; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UYjrxqeB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b0wfUrip; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ztQ4lkZa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4m/MVv9S";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UYjrxqeB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b0wfUrip"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C771021D22;
	Wed,  2 Sep 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zul3SMiRCKIzn4+/AoP8uI+Vb+G05dBmN6Y046iX5xs=;
	b=ztQ4lkZaidvSTglafWuO787YkENuE76xB0kcziTy9FTdk5CM4YJL/zecs+r8n/iBRX58ge
	eXztCoPzx6UMsBhMYMb6wmkk25XsOvPxLxRnxFTH4is1NWvZFOAN6in+BRhj8MX/L7kZoy
	gNOJDdphkgs5tOcCgbKSrr41SuwG/EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zul3SMiRCKIzn4+/AoP8uI+Vb+G05dBmN6Y046iX5xs=;
	b=4m/MVv9S14lLC2VLbOmZz4kDozMIsIXOCYruOgboR/pZrlPeWH2owqfVuhAAkG9PDFMSZb
	i8IdmfHFyHfuZ0Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UYjrxqeB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b0wfUrip
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zul3SMiRCKIzn4+/AoP8uI+Vb+G05dBmN6Y046iX5xs=;
	b=UYjrxqeBb52toJWVGejpHgLxlVnqoiW+Oxe6ydnBq/vu/qrrdaeSBKr3fiFh3ZQYQ1XXWZ
	Klm7fWsfNw1vCPRKOWjDYUw4y1DPZbE8ZAQwAZBUNGBeGCcLU9LTP2vxrLBD032wsj5rTl
	Cg3zwGHwcxORe5HPS/izwBgdXmcjDTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zul3SMiRCKIzn4+/AoP8uI+Vb+G05dBmN6Y046iX5xs=;
	b=b0wfUripXyy265Ihq37dQK+hda9JXDjGCg/5aIqZgTX3816svrnBJj17D2OoLGfE012aqX
	ltTPs6EfVZ3utACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1296136E6;
	Wed,  2 Sep 2026 14:22:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZBFWJxAxmGp0DwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:22:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EA67A13B5; Wed, 02 Sep 2026 16:22:08 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:22:08 +0200
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
Subject: Re: [PATCH 11/27] fs: port acl to const mnt_idmap
Message-ID: <aqkorqm6bqes4i2an44j7ks2ha522hr4lupvo4pji3yiip6avt@3ae27hhk4sly>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-11-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C771021D22
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 01-09-26 14:14:36, Christian Brauner wrote:
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
>  fs/ntfs/ea.c                          |  4 ++--
>  fs/ntfs/ea.h                          |  2 +-
>  fs/ntfs/namei.c                       |  2 +-
>  fs/ntfs3/inode.c                      |  2 +-
>  fs/ntfs3/ntfs_fs.h                    |  4 ++--
>  fs/ntfs3/xattr.c                      |  4 ++--
>  fs/posix_acl.c                        |  6 +++---
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/posix_acl.h             |  4 ++--
>  include/linux/security.h              | 16 ++++++++--------
>  security/integrity/evm/evm_main.c     | 10 +++++-----
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  15 files changed, 43 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
> index cdd306933d73..744ea8c446e5 100644
> --- a/fs/ntfs/ea.c
> +++ b/fs/ntfs/ea.c
> @@ -998,7 +998,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return acl;
>  }
>  
> -static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
> +static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
>  				    struct inode *inode, struct posix_acl *acl,
>  				    int type, bool init_acl)
>  {
> @@ -1086,7 +1086,7 @@ int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
>  }
>  
> -int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
> +int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
>  		  struct inode *dir)
>  {
>  	struct posix_acl *default_acl, *acl;
> diff --git a/fs/ntfs/ea.h b/fs/ntfs/ea.h
> index acb39c2a6fbc..9d17abc2e491 100644
> --- a/fs/ntfs/ea.h
> +++ b/fs/ntfs/ea.h
> @@ -21,7 +21,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type);
>  int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> -int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
> +int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
>  		  struct inode *dir);
>  #else
>  #define ntfs_get_acl NULL
> diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
> index 7091b2496fac..e2cf1ab6935a 100644
> --- a/fs/ntfs/namei.c
> +++ b/fs/ntfs/namei.c
> @@ -391,7 +391,7 @@ static int ntfs_sd_add_everyone(struct ntfs_inode *ni)
>  	return ret;
>  }
>  
> -static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static struct ntfs_inode *__ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		__le16 *name, u8 name_len, mode_t mode, dev_t dev,
>  		const char *target, int target_len)
>  {
> diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
> index 56b4f6469a28..a9fdd33f2886 100644
> --- a/fs/ntfs3/inode.c
> +++ b/fs/ntfs3/inode.c
> @@ -1381,7 +1381,7 @@ ntfs_create_reparse_buffer(struct ntfs_sb_info *sbi, const char *symname,
>   *
>   * NOTE: if fnd != NULL (ntfs_atomic_open) then @dir is locked
>   */
> -int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
> +int ntfs_create_inode(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, const struct cpu_str *uni,
>  		      umode_t mode, dev_t dev, const char *symname, u32 size,
>  		      struct ntfs_fnd *fnd)
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index 5811d89d67b3..a2b74f41048f 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -803,7 +803,7 @@ int ntfs_set_size(struct inode *inode, u64 new_size);
>  int ntfs3_write_inode(struct inode *inode, struct writeback_control *wbc);
>  int ntfs_sync_inode(struct inode *inode);
>  int inode_read_data(struct inode *inode, void *data, size_t bytes);
> -int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
> +int ntfs_create_inode(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, const struct cpu_str *uni,
>  		      umode_t mode, dev_t dev, const char *symname, u32 size,
>  		      struct ntfs_fnd *fnd);
> @@ -967,7 +967,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  			       int type);
>  int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct posix_acl *acl, int type);
> -int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
> +int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
>  		  struct inode *dir);
>  #else
>  #define ntfs_get_acl NULL
> diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
> index 594ef6860b93..d800735477c3 100644
> --- a/fs/ntfs3/xattr.c
> +++ b/fs/ntfs3/xattr.c
> @@ -595,7 +595,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return acl;
>  }
>  
> -static noinline int ntfs_set_acl_ex(struct mnt_idmap *idmap,
> +static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
>  				    struct inode *inode, struct posix_acl *acl,
>  				    int type, bool init_acl)
>  {
> @@ -688,7 +688,7 @@ int ntfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>   *
>   * Called from ntfs_create_inode().
>   */
> -int ntfs_init_acl(struct mnt_idmap *idmap, struct inode *inode,
> +int ntfs_init_acl(const struct mnt_idmap *idmap, struct inode *inode,
>  		  struct inode *dir)
>  {
>  	struct posix_acl *default_acl, *acl;
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index f9c55a59c6c6..b279804ebf56 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -378,7 +378,7 @@ EXPORT_SYMBOL(posix_acl_from_mode);
>   * by the acl. Returns -E... otherwise.
>   */
>  int
> -posix_acl_permission(struct mnt_idmap *idmap, struct inode *inode,
> +posix_acl_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		     const struct posix_acl *acl, int want)
>  {
>  	const struct posix_acl_entry *pa, *pe, *mask_obj;
> @@ -709,7 +709,7 @@ EXPORT_SYMBOL_GPL(posix_acl_create);
>   *
>   * Called from set_acl inode operations.
>   */
> -int posix_acl_update_mode(struct mnt_idmap *idmap,
> +int posix_acl_update_mode(const struct mnt_idmap *idmap,
>  			  struct inode *inode, umode_t *mode_p,
>  			  struct posix_acl **acl)
>  {
> @@ -889,7 +889,7 @@ EXPORT_SYMBOL (posix_acl_to_xattr);
>   * Return: On success, the size of the stored uapi posix acls, on error a
>   * negative errno.
>   */
> -static ssize_t vfs_posix_acl_to_xattr(struct mnt_idmap *idmap,
> +static ssize_t vfs_posix_acl_to_xattr(const struct mnt_idmap *idmap,
>  				      struct inode *inode,
>  				      const struct posix_acl *acl, void *buffer,
>  				      size_t size)
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..30897590258f 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -159,15 +159,15 @@ LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
>  	 const char *name)
>  LSM_HOOK(int, 0, inode_file_setattr, struct dentry *dentry, struct file_kattr *fa)
>  LSM_HOOK(int, 0, inode_file_getattr, struct dentry *dentry, struct file_kattr *fa)
> -LSM_HOOK(int, 0, inode_set_acl, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_set_acl, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *acl_name, struct posix_acl *kacl)
>  LSM_HOOK(void, LSM_RET_VOID, inode_post_set_acl, struct dentry *dentry,
>  	 const char *acl_name, struct posix_acl *kacl)
> -LSM_HOOK(int, 0, inode_get_acl, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_get_acl, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *acl_name)
> -LSM_HOOK(int, 0, inode_remove_acl, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_remove_acl, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *acl_name)
> -LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, struct mnt_idmap *idmap,
> +LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *acl_name)
>  LSM_HOOK(int, 0, inode_need_killpriv, struct dentry *dentry)
>  LSM_HOOK(int, 0, inode_killpriv, struct mnt_idmap *idmap,
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 62d497763e25..7c6cfcae0a9d 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -84,7 +84,7 @@ struct posix_acl *posix_acl_clone(const struct posix_acl *acl, gfp_t flags);
>  int posix_acl_chmod(struct mnt_idmap *, struct dentry *, umode_t);
>  extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
>  		struct posix_acl **);
> -int posix_acl_update_mode(struct mnt_idmap *, struct inode *, umode_t *,
> +int posix_acl_update_mode(const struct mnt_idmap *, struct inode *, umode_t *,
>  			  struct posix_acl **);
>  
>  int simple_set_acl(struct mnt_idmap *, struct dentry *,
> @@ -96,7 +96,7 @@ void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
>  void forget_cached_acl(struct inode *inode, int type);
>  void forget_all_cached_acls(struct inode *inode);
>  int posix_acl_valid(struct user_namespace *, const struct posix_acl *);
> -int posix_acl_permission(struct mnt_idmap *, struct inode *,
> +int posix_acl_permission(const struct mnt_idmap *, struct inode *,
>  			 const struct posix_acl *, int);
>  
>  static inline void cache_no_acl(struct inode *inode)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 4598a13657ee..12bc12e243bf 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -430,16 +430,16 @@ int security_inode_getattr(const struct path *path);
>  int security_inode_setxattr(struct mnt_idmap *idmap,
>  			    struct dentry *dentry, const char *name,
>  			    const void *value, size_t size, int flags);
> -int security_inode_set_acl(struct mnt_idmap *idmap,
> +int security_inode_set_acl(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, const char *acl_name,
>  			   struct posix_acl *kacl);
>  void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
>  				 struct posix_acl *kacl);
> -int security_inode_get_acl(struct mnt_idmap *idmap,
> +int security_inode_get_acl(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, const char *acl_name);
> -int security_inode_remove_acl(struct mnt_idmap *idmap,
> +int security_inode_remove_acl(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, const char *acl_name);
> -void security_inode_post_remove_acl(struct mnt_idmap *idmap,
> +void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry,
>  				    const char *acl_name);
>  void security_inode_post_setxattr(struct dentry *dentry, const char *name,
> @@ -1003,7 +1003,7 @@ static inline int security_inode_setxattr(struct mnt_idmap *idmap,
>  	return cap_inode_setxattr(dentry, name, value, size, flags);
>  }
>  
> -static inline int security_inode_set_acl(struct mnt_idmap *idmap,
> +static inline int security_inode_set_acl(const struct mnt_idmap *idmap,
>  					 struct dentry *dentry,
>  					 const char *acl_name,
>  					 struct posix_acl *kacl)
> @@ -1016,21 +1016,21 @@ static inline void security_inode_post_set_acl(struct dentry *dentry,
>  					       struct posix_acl *kacl)
>  { }
>  
> -static inline int security_inode_get_acl(struct mnt_idmap *idmap,
> +static inline int security_inode_get_acl(const struct mnt_idmap *idmap,
>  					 struct dentry *dentry,
>  					 const char *acl_name)
>  {
>  	return 0;
>  }
>  
> -static inline int security_inode_remove_acl(struct mnt_idmap *idmap,
> +static inline int security_inode_remove_acl(const struct mnt_idmap *idmap,
>  					    struct dentry *dentry,
>  					    const char *acl_name)
>  {
>  	return 0;
>  }
>  
> -static inline void security_inode_post_remove_acl(struct mnt_idmap *idmap,
> +static inline void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
>  						  struct dentry *dentry,
>  						  const char *acl_name)
>  { }
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 06e187c9912d..aaf228ebed7c 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -652,7 +652,7 @@ static int evm_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  }
>  
>  #ifdef CONFIG_FS_POSIX_ACL
> -static int evm_inode_set_acl_change(struct mnt_idmap *idmap,
> +static int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry, const char *name,
>  				    struct posix_acl *kacl)
>  {
> @@ -671,7 +671,7 @@ static int evm_inode_set_acl_change(struct mnt_idmap *idmap,
>  	return 0;
>  }
>  #else
> -static inline int evm_inode_set_acl_change(struct mnt_idmap *idmap,
> +static inline int evm_inode_set_acl_change(const struct mnt_idmap *idmap,
>  					   struct dentry *dentry,
>  					   const char *name,
>  					   struct posix_acl *kacl)
> @@ -693,7 +693,7 @@ static inline int evm_inode_set_acl_change(struct mnt_idmap *idmap,
>   *
>   * Return: zero on success, -EPERM on failure.
>   */
> -static int evm_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int evm_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			     const char *acl_name, struct posix_acl *kacl)
>  {
>  	enum integrity_status evm_status;
> @@ -745,7 +745,7 @@ static int evm_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>   *
>   * Return: zero on success, -EPERM on failure.
>   */
> -static int evm_inode_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int evm_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				const char *acl_name)
>  {
>  	return evm_inode_set_acl(idmap, dentry, acl_name, NULL);
> @@ -926,7 +926,7 @@ static void evm_inode_post_removexattr(struct dentry *dentry,
>   * Update the 'security.evm' xattr with the EVM HMAC re-calculated after
>   * removing posix acls.
>   */
> -static inline void evm_inode_post_remove_acl(struct mnt_idmap *idmap,
> +static inline void evm_inode_post_remove_acl(const struct mnt_idmap *idmap,
>  					     struct dentry *dentry,
>  					     const char *acl_name)
>  {
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 6b21db789ef1..1aed041c127a 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -790,7 +790,7 @@ static int ima_inode_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return result;
>  }
>  
> -static int ima_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int ima_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			     const char *acl_name, struct posix_acl *kacl)
>  {
>  	if (evm_revalidate_status(acl_name))
> @@ -815,7 +815,7 @@ static int ima_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return result;
>  }
>  
> -static int ima_inode_remove_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int ima_inode_remove_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				const char *acl_name)
>  {
>  	return ima_inode_set_acl(idmap, dentry, acl_name, NULL);
> diff --git a/security/security.c b/security/security.c
> index 2ee276ab15c5..e81dcda3050b 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1953,7 +1953,7 @@ int security_inode_setxattr(struct mnt_idmap *idmap,
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_set_acl(struct mnt_idmap *idmap,
> +int security_inode_set_acl(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, const char *acl_name,
>  			   struct posix_acl *kacl)
>  {
> @@ -1990,7 +1990,7 @@ void security_inode_post_set_acl(struct dentry *dentry, const char *acl_name,
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_get_acl(struct mnt_idmap *idmap,
> +int security_inode_get_acl(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, const char *acl_name)
>  {
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> @@ -2009,7 +2009,7 @@ int security_inode_get_acl(struct mnt_idmap *idmap,
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_remove_acl(struct mnt_idmap *idmap,
> +int security_inode_remove_acl(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, const char *acl_name)
>  {
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> @@ -2026,7 +2026,7 @@ int security_inode_remove_acl(struct mnt_idmap *idmap,
>   * Update inode security data after successfully removing posix acls on
>   * @dentry in @idmap. The posix acls are identified by @acl_name.
>   */
> -void security_inode_post_remove_acl(struct mnt_idmap *idmap,
> +void security_inode_post_remove_acl(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry, const char *acl_name)
>  {
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 035aaf113d1d..672d6374d8b0 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3453,20 +3453,20 @@ static int selinux_inode_setxattr(struct mnt_idmap *idmap,
>  			    &ad);
>  }
>  
> -static int selinux_inode_set_acl(struct mnt_idmap *idmap,
> +static int selinux_inode_set_acl(const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, const char *acl_name,
>  				 struct posix_acl *kacl)
>  {
>  	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
>  }
>  
> -static int selinux_inode_get_acl(struct mnt_idmap *idmap,
> +static int selinux_inode_get_acl(const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, const char *acl_name)
>  {
>  	return dentry_has_perm(current_cred(), dentry, FILE__GETATTR);
>  }
>  
> -static int selinux_inode_remove_acl(struct mnt_idmap *idmap,
> +static int selinux_inode_remove_acl(const struct mnt_idmap *idmap,
>  				    struct dentry *dentry, const char *acl_name)
>  {
>  	return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 8e88ac65fd7f..244cdb49e928 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1543,7 +1543,7 @@ static int smack_inode_removexattr(struct mnt_idmap *idmap,
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_set_acl(struct mnt_idmap *idmap,
> +static int smack_inode_set_acl(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, const char *acl_name,
>  			       struct posix_acl *kacl)
>  {
> @@ -1566,7 +1566,7 @@ static int smack_inode_set_acl(struct mnt_idmap *idmap,
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_get_acl(struct mnt_idmap *idmap,
> +static int smack_inode_get_acl(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, const char *acl_name)
>  {
>  	struct smk_audit_info ad;
> @@ -1588,7 +1588,7 @@ static int smack_inode_get_acl(struct mnt_idmap *idmap,
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_remove_acl(struct mnt_idmap *idmap,
> +static int smack_inode_remove_acl(const struct mnt_idmap *idmap,
>  				  struct dentry *dentry, const char *acl_name)
>  {
>  	struct smk_audit_info ad;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
