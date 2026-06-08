Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D226338910
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913749; cv=none; b=XtBC925B9Ktm43HmafBkAW6iFCvmLre9kIy56Pfp7843dwjrKuM/6MzF8+Jhw5/S7hGNcpTrt6KRD+dsfuqsqjymNhsr9UYgMs4PPln3FHgaGyHfzhf/cMnU2vjgIt8tAkcmQ9uamMfFVjKmHqA3+O7qCC1ZGZ+8jsdLhbOPEIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913749; c=relaxed/simple;
	bh=yh5qAjaVN0EzuIaI6oJHNgM42nB/qSl/1lEp+q2IynQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P53uNDbf+CKR3rOjSKWtSUUq9si9DXndLspNPYDsjlshKi5ZotSBVeQNW9q4m4oJHBE0nuYox5iBWmgB1n9kxeVdTUe6zuuANxQGqagPSyBUj2+1GxxaXuYFy0QBisrqXJVemqzIgx1UCoJXBY4NxpquInjTO/hxt1iH8GJYemU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gdm+VXTX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7w/dJW3n; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gdm+VXTX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7w/dJW3n; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gdm+VXTX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7w/dJW3n";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gdm+VXTX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7w/dJW3n"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 638DB6A7C1;
	Mon,  8 Jun 2026 10:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibD9Jz6QCBGfSwHuXe3bIKMHyOrx2qpjm8SibEUza44=;
	b=Gdm+VXTXgrXC9GqQWupyTSVjOWVRRbGWnrXWGmWuZxXRvwIAm7LdotifuHopidYFPNJu9B
	L/7UNFV+mGpvwRWHAjhwv9Wj2AHIMyesIcreKA/EbN2jtboJEIdKwpilbWgGXKUFenuhTf
	6RyarxzUoUKThz/hAuhu9gYaknXZEUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibD9Jz6QCBGfSwHuXe3bIKMHyOrx2qpjm8SibEUza44=;
	b=7w/dJW3nV2PS4azYFFwsCQIekDLJOW1tVTgUhwhY4z2Gr8fYKxHQnNo/6HYGJ/OINKesST
	FgRWaAJVldxBLZBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gdm+VXTX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="7w/dJW3n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibD9Jz6QCBGfSwHuXe3bIKMHyOrx2qpjm8SibEUza44=;
	b=Gdm+VXTXgrXC9GqQWupyTSVjOWVRRbGWnrXWGmWuZxXRvwIAm7LdotifuHopidYFPNJu9B
	L/7UNFV+mGpvwRWHAjhwv9Wj2AHIMyesIcreKA/EbN2jtboJEIdKwpilbWgGXKUFenuhTf
	6RyarxzUoUKThz/hAuhu9gYaknXZEUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ibD9Jz6QCBGfSwHuXe3bIKMHyOrx2qpjm8SibEUza44=;
	b=7w/dJW3nV2PS4azYFFwsCQIekDLJOW1tVTgUhwhY4z2Gr8fYKxHQnNo/6HYGJ/OINKesST
	FgRWaAJVldxBLZBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58082779A7;
	Mon,  8 Jun 2026 10:15:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QEJ7FVKWJmpJNgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 10:15:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1659FA10CB; Mon, 08 Jun 2026 12:15:46 +0200 (CEST)
Date: Mon, 8 Jun 2026 12:15:46 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Message-ID: <eqckzzcpsb2ln6teneufzm7ki6q7ow3dam3ss3j2iwiqtv3vvq@sw4h3dtwva33>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MISSING_XM_UA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 638DB6A7C1
X-Spam-Score: -4.01

On Tue 02-06-26 12:10:10, Christian Brauner wrote:
> Route opens through fs_bdev_file_open_by_path() so each external device
> is registered against mp->m_super, and convert the matching releases.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xfs/xfs_buf.c   |  2 +-
>  fs/xfs/xfs_super.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 580d40a5ee57..3d3b29edb156 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1601,7 +1601,7 @@ xfs_free_buftarg(
>  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>  	/* the main block device is closed by kill_block_super */
>  	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
> -		bdev_fput(btp->bt_file);
> +		fs_bdev_file_release(btp->bt_file, btp->bt_mount->m_super);
>  	kfree(btp);
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f8de44443e81..304667210695 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -400,8 +400,8 @@ xfs_blkdev_get(
>  	blk_mode_t		mode;
>  
>  	mode = sb_open_mode(mp->m_super->s_flags);
> -	*bdev_filep = bdev_file_open_by_path(name, mode,
> -			mp->m_super, &fs_holder_ops);
> +	*bdev_filep = fs_bdev_file_open_by_path(name, mode,
> +			mp->m_super, mp->m_super);
>  	if (IS_ERR(*bdev_filep)) {
>  		error = PTR_ERR(*bdev_filep);
>  		*bdev_filep = NULL;
> @@ -526,7 +526,7 @@ xfs_open_devices(
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  		/* Handle won't be used, drop it */
>  		if (logdev_file)
> -			bdev_fput(logdev_file);
> +			fs_bdev_file_release(logdev_file, mp->m_super);
>  	}
>  
>  	return 0;
> @@ -538,10 +538,10 @@ xfs_open_devices(
>  	xfs_free_buftarg(mp->m_ddev_targp);
>   out_close_rtdev:
>  	 if (rtdev_file)
> -		bdev_fput(rtdev_file);
> +		fs_bdev_file_release(rtdev_file, mp->m_super);
>   out_close_logdev:
>  	if (logdev_file)
> -		bdev_fput(logdev_file);
> +		fs_bdev_file_release(logdev_file, mp->m_super);
>  	return error;
>  }
>  
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
