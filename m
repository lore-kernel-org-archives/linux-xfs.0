Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109607;
	b=JNc6pXSW5X41ijfDsFjk3VMCxUy++4Cd4dqcDGTIm1zqhQxhI9SxtJmFTipbaI/5F4M4
	 Kk4oqt1emPshvIyKwt37Uaj6p9qiXRcM5HHuJR6UWIMsyAFLRUkCw4hrYvyTjOgkxd+9b
	 /Np7GbMrogIa5P7g8Ezkw6w0cHjbQBxKUl7EbXYLb/69J5Y9QmE6nnf/yE4PW0ADPdWh3
	 g07Sx/nbkBJ1ApWF3gFcwtxOHI16FrwHuMamLfKSEvDHXZzeXru1Ow0RUAZaYPrw0Z0dE
	 O7TXqAoJHkOU4X9Yo/4fOX/vyBolFS3jFIFbrFyxLKqjH8zDcQdC27Y5luYm9v0FZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109607;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=m2xq0qOckL39TTzA50HXFg9XYwBx/cgPNnmDXSkv5kpTCe9j5QuLkPJ+caHpCtHkqorV
	 HktfcBTELNP7T2pbSkOqTnLIIK6EPtlrczTw43/PfRbiWFIhD82dWQb3nz4Cwdrlxemr3
	 ikL1IrUS5uMyKAHkC0naCYjqTlfO7KabgMJvZKOWHhpUEa4fJJf6shsWx7R87zbd9fGy3
	 6pxwDI/5jSEqHBo0OWePck+CitLTDJX8oGL/a8JgYXvEx/pYH0cNH8+XwMcKOuwUJcQ/3
	 zHT9lD3Cmdg6St61Zy9BpvFnj0GvbMaTuUd/RUTTdxK2cR0NMuIjK6o1m6150B21bKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDFD606A321;
	Tue, 27 Oct 2026 14:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DDFD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wa7KetCc;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=956mM1Hh
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 84B1F21E61;
	Tue, 27 Oct 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793109604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=wa7KetCcAaJiubuHT9myBcZvkmhrVgro9A1fdapN9oYrkcQLCIHxC+WJV/2L0wql/HkN+A
	9DrGzp9hQR7/nDSOV6fDwiXXSeoTdKz93Ai+moQcyyTgcFLaeGsaeTUVo/rDpmX5D9WNzk
	6lS9BKqcTy1tQjNHwe/i3I/5/fi07Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793109604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=956mM1Hhfx26MGleRkCZBYBnmuUGWBKItOp21Bg4WzpVyauT/hY8Z+TSVbV0Bq6OSOaWV3
	D6v0EguQnGAnF3Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wa7KetCc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=956mM1Hh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793109604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=wa7KetCcAaJiubuHT9myBcZvkmhrVgro9A1fdapN9oYrkcQLCIHxC+WJV/2L0wql/HkN+A
	9DrGzp9hQR7/nDSOV6fDwiXXSeoTdKz93Ai+moQcyyTgcFLaeGsaeTUVo/rDpmX5D9WNzk
	6lS9BKqcTy1tQjNHwe/i3I/5/fi07Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793109604;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uhrgCviLVpqd6doUVj8+mDtiewlfSufkk4uHB72cvM=;
	b=956mM1Hhfx26MGleRkCZBYBnmuUGWBKItOp21Bg4WzpVyauT/hY8Z+TSVbV0Bq6OSOaWV3
	D6v0EguQnGAnF3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57C1F1321C;
	Tue, 27 Oct 2026 14:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QziECmGu4GqdawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 14:00:01 +0000
Date: Tue, 27 Oct 2026 13:59:59 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ryan.roberts@arm.com, 
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, 
	dipietro.salvatore@gmail.com, rvvandan@amazon.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org, 
	hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org, 
	dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, willy@infradead.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-xfs@vger.kernel.org, ntfs@lists.linux.dev, ntfs3@lists.linux.dev
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <auCrqvae2tm4a8PV@pedro-suse.tail5790ac.ts.net>
References: <20261027112702.3747009-1-dipiets@amazon.it>
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
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[49];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[linux-foundation.org,kvack.org,arm.com,amazon.com,gmail.com,zeniv.linux.org.uk,kernel.org,suse.cz,samsung.com,sony.com,szeredi.hu,redhat.com,paragon-software.com,wdc.com,infradead.org,google.com,suse.com,nvidia.com,intel.com,sk.com,gourry.net,linux.alibaba.com,vger.kernel.org,lists.linux.dev];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj7gq6ygjhknyts9645j9ygdi)];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 84B1F21E61

On Tue, Oct 27, 2026 at 11:27:00AM +0000, Salvatore Dipietro wrote:
> Since iomap gained per-block dirty tracking, a large folio can be
> partially dirty: struct iomap_folio_state records exactly which
> blocks are dirty, and writeback only writes those ranges.  The mm
> dirty accounting, however, still charges the whole folio even if a
> single block is dirty (up to 512x over-accounting for a 2 MB folio
> over 4 KB blocks).
> 
> balance_dirty_pages() then throttles writers against a number that
> is unrelated to how much data actually needs writing back.  On
> workloads that repeatedly dirty small ranges of large folios --
> e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> is crossed and writers are throttled long before the real dirty data
> justifies it.  On the benchmark below, run on v7.3-rc7, the
> unpatched kernel charges ~159 TB of dirtied pages while writing
> ~6 TB to the array, a factor of 27; with this series the dirtied
> pages charged match the data actually written.
> 
> This series makes iomap charge and discharge the mm dirty counters
> per dirty page for folios that carry per-block dirty state, so a
> partially dirty large folio is accounted for the dirty part only:

Why? This looks wrong. Yes, you may only have dirtied e.g 4K out of a 2MB
folio, but the whole 2MB folio is still effectively pinned by the VM, awaiting
cleaning + writeback. And that's precisely what we want to measure and
throttle in certain cases, so that e.g the VM system never finds itself
short of clean pages it can reclaim, and no easy way to start writeback
on them.

-- 
Pedro
