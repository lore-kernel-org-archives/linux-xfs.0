Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F5417597
	for <linux-xfs@vger.kernel.org>; Mon, 29 Sep 2025 07:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759129552; cv=none; b=DMg+eT3H41F8wdG9TVaTUs8nrsZF/sS50Cqdbof8dRxMLEaIirNXJev4RIqbc+DKQNO6Kq/ItaZTww18ASakSgwt3toQ77D+H2b+oSpmh+McJT7k84hVuBeacyTFBOMYZRQJGXZzGp61/d7RkcJ3mR366czosvt4re+xpqeS+4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759129552; c=relaxed/simple;
	bh=JkOCyCh8DCqYHwgDIP5DlDFVA2wlSIe1yICZ5EOrHpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LlY8OjoC5P6xAoxKVTatk+7XoIXak27hXxvxsX4CNdzmDY41Zi+U6GFU8YfnXaVJhJ8Vr1Keiqm9wjMCLq1oOX1OTfrrl88avRhh2guIpY2LEPgo1D/Z/XpwpyinG7qRP/qCamRBKtqkoj+E51L//f0iu+r8eeVeHTqwgzY/DFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KTjatXcQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EdTVebLP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KTjatXcQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EdTVebLP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KTjatXcQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EdTVebLP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KTjatXcQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EdTVebLP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2F2B30567;
	Mon, 29 Sep 2025 07:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759129546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=KTjatXcQdqXr+nYbhxwh+pR/Sq08Red373ivaGssSgf2D7VDXSR0UKecI6noeSRKhSgH5u
	yZ88CEcwiXlef3yxrTP24rReS2mfq9zlEKfHlMDO/s31If0sVAD4iMfUrH/E0vlnseLfGd
	W2tVjP2By3YI8HLwulydXN4yDSN+viM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759129546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=EdTVebLPxPU3FldFp8y8Qqmu1iZ4BN8ljDY8UZMc+4UWvq3kTG8jVN2xqvEUVu3TdPsa8U
	aw6tM+gssYwttPBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759129546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=KTjatXcQdqXr+nYbhxwh+pR/Sq08Red373ivaGssSgf2D7VDXSR0UKecI6noeSRKhSgH5u
	yZ88CEcwiXlef3yxrTP24rReS2mfq9zlEKfHlMDO/s31If0sVAD4iMfUrH/E0vlnseLfGd
	W2tVjP2By3YI8HLwulydXN4yDSN+viM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759129546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tNpRu4Z2OugfjqfNcQiZeCEO6pYjWJtUETttpSuKeCU=;
	b=EdTVebLPxPU3FldFp8y8Qqmu1iZ4BN8ljDY8UZMc+4UWvq3kTG8jVN2xqvEUVu3TdPsa8U
	aw6tM+gssYwttPBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C20DB13782;
	Mon, 29 Sep 2025 07:05:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PbGhLskv2mj+FAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Sep 2025 07:05:45 +0000
Message-ID: <3d54a546-77dd-4913-bcd0-7472aec8f53c@suse.cz>
Date: Mon, 29 Sep 2025 09:05:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
To: Christoph Hellwig <hch@infradead.org>,
 syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, cem@kernel.org, david@fromorbit.com, david@redhat.com,
 gourry@gourry.net, harry.yoo@oracle.com, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 matthew.brost@intel.com, mhocko@suse.com,
 penguin-kernel@i-love.sakura.ne.jp, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, willy@infradead.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <68d973fc.a00a0220.102ee.002b.GAE@google.com>
 <aNop4ZBrfuqrX40Y@infradead.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aNop4ZBrfuqrX40Y@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[359a67b608de1ef72f65];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,nvidia.com,kernel.org,sk.com,fromorbit.com,redhat.com,gourry.net,oracle.com,gmail.com,vger.kernel.org,kvack.org,intel.com,suse.com,i-love.sakura.ne.jp,googlegroups.com,infradead.org,linux.alibaba.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

On 9/29/25 08:40, Christoph Hellwig wrote:
> This looks like slub turning a < PAGE_SIZE allocation into a order > 0
> folio allocation, which the page allocator then complains about.

It's order-1 to order-2 but in principle yes.

> We'll either need to make slab not propagate < PAGE_SIZE allocations
> to order > 0 page allocation

It normally doesn't, but enabling debugging stuff can do that. In this case
it seems to be KASAN, but could be also slub's own redzones etc.

, or make the page allocator handle the
> latter.

It handles it, but warns you're doing something you shouldn't, as
__GFP_NOFAIL allocations shouldn't be large. We could just silence it if
it's due to debugging. SLUB could check if page allocation is bloated due to
debugging and there's __GFP_NOFAIL, and then add an extra gfp flag to
silence the warning. We could use __GFP_NOWARN with the risk of someone else
combining __GFP_NOFAIL and __GFP_NOWARN to silence this. Or invent some
other internal flag, but there's not many bits left.

> And XFS shouldn't need the NOFAIL allocation here, but this will break
> things elsewhere as well.
> 

