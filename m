Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FFA2D2383
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 07:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762326850; cv=none; b=orSAHpEKDMVHSOi7ew4D7fUipGMhVI+qw6xGBto2C+qws01rraKAhqCGNVh/bRJPx0kDnZBHfhc0TinlEDohfF8vb0UCFhRji/ZvwBxyh/5fAfg9pIsq9wqfs/gi5UvFx+VsuKC4YabhySr81jtl/dWgyKBG5l0WoYrHz1rVP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762326850; c=relaxed/simple;
	bh=7H1fhNllsJx9cEcEcsuhg54HQgWliSam8LLrwiOWY/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h2hKFXJ2As1Nu7UV9FTj120kZwbwUxuq99JPXR3zYS0wv/1dfBUnX4ucPuSBY7ZFpVOEVDuKi0LgQ6V3g06kjEMU8r9MCm0iohzWza55XeO7JZOn+avhMEET4DTvIs1YO72Z6rh+EYCS0/VnwGvmutQZco3JMQdgz4rsxnvrjzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BQrWy1pu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eEX2e7QK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BQrWy1pu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eEX2e7QK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BQrWy1pu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eEX2e7QK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BQrWy1pu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eEX2e7QK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A86C21192;
	Wed,  5 Nov 2025 07:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdZvQ0i6OaTxmcVuq8+ooiSc+ysgf4J+yTkRFYF9X7U=;
	b=BQrWy1puabSTI0tkYnmFKPMRqbUccGSXtI2DOoGTcH1WI2AzbP/PtS8JOvN+Xh6YbT5s3Z
	GVGKccwe9i83v2c2sV2RUafuCyz8/Z/wTT7yLOlwEE5bucZqumPvB3VHv0C65n//bAEUbh
	+JT/pxAYsoxRI5xHWIK4ZM16YOEwo6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdZvQ0i6OaTxmcVuq8+ooiSc+ysgf4J+yTkRFYF9X7U=;
	b=eEX2e7QKXAmZgNWiu0Vjwqk/8jMmha27UEXY/hBuyyCuBJtvRhgqemDEhTDGJXTiFOIdYa
	IEZOr4zmKo83ytCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdZvQ0i6OaTxmcVuq8+ooiSc+ysgf4J+yTkRFYF9X7U=;
	b=BQrWy1puabSTI0tkYnmFKPMRqbUccGSXtI2DOoGTcH1WI2AzbP/PtS8JOvN+Xh6YbT5s3Z
	GVGKccwe9i83v2c2sV2RUafuCyz8/Z/wTT7yLOlwEE5bucZqumPvB3VHv0C65n//bAEUbh
	+JT/pxAYsoxRI5xHWIK4ZM16YOEwo6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdZvQ0i6OaTxmcVuq8+ooiSc+ysgf4J+yTkRFYF9X7U=;
	b=eEX2e7QKXAmZgNWiu0Vjwqk/8jMmha27UEXY/hBuyyCuBJtvRhgqemDEhTDGJXTiFOIdYa
	IEZOr4zmKo83ytCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1280132DD;
	Wed,  5 Nov 2025 07:14:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jxNqKT75CmmmFwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 05 Nov 2025 07:14:06 +0000
Message-ID: <83168e99-3c65-4b6e-ae09-c3ee1de2cb5b@suse.de>
Date: Wed, 5 Nov 2025 08:14:06 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/15] xfs: use blkdev_report_zones_cached()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251104013147.913802-1-dlemoal@kernel.org>
 <20251104013147.913802-16-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251104013147.913802-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,lst.de:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 11/4/25 02:31, Damien Le Moal wrote:
> Modify xfs_mount_zones() to replace the call to blkdev_report_zones()
> with blkdev_report_zones_cached() to speed-up mount operations.
> 
> With this change, mounting a freshly formatted large capacity (30 TB)
> SMR HDD completes under 2s compared to over 4.7s before.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/xfs/xfs_zone_alloc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 23cdab4515bb..8d819bc134cd 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1231,7 +1231,7 @@ xfs_mount_zones(
>   	trace_xfs_zones_mount(mp);
>   
>   	if (bdev_is_zoned(bt->bt_bdev)) {
> -		error = blkdev_report_zones(bt->bt_bdev,
> +		error = blkdev_report_zones_cached(bt->bt_bdev,
>   				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
>   				mp->m_sb.sb_rgcount, xfs_get_zone_info_cb, &iz);
>   		if (error < 0)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
