Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B564747209E;
	Wed,  2 Sep 2026 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358442; cv=none; b=FyLfxA+c571tkEZmUkgnw7aoLUjMkEGuQiIUyAi/sM2Hn0Bz37gTcIO+apuzptk+1YjqpQoVmUxXR0mXmaZVLxy1n0LPAhGK0//omU1bPcpWwV3P889VHz95EnSuMg+rxf3R/KmKOjXW7+AapJEiyCxYRGeJVLcpkMsi1CAvhZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358442; c=relaxed/simple;
	bh=3uMwdpGV0rY+hVIYVjGSks7GFCbjTZm7gn+IrNdHCWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApT+9tNHh3/1phveavxyfNhOTr69urP7Wac15W12p5U8My7NQOUpoXaqOpWQUli0a6VQJWzYq0T6XVEZ2jFE9z9sAtQ5aIobopD3OBt0o87oJBYIrdRu7KtGLvdaSpdjeZAC0YTdJPP0YVRSVMdNLCGlLKKbHUbIiF20evyr5y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AeSeDjYq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nK82pSwW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Cmv5J66o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pWp87qb/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AeSeDjYq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nK82pSwW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Cmv5J66o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pWp87qb/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 56E2A21D58;
	Wed,  2 Sep 2026 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHgscWxwxwAgClcMz0xn8DnlfiNrTDZyuLzM+SNRD0=;
	b=AeSeDjYqTqBs5LA/YJuoF+FzPqVb8IwAVklveCG1DKIYM2g1uwrrwlUlzLLUE3XBxAh54I
	lueLTFfpcKI0jTqwOorKvQ7nwVPBWlAOPvsc6B1nkpZaCDuEjYbDiRIgJlDggPEup79wdG
	8V8NM/x7W4v+kR+v74dId24VBJ7ZzBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358434;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHgscWxwxwAgClcMz0xn8DnlfiNrTDZyuLzM+SNRD0=;
	b=nK82pSwWCvwx9jTWLtLgLXMxCjxw5ZA6jwP157477jNACPfB1NRFzMMJ5pFs3w1Ytbn0E6
	RhscYl6m7c9CWDDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cmv5J66o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="pWp87qb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHgscWxwxwAgClcMz0xn8DnlfiNrTDZyuLzM+SNRD0=;
	b=Cmv5J66owsdrZ/2IxiL1QLseXY4VBor264SwWQsaqmbOKQQgmwkOBdUIfkcvJSm0ewLRRW
	6DewxuyXAxwuMT6ZzBI3UDmK4OVrw8sxbddAqDeBz2Vp3zx9ROOXYap1SL0ZZ3eHVL61fz
	FGf2Ai29l6IWTUl7LBuMwBiL913iqWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHgscWxwxwAgClcMz0xn8DnlfiNrTDZyuLzM+SNRD0=;
	b=pWp87qb/2Xp5Wq64RZ0nnrHWetSuQMlnkBzCPM4T1uY9GjeuBKfqSqjYBwk/sywxYYnZVl
	M3Lb5YwtiylXceBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34D85136E6;
	Wed,  2 Sep 2026 14:13:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /ynlDB4vmGr5BgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:13:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0FC0A13B5; Wed, 02 Sep 2026 16:13:45 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:13:45 +0200
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
Subject: Re: [PATCH 04/27] fs: port fs{g,u}id helpers to const mnt_idmap
Message-ID: <lqvimz2nyu5kjngui76klhrnzsban6uz76fzfzwlhzll2xeaw4@b52qkg4q6jdt>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-4-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-4-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 56E2A21D58
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

On Tue 01-09-26 14:14:29, Christian Brauner wrote:
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
>  fs/ceph/mds_client.h          |  2 +-
>  fs/fuse/dir.c                 | 13 +++++++------
>  fs/fuse/fuse_i.h              |  4 ++--
>  fs/fuse/req.c                 |  8 +++++---
>  include/linux/fs.h            |  6 +++---
>  include/linux/mnt_idmapping.h |  4 ++--
>  6 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 3c62e3c3530b..1ac8a7e08e5c 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -375,7 +375,7 @@ struct ceph_mds_request {
>  	int r_fmode;        /* file mode, if expecting cap */
>  	int r_request_release_offset;
>  	const struct cred *r_cred;
> -	struct mnt_idmap *r_mnt_idmap;
> +	const struct mnt_idmap *r_mnt_idmap;
>  	struct timespec64 r_stamp;
>  
>  	/* for choosing which mds to send this request to */
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 0d297f74c663..7a204f55ca84 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -820,7 +820,7 @@ static void free_ext_value(struct fuse_args *args)
>   * If the filesystem doesn't support this, then fall back to separate
>   * 'mknod' + 'open' requests.
>   */
> -static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
> +static int fuse_create_open(const struct mnt_idmap *idmap, struct inode *dir,
>  			    struct dentry *entry, struct file *file,
>  			    unsigned int flags, umode_t mode, u32 opcode)
>  {
> @@ -980,7 +980,7 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
>  /*
>   * Code shared between mknod, mkdir, symlink and link
>   */
> -static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_mount *fm,
> +static struct dentry *create_new_entry(const struct mnt_idmap *idmap, struct fuse_mount *fm,
>  				       struct fuse_args *args, struct inode *dir,
>  				       struct dentry *entry, umode_t mode)
>  {
> @@ -1053,7 +1053,7 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
>  	return ERR_PTR(err);
>  }
>  
> -static int create_new_nondir(struct mnt_idmap *idmap, struct fuse_mount *fm,
> +static int create_new_nondir(const struct mnt_idmap *idmap, struct fuse_mount *fm,
>  			     struct fuse_args *args, struct inode *dir,
>  			     struct dentry *entry, umode_t mode)
>  {
> @@ -1256,9 +1256,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
>  	return err;
>  }
>  
> -static int fuse_rename_common(struct mnt_idmap *idmap, struct inode *olddir, struct dentry *oldent,
> -			      struct inode *newdir, struct dentry *newent,
> -			      unsigned int flags, int opcode, size_t argsize)
> +static int fuse_rename_common(const struct mnt_idmap *idmap, struct inode *olddir,
> +			      struct dentry *oldent, struct inode *newdir,
> +			      struct dentry *newent, unsigned int flags,
> +			      int opcode, size_t argsize)
>  {
>  	int err;
>  	struct fuse_rename2_in inarg;
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index c8d4c5f3af7e..a07c75377a30 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1003,7 +1003,7 @@ void __exit fuse_ctl_cleanup(void);
>  /*
>   * Simple request sending that does request allocation and freeing
>   */
> -ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
> +ssize_t __fuse_simple_request(const struct mnt_idmap *idmap,
>  			      struct fuse_mount *fm,
>  			      struct fuse_args *args);
>  
> @@ -1012,7 +1012,7 @@ static inline ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_arg
>  	return __fuse_simple_request(&invalid_mnt_idmap, fm, args);
>  }
>  
> -static inline ssize_t fuse_simple_idmap_request(struct mnt_idmap *idmap,
> +static inline ssize_t fuse_simple_idmap_request(const struct mnt_idmap *idmap,
>  						struct fuse_mount *fm,
>  						struct fuse_args *args)
>  {
> diff --git a/fs/fuse/req.c b/fs/fuse/req.c
> index a01ee743d31e..a133b012d041 100644
> --- a/fs/fuse/req.c
> +++ b/fs/fuse/req.c
> @@ -3,7 +3,8 @@
>  #include "dev.h"
>  #include "fuse_i.h"
>  
> -static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct mnt_idmap *idmap)
> +static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args,
> +			   const struct mnt_idmap *idmap)
>  {
>  	struct fuse_conn *fc = fm->fc;
>  	bool no_idmap = !fm->sb || (fm->sb->s_iflags & SB_I_NOIDMAP);
> @@ -49,7 +50,8 @@ static int fuse_fill_creds(struct fuse_mount *fm, struct fuse_args *args, struct
>  	return 0;
>  }
>  
> -static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args, struct mnt_idmap *idmap)
> +static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args,
> +			 const struct mnt_idmap *idmap)
>  {
>  	if (!args->force && fm->fc->conn_error)
>  		return -ECONNREFUSED;
> @@ -57,7 +59,7 @@ static int fuse_req_prep(struct fuse_mount *fm, struct fuse_args *args, struct m
>  	return fuse_fill_creds(fm, args, idmap);
>  }
>  
> -ssize_t __fuse_simple_request(struct mnt_idmap *idmap, struct fuse_mount *fm,
> +ssize_t __fuse_simple_request(const struct mnt_idmap *idmap, struct fuse_mount *fm,
>  			      struct fuse_args *args)
>  {
>  	struct fuse_conn *fc = fm->fc;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f9d1e05e8ae6..959c747ef75a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1544,7 +1544,7 @@ static inline void i_gid_update(struct mnt_idmap *idmap,
>   * an idmapped mount map the caller's fsuid according to @idmap.
>   */
>  static inline void inode_fsuid_set(struct inode *inode,
> -				   struct mnt_idmap *idmap)
> +				   const struct mnt_idmap *idmap)
>  {
>  	inode->i_uid = mapped_fsuid(idmap, i_user_ns(inode));
>  }
> @@ -1558,7 +1558,7 @@ static inline void inode_fsuid_set(struct inode *inode,
>   * an idmapped mount map the caller's fsgid according to @idmap.
>   */
>  static inline void inode_fsgid_set(struct inode *inode,
> -				   struct mnt_idmap *idmap)
> +				   const struct mnt_idmap *idmap)
>  {
>  	inode->i_gid = mapped_fsgid(idmap, i_user_ns(inode));
>  }
> @@ -1575,7 +1575,7 @@ static inline void inode_fsgid_set(struct inode *inode,
>   * Return: true if fsuid and fsgid is mapped, false if not.
>   */
>  static inline bool fsuidgid_has_mapping(struct super_block *sb,
> -					struct mnt_idmap *idmap)
> +					const struct mnt_idmap *idmap)
>  {
>  	struct user_namespace *fs_userns = sb->s_user_ns;
>  	kuid_t kuid;
> diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
> index b16f52d27ba0..6656aea23be2 100644
> --- a/include/linux/mnt_idmapping.h
> +++ b/include/linux/mnt_idmapping.h
> @@ -225,7 +225,7 @@ static inline kgid_t vfsgid_into_kgid(vfsgid_t vfsgid)
>   *
>   * Return: the caller's current fsuid mapped up according to @idmap.
>   */
> -static inline kuid_t mapped_fsuid(struct mnt_idmap *idmap,
> +static inline kuid_t mapped_fsuid(const struct mnt_idmap *idmap,
>  				  struct user_namespace *fs_userns)
>  {
>  	return from_vfsuid(idmap, fs_userns, VFSUIDT_INIT(current_fsuid()));
> @@ -244,7 +244,7 @@ static inline kuid_t mapped_fsuid(struct mnt_idmap *idmap,
>   *
>   * Return: the caller's current fsgid mapped up according to @idmap.
>   */
> -static inline kgid_t mapped_fsgid(struct mnt_idmap *idmap,
> +static inline kgid_t mapped_fsgid(const struct mnt_idmap *idmap,
>  				  struct user_namespace *fs_userns)
>  {
>  	return from_vfsgid(idmap, fs_userns, VFSGIDT_INIT(current_fsgid()));
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
