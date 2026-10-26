Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793017190;
	b=0u1d/NeQ3srmPZW2oosHWIyavZmAt20TCdIoJLbbx121gPyLZrd/lEHFFofEXufe4/bL
	 aMkKd0V1pMAAKeI1sbzg00SCYP3WJsX0BhbACTkeCzrCUvVAaPMaPAVM7h/MkPgmd77MS
	 EhYFH0RsXmZ6yV7uWU+5gxeIN6xlEVuDQayA/8992vI3zgBPKvp4eKyx0y2FE3iYF4ATY
	 6Hxqi3/HIOCkM+uVqsji+H0w+RgWLAAk04C32qVeanS3ds5sHATxQqDMRIFzMCUh/2T7N
	 PA5wutotdoJJux12lprWFBnXN5eDCAbfOakC9Q245Y3atOh59WP7VdIAfvTfi9lg1WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793017190;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=y8x/Pha56IWNhOsrddTmq/pZ76SoL/4aPw0ZOZYdl3c=;
	b=B4wvXCZVPuibHAkI7w22PIPvyWFPaGnI9jdolPXBLUQTAEIhihXkPdmCdTEdW8MSLbAw
	 i7OVxE+FyEPtouuFPHblZgVGB88NREzR6r/onWIglsMkMfWeOdJc09Ctw1sKbg23l+Q/J
	 HAd8n/fgiRrX3ICOm2x0KaQFG7lAXOYYMGyTlLAPIdQTo420zu39niMEnS8GtDUIvB5CZ
	 hOPiKRaqIsyTqqWriIJWSe7l3GaLyABI5jl+KkSbz198/J0xhsruEQ2XCeHsFuRg4PE7k
	 iEKjUtlrl1nL824NC/Txs0dvLrCBTleNVMrYGnLxoLyJE1x9u8Z+TtC8CzjIkHXVBWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=3bhhpT8v;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Tq7HhWbN;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=k0jtjt69;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bPIVkg8m;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0E8606A31B;
	Mon, 26 Oct 2026 12:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E0E8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=3bhhpT8v;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Tq7HhWbN;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=k0jtjt69;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bPIVkg8m
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 160202215D;
	Mon, 26 Oct 2026 12:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793017188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8x/Pha56IWNhOsrddTmq/pZ76SoL/4aPw0ZOZYdl3c=;
	b=3bhhpT8vSA6RzPpR2M0OYTCv5uNJcRvd2cLFqMgCuexUesIC+kVNvW11FaRLersI934O5K
	AR/aB1/Aj7T6B3dFxe8VIVcQsqvk8H5N+st3jUe0uDPkNbAExvygzqTCXB8T1swAeR4B2i
	nR2Lqvm4JEAz9ex3d6i8eRtJ/c3s2UE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793017188;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8x/Pha56IWNhOsrddTmq/pZ76SoL/4aPw0ZOZYdl3c=;
	b=Tq7HhWbNXUocxl8i2ipjhqfbgTQK+50hH8+2sZ99+7ZqPbhTGy2DFLSQKRv6UMX2w4/NmP
	08T6x79lgxqV1YBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k0jtjt69;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bPIVkg8m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793017187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8x/Pha56IWNhOsrddTmq/pZ76SoL/4aPw0ZOZYdl3c=;
	b=k0jtjt69RyY0Epso4r6J3ByxlPDQEO8GPke/MJYjQRYH+QxzJeGq2fnjQjvDaviQ4ETskW
	qTuRFLcVVMQ5gC4cq9lzKLvpa3917jSbz2Y33AfB6TMyoSN0KX9Tm5lLSoqTDsIUwJHQ2U
	9HmbCA+qtA7QDofwR9qtwYOgP4YzWWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793017187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8x/Pha56IWNhOsrddTmq/pZ76SoL/4aPw0ZOZYdl3c=;
	b=bPIVkg8muLNlGxPMpANSv4KISl504HLzAIuCVh4G01bsZL1v2codZrC+owpbNw6BWpM/TL
	oxaDTge5kcZ/JNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF01513319;
	Mon, 26 Oct 2026 12:19:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GcfaLWJF32rkLQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 12:19:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6B803A1419; Mon, 26 Oct 2026 13:19:42 +0100 (CET)
Date: Mon, 26 Oct 2026 13:19:42 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, 
	Gabriel Krisman Bertazi <krisman@kernel.org>
Subject: Re: [PATCH 1/2] dcache: don't leave negative dentries in casefolded
 directories
Message-ID: <wpzwcqxtvesslqd54ytn6iacckr23rsqy4ktu7pm5dipcmuc2z@bx4esdjjvaql>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
 <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
X-Rspamd-Queue-Id: 160202215D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -13.01

On Fri 23-10-26 14:44:22, Christian Brauner wrote:
> ext4, f2fs and tmpfs keep negative dentries out of casefolded
> directories. A negative dentry remembers one spelling of the name and
> the next create() through it would write that spelling to disk.
> 
> So their ->lookup() doesn't cache a miss and their ->unlink() and
> ->rmdir() call d_invalidate() on the dentry so that d_delete() doesn't
> turn it into a negative dentry.
> 
> But d_invalidate() is the wrong primitive for that. It's for a name that
> went stale. It walks the subtree, prunes it and detaches every mount it
> finds, under namespace_sem, and here that runs from inside the
> filesystem's own directory operation. ext4_rmdir() does it with the
> journal handle still open and ext4_unlink() does it even when the
> unlink failed. All anyone wanted is the unhash.
> 
> So d_delete() now unhashes the dentry when the parent is casefolded,
> next to the dentry-negative sysctl that does the same for every
> directory. ext4, f2fs and tmpfs drop their d_invalidate() calls.
> 
> Nothing changes for a casefolded directory. A miss still isn't cached
> and a removed name still doesn't leave a negative dentry behind. The
> target of a rename over an existing name, which tmpfs also passes
> through shmem_unlink(), doesn't turn negative either. vfs_rename()
> detaches its mounts and d_move() unhashes it. A failed unlink or rmdir
> now leaves the dentry hashed and its mounts in place, as in any other
> directory.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Yeah, this matches my understanding as well. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dcache.c     |  8 +++++++-
>  fs/ext4/namei.c | 18 ------------------
>  fs/f2fs/namei.c |  9 ---------
>  mm/shmem.c      |  7 -------
>  4 files changed, 7 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index efd9332c8407..f5cbb2e24e53 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2746,6 +2746,12 @@ struct dentry *d_hash_and_lookup(struct dentry *dir, struct qstr *name)
>  	return d_lookup(dir, name);
>  }
>  
> +static __always_inline bool d_delete_drop(struct dentry *dentry)
> +{
> +	return dentry_negative_policy ||
> +	       IS_CASEFOLDED(d_inode(dentry->d_parent));
> +}
> +
>  /*
>   * When a file is deleted, we have two options:
>   * - turn this dentry into a negative dentry
> @@ -2777,7 +2783,7 @@ void d_delete(struct dentry * dentry)
>  	 * Are we the only user?
>  	 */
>  	if (dentry->d_lockref.count == 1) {
> -		if (dentry_negative_policy)
> +		if (d_delete_drop(dentry))
>  			__d_drop(dentry);
>  		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
>  		dentry_unlink_inode(dentry);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6e0630a49e48..c4b1121471e6 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3209,15 +3209,6 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	ext4_fc_track_unlink(handle, dentry);
>  	retval = ext4_mark_inode_dirty(handle, dir);
>  
> -	/* VFS negative dentries are incompatible with Encoding and
> -	 * Case-insensitiveness. Eventually we'll want avoid
> -	 * invalidating the dentries here, alongside with returning the
> -	 * negative dentries at ext4_lookup(), when it is better
> -	 * supported by the VFS for the CI case.
> -	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> -		d_invalidate(dentry);
> -
>  end_rmdir:
>  	brelse(bh);
>  	if (handle)
> @@ -3320,15 +3311,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
>  
>  	retval = __ext4_unlink(dir, &dentry->d_name, d_inode(dentry), dentry);
>  
> -	/* VFS negative dentries are incompatible with Encoding and
> -	 * Case-insensitiveness. Eventually we'll want avoid
> -	 * invalidating the dentries here, alongside with returning the
> -	 * negative dentries at ext4_lookup(), when it is  better
> -	 * supported by the VFS for the CI case.
> -	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> -		d_invalidate(dentry);
> -
>  out_trace:
>  	trace_ext4_unlink_exit(dentry, retval);
>  	return retval;
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 233c07fec171..30f6b8448eee 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -631,15 +631,6 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
>  	if (err)
>  		goto out;
>  
> -	/* VFS negative dentries are incompatible with Encoding and
> -	 * Case-insensitiveness. Eventually we'll want avoid
> -	 * invalidating the dentries here, alongside with returning the
> -	 * negative dentries at f2fs_lookup(), when it is better
> -	 * supported by the VFS for the CI case.
> -	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> -		d_invalidate(dentry);
> -
>  	if (IS_DIRSYNC(dir))
>  		err = f2fs_sync_fs(F2FS_I_SB(dir)->sb, 1);
>  out:
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0d891ade18b5..5a353ac32573 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3953,13 +3953,6 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
>  	inode_inc_iversion(dir);
>  	simple_unlink(dir, dentry);
>  
> -	/*
> -	 * For now, VFS can't deal with case-insensitive negative dentries, so
> -	 * we invalidate them
> -	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> -		d_invalidate(dentry);
> -
>  	return 0;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
