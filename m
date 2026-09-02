Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AED64A0EFC;
	Wed,  2 Sep 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365228; cv=none; b=fJ+UOPgWO1E9P+kOw3Vn76a2o9mzZOrOthOVqtYdDCArcMAjo6AtIId6YtMKXAn3AxbJI/eSWZXP56QegU0i4/efSXagIDjBrO2SZKZ+4KrDA5Kpn/yDzITZe+QH9Ur6UjVAtn/Mh1e0VpSsBFeSwYUFB2OizyRGMgi25OM7EqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365228; c=relaxed/simple;
	bh=72EPfSIswZd+f3eTL8BEdt9M/lR194Vhoz5TP6l9e0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBzgZ2Mk39KdFaUIvmWsn8C98Q1DiIGuaGMCZ/AvOXAFmnEBrCjLodjXdnitwqxjI5x4IqxByW5Ga1gb4nmWea7TDwIMQSrg2GBHc1tiQGxtfxI+o5jo9waU6bnzuR901wYPj4S11z/VachJ1FD9a8PVDFXVhAsvvGyXnQ7AhVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UPtO9+dP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ifpQ0Yoc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=czZ+wCPh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7LeFpReK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UPtO9+dP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ifpQ0Yoc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="czZ+wCPh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7LeFpReK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E885221CF8;
	Wed,  2 Sep 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788365219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aYYiFTeUBVr5sNML9uOTND/yUMHOmXEgerRWcixxesQ=;
	b=UPtO9+dPHyo65SXukerUNZbGrSh+DRX/oD/TqFesNtxP6TWWa4op95fMKu+HSmF+QY/iM4
	ttGOQygE8Biet4gzLi1ls0Ny7xWdV7NEWqVy9JmsuEIM6kFg5TuvniYLjiblEx9XEtf8Qu
	WXEiJazxQ8nPra2wIPRAsuf7IJTS5Rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788365219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aYYiFTeUBVr5sNML9uOTND/yUMHOmXEgerRWcixxesQ=;
	b=ifpQ0YocmMOql/tgU+lJ8ObLpCSbz7ZvgH6esYS2diXc5YAO22dGsf/KAYYwn7BqfrDHpM
	DE/mYGrpC0FZT2DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=czZ+wCPh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7LeFpReK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788365215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aYYiFTeUBVr5sNML9uOTND/yUMHOmXEgerRWcixxesQ=;
	b=czZ+wCPhyWcYLF19iYObdz4i5eiUp5FJv5lU7/2a74qW7MqPlRdNO2I4wAMLX8m5R15tD+
	zCQ6Hdg+ktWA4Npp44K0EC6DjQUmuTHfTOOIpHlojOHe8Fl8r9UqtMsJK4eG/R8aVTQSXY
	4HnIodtuweiaAOs1R9xjt11JySTzAc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788365215;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aYYiFTeUBVr5sNML9uOTND/yUMHOmXEgerRWcixxesQ=;
	b=7LeFpReKqez7zP/gOtrsdSnRS/Qd7CD3bcfIuHvNamFXk7s98Lub3CQ9AcDDh3UQ2zX2YI
	h9O5VXXpl+Yt3ZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C473913736;
	Wed,  2 Sep 2026 16:06:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6gTeL55JmGqregAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 16:06:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5A605A13B5; Wed, 02 Sep 2026 18:06:50 +0200 (CEST)
Date: Wed, 2 Sep 2026 18:06:50 +0200
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
Subject: Re: [PATCH 26/27] fs: port mnt_idmap() and file_mnt_idmap() to const
 mnt_idmap
Message-ID: <djx7eu2so7sp3p6qoj2bxgeoddb2lvzm3vl7pnscaoccig45db@jq7p2tsyzzf4>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-26-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-26-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: E885221CF8
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
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:51, Christian Brauner wrote:
> Now that everything takes a mnt_idmap as const store a const pointer in
> struct vfsmount, struct mount_kattr and struct kstatmount and return one
> from mnt_idmap(), file_mnt_idmap() and ovl_upper_mnt_idmap(). Finally,
> also make mnt_idmap_get() return a const pointer. Also convert the
> remaining local variables that are initialized from the accessors.
> 
> alloc_mnt_idmap() keeps returning a non-const pointer. It is the only
> place where an idmapping is actually written to.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  Documentation/filesystems/porting.rst | 13 +++++++++++++
>  fs/backing-file.c                     |  2 +-
>  fs/btrfs/ioctl.c                      |  4 ++--
>  fs/ceph/file.c                        |  2 +-
>  fs/coredump.c                         |  2 +-
>  fs/exec.c                             |  4 ++--
>  fs/ext4/ioctl.c                       |  2 +-
>  fs/f2fs/file.c                        |  6 +++---
>  fs/fhandle.c                          |  2 +-
>  fs/file_attr.c                        |  4 ++--
>  fs/fuse/dir.c                         |  2 +-
>  fs/fuse/file.c                        |  2 +-
>  fs/internal.h                         |  2 +-
>  fs/mnt_idmapping.c                    |  4 ++--
>  fs/namei.c                            | 14 +++++++-------
>  fs/namespace.c                        |  8 ++++----
>  fs/open.c                             |  4 ++--
>  fs/overlayfs/file.c                   |  2 +-
>  fs/overlayfs/inode.c                  |  2 +-
>  fs/overlayfs/ovl_entry.h              |  2 +-
>  fs/overlayfs/util.c                   |  4 ++--
>  fs/remap_range.c                      |  2 +-
>  fs/smb/server/oplock.c                |  2 +-
>  fs/smb/server/smb2pdu.c               | 20 ++++++++++----------
>  fs/smb/server/smb_common.c            |  2 +-
>  fs/smb/server/smbacl.c                |  6 +++---
>  fs/smb/server/vfs.c                   | 10 +++++-----
>  fs/stat.c                             |  2 +-
>  include/linux/fs.h                    |  2 +-
>  include/linux/mnt_idmapping.h         |  2 +-
>  include/linux/mount.h                 |  4 ++--
>  net/unix/af_unix.c                    |  2 +-
>  security/apparmor/lsm.c               |  4 ++--
>  33 files changed, 79 insertions(+), 66 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 60880eb0c49d..b967a129e380 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1409,3 +1409,16 @@ use only if you have no alternative.
>  The .create inode_operation no longer receives the 'excl' arg.  It must
>  always assume the file does not already exist.  If the filesystem needs
>  to be involved in non-exclusive create, it should provide atomic_open.
> +
> +---
> +
> +**mandatory**
> +
> +All struct mnt_idmap pointers handed to filesystems are const now.
> +->create(), ->mkdir(), ->mknod(), ->symlink(), ->rename(), ->setattr(),
> +->getattr(), ->permission(), ->tmpfile(), ->get_acl(), ->set_acl() and
> +->fileattr_set() as well as the xattr ->set() handler and the vfs_*()
> +helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
> +return one. The idmapping is immutable so nothing should have modified it
> +anyway. References are taken and dropped via mnt_idmap_get() and
> +mnt_idmap_put() as before, both accept a const pointer.
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index cc101143f921..5614cb7801e1 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -59,7 +59,7 @@ struct file *backing_tmpfile_open(const struct file *user_file, int flags,
>  				  const struct path *real_parentpath,
>  				  umode_t mode, const struct cred *cred)
>  {
> -	struct mnt_idmap *real_idmap = mnt_idmap(real_parentpath->mnt);
> +	const struct mnt_idmap *real_idmap = mnt_idmap(real_parentpath->mnt);
>  	const struct path *user_path = &user_file->f_path;
>  	struct file *f;
>  	int error;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e20e66c0fead..efeb5561015c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1149,7 +1149,7 @@ static noinline int __btrfs_ioctl_snap_create(struct file *file,
>  {
>  	int ret;
>  	struct qstr qname = QSTR(name);
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  
>  	if (!S_ISDIR(file_inode(file)->i_mode))
>  		return -ENOTDIR;
> @@ -2226,7 +2226,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  	struct btrfs_root *dest = NULL;
>  	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
>  	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args2);
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	char *subvol_name, *subvol_name_ptr = NULL;
>  	int ret = 0;
>  	bool destroy_parent = false;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index bd3e3f5c269e..2c994c08ed4b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -795,7 +795,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
>  int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  		     struct file *file, unsigned flags, umode_t mode)
>  {
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(dir->i_sb);
>  	struct ceph_client *cl = fsc->client;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> diff --git a/fs/coredump.c b/fs/coredump.c
> index ac3cd74808c6..9f75e16d3b36 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -878,7 +878,7 @@ static inline bool coredump_force_suid_safe(const struct coredump_params *cprm)
>  static bool coredump_file(struct core_name *cn, struct coredump_params *cprm,
>  			  const struct linux_binfmt *binfmt)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct inode *inode;
>  	struct file *file __free(fput) = NULL;
>  	int open_flags = O_CREAT | O_WRONLY | O_NOFOLLOW | O_LARGEFILE | O_EXCL;
> diff --git a/fs/exec.c b/fs/exec.c
> index 745f6eb5279e..a7785559d0d3 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1339,7 +1339,7 @@ EXPORT_SYMBOL(begin_new_exec);
>  void would_dump(struct linux_binprm *bprm, struct file *file)
>  {
>  	struct inode *inode = file_inode(file);
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	if (inode_permission(idmap, inode, MAY_READ) < 0) {
>  		struct user_namespace *old, *user_ns;
>  		bprm->interp_flags |= BINPRM_FLAGS_ENFORCE_NONDUMP;
> @@ -1623,7 +1623,7 @@ static void check_unsafe_exec(struct linux_binprm *bprm)
>  static void bprm_fill_uid(struct linux_binprm *bprm, struct file *file)
>  {
>  	/* Handle suid and sgid on files */
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct inode *inode = file_inode(file);
>  	unsigned int mode;
>  	vfsuid_t vfsuid;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 2719f20493c8..0a54b00e5be5 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1539,7 +1539,7 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct super_block *sb = inode->i_sb;
> -	struct mnt_idmap *idmap = file_mnt_idmap(filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(filp);
>  
>  	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
>  
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index fb8b03a9972d..8596c3bc4704 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -2361,7 +2361,7 @@ static int f2fs_ioc_getversion(struct file *filp, unsigned long arg)
>  static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
>  {
>  	struct inode *inode = file_inode(filp);
> -	struct mnt_idmap *idmap = file_mnt_idmap(filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(filp);
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
>  	loff_t isize;
> @@ -2473,7 +2473,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp, bool truncate)
>  static int f2fs_ioc_commit_atomic_write(struct file *filp)
>  {
>  	struct inode *inode = file_inode(filp);
> -	struct mnt_idmap *idmap = file_mnt_idmap(filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(filp);
>  	int ret;
>  
>  	if (!(filp->f_mode & FMODE_WRITE))
> @@ -2508,7 +2508,7 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
>  static int f2fs_ioc_abort_atomic_write(struct file *filp)
>  {
>  	struct inode *inode = file_inode(filp);
> -	struct mnt_idmap *idmap = file_mnt_idmap(filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(filp);
>  	int ret;
>  
>  	if (!(filp->f_mode & FMODE_WRITE))
> diff --git a/fs/fhandle.c b/fs/fhandle.c
> index f8829231e3d7..2aa55b8a878a 100644
> --- a/fs/fhandle.c
> +++ b/fs/fhandle.c
> @@ -201,7 +201,7 @@ static int vfs_dentry_acceptable(void *context, struct dentry *dentry)
>  	struct handle_to_path_ctx *ctx = context;
>  	struct user_namespace *user_ns = current_user_ns();
>  	struct dentry *d, *root = ctx->root.dentry;
> -	struct mnt_idmap *idmap = mnt_idmap(ctx->root.mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(ctx->root.mnt);
>  	int retval = 0;
>  
>  	if (!root)
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 5393c4dfa4a8..81af4364e33a 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -323,7 +323,7 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
>  
>  int ioctl_setflags(struct file *file, unsigned int __user *argp)
>  {
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct dentry *dentry = file->f_path.dentry;
>  	struct file_kattr fa = {};
>  	unsigned int flags;
> @@ -355,7 +355,7 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
>  
>  int ioctl_fssetxattr(struct file *file, void __user *argp)
>  {
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct dentry *dentry = file->f_path.dentry;
>  	struct file_kattr fa = {};
>  	int err;
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 6d23878cfae5..1759f7fd72b0 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -941,7 +941,7 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
>  			    umode_t mode)
>  {
>  	int err;
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct fuse_conn *fc = get_fuse_conn(dir);
>  
>  	if (fuse_is_bad(dir))
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 8d6135a6108a..6ae350f8b486 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1487,7 +1487,7 @@ static const struct iomap_write_ops fuse_iomap_write_ops = {
>  static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
>  	struct file *file = iocb->ki_filp;
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct address_space *mapping = file->f_mapping;
>  	ssize_t written = 0;
>  	struct inode *inode = mapping->host;
> diff --git a/fs/internal.h b/fs/internal.h
> index 973436f44770..3dda57fb3c7d 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -327,7 +327,7 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
>   * fs/attr.c
>   */
>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
> -struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
> +const struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
>  void mnt_idmap_put(const struct mnt_idmap *idmap);
>  struct stashed_operations {
>  	struct dentry *(*stash_dentry)(struct dentry **stashed,
> diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
> index 4d5fbf185608..26704eeb7318 100644
> --- a/fs/mnt_idmapping.c
> +++ b/fs/mnt_idmapping.c
> @@ -312,14 +312,14 @@ struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns)
>   *
>   * Return: @idmap with reference count bumped if @not_mnt_idmap isn't passed.
>   */
> -struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap)
> +const struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap)
>  {
>  	struct mnt_idmap *nonconst_idmap = (struct mnt_idmap *)idmap;
>  
>  	if (idmap != &nop_mnt_idmap && idmap != &invalid_mnt_idmap)
>  		refcount_inc(&nonconst_idmap->count);
>  
> -	return nonconst_idmap;
> +	return idmap;
>  }
>  EXPORT_SYMBOL_GPL(mnt_idmap_get);
>  
> diff --git a/fs/namei.c b/fs/namei.c
> index 14970fe08387..818444a52b88 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1273,7 +1273,7 @@ fs_initcall(init_fs_namei_sysctls);
>   */
>  static inline int may_follow_link(struct nameidata *nd, const struct inode *inode)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	vfsuid_t vfsuid;
>  
>  	if (!sysctl_protected_symlinks)
> @@ -2596,7 +2596,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
>  
>  	/* At this point we know we have a real path component. */
>  	for(;;) {
> -		struct mnt_idmap *idmap;
> +		const struct mnt_idmap *idmap;
>  		const char *link;
>  		unsigned long lastword;
>  
> @@ -4432,7 +4432,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
>  				  const struct open_flags *op)
>  {
>  	struct delegated_inode delegated_inode = { };
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct dentry *dir = nd->path.dentry;
>  	struct inode *dir_inode = dir->d_inode;
>  	int open_flag;
> @@ -4789,7 +4789,7 @@ static const char *open_last_lookups(struct nameidata *nd,
>  static int do_open(struct nameidata *nd,
>  		   struct file *file, const struct open_flags *op)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	int open_flag = op->open_flag;
>  	bool do_truncate;
>  	int acc_mode;
> @@ -5169,7 +5169,7 @@ struct file *dentry_create(struct path *path, int flags, umode_t mode,
>  	struct dentry *orig_dentry = dentry;
>  	struct dentry *dir = dentry->d_parent;
>  	struct inode *dir_inode = d_inode(dir);
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	int error, create_error;
>  
>  	file = alloc_empty_file(flags, cred);
> @@ -5294,7 +5294,7 @@ int filename_mknodat(int dfd, struct filename *name, umode_t mode,
>  		     unsigned int dev)
>  {
>  	struct delegated_inode di = { };
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct dentry *dentry;
>  	struct path path;
>  	int error;
> @@ -5949,7 +5949,7 @@ EXPORT_SYMBOL(vfs_link);
>  int filename_linkat(int olddfd, struct filename *old,
>  		    int newdfd, struct filename *new, int flags)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct dentry *new_dentry;
>  	struct path old_path, new_path;
>  	struct delegated_inode delegated_inode = { };
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1ecd96c918b3..919c27724a59 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -109,7 +109,7 @@ struct mount_kattr {
>  	unsigned int lookup_flags;
>  	enum mount_kattr_flags_t kflags;
>  	struct user_namespace *mnt_userns;
> -	struct mnt_idmap *mnt_idmap;
> +	const struct mnt_idmap *mnt_idmap;
>  };
>  
>  /* /sys/fs */
> @@ -4898,7 +4898,7 @@ static int mount_setattr_prepare(struct mount_kattr *kattr, struct mount *mnt)
>  
>  static void do_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
>  {
> -	struct mnt_idmap *old_idmap;
> +	const struct mnt_idmap *old_idmap;
>  
>  	if (!kattr->mnt_idmap)
>  		return;
> @@ -4941,7 +4941,7 @@ static int do_mount_setattr(const struct path *path, struct mount_kattr *kattr)
>  		return -EINVAL;
>  
>  	if (kattr->mnt_userns) {
> -		struct mnt_idmap *mnt_idmap;
> +		const struct mnt_idmap *mnt_idmap;
>  
>  		mnt_idmap = alloc_mnt_idmap(kattr->mnt_userns);
>  		if (IS_ERR(mnt_idmap))
> @@ -5246,7 +5246,7 @@ struct kstatmount {
>  	struct statmount __user *buf;
>  	size_t bufsize;
>  	struct vfsmount *mnt;
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	u64 mask;
>  	struct path root;
>  	struct seq_file seq;
> diff --git a/fs/open.c b/fs/open.c
> index 971e51008e67..031858d77fcc 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -72,7 +72,7 @@ int do_truncate(const struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  int vfs_truncate(const struct path *path, loff_t length)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct inode *inode;
>  	int error;
>  
> @@ -787,7 +787,7 @@ static inline bool setattr_vfsgid(struct iattr *attr, kgid_t kgid)
>  
>  int chown_common(const struct path *path, uid_t user, gid_t group)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct user_namespace *fs_userns;
>  	struct inode *inode = path->dentry->d_inode;
>  	struct delegated_inode delegated_inode = { };
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index f3d97eb146e8..7433220d4ad6 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -30,7 +30,7 @@ static struct file *ovl_open_realfile(const struct file *file,
>  {
>  	struct inode *realinode = d_inode(realpath->dentry);
>  	struct inode *inode = file_inode(file);
> -	struct mnt_idmap *real_idmap;
> +	const struct mnt_idmap *real_idmap;
>  	struct file *realfile;
>  	int flags = file->f_flags | OVL_OPEN_FLAGS;
>  	int acc_mode = ACC_MODE(flags);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 622e9bb833af..70183d516e5e 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -406,7 +406,7 @@ struct posix_acl *ovl_get_acl_path(const struct path *path,
>  				   const char *acl_name, bool noperm)
>  {
>  	struct posix_acl *real_acl, *clone;
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct inode *realinode = d_inode(path->dentry);
>  
>  	idmap = mnt_idmap(path->mnt);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 80cad4ea96a3..ac07e8769f9b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -105,7 +105,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
>  	return ofs->layers[0].mnt;
>  }
>  
> -static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
> +static inline const struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
>  {
>  	return mnt_idmap(ovl_upper_mnt(ofs));
>  }
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index b41f4788e4f0..521717209b2e 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -657,7 +657,7 @@ bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
>  struct file *ovl_path_open(const struct path *path, int flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> -	struct mnt_idmap *real_idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *real_idmap = mnt_idmap(path->mnt);
>  	int err, acc_mode;
>  
>  	if (flags & ~(O_ACCMODE | O_LARGEFILE))
> @@ -1496,7 +1496,7 @@ void ovl_copyattr(struct inode *inode)
>  {
>  	struct path realpath;
>  	struct inode *realinode;
> -	struct mnt_idmap *real_idmap;
> +	const struct mnt_idmap *real_idmap;
>  	vfsuid_t vfsuid;
>  	vfsgid_t vfsgid;
>  
> diff --git a/fs/remap_range.c b/fs/remap_range.c
> index 26afbbbfb10c..6eb7d845de5d 100644
> --- a/fs/remap_range.c
> +++ b/fs/remap_range.c
> @@ -415,7 +415,7 @@ EXPORT_SYMBOL(vfs_clone_file_range);
>  /* Check whether we are allowed to dedupe the destination file */
>  static bool may_dedupe_file(struct file *file)
>  {
> -	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  	struct inode *inode = file_inode(file);
>  
>  	if (capable(CAP_SYS_ADMIN))
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index 58af0fddf39f..341a812da3a8 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -2229,7 +2229,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>  {
>  	struct create_posix_rsp *buf;
>  	struct inode *inode = file_inode(fp->filp);
> -	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
>  	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
>  	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
>  
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 0789200d602f..e2dcf8228fa4 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3234,7 +3234,7 @@ static bool smb2_is_private_ea(const char *name, size_t name_len)
>  static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
>  		       const struct path *path, bool get_write)
>  {
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	char *attr_name = NULL, *value;
>  	int rc = 0;
>  	unsigned int next = 0;
> @@ -3335,7 +3335,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
>  					       struct ksmbd_file *fp,
>  					       char *stream_name, int s_type)
>  {
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	size_t xattr_stream_size;
>  	char *xattr_stream_name;
>  	int rc;
> @@ -3411,7 +3411,7 @@ static loff_t ksmbd_stream_eof(struct ksmbd_file *fp)
>  
>  static int smb2_remove_smb_xattrs(const struct path *path)
>  {
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	char *name, *xattr_list = NULL;
>  	ssize_t xattr_list_len;
>  	int err = 0;
> @@ -4088,7 +4088,7 @@ int smb2_open(struct ksmbd_work *work)
>  	struct ksmbd_share_config *share = tcon->share_conf;
>  	struct ksmbd_file *fp = NULL;
>  	struct file *filp = NULL;
> -	struct mnt_idmap *idmap = NULL;
> +	const struct mnt_idmap *idmap = NULL;
>  	struct kstat stat;
>  	struct create_context *context;
>  	struct lease_ctx_info *lc = NULL;
> @@ -5753,7 +5753,7 @@ struct smb2_query_dir_private {
>  
>  static int process_query_dir_entries(struct smb2_query_dir_private *priv)
>  {
> -	struct mnt_idmap	*idmap = file_mnt_idmap(priv->dir_fp->filp);
> +	const struct mnt_idmap	*idmap = file_mnt_idmap(priv->dir_fp->filp);
>  	struct kstat		kstat;
>  	struct ksmbd_kstat	ksmbd_kstat;
>  	int			rc;
> @@ -6352,7 +6352,7 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
>  	ssize_t buf_free_len, alignment_bytes, next_offset, rsp_data_cnt = 0;
>  	struct smb2_ea_info_req *ea_req = NULL;
>  	const struct path *path;
> -	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
>  
>  	if (!(fp->daccess & FILE_READ_EA_LE)) {
>  		pr_err("Not permitted to read ext attr : 0x%x\n",
> @@ -7062,7 +7062,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
>  {
>  	struct smb311_posix_qinfo *file_info;
>  	struct inode *inode = file_inode(fp->filp);
> -	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
>  	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
>  	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
>  	struct kstat stat;
> @@ -7547,7 +7547,7 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
>  			     struct smb2_query_info_rsp *rsp)
>  {
>  	struct ksmbd_file *fp;
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct smb_ntsd *pntsd = NULL, *ppntsd = NULL;
>  	struct smb_fattr fattr = {{0}};
>  	struct inode *inode;
> @@ -8060,7 +8060,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
>  	struct iattr attrs;
>  	struct file *filp;
>  	struct inode *inode;
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	__le32 attrs_mask = FILE_ATTRIBUTE_DIRECTORY_LE |
>  		FILE_ATTRIBUTE_COMPRESSED_LE;
>  	int rc = 0;
> @@ -10652,7 +10652,7 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
>  				   struct file_sparse *sparse)
>  {
>  	struct ksmbd_file *fp;
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	int ret = 0;
>  	__le32 old_fattr;
>  
> diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
> index 4c2da65510bc..ec6ee56293ce 100644
> --- a/fs/smb/server/smb_common.c
> +++ b/fs/smb/server/smb_common.c
> @@ -467,7 +467,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
>  {
>  	int i, rc = 0;
>  	struct ksmbd_conn *conn = work->conn;
> -	struct mnt_idmap *idmap = file_mnt_idmap(dir->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(dir->filp);
>  
>  	for (i = 0; i < 2; i++) {
>  		struct kstat kstat;
> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index 915dbfab62ea..784067d14f56 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -1183,7 +1183,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
>  	struct smb_ntsd *parent_pntsd = NULL;
>  	struct smb_sid owner_sid, group_sid;
>  	struct dentry *parent = path->dentry->d_parent;
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	int inherited_flags = 0, flags = 0, i, nt_size = 0, pdacl_size;
>  	int rc = 0, pntsd_type, ppntsd_size, acl_len, aces_size;
>  	unsigned int dacloffset;
> @@ -1438,7 +1438,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
>  			__le32 *pdaccess, __le32 raw_daccess, int uid,
>  			bool strict)
>  {
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	struct smb_ntsd *pntsd = NULL;
>  	struct smb_acl *pdacl;
>  	struct posix_acl *posix_acls;
> @@ -1660,7 +1660,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
>  	int rc;
>  	struct smb_fattr fattr = {{0}};
>  	struct inode *inode = d_inode(path->dentry);
> -	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
> +	const struct mnt_idmap *idmap = mnt_idmap(path->mnt);
>  	struct iattr newattrs;
>  
>  	fattr.cf_uid = INVALID_UID;
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 75edff8dde31..ccfdc726d063 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -183,7 +183,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
>   */
>  int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct path path;
>  	struct dentry *dentry, *d;
>  	int err = 0;
> @@ -386,7 +386,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
>  {
>  	const struct cred *saved_cred;
>  	char *stream_buf = NULL, *wbuf;
> -	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
>  	size_t size;
>  	ssize_t v_len;
>  	int err = 0;
> @@ -577,7 +577,7 @@ int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id)
>   */
>  int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct dentry *parent = path->dentry->d_parent;
>  	int err;
>  
> @@ -1202,7 +1202,7 @@ int ksmbd_vfs_unlink(struct file *filp)
>  	const struct cred *saved_cred;
>  	int err = 0;
>  	struct dentry *dir, *dentry = filp->f_path.dentry;
> -	struct mnt_idmap *idmap = file_mnt_idmap(filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(filp);
>  
>  	saved_cred = override_creds(filp->f_cred);
>  	err = mnt_want_write(filp->f_path.mnt);
> @@ -2316,7 +2316,7 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
>  	const struct cred *saved_cred = NULL;
>  	struct file_kattr fa;
>  	struct dentry *dentry = fp->filp->f_path.dentry;
> -	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
> +	const struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
>  	u32 flags;
>  	__le32 old_fattr;
>  	int rc;
> diff --git a/fs/stat.c b/fs/stat.c
> index fe351818d1d6..a9b7383d538d 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(generic_fill_statx_atomic_writes);
>  int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  		      u32 request_mask, unsigned int query_flags)
>  {
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct inode *inode = d_backing_inode(path->dentry);
>  
>  	memset(stat, 0, sizeof(*stat));
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 935b0f92786f..ca3e9d4797ee 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2459,7 +2459,7 @@ struct filename {
>  static_assert(offsetof(struct filename, iname) % sizeof(long) == 0);
>  static_assert(sizeof(struct filename) % 64 == 0);
>  
> -static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
> +static inline const struct mnt_idmap *file_mnt_idmap(const struct file *file)
>  {
>  	return mnt_idmap(file->f_path.mnt);
>  }
> diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
> index 6656aea23be2..b445c7660040 100644
> --- a/include/linux/mnt_idmapping.h
> +++ b/include/linux/mnt_idmapping.h
> @@ -121,7 +121,7 @@ static inline bool vfsgid_eq_kgid(vfsgid_t vfsgid, kgid_t kgid)
>  
>  int vfsgid_in_group_p(vfsgid_t vfsgid);
>  
> -struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
> +const struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
>  void mnt_idmap_put(const struct mnt_idmap *idmap);
>  
>  vfsuid_t make_vfsuid(const struct mnt_idmap *idmap,
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index acfe7ef86a1b..e90ccafef281 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -59,10 +59,10 @@ struct vfsmount {
>  	struct dentry *mnt_root;	/* root of the mounted tree */
>  	struct super_block *mnt_sb;	/* pointer to superblock */
>  	int mnt_flags;
> -	struct mnt_idmap *mnt_idmap;
> +	const struct mnt_idmap *mnt_idmap;
>  } __randomize_layout;
>  
> -static inline struct mnt_idmap *mnt_idmap(const struct vfsmount *mnt)
> +static inline const struct mnt_idmap *mnt_idmap(const struct vfsmount *mnt)
>  {
>  	/* Pairs with smp_store_release() in do_idmap_mount(). */
>  	return READ_ONCE(mnt->mnt_idmap);
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 13f9926bf205..56e1bf51ffe5 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1361,7 +1361,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
>  	struct unix_sock *u = unix_sk(sk);
>  	unsigned int new_hash, old_hash;
>  	struct net *net = sock_net(sk);
> -	struct mnt_idmap *idmap;
> +	const struct mnt_idmap *idmap;
>  	struct unix_address *addr;
>  	struct dentry *dentry;
>  	struct path parent;
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index d502ad0ac26f..c73681d820a0 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -397,7 +397,7 @@ static int apparmor_path_rename(const struct path *old_dir, struct dentry *old_d
>  
>  	label = begin_current_label_crit_section(&needput);
>  	if (!unconfined(label)) {
> -		struct mnt_idmap *idmap = mnt_idmap(old_dir->mnt);
> +		const struct mnt_idmap *idmap = mnt_idmap(old_dir->mnt);
>  		vfsuid_t vfsuid;
>  		struct path old_path = { .mnt = old_dir->mnt,
>  					 .dentry = old_dentry };
> @@ -485,7 +485,7 @@ static int apparmor_file_open(struct file *file)
>  
>  	label = aa_get_newest_cred_label_condref(file->f_cred, &needput);
>  	if (!unconfined(label)) {
> -		struct mnt_idmap *idmap = file_mnt_idmap(file);
> +		const struct mnt_idmap *idmap = file_mnt_idmap(file);
>  		struct inode *inode = file_inode(file);
>  		vfsuid_t vfsuid;
>  		struct path_cond cond = {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
