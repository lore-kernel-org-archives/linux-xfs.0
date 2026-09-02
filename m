Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B1F4A4822;
	Wed,  2 Sep 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788364700; cv=none; b=DS5T/ctlRTOJQjbFmeNMw03WNqIpZgzYbmPK1prlqmEPe9RCqX1AvDg13I/9jeP0tTRvYE9FFIOOEojOpok9TVzjLheeD5FCwq8sl2uTVaS5kvZgVhw9HW14W3LWZVUreyhwXXTpM84CKLC224w9Zj3WQUTgSq3TNASer11r0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788364700; c=relaxed/simple;
	bh=m012E2ivacBy2hnCm5623OBzTonF2YF9dJaHEtPouYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcFRSk+EVeBZ3u/K+C2nISsWz7yoWEil+Qp/cmiLOVODLmsIHDnKELw+KlG7O+PeUdBnZlih3dbve5NOo+VD67OiSQKHqeduOQjgWcNRddRJQL1e2jtP+iK4QFwT2F/REpB+REvPggw/NbgFeWTWhWK7US00nqYAE+K+OdYH4og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sz/k9+7j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BLMSD0jh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ys1Df6WG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xjV93S3o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sz/k9+7j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BLMSD0jh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ys1Df6WG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xjV93S3o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 66D8D21D9C;
	Wed,  2 Sep 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2CtE9GkwORlPcyAB3jCxkhTPmuef/XZYWE7KWSU89r0=;
	b=sz/k9+7j+fPaBc+C4zbQJlrlXJauE1DEkgzcKFXwzUFLUkbFxiGnChFWIAZwT3VgFnkIt3
	iybFlj2nQzi6U239TqZonydi9LpAFteJeDvZT6UF1YIp+w5Pl7NFaobnf+IcLs8oj38PFW
	MGhwy90FRStCAJI2bjsMhwM8l76iN44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2CtE9GkwORlPcyAB3jCxkhTPmuef/XZYWE7KWSU89r0=;
	b=BLMSD0jhYqDETsUaa83ZOI/ekUsSQac7PH7TatGfcMW8txDLNwEUUmEifyoVx6Trkb1PNb
	y6t3bMrj2CnDM/Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788364685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2CtE9GkwORlPcyAB3jCxkhTPmuef/XZYWE7KWSU89r0=;
	b=ys1Df6WGybrV0X1Al9GE1L8VfcgPpzdLg4lviurLbv34uwpppp4OfPlrHHv2CAYpD+p24k
	1+Kzf8ga+thG5QAV5SUP2jDNPf+5hPyB/VoFmvCK51kQACGzCYeQjjtuQr16XXLE7dxYRu
	ceOjHMPPC+/40PZMOyB70s0mFvM61zE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788364685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2CtE9GkwORlPcyAB3jCxkhTPmuef/XZYWE7KWSU89r0=;
	b=xjV93S3oB8OfrgguEG7N+rx8Hmc0NWjYefgamHFbmF15ypJ+bFA2B1B6ToiMc0CzFxwxGv
	XPKKRLqN6qEaQ9CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 431C513515;
	Wed,  2 Sep 2026 15:58:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wT5hEI1HmGqRcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:58:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D567BA13B5; Wed, 02 Sep 2026 17:58:00 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:58:00 +0200
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
Subject: Re: [PATCH 23/27] fs: port ->getattr() to pass const mnt_idmap
Message-ID: <47344iq56tc52ct2yfqh6e74kfoogsm7chzkid3pducfd72fbf@6waelv7xotce>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-23-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-23-54ccd48e100b@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:48, Christian Brauner wrote:
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
>  fs/afs/inode.c                        | 2 +-
>  fs/afs/internal.h                     | 2 +-
>  fs/anon_inodes.c                      | 2 +-
>  fs/bad_inode.c                        | 2 +-
>  fs/btrfs/inode.c                      | 2 +-
>  fs/ceph/inode.c                       | 4 ++--
>  fs/ceph/super.h                       | 2 +-
>  fs/coda/coda_linux.h                  | 2 +-
>  fs/coda/inode.c                       | 2 +-
>  fs/ecryptfs/inode.c                   | 4 ++--
>  fs/erofs/inode.c                      | 2 +-
>  fs/erofs/internal.h                   | 2 +-
>  fs/exfat/exfat_fs.h                   | 2 +-
>  fs/exfat/file.c                       | 2 +-
>  fs/ext2/ext2.h                        | 2 +-
>  fs/ext2/inode.c                       | 2 +-
>  fs/ext4/ext4.h                        | 4 ++--
>  fs/ext4/inode.c                       | 4 ++--
>  fs/ext4/symlink.c                     | 2 +-
>  fs/f2fs/f2fs.h                        | 2 +-
>  fs/f2fs/file.c                        | 2 +-
>  fs/f2fs/namei.c                       | 2 +-
>  fs/failfs.c                           | 2 +-
>  fs/fat/fat.h                          | 2 +-
>  fs/fat/file.c                         | 2 +-
>  fs/fuse/dir.c                         | 4 ++--
>  fs/gfs2/inode.c                       | 2 +-
>  fs/hfsplus/hfsplus_fs.h               | 2 +-
>  fs/hfsplus/inode.c                    | 2 +-
>  fs/internal.h                         | 2 +-
>  fs/kernfs/inode.c                     | 2 +-
>  fs/kernfs/kernfs-internal.h           | 2 +-
>  fs/libfs.c                            | 2 +-
>  fs/minix/inode.c                      | 2 +-
>  fs/minix/minix.h                      | 2 +-
>  fs/nfs/inode.c                        | 2 +-
>  fs/nfs/namespace.c                    | 2 +-
>  fs/ntfs/file.c                        | 2 +-
>  fs/ntfs/inode.h                       | 2 +-
>  fs/ntfs3/file.c                       | 2 +-
>  fs/ntfs3/ntfs_fs.h                    | 2 +-
>  fs/ocfs2/file.c                       | 2 +-
>  fs/ocfs2/file.h                       | 2 +-
>  fs/orangefs/inode.c                   | 2 +-
>  fs/orangefs/orangefs-kernel.h         | 2 +-
>  fs/overlayfs/inode.c                  | 2 +-
>  fs/overlayfs/overlayfs.h              | 2 +-
>  fs/pidfs.c                            | 2 +-
>  fs/proc/base.c                        | 4 ++--
>  fs/proc/fd.c                          | 2 +-
>  fs/proc/generic.c                     | 2 +-
>  fs/proc/internal.h                    | 2 +-
>  fs/proc/proc_net.c                    | 2 +-
>  fs/proc/proc_sysctl.c                 | 2 +-
>  fs/proc/root.c                        | 2 +-
>  fs/smb/client/cifsfs.h                | 2 +-
>  fs/smb/client/inode.c                 | 2 +-
>  fs/stat.c                             | 2 +-
>  fs/tracefs/inode.c                    | 2 +-
>  fs/ubifs/dir.c                        | 2 +-
>  fs/ubifs/file.c                       | 2 +-
>  fs/ubifs/ubifs.h                      | 2 +-
>  fs/udf/symlink.c                      | 2 +-
>  fs/vboxsf/utils.c                     | 2 +-
>  fs/vboxsf/vfsmod.h                    | 2 +-
>  fs/xfs/xfs_iops.c                     | 2 +-
>  include/linux/fs.h                    | 6 +++---
>  include/linux/nfs_fs.h                | 2 +-
>  mm/shmem.c                            | 2 +-
>  73 files changed, 81 insertions(+), 81 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 864768700eda..f11bfc2e0c13 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -77,7 +77,7 @@ prototypes::
>  	int (*permission) (const struct mnt_idmap *, struct inode *, int, unsigned int);
>  	struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
>  	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> -	int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
> +	int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
>  	void (*update_time)(struct inode *inode, enum fs_update_time type,
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 2ad273cfe547..98aefc5d399e 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -431,7 +431,7 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*permission) (const struct mnt_idmap *, struct inode *, int);
>  		struct posix_acl * (*get_inode_acl)(struct inode *, int, bool);
>  		int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> -		int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
> +		int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  		void (*update_time)(struct inode *inode, enum fs_update_time type,
>  				    int flags);
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index f2d0eef68acf..0c280342f8e9 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -966,7 +966,7 @@ v9fs_vfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
>   */
>  
>  static int
> -v9fs_vfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +v9fs_vfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct dentry *dentry = path->dentry;
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index c7176719a4f9..e37854ee6346 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -414,7 +414,7 @@ static struct dentry *v9fs_vfs_mkdir_dotl(const struct mnt_idmap *idmap,
>  }
>  
>  static int
> -v9fs_vfs_getattr_dotl(struct mnt_idmap *idmap,
> +v9fs_vfs_getattr_dotl(const struct mnt_idmap *idmap,
>  		      const struct path *path, struct kstat *stat,
>  		      u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 14f39a9bea6c..7b8a2adc3f59 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -596,7 +596,7 @@ struct inode *afs_root_iget(struct super_block *sb, struct key *key)
>  /*
>   * read the attributes of an inode
>   */
> -int afs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int afs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index e772da2a15f2..7a8cdde9e0ad 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -1258,7 +1258,7 @@ extern int afs_fetch_status(struct afs_vnode *, struct key *, bool, afs_access_t
>  extern int afs_ilookup5_test_by_fid(struct inode *, void *);
>  extern struct inode *afs_iget(struct afs_operation *, struct afs_vnode_param *);
>  extern struct inode *afs_root_iget(struct super_block *, struct key *);
> -extern int afs_getattr(struct mnt_idmap *idmap, const struct path *,
> +extern int afs_getattr(const struct mnt_idmap *idmap, const struct path *,
>  		       struct kstat *, u32, unsigned int);
>  extern int afs_setattr(struct mnt_idmap *idmap, struct dentry *, struct iattr *);
>  extern void afs_evict_inode(struct inode *);
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index a7b9b948e33d..d4a7e0b67289 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -46,7 +46,7 @@ static struct inode *anon_inode_inode __ro_after_init;
>   * Rather than mess with our internal sane inode data, just fix it
>   * up here in getattr() by masking off the format bits.
>   */
> -int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int anon_inode_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		       struct kstat *stat, u32 request_mask,
>  		       unsigned int query_flags)
>  {
> diff --git a/fs/bad_inode.c b/fs/bad_inode.c
> index 8c7578ea4bd7..e740b4e658bf 100644
> --- a/fs/bad_inode.c
> +++ b/fs/bad_inode.c
> @@ -95,7 +95,7 @@ static int bad_inode_permission(const struct mnt_idmap *idmap,
>  	return -EIO;
>  }
>  
> -static int bad_inode_getattr(struct mnt_idmap *idmap,
> +static int bad_inode_getattr(const struct mnt_idmap *idmap,
>  			     const struct path *path, struct kstat *stat,
>  			     u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 61cfa03b6152..da143f9376ee 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8224,7 +8224,7 @@ int __init btrfs_init_cachep(void)
>  	return 0;
>  }
>  
> -static int btrfs_getattr(struct mnt_idmap *idmap,
> +static int btrfs_getattr(const struct mnt_idmap *idmap,
>  			 const struct path *path, struct kstat *stat,
>  			 u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index b8527f67e3f0..185d713218e6 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2398,7 +2398,7 @@ static const char *ceph_encrypted_get_link(struct dentry *dentry,
>  				   done);
>  }
>  
> -static int ceph_encrypted_symlink_getattr(struct mnt_idmap *idmap,
> +static int ceph_encrypted_symlink_getattr(const struct mnt_idmap *idmap,
>  					  const struct path *path,
>  					  struct kstat *stat, u32 request_mask,
>  					  unsigned int query_flags)
> @@ -3145,7 +3145,7 @@ static int statx_to_caps(u32 want, umode_t mode)
>   * Get all the attributes. If we have sufficient caps for the requested attrs,
>   * then we can avoid talking to the MDS at all.
>   */
> -int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ceph_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index fd603be209e4..0a5e3916e855 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1177,7 +1177,7 @@ extern int __ceph_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  			  struct iattr *attr, struct ceph_iattr *cia);
>  extern int ceph_setattr(struct mnt_idmap *idmap,
>  			struct dentry *dentry, struct iattr *attr);
> -extern int ceph_getattr(struct mnt_idmap *idmap,
> +extern int ceph_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
>  			u32 request_mask, unsigned int flags);
>  void ceph_inode_shutdown(struct inode *inode);
> diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
> index 5ee6cedd3865..5dc9e392079f 100644
> --- a/fs/coda/coda_linux.h
> +++ b/fs/coda/coda_linux.h
> @@ -49,7 +49,7 @@ int coda_release(struct inode *i, struct file *f);
>  int coda_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		    int mask);
>  int coda_revalidate_inode(struct inode *);
> -int coda_getattr(struct mnt_idmap *, const struct path *, struct kstat *,
> +int coda_getattr(const struct mnt_idmap *, const struct path *, struct kstat *,
>  		 u32, unsigned int);
>  int coda_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
>  
> diff --git a/fs/coda/inode.c b/fs/coda/inode.c
> index 40b43866e6a5..f83ebd94c6be 100644
> --- a/fs/coda/inode.c
> +++ b/fs/coda/inode.c
> @@ -294,7 +294,7 @@ static void coda_evict_inode(struct inode *inode)
>  	coda_cache_clear_inode(inode);
>  }
>  
> -int coda_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int coda_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	int err = coda_revalidate_inode(d_inode(path->dentry));
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 432f82bc5b0c..e70a8d73d137 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -939,7 +939,7 @@ static int ecryptfs_setattr(struct mnt_idmap *idmap,
>  	return rc;
>  }
>  
> -static int ecryptfs_getattr_link(struct mnt_idmap *idmap,
> +static int ecryptfs_getattr_link(const struct mnt_idmap *idmap,
>  				 const struct path *path, struct kstat *stat,
>  				 u32 request_mask, unsigned int flags)
>  {
> @@ -965,7 +965,7 @@ static int ecryptfs_getattr_link(struct mnt_idmap *idmap,
>  	return rc;
>  }
>  
> -static int ecryptfs_getattr(struct mnt_idmap *idmap,
> +static int ecryptfs_getattr(const struct mnt_idmap *idmap,
>  			    const struct path *path, struct kstat *stat,
>  			    u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
> index 45afe5c50de8..26ea3790ff21 100644
> --- a/fs/erofs/inode.c
> +++ b/fs/erofs/inode.c
> @@ -311,7 +311,7 @@ struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid)
>  	return inode;
>  }
>  
> -int erofs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int erofs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask,
>  		  unsigned int query_flags)
>  {
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 65974e57aebf..b4f52f5cd626 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -421,7 +421,7 @@ void erofs_onlinefolio_init(struct folio *folio);
>  void erofs_onlinefolio_split(struct folio *folio);
>  void erofs_onlinefolio_end(struct folio *folio, int err, bool dirty);
>  struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid);
> -int erofs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int erofs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask,
>  		  unsigned int query_flags);
>  int erofs_namei(struct inode *dir, const struct qstr *name,
> diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
> index a9131fe03302..5165a0df068a 100644
> --- a/fs/exfat/exfat_fs.h
> +++ b/fs/exfat/exfat_fs.h
> @@ -557,7 +557,7 @@ extern const struct file_operations exfat_file_operations;
>  int __exfat_truncate(struct inode *inode);
>  int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
> -int exfat_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, unsigned int request_mask,
>  		  unsigned int query_flags);
>  struct file_kattr;
> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index 0530803f71e8..c072a0663e69 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
> @@ -319,7 +319,7 @@ static void exfat_truncate(struct inode *inode)
>  	mutex_unlock(&sbi->s_lock);
>  }
>  
> -int exfat_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, unsigned int request_mask,
>  		  unsigned int query_flags)
>  {
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 702cb7aa1afd..f4bb8b888052 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -740,7 +740,7 @@ extern void ext2_evict_inode(struct inode *);
>  void ext2_write_failed(struct address_space *mapping, loff_t to);
>  extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
>  extern int ext2_setattr (struct mnt_idmap *, struct dentry *, struct iattr *);
> -extern int ext2_getattr (struct mnt_idmap *, const struct path *,
> +extern int ext2_getattr (const struct mnt_idmap *, const struct path *,
>  			 struct kstat *, u32, unsigned int);
>  extern void ext2_set_inode_flags(struct inode *inode);
>  extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index a9245f0cda4d..d4b2a2dec35e 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1591,7 +1591,7 @@ int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>  	return err;
>  }
>  
> -int ext2_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ext2_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2c9a845ed0f8..eb7cf19f606a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3182,11 +3182,11 @@ extern int  ext4_sync_inode_metadata(struct inode *, struct writeback_control *)
>  extern int  ext4_setattr(struct mnt_idmap *, struct dentry *,
>  			 struct iattr *);
>  extern u32  ext4_dio_alignment(struct inode *inode);
> -extern int  ext4_getattr(struct mnt_idmap *, const struct path *,
> +extern int  ext4_getattr(const struct mnt_idmap *, const struct path *,
>  			 struct kstat *, u32, unsigned int);
>  extern void ext4_evict_inode(struct inode *);
>  extern void ext4_clear_inode(struct inode *);
> -extern int  ext4_file_getattr(struct mnt_idmap *, const struct path *,
> +extern int  ext4_file_getattr(const struct mnt_idmap *, const struct path *,
>  			      struct kstat *, u32, unsigned int);
>  extern void ext4_dirty_inode(struct inode *, int);
>  extern int ext4_change_inode_journal_flag(struct inode *, int);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bd4b778df9eb..045f5385f26e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6263,7 +6263,7 @@ u32 ext4_dio_alignment(struct inode *inode)
>  	return 1; /* use the iomap defaults */
>  }
>  
> -int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ext4_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> @@ -6332,7 +6332,7 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
>  	return 0;
>  }
>  
> -int ext4_file_getattr(struct mnt_idmap *idmap,
> +int ext4_file_getattr(const struct mnt_idmap *idmap,
>  		      const struct path *path, struct kstat *stat,
>  		      u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index b612262719ed..e680d1e45b47 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -55,7 +55,7 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
>  	return paddr;
>  }
>  
> -static int ext4_encrypted_symlink_getattr(struct mnt_idmap *idmap,
> +static int ext4_encrypted_symlink_getattr(const struct mnt_idmap *idmap,
>  					  const struct path *path,
>  					  struct kstat *stat, u32 request_mask,
>  					  unsigned int query_flags)
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 245df8563256..06538f5fd725 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3848,7 +3848,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
>  int f2fs_do_truncate_blocks(struct inode *inode, u64 from, bool lock);
>  int f2fs_truncate_blocks(struct inode *inode, u64 from, bool lock);
>  int f2fs_truncate(struct inode *inode);
> -int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int f2fs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags);
>  int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index d0cc2ca1397a..267a3a191d54 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1032,7 +1032,7 @@ static bool f2fs_force_buffered_io(struct inode *inode, int rw)
>  	return false;
>  }
>  
> -int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int f2fs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 9934777eb2a9..233c07fec171 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -1394,7 +1394,7 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
>  	return target;
>  }
>  
> -static int f2fs_encrypted_symlink_getattr(struct mnt_idmap *idmap,
> +static int f2fs_encrypted_symlink_getattr(const struct mnt_idmap *idmap,
>  					  const struct path *path,
>  					  struct kstat *stat, u32 request_mask,
>  					  unsigned int query_flags)
> diff --git a/fs/failfs.c b/fs/failfs.c
> index cec6cad99eb2..437cdc981c2d 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -35,7 +35,7 @@ static struct dentry *failfs_lookup(struct inode *dir, struct dentry *dentry,
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
>  
> -static int failfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +static int failfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  			  struct kstat *stat, u32 request_mask,
>  			  unsigned int query_flags)
>  {
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 61338413d9f3..202f209a544b 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -407,7 +407,7 @@ extern const struct inode_operations fat_file_inode_operations;
>  extern int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *attr);
>  extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
> -extern int fat_getattr(struct mnt_idmap *idmap,
> +extern int fat_getattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, struct kstat *stat,
>  		       u32 request_mask, unsigned int flags);
>  int fat_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 0b8b493d06e4..b37bc637945f 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -432,7 +432,7 @@ int fat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
>  }
>  EXPORT_SYMBOL_GPL(fat_fileattr_get);
>  
> -int fat_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int fat_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index ff941e78918f..dd267d9498bc 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1537,7 +1537,7 @@ static int fuse_do_getattr(const struct mnt_idmap *idmap, struct inode *inode,
>  	return err;
>  }
>  
> -static int fuse_update_get_attr(struct mnt_idmap *idmap, struct inode *inode,
> +static int fuse_update_get_attr(const struct mnt_idmap *idmap, struct inode *inode,
>  				struct file *file, struct kstat *stat,
>  				u32 request_mask, unsigned int flags)
>  {
> @@ -2387,7 +2387,7 @@ static int fuse_setattr(struct mnt_idmap *idmap, struct dentry *entry,
>  	return ret;
>  }
>  
> -static int fuse_getattr(struct mnt_idmap *idmap,
> +static int fuse_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
>  			u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index e207ab1f5c23..5ddac2f50f30 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -2156,7 +2156,7 @@ static int gfs2_setattr(struct mnt_idmap *idmap,
>   * Returns: errno
>   */
>  
> -static int gfs2_getattr(struct mnt_idmap *idmap,
> +static int gfs2_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
>  			u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
> index 86fc1c1cdfd6..d55cb16e3897 100644
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -459,7 +459,7 @@ void hfsplus_inode_write_fork(struct inode *inode,
>  			      struct hfsplus_fork_raw *fork);
>  int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd);
>  int hfsplus_cat_write_inode(struct inode *inode);
> -int hfsplus_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int hfsplus_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		    struct kstat *stat, u32 request_mask,
>  		    unsigned int query_flags);
>  int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index 9821662bfc1d..2807b29c7028 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -335,7 +335,7 @@ static int hfsplus_setattr(struct mnt_idmap *idmap,
>  	return 0;
>  }
>  
> -int hfsplus_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int hfsplus_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		    struct kstat *stat, u32 request_mask,
>  		    unsigned int query_flags)
>  {
> diff --git a/fs/internal.h b/fs/internal.h
> index 8a1c7c05c5a2..88d9296c2a48 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -356,7 +356,7 @@ void file_f_owner_release(struct file *file);
>  bool file_seek_cur_needs_f_lock(struct file *file);
>  int statmount_mnt_idmap(const struct mnt_idmap *idmap, struct seq_file *seq, bool uid_map);
>  struct dentry *find_next_child(struct dentry *parent, struct dentry *prev);
> -int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int anon_inode_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		       struct kstat *stat, u32 request_mask,
>  		       unsigned int query_flags);
>  int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index b348d4cd150b..6a92aa789ce5 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -181,7 +181,7 @@ static void kernfs_refresh_inode(struct kernfs_node *kn, struct inode *inode)
>  		set_nlink(inode, kn->dir.subdirs + 2);
>  }
>  
> -int kernfs_iop_getattr(struct mnt_idmap *idmap,
> +int kernfs_iop_getattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, struct kstat *stat,
>  		       u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index 0f6f412213f6..8af7849f2c9c 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -175,7 +175,7 @@ int kernfs_iop_permission(const struct mnt_idmap *idmap,
>  			  struct inode *inode, int mask);
>  int kernfs_iop_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		       struct iattr *iattr);
> -int kernfs_iop_getattr(struct mnt_idmap *idmap,
> +int kernfs_iop_getattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, struct kstat *stat,
>  		       u32 request_mask, unsigned int query_flags);
>  ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size);
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 8b379230b64f..b70977b10a7c 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -29,7 +29,7 @@
>  
>  #include "internal.h"
>  
> -int simple_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int simple_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		   struct kstat *stat, u32 request_mask,
>  		   unsigned int query_flags)
>  {
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index daf83e4ff25c..670179173645 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -724,7 +724,7 @@ static int minix_sync_inode_metadata(struct inode *inode,
>  	return err;
>  }
>  
> -int minix_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int minix_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct super_block *sb = path->dentry->d_sb;
> diff --git a/fs/minix/minix.h b/fs/minix/minix.h
> index 78722ce22e1e..db92cf9e0e1b 100644
> --- a/fs/minix/minix.h
> +++ b/fs/minix/minix.h
> @@ -55,7 +55,7 @@ unsigned long minix_count_free_inodes(struct super_block *sb);
>  int minix_new_block(struct inode *inode);
>  void minix_free_block(struct inode *inode, unsigned long block);
>  unsigned long minix_count_free_blocks(struct super_block *sb);
> -int minix_getattr(struct mnt_idmap *, const struct path *,
> +int minix_getattr(const struct mnt_idmap *, const struct path *,
>  		struct kstat *, u32, unsigned int);
>  int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
>  struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 3022454f7698..b114488715fb 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -955,7 +955,7 @@ static u32 nfs_get_valid_attrmask(struct inode *inode)
>  	return reply_mask;
>  }
>  
> -int nfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int nfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
> index 6d0073c24771..17f54d79efa7 100644
> --- a/fs/nfs/namespace.c
> +++ b/fs/nfs/namespace.c
> @@ -222,7 +222,7 @@ struct vfsmount *nfs_d_automount(struct path *path)
>  }
>  
>  static int
> -nfs_namespace_getattr(struct mnt_idmap *idmap,
> +nfs_namespace_getattr(const struct mnt_idmap *idmap,
>  		      const struct path *path, struct kstat *stat,
>  		      u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 88747217ba61..40e01704ea8f 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -364,7 +364,7 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return err;
>  }
>  
> -int ntfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, unsigned int request_mask,
>  		unsigned int query_flags)
>  {
> diff --git a/fs/ntfs/inode.h b/fs/ntfs/inode.h
> index ff61bd402df0..9cf923911825 100644
> --- a/fs/ntfs/inode.h
> +++ b/fs/ntfs/inode.h
> @@ -332,7 +332,7 @@ int ntfs_truncate_vfs(struct inode *vi, loff_t new_size, loff_t i_size);
>  
>  int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
> -int ntfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, unsigned int request_mask,
>  		unsigned int query_flags);
>  
> diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> index f7baa202dc28..f4d08346d25d 100644
> --- a/fs/ntfs3/file.c
> +++ b/fs/ntfs3/file.c
> @@ -261,7 +261,7 @@ long ntfs_compat_ioctl(struct file *filp, u32 cmd, unsigned long arg)
>  /*
>   * ntfs_getattr - inode_operations::getattr
>   */
> -int ntfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, u32 flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
> index d89609a17886..262b7ff2d6e1 100644
> --- a/fs/ntfs3/ntfs_fs.h
> +++ b/fs/ntfs3/ntfs_fs.h
> @@ -553,7 +553,7 @@ extern const struct file_operations ntfs_dir_operations;
>  int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
>  int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      struct file_kattr *fa);
> -int ntfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, u32 flags);
>  int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 struct iattr *attr);
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 24bbf607546c..befc6ebb2a06 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1317,7 +1317,7 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return status;
>  }
>  
> -int ocfs2_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ocfs2_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index 08e4d6796531..b51c8e77dad7 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -52,7 +52,7 @@ int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
>  		      loff_t zero_to);
>  int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		  struct iattr *attr);
> -int ocfs2_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ocfs2_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags);
>  int ocfs2_permission(const struct mnt_idmap *idmap,
>  		     struct inode *inode,
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index 536d5e842c55..100669ee5862 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -848,7 +848,7 @@ int orangefs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  /*
>   * Obtain attributes of an object given a dentry
>   */
> -int orangefs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int orangefs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		     struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	int ret;
> diff --git a/fs/orangefs/orangefs-kernel.h b/fs/orangefs/orangefs-kernel.h
> index a5c9e7be4005..3bf01c0c763b 100644
> --- a/fs/orangefs/orangefs-kernel.h
> +++ b/fs/orangefs/orangefs-kernel.h
> @@ -354,7 +354,7 @@ int __orangefs_setattr(struct inode *, struct iattr *);
>  int __orangefs_setattr_mode(struct dentry *dentry, struct iattr *iattr);
>  int orangefs_setattr(struct mnt_idmap *, struct dentry *, struct iattr *);
>  
> -int orangefs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int orangefs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		     struct kstat *stat, u32 request_mask, unsigned int flags);
>  
>  int orangefs_permission(const struct mnt_idmap *idmap,
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 18e4cbe154cf..b765780686e6 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -168,7 +168,7 @@ static inline int ovl_real_getattr_nosec(struct super_block *sb,
>  		return vfs_getattr_nosec(path, stat, request_mask, flags);
>  }
>  
> -int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ovl_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct dentry *dentry = path->dentry;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 1759221dcad5..02a822dc8e5e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -950,6 +950,6 @@ static inline bool ovl_force_readonly(struct ovl_fs *ofs)
>  const struct xattr_handler * const *ovl_xattr_handlers(struct ovl_fs *ofs);
>  int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  		struct iattr *attr);
> -int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ovl_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int flags);
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index 5bc136de8660..38868ac99950 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -829,7 +829,7 @@ static int pidfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return anon_inode_setattr(idmap, dentry, attr);
>  }
>  
> -static int pidfs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +static int pidfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  			 struct kstat *stat, u32 request_mask,
>  			 unsigned int query_flags)
>  {
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8dc43c846298..3278c37e5cde 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1994,7 +1994,7 @@ static struct inode *proc_pid_make_base_inode(struct super_block *sb,
>  	return inode;
>  }
>  
> -int pid_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int pid_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		struct kstat *stat, u32 request_mask, unsigned int query_flags)
>  {
>  	struct inode *inode = d_inode(path->dentry);
> @@ -3936,7 +3936,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
>  	return 0;
>  }
>  
> -static int proc_task_getattr(struct mnt_idmap *idmap,
> +static int proc_task_getattr(const struct mnt_idmap *idmap,
>  			     const struct path *path, struct kstat *stat,
>  			     u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/proc/fd.c b/fs/proc/fd.c
> index 0653bceb730d..7214a7495380 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -342,7 +342,7 @@ int proc_fd_permission(const struct mnt_idmap *idmap,
>  	return rv;
>  }
>  
> -static int proc_fd_getattr(struct mnt_idmap *idmap,
> +static int proc_fd_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
>  			u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 26086a283672..4c4f1e63f68f 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -135,7 +135,7 @@ static int proc_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	return 0;
>  }
>  
> -static int proc_getattr(struct mnt_idmap *idmap,
> +static int proc_getattr(const struct mnt_idmap *idmap,
>  			const struct path *path, struct kstat *stat,
>  			u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 04bd6c9e65a7..706fae7d30be 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -258,7 +258,7 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
>   * base.c
>   */
>  extern const struct dentry_operations pid_dentry_operations;
> -extern int pid_getattr(struct mnt_idmap *, const struct path *,
> +extern int pid_getattr(const struct mnt_idmap *, const struct path *,
>  		       struct kstat *, u32, unsigned int);
>  int proc_nochmod_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  			struct iattr *attr);
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 00cc385bce21..b1f5eafb069a 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -308,7 +308,7 @@ static struct dentry *proc_tgid_net_lookup(struct inode *dir,
>  	return de;
>  }
>  
> -static int proc_tgid_net_getattr(struct mnt_idmap *idmap,
> +static int proc_tgid_net_getattr(const struct mnt_idmap *idmap,
>  				 const struct path *path, struct kstat *stat,
>  				 u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 5315d891f244..bd6730000b27 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -834,7 +834,7 @@ static int proc_sys_setattr(struct mnt_idmap *idmap,
>  	return 0;
>  }
>  
> -static int proc_sys_getattr(struct mnt_idmap *idmap,
> +static int proc_sys_getattr(const struct mnt_idmap *idmap,
>  			    const struct path *path, struct kstat *stat,
>  			    u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 99adddfeb4a4..7fbbe92bf73a 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -402,7 +402,7 @@ void __init proc_root_init(void)
>  	register_filesystem(&proc_fs_type);
>  }
>  
> -static int proc_root_getattr(struct mnt_idmap *idmap,
> +static int proc_root_getattr(const struct mnt_idmap *idmap,
>  			     const struct path *path, struct kstat *stat,
>  			     u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index cf09d915bedd..c0adc5219213 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -78,7 +78,7 @@ int cifs_revalidate_file(struct file *filp);
>  int cifs_revalidate_dentry(struct dentry *dentry);
>  int cifs_revalidate_mapping(struct inode *inode);
>  int cifs_zap_mapping(struct inode *inode);
> -int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int cifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags);
>  int cifs_setattr(struct mnt_idmap *idmap, struct dentry *direntry,
>  		 struct iattr *attrs);
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index e3610e456bd4..132f9e072b77 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2932,7 +2932,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
>  	return cifs_revalidate_mapping(inode);
>  }
>  
> -int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int cifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		 struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(path->dentry);
> diff --git a/fs/stat.c b/fs/stat.c
> index c461c3054234..fe351818d1d6 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -79,7 +79,7 @@ EXPORT_SYMBOL(fill_mg_cmtime);
>   * uid and gid filds. On non-idmapped mounts or if permission checking is to be
>   * performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -void generic_fillattr(struct mnt_idmap *idmap, u32 request_mask,
> +void generic_fillattr(const struct mnt_idmap *idmap, u32 request_mask,
>  		      struct inode *inode, struct kstat *stat)
>  {
>  	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 995b8d0f8d33..44448f1a2bb1 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -196,7 +196,7 @@ static int tracefs_permission(const struct mnt_idmap *idmap,
>  	return generic_permission(idmap, inode, mask);
>  }
>  
> -static int tracefs_getattr(struct mnt_idmap *idmap,
> +static int tracefs_getattr(const struct mnt_idmap *idmap,
>  			   const struct path *path, struct kstat *stat,
>  			   u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 57640b6ff72d..c67954f6bee0 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -1667,7 +1667,7 @@ static int ubifs_rename(const struct mnt_idmap *idmap,
>  	return do_rename(old_dir, old_dentry, new_dir, new_dentry, flags);
>  }
>  
> -int ubifs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ubifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags)
>  {
>  	loff_t size;
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index e73c28b12f97..bfc1bd0203ad 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -1611,7 +1611,7 @@ static const char *ubifs_get_link(struct dentry *dentry,
>  	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
>  }
>  
> -static int ubifs_symlink_getattr(struct mnt_idmap *idmap,
> +static int ubifs_symlink_getattr(const struct mnt_idmap *idmap,
>  				 const struct path *path, struct kstat *stat,
>  				 u32 request_mask, unsigned int query_flags)
>  {
> diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
> index af0ef3583aeb..d455a67fe411 100644
> --- a/fs/ubifs/ubifs.h
> +++ b/fs/ubifs/ubifs.h
> @@ -2028,7 +2028,7 @@ int ubifs_update_time(struct inode *inode, enum fs_update_time type,
>  /* dir.c */
>  struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
>  			      umode_t mode, bool is_xattr);
> -int ubifs_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int ubifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		  struct kstat *stat, u32 request_mask, unsigned int flags);
>  int ubifs_check_dir_empty(struct inode *dir);
>  
> diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
> index a05d1888a2ba..df41bf5a05b1 100644
> --- a/fs/udf/symlink.c
> +++ b/fs/udf/symlink.c
> @@ -133,7 +133,7 @@ static int udf_symlink_filler(struct file *file, struct folio *folio)
>  	return err;
>  }
>  
> -static int udf_symlink_getattr(struct mnt_idmap *idmap,
> +static int udf_symlink_getattr(const struct mnt_idmap *idmap,
>  			       const struct path *path, struct kstat *stat,
>  			       u32 request_mask, unsigned int flags)
>  {
> diff --git a/fs/vboxsf/utils.c b/fs/vboxsf/utils.c
> index 298bfc93255c..6a5a47a32075 100644
> --- a/fs/vboxsf/utils.c
> +++ b/fs/vboxsf/utils.c
> @@ -233,7 +233,7 @@ int vboxsf_inode_revalidate(struct dentry *dentry)
>  	return 0;
>  }
>  
> -int vboxsf_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int vboxsf_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		   struct kstat *kstat, u32 request_mask, unsigned int flags)
>  {
>  	int err;
> diff --git a/fs/vboxsf/vfsmod.h b/fs/vboxsf/vfsmod.h
> index b61afd0ce842..9c713b8e7aa2 100644
> --- a/fs/vboxsf/vfsmod.h
> +++ b/fs/vboxsf/vfsmod.h
> @@ -98,7 +98,7 @@ int vboxsf_stat(struct vboxsf_sbi *sbi, struct shfl_string *path,
>  		struct shfl_fsobjinfo *info);
>  int vboxsf_stat_dentry(struct dentry *dentry, struct shfl_fsobjinfo *info);
>  int vboxsf_inode_revalidate(struct dentry *dentry);
> -int vboxsf_getattr(struct mnt_idmap *idmap, const struct path *path,
> +int vboxsf_getattr(const struct mnt_idmap *idmap, const struct path *path,
>  		   struct kstat *kstat, u32 request_mask,
>  		   unsigned int query_flags);
>  int vboxsf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 791af2db7124..19fd83cea18b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -679,7 +679,7 @@ xfs_report_atomic_write(
>  
>  STATIC int
>  xfs_vn_getattr(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	const struct path	*path,
>  	struct kstat		*stat,
>  	u32			request_mask,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2b9ae72010f0..c79fd3776bbf 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2013,7 +2013,7 @@ struct inode_operations {
>  	int (*rename) (const struct mnt_idmap *, struct inode *, struct dentry *,
>  			struct inode *, struct dentry *, unsigned int);
>  	int (*setattr) (struct mnt_idmap *, struct dentry *, struct iattr *);
> -	int (*getattr) (struct mnt_idmap *, const struct path *,
> +	int (*getattr) (const struct mnt_idmap *, const struct path *,
>  			struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
> @@ -3204,7 +3204,7 @@ extern int page_symlink(struct inode *inode, const char *symname, int len);
>  extern const struct inode_operations page_symlink_inode_operations;
>  extern void kfree_link(void *);
>  void fill_mg_cmtime(struct kstat *stat, u32 request_mask, struct inode *inode);
> -void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
> +void generic_fillattr(const struct mnt_idmap *, u32, struct inode *, struct kstat *);
>  void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
>  void generic_fill_statx_atomic_writes(struct kstat *stat,
>  				      unsigned int unit_min,
> @@ -3263,7 +3263,7 @@ extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
>  extern int dcache_readdir(struct file *, struct dir_context *);
>  extern int simple_setattr(struct mnt_idmap *, struct dentry *,
>  			  struct iattr *);
> -extern int simple_getattr(struct mnt_idmap *, const struct path *,
> +extern int simple_getattr(const struct mnt_idmap *, const struct path *,
>  			  struct kstat *, u32, unsigned int);
>  extern int simple_statfs(struct dentry *, struct kstatfs *);
>  extern int simple_open(struct inode *inode, struct file *file);
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index b2828ea03abe..7b307dea7ce7 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -437,7 +437,7 @@ extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
>  extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
>  extern int nfs_post_op_update_inode_force_wcc(struct inode *inode, struct nfs_fattr *fattr);
>  extern int nfs_post_op_update_inode_force_wcc_locked(struct inode *inode, struct nfs_fattr *fattr);
> -extern int nfs_getattr(struct mnt_idmap *, const struct path *,
> +extern int nfs_getattr(const struct mnt_idmap *, const struct path *,
>  		       struct kstat *, u32, unsigned int);
>  extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *, const struct cred *);
>  extern void nfs_access_set_mask(struct nfs_access_entry *, u32);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 656235b2f9c5..b27e5f23dc93 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1292,7 +1292,7 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, uoff_t lend)
>  }
>  EXPORT_SYMBOL_GPL(shmem_truncate_range);
>  
> -static int shmem_getattr(struct mnt_idmap *idmap,
> +static int shmem_getattr(const struct mnt_idmap *idmap,
>  			 const struct path *path, struct kstat *stat,
>  			 u32 request_mask, unsigned int query_flags)
>  {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
