Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25503C9EC1
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438465; cv=none; b=Qbk+pzFy3gxZPsT+Cy3Ir5eRsyT0iQAP9xawGuRbWAIqRDHyFVuj/ph+xaqysY3VhWQgYTbVz4n25b1PUrTz2S4osmJxCHv7h3SydE3hgR79oxusmr7Ro+KV/t8stStKp5NQqCfO+36QypI1lXuIWyojFX5kuaIewTXB+ydrdUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438465; c=relaxed/simple;
	bh=IroKj3t13MG+FM3hFelehM3XmGZE1nt+UtM/5i5NIi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsUrmqVO+WJNi/fghfRH9vho+0Lfog6gh2s9Dg+nZKfhTGfYpUL3EEre2bS5CQlFqGxPshPjLs4Ds2NKZ6zrfsGwUVi38+sPppUeSFrWwnrxhAH2GP5o8jUM/paN4aMccBiNFz9rjCSyUezmwq/Tmv7ChZ3JHZLlb23RgRjHBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UtmLShqM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YEsZcN7X; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UtmLShqM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YEsZcN7X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UtmLShqM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YEsZcN7X";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UtmLShqM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YEsZcN7X"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CAD304D21F;
	Wed, 25 Mar 2026 11:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774438462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vq2T/vFLDEP46zaZVRN1uNpU0VC/YpLh6v2SVWei6m8=;
	b=UtmLShqMzuRyUiGIrc0LUydixRU5bwUjdwrjwEFq5t8eSxN454oqsCUrpVZYqt0lyXJtmw
	FIG9aJxGBGXmsoYB4fgNEYvFwBaO/uWL10wYIkX6oLrtpKKcFn30g0D412Y/hP+lKhAnAx
	ghe/S51MaTkWbqcYxt0sAIVKeqX1CIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774438462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vq2T/vFLDEP46zaZVRN1uNpU0VC/YpLh6v2SVWei6m8=;
	b=YEsZcN7XFcjW0TbV3bB2QjS2CV9b1s5bt3yWQvaFEGEL1x1daCgoVaMJgzQdO2yZNAoWdh
	6AOwHmLWcAVLXOCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UtmLShqM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YEsZcN7X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774438462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vq2T/vFLDEP46zaZVRN1uNpU0VC/YpLh6v2SVWei6m8=;
	b=UtmLShqMzuRyUiGIrc0LUydixRU5bwUjdwrjwEFq5t8eSxN454oqsCUrpVZYqt0lyXJtmw
	FIG9aJxGBGXmsoYB4fgNEYvFwBaO/uWL10wYIkX6oLrtpKKcFn30g0D412Y/hP+lKhAnAx
	ghe/S51MaTkWbqcYxt0sAIVKeqX1CIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774438462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vq2T/vFLDEP46zaZVRN1uNpU0VC/YpLh6v2SVWei6m8=;
	b=YEsZcN7XFcjW0TbV3bB2QjS2CV9b1s5bt3yWQvaFEGEL1x1daCgoVaMJgzQdO2yZNAoWdh
	6AOwHmLWcAVLXOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD48244399;
	Wed, 25 Mar 2026 11:34:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6QsvLj7Iw2nNEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 11:34:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6FDFDA0B32; Wed, 25 Mar 2026 12:34:18 +0100 (CET)
Date: Wed, 25 Mar 2026 12:34:18 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Morduan Zang <zhangdandan@uniontech.com>, 
	dgc@kernel.org, brauner@kernel.org, cem@kernel.org, dchinner@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zhanjun@uniontech.com
Subject: Re: [PATCH] xfs: defer lazytime timestamp updates to inodegc during
 eviction
Message-ID: <pacwesi66thnl2a7ek6i3i74qep4crsmu7kx4oglhhuarvqyjp@dobq2euyexta>
References: <absSoRi8oxXSuSZ7@dread>
 <6EBD01CF561B83EC+20260320100353.220462-1-zhangdandan@uniontech.com>
 <tet44nv2qc7i7uhrip4gcd7cur2cpn4mmgyh4v6hquaju2xtih@i5s2uco5wemr>
 <20260325063822.GA32067@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325063822.GA32067@lst.de>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[d78ace33ad4ee69329d5];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CAD304D21F

On Wed 25-03-26 07:38:22, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 04:14:23PM +0100, Jan Kara wrote:
> > Isn't this problem already fixed by Christoph's patch
> > https://lore.kernel.org/all/20260317134409.1691317-1-hch@lst.de ?
> 
> It should.  My question to Ted what we're even trying to do in this
> context is also still outstanding.

Let me see. One reason is that some filesystems don't cache inodes at VFS
level (such as XFS but there are others which just always return 1 from
their ->drop_inode). For these we'd have to come up with some other place
where they write the outstanding time modification before evicting the
inode from memory.

Second effect is that without I_DIRTY_TIME writeback in iput()
__inode_lru_list_add() in iput_final() will not add these inodes to the lru
list and they won't be added there after flush worker did the dirty time
writeback either so they'd be sitting in memory pretty much until unmount
(or until somebody uses them again).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
