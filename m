Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5604F37FF75;
	Tue,  8 Sep 2026 10:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863425; cv=none; b=P+dwdeeVURsbF+sA6ERJdIKooIxE9T0YN7DIGWxO50+JmQtEqxqxWdU8p1f2w+K0sJKt8nC+94HpiHyVD8vS5R4d0Cc1yMc0cC6GpXV0PRa9joklfnMY7waN6cPT9bkaeswYqdIn6llQi9UMt/pte9u4HuPL2S+HBtvcwKakvQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863425; c=relaxed/simple;
	bh=+p/VHz/ozr/TnZU6IPbGKh4R1M2wnun4aWv4AhVxBSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYi0w7bqg3+VFkV7RdVPJy5FXfW4fK89MBbz6IuWUdbMVGFSlEtsOmJG8KR4Uvdnb7CUv/YVjWiMdWAYNEez+GKDyu/IgrAtI5aROol33UAn75qKvllBWb1lSP/jHJKdR3WRwkffqrcW09BvUGQH1b5Y8vioROFCjUjYM9AQpnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pVCV/+qe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tRIEA9Be; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rEml7VTg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5GBoYFN2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pVCV/+qe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tRIEA9Be";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rEml7VTg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5GBoYFN2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 089BA21A11;
	Tue,  8 Sep 2026 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788863418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHRJTtT/pQ/U8ifD7hm3+xx7M4z8HYAWSg0hjLJ4s/I=;
	b=pVCV/+qe0yVZMsQ7LbG3zqEhhIqxo5xH5F+d71SUXdLd97Idg4z6M1Aj9m3AFdYfNCp5A6
	/4JWN6QQZYkzLqWXiN77aNKlFgL1xlsvUDVBPus7IJwTFMF16l3fiXY2Skt/QSVsO4NPQe
	mfFhgNXfLahar2XATKR9nRQ37fF0xSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788863418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHRJTtT/pQ/U8ifD7hm3+xx7M4z8HYAWSg0hjLJ4s/I=;
	b=tRIEA9Bekv7q3ERb9ulbSv61sE5fyVNanpO6C5qKAHqz6yplklisS2ru0Uz0bC4/w10CXx
	i1fS5W9lqc070cCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rEml7VTg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5GBoYFN2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788863414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHRJTtT/pQ/U8ifD7hm3+xx7M4z8HYAWSg0hjLJ4s/I=;
	b=rEml7VTgMB3OKvJtuheRYBf48qZ2o7Ebj8a0Huzqq2qLTWHtIQch3pAdZ4Hciw4YpuX2cU
	OGSjqLuOS5BqbjjvWjuXrx1iF9mthQsJUa2Z/zQ919kdnU8IZjkbdoj0siGi35Hk2kJb4H
	zh1SU1VxrdZr0h4PPcw3wDvFcTEHtyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788863414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mHRJTtT/pQ/U8ifD7hm3+xx7M4z8HYAWSg0hjLJ4s/I=;
	b=5GBoYFN2tCPzIwJ0/bQUEJoGtdfZkTewrpj0ixh5MW/oRY+nflyk4W1+LcJZg9lEz8O0A5
	EBNxxHZF+d9pOYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD4821347F;
	Tue,  8 Sep 2026 10:30:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EscDNrXjn2qxGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 10:30:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7907DA12E2; Tue, 08 Sep 2026 12:29:58 +0200 (CEST)
Date: Tue, 8 Sep 2026 12:29:58 +0200
From: Jan Kara <jack@suse.cz>
To: cem@kernel.org
Cc: zlang@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, jack@suse.cz
Subject: Re: [RFC PATCH 0/2] quota evasion test and nfs helpers
Message-ID: <7hf5sgqfrengnlq5z743jaz46b4psyarwirpsdnt3lofcvjskg@eowwbzwd4jr6>
References: <20260907164054.111393-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907164054.111393-1-cem@kernel.org>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 089BA21A11
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Mon 07-09-26 18:40:46, cem@kernel.org wrote:
> While writing it I stumped on a weird issue that I'm not exactly sure
> how to fix (or if it's perhaps a bug on umount):
> 
> During cleanup(), I umount the share and unexport the it so the rest
> of the generic cleanup can take place, specially umounting the scratch
> fs There is some timing though required by umount() to properly cleanup
> internal kernel structures before it can be unexported. I honestly
> assumed umount() was synchronous (unless lazy umount) and once it returned
> it was "done". But for some reason I didn't dig into, I need to wait a
> bit between unmounting the share and unexporting it.
> I tried to wait until the mount was excluded from /proc/mounts but even
> after the mount is gone, something still holds the share a bit
> preventing it to be unexported. So I went with a 2 second sleep :)

Yes, umount should be synchronous. But from time to time someone
inadvertedly offloads some cleanup to a workqueue which causes issues like
you describe. We've been through this a few times :). What you describe
seems to be this kind of issue specific for NFS mounts - would be good to
nail down what's exactly causing it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
