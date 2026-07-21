Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215CC402436
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784602697; cv=none; b=ryOMKEYhemx1RJVme0vdP3dukkAMayPtveUjKFMQu2UF2Oh4YfQ4uge+1ddAR0pbh5PI4uRaqgKpKjl/4b4pY/Azj6hOsVliL1H4yDybU0MTvH57dQSVky04Gm58jk8JDJN6RUYJ9SBf5LESvfygwlhdusVwLQEXFqdDc5fVHWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784602697; c=relaxed/simple;
	bh=tIa7gsZ3/GTK+8vC+dJ36Qe7Oz0mb9Oo0EBCkOtMl+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7/jpfyJMsihwBBgHVtRlcSUpqonV+6xMnB7Tgt9+tMah8EhwKKM/oLHutwvRCrww/mDW+DTkKt8dKBl8nyHim2V2GfLwyDAVVxw91qwbCiONVnKtFLdRpMu0OdG7cOw8l0QSc/xLyL7M2bcT3+rIFaY9SjTANXstlW1s1AeRh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vayez1f4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1GOgq7Dm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vayez1f4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1GOgq7Dm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vayez1f4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1GOgq7Dm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vayez1f4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1GOgq7Dm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 282887A33E;
	Tue, 21 Jul 2026 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784602693;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7JD/okLtrTfrWA/8kEFlGhqpktN40fdQr75rS3L+eAA=;
	b=vayez1f4tSWBX7T5Y0ws7I/LftAeF55dKiJq2yCl12/k+qcbcKGf0ntNQ4H3xS1Oa5Smxw
	BiPwzLop3YAUAgKAirWN9+pqW1GV12HmBR1d6WOWUy0jfbKO7IahBMXfnt9tbEMm8r8TUE
	+BDwxzaCIsfGo4V4Z9MpnAgHB5X3MYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784602693;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7JD/okLtrTfrWA/8kEFlGhqpktN40fdQr75rS3L+eAA=;
	b=1GOgq7DmNyCGizojBidkjn+uWADLnzAVOuf+syzirWXAbLn0q8yBXzMrO+3Tk+bSlSDXlz
	qtWhihvUXjTeJyAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vayez1f4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1GOgq7Dm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784602693;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7JD/okLtrTfrWA/8kEFlGhqpktN40fdQr75rS3L+eAA=;
	b=vayez1f4tSWBX7T5Y0ws7I/LftAeF55dKiJq2yCl12/k+qcbcKGf0ntNQ4H3xS1Oa5Smxw
	BiPwzLop3YAUAgKAirWN9+pqW1GV12HmBR1d6WOWUy0jfbKO7IahBMXfnt9tbEMm8r8TUE
	+BDwxzaCIsfGo4V4Z9MpnAgHB5X3MYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784602693;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7JD/okLtrTfrWA/8kEFlGhqpktN40fdQr75rS3L+eAA=;
	b=1GOgq7DmNyCGizojBidkjn+uWADLnzAVOuf+syzirWXAbLn0q8yBXzMrO+3Tk+bSlSDXlz
	qtWhihvUXjTeJyAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1381D779AA;
	Tue, 21 Jul 2026 02:58:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wN4mBEXgXmpIHgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Jul 2026 02:58:13 +0000
Date: Tue, 21 Jul 2026 04:58:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v12 03/21] fsverity: pass digest size and hash of the
 all-zeroes block to ->write
Message-ID: <20260721025811.GF10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260720090410.3487990-1-aalbersh@kernel.org>
 <20260720090410.3487990-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720090410.3487990-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 282887A33E
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, Jul 20, 2026 at 11:03:31AM +0200, Andrey Albershteyn wrote:
> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> ---

>  fs/btrfs/verity.c        | 6 +++++-

Acked-by: David Sterba <dsterba@suse.com>
