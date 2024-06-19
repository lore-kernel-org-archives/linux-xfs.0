Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF0D2A8D3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718813862; cv=none; b=ij3WEFBjBmULOLWkSOeRH5fQH6QJdvGzkUMJawUtFlFWij9WRClCTpMhzupcLetLGQYAM4Jb1pxmh+RTkVy8v0WbsaOzkvzdfdmiO39qtQudsZpCiIyToqPt8HtgTLvPMNQ68xuqqq1MLjn6aJPgmdYAEwpPFCrqkVLAE/M00UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718813862; c=relaxed/simple;
	bh=uN6jn303/4iH4ErEhUAXA2FhMIjNbBHtOp/NNaWHEqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Szyhy5pMWEmF6w0CJsIWtm9ErXWqLpu6/iAPBzsy3FYB5268fJwrvdV3TrabZIflP8a2FQn5fV5D2InugaWwMpP1MdKJe4fot63njK6zScuBTUk/eJT0rWOXt96gxsdUDYs9vHu+MyqbTCdm7gaehMtDYj0p/42PciKJxTQShxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AT9R1NKf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hYoQUymT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AT9R1NKf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hYoQUymT; dkim=neutral (0-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=rPjVeZek; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AT9R1NKf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hYoQUymT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AT9R1NKf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hYoQUymT";
	dkim=neutral (0-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="rPjVeZek"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62E6121903;
	Wed, 19 Jun 2024 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718813858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:
	 list-unsubscribe:list-subscribe;
	bh=MleHXVbUMAHdRd/xLyS1Sy7LNchENQq4aiCEshzsRQE=;
	b=AT9R1NKfptVgj58b4tjinesYDDhJDoW0OCIGu97oqQCReHdAbuoyjHR/ekObL9MzMULno+
	jU6oWykYW7bwHuH9LO/LrlSMzcOLLFx5NEbsagr/VmmKRwl2VW2Q3I9reOC05NlSxWrucp
	8iM52bxXUM6oyvqnVgMK1jmZRD2FDS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718813858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:
	 list-unsubscribe:list-subscribe;
	bh=MleHXVbUMAHdRd/xLyS1Sy7LNchENQq4aiCEshzsRQE=;
	b=hYoQUymTLXPYnENPc4SLY8rI/cbFky68y1kQwYTKRQm1n/56LWXSS2tQTpuzmaTiBDsGxe
	u6YgYQB1VEdMH4CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AT9R1NKf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hYoQUymT;
	dkim=fail ("body hash did not verify") header.d=sandeen.net header.s=default header.b=rPjVeZek
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718813858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:
	 list-unsubscribe:list-subscribe;
	bh=MleHXVbUMAHdRd/xLyS1Sy7LNchENQq4aiCEshzsRQE=;
	b=AT9R1NKfptVgj58b4tjinesYDDhJDoW0OCIGu97oqQCReHdAbuoyjHR/ekObL9MzMULno+
	jU6oWykYW7bwHuH9LO/LrlSMzcOLLFx5NEbsagr/VmmKRwl2VW2Q3I9reOC05NlSxWrucp
	8iM52bxXUM6oyvqnVgMK1jmZRD2FDS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718813858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:
	 list-unsubscribe:list-subscribe;
	bh=MleHXVbUMAHdRd/xLyS1Sy7LNchENQq4aiCEshzsRQE=;
	b=hYoQUymTLXPYnENPc4SLY8rI/cbFky68y1kQwYTKRQm1n/56LWXSS2tQTpuzmaTiBDsGxe
	u6YgYQB1VEdMH4CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C31BE13AAA;
	Wed, 19 Jun 2024 16:17:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gqyKLqEEc2YsNAAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Wed, 19 Jun 2024 16:17:37 +0000
From: Petr Vorel <pvorel@suse.cz>
To: sandeen@sandeen.net,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: cmaiolino@redhat.com,
	djwong@kernel.org,
	hch@infradead.org,
	zlang@redhat.com,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH V3] xfsprogs: remove platform_zero_range wrapper
Date: Wed, 19 Jun 2024 18:17:32 +0200
Message-ID: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>
References: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>
Received: from sandeen.net (sandeen.net [63.231.237.45]) by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE3F188CBB for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 15:24:54 +0000 (UTC)
Received: from [10.0.0.71] (usg [10.0.0.1]) (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits)) (No client certificate requested) by sandeen.net (Postfix) with ESMTPSA id 00B2448C707; Fri,  7 Jun 2024 10:24:52 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 00B2448C707
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; s=default; t=1717773893; bh=p/5D+rr93Zh+0chkKlYaGiKj8IYcMuosSG1iBBBaAoE=; h=Date:To:Cc:From:Subject:From; b=rPjVeZekN+FPZu3SyKpBX3+NuxnYIGsyqclLyaWYR3RVbqcq7BU9nhVFJtCJgsh0N hsblp0H9Z1SYyUQFYt9ON/K2TYxRh9aq/qUw9cPwgpwmrROp45k4Xb10Kz3spf0scc LUmoMJeBYt4xY8VV8NGvv+X0MYBoOtepIpxb0tPGW/v6kI9D+lOM3p57GxY+GcF+9s 1LtrSNkcpZJC2dSErRz9lDLDe5L9zDUFWI3B4Q/Tkb06MKypFnCx+gcsd3U/6A1NXF 8Vj2KyIBzBeZ/SN5eJG77bSNVGNq6LnJObZiRRNUn/iUmu4PUhOdYO/KoSN3Y5ncTI 3+M8rbSGM3RSA==
Precedence: bulk
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.77 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_RHS_MATCH_TO(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MAILLIST(-0.15)[generic];
	SUSE_ML_WHITELIST_VGER(-0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	HAS_LIST_UNSUB(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email,sandeen.net:email,suse.cz:email,suse.cz:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-xfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_MIXED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_REJECT(0.00)[sandeen.net:s=default];
	DKIM_TRACE(0.00)[suse.cz:+,sandeen.net:-];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 62E6121903
X-Spam-Flag: NO
X-Spam-Score: -3.77
X-Spam-Level: 
Message-ID: <20240619161732.c7ikVcO6Yoh0M5zwKwC0q82jjV5T63teo5E0pFOgFV8@z>

From: Eric Sandeen <sandeen@sandeen.net>

> Now that the HAVE_FALLOCATE guard around including
> <linux/falloc.h> in linux/xfs.h has been removed via
> 15fb447f ("configure: don't check for fallocate"),
> bad things can happen because we reference fallocate in
> <xfs/linux.h> without defining _GNU_SOURCE:

> $ cat test.c
> #include <xfs/linux.h>

> int main(void)
> {
> 	return 0;
> }

> $ gcc -o test test.c
> In file included from test.c:1:
> /usr/include/xfs/linux.h: In function ‘platform_zero_range’:
> /usr/include/xfs/linux.h:186:15: error: implicit declaration of function ‘fallocate’ [-Wimplicit-function-declaration]
>   186 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>       |               ^~~~~~~~~

> i.e. xfs/linux.h includes fcntl.h without _GNU_SOURCE, so we
> don't get an fallocate prototype.

> Rather than playing games with header files, just remove the
> platform_zero_range() wrapper - we have only one platform, and
> only one caller after all - and simply call fallocate directly
> if we have the FALLOC_FL_ZERO_RANGE flag defined.

> (LTP also runs into this sort of problem at configure time ...)

> Darrick points out that this changes a public header, but
> platform_zero_range() has only been exposed by default
> (without the oddball / internal xfsprogs guard) for a couple
> of xfsprogs releases, so it's quite unlikely that anyone is
> using this oddball fallocate wrapper.

Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>

I suppose this should be added
Fixes: 9d6023a8 ("libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero")

Kind regards,
Petr

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

> V2: remove error variable, add to commit msg
> V3: Drop FALLOC_FL_ZERO_RANGE #ifdef per hch's suggestion and
>     add his RVB from V2, with changes.

> NOTE: compile tested only

> diff --git a/include/linux.h b/include/linux.h
> index 95a0deee..a13072d2 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -174,24 +174,6 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>  	endmntent(cursor->mtabp);
>  }

> -#if defined(FALLOC_FL_ZERO_RANGE)
> -static inline int
> -platform_zero_range(
> -	int		fd,
> -	xfs_off_t	start,
> -	size_t		len)
> -{
> -	int ret;
> -
> -	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> -	if (!ret)
> -		return 0;
> -	return -errno;
> -}
> -#else
> -#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
> -#endif
> -
>  /*
>   * Use SIGKILL to simulate an immediate program crash, without a chance to run
>   * atexit handlers.
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 153007d5..b54505b5 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -73,7 +73,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)

>  	/* try to use special zeroing methods, fall back to writes if needed */
>  	len_bytes = LIBXFS_BBTOOFF64(len);
> -	error = platform_zero_range(fd, start_offset, len_bytes);
> +	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
>  	if (!error) {
>  		xfs_buftarg_trip_write(btp);
>  		return 0;


