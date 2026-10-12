Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2049891F;
	Mon, 12 Oct 2026 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823132; cv=none; b=qpAn88m9LhovaTFdmjitBQEXA2BDPEVi1yl7vGYSTPwqrR0QTjCfO+DBne6rxUtuLFkNnIIVSu/bQagzEvgwuIw/Nd1VaJh2X9i0ZDm9I6HlIzmxRq5NF6xjSl0H6LuU7joPbMcLQAPhsldFQhCUowDHqItMlfF8HyLMWnO8r34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823132; c=relaxed/simple;
	bh=+2zdQ6S4ZsYD0E7MfH1iCkQfbZPh5zhOEsI2jTjK14o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ns07bHiMVl/2/Oo50StRnCmB0tSs0+Ei5EQEMTV5ufOCyXLK2S/qdhVsaoJ9x3HUgI/MHqKoWiNw1pnqatHJhG8+JiJ5BHh/fvAuRSLluJCsgrFI/BBpbFHWoNeR7bN0zW3KK4WPWFyINX/FNRWEtOAV5w2f/+vKxH2io9dxdCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D19Ab7zG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Zi758xX8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Uwbarloh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zX03xJjP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D19Ab7zG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Zi758xX8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Uwbarloh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zX03xJjP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED90D1F38E;
	Mon, 12 Oct 2026 16:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791823129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csrmG+kg/7i2sj29GJ6UcgK7Fx1EjcFlYaUAqC5zM2M=;
	b=D19Ab7zGWgRqxioTti68cMnegodC9NqI0OopT4947r94LjuQC+4DGht2l7mlLuXrBtlYIZ
	/xSpUt9uifLoRh0cu0NUqff8Gp8pHp7mwgkcOVdBt/YQFz481xH4/92RqDir0mL+l18Pxz
	9e0kY5zo/7jMeI0EMFYoT3EtqJk9AbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791823129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csrmG+kg/7i2sj29GJ6UcgK7Fx1EjcFlYaUAqC5zM2M=;
	b=Zi758xX81PlX2RSwZxqO3OZBz3oCy9UBz1ZwquSPybFAAm3bUnjz3K4iWM34CM8c9JsaTO
	lJcvK4Pj9LT9qDBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791823128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csrmG+kg/7i2sj29GJ6UcgK7Fx1EjcFlYaUAqC5zM2M=;
	b=UwbarlohlE0rKOf1x1aOkm3laMKzkLWLDBAqhPJRvV8TFLqe1gDUcxy96AitoZ+yX3yq/J
	7mn3JaxBa0C/wvjcASGtwuHz038plwYUWILfzRTOOo1BHvBaZq4ohSb94PDkyFHj7nYvd4
	z3rHRGpL16kuCbeNBTeaevmUgaP4MsI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791823128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=csrmG+kg/7i2sj29GJ6UcgK7Fx1EjcFlYaUAqC5zM2M=;
	b=zX03xJjPAFTgWUzEwQJV/VKuyXvputpOMDcHpO8U5UmdbyT4odqDFaHUkDYR8+Qw+6erAp
	fgoikpd6NSKXYXBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C558913314;
	Mon, 12 Oct 2026 16:38:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id debgJxgNzWr0XgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 16:38:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58B75A1405; Mon, 12 Oct 2026 18:38:48 +0200 (CEST)
Date: Mon, 12 Oct 2026 18:38:48 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 25/28] ext4: allow remounting read-only in the
 emergency state
Message-ID: <ixl4z4jusef2ou62hzqecfc4s7c45xx5slrwdhuzb6wctuia6b@i7hccjzpa433>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-25-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-25-60743a3dc326@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Mon 12-10-26 12:21:10, Christian Brauner wrote:
> __ext4_remount() refuses any change of the read-only state with -EROFS
> while ext4_emergency_state() is set, i.e. after FS_IOC_SHUTDOWN, after
> an error with errors=remount-ro or after an error that forces the
> filesystem read-only like ext4_abort(). None of them sets SB_RDONLY
> anymore. So a plain remount to read-only fails and the filesystem stays
> read-write.
> 
> And emergency remount (sysrq u) asks every read-write superblock on a
> block device to go read-only with SB_FORCE. ext4 refuses that too and
> reconfigure_super() warns before it sets SB_RDONLY anyway:
> 
>   EXT4-fs (vda): Remounting filesystem read-only
>   sysrq: Emergency Remount R/O
>   forced remount of a ext4 fs returned -30
>   WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#3: kworker/3:1/50
>    do_emergency_remount_callback+0xc4/0x100
>    __iterate_supers+0x33d/0x410
>    do_emergency_remount+0x20/0x40
> 
> With panic_on_warn that's a panic from sysrq u.
> 
> Nothing may be written in the emergency state but becoming read-only
> doesn't need to write anything. So allow going read-only and skip
> everything in that branch that would touch the disk. That's
> sync_filesystem(), which fails with the emergency errno anyway,
> dquot_suspend(), the s_state update and ext4_mark_recovery_complete().
> Note that after a shutdown with FS_SHUTDOWN_FLAGS_DEFAULT the journal is
> still live and the latter would really write. Also skip the superblock
> commit a remount does for a filesystem without a journal, like
> ext4_put_super() does in that state. Going read-write is still refused
> with -EROFS and option-only remounts work as before. Quotas stay on
> until umount.
> 
> That's the rule the filesystems converted earlier in this series follow
> as well. In the emergency state going read-write fails and going
> read-only works, writing at most what was dirtied before the error.
> 
> Reproducer (the sb_rdonly selftest after this patch covers the mount(2)
> path):
> 
>   truncate -s 64M img; mkfs.ext4 -q img
>   mount -o loop,errors=remount-ro img /mnt
>   xfs_io -x -c shutdown /mnt     # or any ext4 error, e.g.
>                                  # echo x > /sys/fs/ext4/loop0/trigger_fs_error
>   mount -o remount,ro /mnt       # EROFS, stays read-write
>   echo u > /proc/sysrq-trigger   # WARNING: forced remount of a ext4 fs returned -30
> 
> Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
> Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d636b89090a2..643c304460ec 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -6711,11 +6711,18 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  
>  	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
>  		if (ext4_emergency_state(sb)) {
> -			err = -EROFS;
> -			goto restore_opts;
> -		}
> -
> -		if (fc->sb_flags & SB_RDONLY) {
> +			/*
> +			 * Nothing may be written in the emergency state. Going
> +			 * read-write stays refused, but going read-only must
> +			 * not fail or emergency remount (sysrq u) WARNs. So
> +			 * just become read-only without touching the disk.
> +			 */
> +			if (!(fc->sb_flags & SB_RDONLY)) {
> +				err = -EROFS;
> +				goto restore_opts;
> +			}
> +			sb->s_flags |= SB_RDONLY;
> +		} else if (fc->sb_flags & SB_RDONLY) {
>  			err = sync_filesystem(sb);
>  			if (err < 0)
>  				goto restore_opts;
> @@ -6826,7 +6833,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  			goto restore_opts;
>  	}
>  
> -	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
> +	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY) &&
> +	    !ext4_emergency_state(sb)) {
>  		err = ext4_commit_super(sb);
>  		if (err)
>  			goto restore_opts;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
