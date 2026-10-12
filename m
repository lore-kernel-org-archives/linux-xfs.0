Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433C338655A;
	Mon, 12 Oct 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824012; cv=none; b=KdFCtkcP/iajbAzw9K6fcOB7zHYrNdLKGvxkwhf/mQZx0Z6HdnC7DU2vRsG6FRq3W5aW7uxZIKIRIKBmbKU7eM72XB4agDoSOYY3GdL3vKGA9HMnu0dKNE1CXuxIQVj8Kr9rSTSt/MWG0aR14fIX5r50LZzz/76VquZfLgYKbqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824012; c=relaxed/simple;
	bh=u4RbT2JBy+Ts7npCHn3lpvoB15ZuLisXUYt28wIzsZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NlyEXk7kihiKdtYbfA0bKQgpzH1WjNeteGRLoENNugycLcSgL1bWvAUDxXeBa0WP9HRuF07/TUwHBCmUF0JQbIiVneIWJhIxpbDqw7JThfPM2/9qJr3BSyJgNaT1rWo3A5JpzFNuZOPiGsjM7tGtbHLXw8nMsg1h7Sn8gyiPB4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g+Eqnf5h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OONF4/pt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLqk0xPN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pwPw/Ecr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g+Eqnf5h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OONF4/pt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLqk0xPN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pwPw/Ecr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0EFCD21E87;
	Mon, 12 Oct 2026 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791824005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDjF2EqIZ72LsqxvftLHW/KslkTXyiMHSnpVP7GBsSI=;
	b=g+Eqnf5h3LJpu9HnXYbiyiOWds/J0Z3iJiTOLLb+LjyTX7lprmDNunMllA0zLaHb+uzFIM
	ep3pmMWuHlSlZwdRA8qpHHROqCWT1D6WpI/CNlUI2WY+Llm8Kc3gSQhGM8OG7+SWq/Inux
	dgtl9LbTEKtSHzjWA0EyJmr0D+7mToI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791824005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDjF2EqIZ72LsqxvftLHW/KslkTXyiMHSnpVP7GBsSI=;
	b=OONF4/ptQRPFEv6hkUNTADkoNMhEFaJpeXnxSlLzwITTcryOGyVTXUSh8HHffsopaQe+BH
	QvRzXI4T9bSpUZCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791824004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDjF2EqIZ72LsqxvftLHW/KslkTXyiMHSnpVP7GBsSI=;
	b=fLqk0xPNj68O0bVp8KJ3Plt0obAvOXFMewpFvSVBy/M7PQMlK9fQeKyLcmeAwHG1HgqSLV
	KovD5ImiZ4QKxeNss0Cmuy3N5PC64/InwFpeC2IdGFcveYXgQzPowr5Zq3elHc0LMRVy9t
	zE26b7eCqSGpIFOwXx3n0+RwsgYdU5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791824004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDjF2EqIZ72LsqxvftLHW/KslkTXyiMHSnpVP7GBsSI=;
	b=pwPw/Ecr0z2IyT2wKp5Z0I6siBLHYpovCUmz3KD8X2mvxDDQre17gUnh8tXFhsq1HKkCHG
	nkW4uuXx9hIQINAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA19313314;
	Mon, 12 Oct 2026 16:53:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FPUeLYMQzWrdBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 16:53:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 65F66A1405; Mon, 12 Oct 2026 18:53:19 +0200 (CEST)
Date: Mon, 12 Oct 2026 18:53:19 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH RFC 00/28] fs: don't set SB_RDONLY after filesystem errors
Message-ID: <my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,zeniv.linux.org.uk,vger.kernel.org,lists.sourceforge.net,lists.linux.dev,lists.infradead.org,gmail.com];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 12-10-26 12:20:45, Christian Brauner wrote:
> A lot of filesystems handle errors by setting SB_RDONLY on the
> superblock. They do that from whatever context found the error and
> without holding s_umount. That's never been okay. SB_RDONLY is supposed
> to only change under s_umount through a proper remount.
> 
> And it breaks freezing. freeze_super() and thaw_super() both look at
> sb_rdonly() to figure out whether the s_writers rwsems need to be taken
> or released. So if an error sets SB_RDONLY while the filesystem is
> frozen thaw_super() takes the read-only shortcut, leaves the rwsems
> write-locked and marks the superblock unfrozen. Every writer after that
> hangs in sb_start_write() and umount warns when it frees the locked
> rwsems. jfs even oopses on umount. And the unlocked update of
> sb->s_flags races with everyone else who writes it.
> 
> Karl noticed and proposed teaching thaw_super() to remember whether the
> freeze took the rwsems (cf. [1]). But a filesystem changing SB_RDONLY
> behind the VFS' back causes more problems than just confused freezing.
> Jan preferred fixing the filesystems instead (cf. [2]) and I agree. ext4
> and f2fs already stopped doing it. So this converts all the others to
> what ext4 does:
> 
> - the error is recorded in filesystem private state and the filesystem
>   refuses modifications with EROFS itself
> - the superblock stays read-write and "emergency_ro" is shown in the
>   mount options ("withdrawn" for gfs2, "ro_ops" for efivarfs)
> - a remount to read-write fails with EROFS until umount
> - a remount to read-only works so emergency remount (sysrq u) doesn't
>   WARN, and it doesn't mark the filesystem clean
> 
> That's ext2, jfs, nilfs2, fat, exfat, hfs, affs, ufs, hpfs, ntfs, ocfs2,
> zonefs, btrfs, gfs2, efivarfs and ubifs. For gfs2 it's the withdraw and
> for efivarfs it's the notifier that flips SB_RDONLY when the efivar ops
> switch between ops that can and can't set variables. ubifs can't be
> frozen but it flips SB_RDONLY from any context all the same. hfsplus
> only did it when it created the attributes tree, where it can't trigger,
> so that check is simply limited to mount.
> 
> fat, exfat, hpfs, ntfs and ubifs keep setting SB_RDONLY for errors while
> the filesystem is still being mounted. Until SB_BORN the mounter holds
> s_umount and nothing can freeze the superblock so that's fine.
> 
> A few patches make the read-only remount work in the first place. exfat
> and ocfs2 didn't inherit their mount options on remount so emergency
> remount, which passes none, could fail on them. And gfs2 has a BUG_ON()
> when it's remounted read-only while a withdraw is still pending that
> this makes easier to hit. Those come before the conversion of the
> respective filesystem. ext4 and xfs have the same problem with their own
> error states. ext4 refused to go read-only in its emergency state at all
> and a shut down xfs couldn't be remounted read-only either. So sysrq u
> WARNed for every ext4 that hit an error and for every shut down xfs.
> Both are fixed at the end of the series.
> 
> ecryptfs opens its lower files read-write unless the lower superblock is
> read-only. On top of one of these filesystems every lookup of a regular
> file would fail with EROFS after an error and leak the inode. umount
> then reports busy inodes. ext4 already behaves like that and so does a
> read-only bind mount underneath. The first two patches make ecryptfs
> fall back to a read-only lower file and plug the leak.
> 
> There are user-visible changes but I think they're all fine. The big one
> is that "mount -o remount,rw" doesn't make the filesystem writable again
> after an error anymore. That's how ext4 behaves since
> commit d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem
> errors"). statfs() doesn't report ST_RDONLY after an error and a second
> read-only mount of the device fails with EBUSY. Writes through file
> descriptors opened before the error fail with EROFS now where they used
> to succeed. ext2, fat, hfs, affs, ufs and ubifs fail fsync() with EROFS
> after an error. Writeback drops what they can't write anymore so fsync()
> would report success otherwise. And remount helpers that pass the shown
> options back, busybox mount for example, trip over "emergency_ro".
> That's already the case on ext4.
> 
> Every patch has a reproducer in the commit message. I ran all of them
> in a VM against the unpatched and the patched kernel, the latter with
> KASAN and kmemleak. There are selftests for ext2, jfs, nilfs2, gfs2 and
> the ext4 and xfs remount changes.
> 
> This depends on three fixes that aren't upstream yet:
> 
>   super: don't put the remount context under s_umount
>   super: keep the read-only state if a reconfiguration doesn't change it
>   nilfs2: don't reconfigure a frozen superblock on mount
> 
> The first one matters most. This series makes errored filesystems
> reachable for sysrq u and without it a concurrent umount deadlocks on
> s_umount. The second one makes fc->sb_flags carry the current read-only
> state for fspick() reconfigurations, which ->reconfigure() of fat, affs,
> hfs, ufs, hpfs and btrfs rely on. The third one closes the last way
> nilfs2 changes SB_RDONLY on a frozen superblock, through a mount that
> reconfigures it.
> 
> With this no filesystem changes SB_RDONLY outside of mount and remount
> anymore.
> 
> [1]: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
> [2]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

I'm in favor of this. Just after checking couple of filesystem changes -
won't we be better off by using a generic flag in super_block for this so
that VFS can check for it? Then each filesystem won't have to implement
its own wrapper for simple_fsync(), quota operations, and whatever other
generic operations that need to bail on shutdown filesystem...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
