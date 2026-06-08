Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD43B8949
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780913888; cv=none; b=i6l8EHEED/svOwshuRNnmW55+93HNuBXX4dgLb09N+oIVFI1an2P+babWhT2fms+WrWOpXET/msDEDZucKY3hA+JHhz17KALO/CFLEvQ/Q5npMEfwlAecaistxv+bMRgAfVxtleo5/4i9AUSbcGKdbSsvyHNJLBFn5OZG6Sv7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780913888; c=relaxed/simple;
	bh=+vJkmp4C3XlZYFZfEeyLQKamVxmfugyidKr8YR0Ow08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSwXuL9/dspwX1mcZS+7/XXyLCW1iVD8Z4BD0z0IYjcr/OLPYhQYS+U/bKRtXRIkadQjwNL/6O3bRAcmAy8ggPNxmeWQi+EKKP/amXSGEGMkPSEKpZCCKmwRm2kj1CxEvmy2r32MP3rmSk4Ev215tdi6SuOMdwG9SCYdpoNw6rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NJpsHcgc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bP1sP+/0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NJpsHcgc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bP1sP+/0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NJpsHcgc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bP1sP+/0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NJpsHcgc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bP1sP+/0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 493956A820;
	Mon,  8 Jun 2026 10:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+P/SGInmge1PUgMS6/ZkCwa3FAhBuIhcTsFMTk/iewM=;
	b=NJpsHcgcsTDNF58Wy2B9nzIcD14NidTbbiHN7S5u91aiHiZvl4SgEPYsrn78zSkGKqYFmk
	owlE6Wmt5mznafdnRIt1lzLwWC2E4kUfFMfqTWncNpw0iy1ufnwq8ouyOXk8BcuHRVxYQE
	DIIVJx3c4Sp0bW7SFmhz3vi8yJY4Pgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+P/SGInmge1PUgMS6/ZkCwa3FAhBuIhcTsFMTk/iewM=;
	b=bP1sP+/06jCIGDvnwuERo94xTadz9C41rILuQSitQ5M669eS0vQh2LVOCMHjGq4aPa5EXX
	39TwzaVZ4478PMDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NJpsHcgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="bP1sP+/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780913885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+P/SGInmge1PUgMS6/ZkCwa3FAhBuIhcTsFMTk/iewM=;
	b=NJpsHcgcsTDNF58Wy2B9nzIcD14NidTbbiHN7S5u91aiHiZvl4SgEPYsrn78zSkGKqYFmk
	owlE6Wmt5mznafdnRIt1lzLwWC2E4kUfFMfqTWncNpw0iy1ufnwq8ouyOXk8BcuHRVxYQE
	DIIVJx3c4Sp0bW7SFmhz3vi8yJY4Pgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780913885;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+P/SGInmge1PUgMS6/ZkCwa3FAhBuIhcTsFMTk/iewM=;
	b=bP1sP+/06jCIGDvnwuERo94xTadz9C41rILuQSitQ5M669eS0vQh2LVOCMHjGq4aPa5EXX
	39TwzaVZ4478PMDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E41C779A7;
	Mon,  8 Jun 2026 10:18:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BjcuD92WJmosOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 10:18:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D58CDA10CB; Mon, 08 Jun 2026 12:18:04 +0200 (CEST)
Date: Mon, 8 Jun 2026 12:18:04 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 6/8] ext4: open via dedicated fs bdev helpers
Message-ID: <345z27gledmbem3lin7s67gt3ifna5n3mpedjlflur572u2gjp@nqcbdyaramp3>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-6-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-6-bb0fd82f3861@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 493956A820
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
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue 02-06-26 12:10:12, Christian Brauner wrote:
> Route opens through fs_bdev_file_open_by_path() so each external device
> is registered against the correct superblock, and convert the matching
> releases.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..8108d999008e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5793,7 +5793,7 @@ failed_mount8: __maybe_unused
>  	brelse(sbi->s_sbh);
>  	if (sbi->s_journal_bdev_file) {
>  		invalidate_bdev(file_bdev(sbi->s_journal_bdev_file));
> -		bdev_fput(sbi->s_journal_bdev_file);
> +		fs_bdev_file_release(sbi->s_journal_bdev_file, sb);
>  	}
>  out_fail:
>  	invalidate_bdev(sb->s_bdev);
> @@ -5972,9 +5972,9 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
>  	struct ext4_super_block *es;
>  	int errno;
>  
> -	bdev_file = bdev_file_open_by_dev(j_dev,
> +	bdev_file = fs_bdev_file_open_by_dev(j_dev,
>  		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
> -		sb, &fs_holder_ops);
> +		sb, sb);
>  	if (IS_ERR(bdev_file)) {
>  		ext4_msg(sb, KERN_ERR,
>  			 "failed to open journal device unknown-block(%u,%u) %ld",
> @@ -6034,7 +6034,7 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
>  out_bh:
>  	brelse(bh);
>  out_bdev:
> -	bdev_fput(bdev_file);
> +	fs_bdev_file_release(bdev_file, sb);
>  	return ERR_PTR(errno);
>  }
>  
> @@ -6073,7 +6073,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
>  out_journal:
>  	ext4_journal_destroy(EXT4_SB(sb), journal);
>  out_bdev:
> -	bdev_fput(bdev_file);
> +	fs_bdev_file_release(bdev_file, sb);
>  	return ERR_PTR(errno);
>  }
>  
> @@ -7492,7 +7492,7 @@ static void ext4_kill_sb(struct super_block *sb)
>  	kill_block_super(sb);
>  
>  	if (bdev_file)
> -		bdev_fput(bdev_file);
> +		fs_bdev_file_release(bdev_file, sb);
>  }
>  
>  static struct file_system_type ext4_fs_type = {
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
