Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D33359A99;
	Wed,  2 Sep 2026 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358648; cv=none; b=AX97d92ySEL2VPiC0zGl/nOzlCT7q7fvcpONY+bb8pvIA4M/59gutEqCiFlKohzsiePSgtZqWMDWPBRqIlyuKbaszzfjAvRlTHnpqdLv3gHg0kd8UuJWR+cdGuXjFYTbXlqyxeudU9iYQ3HrvcBK1Tc+6pXyf0pqkqxkxy2kxiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358648; c=relaxed/simple;
	bh=FwPVBjM6WDtr4igzSsFDhNcXUCB70q4BO8C4Rz5MH0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kijDktGjYUlrL1Lnm9ZBgy2xCTe5ccGCcbVhYdVHE7A+vIqDBe2kr46HQN+qUK4IwSJXE5iGxEVfLE0ntzLaN0/3Kgo0QWMGPXmRNvlt2JBT3vYwzR58GIOycRQFCB1Pd/yaJywfML3JgvfKkBTa6FYR1tsYj9OkA97xMytvbvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L3wFQr/b; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1/ij3B4c; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NZnqSHuZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bJGOY14I; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L3wFQr/b";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1/ij3B4c";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NZnqSHuZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bJGOY14I"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F82921D3F;
	Wed,  2 Sep 2026 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4RQwWuyLKt+grbW0xzASr3HAd7YWAOvVZAb7y/By+M=;
	b=L3wFQr/bXr26CAMIfuqfeP189/TLFsQIdNXXJW/hieMKMZT2HqQ8ANy8ckp3/2GpcCdIuH
	sdJdEb7WYar1uRkJQfUdM8dK96OXDaVmAvhOsBGEbhG+MatB7gkdVKiOHa/wa1FJPQPxXy
	ECWtbLKyUOE1HaV0w//UqNkF4uzzf/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4RQwWuyLKt+grbW0xzASr3HAd7YWAOvVZAb7y/By+M=;
	b=1/ij3B4cxBjZb0X9Gowa/Ps9VYZtS5dpa08RwVCTfrYsPhmqOqqXk1LUdk+zAknlMsX6qW
	qsWi7EJ1Q5DJTeDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NZnqSHuZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bJGOY14I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4RQwWuyLKt+grbW0xzASr3HAd7YWAOvVZAb7y/By+M=;
	b=NZnqSHuZFUZUrgf/+N1vBEl+Nr1mSXYfvsuXPiBKLXULuFKCVDSiD0uEqAHowgjfCjoBGy
	8zqdCVJmWPy4sngdOKdlEfUbFbkJuZb/bQMSCIqnn3WDU5Up+Lcj2Lu0cveccJqmksj5mm
	docMP/i+1nKGknqf/ynsF/GrPaZZ1JM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4RQwWuyLKt+grbW0xzASr3HAd7YWAOvVZAb7y/By+M=;
	b=bJGOY14Ig7XO6uTM/+RlZU/ROgz/5xsIbKUgqGsZGPeqWh/kNcjNLKJlCpv9QfyG5wkZyP
	uWwzNl650OrhG3CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 727FB13736;
	Wed,  2 Sep 2026 14:17:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qCTyG+wvmGo6CgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:17:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B98AA13B5; Wed, 02 Sep 2026 16:17:08 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:17:08 +0200
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
Subject: Re: [PATCH 08/27] fs: port privilege checking helpers to const
 mnt_idmap
Message-ID: <djoty5t2d4uwprvtcbjilfzvo6xqbojrm36ckkep3mbqps7vsq@hnybw6gztpgl>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-8-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-8-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 9F82921D3F
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

On Tue 01-09-26 14:14:33, Christian Brauner wrote:
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
>  fs/attr.c                  | 10 +++++-----
>  fs/f2fs/acl.c              |  4 ++--
>  fs/f2fs/file.c             |  2 +-
>  fs/inode.c                 |  4 ++--
>  fs/internal.h              |  4 ++--
>  include/linux/capability.h |  4 ++--
>  include/linux/fs.h         |  8 ++++----
>  include/linux/security.h   |  2 +-
>  kernel/capability.c        |  4 ++--
>  security/commoncap.c       |  2 +-
>  10 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 71888ac903c2..23f1347ff240 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -30,7 +30,7 @@
>   *
>   * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
>   */
> -int setattr_should_drop_sgid(struct mnt_idmap *idmap,
> +int setattr_should_drop_sgid(const struct mnt_idmap *idmap,
>  			     const struct inode *inode)
>  {
>  	umode_t mode = inode->i_mode;
> @@ -60,7 +60,7 @@ EXPORT_SYMBOL(setattr_should_drop_sgid);
>   * Return: A mask of ATTR_KILL_S{G,U}ID indicating which - if any - setid bits
>   * to remove, 0 otherwise.
>   */
> -int setattr_should_drop_suidgid(struct mnt_idmap *idmap,
> +int setattr_should_drop_suidgid(const struct mnt_idmap *idmap,
>  				struct inode *inode)
>  {
>  	umode_t mode = inode->i_mode;
> @@ -91,7 +91,7 @@ EXPORT_SYMBOL(setattr_should_drop_suidgid);
>   * permissions. On non-idmapped mounts or if permission checking is to be
>   * performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -static bool chown_ok(struct mnt_idmap *idmap,
> +static bool chown_ok(const struct mnt_idmap *idmap,
>  		     const struct inode *inode, vfsuid_t ia_vfsuid)
>  {
>  	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
> @@ -118,7 +118,7 @@ static bool chown_ok(struct mnt_idmap *idmap,
>   * permissions. On non-idmapped mounts or if permission checking is to be
>   * performed on the raw inode simply pass @nop_mnt_idmap.
>   */
> -static bool chgrp_ok(struct mnt_idmap *idmap,
> +static bool chgrp_ok(const struct mnt_idmap *idmap,
>  		     const struct inode *inode, vfsgid_t ia_vfsgid)
>  {
>  	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
> @@ -339,7 +339,7 @@ static void setattr_copy_mgtime(struct inode *inode, const struct iattr *attr)
>   * that for "simple" filesystems, the struct inode is the inode storage.
>   * The caller is free to mark the inode dirty afterwards if needed.
>   */
> -void setattr_copy(struct mnt_idmap *idmap, struct inode *inode,
> +void setattr_copy(const struct mnt_idmap *idmap, struct inode *inode,
>  		  const struct iattr *attr)
>  {
>  	unsigned int ia_valid = attr->ia_valid;
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index d3253549173e..e7e0084d0a5f 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -219,7 +219,7 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type, bool rcu)
>  	return __f2fs_get_acl(inode, type, NULL);
>  }
>  
> -static int f2fs_acl_update_mode(struct mnt_idmap *idmap,
> +static int f2fs_acl_update_mode(const struct mnt_idmap *idmap,
>  				struct inode *inode, umode_t *mode_p,
>  				struct posix_acl **acl)
>  {
> @@ -240,7 +240,7 @@ static int f2fs_acl_update_mode(struct mnt_idmap *idmap,
>  	return 0;
>  }
>  
> -static int __f2fs_set_acl(struct mnt_idmap *idmap,
> +static int __f2fs_set_acl(const struct mnt_idmap *idmap,
>  			struct inode *inode, int type,
>  			struct posix_acl *acl, struct folio *ifolio)
>  {
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index edc352569e87..03bb3a9a449f 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1096,7 +1096,7 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
>  }
>  
>  #ifdef CONFIG_F2FS_FS_POSIX_ACL
> -static void __setattr_copy(struct mnt_idmap *idmap,
> +static void __setattr_copy(const struct mnt_idmap *idmap,
>  			   struct inode *inode, const struct iattr *attr)
>  {
>  	unsigned int ia_valid = attr->ia_valid;
> diff --git a/fs/inode.c b/fs/inode.c
> index ba7da39be4a3..72a8bbe38d62 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2337,7 +2337,7 @@ EXPORT_SYMBOL(touch_atime);
>   * response to write or truncate. Return 0 if nothing has to be changed.
>   * Negative value on error (change should be denied).
>   */
> -int dentry_needs_remove_privs(struct mnt_idmap *idmap,
> +int dentry_needs_remove_privs(const struct mnt_idmap *idmap,
>  			      struct dentry *dentry)
>  {
>  	struct inode *inode = d_inode(dentry);
> @@ -3033,7 +3033,7 @@ EXPORT_SYMBOL(inode_set_ctime_deleg);
>   *
>   * Return: true if the caller is sufficiently privileged, false if not.
>   */
> -bool in_group_or_capable(struct mnt_idmap *idmap,
> +bool in_group_or_capable(const struct mnt_idmap *idmap,
>  			 const struct inode *inode, vfsgid_t vfsgid)
>  {
>  	if (vfsgid_in_group_p(vfsgid))
> diff --git a/fs/internal.h b/fs/internal.h
> index 72244e5f4e57..161b0cafe17f 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -210,8 +210,8 @@ extern int vfs_open(const struct path *, struct file *);
>   * inode.c
>   */
>  extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
> -int dentry_needs_remove_privs(struct mnt_idmap *, struct dentry *dentry);
> -bool in_group_or_capable(struct mnt_idmap *idmap,
> +int dentry_needs_remove_privs(const struct mnt_idmap *, struct dentry *dentry);
> +bool in_group_or_capable(const struct mnt_idmap *idmap,
>  			 const struct inode *inode, vfsgid_t vfsgid);
>  
>  /*
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 37db92b3d6f8..c39a2bbefc47 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -181,9 +181,9 @@ static inline bool ns_capable_setid(struct user_namespace *ns, int cap)
>  }
>  #endif /* CONFIG_MULTIUSER */
>  bool privileged_wrt_inode_uidgid(struct user_namespace *ns,
> -				 struct mnt_idmap *idmap,
> +				 const struct mnt_idmap *idmap,
>  				 const struct inode *inode);
> -bool capable_wrt_inode_uidgid(struct mnt_idmap *idmap,
> +bool capable_wrt_inode_uidgid(const struct mnt_idmap *idmap,
>  			      const struct inode *inode, int cap);
>  extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
>  extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 154f2c976a0a..7c82d7aaa775 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1835,7 +1835,7 @@ void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
>  extern bool may_open_dev(const struct path *path);
>  umode_t mode_strip_sgid(struct mnt_idmap *idmap,
>  			const struct inode *dir, umode_t mode);
> -bool in_group_or_capable(struct mnt_idmap *idmap,
> +bool in_group_or_capable(const struct mnt_idmap *idmap,
>  			 const struct inode *inode, vfsgid_t vfsgid);
>  
>  /*
> @@ -3045,9 +3045,9 @@ static inline struct inode *new_inode_pseudo(struct super_block *sb)
>  }
>  extern struct inode *new_inode(struct super_block *sb);
>  extern void free_inode_nonrcu(struct inode *inode);
> -extern int setattr_should_drop_suidgid(struct mnt_idmap *, struct inode *);
> +extern int setattr_should_drop_suidgid(const struct mnt_idmap *, struct inode *);
>  extern int file_remove_privs(struct file *);
> -int setattr_should_drop_sgid(struct mnt_idmap *idmap,
> +int setattr_should_drop_sgid(const struct mnt_idmap *idmap,
>  			     const struct inode *inode);
>  
>  /*
> @@ -3401,7 +3401,7 @@ int may_setattr(struct mnt_idmap *idmap, struct inode *inode,
>  		unsigned int ia_valid);
>  int setattr_prepare(struct mnt_idmap *, struct dentry *, struct iattr *);
>  extern int inode_newsize_ok(const struct inode *, loff_t offset);
> -void setattr_copy(struct mnt_idmap *, struct inode *inode,
> +void setattr_copy(const struct mnt_idmap *, struct inode *inode,
>  		  const struct iattr *attr);
>  
>  extern int file_update_time(struct file *file);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..4598a13657ee 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -185,7 +185,7 @@ extern int cap_capset(struct cred *new, const struct cred *old,
>  extern int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file);
>  int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  		       const void *value, size_t size, int flags);
> -int cap_inode_removexattr(struct mnt_idmap *idmap,
> +int cap_inode_removexattr(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, const char *name);
>  int cap_inode_need_killpriv(struct dentry *dentry);
>  int cap_inode_killpriv(struct mnt_idmap *idmap, struct dentry *dentry);
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 829f49ae07b9..ae3b03703148 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -453,7 +453,7 @@ EXPORT_SYMBOL(file_ns_capable);
>   * Return true if the inode uid and gid are within the namespace.
>   */
>  bool privileged_wrt_inode_uidgid(struct user_namespace *ns,
> -				 struct mnt_idmap *idmap,
> +				 const struct mnt_idmap *idmap,
>  				 const struct inode *inode)
>  {
>  	return vfsuid_has_mapping(ns, i_uid_into_vfsuid(idmap, inode)) &&
> @@ -470,7 +470,7 @@ bool privileged_wrt_inode_uidgid(struct user_namespace *ns,
>   * its own user namespace and that the given inode's uid and gid are
>   * mapped into the current user namespace.
>   */
> -bool capable_wrt_inode_uidgid(struct mnt_idmap *idmap,
> +bool capable_wrt_inode_uidgid(const struct mnt_idmap *idmap,
>  			      const struct inode *inode, int cap)
>  {
>  	struct user_namespace *ns = current_user_ns();
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 3399535808fe..9361393fd756 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -1063,7 +1063,7 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>   * This is used to make sure security xattrs don't get removed by those who
>   * aren't privileged to remove them.
>   */
> -int cap_inode_removexattr(struct mnt_idmap *idmap,
> +int cap_inode_removexattr(const struct mnt_idmap *idmap,
>  			  struct dentry *dentry, const char *name)
>  {
>  	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
