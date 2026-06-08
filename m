Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C463BAD90
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 10:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912872; cv=none; b=fDI8+YhXaTHH6f/zauSa1fluQOfTKkYgsVedlYBFzzMkZ/95GI0FolcBqnVERad6ynPZQL8MF6kZ8MaghKpbzxrICYNOEdPHSBDq8DLyStsjf6pnpjoViTCGEnVnBt3MdMclY49QhGHQ3PdBXa5KZDzghgj2k2yc2riGFrFGMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912872; c=relaxed/simple;
	bh=BawfdQdMn6uLn01Tl+RSyS3F3+nS9BE/E7dlkGh9I2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPFFzvx4n9MjkLOnXraNNi5RitNnQoii8yhDSJo554wCjKiBLk9BE4nhtTyOlCK/gIuHj2/rHAVVxh+yWtexOjvYkXU94HrcvEYikCN1vqbcgz/rOU0kK2SedeJgdp/B+g9bYGqKYs4K90YoD+hEb1uSxVnXuzRkzkwyXt102GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rRGiR2I3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uTb/eIj1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rRGiR2I3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uTb/eIj1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rRGiR2I3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uTb/eIj1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rRGiR2I3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uTb/eIj1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B826A67C9D;
	Mon,  8 Jun 2026 10:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780912869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIDE+rHXoUrjVltLbrUUw2XWHk0UZNkmIFDDfUGj8p0=;
	b=rRGiR2I3YRUllXedB6of680cGQ8l8kLSW/ZGz+GDOxHgQQ9p4XjrcZ0nrv7fv71dPjCqvx
	y/Ptq2nOSFOByR4kX3ci4W6gGhOIhVUZbF7Q1GAfH4iAImUjk2tCwLgFky6z8BYNJnb8Pe
	xJCPN5urKkFhy9Xpbj9Hdnp2L7zKXFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780912869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIDE+rHXoUrjVltLbrUUw2XWHk0UZNkmIFDDfUGj8p0=;
	b=uTb/eIj16FpASc44P3EjTeP4SHzsflhbLmYs6/N68mpyrKvRFd20/GoFyJXifi7QR1dgW9
	ALaTxzDXN+BM0YDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780912869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIDE+rHXoUrjVltLbrUUw2XWHk0UZNkmIFDDfUGj8p0=;
	b=rRGiR2I3YRUllXedB6of680cGQ8l8kLSW/ZGz+GDOxHgQQ9p4XjrcZ0nrv7fv71dPjCqvx
	y/Ptq2nOSFOByR4kX3ci4W6gGhOIhVUZbF7Q1GAfH4iAImUjk2tCwLgFky6z8BYNJnb8Pe
	xJCPN5urKkFhy9Xpbj9Hdnp2L7zKXFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780912869;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIDE+rHXoUrjVltLbrUUw2XWHk0UZNkmIFDDfUGj8p0=;
	b=uTb/eIj16FpASc44P3EjTeP4SHzsflhbLmYs6/N68mpyrKvRFd20/GoFyJXifi7QR1dgW9
	ALaTxzDXN+BM0YDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF226779A7;
	Mon,  8 Jun 2026 10:01:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U/aqKuWSJmoDJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 08 Jun 2026 10:01:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5B6AFA10CB; Mon, 08 Jun 2026 12:01:09 +0200 (CEST)
Date: Mon, 8 Jun 2026 12:01:09 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 3/8] fs: refuse to claim any frozen block device
Message-ID: <tm5nvcqgcyi37gpjvayettp22wkovzk3wr5wj5mcmmkmygj5f5@teavlw6bbmwf>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-3-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-3-bb0fd82f3861@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Tue 02-06-26 12:10:09, Christian Brauner wrote:
> setup_bdev_super() already refuses to bring a filesystem up on a frozen
> block device but only for the primary device. Now that filesystems claim
> every device through fs_bdev_file_open_by_{dev,path}(), do that check
> once in the registration helper so it covers all of them.
> 
> Drop the now-redundant check from setup_bdev_super().
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/super.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index e0174d5819a0..cea743f699e4 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1690,6 +1690,17 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>  	sb->s_count++;
>  	spin_unlock(&sb_lock);
>  
> +	/*
> +	 * Don't bring a filesystem up on a frozen device.  The entry is already
> +	 * published, so a freeze either is seen here or finds it and waits in
> +	 * super_lock() until this mount is born or (on -EBUSY) dies.  The mount
> +	 * aborts, so the entry is torn down without rebalancing @fs_bdev_active.
> +	 */
> +	if (atomic_read(&file_bdev(bdev_file)->bd_fsfreeze_count) > 0) {
> +		fs_bdev_holder_put(h);
> +		return -EBUSY;
> +	}
> +
>  	return 0;
>  }

Shouldn't this check be common also for the branch where we only increase
the refcount? Or is a filesystem where a superblock claims the bdev
multiple times and can get frozen inbetween too insane?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
