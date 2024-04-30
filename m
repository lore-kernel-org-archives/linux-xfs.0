Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1305256
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714455089; cv=none; b=XWuuMC3vLHFmKSp0AFI5ddFZc7S3ZyYFW5ZwYKu3KI2gnME83FIbz3nTUcmuk0dY9B5X9m+TeJoqwGGNwvLYWkI4qrp4ZLqpDgy+bP/rutPXC2itiL7YnSzS1+AikdNM/4PlsND3vFIHGJJmOz7ChFWWtiKNZPF+Ao8lPgit3uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714455089; c=relaxed/simple;
	bh=nkC69H0OLcogA9PKlgEihrnLNRnYBItjL+CgXJO6VJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XpEcpBImpvv7X4kvGnmfsSM65gQwkFPH5d3P0fwTln2hQk5xNdsStsz2T9+mK6WF7OGkPZIU9opmA9DYdGBSgQSCgDXZOfuW9UL1OXpXrpabDHUKeuo6qldbJA2sfJd44+V+X2R0JzbDT0FdV/0JmMTi8CKcFgxpTGRJSr+mxbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EHUdfk0B; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xrrZnpsD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EHUdfk0B; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xrrZnpsD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EHUdfk0B";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrrZnpsD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EHUdfk0B";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrrZnpsD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5217C33DC9;
	Tue, 30 Apr 2024 05:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714455085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1vETgkHqBSYsyE/+5wiWxoG0gxkURMYJb8qnN1EZNQ=;
	b=EHUdfk0BHtJsZ+fjZdIJO0j2UPDTarFGnkgQpVwKwuDQY312DwifCtqc8VYxoBxd5VdGRp
	UzEwE+jxfj5X7hvRGFNZwyjseJsMQw5p+z8VnhZ1mhPuB/lVdc8jGK0T1YuD8KxgAhrEer
	FCg8zVlEQ3g+d622VzOipIZ8CmVZuAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714455085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1vETgkHqBSYsyE/+5wiWxoG0gxkURMYJb8qnN1EZNQ=;
	b=xrrZnpsDfp50ETw5ceVGWU3thN0CFc79nyir9O83+6dFq+oAzg2TAopSRP+3LfB2ZkuHg/
	wExTTZNYzEc1tHBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EHUdfk0B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xrrZnpsD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714455085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1vETgkHqBSYsyE/+5wiWxoG0gxkURMYJb8qnN1EZNQ=;
	b=EHUdfk0BHtJsZ+fjZdIJO0j2UPDTarFGnkgQpVwKwuDQY312DwifCtqc8VYxoBxd5VdGRp
	UzEwE+jxfj5X7hvRGFNZwyjseJsMQw5p+z8VnhZ1mhPuB/lVdc8jGK0T1YuD8KxgAhrEer
	FCg8zVlEQ3g+d622VzOipIZ8CmVZuAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714455085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1vETgkHqBSYsyE/+5wiWxoG0gxkURMYJb8qnN1EZNQ=;
	b=xrrZnpsDfp50ETw5ceVGWU3thN0CFc79nyir9O83+6dFq+oAzg2TAopSRP+3LfB2ZkuHg/
	wExTTZNYzEc1tHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CD89138A7;
	Tue, 30 Apr 2024 05:31:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3xKGDi2CMGb/DQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Apr 2024 05:31:25 +0000
Message-ID: <1fb5b8f3-d8c7-4350-888a-ad8f4d54bc66@suse.cz>
Date: Tue, 30 Apr 2024 07:31:25 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm,page_owner: don't remove GFP flags in
 add_stack_record_to_list
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
 osalvador@suse.de, elver@google.com, andreyknvl@gmail.com,
 linux-mm@kvack.org, djwong@kernel.org, linux-xfs@vger.kernel.org
References: <20240429054706.1543980-1-hch@lst.de>
 <3e486c7f-57d4-4a36-a949-0cf19f10bf4f@suse.cz>
 <ZjAyIWUzDipofHFJ@dread.disaster.area>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <ZjAyIWUzDipofHFJ@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[lst.de,linux-foundation.org,suse.de,google.com,gmail.com,kvack.org,kernel.org,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5217C33DC9
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 4/30/24 1:49 AM, Dave Chinner wrote:
> On Mon, Apr 29, 2024 at 09:59:43AM +0200, Vlastimil Babka wrote:
>> On 4/29/24 7:47 AM, Christoph Hellwig wrote:
>> > This loses flags like GFP_NOFS and GFP_NOIO that are important to avoid
>> > deadlocks as well as GFP_NOLOCKDEP that otherwise generates lockdep false
>> > positives.
>> 
>> GFP_NOFS and GFP_NOIO translate to GFP_KERNEL without __GFP_FS/__GFP_IO so I
>> don't see how this patch would have helped with those.
>> __GFP_NOLOCKDEP is likely the actual issue and stackdepot solved it like this:
>> 
>> https://lore.kernel.org/linux-xfs/20240418141133.22950-1-ryabinin.a.a@gmail.com/
>>
>> So we could just do the same here.
> 
> Yes, it is __GFP_NOLOCKDEP that is the issue here, but
> cargo-cult-copying of that stackdepot fix is just whack-a-mole bug
> fixing without addressing the technical debt that got us here in the
> first place. Has anyone else bothered to look to see if kmemleak has
> the same problem?

Looks like you did :)

> If anyone bothered to do an audit, they would see that
> gfp_kmemleak_mask() handles the reclaim context masks correctly.
> Further, it adds NOWARN, NOMEMALLOC and
> NORETRY, which means the debug code is silent when it fails, it
> doesn't deplete emergency reserves and doesn't bog down retrying
> forever when there are sustained low memory situations.

So we do have NOWARN here. __GFP_RETRY_MAYFAIL might have been slightly
better than __GFP_NOWARN wrt "not retrying forever" but also not giving up
too soon. If we want to be really careful about reserves, it's a question
whether to keep the | GFP_ATOMIC which translates to leaving __GFP_HIGH.
OTOH if we don't keep it, these allocations might fail too easily from an
atomic context and we could miss the debugging data.

> This also points out that the page-owner/stackdepot code that strips
> GFP_ZONEMASK is completely redundant. Doing:
> 
> 	gfp_flags &= GFP_KERNEL|GFP_ATOMIC|__GFP_NOLOCKDEP;
> 
> strips everything but __GFP_RECLAIM, __GFP_FS, __GFP_IO,
> __GFP_HIGH and __GFP_NOLOCKDEP. This already strips the zonemask
> info, so there's no need to do it explicitly.

True.

> IOWs, the right way to fix this set of problems is to lift
> gfp_kmemleak_mask() to include/linux/gfp.h and then use it across
> all these nested allocations that occur behind the public
> memory allocation API.

Agree. But arguably these quick fixes adding __GFP_NOLOCKDEP were
appropriate for the late rc phase we're in.

> I've got a patchset under test at the moment that does this....

Great! Thanks.

> -Dave.

