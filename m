Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEBB52FE42;
	Wed, 14 Oct 2026 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985663; cv=none; b=rOZcUCwf0LuOStKrxgzW0pYCfgewfM/Kodm3ZyXH+m8mNws6+nTZ0dUTy0quiUnn/3x6tqplTh6+h0KSsnVbMFD6h0ZHvUnCaGnM8JdViRqS70gS1bdnZ88yHSLvnDxC2lP1YS5do0g+/pGfSiKNKqLroedZRIOSTdvE1PXPEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985663; c=relaxed/simple;
	bh=uLec5Ms1kEItxT/9M3m+iatVoLfvlo+Ku3r+6YxXaVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phCBR6//HXrne9fXQuP5Y8SlKSN8HTEjA2q3Jc4Sajhj8+u1uUOHMyUHoTWCDTdEAzUTBJE3/IZJndBSh1RxXY2sWaD31bfg76jprO9ONdpaNf+CJguXn6+qH+rNM0OxUhvPqk7EUsm6GBMbQIaANXa0Vvd+R0yHPNISsRLC1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KER6SV+3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5kV45Nl3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S0AnEx52; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gG1ABpRO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KER6SV+3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5kV45Nl3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S0AnEx52";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gG1ABpRO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D252822258;
	Wed, 14 Oct 2026 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791985659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY9RqNIokuQ1DH3X9Yc1BCOmA2bOCbyTbnsYeJcms7U=;
	b=KER6SV+3E5T8faaU3djQpSC8B9QPNgiQOksk9btYa1oyN+g/YdhOBY6t1StzY1g3bSF0IJ
	zd1FvSem8kaP2TbkqojJhhhFOthOVUjirK7sCmgbkHZZx82aJ9Io4OE8IvNRplBb+KGXEf
	1xnlhspPxY1CCNo9bMSSg22YlcPY1WI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791985659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY9RqNIokuQ1DH3X9Yc1BCOmA2bOCbyTbnsYeJcms7U=;
	b=5kV45Nl3phoxgImBDhEqInuMMmAek0XiQQPFlXI/cnE3ZS5Quvx+F2axMbnAyEMUB1fkx3
	FIYEJ2frN9CQ5KBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S0AnEx52;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gG1ABpRO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791985657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY9RqNIokuQ1DH3X9Yc1BCOmA2bOCbyTbnsYeJcms7U=;
	b=S0AnEx52KGncKxtGJdhOJnkNKWblqAhU1fDfPojL39mMiKeDrabTNcq7zrzX9j4BiwbLyH
	OakWO7MFjbmum5NnwrDWXKsOJm95K6rjrzLtmGKio9hh9a9ZDKInBQ8G3OJJr2jLduCpIm
	cY4ShwlOEbCtlHljqjRWtydkmyqg6nY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791985657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY9RqNIokuQ1DH3X9Yc1BCOmA2bOCbyTbnsYeJcms7U=;
	b=gG1ABpROq+bYTWDuUnYSBShOJ9fbmudAese1phkK/c9rHSbMI+6wnPeO8BO8ATprL8kHK6
	exH5zVUd6CuBDKDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9348F133F1;
	Wed, 14 Oct 2026 13:47:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ACfUG/mHz2oSUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 13:47:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84A41A140F; Wed, 14 Oct 2026 15:47:36 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:47:36 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH RFC 00/28] fs: don't set SB_RDONLY after filesystem errors
Message-ID: <k7zduo2ewgvrmic2gc4wssakq4ystwqpuwo6a5llx2gzc64xzl@k2pjjijh5kye>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs>
 <20261013-forsten-ammoniak-geknackt-fefec366cc97@brauner>
 <CAHc6FU5JuYU8R4=agxgWBoEKrUGyWiitzRn5MwXiV7NZYt=_ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU5JuYU8R4=agxgWBoEKrUGyWiitzRn5MwXiV7NZYt=_ag@mail.gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,zeniv.linux.org.uk,vger.kernel.org,lists.sourceforge.net,lists.linux.dev,lists.infradead.org,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: D252822258
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Wed 14-10-26 12:04:08, Andreas Gruenbacher wrote:
> On Wed, Oct 14, 2026 at 12:20 AM Christian Brauner <brauner@kernel.org> wrote:
> > > I'm in favor of this. Just after checking couple of filesystem changes -
> > > won't we be better off by using a generic flag in super_block for this so
> > > that VFS can check for it? Then each filesystem won't have to implement
> > > its own wrapper for simple_fsync(), quota operations, and whatever other
> > > generic operations that need to bail on shutdown filesystem...
> >
> > Do you mean something like?:
> >
> > From 28c97f2142e255eb835d26deb97b00afccfb7c4a Mon Sep 17 00:00:00 2001
> > From: Christian Brauner <brauner@kernel.org>
> > Date: Tue, 13 Oct 2026 21:15:36 +0200
> > Subject: [PATCH] fs: add a generic emergency read-only state
> >
> > The filesystems that stopped setting SB_RDONLY after an error refuse
> > modifications themselves now. Each of them grew the same checks in
> > ->open, ->setattr, ->fsync, ->write_inode, the directory operations, the
> > quota operations and ->reconfigure. Jan suggested a generic flag so the
> > VFS can do that once (cf. [1]).
> >
> > So add SB_STATE_EMERGENCY_RO in a new sb->s_state word. It is only ever
> > set with set_bit() and never cleared so it can be tested anywhere
> > without any ordering against the setter. A filesystem calls
> > sb_set_emergency_ro() where it used to set SB_RDONLY. SB_RDONLY itself
> > stays untouched so freeze_super() and thaw_super() keep seeing a
> > consistent superblock.
> >
> > The VFS then checks it wherever sb_rdonly() gates a write:
> >
> > - __mnt_is_readonly() so mnt_want_write(), opening files for writing,
> >   access(W_OK), nfsd and overlayfs see a read-only superblock
> > - sb_permission() for vfs_create(), vfs_unlink() and friends
> > - notify_change(), rw_verify_area(), vfs_fallocate(), vfs_fsync_range()
> >   and do_page_mkwrite() for files that were opened before the error
> > - reconfigure_super() refuses going read-write
> > - sync_filesystem(), sync(2) and write_inode() don't write anymore
> > - the dquot code doesn't write the quota files anymore and quotactl(2)
> >   refuses to change anything
> > - "emergency_ro" is shown in the mount options, /proc/mounts shows the
> >   superblock as "ro" and statfs() reports ST_RDONLY like they did when
> >   SB_RDONLY was set
> >
> > What reaches the filesystem without passing through the VFS it still has
> > to refuse itself. That's its allocators, its journal, its own writeback
> > and the deletion of unlinked inodes.
> 
> For shared filesystems like gfs2, the concept of an emergency
> read-only state doesn't make sense because in that state (in gfs2
> terms, a withdrawn filesystem), we cannot do any more cluster-wide
> locking and so we cannot allow any more reads, either. Could we define
> the new flag in a way that would allow filesystems to enforce stronger
> guarantees? This would suggest a flag name other than
> SB_STATE_EMERGENCY_RO, though.

The problem is that a lot of local filesystems really want the emergency
read-only state (and not full fs shutdown). So if you want to fully
shutdown the fs on error, either gfs2 has to do it on it's own or we could
introduce another sb state for that. But I think emergency-ro state needs
to stay...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
