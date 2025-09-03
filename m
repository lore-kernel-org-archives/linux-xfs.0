Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348B264FB5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756922853; cv=none; b=MWeF0HpxeMCNw4jnAsRjlLGK6X+TFgzuNeaY+lUhWCH0CXYPXeJT1Tiaa6Ktg6ClBxrWwtfHXAkdas1d8SQ8jWqz8lT4p1uQNXYJQGZQwZUd4G1Hp24yy1klIzfUK+IkWwQv5GMWBNN05kS48NRT09tgFBLPFGoyLv/AEN5pisQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756922853; c=relaxed/simple;
	bh=upQMfC7hNHjJFJbDRgHo7N11cTPV0+/D7F1x6c0YR/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjYzXKAehVm8tHlP0Cm//pBa2UzyzlsG0NaHyrkezAfAzW7bt+wsZCbtgpLEeYNO0HW3XemdLMyf02pxcFAMi77wNXNMkd05YlkiEUWIZo8cBAiKmaeI8jGDlun2TyJYDLwm+fvdVZ/PQdawsO1xNzmWEAft970/PI72q0NbFiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V0SIoPzg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N2KMcL7/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V0SIoPzg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N2KMcL7/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V0SIoPzg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N2KMcL7/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V0SIoPzg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N2KMcL7/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 062791F38A;
	Wed,  3 Sep 2025 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756922850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K0SNTACYNeenCLdEDaEEX8EwxyvHt0mmXaw7faobCgU=;
	b=V0SIoPzg389i5USRAQXwTNhd7PHscbV4SZcAjyZd53BQFW8OU5IGlwSccCBq44x5qbH80T
	NULxT7lg7nsil0iBWuXJJOJDnwZFsyqrHahZymHw0oq2KJzPUD1LvrIVPJUZx1ohYzfAh3
	NNcU0aJQ+5VjmTpEbu9tJk0fnWECn4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756922850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K0SNTACYNeenCLdEDaEEX8EwxyvHt0mmXaw7faobCgU=;
	b=N2KMcL7/R/wao4vRRDLZ93xsPnvP8rzEy+d5MeEepecU5SqMxtdlzcvQ7WFA4MMjxxqDNU
	vTdYmuKCxFmdZNBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756922850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K0SNTACYNeenCLdEDaEEX8EwxyvHt0mmXaw7faobCgU=;
	b=V0SIoPzg389i5USRAQXwTNhd7PHscbV4SZcAjyZd53BQFW8OU5IGlwSccCBq44x5qbH80T
	NULxT7lg7nsil0iBWuXJJOJDnwZFsyqrHahZymHw0oq2KJzPUD1LvrIVPJUZx1ohYzfAh3
	NNcU0aJQ+5VjmTpEbu9tJk0fnWECn4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756922850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K0SNTACYNeenCLdEDaEEX8EwxyvHt0mmXaw7faobCgU=;
	b=N2KMcL7/R/wao4vRRDLZ93xsPnvP8rzEy+d5MeEepecU5SqMxtdlzcvQ7WFA4MMjxxqDNU
	vTdYmuKCxFmdZNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F040613A31;
	Wed,  3 Sep 2025 18:07:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HzM/OuGDuGhNGAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 18:07:29 +0000
Message-ID: <0b88c35a-9616-4ad9-9dec-978902f0e901@suse.cz>
Date: Wed, 3 Sep 2025 20:07:29 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: enable online fsck by default in Kconfig
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 9/3/25 17:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck has been a part of upstream for over a year now without any
> serious problems.  Turn it on by default in time for the 2025 LTS
> kernel.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/Kconfig |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index ecebd3ebab1342..dc55bbf295208d 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -137,7 +137,7 @@ config XFS_BTREE_IN_MEM
>  
>  config XFS_ONLINE_SCRUB
>  	bool "XFS online metadata check support"
> -	default n
> +	default y
>  	depends on XFS_FS
>  	depends on TMPFS && SHMEM
>  	select XFS_LIVE_HOOKS
> @@ -150,8 +150,6 @@ config XFS_ONLINE_SCRUB
>  	  advantage here is to look for problems proactively so that
>  	  they can be dealt with in a controlled manner.
>  
> -	  This feature is considered EXPERIMENTAL.  Use with caution!
> -
>  	  See the xfs_scrub man page in section 8 for additional information.
>  
>  	  If unsure, say N.

Should it still say that with default y?

> @@ -175,7 +173,7 @@ config XFS_ONLINE_SCRUB_STATS
>  
>  config XFS_ONLINE_REPAIR
>  	bool "XFS online metadata repair support"
> -	default n
> +	default y
>  	depends on XFS_FS && XFS_ONLINE_SCRUB
>  	select XFS_BTREE_IN_MEM
>  	help
> @@ -186,8 +184,6 @@ config XFS_ONLINE_REPAIR
>  	  formatted with secondary metadata, such as reverse mappings and inode
>  	  parent pointers.
>  
> -	  This feature is considered EXPERIMENTAL.  Use with caution!
> -
>  	  See the xfs_scrub man page in section 8 for additional information.
>  
>  	  If unsure, say N.

Ditto
