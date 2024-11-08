Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7513A27D
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 10:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731060530; cv=none; b=LDdyv9Butaf4S5/KAF6oe/xj793RcvT7EIFieGJRiP5B1n4y3besi2D8kCDKESLTQJKW5qyKiBNFNnuW0QGD+VvillqcNLtKrhzRKT0WFysC2Dhq26SrodyM5AHTpgvlermV3nVsjz3oEPpOlzwju5UydSfKWVR7j0ylsK9yxCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731060530; c=relaxed/simple;
	bh=TpIOwxg5NudBRAR0Mj6PJuzYAYi8vs+qIIweRmntu/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDXEeaKavBxB3Z1O2fWe80VHCmpb6Iarz2UQ8o1Z1YNa4MilGMRYzRqxS1eYGbwAOtU5q29fNK79SzZevpE8eX1C8gQYoOFsBacuKeFir1xu0H6E6LimqZUlFobyT8+MTOXUu6tuQiN3Q3ufzcGzMK4qcj9NqbPa/Fxl+eljVw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v1SQ1DFB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wb9gttcT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v1SQ1DFB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wb9gttcT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v1SQ1DFB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wb9gttcT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v1SQ1DFB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wb9gttcT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F26A221BFF;
	Fri,  8 Nov 2024 10:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1731060521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9sGYsJWaaHfBvLleB3NjdbLRs4MaOHS0axBvYWCw6Bw=;
	b=v1SQ1DFBw2aYIAUSHBwAifhITYUynDjvukGC1l8Y5psGs7qBQiV0ElM19LuficbaRxSSdU
	19SJzlW11SCkaetZ2e/iFx3GCybd/HZqdJ4epnraz332h/ydOVMAUvj0LVP4pwM6ywUoRy
	HC96tz3Yu+VON7VH4L4B9CZjT0poROM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1731060521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9sGYsJWaaHfBvLleB3NjdbLRs4MaOHS0axBvYWCw6Bw=;
	b=wb9gttcTKHpRIyLwVmJikQjZHDghyUt7kJv314DSKaCZ4YHLLwp8oPXrfmfzxTeh59Acke
	DEHG4omTTMHIfmBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1731060521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9sGYsJWaaHfBvLleB3NjdbLRs4MaOHS0axBvYWCw6Bw=;
	b=v1SQ1DFBw2aYIAUSHBwAifhITYUynDjvukGC1l8Y5psGs7qBQiV0ElM19LuficbaRxSSdU
	19SJzlW11SCkaetZ2e/iFx3GCybd/HZqdJ4epnraz332h/ydOVMAUvj0LVP4pwM6ywUoRy
	HC96tz3Yu+VON7VH4L4B9CZjT0poROM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1731060521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9sGYsJWaaHfBvLleB3NjdbLRs4MaOHS0axBvYWCw6Bw=;
	b=wb9gttcTKHpRIyLwVmJikQjZHDghyUt7kJv314DSKaCZ4YHLLwp8oPXrfmfzxTeh59Acke
	DEHG4omTTMHIfmBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D29FE13967;
	Fri,  8 Nov 2024 10:08:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aKsZMyjjLWeNLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Nov 2024 10:08:40 +0000
Message-ID: <dae2f548-cc2d-42ac-9a01-7382958001a7@suse.cz>
Date: Fri, 8 Nov 2024 11:08:40 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: slab warning: kmem_cache of name 'dm_bufio_buffer' already exists
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>, Dave Chinner
 <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>, Christoph Lameter
 <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org
References: <9c3fecc3-19dc-42d4-6c89-4a48e9ad19cc@redhat.com>
 <5a1e67c3-481e-4c6e-8507-5a8ea0bd9f28@suse.cz>
 <27ba7473-9255-2407-8e4e-e5c3cafc25c4@redhat.com>
 <e7fca292-7c79-4f97-a90c-d68178d8ca59@suse.cz>
 <58fce0d4-9074-3d98-5a1b-970371f0c23c@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <58fce0d4-9074-3d98-5a1b-970371f0c23c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linux.com,kernel.org,google.com,lge.com,linux-foundation.org,redhat.com,linux.dev,kvack.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On 11/6/24 22:22, Mikulas Patocka wrote:
> 
>> BTW, what benefits do you get from creating own kmem caches instead of using
>> kmalloc()? If it's just alignment, if you round up the intended size to
>> power of two, there's implicit kmalloc alignment guarantee.
> 
> See the function xfs_buf_alloc_kmem - it allocates a buffer using kmalloc, 
> tests if the buffer crosses a page boundary, and if it does, the code 
> falls back to xfs_buf_alloc_pages.
> 
> Do you think that it can be simplified to just allocate a buffer and NOT 
> check for page crossing?

Right, IIRC xfs was one of the usecases that prompted us towards defining
the kmalloc alignment guarantees, which was around 2019.
So today, kmalloc() allocations will not cross a page boundary if the
requested size is lower than page size, and it's a power-of-two value. Even
if SLUB debugging is enabled (before the alignment became guaranteed, it
would happen naturally, and only be violated by either using SLOB, or
enabling SLUB debugging).
xfs_buf_alloc_kmem() could be thus simplified.

>> AFAICS there's some alignment for c->slab_cache in 
>> dm_bufio_client_create()
> 
> There are two slab caches - one for the dm_buffer structure and one for 
> the buffer data (if the buffer size is less than a page).
> 
>> In case the allocations have odd sizes without any such alignment
>> (the case of c->slab_buffer?) separate size-specific caches can result in
>> better packing, but that should only matter if you expect many/long-lived
>> objects to be allocated.
> 
> The cache for the dm_buffer structure is there so that it utilizes memory 
> better. Yes - there may be a lot of long-lived dm_buffers in memory.

OK.

> Mikulas
> 

