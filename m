Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE293B2FCC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782135359; cv=none; b=qf/+q5bgWdMWmS20OR6t4b8lyYLEO8ue71q0B/fGAnq3+mMa14l/hjgJ0LNOOpBvXyL9hhRPZmEuqIDId6sei9Jad0O3u01+RbCaKfILWrt88Y637tPLYbm9bUb1lg0ZKNG7xvX5ArMxWh0qb2Wllm7PofYffkCSfjAeNkY6jN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782135359; c=relaxed/simple;
	bh=SBvpZlbgi6NWzmSj4Dr0aKTGqCZG+pQtHmST1nh4zYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhTpxl3TkCe8NFBLD0WJms/HaOqCdKk201YiZqJQ/M+vd9J4Vda2uZEKJpDV/fLcVI+e43pUCPECQ6bSbmOdHmxGUH4uQsJJElb1tH+nSK9OGawA/6ktMYfDBmodr5KT1Wjo4ObAH3MwZPAzGVER5loQ4gBVoBJIk+9ROLjl0nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c3IjOeoA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pTObOnwz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aCK/J0Dg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R9Y2ILYW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c3IjOeoA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pTObOnwz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aCK/J0Dg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R9Y2ILYW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D277275CC2;
	Mon, 22 Jun 2026 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782135355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=klHx9ZWC+iv1arsVCPKl7bjBSJ7l+Dg5khZq7zu+UWs=;
	b=c3IjOeoAiqHBStIClfAkdBrQ81syPvT60HMpyaCi8OCJO7SRqMspy88/oqPJPyNe7FfpJD
	Kb6/2PAOfqTrF1WFj63A+c200oC1vNbyoGP/aOf84FEAjzbXYcNWWIoB9QXhwdLGbmP+67
	2pMzcebI1Nmju9mSahIYbkamOn9F28g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782135355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=klHx9ZWC+iv1arsVCPKl7bjBSJ7l+Dg5khZq7zu+UWs=;
	b=pTObOnwzJKLeZNkaE+dbeKEhi3V/oOUzjBkVEYEasSKXX+RDKXM2xiqCox86wO155vzeHo
	Qw/Jz1E2aTjZBUDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782135353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=klHx9ZWC+iv1arsVCPKl7bjBSJ7l+Dg5khZq7zu+UWs=;
	b=aCK/J0DgzlDu0PkQWF53wPRQemLRiciaQEpCAYcnBmb35l5RhbllXz5eReXSW22M/N5M4S
	oDu93z93H60JJ5oSkB0p19x7Iq28s9Q8uJB3nKqu+RGmDFDrWIRWVtOs+Z5m25wrm+YlNT
	JeHcCHymlwqZ+raJ0kFyj6V9N/yY00A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782135353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=klHx9ZWC+iv1arsVCPKl7bjBSJ7l+Dg5khZq7zu+UWs=;
	b=R9Y2ILYW4cwgfwgw0UOJGwlHo6W4aIaPAQKOAYw8Ww+Rf6CRGBYsJiIi/EmVu2qXEVFP0u
	pHijboeLS4BrhHCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6698779A8;
	Mon, 22 Jun 2026 13:35:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rn1tMDk6OWqbLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 13:35:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5C7D7A093E; Mon, 22 Jun 2026 15:35:53 +0200 (CEST)
Date: Mon, 22 Jun 2026 15:35:53 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 01/18] xfs: fix the error unwind in
 xfs_open_devices()
Message-ID: <mz2myo6clekydj7y7vyro3ebzi43irhmzcueypgjv43ra7rcp7@tsgf3enlgvrm>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-1-7df6b864028e@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Tue 16-06-26 16:08:17, Christian Brauner wrote:
> Since the rt and log block devices are closed in xfs_free_buftarg() the
> buftarg owns the device file. The error unwind does not respect that:
> when the log buftarg allocation fails, out_free_rtdev_targ frees the rt
> buftarg - releasing rtdev_file - and then falls through to
> out_close_rtdev and releases it a second time.
> 
> The unwind also leaves mp->m_rtdev_targp and mp->m_ddev_targp pointing
> to the freed buftargs. The failed mount continues into
> deactivate_locked_super() -> xfs_kill_sb() -> xfs_mount_free(), which
> frees them again.
> 
> Clear the buftarg pointers once the unwind freed them and clear
> rtdev_file once the rt buftarg owns it, so nothing is released twice.
> 
> Reachable when a buftarg allocation fails after the data buftarg was
> set up: an I/O error in sync_blockdev() or an allocation failure in
> xfs_init_buftarg() while mounting with external rt and log devices.
> 
> Fixes: 41233576e9a4 ("xfs: close the RT and log block devices in xfs_free_buftarg")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me. As a small nit I'd probably do rtdev_file = NULL just
after we've successfully allocated m_rtdev_targp but that's really minor.
Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/xfs/xfs_super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index eac7f9503805..8531d526fc44 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -534,8 +534,11 @@ xfs_open_devices(
>   out_free_rtdev_targ:
>  	if (mp->m_rtdev_targp)
>  		xfs_free_buftarg(mp->m_rtdev_targp);
> +	mp->m_rtdev_targp = NULL;
> +	rtdev_file = NULL;	/* released by xfs_free_buftarg() */
>   out_free_ddev_targ:
>  	xfs_free_buftarg(mp->m_ddev_targp);
> +	mp->m_ddev_targp = NULL;
>   out_close_rtdev:
>  	 if (rtdev_file)
>  		bdev_fput(rtdev_file);
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
