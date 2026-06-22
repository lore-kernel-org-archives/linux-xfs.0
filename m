Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929401E5207
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146100; cv=none; b=YIFgl4zdgucHUuGtDhyBI+F+lHZBPWeOqsBcID/mwpG0i+EB9SZ1xYRYiTU6/ADg2tLhuB/chnsfmZfrN/0pAYafzeMA341VwMlZpuoAQa3zpYuHYWrlrCBgg7odSNhabcsAG+OvszutpwOm07BtdF6iF2uHbjSMuhnA96HqGX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146100; c=relaxed/simple;
	bh=+VaXmzuGs7ZjB1hzOKV8Tf7ychJO6jd2T5191/5djeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8J8yu9d9uXfr5lwyiF0mdegoXuJqu8M2/i6egNOi6rPALCiQX9Ll6KpxGGSXoo7wdyPV42pHzTtPg+YSMHYDADRTm2e0Dlt2Jca0oHl3uT4yylgy4HwYRZGY0xekMfaSkouk3+Z2ftNPR786SHQ1jpAslhcooYcK4zOl6TBtvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wttf5jNj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yf5ZI00v; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Sc6A4Dw/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vwqQhrF0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wttf5jNj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yf5ZI00v";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Sc6A4Dw/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vwqQhrF0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD9CD75B12;
	Mon, 22 Jun 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782146097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zOyzIKJqX7tZFMtlqztdiIbczyvu/PCMQorXmmY+s9w=;
	b=Wttf5jNjQA9DKN6ckwrKQGIE2piT+zrUI8ktk1AaEcq4AjCir3O3KjiLBTfhcvVN33l2i5
	r6ezZQC/RENxOtoNaFMmsWcGPubbPZKoGFBAkUlB6zd+YahkQsjGXUQoOgRazL3G6Opv6b
	iFHcDj85S+palLxzUQE0yil/Wmn+nGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782146097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zOyzIKJqX7tZFMtlqztdiIbczyvu/PCMQorXmmY+s9w=;
	b=yf5ZI00vPNh0BcAOmLoS1qx84bokNY9IUkRbKtaAbDcQMyWGvZK32r9i+5OEwLCC0Gqjqe
	qBVXFs8oRrvCeCDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Sc6A4Dw/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vwqQhrF0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782146096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zOyzIKJqX7tZFMtlqztdiIbczyvu/PCMQorXmmY+s9w=;
	b=Sc6A4Dw/TGIsMWPgC/z20PyGSzMZXPLnPzOtCPbOPpomuS41q/qQZv748sXOU0aVeINc0t
	FQHPIqksKweksAUy3y6mHZaXHcqK4kCUMOx2IAvNXGDdlwHZ1VyIZQWjOj5WsytX+746Pk
	meg+eE6S+ZWhqCSFLshWQ247Uoc6WHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782146096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zOyzIKJqX7tZFMtlqztdiIbczyvu/PCMQorXmmY+s9w=;
	b=vwqQhrF0Eqf2paPnD2EIyxxgK0g+9g5ihen5K17JO9lQ61F2qmftn9ds+5MsCdWo77MNwq
	ghsmUf9Z20qn0qBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1FB2779A8;
	Mon, 22 Jun 2026 16:34:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D0dyKzBkOWrZWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 16:34:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EB2EA093E; Mon, 22 Jun 2026 18:34:56 +0200 (CEST)
Date: Mon, 22 Jun 2026 18:34:56 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open helpers
 for filesystems
Message-ID: <7unybrw7f6nmn5nfxiaxgqm2reneybunc6nha256oez6siixkg@qzdhk474mx7h>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
 <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org>
 <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BD9CD75B12
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
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 22-06-26 18:28:50, Jan Kara wrote:
> On Tue 16-06-26 16:08:24, Christian Brauner wrote:
> > Add fs_bdev_file_open_by_{dev,path}() and fs_bdev_file_release(). They
> > open the device with fs_holder_ops and register a claim in the
> > device-to-superblock table. Claims on the same (device, superblock)
> > pair share one entry, so when a filesystem claims a device it already
> > uses (xfs with its log on the data device), no second entry is added
> > and each superblock will be acted on once.
> > 
> > The holder argument remains purely the block layer's exclusivity token:
> > a superblock, or a file_system_type for a device shared by several
> > superblocks of that type. The shared case only becomes usable once the
> > fs_holder_ops callbacks resolve superblocks through the table instead
> > of bdev->bd_holder.
> > 
> > Convert the main device, setup_bdev_super() and kill_block_super(),
> > over: the open finds the entry registered by sget_fc() and claims it
> > again. cramfs and romfs bypass kill_block_super() so they can handle
> > MTD mounts and release the main device with a plain bdev_fput(), which
> > would leave the claim behind: the (dev, sb) entry would never be
> > unregistered and the passive reference it holds would keep the
> > superblock alive forever. Convert their release paths in the same
> > step.
> > 
> > The frozen-device check stays in setup_bdev_super() for the primary
> > device and is added to fs_bdev_register() for new claims, i.e. every
> > additional device a filesystem opens through the helpers. Only a
> > (device, superblock) pair the superblock claimed earlier may be
> > reopened while frozen (xfs with its log on the data device): the freeze
> > already covers that superblock through the existing claim, so nothing
> > escapes it. Without the setup_bdev_super() check a device frozen before
> > the mount even started (dm lock_fs, loop) could be mounted and written
> > to (journal replay) under an active freeze, because the primary open
> > reuses the entry registered by sget_fc() and never takes the new-claim
> > path.
> > 
> > Both checks read bd_fsfreeze_count only after the entry is published
> > (by sget_fc() for the primary, by fs_bdev_register() for new claims)
> > and pair with bdev_freeze() incrementing the count before walking the
> > table: either the mount sees the elevated freeze count and fails with
> > EBUSY, or the freeze finds the published entry and converges once
> > SB_BORN is set.
> > 
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

...

> > +/**
> > + * fs_bdev_file_release - release a block device claimed for a superblock
> > + * @bdev_file: file returned by fs_bdev_file_open_by_{dev,path}()
> > + * @sb: superblock the device was claimed for
> > + *
> > + * Drop one claim on the {dev, @sb} entry; the last claim unregisters it (a
> > + * pinning cursor defers the actual unlink).  Then close the block device.
> > + */
> > +void fs_bdev_file_release(struct file *bdev_file, struct super_block *sb)
> > +{
> > +	dev_t dev = file_bdev(bdev_file)->bd_dev;
> > +	struct super_dev *sb_dev;
> > +
> > +	rcu_read_lock();
> > +	sb_dev = super_dev_lookup(dev, sb);
> > +	rcu_read_unlock();
> > +	super_dev_put(sb_dev);
> > +	bdev_fput(bdev_file);
> > +}
> > +EXPORT_SYMBOL_GPL(fs_bdev_file_release);
> 
> Why don't you use sb->s_super_dev in this function?

Nevermind, I've realized sb can hold multiple bdevs so this is really
needed.

I'd still prefer the __free handling in fs_bdev_register() sorted out but
regardless feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
