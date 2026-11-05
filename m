Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870531;
	b=AheyW9LclDeWhe7w2ZZG7vM/KKzxsw7BZRaY9R9J/Kc9OxTIhy9eFFiUuF86nQjswlu+
	 rlH2mtYO+YC9n1PfQKtuSi1HXXOLnW4pruwmk6y0j00R4UHhGe0+nxIy5d21BeU1V+sbl
	 Wnf81g1kbPaVaNceFynHzXuW8pUsGZix2WlQqbhXz40+NvehMDVPZp0cm5MSe+4SkSGP6
	 ST+6BajPW6V1WSv9/wdsSVhoBXTTmA0bNXZav87shVg1Izpvjgp1HE8qma7fsfr+RX3+l
	 hHtwwcKvNxwdJn6lVvhu/CLf1eHUfxRENbqAgi7VyDdDGQE3Miemzx92slv1J7e4FfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870531;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=lgGRQ1zml4Lq93KheFzx2lNRVd/kazla1aVm+l1shTz6YyO0hDd3fplVwfDLcH7fMCWE
	 aW2OblZ6NOE6E3RsZNL7p6fiiGaVrxu77qjMYVJbpM3ebmrtuBP+UmTkaZkba0acs5EID
	 rmfhl6niHzsnvQ69sKTKBDVfIAmjwkNE7JpV68kFg6Vh5P6jzDICpJUID/YREiX+3ilfq
	 qFAZj5QXzGGpNZKNQfAANcZkmmco3gmFy3e5xqQbZ+HpPV5d0fSdoBjee/lwHBWAaK25t
	 O5AyTpb1JenLYe289BSprXzZzWFYVIwexNNDL6Yp/JdUHKs0DbrT9a20MAd+gNj4gbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n50o8Nho;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEObjVwj;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2cOYoXtK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xNpdsHrD;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E8F606A326;
	Thu,  5 Nov 2026 09:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97E8F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n50o8Nho;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEObjVwj;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2cOYoXtK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xNpdsHrD
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1BB621E6B;
	Thu,  5 Nov 2026 09:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793870529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=n50o8NhoUcr4RCi/B4rIsia/X2BPL0xvAZqFp6JcVaXbZfzT/RTxiBntW4h00kVQGa6Adw
	BoZgFvLF8XedTFomzkc3T1PyMdrQx7jS1R9+mgt1K6CyVCzEcEHQMaqYV1coIn8BosvIE6
	1mdP0qlalo/s/vwRKzpCaU5hyRKm15E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793870529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=vEObjVwj9IoYCWGtblG300EgQss9NlqG2oQadAEYX85TWpmXLFO3Kp4hDBJ5PF1rLfqJsZ
	UQBKm7Amz6f/XsBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793870528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=2cOYoXtKQsnGxKetXHmlYmsgdtzx4dKmzc4TKkHro1fVmuXVkT6aeMOQnia12G6yDV2PP8
	3d1d5nW7OM8023OYjhcxzn4r5MBadUUW/5fKMphJggjyFhvt6zOxv0YmYZBEEwDfWpx6eG
	o2RmagT5J5MIADePkoerRdmpGGEJ0aw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793870528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=xNpdsHrD+svQDtDWU8bkw0RsFYdBqvO0lz4aSu1a0Q9BoRVeC++GKGYW8dvo9pxsLw8pv9
	oK8gPfGxFQDXWCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C188F134F4;
	Thu,  5 Nov 2026 09:22:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0RUpJ79K7GoMZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 09:22:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 52E39B65F; Thu, 05 Nov 2026 10:22:07 +0100 (CET)
Date: Thu, 5 Nov 2026 10:22:07 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
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
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.com,zeniv.linux.org.uk,lists.sourceforge.net,lists.linux.dev,kvack.org,lists.infradead.org,gmail.com];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 29-10-26 17:06:55, Christian Brauner wrote:
> With errors=remount-ro ext2_error() sets SB_RDONLY from whatever context
> hit the error and without holding s_umount. That races with everyone
> else changing sb->s_flags and it breaks freezing. If it happens while
> the filesystem is frozen thaw_super() sees a read-only superblock and
> leaves the s_writers rwsems locked so every writer hangs. A lookup in a
> corrupted directory is enough. Karl proposed teaching thaw_super() about
> it but Jan preferred fixing the filesystems (cf. [1]) like ext4 and f2fs
> already did.
> 
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. ext2 still refuses allocations, ext2_write_inode(),
> ext2_sync_fs() and ext2_xattr_set() itself. The superblock isn't written
> after the error is recorded and unlinked inodes are left to e2fsck.
> ext2_handle_dirsync() treats EROFS as success in that state because the
> entry was already changed.
> 
> A remount to read-write fails until umount and writes through file
> descriptors opened before the error fail with EROFS.
> 
> [1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf
> 
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Nothing critical but couple of points for discussion:

> @@ -1287,6 +1287,10 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
>  
> +	/* Nothing may be written after an error made us read-only. */
> +	if (sb_emergency_ro(sb))
> +		return 0;
> +

So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
use also sb_emergency_ro() and don't bother with modifying individual
filesystems?

> @@ -1307,6 +1311,9 @@ static int ext2_freeze(struct super_block *sb)
>  {
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  
> +	if (sb_emergency_ro(sb))
> +		return 0;
> +

Also if we have the check in sync_filesystem(), then freeze_super() is
generally going to fail so this check could trigger only if
sb_emergency_ro() was set after sync_filesystem() ran and before we called
->freeze_fs(). Since sb_emergency_ro() checking is pretty much guaranteed
to be racy (it is just a best effort framework to limit damage), we
probably don't have to bother with checking in ->freeze_fs() handlers.

> @@ -1349,7 +1356,9 @@ static int ext2_reconfigure(struct fs_context *fc)
>  	int flags = fc->sb_flags;
>  	int err;
>  
> -	sync_filesystem(sb);
> +	/* Nothing may be written after an error made us read-only. */
> +	if (!sb_emergency_ro(sb))
> +		sync_filesystem(sb);

If there's a check in sync_filesystem(), this change can go away.

> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 8f608930a48c..12dfffff189c 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
>  	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
>  		  name_index, name, value, (long)value_len);
>  
> +	if (sb_emergency_ro(sb))
> +		return -EROFS;

Is this really needed? All the xattr operations go through mnt_want_write()
/ mnt_want_write_file() so this should be caught in VFS...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
