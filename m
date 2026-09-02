Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DCD3438A9;
	Wed,  2 Sep 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364554; cv=none; b=e2hXMSEvw3ZB1bfOMvCfgrE63o/oqgXRV/yMd7eaIx+CxoG01iGbtZWztlqcwc6PoVEGR3qeTo1OHL+ceOUpFCqNdp1+dRa3l0xOav52CEJPIpF67JgGLButZD9IbQJrLtHXuRRO7PGMhauefnngyGwIrkVp7l8h2rOguY1EdME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364554; c=relaxed/simple;
	bh=3rbkJG2trBiO/32nFILe5g1qT8N1JjaTk6WgpLPt4ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEYpkKCgZdXGOKs/l4NCOuP/Rif9+HrO2pPMzL0ROiKxfgKjsgzFX3cEde68Khi57CeSAbNbA4XFAfyICYSRjEiSrNAHhCkbuURwpcpKtMT3ds679P21J13NQC0z3SOHiT+e1amyEtHHpna1SCwNoCFjbQ9fP2IgS7+ENxkT2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GBc2G7bk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wg5ZF4M/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I3SzrJpQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8mtcsg4u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GBc2G7bk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wg5ZF4M/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I3SzrJpQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8mtcsg4u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB8DA1FB1B;
	Wed,  2 Sep 2026 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nx6dFFkh/4fUaybTUn4btUNIdvSUd+cIt6pbP+Wr15c=;
	b=GBc2G7bkFfhcK8hYX7j05I6BRm1hK6swIcUkhcczWsUSuDGxbP1m7HpZ7PmgebFRB8evti
	NuH11nnfa8BXwe1HiA/oQEDfnbKlOYQLznzHHAFDX4vPbEPcFnz+eRx9e0GHmK5GcoaQQB
	8bAioM9Kk2+81JnWNLGFTf0CcD7T/kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nx6dFFkh/4fUaybTUn4btUNIdvSUd+cIt6pbP+Wr15c=;
	b=Wg5ZF4M/vr32NBaGh+12srx2ochWlnHJi5geId6waDwYx0p5M9Mq8cFhIYI8hu5yu03jpm
	TQxsZHHgUQBPDjCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I3SzrJpQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8mtcsg4u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nx6dFFkh/4fUaybTUn4btUNIdvSUd+cIt6pbP+Wr15c=;
	b=I3SzrJpQPtQw3zBrUSEmtyuf34hNeT1FjiPbkSar5sBU7K1K6j+5JszfJJb8X/1QyMUwgO
	35we+OaPRVUbTB8iTfEt+2CUuYMw4i1GGTAClKzPeSGw1C2VmckuzvU9wo1j4LhvPL9GqA
	F+rlXjmLDFOu8bO6WtKBKzCvIWbb0Lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nx6dFFkh/4fUaybTUn4btUNIdvSUd+cIt6pbP+Wr15c=;
	b=8mtcsg4ue2DRZ5+lb7/ljiEn6CQErIkWQ1p/JkX7PpXL39yxDdKBPyb1O3ChfsSb2PdqXq
	OA/2vjBPMSWvjaCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A831F13515;
	Wed,  2 Sep 2026 15:55:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kukOKf1GmGrtbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:55:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 401A1A13B5; Wed, 02 Sep 2026 17:55:41 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:55:41 +0200
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
Subject: Re: [PATCH 22/27] fs: port ->create() to pass const mnt_idmap
Message-ID: <awtifgrlppf3mr544m6p7nxk6n5ps5uuh5ki3rjpexb2bu6tbd@7prrmk5wnd2g>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-22-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-22-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: CB8DA1FB1B
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

On Tue 01-09-26 14:14:47, Christian Brauner wrote:
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
>  fs/9p/vfs_inode.c                     | 2 +-
>  fs/9p/vfs_inode_dotl.c                | 2 +-
>  fs/affs/affs.h                        | 2 +-
>  fs/affs/namei.c                       | 2 +-
>  fs/afs/dir.c                          | 4 ++--
>  fs/bad_inode.c                        | 2 +-
>  fs/bfs/dir.c                          | 2 +-
>  fs/btrfs/inode.c                      | 2 +-
>  fs/ceph/dir.c                         | 2 +-
>  fs/coda/dir.c                         | 2 +-
>  fs/ecryptfs/inode.c                   | 2 +-
>  fs/efivarfs/inode.c                   | 2 +-
>  fs/exfat/namei.c                      | 2 +-
>  fs/ext2/namei.c                       | 2 +-
>  fs/ext4/namei.c                       | 2 +-
>  fs/f2fs/namei.c                       | 2 +-
>  fs/fat/namei_msdos.c                  | 2 +-
>  fs/fat/namei_vfat.c                   | 2 +-
>  fs/fuse/dir.c                         | 2 +-
>  fs/gfs2/inode.c                       | 2 +-
>  fs/hfs/dir.c                          | 2 +-
>  fs/hfsplus/dir.c                      | 2 +-
>  fs/hostfs/hostfs_kern.c               | 2 +-
>  fs/hpfs/namei.c                       | 2 +-
>  fs/hugetlbfs/inode.c                  | 2 +-
>  fs/jffs2/dir.c                        | 4 ++--
>  fs/jfs/namei.c                        | 2 +-
>  fs/minix/namei.c                      | 2 +-
>  fs/nfs/dir.c                          | 2 +-
>  fs/nfs/internal.h                     | 2 +-
>  fs/nilfs2/namei.c                     | 2 +-
>  fs/ntfs/namei.c                       | 2 +-
>  fs/ntfs3/namei.c                      | 2 +-
>  fs/ocfs2/dlmfs/dlmfs.c                | 2 +-
>  fs/ocfs2/namei.c                      | 2 +-
>  fs/omfs/dir.c                         | 2 +-
>  fs/orangefs/namei.c                   | 2 +-
>  fs/overlayfs/dir.c                    | 2 +-
>  fs/ramfs/inode.c                      | 2 +-
>  fs/smb/client/cifsfs.h                | 2 +-
>  fs/smb/client/dir.c                   | 2 +-
>  fs/ubifs/dir.c                        | 2 +-
>  fs/udf/namei.c                        | 2 +-
>  fs/ufs/namei.c                        | 2 +-
>  fs/vboxsf/dir.c                       | 2 +-
>  fs/xfs/xfs_iops.c                     | 2 +-
>  include/linux/fs.h                    | 2 +-
>  ipc/mqueue.c                          | 2 +-
>  mm/shmem.c                            | 2 +-
>  51 files changed, 53 insertions(+), 53 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 856b9cc88c76..864768700eda 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -61,7 +61,7 @@ inode_operations
>  
>  prototypes::
>  
> -	int (*create) (struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
> +	int (*create) (const struct mnt_idmap *, struct inode *,struct dentry *,umode_t);
>  	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
>  	int (*link) (struct dentry *,struct inode *,struct dentry *);
>  	int (*unlink) (struct inode *,struct dentry *);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 5a9203e98bb6..2ad273cfe547 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -415,7 +415,7 @@ As of kernel 2.6.22, the following members are defined:
>  .. code-block:: c
>  
>  	struct inode_operations {
> -		int (*create) (struct mnt_idmap *, struct inode *,struct dentry *, umode_t);
> +		int (*create) (const struct mnt_idmap *, struct inode *,struct dentry *, umode_t);
>  		struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
>  		int (*link) (struct dentry *,struct inode *,struct dentry *);
>  		int (*unlink) (struct inode *,struct dentry *);
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index cc52c244bb95..f2d0eef68acf 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -652,7 +652,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
>   */
>  
>  static int
> -v9fs_vfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +v9fs_vfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *dentry, umode_t mode)
>  {
>  	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index ec58718eec4a..c7176719a4f9 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -216,7 +216,7 @@ int v9fs_open_to_dotl_flags(int flags)
>   *
>   */
>  static int
> -v9fs_vfs_create_dotl(struct mnt_idmap *idmap, struct inode *dir,
> +v9fs_vfs_create_dotl(const struct mnt_idmap *idmap, struct inode *dir,
>  		     struct dentry *dentry, umode_t omode)
>  {
>  	return v9fs_vfs_mknod_dotl(idmap, dir, dentry, omode, 0);
> diff --git a/fs/affs/affs.h b/fs/affs/affs.h
> index b1047766a829..8d4ca16c7891 100644
> --- a/fs/affs/affs.h
> +++ b/fs/affs/affs.h
> @@ -166,7 +166,7 @@ extern const struct export_operations affs_export_ops;
>  extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
>  extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int);
>  extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
> -extern int	affs_create(struct mnt_idmap *idmap, struct inode *dir,
> +extern int	affs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode);
>  extern struct dentry *affs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode);
> diff --git a/fs/affs/namei.c b/fs/affs/namei.c
> index 1d609355fc3f..2e32899a32d5 100644
> --- a/fs/affs/namei.c
> +++ b/fs/affs/namei.c
> @@ -242,7 +242,7 @@ affs_unlink(struct inode *dir, struct dentry *dentry)
>  }
>  
>  int
> -affs_create(struct mnt_idmap *idmap, struct inode *dir,
> +affs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  	    struct dentry *dentry, umode_t mode)
>  {
>  	struct super_block *sb = dir->i_sb;
> diff --git a/fs/afs/dir.c b/fs/afs/dir.c
> index 603dd9323ed2..63d4f15ae168 100644
> --- a/fs/afs/dir.c
> +++ b/fs/afs/dir.c
> @@ -33,7 +33,7 @@ static bool afs_lookup_one_filldir(struct dir_context *ctx, const char *name, in
>  static bool afs_lookup_filldir(struct dir_context *ctx, const char *name, int nlen,
>  			       u64 ino, u32 uniquifier);
>  #define AFS_LOOKUP ((filldir_t)0x137UL)
> -static int afs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int afs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode);
>  static struct dentry *afs_mkdir(const struct mnt_idmap *idmap, struct inode *dir,
>  				struct dentry *dentry, umode_t mode);
> @@ -1632,7 +1632,7 @@ static const struct afs_operation_ops afs_create_operation = {
>  /*
>   * create a regular file on an AFS filesystem
>   */
> -static int afs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int afs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	struct afs_operation *op;
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 096e6afb5e07..8c7578ea4bd7 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -27,7 +27,7 @@ static const struct file_operations bad_file_ops =
>  	.open		= bad_file_open,
>  };
>  
> -static int bad_inode_create(struct mnt_idmap *idmap,
> +static int bad_inode_create(const struct mnt_idmap *idmap,
>  			    struct inode *dir, struct dentry *dentry,
>  			    umode_t mode)
>  {
> diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
> index 80534d04db9d..b944bd62f5d0 100644
> --- a/fs/bfs/dir.c
> +++ b/fs/bfs/dir.c
> @@ -75,7 +75,7 @@ const struct file_operations bfs_dir_operations = {
>  	.llseek		= generic_file_llseek,
>  };
>  
> -static int bfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int bfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	int err;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9b5e3a67122d..61cfa03b6152 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7018,7 +7018,7 @@ static int btrfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
>  	return btrfs_create_common(dir, dentry, inode);
>  }
>  
> -static int btrfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int btrfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5417a9948e98..d9615d67bf1c 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -988,7 +988,7 @@ static int ceph_mknod(const struct mnt_idmap *idmap, struct inode *dir,
>  	return err;
>  }
>  
> -static int ceph_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ceph_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	return ceph_mknod(idmap, dir, dentry, mode, 0);
> diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> index 02b8259b6a0e..a85be5962e62 100644
> --- a/fs/coda/dir.c
> +++ b/fs/coda/dir.c
> @@ -133,7 +133,7 @@ static inline void coda_dir_drop_nlink(struct inode *dir)
>  }
>  
>  /* creation routines: create, mknod, mkdir, link, symlink */
> -static int coda_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int coda_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *de, umode_t mode)
>  {
>  	int error;
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index f9a3c88c4fbd..432f82bc5b0c 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -266,7 +266,7 @@ int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry,
>   * Returns zero on success; non-zero on error condition
>   */
>  static int
> -ecryptfs_create(struct mnt_idmap *idmap,
> +ecryptfs_create(const struct mnt_idmap *idmap,
>  		struct inode *directory_inode, struct dentry *ecryptfs_dentry,
>  		umode_t mode)
>  {
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index f7dcd72e4a07..d87091b92776 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -74,7 +74,7 @@ static bool efivarfs_valid_name(const char *str, int len)
>  	return uuid_is_valid(s);
>  }
>  
> -static int efivarfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int efivarfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			   struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode = NULL;
> diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
> index 4accf96ea7f9..5e7836af63b8 100644
> --- a/fs/exfat/namei.c
> +++ b/fs/exfat/namei.c
> @@ -552,7 +552,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
>  	return ret;
>  }
>  
> -static int exfat_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int exfat_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct super_block *sb = dir->i_sb;
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 7da42f071eab..bfb6a463a95e 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -97,7 +97,7 @@ struct dentry *ext2_get_parent(struct dentry *child)
>   * If the create succeeds, we fill in the inode information
>   * with d_instantiate(). 
>   */
> -static int ext2_create (struct mnt_idmap * idmap,
> +static int ext2_create (const struct mnt_idmap * idmap,
>  			struct inode * dir, struct dentry * dentry,
>  			umode_t mode)
>  {
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6e493b4d205f..6e0630a49e48 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2812,7 +2812,7 @@ static int ext4_add_nondir(handle_t *handle,
>   * If the create succeeds, we fill in the inode information
>   * with d_instantiate().
>   */
> -static int ext4_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ext4_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	handle_t *handle;
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index b2e99822d8b4..9934777eb2a9 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -365,7 +365,7 @@ static struct inode *f2fs_new_inode(const struct mnt_idmap *idmap,
>  	return ERR_PTR(err);
>  }
>  
> -static int f2fs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int f2fs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
> diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
> index 9ee899391f4f..dde4215616f9 100644
> --- a/fs/fat/namei_msdos.c
> +++ b/fs/fat/namei_msdos.c
> @@ -263,7 +263,7 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
>  }
>  
>  /***** Create a file */
> -static int msdos_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int msdos_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct super_block *sb = dir->i_sb;
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index a3f3320fe630..3dc063ba0a73 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -753,7 +753,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
>  	return ERR_PTR(err);
>  }
>  
> -static int vfat_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int vfat_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	struct super_block *sb = dir->i_sb;
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 3d8246ff061e..ff941e78918f 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1092,7 +1092,7 @@ static int fuse_mknod(const struct mnt_idmap *idmap, struct inode *dir,
>  	return create_new_nondir(idmap, fm, &args, dir, entry, mode);
>  }
>  
> -static int fuse_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int fuse_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *entry, umode_t mode)
>  {
>  	return fuse_mknod(idmap, dir, entry, mode, 0);
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index c8f2b01e8cf5..e207ab1f5c23 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -967,7 +967,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
>   * Returns: errno
>   */
>  
> -static int gfs2_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int gfs2_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	return gfs2_create_inode(dir, dentry, NULL, S_IFREG | mode, 0, NULL, 0, 1);
> diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
> index d60399c62e99..f6b97da19788 100644
> --- a/fs/hfs/dir.c
> +++ b/fs/hfs/dir.c
> @@ -183,7 +183,7 @@ static int hfs_dir_release(struct inode *inode, struct file *file)
>   * a directory and return a corresponding inode, given the inode for
>   * the directory and the name (and its length) of the new file.
>   */
> -static int hfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int hfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
> index 1b59ddb6d1e1..b3a1193a491f 100644
> --- a/fs/hfsplus/dir.c
> +++ b/fs/hfsplus/dir.c
> @@ -561,7 +561,7 @@ static int hfsplus_mknod(const struct mnt_idmap *idmap, struct inode *dir,
>  	return res;
>  }
>  
> -static int hfsplus_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int hfsplus_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			  struct dentry *dentry, umode_t mode)
>  {
>  	return hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index ef03763aa074..c8ad58be047e 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -592,7 +592,7 @@ static struct inode *hostfs_iget(struct super_block *sb, char *name)
>  	return inode;
>  }
>  
> -static int hostfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int hostfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
> index 44a7fb797633..ac9b5e3e83fa 100644
> --- a/fs/hpfs/namei.c
> +++ b/fs/hpfs/namei.c
> @@ -128,7 +128,7 @@ static struct dentry *hpfs_mkdir(const struct mnt_idmap *idmap, struct inode *di
>  	return ERR_PTR(err);
>  }
>  
> -static int hpfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int hpfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	const unsigned char *name = dentry->d_name.name;
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9e937602b2ec..0b95be14d3ee 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -977,7 +977,7 @@ static struct dentry *hugetlbfs_mkdir(const struct mnt_idmap *idmap, struct inod
>  	return ERR_PTR(retval);
>  }
>  
> -static int hugetlbfs_create(struct mnt_idmap *idmap,
> +static int hugetlbfs_create(const struct mnt_idmap *idmap,
>  			    struct inode *dir, struct dentry *dentry,
>  			    umode_t mode)
>  {
> diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
> index 7d23be0bab72..23813f191281 100644
> --- a/fs/jffs2/dir.c
> +++ b/fs/jffs2/dir.c
> @@ -25,7 +25,7 @@
>  
>  static int jffs2_readdir (struct file *, struct dir_context *);
>  
> -static int jffs2_create (struct mnt_idmap *, struct inode *,
> +static int jffs2_create (const struct mnt_idmap *, struct inode *,
>  		         struct dentry *, umode_t);
>  static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
>  				    unsigned int);
> @@ -162,7 +162,7 @@ static int jffs2_readdir(struct file *file, struct dir_context *ctx)
>  /***********************************************************************/
>  
>  
> -static int jffs2_create(struct mnt_idmap *idmap, struct inode *dir_i,
> +static int jffs2_create(const struct mnt_idmap *idmap, struct inode *dir_i,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct jffs2_raw_inode *ri;
> diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
> index 6009d65ab53f..8ab2e952ce16 100644
> --- a/fs/jfs/namei.c
> +++ b/fs/jfs/namei.c
> @@ -60,7 +60,7 @@ static inline void free_ea_wmap(struct inode *inode)
>   * RETURN:	Errors from subroutines
>   *
>   */
> -static int jfs_create(struct mnt_idmap *idmap, struct inode *dip,
> +static int jfs_create(const struct mnt_idmap *idmap, struct inode *dip,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	int rc = 0;
> diff --git a/fs/minix/namei.c b/fs/minix/namei.c
> index 11b66a25e92b..f450b11b9860 100644
> --- a/fs/minix/namei.c
> +++ b/fs/minix/namei.c
> @@ -63,7 +63,7 @@ static int minix_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
>  	return finish_open_simple(file, 0);
>  }
>  
> -static int minix_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int minix_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	return minix_mknod(&nop_mnt_idmap, dir, dentry, mode, 0);
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index a917c008a05a..354f986e60c4 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -2437,7 +2437,7 @@ static int nfs_do_create(struct inode *dir, struct dentry *dentry,
>  	return error;
>  }
>  
> -int nfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +int nfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  	       struct dentry *dentry, umode_t mode)
>  {
>  	return nfs_do_create(dir, dentry, mode, O_EXCL);
> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
> index 4c966dac7f7d..cbb323c6530d 100644
> --- a/fs/nfs/internal.h
> +++ b/fs/nfs/internal.h
> @@ -396,7 +396,7 @@ extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
>  					   struct shrink_control *sc);
>  struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
>  void nfs_d_prune_case_insensitive_aliases(struct inode *inode);
> -int nfs_create(struct mnt_idmap *, struct inode *, struct dentry *,
> +int nfs_create(const struct mnt_idmap *, struct inode *, struct dentry *,
>  	       umode_t);
>  struct dentry *nfs_mkdir(const struct mnt_idmap *, struct inode *, struct dentry *,
>  			 umode_t);
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 8762fdc16c05..d0ae24f37854 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -85,7 +85,7 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
>   * If the create succeeds, we fill in the inode information
>   * with d_instantiate().
>   */
> -static int nilfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int nilfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
> index 637bc3690844..5d222edadf0c 100644
> --- a/fs/ntfs/namei.c
> +++ b/fs/ntfs/namei.c
> @@ -732,7 +732,7 @@ static struct ntfs_inode *__ntfs_create(const struct mnt_idmap *idmap, struct in
>  	return ERR_PTR(err);
>  }
>  
> -static int ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *dentry, umode_t mode)
>  {
>  	struct ntfs_volume *vol = NTFS_SB(dir->i_sb);
> diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
> index 289796da6ba5..ae88cb66fb7e 100644
> --- a/fs/ntfs3/namei.c
> +++ b/fs/ntfs3/namei.c
> @@ -111,7 +111,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
>  /*
>   * ntfs_create - inode_operations::create
>   */
> -static int ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	return ntfs_create_inode(idmap, dir, dentry, NULL, S_IFREG | mode, 0,
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 5e544d8ded42..fef79b21a4a5 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -450,7 +450,7 @@ static struct dentry *dlmfs_mkdir(const struct mnt_idmap * idmap,
>  	return ERR_PTR(status);
>  }
>  
> -static int dlmfs_create(struct mnt_idmap *idmap,
> +static int dlmfs_create(const struct mnt_idmap *idmap,
>  			struct inode *dir,
>  			struct dentry *dentry,
>  			umode_t mode)
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index dfa2cb2bcb12..4873525be3b1 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -671,7 +671,7 @@ static struct dentry *ocfs2_mkdir(const struct mnt_idmap *idmap,
>  	return ERR_PTR(ret);
>  }
>  
> -static int ocfs2_create(struct mnt_idmap *idmap,
> +static int ocfs2_create(const struct mnt_idmap *idmap,
>  			struct inode *dir,
>  			struct dentry *dentry,
>  			umode_t mode)
> diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
> index a476675e8e61..18f4b4543cc8 100644
> --- a/fs/omfs/dir.c
> +++ b/fs/omfs/dir.c
> @@ -285,7 +285,7 @@ static struct dentry *omfs_mkdir(const struct mnt_idmap *idmap, struct inode *di
>  	return ERR_PTR(omfs_add_node(dir, dentry, mode));
>  }
>  
> -static int omfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int omfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		       struct dentry *dentry, umode_t mode)
>  {
>  	return omfs_add_node(dir, dentry, mode | S_IFREG);
> diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
> index f5deb8cdbf2f..32b7769ea49c 100644
> --- a/fs/orangefs/namei.c
> +++ b/fs/orangefs/namei.c
> @@ -15,7 +15,7 @@
>  /*
>   * Get a newly allocated inode to go with a negative dentry.
>   */
> -static int orangefs_create(struct mnt_idmap *idmap,
> +static int orangefs_create(const struct mnt_idmap *idmap,
>  			struct inode *dir,
>  			struct dentry *dentry,
>  			umode_t mode)
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index f7a3fd3a25b9..1194ccf981c3 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -730,7 +730,7 @@ static int ovl_create_object(const struct mnt_idmap *idmap, struct dentry *dentr
>  	return err;
>  }
>  
> -static int ovl_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ovl_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	return ovl_create_object(idmap, dentry, (mode & 07777) | S_IFREG, 0, NULL);
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index cc06d806b214..ef91b933d4e6 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -127,7 +127,7 @@ static struct dentry *ramfs_mkdir(const struct mnt_idmap *idmap, struct inode *d
>  	return ERR_PTR(retval);
>  }
>  
> -static int ramfs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ramfs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	return ramfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 483d2b23fc23..cf09d915bedd 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -53,7 +53,7 @@ void cifs_sb_deactive(struct super_block *sb);
>  /* Functions related to inodes */
>  extern const struct inode_operations cifs_dir_inode_ops;
>  struct inode *cifs_root_iget(struct super_block *sb);
> -int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
> +int cifs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *direntry, umode_t mode);
>  int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
>  		     struct file *file, unsigned int oflags, umode_t mode);
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 95da43ad7c02..52d30ebe67f3 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -640,7 +640,7 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
>   * The initial dentry state is hashed-negative.  On success, dentry will become
>   * hashed-positive by calling d_instantiate().
>   */
> -int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
> +int cifs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		struct dentry *direntry, umode_t mode)
>  {
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(dir);
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index d784283d427f..57640b6ff72d 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -302,7 +302,7 @@ static int ubifs_prepare_create(struct inode *dir, struct dentry *dentry,
>  	return fscrypt_setup_filename(dir, &dentry->d_name, 0, nm);
>  }
>  
> -static int ubifs_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int ubifs_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 002e79052f92..42d000fe9d6b 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -370,7 +370,7 @@ static int udf_add_nondir(struct dentry *dentry, struct inode *inode)
>  	return 0;
>  }
>  
> -static int udf_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int udf_create(const struct mnt_idmap *idmap, struct inode *dir,
>  		      struct dentry *dentry, umode_t mode)
>  {
>  	struct inode *inode = udf_new_inode(dir, mode);
> diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
> index 9231a5cda08e..d45347a25741 100644
> --- a/fs/ufs/namei.c
> +++ b/fs/ufs/namei.c
> @@ -69,7 +69,7 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, unsi
>   * If the create succeeds, we fill in the inode information
>   * with d_instantiate(). 
>   */
> -static int ufs_create (struct mnt_idmap * idmap,
> +static int ufs_create (const struct mnt_idmap * idmap,
>  		struct inode * dir, struct dentry * dentry, umode_t mode)
>  {
>  	struct inode *inode;
> diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
> index 9db16e90f670..b9c46c769c4e 100644
> --- a/fs/vboxsf/dir.c
> +++ b/fs/vboxsf/dir.c
> @@ -296,7 +296,7 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
>  	return err;
>  }
>  
> -static int vboxsf_dir_mkfile(struct mnt_idmap *idmap,
> +static int vboxsf_dir_mkfile(const struct mnt_idmap *idmap,
>  			     struct inode *parent, struct dentry *dentry,
>  			     umode_t mode)
>  {
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index fe388619a138..791af2db7124 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -290,7 +290,7 @@ xfs_vn_mknod(
>  
>  STATIC int
>  xfs_vn_create(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct inode		*dir,
>  	struct dentry		*dentry,
>  	umode_t			mode)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f2c7838644c3..2b9ae72010f0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1999,7 +1999,7 @@ struct inode_operations {
>  
>  	int (*readlink) (struct dentry *, char __user *,int);
>  
> -	int (*create) (struct mnt_idmap *, struct inode *,struct dentry *,
> +	int (*create) (const struct mnt_idmap *, struct inode *,struct dentry *,
>  		       umode_t);
>  	int (*link) (struct dentry *,struct inode *,struct dentry *);
>  	int (*unlink) (struct inode *,struct dentry *);
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index d1dd36a651b0..e3a1f3b6d00f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -607,7 +607,7 @@ static int mqueue_create_attr(struct dentry *dentry, umode_t mode, void *arg)
>  	return error;
>  }
>  
> -static int mqueue_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int mqueue_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			 struct dentry *dentry, umode_t mode)
>  {
>  	return mqueue_create_attr(dentry, mode, NULL);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f633af032a08..656235b2f9c5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3897,7 +3897,7 @@ static struct dentry *shmem_mkdir(const struct mnt_idmap *idmap, struct inode *d
>  	return NULL;
>  }
>  
> -static int shmem_create(struct mnt_idmap *idmap, struct inode *dir,
> +static int shmem_create(const struct mnt_idmap *idmap, struct inode *dir,
>  			struct dentry *dentry, umode_t mode)
>  {
>  	return shmem_mknod(idmap, dir, dentry, mode | S_IFREG, 0);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
