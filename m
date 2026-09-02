Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59C53DE423;
	Wed,  2 Sep 2026 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363740; cv=none; b=ZTgEPbeeWv7oBNw96uHIe86WIORvxSVTMp0AaY3ekkJa6nC1CgKqmlJz3u5GDQ+cOem7702CAapp+hI+h0sOT8JbXZBBMxqSTtrvddmo7z4yIo1jCOC5L+/thesEyUKvhp3RVVkLu76sSJby6P6TLS+lMIcdkQZx9yTUctgjBak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363740; c=relaxed/simple;
	bh=Hodie3YgcYi35MIhQvFjdx9UkHjhzhRnlJemh/PMFsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjYhgnSaojfcwhYWm9zeARVsBzRUBW6u3ag584FlTMZqIUoqq+FP0WBDNUOmMhaO5Kh8+1aCn8w2j8JsFc3ELKkIdaN1gbafjxy2eSshAj/ivBndmLCypd58TyseV1XjX5rXIYyGlWEQiICjOpVr4tis747h25Xat9754OZF3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uuY2+Xwf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ICUQ5vMo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WFWAGL7w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hdVtzzRm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uuY2+Xwf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ICUQ5vMo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WFWAGL7w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hdVtzzRm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9360B1F7B8;
	Wed,  2 Sep 2026 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzW/uXeCNk78c5ya/Zv36jfMczo04g5onHeuljK6Fo8=;
	b=uuY2+XwfOODz1NMBM4joYq4BPYT2ogiYY8me6wXtkqqYQrZB6FcKYPI/+407qOwTJ+FV50
	Rhn7KIRDOT9wOFefE+SfzfslAJSWF3GsLQFPpOfs0Z/a928pElW/Hv96Yys0mPxg2UlNxF
	ztVMa906CPi/t0JQJpbdhtY8ypVFVuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363729;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzW/uXeCNk78c5ya/Zv36jfMczo04g5onHeuljK6Fo8=;
	b=ICUQ5vMo0vSL4J/0Bs0OodbIQld3ylWf9IKnjPlX6ZF9HXxvJPdH9796y74FdxLRbZSfvD
	pQo3XFuSMXpFRzAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WFWAGL7w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hdVtzzRm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788363725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzW/uXeCNk78c5ya/Zv36jfMczo04g5onHeuljK6Fo8=;
	b=WFWAGL7wH1pHu3+AQ3k53O52XBxuonT3xPT/WaUHfG8wOPRP/tx3iZuI2ZCVEQAn/THtdr
	ijzkXfMx5oKT/ZUSv9hCudzVikQmKQs2u5QX5lx9pHyDvUnS7iUWhdu7h6lGyDKZnk9wZS
	ncmYVBZeHlEPql9eFcsxhY6cRDPVX+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788363725;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzW/uXeCNk78c5ya/Zv36jfMczo04g5onHeuljK6Fo8=;
	b=hdVtzzRmxBr7AFUPUAlrhP4DAGFyg9QPSP9YaTwPzrxj//29wVINq2jflmJ2lLTnMHLD38
	+Fw+vnoHkiCTxyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A4BF13515;
	Wed,  2 Sep 2026 15:42:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hSfrGc1DmGo0YQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:42:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 03E76A13B5; Wed, 02 Sep 2026 17:42:04 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:42:04 +0200
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
Subject: Re: [PATCH 13/27] fs: port xattr to const mnt_idmap
Message-ID: <2cgu44nogbfljyqwd25nvvz6pzby2fxjiwtus6avem7yqei4fs@buo5qxzocxvn>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-13-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-13-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9360B1F7B8
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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

On Tue 01-09-26 14:14:38, Christian Brauner wrote:
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
>  fs/9p/xattr.c                         |  2 +-
>  fs/afs/xattr.c                        |  4 ++--
>  fs/attr.c                             |  2 +-
>  fs/btrfs/xattr.c                      |  6 +++---
>  fs/ceph/xattr.c                       |  2 +-
>  fs/ecryptfs/inode.c                   |  2 +-
>  fs/ext2/xattr_security.c              |  2 +-
>  fs/ext2/xattr_trusted.c               |  2 +-
>  fs/ext2/xattr_user.c                  |  2 +-
>  fs/ext4/xattr_hurd.c                  |  2 +-
>  fs/ext4/xattr_security.c              |  2 +-
>  fs/ext4/xattr_trusted.c               |  2 +-
>  fs/ext4/xattr_user.c                  |  2 +-
>  fs/f2fs/xattr.c                       |  4 ++--
>  fs/fuse/dir.c                         |  2 +-
>  fs/fuse/fuse_i.h                      |  2 +-
>  fs/fuse/xattr.c                       |  2 +-
>  fs/gfs2/xattr.c                       |  2 +-
>  fs/hfs/attr.c                         |  2 +-
>  fs/hfsplus/xattr.c                    |  2 +-
>  fs/hfsplus/xattr_security.c           |  2 +-
>  fs/hfsplus/xattr_trusted.c            |  2 +-
>  fs/hfsplus/xattr_user.c               |  2 +-
>  fs/jffs2/security.c                   |  2 +-
>  fs/jffs2/xattr_trusted.c              |  2 +-
>  fs/jffs2/xattr_user.c                 |  2 +-
>  fs/jfs/xattr.c                        |  4 ++--
>  fs/kernfs/inode.c                     |  4 ++--
>  fs/nfs/nfs4proc.c                     | 10 +++++-----
>  fs/ntfs/ea.c                          |  2 +-
>  fs/ntfs3/xattr.c                      |  2 +-
>  fs/ocfs2/xattr.c                      |  6 +++---
>  fs/orangefs/xattr.c                   |  2 +-
>  fs/overlayfs/xattrs.c                 |  4 ++--
>  fs/pidfs.c                            |  2 +-
>  fs/smb/client/xattr.c                 |  2 +-
>  fs/smb/server/vfs.c                   | 24 ++++++++++++------------
>  fs/smb/server/vfs.h                   | 20 ++++++++++----------
>  fs/ubifs/xattr.c                      |  2 +-
>  fs/xattr.c                            | 22 +++++++++++-----------
>  fs/xfs/xfs_iops.c                     |  2 +-
>  fs/xfs/xfs_xattr.c                    |  2 +-
>  include/linux/capability.h            |  4 ++--
>  include/linux/fs.h                    |  2 +-
>  include/linux/lsm_hook_defs.h         |  8 ++++----
>  include/linux/security.h              | 20 ++++++++++----------
>  include/linux/xattr.h                 | 20 ++++++++++----------
>  kernel/bpf/inode.c                    |  2 +-
>  mm/shmem.c                            |  2 +-
>  net/socket.c                          |  4 ++--
>  security/commoncap.c                  |  8 ++++----
>  security/integrity/evm/evm_main.c     |  4 ++--
>  security/integrity/ima/ima_appraise.c |  4 ++--
>  security/security.c                   |  8 ++++----
>  security/selinux/hooks.c              |  6 +++---
>  security/smack/smack_lsm.c            |  6 +++---
>  57 files changed, 135 insertions(+), 135 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 5af7d3bfcd5e..2a91bc9c15f5 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -148,7 +148,7 @@ prototypes::
>  		   struct inode *inode, const char *name, void *buffer,
>  		   size_t size);
>  	int (*set)(const struct xattr_handler *handler,
> -                   struct mnt_idmap *idmap,
> +                   const struct mnt_idmap *idmap,
>                     struct dentry *dentry, struct inode *inode, const char *name,
>                     const void *buffer, size_t size, int flags);
>  
> diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
> index 8604e3377ee7..dac06587f67a 100644
> --- a/fs/9p/xattr.c
> +++ b/fs/9p/xattr.c
> @@ -153,7 +153,7 @@ static int v9fs_xattr_handler_get(const struct xattr_handler *handler,
>  }
>  
>  static int v9fs_xattr_handler_set(const struct xattr_handler *handler,
> -				  struct mnt_idmap *idmap,
> +				  const struct mnt_idmap *idmap,
>  				  struct dentry *dentry, struct inode *inode,
>  				  const char *name, const void *value,
>  				  size_t size, int flags)
> diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
> index 3770ed236f67..bcffd7236cc9 100644
> --- a/fs/afs/xattr.c
> +++ b/fs/afs/xattr.c
> @@ -97,7 +97,7 @@ static const struct afs_operation_ops afs_store_acl_operation = {
>   * Set a file's AFS3 ACL.
>   */
>  static int afs_xattr_set_acl(const struct xattr_handler *handler,
> -			     struct mnt_idmap *idmap,
> +			     const struct mnt_idmap *idmap,
>                               struct dentry *dentry,
>                               struct inode *inode, const char *name,
>                               const void *buffer, size_t size, int flags)
> @@ -228,7 +228,7 @@ static const struct afs_operation_ops yfs_store_opaque_acl2_operation = {
>   * Set a file's YFS ACL.
>   */
>  static int afs_xattr_set_yfs(const struct xattr_handler *handler,
> -			     struct mnt_idmap *idmap,
> +			     const struct mnt_idmap *idmap,
>                               struct dentry *dentry,
>                               struct inode *inode, const char *name,
>                               const void *buffer, size_t size, int flags)
> diff --git a/fs/attr.c b/fs/attr.c
> index c5033afe04bf..1845d145fe4c 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -158,7 +158,7 @@ static bool chgrp_ok(const struct mnt_idmap *idmap,
>   * Should be called as the first thing in ->setattr implementations,
>   * possibly after taking additional locks.
>   */
> -int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
> +int setattr_prepare(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		    struct iattr *attr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index ab55d10bd71f..a06420b9c662 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -353,7 +353,7 @@ static int btrfs_xattr_handler_get(const struct xattr_handler *handler,
>  }
>  
>  static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct dentry *unused, struct inode *inode,
>  				   const char *name, const void *buffer,
>  				   size_t size, int flags)
> @@ -395,7 +395,7 @@ static int btrfs_xattr_handler_get_security(const struct xattr_handler *handler,
>  }
>  
>  static int btrfs_xattr_handler_set_security(const struct xattr_handler *handler,
> -					    struct mnt_idmap *idmap,
> +					    const struct mnt_idmap *idmap,
>  					    struct dentry *unused,
>  					    struct inode *inode,
>  					    const char *name,
> @@ -413,7 +413,7 @@ static int btrfs_xattr_handler_set_security(const struct xattr_handler *handler,
>  }
>  
>  static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
> -					struct mnt_idmap *idmap,
> +					const struct mnt_idmap *idmap,
>  					struct dentry *unused, struct inode *inode,
>  					const char *name, const void *value,
>  					size_t size, int flags)
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index cc4ffbbcb719..7d77214c76c6 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1352,7 +1352,7 @@ static int ceph_get_xattr_handler(const struct xattr_handler *handler,
>  }
>  
>  static int ceph_set_xattr_handler(const struct xattr_handler *handler,
> -				  struct mnt_idmap *idmap,
> +				  const struct mnt_idmap *idmap,
>  				  struct dentry *unused, struct inode *inode,
>  				  const char *name, const void *value,
>  				  size_t size, int flags)
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 6dafca14ca78..691b3a24b60a 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -1158,7 +1158,7 @@ static int ecryptfs_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int ecryptfs_xattr_set(const struct xattr_handler *handler,
> -			      struct mnt_idmap *idmap,
> +			      const struct mnt_idmap *idmap,
>  			      struct dentry *dentry, struct inode *inode,
>  			      const char *name, const void *value, size_t size,
>  			      int flags)
> diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
> index db47b8ab153e..ade074354258 100644
> --- a/fs/ext2/xattr_security.c
> +++ b/fs/ext2/xattr_security.c
> @@ -19,7 +19,7 @@ ext2_xattr_security_get(const struct xattr_handler *handler,
>  
>  static int
>  ext2_xattr_security_set(const struct xattr_handler *handler,
> -			struct mnt_idmap *idmap,
> +			const struct mnt_idmap *idmap,
>  			struct dentry *unused, struct inode *inode,
>  			const char *name, const void *value,
>  			size_t size, int flags)
> diff --git a/fs/ext2/xattr_trusted.c b/fs/ext2/xattr_trusted.c
> index 995f931228ce..0f12d634d6d0 100644
> --- a/fs/ext2/xattr_trusted.c
> +++ b/fs/ext2/xattr_trusted.c
> @@ -26,7 +26,7 @@ ext2_xattr_trusted_get(const struct xattr_handler *handler,
>  
>  static int
>  ext2_xattr_trusted_set(const struct xattr_handler *handler,
> -		       struct mnt_idmap *idmap,
> +		       const struct mnt_idmap *idmap,
>  		       struct dentry *unused, struct inode *inode,
>  		       const char *name, const void *value,
>  		       size_t size, int flags)
> diff --git a/fs/ext2/xattr_user.c b/fs/ext2/xattr_user.c
> index dd1507231081..48002c033e9c 100644
> --- a/fs/ext2/xattr_user.c
> +++ b/fs/ext2/xattr_user.c
> @@ -30,7 +30,7 @@ ext2_xattr_user_get(const struct xattr_handler *handler,
>  
>  static int
>  ext2_xattr_user_set(const struct xattr_handler *handler,
> -		    struct mnt_idmap *idmap,
> +		    const struct mnt_idmap *idmap,
>  		    struct dentry *unused, struct inode *inode,
>  		    const char *name, const void *value,
>  		    size_t size, int flags)
> diff --git a/fs/ext4/xattr_hurd.c b/fs/ext4/xattr_hurd.c
> index 8a5842e4cd95..a3ecbff72b10 100644
> --- a/fs/ext4/xattr_hurd.c
> +++ b/fs/ext4/xattr_hurd.c
> @@ -32,7 +32,7 @@ ext4_xattr_hurd_get(const struct xattr_handler *handler,
>  
>  static int
>  ext4_xattr_hurd_set(const struct xattr_handler *handler,
> -		    struct mnt_idmap *idmap,
> +		    const struct mnt_idmap *idmap,
>  		    struct dentry *unused, struct inode *inode,
>  		    const char *name, const void *value,
>  		    size_t size, int flags)
> diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
> index 776cf11d24ca..af5b8a93fed1 100644
> --- a/fs/ext4/xattr_security.c
> +++ b/fs/ext4/xattr_security.c
> @@ -23,7 +23,7 @@ ext4_xattr_security_get(const struct xattr_handler *handler,
>  
>  static int
>  ext4_xattr_security_set(const struct xattr_handler *handler,
> -			struct mnt_idmap *idmap,
> +			const struct mnt_idmap *idmap,
>  			struct dentry *unused, struct inode *inode,
>  			const char *name, const void *value,
>  			size_t size, int flags)
> diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
> index 9811eb0ab276..458e1982ef83 100644
> --- a/fs/ext4/xattr_trusted.c
> +++ b/fs/ext4/xattr_trusted.c
> @@ -30,7 +30,7 @@ ext4_xattr_trusted_get(const struct xattr_handler *handler,
>  
>  static int
>  ext4_xattr_trusted_set(const struct xattr_handler *handler,
> -		       struct mnt_idmap *idmap,
> +		       const struct mnt_idmap *idmap,
>  		       struct dentry *unused, struct inode *inode,
>  		       const char *name, const void *value,
>  		       size_t size, int flags)
> diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
> index 4b70bf4e7626..ad35215f6610 100644
> --- a/fs/ext4/xattr_user.c
> +++ b/fs/ext4/xattr_user.c
> @@ -31,7 +31,7 @@ ext4_xattr_user_get(const struct xattr_handler *handler,
>  
>  static int
>  ext4_xattr_user_set(const struct xattr_handler *handler,
> -		    struct mnt_idmap *idmap,
> +		    const struct mnt_idmap *idmap,
>  		    struct dentry *unused, struct inode *inode,
>  		    const char *name, const void *value,
>  		    size_t size, int flags)
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 6728d1488cad..ffe4815ffa6d 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -67,7 +67,7 @@ static int f2fs_xattr_generic_get(const struct xattr_handler *handler,
>  }
>  
>  static int f2fs_xattr_generic_set(const struct xattr_handler *handler,
> -		struct mnt_idmap *idmap,
> +		const struct mnt_idmap *idmap,
>  		struct dentry *unused, struct inode *inode,
>  		const char *name, const void *value,
>  		size_t size, int flags)
> @@ -111,7 +111,7 @@ static int f2fs_xattr_advise_get(const struct xattr_handler *handler,
>  }
>  
>  static int f2fs_xattr_advise_set(const struct xattr_handler *handler,
> -		struct mnt_idmap *idmap,
> +		const struct mnt_idmap *idmap,
>  		struct dentry *unused, struct inode *inode,
>  		const char *name, const void *value,
>  		size_t size, int flags)
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 4b87973c727d..0dbe3c6560f8 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2143,7 +2143,7 @@ int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
>   * vmtruncate() doesn't allow for this case, so do the rlimit checking
>   * and the actual truncation by hand.
>   */
> -int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int fuse_do_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		    struct iattr *attr, struct file *file)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index a07c75377a30..9ea346ea2e01 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1189,7 +1189,7 @@ bool fuse_write_update_attr(struct inode *inode, loff_t pos, ssize_t written);
>  int fuse_flush_times(struct inode *inode, struct fuse_file *ff);
>  int fuse_write_inode(struct inode *inode, struct writeback_control *wbc);
>  
> -int fuse_do_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +int fuse_do_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		    struct iattr *attr, struct file *file);
>  
>  void fuse_unlock_inode(struct inode *inode, bool locked);
> diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
> index cab2685acc65..53e3c5e6fff0 100644
> --- a/fs/fuse/xattr.c
> +++ b/fs/fuse/xattr.c
> @@ -188,7 +188,7 @@ static int fuse_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int fuse_xattr_set(const struct xattr_handler *handler,
> -			  struct mnt_idmap *idmap,
> +			  const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct inode *inode,
>  			  const char *name, const void *value, size_t size,
>  			  int flags)
> diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
> index b9f48d6f10a9..0e66e4849b57 100644
> --- a/fs/gfs2/xattr.c
> +++ b/fs/gfs2/xattr.c
> @@ -1229,7 +1229,7 @@ int __gfs2_xattr_set(struct inode *inode, const char *name,
>  }
>  
>  static int gfs2_xattr_set(const struct xattr_handler *handler,
> -			  struct mnt_idmap *idmap,
> +			  const struct mnt_idmap *idmap,
>  			  struct dentry *unused, struct inode *inode,
>  			  const char *name, const void *value,
>  			  size_t size, int flags)
> diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
> index f8395cdd1adf..6d737a085461 100644
> --- a/fs/hfs/attr.c
> +++ b/fs/hfs/attr.c
> @@ -121,7 +121,7 @@ static int hfs_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int hfs_xattr_set(const struct xattr_handler *handler,
> -			 struct mnt_idmap *idmap,
> +			 const struct mnt_idmap *idmap,
>  			 struct dentry *unused, struct inode *inode,
>  			 const char *name, const void *value, size_t size,
>  			 int flags)
> diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
> index 21a1c196c71f..71364e093fa7 100644
> --- a/fs/hfsplus/xattr.c
> +++ b/fs/hfsplus/xattr.c
> @@ -1008,7 +1008,7 @@ static int hfsplus_osx_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int hfsplus_osx_setxattr(const struct xattr_handler *handler,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct dentry *unused, struct inode *inode,
>  				const char *name, const void *buffer,
>  				size_t size, int flags)
> diff --git a/fs/hfsplus/xattr_security.c b/fs/hfsplus/xattr_security.c
> index 90f68ec119cd..1969919c12cb 100644
> --- a/fs/hfsplus/xattr_security.c
> +++ b/fs/hfsplus/xattr_security.c
> @@ -23,7 +23,7 @@ static int hfsplus_security_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int hfsplus_security_setxattr(const struct xattr_handler *handler,
> -				     struct mnt_idmap *idmap,
> +				     const struct mnt_idmap *idmap,
>  				     struct dentry *unused, struct inode *inode,
>  				     const char *name, const void *buffer,
>  				     size_t size, int flags)
> diff --git a/fs/hfsplus/xattr_trusted.c b/fs/hfsplus/xattr_trusted.c
> index fdbaebc1c49a..c140a95ab3f0 100644
> --- a/fs/hfsplus/xattr_trusted.c
> +++ b/fs/hfsplus/xattr_trusted.c
> @@ -22,7 +22,7 @@ static int hfsplus_trusted_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int hfsplus_trusted_setxattr(const struct xattr_handler *handler,
> -				    struct mnt_idmap *idmap,
> +				    const struct mnt_idmap *idmap,
>  				    struct dentry *unused, struct inode *inode,
>  				    const char *name, const void *buffer,
>  				    size_t size, int flags)
> diff --git a/fs/hfsplus/xattr_user.c b/fs/hfsplus/xattr_user.c
> index 6464b6c3d58d..7e5da15f9937 100644
> --- a/fs/hfsplus/xattr_user.c
> +++ b/fs/hfsplus/xattr_user.c
> @@ -22,7 +22,7 @@ static int hfsplus_user_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int hfsplus_user_setxattr(const struct xattr_handler *handler,
> -				 struct mnt_idmap *idmap,
> +				 const struct mnt_idmap *idmap,
>  				 struct dentry *unused, struct inode *inode,
>  				 const char *name, const void *buffer,
>  				 size_t size, int flags)
> diff --git a/fs/jffs2/security.c b/fs/jffs2/security.c
> index 437f3a2c1b54..67330aeb8ae8 100644
> --- a/fs/jffs2/security.c
> +++ b/fs/jffs2/security.c
> @@ -57,7 +57,7 @@ static int jffs2_security_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int jffs2_security_setxattr(const struct xattr_handler *handler,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct dentry *unused, struct inode *inode,
>  				   const char *name, const void *buffer,
>  				   size_t size, int flags)
> diff --git a/fs/jffs2/xattr_trusted.c b/fs/jffs2/xattr_trusted.c
> index b7c5da2d89bd..85133ad8b449 100644
> --- a/fs/jffs2/xattr_trusted.c
> +++ b/fs/jffs2/xattr_trusted.c
> @@ -25,7 +25,7 @@ static int jffs2_trusted_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int jffs2_trusted_setxattr(const struct xattr_handler *handler,
> -				  struct mnt_idmap *idmap,
> +				  const struct mnt_idmap *idmap,
>  				  struct dentry *unused, struct inode *inode,
>  				  const char *name, const void *buffer,
>  				  size_t size, int flags)
> diff --git a/fs/jffs2/xattr_user.c b/fs/jffs2/xattr_user.c
> index f64edce4927b..dcfd3caf1d8b 100644
> --- a/fs/jffs2/xattr_user.c
> +++ b/fs/jffs2/xattr_user.c
> @@ -25,7 +25,7 @@ static int jffs2_user_getxattr(const struct xattr_handler *handler,
>  }
>  
>  static int jffs2_user_setxattr(const struct xattr_handler *handler,
> -			       struct mnt_idmap *idmap,
> +			       const struct mnt_idmap *idmap,
>  			       struct dentry *unused, struct inode *inode,
>  			       const char *name, const void *buffer,
>  			       size_t size, int flags)
> diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
> index 11d7f74d207b..dcc4a69d44fe 100644
> --- a/fs/jfs/xattr.c
> +++ b/fs/jfs/xattr.c
> @@ -956,7 +956,7 @@ static int jfs_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int jfs_xattr_set(const struct xattr_handler *handler,
> -			 struct mnt_idmap *idmap,
> +			 const struct mnt_idmap *idmap,
>  			 struct dentry *unused, struct inode *inode,
>  			 const char *name, const void *value,
>  			 size_t size, int flags)
> @@ -975,7 +975,7 @@ static int jfs_xattr_get_os2(const struct xattr_handler *handler,
>  }
>  
>  static int jfs_xattr_set_os2(const struct xattr_handler *handler,
> -			     struct mnt_idmap *idmap,
> +			     const struct mnt_idmap *idmap,
>  			     struct dentry *unused, struct inode *inode,
>  			     const char *name, const void *value,
>  			     size_t size, int flags)
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index d53d104e54d5..b348d4cd150b 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -344,7 +344,7 @@ static int kernfs_vfs_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int kernfs_vfs_xattr_set(const struct xattr_handler *handler,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct dentry *unused, struct inode *inode,
>  				const char *suffix, const void *value,
>  				size_t size, int flags)
> @@ -356,7 +356,7 @@ static int kernfs_vfs_xattr_set(const struct xattr_handler *handler,
>  }
>  
>  static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
> -				     struct mnt_idmap *idmap,
> +				     const struct mnt_idmap *idmap,
>  				     struct dentry *unused, struct inode *inode,
>  				     const char *suffix, const void *value,
>  				     size_t size, int flags)
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 04b1987115d5..21e5df7e5251 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -7866,7 +7866,7 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
>  #define XATTR_NAME_NFSV4_ACL "system.nfs4_acl"
>  
>  static int nfs4_xattr_set_nfs4_acl(const struct xattr_handler *handler,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct dentry *unused, struct inode *inode,
>  				   const char *key, const void *buf,
>  				   size_t buflen, int flags)
> @@ -7889,7 +7889,7 @@ static bool nfs4_xattr_list_nfs4_acl(struct dentry *dentry)
>  #define XATTR_NAME_NFSV4_DACL "system.nfs4_dacl"
>  
>  static int nfs4_xattr_set_nfs4_dacl(const struct xattr_handler *handler,
> -				    struct mnt_idmap *idmap,
> +				    const struct mnt_idmap *idmap,
>  				    struct dentry *unused, struct inode *inode,
>  				    const char *key, const void *buf,
>  				    size_t buflen, int flags)
> @@ -7912,7 +7912,7 @@ static bool nfs4_xattr_list_nfs4_dacl(struct dentry *dentry)
>  #define XATTR_NAME_NFSV4_SACL "system.nfs4_sacl"
>  
>  static int nfs4_xattr_set_nfs4_sacl(const struct xattr_handler *handler,
> -				    struct mnt_idmap *idmap,
> +				    const struct mnt_idmap *idmap,
>  				    struct dentry *unused, struct inode *inode,
>  				    const char *key, const void *buf,
>  				    size_t buflen, int flags)
> @@ -7935,7 +7935,7 @@ static bool nfs4_xattr_list_nfs4_sacl(struct dentry *dentry)
>  #ifdef CONFIG_NFS_V4_SECURITY_LABEL
>  
>  static int nfs4_xattr_set_nfs4_label(const struct xattr_handler *handler,
> -				     struct mnt_idmap *idmap,
> +				     const struct mnt_idmap *idmap,
>  				     struct dentry *unused, struct inode *inode,
>  				     const char *key, const void *buf,
>  				     size_t buflen, int flags)
> @@ -7965,7 +7965,7 @@ static const struct xattr_handler nfs4_xattr_nfs4_label_handler = {
>  
>  #ifdef CONFIG_NFS_V4_2
>  static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
> -				    struct mnt_idmap *idmap,
> +				    const struct mnt_idmap *idmap,
>  				    struct dentry *unused, struct inode *inode,
>  				    const char *key, const void *buf,
>  				    size_t buflen, int flags)
> diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
> index 744ea8c446e5..7fd323912510 100644
> --- a/fs/ntfs/ea.c
> +++ b/fs/ntfs/ea.c
> @@ -852,7 +852,7 @@ static int ntfs_validate_fattr(struct ntfs_inode *ni, __le32 fattr)
>  }
>  
>  static int ntfs_setxattr(const struct xattr_handler *handler,
> -		struct mnt_idmap *idmap, struct dentry *unused,
> +		const struct mnt_idmap *idmap, struct dentry *unused,
>  		struct inode *inode, const char *name, const void *value,
>  		size_t size, int flags)
>  {
> diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
> index d800735477c3..5644167de863 100644
> --- a/fs/ntfs3/xattr.c
> +++ b/fs/ntfs3/xattr.c
> @@ -863,7 +863,7 @@ static bool ntfs_is_reserved_lxattr(const char *name)
>   * ntfs_setxattr - inode_operations::setxattr
>   */
>  static noinline int ntfs_setxattr(const struct xattr_handler *handler,
> -				  struct mnt_idmap *idmap, struct dentry *de,
> +				  const struct mnt_idmap *idmap, struct dentry *de,
>  				  struct inode *inode, const char *name,
>  				  const void *value, size_t size, int flags)
>  {
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..da8e19e21a91 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7503,7 +7503,7 @@ static int ocfs2_xattr_security_get(const struct xattr_handler *handler,
>  }
>  
>  static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
> -				    struct mnt_idmap *idmap,
> +				    const struct mnt_idmap *idmap,
>  				    struct dentry *unused, struct inode *inode,
>  				    const char *name, const void *value,
>  				    size_t size, int flags)
> @@ -7598,7 +7598,7 @@ static int ocfs2_xattr_trusted_get(const struct xattr_handler *handler,
>  }
>  
>  static int ocfs2_xattr_trusted_set(const struct xattr_handler *handler,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct dentry *unused, struct inode *inode,
>  				   const char *name, const void *value,
>  				   size_t size, int flags)
> @@ -7629,7 +7629,7 @@ static int ocfs2_xattr_user_get(const struct xattr_handler *handler,
>  }
>  
>  static int ocfs2_xattr_user_set(const struct xattr_handler *handler,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct dentry *unused, struct inode *inode,
>  				const char *name, const void *value,
>  				size_t size, int flags)
> diff --git a/fs/orangefs/xattr.c b/fs/orangefs/xattr.c
> index 885fd3bd5a3d..a49e64566e1e 100644
> --- a/fs/orangefs/xattr.c
> +++ b/fs/orangefs/xattr.c
> @@ -527,7 +527,7 @@ ssize_t orangefs_listxattr(struct dentry *dentry, char *buffer, size_t size)
>  }
>  
>  static int orangefs_xattr_set_default(const struct xattr_handler *handler,
> -				      struct mnt_idmap *idmap,
> +				      const struct mnt_idmap *idmap,
>  				      struct dentry *unused,
>  				      struct inode *inode,
>  				      const char *name,
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index 5ae44b9c8790..acc54f6138ef 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -190,7 +190,7 @@ static int ovl_own_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int ovl_own_xattr_set(const struct xattr_handler *handler,
> -			     struct mnt_idmap *idmap,
> +			     const struct mnt_idmap *idmap,
>  			     struct dentry *dentry, struct inode *inode,
>  			     const char *name, const void *value,
>  			     size_t size, int flags)
> @@ -217,7 +217,7 @@ static int ovl_other_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int ovl_other_xattr_set(const struct xattr_handler *handler,
> -			       struct mnt_idmap *idmap,
> +			       const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, struct inode *inode,
>  			       const char *name, const void *value,
>  			       size_t size, int flags)
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index a6a643f15d08..5bc136de8660 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -1102,7 +1102,7 @@ static int pidfs_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int pidfs_xattr_set(const struct xattr_handler *handler,
> -			   struct mnt_idmap *idmap, struct dentry *unused,
> +			   const struct mnt_idmap *idmap, struct dentry *unused,
>  			   struct inode *inode, const char *suffix,
>  			   const void *value, size_t size, int flags)
>  {
> diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
> index 5091f6c0d7fe..f6c9343016f7 100644
> --- a/fs/smb/client/xattr.c
> +++ b/fs/smb/client/xattr.c
> @@ -91,7 +91,7 @@ static int cifs_creation_time_set(unsigned int xid, struct cifs_tcon *pTcon,
>  }
>  
>  static int cifs_xattr_set(const struct xattr_handler *handler,
> -			  struct mnt_idmap *idmap,
> +			  const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, struct inode *inode,
>  			  const char *name, const void *value,
>  			  size_t size, int flags)
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 0361de56edc2..3c4d18a4e8d5 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -216,7 +216,7 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
>  	return err;
>  }
>  
> -static ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
> +static ssize_t ksmbd_vfs_getcasexattr(const struct mnt_idmap *idmap,
>  				      struct dentry *dentry, char *attr_name,
>  				      int attr_name_len, char **attr_value)
>  {
> @@ -841,7 +841,7 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
>  	return size;
>  }
>  
> -static ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
> +static ssize_t ksmbd_vfs_xattr_len(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, char *xattr_name)
>  {
>  	return vfs_getxattr(idmap, dentry, xattr_name, NULL, 0);
> @@ -856,7 +856,7 @@ static ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
>   *
>   * Return:	read xattr value length on success, otherwise error
>   */
> -ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
> +ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry,
>  			   char *xattr_name, char **xattr_buf)
>  {
> @@ -893,7 +893,7 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
>   *
>   * Return:	0 on success, otherwise error
>   */
> -int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, const char *attr_name,
>  		       void *attr_value, size_t attr_size, int flags,
>  		       bool get_write)
> @@ -1177,7 +1177,7 @@ int ksmbd_vfs_query_allocated_ranges(struct ksmbd_file *fp, loff_t start,
>  	return ret;
>  }
>  
> -int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
>  			   const struct path *path, char *attr_name,
>  			   bool get_write)
>  {
> @@ -1511,7 +1511,7 @@ int ksmbd_vfs_remove_acl_xattrs(struct mnt_idmap *idmap,
>  	return err;
>  }
>  
> -int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap, const struct path *path)
> +int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path *path)
>  {
>  	char *name, *xattr_list = NULL;
>  	ssize_t xattr_list_len;
> @@ -1606,7 +1606,7 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(const struct mnt_idm
>  }
>  
>  int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
> -			   struct mnt_idmap *idmap,
> +			   const struct mnt_idmap *idmap,
>  			   const struct path *path,
>  			   struct smb_ntsd *pntsd, int len,
>  			   bool get_write)
> @@ -1673,7 +1673,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
>  }
>  
>  int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
> -			   struct mnt_idmap *idmap,
> +			   const struct mnt_idmap *idmap,
>  			   struct dentry *dentry,
>  			   struct smb_ntsd **pntsd)
>  {
> @@ -1742,7 +1742,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
>  	return rc;
>  }
>  
> -int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
>  				   const struct path *path,
>  				   struct xattr_dos_attrib *da,
>  				   bool get_write)
> @@ -1764,7 +1764,7 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
>  	return err;
>  }
>  
> -int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_get_dos_attrib_xattr(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry,
>  				   struct xattr_dos_attrib *da)
>  {
> @@ -1820,7 +1820,7 @@ void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat)
>  }
>  
>  int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct dentry *dentry,
>  				struct ksmbd_kstat *ksmbd_kstat)
>  {
> @@ -1895,7 +1895,7 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
>  	return 0;
>  }
>  
> -ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
> +ssize_t ksmbd_vfs_casexattr_len(const struct mnt_idmap *idmap,
>  				struct dentry *dentry, char *attr_name,
>  				int attr_name_len)
>  {
> diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
> index 9c8b5b288926..5e34fc61b48b 100644
> --- a/fs/smb/server/vfs.h
> +++ b/fs/smb/server/vfs.h
> @@ -104,20 +104,20 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
>  			       unsigned int *chunk_size_written,
>  			       loff_t  *total_size_written);
>  ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list);
> -ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
> +ssize_t ksmbd_vfs_getxattr(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry,
>  			   char *xattr_name,
>  			   char **xattr_buf);
> -ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
> +ssize_t ksmbd_vfs_casexattr_len(const struct mnt_idmap *idmap,
>  				struct dentry *dentry, char *attr_name,
>  				int attr_name_len);
> -int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_setxattr(const struct mnt_idmap *idmap,
>  		       const struct path *path, const char *attr_name,
>  		       void *attr_value, size_t attr_size, int flags,
>  		       bool get_write);
>  int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
>  				size_t *xattr_stream_name_size, int s_type);
> -int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_remove_xattr(const struct mnt_idmap *idmap,
>  			   const struct path *path, char *attr_name,
>  			   bool get_write);
>  int ksmbd_vfs_kern_path(struct ksmbd_work *work, char *name,
> @@ -147,28 +147,28 @@ int ksmbd_vfs_query_allocated_ranges(struct ksmbd_file *fp, loff_t start,
>  int ksmbd_vfs_unlink(struct file *filp);
>  void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat);
>  int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct dentry *dentry,
>  				struct ksmbd_kstat *ksmbd_kstat);
>  void ksmbd_vfs_posix_lock_wait(struct file_lock *flock);
>  void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock);
>  int ksmbd_vfs_remove_acl_xattrs(struct mnt_idmap *idmap,
>  				const struct path *path);
> -int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap, const struct path *path);
> +int ksmbd_vfs_remove_sd_xattrs(const struct mnt_idmap *idmap, const struct path *path);
>  int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
> -			   struct mnt_idmap *idmap,
> +			   const struct mnt_idmap *idmap,
>  			   const struct path *path,
>  			   struct smb_ntsd *pntsd, int len,
>  			   bool get_write);
>  int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
> -			   struct mnt_idmap *idmap,
> +			   const struct mnt_idmap *idmap,
>  			   struct dentry *dentry,
>  			   struct smb_ntsd **pntsd);
> -int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_set_dos_attrib_xattr(const struct mnt_idmap *idmap,
>  				   const struct path *path,
>  				   struct xattr_dos_attrib *da,
>  				   bool get_write);
> -int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
> +int ksmbd_vfs_get_dos_attrib_xattr(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry,
>  				   struct xattr_dos_attrib *da);
>  int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index b5a9ab9d8a10..3b0e8a270f59 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -660,7 +660,7 @@ static int xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int xattr_set(const struct xattr_handler *handler,
> -			   struct mnt_idmap *idmap,
> +			   const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct inode *inode,
>  			   const char *name, const void *value,
>  			   size_t size, int flags)
> diff --git a/fs/xattr.c b/fs/xattr.c
> index c08f188748a9..acdaafb0c7c1 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -123,7 +123,7 @@ static inline int xattr_permission_error(int mask)
>   * because different namespaces have very different rules.
>   */
>  static int
> -xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
> +xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  		 const char *name, int mask)
>  {
>  	if (mask & MAY_WRITE) {
> @@ -204,7 +204,7 @@ xattr_supports_user_prefix(struct inode *inode)
>  EXPORT_SYMBOL(xattr_supports_user_prefix);
>  
>  int
> -__vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +__vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	       struct inode *inode, const char *name, const void *value,
>  	       size_t size, int flags)
>  {
> @@ -242,7 +242,7 @@ EXPORT_SYMBOL(__vfs_setxattr);
>   *  is executed. It also assumes that the caller will make the appropriate
>   *  permission checks.
>   */
> -int __vfs_setxattr_noperm(struct mnt_idmap *idmap,
> +int __vfs_setxattr_noperm(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, const char *name,
>  			  const void *value, size_t size, int flags)
>  {
> @@ -295,7 +295,7 @@ int __vfs_setxattr_noperm(struct mnt_idmap *idmap,
>   *  a delegation was broken on, NULL if none.
>   */
>  int
> -__vfs_setxattr_locked(struct mnt_idmap *idmap, struct dentry *dentry,
> +__vfs_setxattr_locked(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      const char *name, const void *value, size_t size,
>  		      int flags, struct delegated_inode *delegated_inode)
>  {
> @@ -324,7 +324,7 @@ __vfs_setxattr_locked(struct mnt_idmap *idmap, struct dentry *dentry,
>  EXPORT_SYMBOL_GPL(__vfs_setxattr_locked);
>  
>  int
> -vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	     const char *name, const void *value, size_t size, int flags)
>  {
>  	struct inode *inode = dentry->d_inode;
> @@ -358,7 +358,7 @@ vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  EXPORT_SYMBOL_GPL(vfs_setxattr);
>  
>  static ssize_t
> -xattr_getsecurity(struct mnt_idmap *idmap, struct inode *inode,
> +xattr_getsecurity(const struct mnt_idmap *idmap, struct inode *inode,
>  		  const char *name, void *value, size_t size)
>  {
>  	void *buffer = NULL;
> @@ -395,7 +395,7 @@ xattr_getsecurity(struct mnt_idmap *idmap, struct inode *inode,
>   * Returns the result of alloc, if failed, or the getxattr operation.
>   */
>  int
> -vfs_getxattr_alloc(struct mnt_idmap *idmap, struct dentry *dentry,
> +vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   const char *name, char **xattr_value, size_t xattr_size,
>  		   gfp_t flags)
>  {
> @@ -448,7 +448,7 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
>  EXPORT_SYMBOL(__vfs_getxattr);
>  
>  ssize_t
> -vfs_getxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +vfs_getxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	     const char *name, void *value, size_t size)
>  {
>  	struct inode *inode = dentry->d_inode;
> @@ -527,7 +527,7 @@ vfs_listxattr(struct dentry *dentry, char *list, size_t size)
>  EXPORT_SYMBOL_GPL(vfs_listxattr);
>  
>  int
> -__vfs_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +__vfs_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		  const char *name)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -557,7 +557,7 @@ EXPORT_SYMBOL(__vfs_removexattr);
>   *  a delegation was broken on, NULL if none.
>   */
>  int
> -__vfs_removexattr_locked(struct mnt_idmap *idmap,
> +__vfs_removexattr_locked(const struct mnt_idmap *idmap,
>  			 struct dentry *dentry, const char *name,
>  			 struct delegated_inode *delegated_inode)
>  {
> @@ -589,7 +589,7 @@ __vfs_removexattr_locked(struct mnt_idmap *idmap,
>  EXPORT_SYMBOL_GPL(__vfs_removexattr_locked);
>  
>  int
> -vfs_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +vfs_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		const char *name)
>  {
>  	struct inode *inode = dentry->d_inode;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index df5e7c1b2334..b652f129c85e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -754,7 +754,7 @@ xfs_vn_getattr(
>  
>  static int
>  xfs_vn_change_ok(
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct dentry		*dentry,
>  	struct iattr		*iattr)
>  {
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 1efe6c8139b2..b059a9714d11 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -169,7 +169,7 @@ xfs_xattr_flags_to_op(
>  
>  static int
>  xfs_xattr_set(const struct xattr_handler *handler,
> -	      struct mnt_idmap *idmap, struct dentry *unused,
> +	      const struct mnt_idmap *idmap, struct dentry *unused,
>  	      struct inode *inode, const char *name, const void *value,
>  	      size_t size, int flags)
>  {
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index c39a2bbefc47..8ab509c4e1ef 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -210,11 +210,11 @@ static inline bool checkpoint_restore_ns_capable_noaudit(struct user_namespace *
>  }
>  
>  /* audit system wants to get cap info from files as well */
> -int get_vfs_caps_from_disk(struct mnt_idmap *idmap,
> +int get_vfs_caps_from_disk(const struct mnt_idmap *idmap,
>  			   const struct dentry *dentry,
>  			   struct cpu_vfs_cap_data *cpu_caps);
>  
> -int cap_convert_nscap(struct mnt_idmap *idmap, struct dentry *dentry,
> +int cap_convert_nscap(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      const void **ivalue, size_t size);
>  
>  #endif /* !_LINUX_CAPABILITY_H */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f815594dd8cb..08166900931a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3399,7 +3399,7 @@ static inline bool generic_ci_validate_strict_name(struct inode *dir,
>  
>  int may_setattr(const struct mnt_idmap *idmap, struct inode *inode,
>  		unsigned int ia_valid);
> -int setattr_prepare(struct mnt_idmap *, struct dentry *, struct iattr *);
> +int setattr_prepare(const struct mnt_idmap *, struct dentry *, struct iattr *);
>  extern int inode_newsize_ok(const struct inode *, loff_t offset);
>  void setattr_copy(const struct mnt_idmap *, struct inode *inode,
>  		  const struct iattr *attr);
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 30897590258f..e8638f7d2245 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -146,14 +146,14 @@ LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, struct mnt_idmap *idmap,
>  	 struct dentry *dentry, int ia_valid)
>  LSM_HOOK(int, 0, inode_getattr, const struct path *path)
>  LSM_HOOK(int, 0, inode_xattr_skipcap, const char *name)
> -LSM_HOOK(int, 0, inode_setxattr, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_setxattr, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *name, const void *value,
>  	 size_t size, int flags)
>  LSM_HOOK(void, LSM_RET_VOID, inode_post_setxattr, struct dentry *dentry,
>  	 const char *name, const void *value, size_t size, int flags)
>  LSM_HOOK(int, 0, inode_getxattr, struct dentry *dentry, const char *name)
>  LSM_HOOK(int, 0, inode_listxattr, struct dentry *dentry)
> -LSM_HOOK(int, 0, inode_removexattr, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_removexattr, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *name)
>  LSM_HOOK(void, LSM_RET_VOID, inode_post_removexattr, struct dentry *dentry,
>  	 const char *name)
> @@ -170,9 +170,9 @@ LSM_HOOK(int, 0, inode_remove_acl, const struct mnt_idmap *idmap,
>  LSM_HOOK(void, LSM_RET_VOID, inode_post_remove_acl, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry, const char *acl_name)
>  LSM_HOOK(int, 0, inode_need_killpriv, struct dentry *dentry)
> -LSM_HOOK(int, 0, inode_killpriv, struct mnt_idmap *idmap,
> +LSM_HOOK(int, 0, inode_killpriv, const struct mnt_idmap *idmap,
>  	 struct dentry *dentry)
> -LSM_HOOK(int, -EOPNOTSUPP, inode_getsecurity, struct mnt_idmap *idmap,
> +LSM_HOOK(int, -EOPNOTSUPP, inode_getsecurity, const struct mnt_idmap *idmap,
>  	 struct inode *inode, const char *name, void **buffer, bool alloc)
>  LSM_HOOK(int, -EOPNOTSUPP, inode_setsecurity, struct inode *inode,
>  	 const char *name, const void *value, size_t size, int flags)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 12bc12e243bf..d5832750418a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -188,8 +188,8 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  int cap_inode_removexattr(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, const char *name);
>  int cap_inode_need_killpriv(struct dentry *dentry);
> -int cap_inode_killpriv(struct mnt_idmap *idmap, struct dentry *dentry);
> -int cap_inode_getsecurity(struct mnt_idmap *idmap,
> +int cap_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry);
> +int cap_inode_getsecurity(const struct mnt_idmap *idmap,
>  			  struct inode *inode, const char *name, void **buffer,
>  			  bool alloc);
>  extern int cap_mmap_addr(unsigned long addr);
> @@ -427,7 +427,7 @@ int security_inode_setattr(struct mnt_idmap *idmap,
>  void security_inode_post_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  				 int ia_valid);
>  int security_inode_getattr(const struct path *path);
> -int security_inode_setxattr(struct mnt_idmap *idmap,
> +int security_inode_setxattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, const char *name,
>  			    const void *value, size_t size, int flags);
>  int security_inode_set_acl(const struct mnt_idmap *idmap,
> @@ -446,7 +446,7 @@ void security_inode_post_setxattr(struct dentry *dentry, const char *name,
>  				  const void *value, size_t size, int flags);
>  int security_inode_getxattr(struct dentry *dentry, const char *name);
>  int security_inode_listxattr(struct dentry *dentry);
> -int security_inode_removexattr(struct mnt_idmap *idmap,
> +int security_inode_removexattr(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, const char *name);
>  void security_inode_post_removexattr(struct dentry *dentry, const char *name);
>  int security_inode_file_setattr(struct dentry *dentry,
> @@ -454,8 +454,8 @@ int security_inode_file_setattr(struct dentry *dentry,
>  int security_inode_file_getattr(struct dentry *dentry,
>  			      struct file_kattr *fa);
>  int security_inode_need_killpriv(struct dentry *dentry);
> -int security_inode_killpriv(struct mnt_idmap *idmap, struct dentry *dentry);
> -int security_inode_getsecurity(struct mnt_idmap *idmap,
> +int security_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry);
> +int security_inode_getsecurity(const struct mnt_idmap *idmap,
>  			       struct inode *inode, const char *name,
>  			       void **buffer, bool alloc);
>  int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
> @@ -996,7 +996,7 @@ static inline int security_inode_getattr(const struct path *path)
>  	return 0;
>  }
>  
> -static inline int security_inode_setxattr(struct mnt_idmap *idmap,
> +static inline int security_inode_setxattr(const struct mnt_idmap *idmap,
>  		struct dentry *dentry, const char *name, const void *value,
>  		size_t size, int flags)
>  {
> @@ -1050,7 +1050,7 @@ static inline int security_inode_listxattr(struct dentry *dentry)
>  	return 0;
>  }
>  
> -static inline int security_inode_removexattr(struct mnt_idmap *idmap,
> +static inline int security_inode_removexattr(const struct mnt_idmap *idmap,
>  					     struct dentry *dentry,
>  					     const char *name)
>  {
> @@ -1078,13 +1078,13 @@ static inline int security_inode_need_killpriv(struct dentry *dentry)
>  	return cap_inode_need_killpriv(dentry);
>  }
>  
> -static inline int security_inode_killpriv(struct mnt_idmap *idmap,
> +static inline int security_inode_killpriv(const struct mnt_idmap *idmap,
>  					  struct dentry *dentry)
>  {
>  	return cap_inode_killpriv(idmap, dentry);
>  }
>  
> -static inline int security_inode_getsecurity(struct mnt_idmap *idmap,
> +static inline int security_inode_getsecurity(const struct mnt_idmap *idmap,
>  					     struct inode *inode,
>  					     const char *name, void **buffer,
>  					     bool alloc)
> diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> index 54ac3cbc133f..4cc4257de084 100644
> --- a/include/linux/xattr.h
> +++ b/include/linux/xattr.h
> @@ -47,7 +47,7 @@ struct xattr_handler {
>  		   struct inode *inode, const char *name, void *buffer,
>  		   size_t size);
>  	int (*set)(const struct xattr_handler *,
> -		   struct mnt_idmap *idmap, struct dentry *dentry,
> +		   const struct mnt_idmap *idmap, struct dentry *dentry,
>  		   struct inode *inode, const char *name, const void *buffer,
>  		   size_t size, int flags);
>  };
> @@ -77,25 +77,25 @@ struct xattr {
>  };
>  
>  ssize_t __vfs_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
> -ssize_t vfs_getxattr(struct mnt_idmap *, struct dentry *, const char *,
> +ssize_t vfs_getxattr(const struct mnt_idmap *, struct dentry *, const char *,
>  		     void *, size_t);
>  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> -int __vfs_setxattr(struct mnt_idmap *, struct dentry *, struct inode *,
> +int __vfs_setxattr(const struct mnt_idmap *, struct dentry *, struct inode *,
>  		   const char *, const void *, size_t, int);
> -int __vfs_setxattr_noperm(struct mnt_idmap *, struct dentry *,
> +int __vfs_setxattr_noperm(const struct mnt_idmap *, struct dentry *,
>  			  const char *, const void *, size_t, int);
> -int __vfs_setxattr_locked(struct mnt_idmap *, struct dentry *,
> +int __vfs_setxattr_locked(const struct mnt_idmap *, struct dentry *,
>  			  const char *, const void *, size_t, int,
>  			  struct delegated_inode *);
> -int vfs_setxattr(struct mnt_idmap *, struct dentry *, const char *,
> +int vfs_setxattr(const struct mnt_idmap *, struct dentry *, const char *,
>  		 const void *, size_t, int);
> -int __vfs_removexattr(struct mnt_idmap *, struct dentry *, const char *);
> -int __vfs_removexattr_locked(struct mnt_idmap *, struct dentry *,
> +int __vfs_removexattr(const struct mnt_idmap *, struct dentry *, const char *);
> +int __vfs_removexattr_locked(const struct mnt_idmap *, struct dentry *,
>  			     const char *, struct delegated_inode *);
> -int vfs_removexattr(struct mnt_idmap *, struct dentry *, const char *);
> +int vfs_removexattr(const struct mnt_idmap *, struct dentry *, const char *);
>  
>  ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
> -int vfs_getxattr_alloc(struct mnt_idmap *idmap,
> +int vfs_getxattr_alloc(const struct mnt_idmap *idmap,
>  		       struct dentry *dentry, const char *name,
>  		       char **xattr_value, size_t size, gfp_t flags);
>  
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 7837968c0842..11174037a9ca 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -874,7 +874,7 @@ enum {
>  };
>  
>  static int bpf_fs_xattr_set(const struct xattr_handler *handler,
> -			    struct mnt_idmap *idmap, struct dentry *unused,
> +			    const struct mnt_idmap *idmap, struct dentry *unused,
>  			    struct inode *inode, const char *name,
>  			    const void *value, size_t size, int flags)
>  {
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9ab5231c4dfe..ed633b3bc38d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4264,7 +4264,7 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
>  }
>  
>  static int shmem_xattr_handler_set(const struct xattr_handler *handler,
> -				   struct mnt_idmap *idmap,
> +				   const struct mnt_idmap *idmap,
>  				   struct dentry *unused, struct inode *inode,
>  				   const char *name, const void *value,
>  				   size_t size, int flags)
> diff --git a/net/socket.c b/net/socket.c
> index c05d86e63abf..052273ad081a 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -422,7 +422,7 @@ static const struct xattr_handler sockfs_xattr_handler = {
>  };
>  
>  static int sockfs_security_xattr_set(const struct xattr_handler *handler,
> -				     struct mnt_idmap *idmap,
> +				     const struct mnt_idmap *idmap,
>  				     struct dentry *dentry, struct inode *inode,
>  				     const char *suffix, const void *value,
>  				     size_t size, int flags)
> @@ -447,7 +447,7 @@ static int sockfs_user_xattr_get(const struct xattr_handler *handler,
>  }
>  
>  static int sockfs_user_xattr_set(const struct xattr_handler *handler,
> -				 struct mnt_idmap *idmap,
> +				 const struct mnt_idmap *idmap,
>  				 struct dentry *dentry, struct inode *inode,
>  				 const char *suffix, const void *value,
>  				 size_t size, int flags)
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 9361393fd756..d47ab3022343 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -348,7 +348,7 @@ int cap_inode_need_killpriv(struct dentry *dentry)
>   *
>   * Return: 0 if successful, -ve on error.
>   */
> -int cap_inode_killpriv(struct mnt_idmap *idmap, struct dentry *dentry)
> +int cap_inode_killpriv(const struct mnt_idmap *idmap, struct dentry *dentry)
>  {
>  	int error;
>  
> @@ -417,7 +417,7 @@ static bool is_v3header(int size, const struct vfs_cap_data *cap)
>   * by the integrity subsystem, which really wants the unconverted values -
>   * so that's good.
>   */
> -int cap_inode_getsecurity(struct mnt_idmap *idmap,
> +int cap_inode_getsecurity(const struct mnt_idmap *idmap,
>  			  struct inode *inode, const char *name, void **buffer,
>  			  bool alloc)
>  {
> @@ -566,7 +566,7 @@ static bool validheader(size_t size, const struct vfs_cap_data *cap)
>   *
>   * Return: On success, return the new size; on error, return < 0.
>   */
> -int cap_convert_nscap(struct mnt_idmap *idmap, struct dentry *dentry,
> +int cap_convert_nscap(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		      const void **ivalue, size_t size)
>  {
>  	struct vfs_ns_cap_data *nscap;
> @@ -672,7 +672,7 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
>   * permissions. On non-idmapped mounts or if permission checking is to be
>   * performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -int get_vfs_caps_from_disk(struct mnt_idmap *idmap,
> +int get_vfs_caps_from_disk(const struct mnt_idmap *idmap,
>  			   const struct dentry *dentry,
>  			   struct cpu_vfs_cap_data *cpu_caps)
>  {
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index aaf228ebed7c..94928549bfab 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -607,7 +607,7 @@ static int evm_protect_xattr(const struct mnt_idmap *idmap,
>   * userspace from writing HMAC value.  Writing 'security.evm' requires
>   * requires CAP_SYS_ADMIN privileges.
>   */
> -static int evm_inode_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int evm_inode_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			      const char *xattr_name, const void *xattr_value,
>  			      size_t xattr_value_len, int flags)
>  {
> @@ -639,7 +639,7 @@ static int evm_inode_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
>   * Removing 'security.evm' requires CAP_SYS_ADMIN privileges and that
>   * the current value is valid.
>   */
> -static int evm_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int evm_inode_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				 const char *xattr_name)
>  {
>  	/* Policy permits modification of the protected xattrs even though
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 1aed041c127a..cfc20c63a814 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -757,7 +757,7 @@ static int validate_hash_algo(struct dentry *dentry,
>  	return -EACCES;
>  }
>  
> -static int ima_inode_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int ima_inode_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  			      const char *xattr_name, const void *xattr_value,
>  			      size_t xattr_value_len, int flags)
>  {
> @@ -799,7 +799,7 @@ static int ima_inode_set_acl(const struct mnt_idmap *idmap, struct dentry *dentr
>  	return 0;
>  }
>  
> -static int ima_inode_removexattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +static int ima_inode_removexattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  				 const char *xattr_name)
>  {
>  	int result, digsig = -1;
> diff --git a/security/security.c b/security/security.c
> index e81dcda3050b..e3a14c958bc4 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1921,7 +1921,7 @@ int security_inode_getattr(const struct path *path)
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_setxattr(struct mnt_idmap *idmap,
> +int security_inode_setxattr(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry, const char *name,
>  			    const void *value, size_t size, int flags)
>  {
> @@ -2108,7 +2108,7 @@ int security_inode_listxattr(struct dentry *dentry)
>   *
>   * Return: Returns 0 if permission is granted.
>   */
> -int security_inode_removexattr(struct mnt_idmap *idmap,
> +int security_inode_removexattr(const struct mnt_idmap *idmap,
>  			       struct dentry *dentry, const char *name)
>  {
>  	int rc;
> @@ -2197,7 +2197,7 @@ int security_inode_need_killpriv(struct dentry *dentry)
>   * Return: Return 0 on success.  If error is returned, then the operation
>   *         causing setuid bit removal is failed.
>   */
> -int security_inode_killpriv(struct mnt_idmap *idmap,
> +int security_inode_killpriv(const struct mnt_idmap *idmap,
>  			    struct dentry *dentry)
>  {
>  	return call_int_hook(inode_killpriv, idmap, dentry);
> @@ -2219,7 +2219,7 @@ int security_inode_killpriv(struct mnt_idmap *idmap,
>   *
>   * Return: Returns size of buffer on success.
>   */
> -int security_inode_getsecurity(struct mnt_idmap *idmap,
> +int security_inode_getsecurity(const struct mnt_idmap *idmap,
>  			       struct inode *inode, const char *name,
>  			       void **buffer, bool alloc)
>  {
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 672d6374d8b0..b7c6eba08fdc 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3367,7 +3367,7 @@ static int selinux_inode_xattr_skipcap(const char *name)
>  	return !strcmp(name, XATTR_NAME_SELINUX);
>  }
>  
> -static int selinux_inode_setxattr(struct mnt_idmap *idmap,
> +static int selinux_inode_setxattr(const struct mnt_idmap *idmap,
>  				  struct dentry *dentry, const char *name,
>  				  const void *value, size_t size, int flags)
>  {
> @@ -3526,7 +3526,7 @@ static int selinux_inode_listxattr(struct dentry *dentry)
>  	return dentry_has_perm(cred, dentry, FILE__GETATTR);
>  }
>  
> -static int selinux_inode_removexattr(struct mnt_idmap *idmap,
> +static int selinux_inode_removexattr(const struct mnt_idmap *idmap,
>  				     struct dentry *dentry, const char *name)
>  {
>  	/* if not a selinux xattr, only check the ordinary setattr perm */
> @@ -3606,7 +3606,7 @@ static int selinux_path_notify(const struct path *path, u64 mask,
>   *
>   * Permission check is handled by selinux_inode_getxattr hook.
>   */
> -static int selinux_inode_getsecurity(struct mnt_idmap *idmap,
> +static int selinux_inode_getsecurity(const struct mnt_idmap *idmap,
>  				     struct inode *inode, const char *name,
>  				     void **buffer, bool alloc)
>  {
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 244cdb49e928..df4fc6ff26aa 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1348,7 +1348,7 @@ static int smack_inode_xattr_skipcap(const char *name)
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_setxattr(struct mnt_idmap *idmap,
> +static int smack_inode_setxattr(const struct mnt_idmap *idmap,
>  				struct dentry *dentry, const char *name,
>  				const void *value, size_t size, int flags)
>  {
> @@ -1482,7 +1482,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
>   *
>   * Returns 0 if access is permitted, an error code otherwise
>   */
> -static int smack_inode_removexattr(struct mnt_idmap *idmap,
> +static int smack_inode_removexattr(const struct mnt_idmap *idmap,
>  				   struct dentry *dentry, const char *name)
>  {
>  	struct inode_smack *isp;
> @@ -1612,7 +1612,7 @@ static int smack_inode_remove_acl(const struct mnt_idmap *idmap,
>   *
>   * Returns the size of the attribute or an error code
>   */
> -static int smack_inode_getsecurity(struct mnt_idmap *idmap,
> +static int smack_inode_getsecurity(const struct mnt_idmap *idmap,
>  				   struct inode *inode, const char *name,
>  				   void **buffer, bool alloc)
>  {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
