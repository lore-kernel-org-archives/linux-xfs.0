Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC4134BF
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714377593; cv=none; b=GrleoT0V1WvwtEwEbXRMkB7vw8MxNc3MPKYEHlEzmRQYUPt88XJaeokvwlvZ86LhzZCBEJUJVpcUCwVqdoZuF8J+VMILRnEr9Us54U7MlLADYW/NIylcJkgv8bt53ksi8G0H1TNph7SFAN3ntDf/tDsYY/TW01M3HlOjajDqKmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714377593; c=relaxed/simple;
	bh=J/M3Kyyaxp9U40xUp5o+l0+F3r6uFcjQS9TUkAY64kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kuFL/WP8RR0gWp6Z+ZmIGWlD3v5+bltgtwnv2yfp5zRq16vlkpJitjzaPQtvEqh0GQ2D8K0kuR+4cOdqRxcbOJR9Vivcue4n0s2OSA/qSfJXhWg1D42twGjbrBgI2uV03OUK6Z4Y/lDvqoLmE8rmPOID8pGEjm2fJfJ4Y0XnXA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qOwwJqtu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9D6szPgE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qOwwJqtu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9D6szPgE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qOwwJqtu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9D6szPgE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qOwwJqtu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9D6szPgE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A686422B14;
	Mon, 29 Apr 2024 07:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714377583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jvmZqNemgCykxOSMl87YYizu5RB3gJTyHE7G4OaSmNw=;
	b=qOwwJqtulAYG6bDnwd8OS9AkorOhMykpaxjYWE6nfEYEUZZkTKu4mEHB5DHbiSFYXoGZGk
	HauX1pyZFQYzpuNsmFSzz+JAaIn0zmRoj6I5nBgTlFvuvQ4WTDdGC8RdQbr97G5Og8sLIy
	4krXmqX8b5StjEo0AcRVBtkkrBcL21A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714377583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jvmZqNemgCykxOSMl87YYizu5RB3gJTyHE7G4OaSmNw=;
	b=9D6szPgEVtaIm8ctWKph6O50A1dbrMDYt/pjfsYeE6CpsIpsfAA/TmSyALyZmhPz7Rmpp2
	thsUGPgPEmvn+FCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714377583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jvmZqNemgCykxOSMl87YYizu5RB3gJTyHE7G4OaSmNw=;
	b=qOwwJqtulAYG6bDnwd8OS9AkorOhMykpaxjYWE6nfEYEUZZkTKu4mEHB5DHbiSFYXoGZGk
	HauX1pyZFQYzpuNsmFSzz+JAaIn0zmRoj6I5nBgTlFvuvQ4WTDdGC8RdQbr97G5Og8sLIy
	4krXmqX8b5StjEo0AcRVBtkkrBcL21A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714377583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jvmZqNemgCykxOSMl87YYizu5RB3gJTyHE7G4OaSmNw=;
	b=9D6szPgEVtaIm8ctWKph6O50A1dbrMDYt/pjfsYeE6CpsIpsfAA/TmSyALyZmhPz7Rmpp2
	thsUGPgPEmvn+FCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90A2C139DE;
	Mon, 29 Apr 2024 07:59:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RQ7tIm9TL2ZVAQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Apr 2024 07:59:43 +0000
Message-ID: <3e486c7f-57d4-4a36-a949-0cf19f10bf4f@suse.cz>
Date: Mon, 29 Apr 2024 09:59:43 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm,page_owner: don't remove GFP flags in
 add_stack_record_to_list
To: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: elver@google.com, andreyknvl@gmail.com, linux-mm@kvack.org,
 djwong@kernel.org, david@fromorbit.com, linux-xfs@vger.kernel.org
References: <20240429054706.1543980-1-hch@lst.de>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240429054706.1543980-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[google.com,gmail.com,kvack.org,kernel.org,fromorbit.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[]

On 4/29/24 7:47 AM, Christoph Hellwig wrote:
> This loses flags like GFP_NOFS and GFP_NOIO that are important to avoid
> deadlocks as well as GFP_NOLOCKDEP that otherwise generates lockdep false
> positives.

GFP_NOFS and GFP_NOIO translate to GFP_KERNEL without __GFP_FS/__GFP_IO so I
don't see how this patch would have helped with those.
__GFP_NOLOCKDEP is likely the actual issue and stackdepot solved it like this:

https://lore.kernel.org/linux-xfs/20240418141133.22950-1-ryabinin.a.a@gmail.com/

So we could just do the same here.

> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Reported-by: Reported-by: syzbot+b7e8d799f0ab724876f9@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_owner.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index d17d1351ec84af..d214488846fa92 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -168,9 +168,7 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
>  	unsigned long flags;
>  	struct stack *stack;
>  
> -	/* Filter gfp_mask the same way stackdepot does, for consistency */
>  	gfp_mask &= ~GFP_ZONEMASK;
> -	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
>  	gfp_mask |= __GFP_NOWARN;
>  
>  	set_current_in_page_owner();

