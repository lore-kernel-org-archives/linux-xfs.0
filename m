Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C464A92D9;
	Wed,  2 Sep 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363554; cv=none; b=SYpupwUMuZqCeN12gjMUb8rvs7B/F1DLUcuaHolHaxHEoTijUj+GNmy0Ao4y0Rlt2C8PMRN1oDklE5jALenBXHPlyttM4V7iFfwVkGq5+BEZOBhBS+5fK1rvGg+cr/YMp021c7A+5p+GBZR42MyyKGkb6nE8zRkGWmk78c5KFIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363554; c=relaxed/simple;
	bh=u5Fqzu7NryLAJ26hWEos4RDSCc049nOVtFmhJA4+xtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjzKYWoR1ERBgkOlkucb13XISut0cE1hYcDaXApDkQYnvIsNBm1YPorIOrcrTn2XHM90p7sZ4NXncPe76P4I2BPYWSKFoaBCW+9BWU3ILvibJ9xZKVRnmvIA6WeP+lfqH4bbSzkIPV4HwtpG+rLSIr0dj1Ds6M6PtzsToyUcwNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=knQ6pxFT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ECm7b0US; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BH9iwP8O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IkFz2RYc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="knQ6pxFT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ECm7b0US";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BH9iwP8O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IkFz2RYc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B20421DDF;
	Wed,  2 Sep 2026 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zmAtNLqBB7vGH3QmFxihCLRsUPlf4AufPeMR6Rd7GDk=;
	b=knQ6pxFTxPcsUTS1BPszSuI8jY4mB/n6QsVzbb6BddMc4pDtIupBqzrgFuIHxxu71grp1P
	A/6z/uvRpTnChFj8GgvOb9iaMWse7Dx/9vgnLfNdlEhWMoAPXaC3XijMWq+IAt+BfcNkzb
	NqgupjlsuVxgEje6VA7CLGBA7c28q18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zmAtNLqBB7vGH3QmFxihCLRsUPlf4AufPeMR6Rd7GDk=;
	b=ECm7b0USBxNSkYIOrlyzNBloN7/KWo0rnPG7JqJmTvWOKKsJVprxz+cpFK0xgQXpfZLalt
	ruW0fhkjydgMVMDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BH9iwP8O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IkFz2RYc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zmAtNLqBB7vGH3QmFxihCLRsUPlf4AufPeMR6Rd7GDk=;
	b=BH9iwP8OoUQgSxYhurrgSvL+iSqdyITGmSGGu3Hjwli0QHGxwcQNy1lzcY5VgKl6Q6jCJS
	LySAmqaW5kDyBjZ9kSS1wmL2RLqdAtc6H9jGCoaq6bLjwg5BCQFkzQlEzvD5XoKNKJ8oiy
	HLiReDjMB6iizi58d06Rde6Jhfee7j0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363539;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zmAtNLqBB7vGH3QmFxihCLRsUPlf4AufPeMR6Rd7GDk=;
	b=IkFz2RYc69NtMJgeVEY3bfJzWUaqapHPsF5fiA4dfs07WPFSnKvuzr/OeQ0GjanWmt+KyG
	S+MLNFA1noR/WLCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 040F613515;
	Wed,  2 Sep 2026 15:38:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6kv2ABNDmGrrXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:38:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8D3E2A13B5; Wed, 02 Sep 2026 17:38:58 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:38:58 +0200
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
Subject: Re: [PATCH 12/27] fs: port ->permission() to pass const mnt_idmap
Message-ID: <bop3ytac2snusakjfi3bjpph5avema2rkpc2ncqlpjdwpthsg6@3anrw3suhrph>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-12-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 2B20421DDF
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:37, Christian Brauner wrote:
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
>  Documentation/filesystems/locking.rst |  2 +-
>  Documentation/filesystems/vfs.rst     |  2 +-
>  fs/afs/internal.h                     |  2 +-
>  fs/afs/security.c                     |  2 +-
>  fs/attr.c                             |  2 +-
>  fs/autofs/root.c                      |  4 ++--
>  fs/bad_inode.c                        |  2 +-
>  fs/btrfs/inode.c                      |  2 +-
>  fs/btrfs/ioctl.c                      |  2 +-
>  fs/ceph/inode.c                       |  2 +-
>  fs/ceph/super.h                       |  2 +-
>  fs/coda/coda_linux.h                  |  2 +-
>  fs/coda/dir.c                         |  2 +-
>  fs/coda/pioctl.c                      |  4 ++--
>  fs/ecryptfs/inode.c                   |  2 +-
>  fs/failfs.c                           |  2 +-
>  fs/fuse/dir.c                         |  2 +-
>  fs/gfs2/inode.c                       |  2 +-
>  fs/gfs2/inode.h                       |  2 +-
>  fs/hostfs/hostfs_kern.c               |  2 +-
>  fs/internal.h                         |  2 +-
>  fs/kernfs/inode.c                     |  2 +-
>  fs/kernfs/kernfs-internal.h           |  2 +-
>  fs/namei.c                            | 22 +++++++++++-----------
>  fs/nfs/dir.c                          |  2 +-
>  fs/nilfs2/inode.c                     |  2 +-
>  fs/nilfs2/nilfs.h                     |  2 +-
>  fs/ocfs2/file.c                       |  2 +-
>  fs/ocfs2/file.h                       |  2 +-
>  fs/orangefs/inode.c                   |  2 +-
>  fs/orangefs/orangefs-kernel.h         |  2 +-
>  fs/overlayfs/inode.c                  |  2 +-
>  fs/overlayfs/overlayfs.h              |  2 +-
>  fs/proc/base.c                        |  4 ++--
>  fs/proc/fd.c                          |  4 ++--
>  fs/proc/fd.h                          |  2 +-
>  fs/proc/proc_sysctl.c                 |  2 +-
>  fs/smb/client/cifsfs.c                |  2 +-
>  fs/smb/server/vfs.c                   |  2 +-
>  fs/smb/server/vfs.h                   |  2 +-
>  fs/tracefs/inode.c                    |  2 +-
>  include/linux/fs.h                    |  8 ++++----
>  include/linux/nfs_fs.h                |  2 +-
>  security/selinux/selinuxfs.c          |  2 +-
>  44 files changed, 61 insertions(+), 61 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 844d65eb47a5..5af7d3bfcd5e 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -74,7 +74,7 @@ prototypes::
>  	int (*readlink) (struct dentry *, char __user *,int);
>  	const char *(*get_link) (struct dentry *, struct inode *, struct delayed_call *);
>  	void (*truncate) (struct inode *);
> -	int (*permission) (struct mnt_idmap *, struct inode *, int, unsigned int);
> +	int (*permission) (const struct mnt_idmap *, struct inode *, int, unsigned int);
>  	struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
>  	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
>  	int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index d3a93eec3945..b7e476f70185 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -428,7 +428,7 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*readlink) (struct dentry *, char __user *,int);
>  		const char *(*get_link) (struct dentry *, struct inode *,
>  					 struct delayed_call *);
> -		int (*permission) (struct mnt_idmap *, struct inode *, int);
> +		int (*permission) (const struct mnt_idmap *, struct inode *, int);
>  		struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
>  		int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
>  		int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 290873bac89b..e772da2a15f2 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -1530,7 +1530,7 @@ extern void afs_cache_permit(struct afs_vnode *, struct key *, unsigned int,
>  extern struct key *afs_request_key(struct afs_cell *);
>  extern struct key *afs_request_key_rcu(struct afs_cell *);
>  extern int afs_check_permit(struct afs_vnode *, struct key *, afs_access_t *);
> -extern int afs_permission(struct mnt_idmap *, struct inode *, int);
> +extern int afs_permission(const struct mnt_idmap *, struct inode *, int);
>  extern void __exit afs_clean_up_permit_cache(void);
>  
>  /*
> diff --git a/fs/afs/security.c b/fs/afs/security.c
> index 6d00d62a65ed..fd040f7c6766 100644
> --- a/fs/afs/security.c
> +++ b/fs/afs/security.c
> @@ -428,7 +428,7 @@ int afs_check_permit(struct afs_vnode *vnode, struct key *key,
>   * - AFS ACLs are attached to directories only, and a file is controlled by its
>   *   parent directory's ACL
>   */
> -int afs_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int afs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		   int mask)
>  {
>  	struct afs_vnode *vnode = AFS_FS_I(inode);
> diff --git a/fs/attr.c b/fs/attr.c
> index 23f1347ff240..c5033afe04bf 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -369,7 +369,7 @@ void setattr_copy(const struct mnt_idmap *idmap, struct inode *inode,
>  }
>  EXPORT_SYMBOL(setattr_copy);
>  
> -int may_setattr(struct mnt_idmap *idmap, struct inode *inode,
> +int may_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  		unsigned int ia_valid)
>  {
>  	int error;
> diff --git a/fs/autofs/root.c b/fs/autofs/root.c
> index b36439f4521e..3158df448025 100644
> --- a/fs/autofs/root.c
> +++ b/fs/autofs/root.c
> @@ -11,7 +11,7 @@
>  
>  #include "autofs_i.h"
>  
> -static int autofs_dir_permission(struct mnt_idmap *, struct inode *, int);
> +static int autofs_dir_permission(const struct mnt_idmap *, struct inode *, int);
>  static int autofs_dir_symlink(struct mnt_idmap *, struct inode *,
>  			      struct dentry *, const char *);
>  static int autofs_dir_unlink(struct inode *, struct dentry *);
> @@ -552,7 +552,7 @@ static struct dentry *autofs_lookup(struct inode *dir,
>  	return NULL;
>  }
>  
> -static int autofs_dir_permission(struct mnt_idmap *idmap,
> +static int autofs_dir_permission(const struct mnt_idmap *idmap,
>  				 struct inode *inode, int mask)
>  {
>  	if (mask & MAY_WRITE) {
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 486c40f73e51..c2cfa9395bc9 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -89,7 +89,7 @@ static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
>  	return -EIO;
>  }
>  
> -static int bad_inode_permission(struct mnt_idmap *idmap,
> +static int bad_inode_permission(const struct mnt_idmap *idmap,
>  				struct inode *inode, int mask)
>  {
>  	return -EIO;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d5a78d9027e2..7bf38f069116 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9375,7 +9375,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
>   * we are marking them with IOP_FASTPERM_MAY_EXEC, allowing path lookup to
>   * elide calls here.
>   */
> -static int btrfs_permission(struct mnt_idmap *idmap,
> +static int btrfs_permission(const struct mnt_idmap *idmap,
>  			    struct inode *inode, int mask)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8eacdc2ee4de..9d6302547b12 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1726,7 +1726,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_root *root, u64 dirid
>  	return 0;
>  }
>  
> -static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
> +static int btrfs_search_path_in_tree_user(const struct mnt_idmap *idmap,
>  				struct inode *inode,
>  				struct btrfs_ioctl_ino_lookup_user_args *args)
>  {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 3921b601ad59..b8527f67e3f0 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -3098,7 +3098,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>   * Check inode permissions.  We verify we have a valid value for
>   * the AUTH cap, then call the generic handler.
>   */
> -int ceph_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int ceph_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask)
>  {
>  	int err;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index e9a9d5737c80..ef9861797eb2 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1166,7 +1166,7 @@ static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
>  {
>  	return __ceph_do_getattr(inode, NULL, mask, force);
>  }
> -extern int ceph_permission(struct mnt_idmap *idmap,
> +extern int ceph_permission(const struct mnt_idmap *idmap,
>  			   struct inode *inode, int mask);
>  
>  struct ceph_iattr {
> diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
> index dd6277d87afb..5ee6cedd3865 100644
> --- a/fs/coda/coda_linux.h
> +++ b/fs/coda/coda_linux.h
> @@ -46,7 +46,7 @@ extern const struct file_operations coda_ioctl_operations;
>  /* operations shared over more than one file */
>  int coda_open(struct inode *i, struct file *f);
>  int coda_release(struct inode *i, struct file *f);
> -int coda_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int coda_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask);
>  int coda_revalidate_inode(struct inode *);
>  int coda_getattr(struct mnt_idmap *, const struct path *, struct kstat *,
> diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> index 67148edfadee..e8db5960b61b 100644
> --- a/fs/coda/dir.c
> +++ b/fs/coda/dir.c
> @@ -73,7 +73,7 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsig
>  }
>  
>  
> -int coda_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int coda_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask)
>  {
>  	int error;
> diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
> index 36e35c15561a..c457e9bab94b 100644
> --- a/fs/coda/pioctl.c
> +++ b/fs/coda/pioctl.c
> @@ -24,7 +24,7 @@
>  #include "coda_linux.h"
>  
>  /* pioctl ops */
> -static int coda_ioctl_permission(struct mnt_idmap *idmap,
> +static int coda_ioctl_permission(const struct mnt_idmap *idmap,
>  				 struct inode *inode, int mask);
>  static long coda_pioctl(struct file *filp, unsigned int cmd,
>  			unsigned long user_data);
> @@ -41,7 +41,7 @@ const struct file_operations coda_ioctl_operations = {
>  };
>  
>  /* the coda pioctl inode ops */
> -static int coda_ioctl_permission(struct mnt_idmap *idmap,
> +static int coda_ioctl_permission(const struct mnt_idmap *idmap,
>  				 struct inode *inode, int mask)
>  {
>  	return (mask & MAY_EXEC) ? -EACCES : 0;
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 525297c7ebd8..6dafca14ca78 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -849,7 +849,7 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
>  }
>  
>  static int
> -ecryptfs_permission(struct mnt_idmap *idmap, struct inode *inode,
> +ecryptfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask)
>  {
>  	return inode_permission(&nop_mnt_idmap,
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 66a36da3d236..cec6cad99eb2 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -22,7 +22,7 @@ bool failfs_mnt(const struct vfsmount *mnt)
>  	return mnt->mnt_sb == failfs_root_path.mnt->mnt_sb;
>  }
>  
> -static int failfs_permission(struct mnt_idmap *idmap, struct inode *inode,
> +static int failfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  			     int mask)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 7a204f55ca84..4b87973c727d 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1763,7 +1763,7 @@ static int fuse_perm_getattr(struct inode *inode, int mask)
>   * access request is sent.  Execute permission is still checked
>   * locally based on file mode.
>   */
> -static int fuse_permission(struct mnt_idmap *idmap,
> +static int fuse_permission(const struct mnt_idmap *idmap,
>  			   struct inode *inode, int mask)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index f361876c5583..1b1d22abe1d4 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -1963,7 +1963,7 @@ static const char *gfs2_get_link(struct dentry *dentry,
>   * Returns: errno
>   */
>  
> -int gfs2_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int gfs2_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask)
>  {
>  	int may_not_block = mask & MAY_NOT_BLOCK;
> diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
> index 2fcd96dd1361..373473eb091c 100644
> --- a/fs/gfs2/inode.h
> +++ b/fs/gfs2/inode.h
> @@ -97,7 +97,7 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip);
>  
>  struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
>  			   int is_root);
> -int gfs2_permission(struct mnt_idmap *idmap,
> +int gfs2_permission(const struct mnt_idmap *idmap,
>  		    struct inode *inode, int mask);
>  struct inode *gfs2_lookup_meta(struct inode *dip, const char *name);
>  void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index 7add056d47d8..0d5c5f11f913 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -774,7 +774,7 @@ static int hostfs_rename2(struct mnt_idmap *idmap,
>  	return err;
>  }
>  
> -static int hostfs_permission(struct mnt_idmap *idmap,
> +static int hostfs_permission(const struct mnt_idmap *idmap,
>  			     struct inode *ino, int desired)
>  {
>  	char *name;
> diff --git a/fs/internal.h b/fs/internal.h
> index 161b0cafe17f..a502b1fbacd2 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -55,7 +55,7 @@ extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
>  			   struct path *path, const struct path *root);
>  int filename_rmdir(int dfd, struct filename *name);
>  int filename_unlinkat(int dfd, struct filename *name);
> -int may_linkat(struct mnt_idmap *idmap, const struct path *link);
> +int may_linkat(const struct mnt_idmap *idmap, const struct path *link);
>  int filename_renameat2(int olddfd, struct filename *oldname, int newdfd,
>  		 struct filename *newname, unsigned int flags);
>  int filename_mkdirat(int dfd, struct filename *name, umode_t mode);
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index 237dcdd73fc2..d53d104e54d5 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -272,7 +272,7 @@ void kernfs_evict_inode(struct inode *inode)
>  	kernfs_put(kn);
>  }
>  
> -int kernfs_iop_permission(struct mnt_idmap *idmap,
> +int kernfs_iop_permission(const struct mnt_idmap *idmap,
>  			  struct inode *inode, int mask)
>  {
>  	struct kernfs_node *kn;
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index aa784b540b36..0f6f412213f6 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -171,7 +171,7 @@ extern struct kmem_cache *kernfs_node_cache, *kernfs_iattrs_cache;
>   */
>  extern const struct xattr_handler * const kernfs_xattr_handlers[];
>  void kernfs_evict_inode(struct inode *inode);
> -int kernfs_iop_permission(struct mnt_idmap *idmap,
> +int kernfs_iop_permission(const struct mnt_idmap *idmap,
>  			  struct inode *inode, int mask);
>  int kernfs_iop_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *iattr);
> diff --git a/fs/namei.c b/fs/namei.c
> index db82daec3646..f5e00ae41ed4 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -371,7 +371,7 @@ struct filename *complete_getname(struct delayed_filename *v)
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -static int check_acl(struct mnt_idmap *idmap,
> +static int check_acl(const struct mnt_idmap *idmap,
>  		     struct inode *inode, int mask)
>  {
>  #ifdef CONFIG_FS_POSIX_ACL
> @@ -435,7 +435,7 @@ static inline bool no_acl_inode(struct inode *inode)
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -static int acl_permission_check(struct mnt_idmap *idmap,
> +static int acl_permission_check(const struct mnt_idmap *idmap,
>  				struct inode *inode, int mask)
>  {
>  	unsigned int mode = inode->i_mode;
> @@ -518,7 +518,7 @@ static int acl_permission_check(struct mnt_idmap *idmap,
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -int generic_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int generic_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		       int mask)
>  {
>  	int ret;
> @@ -575,7 +575,7 @@ EXPORT_SYMBOL(generic_permission);
>   * flag in inode->i_opflags, that says "this has not special
>   * permission function, use the fast case".
>   */
> -static inline int do_inode_permission(struct mnt_idmap *idmap,
> +static inline int do_inode_permission(const struct mnt_idmap *idmap,
>  				      struct inode *inode, int mask)
>  {
>  	if (unlikely(!(inode->i_opflags & IOP_FASTPERM))) {
> @@ -625,7 +625,7 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
>   *
>   * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
>   */
> -int inode_permission(struct mnt_idmap *idmap,
> +int inode_permission(const struct mnt_idmap *idmap,
>  		     struct inode *inode, int mask)
>  {
>  	int retval;
> @@ -680,7 +680,7 @@ EXPORT_SYMBOL(inode_permission);
>   * on IOP_FASTPERM can still get the optimization if they set IOP_FASTPERM_MAY_EXEC
>   * on their directory inodes.
>   */
> -static __always_inline int lookup_inode_permission_may_exec(struct mnt_idmap *idmap,
> +static __always_inline int lookup_inode_permission_may_exec(const struct mnt_idmap *idmap,
>  	struct inode *inode, int mask)
>  {
>  	/* Lookup already checked this to return -ENOTDIR */
> @@ -1314,7 +1314,7 @@ static inline int may_follow_link(struct nameidata *nd, const struct inode *inod
>   *
>   * Otherwise returns true.
>   */
> -static bool safe_hardlink_source(struct mnt_idmap *idmap,
> +static bool safe_hardlink_source(const struct mnt_idmap *idmap,
>  				 struct inode *inode)
>  {
>  	umode_t mode = inode->i_mode;
> @@ -1357,7 +1357,7 @@ static bool safe_hardlink_source(struct mnt_idmap *idmap,
>   *
>   * Returns 0 if successful, -ve on error.
>   */
> -int may_linkat(struct mnt_idmap *idmap, const struct path *link)
> +int may_linkat(const struct mnt_idmap *idmap, const struct path *link)
>  {
>  	struct inode *inode = link->dentry->d_inode;
>  
> @@ -1952,7 +1952,7 @@ static struct dentry *lookup_slow_killable(const struct qstr *name,
>  	return res;
>  }
>  
> -static inline int may_lookup(struct mnt_idmap *idmap,
> +static inline int may_lookup(const struct mnt_idmap *idmap,
>  			     struct nameidata *restrict nd)
>  {
>  	int err, mask;
> @@ -4228,7 +4228,7 @@ bool may_open_dev(const struct path *path)
>  		!(path->mnt->mnt_sb->s_iflags & SB_I_NODEV);
>  }
>  
> -static int may_open(struct mnt_idmap *idmap, const struct path *path,
> +static int may_open(const struct mnt_idmap *idmap, const struct path *path,
>  		    int acc_mode, int flag)
>  {
>  	struct dentry *dentry = path->dentry;
> @@ -4312,7 +4312,7 @@ static inline int open_to_namei_flags(int flag)
>  	return flag;
>  }
>  
> -static int may_o_create(struct mnt_idmap *idmap,
> +static int may_o_create(const struct mnt_idmap *idmap,
>  			const struct path *dir, struct dentry *dentry,
>  			umode_t mode)
>  {
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 49394123bd09..7574bc2fb677 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -3393,7 +3393,7 @@ static int nfs_execute_ok(struct inode *inode, int mask)
>  	return ret;
>  }
>  
> -int nfs_permission(struct mnt_idmap *idmap,
> +int nfs_permission(const struct mnt_idmap *idmap,
>  		   struct inode *inode,
>  		   int mask)
>  {
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 34e6096069ad..9342f651bf9b 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -943,7 +943,7 @@ int nilfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return err;
>  }
>  
> -int nilfs_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int nilfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		     int mask)
>  {
>  	struct nilfs_root *root = NILFS_I(inode)->i_root;
> diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
> index 4fc42d3787a4..0eaa191f70b8 100644
> --- a/fs/nilfs2/nilfs.h
> +++ b/fs/nilfs2/nilfs.h
> @@ -302,7 +302,7 @@ extern void nilfs_evict_inode(struct inode *);
>  extern int nilfs_setattr(struct mnt_idmap *, struct dentry *,
>  			 struct iattr *);
>  extern void nilfs_write_failed(struct address_space *mapping, loff_t to);
> -int nilfs_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int nilfs_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		     int mask);
>  int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
>  extern int nilfs_inode_dirty(struct inode *);
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index d6e977ba6565..24bbf607546c 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1349,7 +1349,7 @@ int ocfs2_getattr(struct mnt_idmap *idmap, const struct path *path,
>  	return err;
>  }
>  
> -int ocfs2_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int ocfs2_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		     int mask)
>  {
>  	int ret, had_lock;
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index 41e65e45a9f3..08e4d6796531 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -54,7 +54,7 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
>  int ocfs2_getattr(struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags);
> -int ocfs2_permission(struct mnt_idmap *idmap,
> +int ocfs2_permission(const struct mnt_idmap *idmap,
>  		     struct inode *inode,
>  		     int mask);
>  
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index cd3273c88e03..8e6eeec501bc 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -872,7 +872,7 @@ int orangefs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  	return ret;
>  }
>  
> -int orangefs_permission(struct mnt_idmap *idmap,
> +int orangefs_permission(const struct mnt_idmap *idmap,
>  			struct inode *inode, int mask)
>  {
>  	int ret;
> diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
> index 1451fc2c1917..c582ceffb26e 100644
> --- a/fs/orangefs/orangefs-kernel.h
> +++ b/fs/orangefs/orangefs-kernel.h
> @@ -357,7 +357,7 @@ int orangefs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
>  int orangefs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  		     struct kstat *stat, u32 request_mask, unsigned int flags);
>  
> -int orangefs_permission(struct mnt_idmap *idmap,
> +int orangefs_permission(const struct mnt_idmap *idmap,
>  			struct inode *inode, int mask);
>  
>  int orangefs_update_time(struct inode *inode, enum fs_update_time type,
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 0364e7d08ad7..1166381f1852 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -303,7 +303,7 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
>  	return err;
>  }
>  
> -int ovl_permission(struct mnt_idmap *idmap,
> +int ovl_permission(const struct mnt_idmap *idmap,
>  		   struct inode *inode, int mask)
>  {
>  	struct inode *upperinode = ovl_inode_upper(inode);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 6508f30aaaca..513ba93c7d1b 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -802,7 +802,7 @@ int ovl_set_nlink_lower(struct dentry *dentry);
>  unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
>  			   struct dentry *upperdentry,
>  			   unsigned int fallback);
> -int ovl_permission(struct mnt_idmap *idmap, struct inode *inode,
> +int ovl_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		   int mask);
>  
>  #ifdef CONFIG_FS_POSIX_ACL
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6a39de424f62..8dc43c846298 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -743,7 +743,7 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
>  }
>  
>  
> -static int proc_pid_permission(struct mnt_idmap *idmap,
> +static int proc_pid_permission(const struct mnt_idmap *idmap,
>  			       struct inode *inode, int mask)
>  {
>  	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
> @@ -3607,7 +3607,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
>   * This function makes sure that the node is always accessible for members of
>   * same thread group.
>   */
> -static int proc_tid_comm_permission(struct mnt_idmap *idmap,
> +static int proc_tid_comm_permission(const struct mnt_idmap *idmap,
>  				    struct inode *inode, int mask)
>  {
>  	bool is_same_tgroup;
> diff --git a/fs/proc/fd.c b/fs/proc/fd.c
> index 0f9a1556f2a3..0653bceb730d 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -82,7 +82,7 @@ static int seq_fdinfo_open(struct inode *inode, struct file *file)
>   * that the current task has PTRACE_MODE_READ in addition to the normal
>   * POSIX-like checks.
>   */
> -static int proc_fdinfo_permission(struct mnt_idmap *idmap, struct inode *inode,
> +static int proc_fdinfo_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  				  int mask)
>  {
>  	bool allowed = false;
> @@ -323,7 +323,7 @@ static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
>   * /proc/pid/fd needs a special permission handler so that a process can still
>   * access /proc/self/fd after it has executed a setuid().
>   */
> -int proc_fd_permission(struct mnt_idmap *idmap,
> +int proc_fd_permission(const struct mnt_idmap *idmap,
>  		       struct inode *inode, int mask)
>  {
>  	struct task_struct *p;
> diff --git a/fs/proc/fd.h b/fs/proc/fd.h
> index 7e7265f7e06f..77f2e4f38592 100644
> --- a/fs/proc/fd.h
> +++ b/fs/proc/fd.h
> @@ -10,7 +10,7 @@ extern const struct inode_operations proc_fd_inode_operations;
>  extern const struct file_operations proc_fdinfo_operations;
>  extern const struct inode_operations proc_fdinfo_inode_operations;
>  
> -extern int proc_fd_permission(struct mnt_idmap *idmap,
> +extern int proc_fd_permission(const struct mnt_idmap *idmap,
>  			      struct inode *inode, int mask);
>  
>  static inline unsigned int proc_fd(struct inode *inode)
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 04a382178c65..5315d891f244 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -788,7 +788,7 @@ static int proc_sys_readdir(struct file *file, struct dir_context *ctx)
>  	return 0;
>  }
>  
> -static int proc_sys_permission(struct mnt_idmap *idmap,
> +static int proc_sys_permission(const struct mnt_idmap *idmap,
>  			       struct inode *inode, int mask)
>  {
>  	/*
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 7ecd70efdfea..b1ecbcfb154e 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -402,7 +402,7 @@ static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
>  	return rc;
>  }
>  
> -static int cifs_permission(struct mnt_idmap *idmap,
> +static int cifs_permission(const struct mnt_idmap *idmap,
>  			   struct inode *inode, int mask)
>  {
>  	unsigned int sbflags = cifs_sb_flags(CIFS_SB(inode));
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index cb52dce113b9..0361de56edc2 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -115,7 +115,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
>  	return 0;
>  }
>  
> -void ksmbd_vfs_query_maximal_access(struct mnt_idmap *idmap,
> +void ksmbd_vfs_query_maximal_access(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, __le32 *daccess)
>  {
>  	*daccess = cpu_to_le32(FILE_READ_ATTRIBUTES | READ_CONTROL);
> diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
> index 9f4b003166e5..9c8b5b288926 100644
> --- a/fs/smb/server/vfs.h
> +++ b/fs/smb/server/vfs.h
> @@ -74,7 +74,7 @@ struct ksmbd_kstat {
>  };
>  
>  int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
> -void ksmbd_vfs_query_maximal_access(struct mnt_idmap *idmap,
> +void ksmbd_vfs_query_maximal_access(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, __le32 *daccess);
>  int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode);
>  int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode);
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index f3d6188a3b7b..7cf32384ad50 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -189,7 +189,7 @@ static void set_tracefs_inode_owner(struct inode *inode)
>  		inode->i_gid = gid;
>  }
>  
> -static int tracefs_permission(struct mnt_idmap *idmap,
> +static int tracefs_permission(const struct mnt_idmap *idmap,
>  			      struct inode *inode, int mask)
>  {
>  	set_tracefs_inode_owner(inode);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 91a23c8dbbf6..f815594dd8cb 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1994,7 +1994,7 @@ enum fs_update_time {
>  struct inode_operations {
>  	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
>  	const char * (*get_link) (struct dentry *, struct inode *, struct delayed_call *);
> -	int (*permission) (struct mnt_idmap *, struct inode *, int);
> +	int (*permission) (const struct mnt_idmap *, struct inode *, int);
>  	struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
>  
>  	int (*readlink) (struct dentry *, char __user *,int);
> @@ -2709,8 +2709,8 @@ static inline int bmap(struct inode *inode,  sector_t *block)
>  
>  int notify_change(struct mnt_idmap *, struct dentry *,
>  		  struct iattr *, struct delegated_inode *);
> -int inode_permission(struct mnt_idmap *, struct inode *, int);
> -int generic_permission(struct mnt_idmap *, struct inode *, int);
> +int inode_permission(const struct mnt_idmap *, struct inode *, int);
> +int generic_permission(const struct mnt_idmap *, struct inode *, int);
>  static inline int file_permission(struct file *file, int mask)
>  {
>  	return inode_permission(file_mnt_idmap(file),
> @@ -3397,7 +3397,7 @@ static inline bool generic_ci_validate_strict_name(struct inode *dir,
>  }
>  #endif
>  
> -int may_setattr(struct mnt_idmap *idmap, struct inode *inode,
> +int may_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  		unsigned int ia_valid);
>  int setattr_prepare(struct mnt_idmap *, struct dentry *, struct iattr *);
>  extern int inode_newsize_ok(const struct inode *, loff_t offset);
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index b85a73ae7919..b2828ea03abe 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -441,7 +441,7 @@ extern int nfs_getattr(struct mnt_idmap *, const struct path *,
>  		       struct kstat *, u32, unsigned int);
>  extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *, const struct cred *);
>  extern void nfs_access_set_mask(struct nfs_access_entry *, u32);
> -extern int nfs_permission(struct mnt_idmap *, struct inode *, int);
> +extern int nfs_permission(const struct mnt_idmap *, struct inode *, int);
>  extern int nfs_open(struct inode *, struct file *);
>  extern int nfs_attribute_cache_expired(struct inode *inode);
>  extern int nfs_revalidate_inode(struct inode *inode, unsigned long flags);
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index c7d91476971c..a0be7f1b5993 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1782,7 +1782,7 @@ static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
>  	return sel_attach(dir, name, inode);
>  }
>  
> -static int reject_all(struct mnt_idmap *idmap, struct inode *inode, int mask)
> +static int reject_all(const struct mnt_idmap *idmap, struct inode *inode, int mask)
>  {
>  	return -EPERM;	// no access for anyone, root or no root.
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
