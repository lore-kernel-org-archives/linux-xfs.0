Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DAB3D9DA4
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778496013; cv=none; b=J0N8jcEx8O62EVy0KTo1c6ox4kVMiMLRh8ksgkMLgv28fN/82//N34OBet6wjlSoCRhA8VOw/qx0lX5XhDj5MiJ1ETz0Hk09fcE8bFEGJH8OHhKDpeakq+FFXgMMIUfLevqsK3RTJVvAbraaiA/j6G7Czv2rO62BoKEnic9+WEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778496013; c=relaxed/simple;
	bh=J1sXdF9vPJ7ICj/wMdF1/e1AuJ7CO+FnEozUrNXSO3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jaK2G0VGIT5+qiZTqt9ANo+SOvF0Eom6Zx37X3F8ZrC0fT3P0FeWBwHtNd7z6g41Fw/AZLkSTU9M5aHbVPtOMKUnxooua+vj3DrhFeQ5DdC+bfOj03E+Un1P9DtpdRubt4Kq+6nF8fnAfBLyUXtSQGEdjxgn7nmMYqVggS48SH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KZ2DUaPi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w3lXbRzc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KZ2DUaPi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w3lXbRzc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KZ2DUaPi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w3lXbRzc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KZ2DUaPi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w3lXbRzc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90E5A6870C;
	Mon, 11 May 2026 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778496010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWwg0bXJYVGVFc68s5LxY5PVfGsatvdkIHez37aUjWA=;
	b=KZ2DUaPiGfWfpK0uPOrSMeNbfAMkZ/TnDbQuIuwLRJAoHesU8/JiQN63sCviBNUqR0hAfG
	NwMr/l/IsFAAwi704o+QSYLBhhYfe615/cjFn+9nyKflaKqRDXDzb+60E8ABOsQ1A0YmPp
	/90wjcd3CMg4rHguFvLCgE/7AjmNQXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778496010;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWwg0bXJYVGVFc68s5LxY5PVfGsatvdkIHez37aUjWA=;
	b=w3lXbRzcDBl1euuqFWwLZpeJXCRdBJKH7ndhPccBNB0InSxBOaGqWRW/Su0ADqLVNFLid7
	3z6bGREsfR2hFCBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KZ2DUaPi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=w3lXbRzc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778496010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWwg0bXJYVGVFc68s5LxY5PVfGsatvdkIHez37aUjWA=;
	b=KZ2DUaPiGfWfpK0uPOrSMeNbfAMkZ/TnDbQuIuwLRJAoHesU8/JiQN63sCviBNUqR0hAfG
	NwMr/l/IsFAAwi704o+QSYLBhhYfe615/cjFn+9nyKflaKqRDXDzb+60E8ABOsQ1A0YmPp
	/90wjcd3CMg4rHguFvLCgE/7AjmNQXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778496010;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWwg0bXJYVGVFc68s5LxY5PVfGsatvdkIHez37aUjWA=;
	b=w3lXbRzcDBl1euuqFWwLZpeJXCRdBJKH7ndhPccBNB0InSxBOaGqWRW/Su0ADqLVNFLid7
	3z6bGREsfR2hFCBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 788E4593A9;
	Mon, 11 May 2026 10:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gm7qGwqyAWoGeAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 11 May 2026 10:40:10 +0000
Message-ID: <11dd866b-3e48-412d-b558-29aa931546d8@suse.de>
Date: Mon, 11 May 2026 12:40:10 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: pass a minsize argument to bio_iov_iter_bounce
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <pankaj.raghav@linux.dev>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260507050153.1298375-1-hch@lst.de>
 <20260507050153.1298375-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260507050153.1298375-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 90E5A6870C
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/7/26 07:01, Christoph Hellwig wrote:
> When bouncing for block size > PAGE_SIZE file systems that require
> file system block size alignment (e.g. zoned XFS), the bio needs to
> be big enough to fit an entire block.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c          | 23 +++++++++++++----------
>   fs/iomap/direct-io.c |  2 +-
>   include/linux/bio.h  |  3 ++-
>   3 files changed, 16 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
