Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675A23B3893
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529453; cv=none; b=LBPpp/VE5ygpFCcdM+qaK/ojdM+FWYPebAHNKivhr8ZDk+sNFklydT0OLlDUhwlEyn04EcXUB7VuE3Kp7vGCOnFGH/uFtwV2Vlzgmus+WkjgPzO+oYscfN641tJozFn/rarDCFYjuUXM7221c118+bWQLemrU+7AgUCiOizfCbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529453; c=relaxed/simple;
	bh=sxV8qJN9auKTPlL5YtnThwxmlkp68g3zFX+rcxhPfQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+zoUvanSDOD6Z46BIJEDPwFTTkzDYz0tt3RVO5c98lmEHxaX9fsK0AOJUsL46wcCSTJxOgdJgDvSa0W5fWMhjX4wL8lezzhF8j2+6KOL9r3aUTuBCTjJGmGVuCkdF7iGBJCNx/NGGDsGBmSzuYbXy3ZQcvRSr4wNijp5PGmUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RGcP2c+x; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s0KUO/GI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RGcP2c+x; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s0KUO/GI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RGcP2c+x";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s0KUO/GI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RGcP2c+x";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s0KUO/GI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4FD0075ABF;
	Mon, 15 Jun 2026 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781529450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uv8IPf6skenuMT7p9mPdAVsyScDMwwJt8Kiedh2MkwQ=;
	b=RGcP2c+x9eZ42Gt+1x9wknGtatuI6Bnw2lCSN83Y7WSVE4c7lrXelM4niozeiuv0AL60AS
	RVcv8ETIEHiQWfJUXu6thwrh1vGZz+/MRz3+pN3pX8rEzRo5NvoSvAt5wwDiPnr+q6z8GP
	jBpAalQcfE5e/xclzhpeu7VWvk60nRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781529450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uv8IPf6skenuMT7p9mPdAVsyScDMwwJt8Kiedh2MkwQ=;
	b=s0KUO/GIDk9rEGnSrDw1+nZSES8372IGKHe22X4ECF7gbZ48K5RmVRgvzqG2Tp1uvwM0rm
	kSaQysxLuxKSMYAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RGcP2c+x;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="s0KUO/GI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781529450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uv8IPf6skenuMT7p9mPdAVsyScDMwwJt8Kiedh2MkwQ=;
	b=RGcP2c+x9eZ42Gt+1x9wknGtatuI6Bnw2lCSN83Y7WSVE4c7lrXelM4niozeiuv0AL60AS
	RVcv8ETIEHiQWfJUXu6thwrh1vGZz+/MRz3+pN3pX8rEzRo5NvoSvAt5wwDiPnr+q6z8GP
	jBpAalQcfE5e/xclzhpeu7VWvk60nRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781529450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uv8IPf6skenuMT7p9mPdAVsyScDMwwJt8Kiedh2MkwQ=;
	b=s0KUO/GIDk9rEGnSrDw1+nZSES8372IGKHe22X4ECF7gbZ48K5RmVRgvzqG2Tp1uvwM0rm
	kSaQysxLuxKSMYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45ADB779A7;
	Mon, 15 Jun 2026 13:17:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wI78EGr7L2ruJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 13:17:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DE192A12D2; Mon, 15 Jun 2026 15:17:29 +0200 (CEST)
Date: Mon, 15 Jun 2026 15:17:29 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, aalbersh@redhat.com, cem@kernel.org, 
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, ailiopoulos@suse.com
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <ptb5fg2wmlanfsvwawgcye6a2ezevrdnxfq4oxhwoialvgfjld@is3nzrdegqzk>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219114405.31521-6-lukas@herbolt.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4FD0075ABF
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[herbolt.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu 19-02-26 12:44:09, Lukas Herbolt wrote:
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

During our performance testing we have noticed that this patch changes the
size of log stripe unit on a disk behind megaraid_sas controller from 4k to
64k (which is understandable as the disk reports 64k minimum_io_size). This
actually causes a performance regression (about 40%) for dbench with 1
client as it is very fsync-heavy and thus commits lots of tiny transactions
and with larger log blocks the logging overhead just seems larger. dbench
is kind of pathological load but I assume other more relevant fsync
intensive loads could experience a regression as well.

I think one of the reasons why 4k log IO actually ends up performing better
with this disk is that the controller has a battery backed cache (a few GB
large) and thus it's able to absorb smaller log writes and merge them into
properly sized IO so larger half-empty log blocks are just pure overhead
for it.

This commit sadly doesn't contain any quantification how bad small log IO
is for 4kN or 512e drives so that one could weight it against the
regression for higher-end storage. Anyway, I'm not sure something needs to
be done here as there likely isn't a value that works for everyone. I just
wanted to provide a data point that this isn't a universal win and maybe it
needs to be considered what's the most sensible default.

								Honza


> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76..1b6334e9adce 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3647,7 +3647,7 @@ check_lsunit:
>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>  
> -	if (lsu) {
> +	if (cli->lsu) {
>  		/* verify if lsu is a multiple block size */
>  		if (lsu % cfg->blocksize != 0) {
>  			fprintf(stderr,
> -- 
> 2.53.0
> 
> >From 2771375662c9edce25d7268bc71cc6db35a0d5c7 Mon Sep 17 00:00:00 2001
> From: Lukas Herbolt <lukas@herbolt.com>
> Date: Fri, 26 Sep 2025 12:48:39 +0200
> Subject: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
> 
> Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
> As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
> and so we set lsu to blocksize. But we do not check the the size if
> lsunit can be bigger to fit the disk geometry.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76..1b6334e9adce 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3647,7 +3647,7 @@ check_lsunit:
>  	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
>  		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
>  
> -	if (lsu) {
> +	if (cli->lsu) {
>  		/* verify if lsu is a multiple block size */
>  		if (lsu % cfg->blocksize != 0) {
>  			fprintf(stderr,
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
