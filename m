Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63663331A5C
	for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 09:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049641; cv=none; b=jcjkInlhRXj03YcTe6/UTFXkpC/r+aRAT5KO14PMacI4/zB/mvkiMC2KJTF7lJL1DI1CeDNFNtkC26iXX3bbXwTOcIzUlxt9f5lJEo07QKwt3EUdiT2DcWuynjZqLs/F0gRc3WMJ79IkvNWJ8JmXPVNyrrISzrnmXeMHQo38q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049641; c=relaxed/simple;
	bh=n13k21UmYy1b/UkjF11Z2Y0yZLMTJWxEi0AKEP4HOek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u0Abrojry0esaOZB9s7B0xtT0vGTPaPXi7QUxopUK8LugAhPvJ5Mwj9Fk95HYZzctLu/FSmRy6yZ5T+C10lS+y+Pkq7h7mM5YqFzoCrKqYrNCV5U/60ArqdujQZ9ilR6dkmy4e8JuiXE+OKsBiNf2HbhbhPlFkJlBk4WZNYMYNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sDeC5gTG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VdQ7kDio; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sDeC5gTG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VdQ7kDio; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sDeC5gTG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VdQ7kDio";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sDeC5gTG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VdQ7kDio"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0CCD433707;
	Thu, 18 Dec 2025 09:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766049632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgHRunWU3mgkIFMaOJpS/P/FKTY9rTZ7V7UUMmOw87k=;
	b=sDeC5gTGtQaAbjjfVjKHThf7w6jaLSnqtRyufB5ib7/iStFlNVAkycwTlrFquT4XioA38W
	37ce/2dymd+xJHGjT0qh/C3wRuPpnyInRJHgLaX87mjTiFSg+46/LkUoOJEyomLpNlBTsZ
	R+d6PXQpfXrjxuswLdGccSYxO9fiHKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766049632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgHRunWU3mgkIFMaOJpS/P/FKTY9rTZ7V7UUMmOw87k=;
	b=VdQ7kDioJTRON4sh4sTNzbi5xdC0SxUkafYAeDKbYWiaxuTlGZS238ZjzwqcB1p9t9NzaH
	LDDNBBZjtOm3UbDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766049632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgHRunWU3mgkIFMaOJpS/P/FKTY9rTZ7V7UUMmOw87k=;
	b=sDeC5gTGtQaAbjjfVjKHThf7w6jaLSnqtRyufB5ib7/iStFlNVAkycwTlrFquT4XioA38W
	37ce/2dymd+xJHGjT0qh/C3wRuPpnyInRJHgLaX87mjTiFSg+46/LkUoOJEyomLpNlBTsZ
	R+d6PXQpfXrjxuswLdGccSYxO9fiHKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766049632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WgHRunWU3mgkIFMaOJpS/P/FKTY9rTZ7V7UUMmOw87k=;
	b=VdQ7kDioJTRON4sh4sTNzbi5xdC0SxUkafYAeDKbYWiaxuTlGZS238ZjzwqcB1p9t9NzaH
	LDDNBBZjtOm3UbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9EF13EA63;
	Thu, 18 Dec 2025 09:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IPsSMF/HQ2nQIQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 18 Dec 2025 09:20:31 +0000
Message-ID: <b5dbf7d2-8e4e-4a96-a04b-a14ed83beb2e@suse.de>
Date: Thu, 18 Dec 2025 10:20:31 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg
 <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-2-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251218063234.1539374-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.27 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.17)[-0.829];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.27

On 12/18/25 07:31, Christoph Hellwig wrote:
> Add a helper to allow an existing bio to be resubmitted withtout
> having to re-add the payload.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c         | 25 +++++++++++++++++++++++++
>   include/linux/bio.h |  1 +
>   2 files changed, 26 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index e726c0e280a8..1b68ae877468 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -311,6 +311,31 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>   }
>   EXPORT_SYMBOL(bio_reset);
>   
> +/**
> + * bio_reuse - reuse a bio with the payload left intact
> + * @bio bio to reuse
> + *
> + * Allow reusing an existing bio for another operation with all set up
> + * fields including the payload, device and end_io handler left intact.
> + *
> + * Typically used for bios first used to read data which is then written
> + * to another location without modification.
> + */
> +void bio_reuse(struct bio *bio)
> +{
> +	unsigned short vcnt = bio->bi_vcnt, i;
> +	bio_end_io_t *end_io = bio->bi_end_io;
> +	void *private = bio->bi_private;
> +
> +	bio_reset(bio, bio->bi_bdev, bio->bi_opf);
> +	for (i = 0; i < vcnt; i++)
> +		bio->bi_iter.bi_size += bio->bi_io_vec[i].bv_len;
> +	bio->bi_vcnt = vcnt;
> +	bio->bi_private = private;
> +	bio->bi_end_io = end_io;
> +}
> +EXPORT_SYMBOL_GPL(bio_reuse);
> +

'reuse' has a different connotation for me; I woudl have expected
a 'reused' bio to be used for any purposes.
Maybe 'bio_reprep'?

Otherwise looks good.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
