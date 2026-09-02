Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBE04A9D46;
	Wed,  2 Sep 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364983; cv=none; b=o3DDCTcbV6FGZksDaCEKZKfDlo4Ao1fA5xvSMHOszL5PZJ0vd/Dpbh2O+akYWKStCvtq/aORv83Hdj5zQrVbbxwf/p0RzNsZo/A3AqnvND5LHDUJIH5K2RNoQvf2RGR7NGJEcdTTEvfsGHk0K9bC8wd9arMdwofmsGpAodK+wWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364983; c=relaxed/simple;
	bh=HsygTzcif32HXcEBLL9ZV6GPJhAa2FOTk4u+ob8NehY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkPCpeWU+tT8ZczDujq0q3xJ/RSbfIzERChWzZMk4A8Ud1OmzovoV8NO/lHP/ChMDeMTLQZkxUACA5nSYdK+8PmViwOPTI6SDOi0rrnl+yFXnKiB5FvvSh1mndy3mvitlNqtQx6H0IGE2kMg6qqMIzXA2vjj9DZOVhW2Q/Od39o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AJStpF7h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T3Oiqh7u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1QVSfmEh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RcMISohv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AJStpF7h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T3Oiqh7u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1QVSfmEh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RcMISohv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1766021CC0;
	Wed,  2 Sep 2026 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdDMPxNCIBFQNL+uLKvaJ+WaYLrmiG55V4yIQYE/a6I=;
	b=AJStpF7hiOTPtKozAkghpixe2rzvDIt+mYHaFYK6KNVL/E8H/tjlpA4YXR0mceuW3S4Hjx
	CXvxLsjaojL+7ebQGLDoVU5IwqhR32IR5q195hS6uR+HMObUA4PPMflqMRLO5KYUa+qVLa
	90E3s7LxYaRFEPloxBhq5hcyCKc+ISg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364975;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdDMPxNCIBFQNL+uLKvaJ+WaYLrmiG55V4yIQYE/a6I=;
	b=T3Oiqh7uSJf3pHjXlG8GBJKu3YZI0XMzmMCJsehC/vdDTldv8RpfR3Y/QV+CaB2be6XwR0
	kNNqMNA75sFYfbCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1QVSfmEh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RcMISohv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdDMPxNCIBFQNL+uLKvaJ+WaYLrmiG55V4yIQYE/a6I=;
	b=1QVSfmEhM3+Jrwlez2VarStEgNfdjzlc9YeTFSp54vJ5Wdk9OlapuNWtFoGPAI4S/B6NeA
	L7OIlSl32HZyUXNJF7uzOx0nkmnHJbLV9WFHwnYSnCjvQ11O47LpQDppRVmeHFms3+MGuc
	0KziNSrpyOoriE65NGumNyh1XWpWjFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364971;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LdDMPxNCIBFQNL+uLKvaJ+WaYLrmiG55V4yIQYE/a6I=;
	b=RcMISohvQXUC5WlfA1zUgu0gU3aiTVgO5UapcroIY0iyvextL7NcqFRRq0if9A/TF6cuKd
	9mj78dgxWTpk+NBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E954B13515;
	Wed,  2 Sep 2026 16:02:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I2v0OKpImGpvdgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 16:02:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 914C1A13B5; Wed, 02 Sep 2026 18:02:46 +0200 (CEST)
Date: Wed, 2 Sep 2026 18:02:46 +0200
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
Subject: Re: [PATCH 25/27] fs: port vfs_*() helpers to const mnt_idmap
Message-ID: <hkuct3g6weocxhksq6x23osse2i44gr54cfnnacphxfxqtjgas@4gzzwlypnqxc>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-25-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-25-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1766021CC0
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

On Tue 01-09-26 14:14:50, Christian Brauner wrote:
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
>  fs/btrfs/ioctl.c      |  4 ++--
>  fs/internal.h         |  2 +-
>  fs/namei.c            | 44 ++++++++++++++++++++++----------------------
>  fs/open.c             |  2 +-
>  include/linux/fs.h    | 30 +++++++++++++++---------------
>  include/linux/namei.h | 16 ++++++++--------
>  6 files changed, 49 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 94c98801800f..e20e66c0fead 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -864,7 +864,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>   * inside this filesystem so it's quite a bit simpler.
>   */
>  static noinline int btrfs_mksubvol(struct dentry *parent,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct qstr *qname, struct btrfs_root *snap_src,
>  				   bool readonly,
>  				   struct btrfs_qgroup_inherit *inherit)
> @@ -911,7 +911,7 @@ static noinline int btrfs_mksubvol(struct dentry *parent,
>  }
>  
>  static noinline int btrfs_mksnapshot(struct dentry *parent,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct qstr *qname,
>  				   struct btrfs_root *root,
>  				   bool readonly,
> diff --git a/fs/internal.h b/fs/internal.h
> index 2b8cffc22fb3..973436f44770 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -63,7 +63,7 @@ int filename_mknodat(int dfd, struct filename *name, umode_t mode, unsigned int
>  int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
>  int filename_linkat(int olddfd, struct filename *old, int newdfd,
>  			struct filename *new, int flags);
> -int vfs_tmpfile(struct mnt_idmap *idmap,
> +int vfs_tmpfile(const struct mnt_idmap *idmap,
>  		const struct path *parentpath,
>  		struct file *file, umode_t mode);
>  struct dentry *d_hash_and_lookup(struct dentry *, struct qstr *);
> diff --git a/fs/namei.c b/fs/namei.c
> index f5e00ae41ed4..14970fe08387 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3111,7 +3111,7 @@ int lookup_noperm_common(struct qstr *qname, struct dentry *base)
>  	return 0;
>  }
>  
> -static int lookup_one_common(struct mnt_idmap *idmap,
> +static int lookup_one_common(const struct mnt_idmap *idmap,
>  			     struct qstr *qname, struct dentry *base)
>  {
>  	int err;
> @@ -3190,7 +3190,7 @@ EXPORT_SYMBOL(lookup_noperm);
>   *
>   * The caller must hold base->i_rwsem.
>   */
> -struct dentry *lookup_one(struct mnt_idmap *idmap, struct qstr *name,
> +struct dentry *lookup_one(const struct mnt_idmap *idmap, struct qstr *name,
>  			  struct dentry *base)
>  {
>  	struct dentry *dentry;
> @@ -3223,7 +3223,7 @@ EXPORT_SYMBOL(lookup_one);
>   *	    - ERR_PTR(-ENOENT) if parent has been removed, or
>   *	    - ERR_PTR(-EACCES) if parent directory is not searchable.
>   */
> -struct dentry *lookup_one_unlocked(struct mnt_idmap *idmap, struct qstr *name,
> +struct dentry *lookup_one_unlocked(const struct mnt_idmap *idmap, struct qstr *name,
>  				   struct dentry *base)
>  {
>  	int err;
> @@ -3263,7 +3263,7 @@ EXPORT_SYMBOL(lookup_one_unlocked);
>   *	   - same errors as lookup_one_unlocked() or
>   *	   - ERR_PTR(-EINTR) if a fatal signal is pending.
>   */
> -struct dentry *lookup_one_positive_killable(struct mnt_idmap *idmap,
> +struct dentry *lookup_one_positive_killable(const struct mnt_idmap *idmap,
>  					    struct qstr *name,
>  					    struct dentry *base)
>  {
> @@ -3306,7 +3306,7 @@ EXPORT_SYMBOL(lookup_one_positive_killable);
>   *	   - ERR_PTR(-ENOENT) if the name could not be found, or
>   *	   - same errors as lookup_one_unlocked().
>   */
> -struct dentry *lookup_one_positive_unlocked(struct mnt_idmap *idmap,
> +struct dentry *lookup_one_positive_unlocked(const struct mnt_idmap *idmap,
>  					    struct qstr *name,
>  					    struct dentry *base)
>  {
> @@ -3396,7 +3396,7 @@ EXPORT_SYMBOL(lookup_noperm_positive_unlocked);
>   *
>   * Returns: a negative or positive dentry, or an error.
>   */
> -struct dentry *start_creating(struct mnt_idmap *idmap, struct dentry *parent,
> +struct dentry *start_creating(const struct mnt_idmap *idmap, struct dentry *parent,
>  			      struct qstr *name)
>  {
>  	int err = lookup_one_common(idmap, name, parent);
> @@ -3423,7 +3423,7 @@ EXPORT_SYMBOL(start_creating);
>   *
>   * Returns: a positive dentry, or an error.
>   */
> -struct dentry *start_removing(struct mnt_idmap *idmap, struct dentry *parent,
> +struct dentry *start_removing(const struct mnt_idmap *idmap, struct dentry *parent,
>  			      struct qstr *name)
>  {
>  	int err = lookup_one_common(idmap, name, parent);
> @@ -3451,7 +3451,7 @@ EXPORT_SYMBOL(start_removing);
>   *
>   * Returns: a negative or positive dentry, or an error.
>   */
> -struct dentry *start_creating_killable(struct mnt_idmap *idmap,
> +struct dentry *start_creating_killable(const struct mnt_idmap *idmap,
>  				       struct dentry *parent,
>  				       struct qstr *name)
>  {
> @@ -3482,7 +3482,7 @@ EXPORT_SYMBOL(start_creating_killable);
>   *
>   * Returns: a positive dentry, or an error.
>   */
> -struct dentry *start_removing_killable(struct mnt_idmap *idmap,
> +struct dentry *start_removing_killable(const struct mnt_idmap *idmap,
>  				       struct dentry *parent,
>  				       struct qstr *name)
>  {
> @@ -3642,7 +3642,7 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
>  }
>  EXPORT_SYMBOL(user_path_at);
>  
> -int __check_sticky(struct mnt_idmap *idmap, struct inode *dir,
> +int __check_sticky(const struct mnt_idmap *idmap, struct inode *dir,
>  		   struct inode *inode)
>  {
>  	kuid_t fsuid = current_fsuid();
> @@ -3675,7 +3675,7 @@ EXPORT_SYMBOL(__check_sticky);
>   * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
>   *     nfs_async_unlink().
>   */
> -int may_delete_dentry(struct mnt_idmap *idmap, struct inode *dir,
> +int may_delete_dentry(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *victim, bool isdir)
>  {
>  	struct inode *inode = d_backing_inode(victim);
> @@ -3728,7 +3728,7 @@ EXPORT_SYMBOL(may_delete_dentry);
>   *  4. We should have write and exec permissions on dir
>   *  5. We can't do it if dir is immutable (done in permission())
>   */
> -int may_create_dentry(struct mnt_idmap *idmap,
> +int may_create_dentry(const struct mnt_idmap *idmap,
>  		      struct inode *dir, struct dentry *child)
>  {
>  	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
> @@ -4174,7 +4174,7 @@ static inline umode_t vfs_prepare_mode(const struct mnt_idmap *idmap,
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_create(struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
> +int vfs_create(const struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
>  	       struct delegated_inode *di)
>  {
>  	struct inode *dir = d_inode(dentry->d_parent);
> @@ -4287,7 +4287,7 @@ static int may_open(const struct mnt_idmap *idmap, const struct path *path,
>  	return 0;
>  }
>  
> -static int handle_truncate(struct mnt_idmap *idmap, struct file *filp)
> +static int handle_truncate(const struct mnt_idmap *idmap, struct file *filp)
>  {
>  	const struct path *path = &filp->f_path;
>  	struct inode *inode = path->dentry->d_inode;
> @@ -4863,7 +4863,7 @@ static int do_open(struct nameidata *nd,
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_tmpfile(struct mnt_idmap *idmap,
> +int vfs_tmpfile(const struct mnt_idmap *idmap,
>  		const struct path *parentpath,
>  		struct file *file, umode_t mode)
>  {
> @@ -4921,7 +4921,7 @@ int vfs_tmpfile(struct mnt_idmap *idmap,
>   * hence this is only for kernel internal use, and must not be installed into
>   * file tables or such.
>   */
> -struct file *kernel_tmpfile_open(struct mnt_idmap *idmap,
> +struct file *kernel_tmpfile_open(const struct mnt_idmap *idmap,
>  				 const struct path *parentpath,
>  				 umode_t mode, int open_flag,
>  				 const struct cred *cred)
> @@ -5236,7 +5236,7 @@ EXPORT_SYMBOL(dentry_create);
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
> +int vfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
>  	      struct dentry *dentry, umode_t mode, dev_t dev,
>  	      struct delegated_inode *delegated_inode)
>  {
> @@ -5378,7 +5378,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
>   *
>   * In case of an error the dentry is dput() and an ERR_PTR() is returned.
>   */
> -struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
> +struct dentry *vfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct dentry *dentry, umode_t mode,
>  			 struct delegated_inode *delegated_inode)
>  {
> @@ -5485,7 +5485,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
> +int vfs_rmdir(const struct mnt_idmap *idmap, struct inode *dir,
>  	      struct dentry *dentry, struct delegated_inode *delegated_inode)
>  {
>  	int error = may_delete_dentry(idmap, dir, dentry, true);
> @@ -5620,7 +5620,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_unlink(struct mnt_idmap *idmap, struct inode *dir,
> +int vfs_unlink(const struct mnt_idmap *idmap, struct inode *dir,
>  	       struct dentry *dentry, struct delegated_inode *delegated_inode)
>  {
>  	struct inode *target = dentry->d_inode;
> @@ -5770,7 +5770,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pathname)
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
> +int vfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *dentry, const char *oldname,
>  		struct delegated_inode *delegated_inode)
>  {
> @@ -5872,7 +5872,7 @@ SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newn
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int vfs_link(struct dentry *old_dentry, struct mnt_idmap *idmap,
> +int vfs_link(struct dentry *old_dentry, const struct mnt_idmap *idmap,
>  	     struct inode *dir, struct dentry *new_dentry,
>  	     struct delegated_inode *delegated_inode)
>  {
> diff --git a/fs/open.c b/fs/open.c
> index 6b1c14e684a9..971e51008e67 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -36,7 +36,7 @@
>  
>  #include "internal.h"
>  
> -int do_truncate(struct mnt_idmap *idmap, struct dentry *dentry,
> +int do_truncate(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		loff_t length, unsigned int time_attrs, struct file *filp)
>  {
>  	int ret;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 55d8e7e473ff..935b0f92786f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1761,19 +1761,19 @@ bool inode_owner_or_capable(const struct mnt_idmap *idmap,
>  /*
>   * VFS helper functions..
>   */
> -int vfs_create(struct mnt_idmap *, struct dentry *, umode_t,
> +int vfs_create(const struct mnt_idmap *, struct dentry *, umode_t,
>  	       struct delegated_inode *);
> -struct dentry *vfs_mkdir(struct mnt_idmap *, struct inode *,
> +struct dentry *vfs_mkdir(const struct mnt_idmap *, struct inode *,
>  			 struct dentry *, umode_t, struct delegated_inode *);
> -int vfs_mknod(struct mnt_idmap *, struct inode *, struct dentry *,
> +int vfs_mknod(const struct mnt_idmap *, struct inode *, struct dentry *,
>  	      umode_t, dev_t, struct delegated_inode *);
> -int vfs_symlink(struct mnt_idmap *, struct inode *,
> +int vfs_symlink(const struct mnt_idmap *, struct inode *,
>  		struct dentry *, const char *, struct delegated_inode *);
> -int vfs_link(struct dentry *, struct mnt_idmap *, struct inode *,
> +int vfs_link(struct dentry *, const struct mnt_idmap *, struct inode *,
>  	     struct dentry *, struct delegated_inode *);
> -int vfs_rmdir(struct mnt_idmap *, struct inode *, struct dentry *,
> +int vfs_rmdir(const struct mnt_idmap *, struct inode *, struct dentry *,
>  	      struct delegated_inode *);
> -int vfs_unlink(struct mnt_idmap *, struct inode *, struct dentry *,
> +int vfs_unlink(const struct mnt_idmap *, struct inode *, struct dentry *,
>  	       struct delegated_inode *);
>  
>  /**
> @@ -1787,7 +1787,7 @@ int vfs_unlink(struct mnt_idmap *, struct inode *, struct dentry *,
>   * @flags:             rename flags
>   */
>  struct renamedata {
> -	struct mnt_idmap *mnt_idmap;
> +	const struct mnt_idmap *mnt_idmap;
>  	struct dentry *old_parent;
>  	struct dentry *old_dentry;
>  	struct dentry *new_parent;
> @@ -1798,14 +1798,14 @@ struct renamedata {
>  
>  int vfs_rename(struct renamedata *);
>  
> -static inline int vfs_whiteout(struct mnt_idmap *idmap,
> +static inline int vfs_whiteout(const struct mnt_idmap *idmap,
>  			       struct inode *dir, struct dentry *dentry)
>  {
>  	return vfs_mknod(idmap, dir, dentry, S_IFCHR | WHITEOUT_MODE,
>  			 WHITEOUT_DEV, NULL);
>  }
>  
> -struct file *kernel_tmpfile_open(struct mnt_idmap *idmap,
> +struct file *kernel_tmpfile_open(const struct mnt_idmap *idmap,
>  				 const struct path *parentpath,
>  				 umode_t mode, int open_flag,
>  				 const struct cred *cred);
> @@ -2483,7 +2483,7 @@ static inline bool is_idmapped_mnt(const struct vfsmount *mnt)
>  }
>  
>  int vfs_truncate(const struct path *, loff_t);
> -int do_truncate(struct mnt_idmap *, struct dentry *, loff_t start,
> +int do_truncate(const struct mnt_idmap *, struct dentry *, loff_t start,
>  		unsigned int time_attrs, struct file *filp);
>  extern int vfs_fallocate(struct file *file, int mode, loff_t offset,
>  			loff_t len);
> @@ -2721,12 +2721,12 @@ static inline int path_permission(const struct path *path, int mask)
>  	return inode_permission(mnt_idmap(path->mnt),
>  				d_inode(path->dentry), mask);
>  }
> -int __check_sticky(struct mnt_idmap *idmap, struct inode *dir,
> +int __check_sticky(const struct mnt_idmap *idmap, struct inode *dir,
>  		   struct inode *inode);
>  
> -int may_delete_dentry(struct mnt_idmap *idmap, struct inode *dir,
> +int may_delete_dentry(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *victim, bool isdir);
> -int may_create_dentry(struct mnt_idmap *idmap,
> +int may_create_dentry(const struct mnt_idmap *idmap,
>  		      struct inode *dir, struct dentry *child);
>  
>  static inline bool execute_ok(struct inode *inode)
> @@ -3578,7 +3578,7 @@ static inline bool is_sxid(umode_t mode)
>  	return mode & (S_ISUID | S_ISGID);
>  }
>  
> -static inline int check_sticky(struct mnt_idmap *idmap,
> +static inline int check_sticky(const struct mnt_idmap *idmap,
>  			       struct inode *dir, struct inode *inode)
>  {
>  	if (!(dir->i_mode & S_ISVTX))
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 86d657b24fc6..da5b4ccca1b5 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -70,24 +70,24 @@ extern struct dentry *try_lookup_noperm(struct qstr *, struct dentry *);
>  extern struct dentry *lookup_noperm(struct qstr *, struct dentry *);
>  extern struct dentry *lookup_noperm_unlocked(struct qstr *, struct dentry *);
>  extern struct dentry *lookup_noperm_positive_unlocked(struct qstr *, struct dentry *);
> -struct dentry *lookup_one(struct mnt_idmap *, struct qstr *, struct dentry *);
> -struct dentry *lookup_one_unlocked(struct mnt_idmap *idmap,
> +struct dentry *lookup_one(const struct mnt_idmap *, struct qstr *, struct dentry *);
> +struct dentry *lookup_one_unlocked(const struct mnt_idmap *idmap,
>  				   struct qstr *name, struct dentry *base);
> -struct dentry *lookup_one_positive_unlocked(struct mnt_idmap *idmap,
> +struct dentry *lookup_one_positive_unlocked(const struct mnt_idmap *idmap,
>  					    struct qstr *name,
>  					    struct dentry *base);
> -struct dentry *lookup_one_positive_killable(struct mnt_idmap *idmap,
> +struct dentry *lookup_one_positive_killable(const struct mnt_idmap *idmap,
>  					    struct qstr *name,
>  					    struct dentry *base);
>  
> -struct dentry *start_creating(struct mnt_idmap *idmap, struct dentry *parent,
> +struct dentry *start_creating(const struct mnt_idmap *idmap, struct dentry *parent,
>  			      struct qstr *name);
> -struct dentry *start_removing(struct mnt_idmap *idmap, struct dentry *parent,
> +struct dentry *start_removing(const struct mnt_idmap *idmap, struct dentry *parent,
>  			      struct qstr *name);
> -struct dentry *start_creating_killable(struct mnt_idmap *idmap,
> +struct dentry *start_creating_killable(const struct mnt_idmap *idmap,
>  				       struct dentry *parent,
>  				       struct qstr *name);
> -struct dentry *start_removing_killable(struct mnt_idmap *idmap,
> +struct dentry *start_removing_killable(const struct mnt_idmap *idmap,
>  				       struct dentry *parent,
>  				       struct qstr *name);
>  struct dentry *start_creating_noperm(struct dentry *parent, struct qstr *name);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
