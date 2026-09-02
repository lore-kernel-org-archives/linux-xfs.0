Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BDB30E0CC;
	Wed,  2 Sep 2026 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358726; cv=none; b=qt6l0KezctessLAN9DTzGRXHKs9SmYnwzyfZSXj/Nu5ng2s6v1LAYmcle6QdEFb2bC1Ke82Kxy/i3AuPr6VLiUTyqsNDUzCw5z3THO7l9nN1oywhZ4DvTYwwpHl4IwG0HF0f+XYO3c30GlIKQDPNQ3B9jviubM2MAkQrbWUQzsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358726; c=relaxed/simple;
	bh=g2fh/2Y+qhtJXsZLvZ8Ia+JjBK6fwA0EcBmTPBzRIRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ty+hD9Hrq2prkOJmvBZoBoJGQ+ynAGM9hfTysYlnU7pWhXK88sZIvLqfFb3HXydquDnzVUSltXvIdi6pUvFsvKchphYLBUhelLjDp1ze7onTaTFx9F45AH+ZAMEZACawI1xZqQ4kAv/NbENvRLdh2Ur6SB4KDegTuz8S53Hy00E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j9Rm1vB3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7mm+X9y1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CI1EqKU9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LKlc4oij; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j9Rm1vB3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7mm+X9y1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CI1EqKU9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LKlc4oij"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D48E41F7B8;
	Wed,  2 Sep 2026 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCEcLopfA07b49SNi5+xsV9zhgEMvhJ+X9q9DwwqLF0=;
	b=j9Rm1vB3WvXjEWIgRwCS+Bm7HMj0uQ69ftNZPo6q7NNzk9y9HsjQPZRR+7u2TOmIA+baGK
	t3/ZPhCTfQO50AycjmZZhW/WwNxb/Tj//Mhmj1WxwJqHhwX+e9nXEsq16SQfHZ1xMAwnGE
	LEr+eEHOUAFTvkq7/8R/rfO0W/Njq7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCEcLopfA07b49SNi5+xsV9zhgEMvhJ+X9q9DwwqLF0=;
	b=7mm+X9y1cxc/f3FuyoP8GHcWTTLA+LFwTdStmJCtXoknAyxrW7xYJaZtPIDD5CIxGRU80t
	/NIOnKcACZQJ4YCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCEcLopfA07b49SNi5+xsV9zhgEMvhJ+X9q9DwwqLF0=;
	b=CI1EqKU9WmvcftxUilfqCeAL3JXrloDYOiyfS8NddoSXUmVQujq+nNQ+KY9Q7Tu1BGb5as
	zDQC5sxt7akfaZanJ+Z3icbtIJ0bbBvBD2/8UoVlzd2rrVmip5AiyoW1ezxgEv6DfzZk5w
	/sMzZ6bwuMA1rdePt0RyUFn/dtg0GBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCEcLopfA07b49SNi5+xsV9zhgEMvhJ+X9q9DwwqLF0=;
	b=LKlc4oij76A8lIuFml+FBRuO9haihM/tga2dmvSoxghaxJm14xdRSscs59z2DN1zsWcaHG
	OFWjyCwcluNtInAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4CC2136E6;
	Wed,  2 Sep 2026 14:18:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uoMhLDkwmGpOCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:18:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F931A13B5; Wed, 02 Sep 2026 16:18:29 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:18:29 +0200
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
Subject: Re: [PATCH 09/27] fs: port inode_owner_or_capable() to const
 mnt_idmap
Message-ID: <7iyu53duyhf2uretzpp4opsls2ldy63rm3jooaoifoe427xdv4@ghksxihzdzx3>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-9-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-9-54ccd48e100b@kernel.org>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Tue 01-09-26 14:14:34, Christian Brauner wrote:
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
>  fs/btrfs/ioctl.c   | 2 +-
>  fs/ext4/ioctl.c    | 2 +-
>  fs/inode.c         | 2 +-
>  include/linux/fs.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 72bc9d4f7708..b34c6a8247e4 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3886,7 +3886,7 @@ static long btrfs_ioctl_quota_rescan_wait(struct btrfs_fs_info *fs_info)
>  }
>  
>  static long _btrfs_ioctl_set_received_subvol(struct file *file,
> -					    struct mnt_idmap *idmap,
> +					    const struct mnt_idmap *idmap,
>  					    struct btrfs_ioctl_received_subvol_args *sa)
>  {
>  	struct inode *inode = file_inode(file);
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e..6de77da4203c 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -373,7 +373,7 @@ void ext4_reset_inode_seed(struct inode *inode)
>   *
>   */
>  static long swap_inode_boot_loader(struct super_block *sb,
> -				struct mnt_idmap *idmap,
> +				const struct mnt_idmap *idmap,
>  				struct inode *inode)
>  {
>  	handle_t *handle;
> diff --git a/fs/inode.c b/fs/inode.c
> index 72a8bbe38d62..4313e9735c5c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2746,7 +2746,7 @@ EXPORT_SYMBOL(inode_init_owner);
>   * On non-idmapped mounts or if permission checking is to be performed on the
>   * raw inode simply pass @nop_mnt_idmap.
>   */
> -bool inode_owner_or_capable(struct mnt_idmap *idmap,
> +bool inode_owner_or_capable(const struct mnt_idmap *idmap,
>  			    const struct inode *inode)
>  {
>  	vfsuid_t vfsuid;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7c82d7aaa775..e2babddf755d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1755,7 +1755,7 @@ static inline bool file_write_not_started(const struct file *file)
>  	return sb_write_not_started(file_inode(file)->i_sb);
>  }
>  
> -bool inode_owner_or_capable(struct mnt_idmap *idmap,
> +bool inode_owner_or_capable(const struct mnt_idmap *idmap,
>  			    const struct inode *inode);
>  
>  /*
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
