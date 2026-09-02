Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD449C4B8;
	Wed,  2 Sep 2026 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358511; cv=none; b=Z1PV/6YltHYNmpsqOwb0eE1oo2aoPryFU2e4F3PfCQJhlvr2p0x2KvUBgFanStBYlmlAZpllzMbn6GRQmIJl4yHiWLfwE6GPfW1Yu0NYPWoiHKDaUfLXDFSG99BzHF03aKu3EtoB7+T3leD8k7BXGD0lC1/OFlc6c2QuYvBMKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358511; c=relaxed/simple;
	bh=h9vkmUP5EGUBSLgig4/4D6vS7DsBEOgu4kGFiyDG8DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8AW3PcmejYRyFqNX0Nqt/aoUNSNTWSM4hMpYyzxedZykAcdKIHgBpX8ueWGXV6Ie1mGehJmArvr7jieT19NwYVZ/pua2uAwli4JIWJt3W5BznV+vgfKa/TOzSCGgnCoIWqEPmmkGfTzJ5scWmf96VawQACZxjhhXBvtL+kpbx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZFJpPptC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7GfKVNXF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u4+ObZDT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GDl3pLPQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZFJpPptC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7GfKVNXF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u4+ObZDT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GDl3pLPQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91E8521D04;
	Wed,  2 Sep 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WeD5rKAor0C3Yp71Uu2rUH9EwKLBs3JKF97nLFBeTbk=;
	b=ZFJpPptC0g7IJ7lmg1tWzecyub+ZmW9QTu1ej7vODLYlmhauo8bStVERHaHP19sTYyC6lU
	F8RLNYJfWDozzqzSRKX5wvFWOZY12RDwFxO//0s6gdeWcmDmH6iXS91pTU0OrxvnMMaCv5
	M3Y5/h+Ey+1xKKZCQyqYxXUa8d0pv6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WeD5rKAor0C3Yp71Uu2rUH9EwKLBs3JKF97nLFBeTbk=;
	b=7GfKVNXFwyOMTk5ngcMx2fZxDIdfok3aOFRdkmTfO11dCyBli4SePPXh4iwkr3Qq4LKcTk
	o01ct2JX0J4H4WDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u4+ObZDT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GDl3pLPQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WeD5rKAor0C3Yp71Uu2rUH9EwKLBs3JKF97nLFBeTbk=;
	b=u4+ObZDT5SVpBJ0vg/pTzgOT5ntKHvL5L9OY+Zaq9rJTBxnnQE5mL7fGhs79X+PVaICrif
	tDi7gudcHD5/j5fWXwiR0G24nhz6NTNH7zAisif6x0q71qoBdyk6CoG8ih1DLc8USDh70X
	98t/Y4SAqlorfZC3bdXaqy2EpOdn2UA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WeD5rKAor0C3Yp71Uu2rUH9EwKLBs3JKF97nLFBeTbk=;
	b=GDl3pLPQzilPpm72NlkgGFTFSRy0bZQyveb9AEOwHu+xy5mj19ODnfiTCz+TCJRKiJiGLq
	XQFJQRaTZOHhQtCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FC6313736;
	Wed,  2 Sep 2026 14:14:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TMhTG2IvmGrUBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:14:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1E6DDA13B5; Wed, 02 Sep 2026 16:14:54 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:14:54 +0200
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
Subject: Re: [PATCH 05/27] fs: port i_{g,u}id_into_vfs{g,u}id() to const
 mnt_idmap
Message-ID: <bjeeledz4ycna2xtjdhwgmfcfvqc3d22cg2s5pyra2greyienn@ehbyy5t46w44>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-5-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-5-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 91E8521D04
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 01-09-26 14:14:30, Christian Brauner wrote:
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
>  fs/exfat/file.c                       |  2 +-
>  fs/fat/file.c                         |  2 +-
>  fs/internal.h                         |  2 +-
>  fs/namei.c                            |  2 +-
>  fs/smb/server/ndr.c                   |  2 +-
>  fs/smb/server/ndr.h                   |  2 +-
>  fs/smb/server/smb2pdu.c               |  2 +-
>  fs/xattr.c                            |  2 +-
>  fs/xfs/xfs_itable.c                   |  2 +-
>  fs/xfs/xfs_itable.h                   |  2 +-
>  include/linux/fs.h                    |  6 +++---
>  security/integrity/ima/ima.h          | 10 +++++-----
>  security/integrity/ima/ima_api.c      |  2 +-
>  security/integrity/ima/ima_appraise.c |  2 +-
>  security/integrity/ima/ima_main.c     |  2 +-
>  security/integrity/ima/ima_policy.c   |  4 ++--
>  16 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index a2a9ee1a2004..0530803f71e8 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
> @@ -143,7 +143,7 @@ static long exfat_fallocate(struct file *file, int mode,
>  	return err;
>  }
>  
> -static bool exfat_allow_set_time(struct mnt_idmap *idmap,
> +static bool exfat_allow_set_time(const struct mnt_idmap *idmap,
>  				 struct exfat_sb_info *sbi, struct inode *inode)
>  {
>  	mode_t allow_utime = sbi->options.allow_utime;
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 1c835ca5f21a..0b8b493d06e4 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -493,7 +493,7 @@ static int fat_sanitize_mode(const struct msdos_sb_info *sbi,
>  	return 0;
>  }
>  
> -static int fat_allow_set_time(struct mnt_idmap *idmap,
> +static int fat_allow_set_time(const struct mnt_idmap *idmap,
>  			      struct msdos_sb_info *sbi, struct inode *inode)
>  {
>  	umode_t allow_utime = sbi->options.allow_utime;
> diff --git a/fs/internal.h b/fs/internal.h
> index 87ac96c3e29e..72244e5f4e57 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -299,7 +299,7 @@ int filename_setxattr(int dfd, struct filename *filename,
>  int setxattr_copy(const char __user *name, struct kernel_xattr_ctx *ctx);
>  int import_xattr_name(struct xattr_name *kname, const char __user *name);
>  
> -int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode);
> +int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode);
>  
>  #ifdef CONFIG_FS_POSIX_ACL
>  int do_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> diff --git a/fs/namei.c b/fs/namei.c
> index 20a6534ea3ef..603d43e4a961 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1407,7 +1407,7 @@ int may_linkat(struct mnt_idmap *idmap, const struct path *link)
>   *
>   * Returns 0 if the open is allowed, -ve on error.
>   */
> -static int may_create_in_sticky(struct mnt_idmap *idmap, struct nameidata *nd,
> +static int may_create_in_sticky(const struct mnt_idmap *idmap, struct nameidata *nd,
>  				struct inode *const inode)
>  {
>  	umode_t dir_mode = nd->dir_mode;
> diff --git a/fs/smb/server/ndr.c b/fs/smb/server/ndr.c
> index 58d71560f626..7e546c22e284 100644
> --- a/fs/smb/server/ndr.c
> +++ b/fs/smb/server/ndr.c
> @@ -338,7 +338,7 @@ static int ndr_encode_posix_acl_entry(struct ndr *n, struct xattr_smb_acl *acl)
>  }
>  
>  int ndr_encode_posix_acl(struct ndr *n,
> -			 struct mnt_idmap *idmap,
> +			 const struct mnt_idmap *idmap,
>  			 struct inode *inode,
>  			 struct xattr_smb_acl *acl,
>  			 struct xattr_smb_acl *def_acl)
> diff --git a/fs/smb/server/ndr.h b/fs/smb/server/ndr.h
> index f3c108c8cf4d..646568c42e4d 100644
> --- a/fs/smb/server/ndr.h
> +++ b/fs/smb/server/ndr.h
> @@ -14,7 +14,7 @@ struct ndr {
>  
>  int ndr_encode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da);
>  int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da);
> -int ndr_encode_posix_acl(struct ndr *n, struct mnt_idmap *idmap,
> +int ndr_encode_posix_acl(struct ndr *n, const struct mnt_idmap *idmap,
>  			 struct inode *inode, struct xattr_smb_acl *acl,
>  			 struct xattr_smb_acl *def_acl);
>  int ndr_encode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl);
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index a8046f477d54..0789200d602f 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3604,7 +3604,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
>  }
>  
>  static void ksmbd_acls_fattr(struct smb_fattr *fattr,
> -			     struct mnt_idmap *idmap,
> +			     const struct mnt_idmap *idmap,
>  			     struct inode *inode)
>  {
>  	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
> diff --git a/fs/xattr.c b/fs/xattr.c
> index d58979115200..c08f188748a9 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -100,7 +100,7 @@ xattr_resolve_name(struct inode *inode, const char **name)
>   *
>   * Return: On success zero is returned. On error a negative errno is returned.
>   */
> -int may_write_xattr(struct mnt_idmap *idmap, struct inode *inode)
> +int may_write_xattr(const struct mnt_idmap *idmap, struct inode *inode)
>  {
>  	if (IS_IMMUTABLE(inode))
>  		return -EPERM;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 159295c63e8f..a4cf1effa5e6 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -63,7 +63,7 @@ want_metadir_file(
>  STATIC int
>  xfs_bulkstat_one_int(
>  	struct xfs_mount	*mp,
> -	struct mnt_idmap	*idmap,
> +	const struct mnt_idmap	*idmap,
>  	struct xfs_trans	*tp,
>  	xfs_ino_t		ino,
>  	struct xfs_bstat_chunk	*bc)
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 2d0612f14d6e..c0567bfc30fb 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -8,7 +8,7 @@
>  /* In-memory representation of a userspace request for batch inode data. */
>  struct xfs_ibulk {
>  	struct xfs_mount	*mp;
> -	struct mnt_idmap	*idmap;
> +	const struct mnt_idmap	*idmap;
>  	void __user		*ubuffer; /* user output buffer */
>  	xfs_ino_t		startino; /* start with this inode */
>  	unsigned int		icount;   /* number of elements in ubuffer */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 959c747ef75a..cec5de83d882 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1439,7 +1439,7 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
>   * Return: whe inode's i_uid mapped down according to @idmap.
>   * If the inode's i_uid has no mapping INVALID_VFSUID is returned.
>   */
> -static inline vfsuid_t i_uid_into_vfsuid(struct mnt_idmap *idmap,
> +static inline vfsuid_t i_uid_into_vfsuid(const struct mnt_idmap *idmap,
>  					 const struct inode *inode)
>  {
>  	return make_vfsuid(idmap, i_user_ns(inode), inode->i_uid);
> @@ -1491,7 +1491,7 @@ static inline void i_uid_update(struct mnt_idmap *idmap,
>   * Return: the inode's i_gid mapped down according to @idmap.
>   * If the inode's i_gid has no mapping INVALID_VFSGID is returned.
>   */
> -static inline vfsgid_t i_gid_into_vfsgid(struct mnt_idmap *idmap,
> +static inline vfsgid_t i_gid_into_vfsgid(const struct mnt_idmap *idmap,
>  					 const struct inode *inode)
>  {
>  	return make_vfsgid(idmap, i_user_ns(inode), inode->i_gid);
> @@ -2173,7 +2173,7 @@ extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>  				 (inode)->i_rdev == WHITEOUT_DEV)
>  #define IS_ANON_FILE(inode)	((inode)->i_flags & S_ANON_INODE)
>  
> -static inline bool HAS_UNMAPPED_ID(struct mnt_idmap *idmap,
> +static inline bool HAS_UNMAPPED_ID(const struct mnt_idmap *idmap,
>  				   struct inode *inode)
>  {
>  	return !vfsuid_valid(i_uid_into_vfsuid(idmap, inode)) ||
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 10214f73ca1e..b502854f28ee 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -423,7 +423,7 @@ static inline void ima_process_queued_keys(void) {}
>  #endif /* CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS */
>  
>  /* LIM API function definitions */
> -int ima_get_action(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_get_action(const struct mnt_idmap *idmap, struct inode *inode,
>  		   const struct cred *cred, struct lsm_prop *prop, int mask,
>  		   enum ima_hooks func, int *pcr,
>  		   struct ima_template_desc **template_desc,
> @@ -437,7 +437,7 @@ void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
>  			   struct evm_ima_xattr_data *xattr_value,
>  			   int xattr_len, const struct modsig *modsig, int pcr,
>  			   struct ima_template_desc *template_desc);
> -int process_buffer_measurement(struct mnt_idmap *idmap,
> +int process_buffer_measurement(const struct mnt_idmap *idmap,
>  			       struct inode *inode, const void *buf, int size,
>  			       const char *eventname, enum ima_hooks func,
>  			       int pcr, const char *func_data,
> @@ -454,7 +454,7 @@ void ima_free_template_entry(struct ima_template_entry *entry);
>  const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
>  
>  /* IMA policy related functions */
> -int ima_match_policy(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_match_policy(const struct mnt_idmap *idmap, struct inode *inode,
>  		     const struct cred *cred, struct lsm_prop *prop,
>  		     enum ima_hooks func, int mask, int flags, int *pcr,
>  		     struct ima_template_desc **template_desc,
> @@ -489,7 +489,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
>  			     struct evm_ima_xattr_data *xattr_value,
>  			     int xattr_len, const struct modsig *modsig,
>  			     bool bprm_is_check);
> -int ima_must_appraise(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_must_appraise(const struct mnt_idmap *idmap, struct inode *inode,
>  		      int mask, enum ima_hooks func);
>  void ima_update_xattr(struct ima_iint_cache *iint, struct file *file);
>  enum integrity_status ima_get_cache_status(struct ima_iint_cache *iint,
> @@ -519,7 +519,7 @@ static inline int ima_appraise_measurement(enum ima_hooks func,
>  	return INTEGRITY_UNKNOWN;
>  }
>  
> -static inline int ima_must_appraise(struct mnt_idmap *idmap,
> +static inline int ima_must_appraise(const struct mnt_idmap *idmap,
>  				    struct inode *inode, int mask,
>  				    enum ima_hooks func)
>  {
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 122d127e108d..3c5a23b4a2ff 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -188,7 +188,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>   * Returns IMA_MEASURE, IMA_APPRAISE mask.
>   *
>   */
> -int ima_get_action(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_get_action(const struct mnt_idmap *idmap, struct inode *inode,
>  		   const struct cred *cred, struct lsm_prop *prop, int mask,
>  		   enum ima_hooks func, int *pcr,
>  		   struct ima_template_desc **template_desc,
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index ced2e131b061..6b21db789ef1 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -71,7 +71,7 @@ bool is_ima_appraise_enabled(void)
>   *
>   * Return 1 to appraise or hash
>   */
> -int ima_must_appraise(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_must_appraise(const struct mnt_idmap *idmap, struct inode *inode,
>  		      int mask, enum ima_hooks func)
>  {
>  	struct lsm_prop prop;
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index ab1e53b3210d..8d9c92dc8825 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -1095,7 +1095,7 @@ static int ima_post_load_data(char *buf, loff_t size,
>   * has been written to the passed location but not added to a measurement entry,
>   * a negative value otherwise.
>   */
> -int process_buffer_measurement(struct mnt_idmap *idmap,
> +int process_buffer_measurement(const struct mnt_idmap *idmap,
>  			       struct inode *inode, const void *buf, int size,
>  			       const char *eventname, enum ima_hooks func,
>  			       int pcr, const char *func_data,
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index f79d07bb63c6..89d197d99383 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -575,7 +575,7 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
>   * Returns true on rule match, false on failure.
>   */
>  static bool ima_match_rules(struct ima_rule_entry *rule,
> -			    struct mnt_idmap *idmap,
> +			    const struct mnt_idmap *idmap,
>  			    struct inode *inode, const struct cred *cred,
>  			    struct lsm_prop *prop, enum ima_hooks func, int mask,
>  			    const char *func_data)
> @@ -757,7 +757,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
>   * list when walking it.  Reads are many orders of magnitude more numerous
>   * than writes so ima_match_policy() is classical RCU candidate.
>   */
> -int ima_match_policy(struct mnt_idmap *idmap, struct inode *inode,
> +int ima_match_policy(const struct mnt_idmap *idmap, struct inode *inode,
>  		     const struct cred *cred, struct lsm_prop *prop,
>  		     enum ima_hooks func, int mask, int flags, int *pcr,
>  		     struct ima_template_desc **template_desc,
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
