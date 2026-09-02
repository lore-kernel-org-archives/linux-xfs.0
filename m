Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B4313267;
	Wed,  2 Sep 2026 14:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358546; cv=none; b=PnwhrIZSetb+VV3CYYA/A8Dn+wdMBffe5M1IrbM+brg9rGFkIRTH6rgTwsRpT/zFgZ8oFgnqz3yKtPvnxpUUKw/KkMItPV76Jh38r2tk7hjzpiWYKxjeEFTe4Jsa9B1LkaEEamip14CATot4gdC1TEOcqapK9RkZJxxKiQs9R/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358546; c=relaxed/simple;
	bh=/VIrMdjnE4feqzQKiZJ5v3uhJo0byjFwPaVBFPq+kmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRRM6GwCL2rEXy4XKBQE/zjGLGFdfqC4Ahm87fd+5e/SJ+CJga65BgjrGUi8nGm47q+gpFkpJnwYmGyJuzz4JtVZj+d3UWAkZi2vgtX44WSh2usJS+CxEpWDCyOhPBcVzZLe9n/0yuPf4OLzI+bs4W0ZL4OQfNjgyNnDHaSNeQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0/Ucg4q2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ndR3vqGp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x6SVBTNF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7bXgNQcl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0/Ucg4q2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ndR3vqGp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x6SVBTNF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7bXgNQcl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A58F51F7EE;
	Wed,  2 Sep 2026 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm63lg1C+ggmkUKeCKiUOvEC7eVaOh5IoCCSRPUhWzg=;
	b=0/Ucg4q2ffQldOy5WMN4ZwPNq5iM9XqCu/M7jtMAkeGoIxItyMsAmo3/JvFqyxi7eAFmI7
	N9IwNnlJNZTsmXrEhNm2626n8ElpUn1nkTejyLGCAIOJhPUuGD6vEQMyDjnVTB0fUXizMl
	XIbL56ICsAxoTRfR7fYbMP+6/DV4Mes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm63lg1C+ggmkUKeCKiUOvEC7eVaOh5IoCCSRPUhWzg=;
	b=ndR3vqGp+2SZ04jc2tkNJPAzMa5FkbfPbCNb6aJhlecwRsGavU7vaBPeuFG7VRc7Hnzmlb
	Wk5jybDWWTbRbiCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x6SVBTNF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7bXgNQcl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm63lg1C+ggmkUKeCKiUOvEC7eVaOh5IoCCSRPUhWzg=;
	b=x6SVBTNF8PXF0pFQsKAEABdLmQFnzf2kzbTv/Hpt+baUONseGm3SYYo2+N2n3I9c+jvPLv
	/oVjgQSBULZ15Mruy7H1kRMRKi9ZVz6Im47V0qZmpU1E/quBS7R+w20KTwGEuzH3YerWw8
	t8Ia/n79WHXlSzAWc/gs0hrfwbnSfCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm63lg1C+ggmkUKeCKiUOvEC7eVaOh5IoCCSRPUhWzg=;
	b=7bXgNQclOWhlB32a7R+aosVGWplxOs0QF5lBkD3qHfbSZ63yqkKrtiar5Ei+n744N0DJ0I
	bOyzopWkSb3w5bBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C7E213736;
	Wed,  2 Sep 2026 14:15:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9Q9fHoYvmGpMCAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:15:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1D345A13B5; Wed, 02 Sep 2026 16:15:30 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:15:30 +0200
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
Subject: Re: [PATCH 06/27] fs: port i_{g,u}id_{needs_}update() to const
 mnt_idmap
Message-ID: <4rmh6l7yrzu6onwufn6lfe2zldewrmdnuaa7f4ydlritbjpgo2@f6ac3hnu3edm>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-6-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-6-54ccd48e100b@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: A58F51F7EE
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

On Tue 01-09-26 14:14:31, Christian Brauner wrote:
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
>  include/linux/fs.h                | 8 ++++----
>  security/integrity/evm/evm_main.c | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index cec5de83d882..154f2c976a0a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1456,7 +1456,7 @@ static inline vfsuid_t i_uid_into_vfsuid(const struct mnt_idmap *idmap,
>   *
>   * Return: true if @inode's i_uid field needs to be updated, false if not.
>   */
> -static inline bool i_uid_needs_update(struct mnt_idmap *idmap,
> +static inline bool i_uid_needs_update(const struct mnt_idmap *idmap,
>  				      const struct iattr *attr,
>  				      const struct inode *inode)
>  {
> @@ -1474,7 +1474,7 @@ static inline bool i_uid_needs_update(struct mnt_idmap *idmap,
>   * Safely update @inode's i_uid field translating the vfsuid of any idmapped
>   * mount into the filesystem kuid.
>   */
> -static inline void i_uid_update(struct mnt_idmap *idmap,
> +static inline void i_uid_update(const struct mnt_idmap *idmap,
>  				const struct iattr *attr,
>  				struct inode *inode)
>  {
> @@ -1508,7 +1508,7 @@ static inline vfsgid_t i_gid_into_vfsgid(const struct mnt_idmap *idmap,
>   *
>   * Return: true if @inode's i_gid field needs to be updated, false if not.
>   */
> -static inline bool i_gid_needs_update(struct mnt_idmap *idmap,
> +static inline bool i_gid_needs_update(const struct mnt_idmap *idmap,
>  				      const struct iattr *attr,
>  				      const struct inode *inode)
>  {
> @@ -1526,7 +1526,7 @@ static inline bool i_gid_needs_update(struct mnt_idmap *idmap,
>   * Safely update @inode's i_gid field translating the vfsgid of any idmapped
>   * mount into the filesystem kgid.
>   */
> -static inline void i_gid_update(struct mnt_idmap *idmap,
> +static inline void i_gid_update(const struct mnt_idmap *idmap,
>  				const struct iattr *attr,
>  				struct inode *inode)
>  {
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 66f27653cdac..06e187c9912d 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -933,7 +933,7 @@ static inline void evm_inode_post_remove_acl(struct mnt_idmap *idmap,
>  	evm_inode_post_removexattr(dentry, acl_name);
>  }
>  
> -static int evm_attr_change(struct mnt_idmap *idmap,
> +static int evm_attr_change(const struct mnt_idmap *idmap,
>  			   struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = d_backing_inode(dentry);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
