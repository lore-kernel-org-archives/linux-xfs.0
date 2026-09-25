Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9C34052A6;
	Fri, 25 Sep 2026 05:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313309; cv=none; b=Prcd5et8tqG+SexikrL3AJIXRhgpCb7rHwPbiqF3ohtqZ4CoYBDkSfKhhvEkje/EzAxre0BWkIfrXkE6Sfrz7Zjjeamg+mk6mTqZmiQzhqT3psIcEHCdLT1WingqcXacZa4ipsJibiZEI5BFsPuusz/GIrt+IeDZM1rDyDFSsQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313309; c=relaxed/simple;
	bh=cpzX8IpCZX+alDCMZymgFbS2Dr4E0qIgHplTS9pQBtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wf/2z7W41Xdilg4zrl9476IfQtC2ELGAj/Lr3otmolbJe0DGrFw0liWwVJLBmzf4UYT6uL+i/Xg8wWyBMvPQklz/Z9pzU9u7j8ERla6BPLCnJMG14atVI3XhWS/DCf4mycthA8UD1lVybz1uRs5T3VmHKohAl9yBsUXDX0dhlac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dL5jpU6Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=smlDoST4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cd9GW5x4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TNNkR0n+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dL5jpU6Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="smlDoST4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cd9GW5x4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TNNkR0n+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DD5B21ADA;
	Fri, 25 Sep 2026 05:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790313298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZTFI5GppfkB88iIwO4OBFegC6QWGKH/v+BAXGjDetk=;
	b=dL5jpU6QwxxQI66nyu8+JtfKsg4UHtfCcrUaxKOs37UwjjfGsYdpaEKHHI9xx/NoI4Kcwo
	RmlIErjDTyiYlPLUlMHThsJIUh9MDBCIQQS67/Kp8U3MKPQs5J9KR+B6Ovo5FPHSpxg0Ip
	Qo7cFqKxW86M2K82kcrFzjZw+pTl2/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790313298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZTFI5GppfkB88iIwO4OBFegC6QWGKH/v+BAXGjDetk=;
	b=smlDoST4XPODTd0MSGIluoAL921tQ+JXYrGmfoi2pQbCODcPBAGHVHDD1mM59NNf4SMbDm
	qP3n7wV4CD35KEBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cd9GW5x4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TNNkR0n+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790313294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZTFI5GppfkB88iIwO4OBFegC6QWGKH/v+BAXGjDetk=;
	b=Cd9GW5x4NfNKoCzPAig+QLFfJr0fqhMveZsFYbsQxr6ZGLBIV5nfOs6/V74A1C6eHl3f16
	zGAQW8EoDmNZPaQEysnrvDFaydcwlQwK9KKnKoHvuZ6dUarTJK1hnpe6fmiMg3uHKpCNgB
	WdnkHrs3UPf0d5bKu7t2lifywFKLZso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790313294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZTFI5GppfkB88iIwO4OBFegC6QWGKH/v+BAXGjDetk=;
	b=TNNkR0n+RiwPy8di2MLf2rx/vcANpBXV6ukZJhQ/0vq755TsIDPWc/dsaQfl8L7NbPM57t
	JwVdBCkQDf0k1XBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4BEC136F7;
	Fri, 25 Sep 2026 05:14:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lGqAH00DtmqDBAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 25 Sep 2026 05:14:53 +0000
Message-ID: <247fa6c0-6523-4476-b4ca-98f730b1f798@suse.de>
Date: Fri, 25 Sep 2026 07:14:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/9] iomap: reject atomic writes in
 iomap_file_buffered_write()
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Hannes Reinecke <hare@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 John Garry <john.garry@linux.dev>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260923-blkdev-fixes-v5-0-89e60d66eb38@columbia.edu>
 <20260923-blkdev-fixes-v5-7-89e60d66eb38@columbia.edu>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260923-blkdev-fixes-v5-7-89e60d66eb38@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 5DD5B21ADA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[columbia.edu:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:email,suse.de:dkim,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 9/24/26 1:56 AM, Tal Zussman wrote:
> Buffered atomic writes are not currently supported. The page cache
> writes folios back independently, so it cannot guarantee that a range is
> written atomically. iomap_file_buffered_write() does not check for
> IOCB_ATOMIC, so a direct write that falls back to it would complete an
> atomic write without atomicity. While no such case currently exists,
> fail IOCB_ATOMIC writes with -EOPNOTSUPP, so that a future fallback
> cannot complete an atomic write non-atomically.
> 
> Suggested-by: John Garry <john.garry@linux.dev>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>   fs/iomap/buffered-io.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 0a5ebfda90f1..e6654cfe1cbf 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1304,6 +1304,10 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
>   	};
>   	ssize_t ret;
>   
> +	/* Buffered atomic writes are not supported */
> +	if (iocb->ki_flags & IOCB_ATOMIC)
> +		return -EOPNOTSUPP;
> +
>   	if (iocb->ki_flags & IOCB_NOWAIT)
>   		iter.flags |= IOMAP_NOWAIT;
>   	if (iocb->ki_flags & IOCB_DONTCACHE)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
