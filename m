Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751F1292D2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 10:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714471603; cv=none; b=rLCSwm6dKGEYj61sfD6z4+BXE3UWCutKwZRAWmOBWcmXCYYFk6zFeRr+UM/SIg5uIO0mVQwisJU5W7XLqgrclFAZGdjbZs75XPJlg0txKq1ng3YE2mrFvFPr0y+p67H0JpZjZgs6VU9qnzFJNyC6+IghXkDR1486wgy4P5DY50Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714471603; c=relaxed/simple;
	bh=QwvIHhP9erYeqEw06B3xuM3FRzXjGIbbVyKPpGsXEMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4+Wo2NsHPO2L01CXYa7fOZlPEjiQty0xAjsK2rfGyAdsA3/k7CimA0PCZPtijCLz6IS9XkO6cpJaaScM8s6o2+SI58Jfmn1u+eRq7KRfSC1s3XcRDEbF2ougfqFhE16wYbP79Wd1EpnSfkD7TqqkdM67FQzzGQoLAAECGWhut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DVJsuzRl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QoyXCDEe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DVJsuzRl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QoyXCDEe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DVJsuzRl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QoyXCDEe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DVJsuzRl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QoyXCDEe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E38F33F4D;
	Tue, 30 Apr 2024 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fTxOpyNSTjXirdXLGX84M7gQy0fDakCNX4kbgGIAK/c=;
	b=DVJsuzRl5BSnBYk/bOrWgZfXY0RVeiZTvAbuL5BwEgNOZHX4j9rb4ljlZYFpy/32/Uix15
	BIRQsQm7idvF866DX96lj+Zay7PeafMzsJu+zfP7SW2FGrGdpc/qYwgaT/kOf4Zc+9zhIr
	x9d4SXVmv+dJ6suePo4kz8bPLr3wMzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fTxOpyNSTjXirdXLGX84M7gQy0fDakCNX4kbgGIAK/c=;
	b=QoyXCDEecYOKcJUt7CK890yTZM3tw2g/pXl2bw4Yodo2zK/CoHdcMUvelVvsScvbdM2dCE
	ozxlI2YAQZrxTBAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1714471593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fTxOpyNSTjXirdXLGX84M7gQy0fDakCNX4kbgGIAK/c=;
	b=DVJsuzRl5BSnBYk/bOrWgZfXY0RVeiZTvAbuL5BwEgNOZHX4j9rb4ljlZYFpy/32/Uix15
	BIRQsQm7idvF866DX96lj+Zay7PeafMzsJu+zfP7SW2FGrGdpc/qYwgaT/kOf4Zc+9zhIr
	x9d4SXVmv+dJ6suePo4kz8bPLr3wMzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1714471593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fTxOpyNSTjXirdXLGX84M7gQy0fDakCNX4kbgGIAK/c=;
	b=QoyXCDEecYOKcJUt7CK890yTZM3tw2g/pXl2bw4Yodo2zK/CoHdcMUvelVvsScvbdM2dCE
	ozxlI2YAQZrxTBAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F80C136A8;
	Tue, 30 Apr 2024 10:06:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKHqFqnCMGbaawAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Apr 2024 10:06:33 +0000
Message-ID: <b6a4d7a4-c4f9-45a9-a34b-205f6ecac2a7@suse.cz>
Date: Tue, 30 Apr 2024 12:06:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: fix nested allocation context filtering
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, osalvador@suse.de,
 elver@google.com, andreyknvl@gmail.com
References: <20240430054604.4169568-1-david@fromorbit.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
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
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,lst.de,suse.de,google.com,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email]

On 4/30/24 7:28 AM, Dave Chinner wrote:
> This patchset is the followup to the comment I made earlier today:
> 
> https://lore.kernel.org/linux-xfs/ZjAyIWUzDipofHFJ@dread.disaster.area/
> 
> Tl;dr: Memory allocations that are done inside the public memory
> allocation API need to obey the reclaim recursion constraints placed
> on the allocation by the original caller, including the "don't track
> recursion for this allocation" case defined by __GFP_NOLOCKDEP.
> 
> These nested allocations are generally in debug code that is
> tracking something about the allocation (kmemleak, KASAN, etc) and
> so are allocating private kernel objects that only that debug system
> will use.
> 
> Neither the page-owner code nor the stack depot code get this right.
> They also also clear GFP_ZONEMASK as a separate operation, which is
> completely redundant because the constraint filter applied
> immediately after guarantees that GFP_ZONEMASK bits are cleared.
> 
> kmemleak gets this filtering right. It preserves the allocation
> constraints for deadlock prevention and clears all other context
> flags whilst also ensuring that the nested allocation will fail
> quickly, silently and without depleting emergency kernel reserves if
> there is no memory available.
> 
> This can be made much more robust, immune to whack-a-mole games and
> the code greatly simplified by lifting gfp_kmemleak_mask() to
> include/linux/gfp.h and using that everywhere. Also document it so
> that there is no excuse for not knowing about it when writing new
> debug code that nests allocations.
> 
> Tested with lockdep, KASAN + page_owner=on and kmemleak=on over
> multiple fstests runs with XFS.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks.
