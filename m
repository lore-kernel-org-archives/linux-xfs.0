Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E536308F;
	Wed,  2 Sep 2026 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788357998; cv=none; b=hsStTv/1q9voCwc7BVEr/tPWyd2ygYO5ec4Q9xVci/TXh3gSL7D7yN4E8Cphwy5u9LEfvMT02F0IlK/VFFT/PHV3dhYQ9AUoSROTdNHIw76LInyFwEVLxdEpfdpIWGjqAyk4OPW17X2dpDYLBspJIzpX7Aj1zkL4HnYUhU/2W7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788357998; c=relaxed/simple;
	bh=EIoe2mqPEJ5mgn/d4f/HDwaO1aLOzjVQ4OAM5V7D67s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ii8+pA+DQl1cOy4mVv+UBjxzEylLCMT0xtwaGg3uic8C8HC/5qw+9fkFDlNVCVJfk28h8DqQX4nKxZ3KZUXgo16AN7LitDSiYNXu8o8vMu/Shtww7CmdtuSUYwHtuHWFmktdCo0qNhLIHtHZSzWrzU80BsRSafKLLgBhjCQRVXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ov933JCl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DoezQ8Ri; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NIME0esV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SIyIcNby; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ov933JCl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DoezQ8Ri";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NIME0esV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SIyIcNby"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A162F21D17;
	Wed,  2 Sep 2026 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788357990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbCDMIEfZFVatzaEEPp9gAsGk6EPyPCn6tMVBkwZzS4=;
	b=ov933JClDQxCLII8uvFH82uzA0D7QF9xrNWMxCKvsnfyEHd1k2bBIkZdVR4LnLclFavPyp
	Q33OLOi23RVosk0PKCgMKZN5EljSHHoaSoLCtcT7B05Zp3r/IXxNN+GIO1NpcA18j7dbuw
	cXJQqqUyQpo/piTBpSkRIAE78TvNc7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788357990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbCDMIEfZFVatzaEEPp9gAsGk6EPyPCn6tMVBkwZzS4=;
	b=DoezQ8RitsWz+7sIQVTS50EnlsFhD8ttkA7dWRCTIkAHGBgl4t9sYkdv5+ak641PLwlpJv
	+W7wDZ8SsaUDKnAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788357986; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbCDMIEfZFVatzaEEPp9gAsGk6EPyPCn6tMVBkwZzS4=;
	b=NIME0esVzi5zNshnI5Tuo9JjESdFmxlh4Y6pYS8Xw5Vv0QjtguF4r8EZlRqhotaQj+nzLY
	DU4DfxbXmKbCTzrPgO/mZlXhScJK78edrSeWIZN6QeE5ppNnZMKVg5KwtbYUqfG+B+7Bkn
	nqMxy4IzqFKxKTwbm33wG8mHc/7UPLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788357986;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbCDMIEfZFVatzaEEPp9gAsGk6EPyPCn6tMVBkwZzS4=;
	b=SIyIcNbyXMy+y+uWsHCZjysVfdpxmR4IybhFpzzB//aFy5zWq0fyYQpYcudwcYxY3PQ7mY
	cgBr5HlW5PahMiAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7964213515;
	Wed,  2 Sep 2026 14:06:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TMqdHWItmGq0fQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:06:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04131A13B5; Wed, 02 Sep 2026 16:06:21 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:06:21 +0200
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
Subject: Re: [PATCH 01/27] userns: pass const uid_gid_map in lookup helpers
Message-ID: <622txnxnjbd4hezoqqwf7kyfqfxuon7oapf7n4pmx2pdltb4km@riyz7tb7vzs6>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-1-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-1-54ccd48e100b@kernel.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,lst.de,kernel.org,paul-moore.com,linux.ibm.com,gmail.com,szeredi.hu];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Tue 01-09-26 14:14:26, Christian Brauner wrote:
> map_id_down(), map_id_up() and map_id_range_up() search the extents
> of an idmapping and never modify it. Let all relevant helpers pass a
> const struct uid_gid_map. Callers can now pass pass struct mnt_idmap as
> const and pass down &idmap->uid_map and &idmap->gid_map.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/uidgid.h  | 12 ++++++------
>  kernel/user_namespace.c | 28 ++++++++++++++--------------
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 2dc767e08f54..02403629b49f 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h
> @@ -130,9 +130,9 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
>  	return from_kgid(ns, gid) != (gid_t) -1;
>  }
>  
> -u32 map_id_down(struct uid_gid_map *map, u32 id);
> -u32 map_id_up(struct uid_gid_map *map, u32 id);
> -u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count);
> +u32 map_id_down(const struct uid_gid_map *map, u32 id);
> +u32 map_id_up(const struct uid_gid_map *map, u32 id);
> +u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count);
>  
>  #else
>  
> @@ -182,17 +182,17 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
>  	return gid_valid(gid);
>  }
>  
> -static inline u32 map_id_down(struct uid_gid_map *map, u32 id)
> +static inline u32 map_id_down(const struct uid_gid_map *map, u32 id)
>  {
>  	return id;
>  }
>  
> -static inline u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
> +static inline u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count)
>  {
>  	return id;
>  }
>  
> -static inline u32 map_id_up(struct uid_gid_map *map, u32 id)
> +static inline u32 map_id_up(const struct uid_gid_map *map, u32 id)
>  {
>  	return id;
>  }
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 0bed462e9b2a..55b6bd75624b 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -278,8 +278,8 @@ static int cmp_map_id(const void *k, const void *e)
>   * map_id_range_down_max - Find idmap via binary search in ordered idmap array.
>   * Can only be called if number of mappings exceeds UID_GID_MAP_MAX_BASE_EXTENTS.
>   */
> -static struct uid_gid_extent *
> -map_id_range_down_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
> +static const struct uid_gid_extent *
> +map_id_range_down_max(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
>  {
>  	struct idmap_key key;
>  
> @@ -296,8 +296,8 @@ map_id_range_down_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 cou
>   * Can only be called if number of mappings is equal or less than
>   * UID_GID_MAP_MAX_BASE_EXTENTS.
>   */
> -static struct uid_gid_extent *
> -map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
> +static const struct uid_gid_extent *
> +map_id_range_down_base(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
>  {
>  	unsigned idx;
>  	u32 first, last, id2;
> @@ -315,9 +315,9 @@ map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 co
>  	return NULL;
>  }
>  
> -static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
> +static u32 map_id_range_down(const struct uid_gid_map *map, u32 id, u32 count)
>  {
> -	struct uid_gid_extent *extent;
> +	const struct uid_gid_extent *extent;
>  	unsigned extents = map->nr_extents;
>  	smp_rmb();
>  
> @@ -335,7 +335,7 @@ static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
>  	return id;
>  }
>  
> -u32 map_id_down(struct uid_gid_map *map, u32 id)
> +u32 map_id_down(const struct uid_gid_map *map, u32 id)
>  {
>  	return map_id_range_down(map, id, 1);
>  }
> @@ -345,8 +345,8 @@ u32 map_id_down(struct uid_gid_map *map, u32 id)
>   * Can only be called if number of mappings is equal or less than
>   * UID_GID_MAP_MAX_BASE_EXTENTS.
>   */
> -static struct uid_gid_extent *
> -map_id_range_up_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
> +static const struct uid_gid_extent *
> +map_id_range_up_base(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
>  {
>  	unsigned idx;
>  	u32 first, last, id2;
> @@ -368,8 +368,8 @@ map_id_range_up_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 coun
>   * map_id_up_max - Find idmap via binary search in ordered idmap array.
>   * Can only be called if number of mappings exceeds UID_GID_MAP_MAX_BASE_EXTENTS.
>   */
> -static struct uid_gid_extent *
> -map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
> +static const struct uid_gid_extent *
> +map_id_range_up_max(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
>  {
>  	struct idmap_key key;
>  
> @@ -381,9 +381,9 @@ map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count
>  		       sizeof(struct uid_gid_extent), cmp_map_id);
>  }
>  
> -u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
> +u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count)
>  {
> -	struct uid_gid_extent *extent;
> +	const struct uid_gid_extent *extent;
>  	unsigned extents = map->nr_extents;
>  	smp_rmb();
>  
> @@ -401,7 +401,7 @@ u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
>  	return id;
>  }
>  
> -u32 map_id_up(struct uid_gid_map *map, u32 id)
> +u32 map_id_up(const struct uid_gid_map *map, u32 id)
>  {
>  	return map_id_range_up(map, id, 1);
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
