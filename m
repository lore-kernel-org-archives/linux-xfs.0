Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC0B4A3879;
	Wed,  2 Sep 2026 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358575; cv=none; b=sJJPcvDDq57nJuHfxuVD36WnCjW3ma6lx4dVyCnyULMgxuF7exX8JhyoaTRBfOVi50MzNcKG8nMfiL2viFZ1Sg5X3owTcv29MFqHOM7RDpEUm6VBy6BrzY2T6AP/VgTWsKUsmFOQnj1e7zI7NUeFIlnAMJEtPLQQWHak3gGLZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358575; c=relaxed/simple;
	bh=GCA0bPB/YUZlP4IOP98n7AXcjLj6hl3oaR7DyXNWJBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9KNdtdN67Oh4z8t5jHm3GMIQd6SvvO+CJQQy7VIDqLK4OkJiEbOyPbaW03aA6a2s6VTpsTnqar2A31i+rQU295qoZsOyXYiQ16MQ1HYnRNcCmeNe+TmE0XhUBY8jkTqXifEPd/Nafk5MjBeSv9vcXYZS6EbHGBaWNmkyvfIJAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U3FX6fvg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1BQ+cQrF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Fw28NOAK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q5ndf4+Q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U3FX6fvg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1BQ+cQrF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Fw28NOAK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q5ndf4+Q"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 36EE91FA8F;
	Wed,  2 Sep 2026 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb0dKasFF3hTPeFYF6PUiyC6Pn9XziSlrLw3mGV305E=;
	b=U3FX6fvgTUA87329626Ye7ERTy9XsCljLwERs/AVMDc9xG6D5bjZDJ47ogPjuSbRbXSn3v
	07Ps/sk0fE8vSE5hJCCpoTSiGQc9idRhQE13rFnHDuh4O87tI0CQvTMIgfELyV2vEgu/1M
	trgA3Q8CcJL0r7GUKHb8kf6jP9r4A2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb0dKasFF3hTPeFYF6PUiyC6Pn9XziSlrLw3mGV305E=;
	b=1BQ+cQrF+/lOHnrksRU2H4xfr71qBOJi93dh3N4fQzQgUGGw+Evn5Rt5gCHaYpczTbjOv3
	Gc+wsC3bPH85+BCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fw28NOAK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q5ndf4+Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb0dKasFF3hTPeFYF6PUiyC6Pn9XziSlrLw3mGV305E=;
	b=Fw28NOAKn1qw7RVW7ogA38IV4Elp68lToCtR3h97CDiQ4jTqQhhNCBck/U3K8DHz2YBAXW
	DFoKdPT39RYtiiLMVtyVrdjh6hjWwKHSVK1MnbJzpr/ye0q2sDdcEFAsluxK3VmOsmKUtd
	XBjmTehH2m7XxfUINgg0K7Z6wwXr7f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358563;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb0dKasFF3hTPeFYF6PUiyC6Pn9XziSlrLw3mGV305E=;
	b=Q5ndf4+QGNMfcZp2CzDHA05I2jVz+HMQo8gAuHlm6PxEA2VDAtNYJ24kK7JFOZWMFmNMzr
	R4A4bDfOkjfNH9Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15EA313738;
	Wed,  2 Sep 2026 14:16:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +hVWBaMvmGpCCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:16:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6FA6A13B5; Wed, 02 Sep 2026 16:16:02 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:16:02 +0200
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
Subject: Re: [PATCH 07/27] quota: port to const mnt_idmap
Message-ID: <du46n7ar62ruzoubfxuqs7avfkuajfabtngju2m3ynstttpgzb@c4rnp3mehc2o>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-7-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-7-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 36EE91FA8F
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLbde8anocd1dffa59fn6d5qp8)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 01-09-26 14:14:32, Christian Brauner wrote:
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
>  fs/quota/dquot.c         | 2 +-
>  include/linux/quotaops.h | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 204afc5e984b..c5e9c4e24d68 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2079,7 +2079,7 @@ EXPORT_SYMBOL(__dquot_transfer);
>  /* Wrapper for transferring ownership of an inode for uid/gid only
>   * Called from FSXXX_setattr()
>   */
> -int dquot_transfer(struct mnt_idmap *idmap, struct inode *inode,
> +int dquot_transfer(const struct mnt_idmap *idmap, struct inode *inode,
>  		   struct iattr *iattr)
>  {
>  	struct dquot *transfer_to[MAXQUOTAS] = {};
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index f9c0f9d7c9d9..0c64ca674e77 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -20,7 +20,7 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
>  }
>  
>  /* i_rwsem must being held */
> -static inline bool is_quota_modification(struct mnt_idmap *idmap,
> +static inline bool is_quota_modification(const struct mnt_idmap *idmap,
>  					 struct inode *inode, struct iattr *ia)
>  {
>  	return ((ia->ia_valid & ATTR_SIZE) ||
> @@ -109,7 +109,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid id,
>  		struct qc_dqblk *di);
>  
>  int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
> -int dquot_transfer(struct mnt_idmap *idmap, struct inode *inode,
> +int dquot_transfer(const struct mnt_idmap *idmap, struct inode *inode,
>  		   struct iattr *iattr);
>  
>  static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
> @@ -229,7 +229,7 @@ static inline void dquot_free_inode(struct inode *inode)
>  {
>  }
>  
> -static inline int dquot_transfer(struct mnt_idmap *idmap,
> +static inline int dquot_transfer(const struct mnt_idmap *idmap,
>  				 struct inode *inode, struct iattr *iattr)
>  {
>  	return 0;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
