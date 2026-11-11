Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406514;
	b=pnS1pFA387ZVO9e7L211jNYdB7CVEsrISckdBlDXxrCwDOPeUUfigZ5M0EAL+1zpgNxX
	 lPm/QrLfL6MQuWcOrgas8sOQ5Z3bPFBj8cqyfsx82wtvoBfh5i/IXTnWKMVKKRy7xre3V
	 didVrbYy9r6f8XdubW6OdZF3tC02IRM2lP6r+ALbq8LBPteLp1Z4mmLu8BxgOHGIz5eB3
	 mH8iQMuLFJKy0X64QnRZvbbjKxJ2FKSog3lQ5cbrAX93xiMGf6Buw5AV8/VilJ1QwYkrv
	 VoVs/I60Jedx41RbDMk9TzI3pmAs2oLrsRkFHf9FdNysgpRbMaavWZ10LqWGjRWkYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406514;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=oDSv8TML6Br2ANrNyyHl5eLdEaqkGzeKqpFh5cUnWgNS3fFOATWhduyRajWfNTE5l6fy
	 uzP1ErgGCX40NlHPlSkrYAyCKWd/DrM3AR1hSHvG7Gt9Errj1r27oDq/v6I2EXnOowHjj
	 yJXfIJaifMDI9/c8fAjy0oc1c0mbEkwVJlkJSr6dcwENjDpa8I3oR9yzWDT+3C5P1fw2t
	 RbK2FcApV6zWx9SnMoOkoEMy1hWiBt8IIC507Xei0f8qg6s4ZwFwoHWE9Sm3dFhOwvroq
	 n/I8nuOGPIkkWsUxEZu67qnuVp5v8q97OyQpfwpLZyLlwi0nYOp8xfQAY+e7ZNPPghg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1C606A334;
	Wed, 11 Nov 2026 14:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE1C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 09F3E22A5E;
	Wed, 11 Nov 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794406512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=r58BF0D8W8gzgIAphVb7+yXG4Wp0CzJfQUUtsAILSsDExswBBX2Vz1DZhrqDcoIpRX0ZTt
	0gBD9RMFaruNOsM+g+SXe7YVni3W376lEjHWkMsC8cv+03B46mcbwzWMdN6eutgUbVcR1I
	skb2yG6nBdMmWTQD7PkbKOeYbn2js8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794406512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=15TlV9Nrfb6fbwPB+XQGAF9gQF4YSshvgg4Qr4JwuaNYvo4isPqFDJlR8PRYTR3/TFQArE
	KUe4A2NvjL7x2ZAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15TlV9Nr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794406512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=r58BF0D8W8gzgIAphVb7+yXG4Wp0CzJfQUUtsAILSsDExswBBX2Vz1DZhrqDcoIpRX0ZTt
	0gBD9RMFaruNOsM+g+SXe7YVni3W376lEjHWkMsC8cv+03B46mcbwzWMdN6eutgUbVcR1I
	skb2yG6nBdMmWTQD7PkbKOeYbn2js8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794406512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=15TlV9Nrfb6fbwPB+XQGAF9gQF4YSshvgg4Qr4JwuaNYvo4isPqFDJlR8PRYTR3/TFQArE
	KUe4A2NvjL7x2ZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD61B134E5;
	Wed, 11 Nov 2026 14:15:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oMu1Jm949GpWAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 14:15:11 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 475D422933; Wed, 11 Nov 2026 15:15:11 +0100 (CET)
Date: Wed, 11 Nov 2026 15:15:11 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
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
In-Reply-To: <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
X-Rspamd-Queue-Id: 09F3E22A5E
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,suse.com,zeniv.linux.org.uk,lists.sourceforge.net,lists.linux.dev,kvack.org,lists.infradead.org,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim]
X-Spam-Score: -11.51

On Tue 10-11-26 22:50:47, Christian Brauner wrote:
> On Thu, Nov 05, 2026 at 10:22:07AM +0100, Jan Kara wrote:
> > So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
> > use also sb_emergency_ro() and don't bother with modifying individual
> > filesystems?
> 
> The VFS patch I posted in v1 thread did that. I dropped it because
> of jfs. jfs keeps anonymous tlocks for every allocation that writeback
> hasn't committed yet. If sync_filesystem() bails after the error nothing
> commits them before evict_inodes() and jfs_evict_inode() hits the
> BUG_ON() for a non-empty anon_inode_list on umount.
> 
> Which is what happened before the series because the error set
> SB_RDONLY. jfs_reconfigure() relies on the same sync_filesystem() call
> when going read-only after the error.
> 
> jfs could commit them itself before evict_inodes() but that means a
> ->kill_sb() wrapper and a txQuiesce()-like walk over the global
> anon_list filtered by superblock. I don't think that's worth it.

OK, so instead of BUGing in jfs_evict_inode(), shouldn't JFS just do
something like:

-	BUG_ON(!list_empty(&ji->anon_inode_list));
+	if (!list_empty(&ji->anon_inode_list)) {
+		WARN_ON_ONCE(!sb_emergency_ro(inode->i_sb));
+		/* This needs helper in fs/jfs/jfs_txnmgr.c */
+		TXN_LOCK();
+		list_del_init(&ji->anon_inode_list);
+		TXN_UNLOCK();
+	}

So that JFS doesn't block everybody else? Because conceptually, once sb is
marked as emergency read-only, we really want to stop writeback so letting
sync_inodes() run seems moot.

> > Is this really needed? All the xattr operations go through mnt_want_write()
> > / mnt_want_write_file() so this should be caught in VFS...
> 
> Not the ones ecryptfs does on the lower filesystem...
> Hm, maybe we should make ecryptfs get write access to the lower mount
> instead and drop the xattr checks from the filesystems. Not sure.

Argh, also NFS I assume. OK, that won't be easy to get rid of AFAICT (we
generally don't have mount available there).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
