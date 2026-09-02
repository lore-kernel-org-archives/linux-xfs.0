Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68D390239;
	Wed,  2 Sep 2026 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788358136; cv=none; b=N7TD7N7ENUA235FPaNgpUyekdqwiUm64FdGW5BFdbJLPNUjEalG/Qqz/pJHuWd/WSAyqwAgDxvlEI9GFODk7Lix4vNINiYrmX3lOT5ZBIda6wD5E0j3Z6J5Ix/g4QAe+USAUbCDuDGOjuC7AL8B8VRENWM1pNfh5AcjG/0xUb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788358136; c=relaxed/simple;
	bh=S8cywDh9yiuzPNVKaKGeuVkuLBd5I+C+GwCbZEmfNBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHtyQZNd5jNgu6h+dKg+81KAtS8b6fMPUZRvMiraguK8FsUXaaHWZNB77qgblGTQuZJSo9XWdgRzi9SqbD+b4HtPZWjL2w7forbFfOueMA9KvP2orZoux9j6sm3+wJTXOT5HFm6R7B5jTOkYcHzKI7f/+sTwsgYB1DvLqRSHuNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qJPy99E2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KbxL71w2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ktXOARdA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wrNdg/N0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qJPy99E2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KbxL71w2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ktXOARdA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wrNdg/N0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E10121D17;
	Wed,  2 Sep 2026 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0EDI2eveR15vdqf1UXwkT5fNM3xRNsPYucFR/c22A4=;
	b=qJPy99E2OZ9fHuJL3r/vXAn73rP9ksh8H1LjmvpExHIA15EIVJE7eHKgZ7VjK2Iu08RcI3
	MmIg5TVciwbdEPVPVFvahWgH7sZX6LNkf3+B6kDXDBSFmcuV2yPbCc4wVYZbPzuiv0GnoD
	yl6f4XpEQQSHdDEX9b+VmMGarQnliz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0EDI2eveR15vdqf1UXwkT5fNM3xRNsPYucFR/c22A4=;
	b=KbxL71w2KNMsKXnohyGioylcRtYsrzumvpFU31srhOLilVg3vFKHj8W6qvCR32rCYAJc1+
	0WMV6LGT2zHUECCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788358124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0EDI2eveR15vdqf1UXwkT5fNM3xRNsPYucFR/c22A4=;
	b=ktXOARdAfzGmL0WdBryOJhol/eDyJy0I6H8PwoHTqj2UYo1XM43sROxtGMNfmk00Mf2Hm5
	+Xpz2y0j7Gk4e/9XJ95L6MyiegpqAseNqvQimD4KHgqgog9tugYQwSQ1wXa8LF7tcZ/U+t
	7Dd5NrvwVnZKSoavLWfmjLjHC0jimls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788358124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d0EDI2eveR15vdqf1UXwkT5fNM3xRNsPYucFR/c22A4=;
	b=wrNdg/N0LfUx2qpBUhYvlszDdjb+eQideFvvegTx5QjgCrjEyXhaPBYcMX7eOt0LK4ADqv
	YLKY7+kwz4KtywBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E419136E6;
	Wed,  2 Sep 2026 14:08:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4cEaE+wtmGqkAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:08:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DE889A13B5; Wed, 02 Sep 2026 16:08:43 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:08:43 +0200
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
Subject: Re: [PATCH 02/27] fs: port mnt_idmap_{get,put}() to const mnt_idmap
Message-ID: <rp3rpct6fq4tzolaus2xezyyflljigcpskksvwrt6vlyraod7p@ra63xgvw57tx>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
 <20260901-work-idmap-const-v1-2-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-2-54ccd48e100b@kernel.org>
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

On Tue 01-09-26 14:14:27, Christian Brauner wrote:
> struct mnt_idmap is immutable once alloc_mnt_idmap() has set it up. The
> only thing that changes afterwards is the reference count. Model
> mnt_idmap_{get,put}() after struct cred's reference count handling and
> take a const pointer.
> 
> This model is forced upon us because ceph stores the idmapping in mds
> requests and need to be able to take and put references.
> 
> mnt_idmap_get() keeps returning a non-const pointer for now because
> struct vfsmount still stores a non-const pointer. We can only change
> that at the end of the series once every user of mnt_idmap() has been
> ported.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Yeah, this is a bit ugly but it's convenient :) and in the great scheme of
things I think it's a win. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/internal.h                 |  4 ++--
>  fs/mnt_idmapping.c            | 16 ++++++++++------
>  include/linux/mnt_idmapping.h |  4 ++--
>  3 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index c658c8a5ebd5..581aaa2d6510 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -327,8 +327,8 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
>   * fs/attr.c
>   */
>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
> -struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
> -void mnt_idmap_put(struct mnt_idmap *idmap);
> +struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
> +void mnt_idmap_put(const struct mnt_idmap *idmap);
>  struct stashed_operations {
>  	struct dentry *(*stash_dentry)(struct dentry **stashed,
>  				       struct dentry *dentry);
> diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
> index cb61fbdb52e9..cc6c5f1cfba8 100644
> --- a/fs/mnt_idmapping.c
> +++ b/fs/mnt_idmapping.c
> @@ -312,12 +312,14 @@ struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns)
>   *
>   * Return: @idmap with reference count bumped if @not_mnt_idmap isn't passed.
>   */
> -struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap)
> +struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap)
>  {
> +	struct mnt_idmap *nonconst_idmap = (struct mnt_idmap *)idmap;
> +
>  	if (idmap != &nop_mnt_idmap && idmap != &invalid_mnt_idmap)
> -		refcount_inc(&idmap->count);
> +		refcount_inc(&nonconst_idmap->count);
>  
> -	return idmap;
> +	return nonconst_idmap;
>  }
>  EXPORT_SYMBOL_GPL(mnt_idmap_get);
>  
> @@ -328,11 +330,13 @@ EXPORT_SYMBOL_GPL(mnt_idmap_get);
>   * If this is a non-initial idmapping, put the reference count when a mount is
>   * released and free it if we're the last user.
>   */
> -void mnt_idmap_put(struct mnt_idmap *idmap)
> +void mnt_idmap_put(const struct mnt_idmap *idmap)
>  {
> +	struct mnt_idmap *nonconst_idmap = (struct mnt_idmap *)idmap;
> +
>  	if (idmap != &nop_mnt_idmap && idmap != &invalid_mnt_idmap &&
> -	    refcount_dec_and_test(&idmap->count))
> -		free_mnt_idmap(idmap);
> +	    refcount_dec_and_test(&nonconst_idmap->count))
> +		free_mnt_idmap(nonconst_idmap);
>  }
>  EXPORT_SYMBOL_GPL(mnt_idmap_put);
>  
> diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
> index e71a6070a8f8..e5bee8b41094 100644
> --- a/include/linux/mnt_idmapping.h
> +++ b/include/linux/mnt_idmapping.h
> @@ -121,8 +121,8 @@ static inline bool vfsgid_eq_kgid(vfsgid_t vfsgid, kgid_t kgid)
>  
>  int vfsgid_in_group_p(vfsgid_t vfsgid);
>  
> -struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
> -void mnt_idmap_put(struct mnt_idmap *idmap);
> +struct mnt_idmap *mnt_idmap_get(const struct mnt_idmap *idmap);
> +void mnt_idmap_put(const struct mnt_idmap *idmap);
>  
>  vfsuid_t make_vfsuid(struct mnt_idmap *idmap,
>  		     struct user_namespace *fs_userns, kuid_t kuid);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
