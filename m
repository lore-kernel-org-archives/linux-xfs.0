Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B734A9D76;
	Wed,  2 Sep 2026 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365269; cv=none; b=SZHkDmF/Kf03QqRVRZDLYwRbijXZEZTkkPeRr2T0w5pOv0yWt02Z/ZG4MrVlB/FnrFDNOGWnJ02+kSwzRe1Gh9hHSO6DEhgoeCyGc8dUuPFFgVwGox/qkIeWtp6+Cja6kvEt4sKY2fgUv4JjIVEh+JXeSv4WuyOzmFDHCPCUBFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365269; c=relaxed/simple;
	bh=P6CyjnQCD6Ueg6/odmAdFf71SxIvposEfb5XFt0XTH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heFO5EHKX2AvAnQrWyO0BANsm5jGW7v04JYnxIX87U9Auxh2cpAemA4ld7rcrQsnoNoo+T13bkaNYEvdZ9DejImKa84ogOPNZ2Ny2yWr39VIsOxGQte8bBTt7Uh/4oKeERYLW6hXuw3nzdSsObjI38xaIMmerjXIuVBF/7sAj54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A0G0EV6U; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wMfk1JD4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J2u0vrLQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jhVZVvvG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A0G0EV6U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wMfk1JD4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J2u0vrLQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jhVZVvvG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D984721CF1;
	Wed,  2 Sep 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788365260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyyAayOiVnv3aCFB/W1ne3d6kkITO1+ebE/Tmz3HhRc=;
	b=A0G0EV6UhbB6YIvOcpkFyIfobvY9/e8i/ReIi8HVus8DxK9g5Hk5ISsE5espVhhlivJZOU
	ImQ51Lja4jGOm1Tf6aRccvgqzCLff2nf22JUKY5mlzlEFKzQFTn60qtuyKgzDV0AOBqIUV
	lfAJu0mnlzJXGa3I9wqiz48JnlJ1ZdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788365260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyyAayOiVnv3aCFB/W1ne3d6kkITO1+ebE/Tmz3HhRc=;
	b=wMfk1JD4823uYOsl8fRyyPrX6HKmco8UqVmxSlHr5EdUleJzoOC6hSE544UQHcxcMbS1Rq
	p9SnsXWpu3kNZmDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788365255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyyAayOiVnv3aCFB/W1ne3d6kkITO1+ebE/Tmz3HhRc=;
	b=J2u0vrLQuKQxOjcCTVhxFLjobpvG5TMTIE29WBZx0Kfd6B7+2rH4mLAdzP/e+YRYBfkhi1
	/dsloXZkTXfiA7rJdHeBBTbJgSCdbgHK7Gnw0uA41QQrTbKKpIkmlh8noKS+0iuqcNcXcg
	zx/wQArVMHi8TVda+qCcK9L3pWQap+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788365255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyyAayOiVnv3aCFB/W1ne3d6kkITO1+ebE/Tmz3HhRc=;
	b=jhVZVvvGm3fLLJuX6gV+8KGwP9KoKX/mo0qHd/+V2P87KOQvfzzvsovffSqZZ5hvtPLeGP
	YaEYZs6Z2naE0oBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B91D713515;
	Wed,  2 Sep 2026 16:07:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AAStLMdJmGrnegAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 16:07:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64656A13B5; Wed, 02 Sep 2026 18:07:35 +0200 (CEST)
Date: Wed, 2 Sep 2026 18:07:35 +0200
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
Subject: Re: [PATCH 27/27] fs: make nop_mnt_idmap and invalid_mnt_idmap const
Message-ID: <zjaeoapknslc6sxdf7ycgkytk2fr6ougieqz7icejptlfzkuhd@sr47lzi4ldex>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-27-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-27-54ccd48e100b@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]

On Tue 01-09-26 14:14:52, Christian Brauner wrote:
> Make both static maps const so they end up in rodata. Any attempt to
> modify them now faults instead of silently corrupting the initial
> idmapping.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/mnt_idmapping.c            | 4 ++--
>  include/linux/mnt_idmapping.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
> index 26704eeb7318..bed57094cef0 100644
> --- a/fs/mnt_idmapping.c
> +++ b/fs/mnt_idmapping.c
> @@ -28,7 +28,7 @@ struct mnt_idmap {
>   * mapping. This means that {g,u}id 0 is mapped to {g,u}id 0, {g,u}id 1 is
>   * mapped to {g,u}id 1, [...], {g,u}id 1000 to {g,u}id 1000, [...].
>   */
> -struct mnt_idmap nop_mnt_idmap = {
> +const struct mnt_idmap nop_mnt_idmap = {
>  	.count	= REFCOUNT_INIT(1),
>  };
>  EXPORT_SYMBOL_GPL(nop_mnt_idmap);
> @@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(nop_mnt_idmap);
>   * Carries the invalid idmapping of a full 0-4294967295 {g,u}id range.
>   * This means that all {g,u}ids are mapped to INVALID_VFS{G,U}ID.
>   */
> -struct mnt_idmap invalid_mnt_idmap = {
> +const struct mnt_idmap invalid_mnt_idmap = {
>  	.count	= REFCOUNT_INIT(1),
>  };
>  EXPORT_SYMBOL_GPL(invalid_mnt_idmap);
> diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
> index b445c7660040..78eeef4c2996 100644
> --- a/include/linux/mnt_idmapping.h
> +++ b/include/linux/mnt_idmapping.h
> @@ -8,8 +8,8 @@
>  struct mnt_idmap;
>  struct user_namespace;
>  
> -extern struct mnt_idmap nop_mnt_idmap;
> -extern struct mnt_idmap invalid_mnt_idmap;
> +extern const struct mnt_idmap nop_mnt_idmap;
> +extern const struct mnt_idmap invalid_mnt_idmap;
>  extern struct user_namespace init_user_ns;
>  
>  typedef struct {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
