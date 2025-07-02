Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F0822DFAA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 07:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751441349; cv=none; b=stCuJIUKDBsr/Dk4zbE+9qWOi7xxo/gfyep7ZY7epdpVXWC+rQRt9D54n2bv496f/vEHXpr6zNrkRONGson+JiLlg14c8RDCCV+vZswAEv+ezSVWlorVJ+QzxH+OEwKL9rgkqw44rlS4iCnmPcg1gZFif7uyVb99jlSPDb6EOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751441349; c=relaxed/simple;
	bh=xRQapr6D0j6OmROc6lj3PVObtZoVb816wxd2vQ5M7Ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zb79DKUYfEzvouE4AK7RHvUHhyp1BVN36/TfNmYZNjZHyOjj8kyq6giMWQCpGlb8JXPRWxuOH+Qk4KhETAk4gtGDGdTGTGaXVaBw4p1Ni3DlzcAcAPqt1PoYIePK02vSb99WiQt4qhhCVtyunGeYj3QkNHHZtYXdQ0GEiDKE+4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XiLMRqTq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O1aNKbuL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XiLMRqTq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O1aNKbuL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XiLMRqTq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O1aNKbuL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XiLMRqTq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O1aNKbuL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B417F1F445;
	Wed,  2 Jul 2025 07:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751441345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVIsBl9hllwNnK2RPVGCxz20gNq3g7ebI1tf7GBZSuw=;
	b=XiLMRqTqr/R+laACxUArPADJvhuczPIpV8BIM/OFa04GcQAJ5bKHB+s9KwpHmLkoGUTIJe
	dpqvkxW3xoGTM8EVjIF4BQGpLGIyiVFQHRVdgvjXTufa2tV5uo+BflkguvRafAIh5CA8WV
	05yu8ea8XgNV8OUizXg/g+SZgDpyMPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751441345;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVIsBl9hllwNnK2RPVGCxz20gNq3g7ebI1tf7GBZSuw=;
	b=O1aNKbuLz7uO3z9xmridSpDFKfIzEEsNMTZyUI/55JHCpN7yDdH+lVC7BxN6L8hBnRjls7
	0NDRNSWvkdxjH1Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751441345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVIsBl9hllwNnK2RPVGCxz20gNq3g7ebI1tf7GBZSuw=;
	b=XiLMRqTqr/R+laACxUArPADJvhuczPIpV8BIM/OFa04GcQAJ5bKHB+s9KwpHmLkoGUTIJe
	dpqvkxW3xoGTM8EVjIF4BQGpLGIyiVFQHRVdgvjXTufa2tV5uo+BflkguvRafAIh5CA8WV
	05yu8ea8XgNV8OUizXg/g+SZgDpyMPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751441345;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVIsBl9hllwNnK2RPVGCxz20gNq3g7ebI1tf7GBZSuw=;
	b=O1aNKbuLz7uO3z9xmridSpDFKfIzEEsNMTZyUI/55JHCpN7yDdH+lVC7BxN6L8hBnRjls7
	0NDRNSWvkdxjH1Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A0CF1369C;
	Wed,  2 Jul 2025 07:29:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VtfvBMHfZGiuOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 02 Jul 2025 07:29:05 +0000
Message-ID: <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz>
Date: Wed, 2 Jul 2025 09:30:30 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Zi Yan
 <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, Harry Yoo <harry.yoo@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <DDD5FAAF-F698-4FC8-B49C-FD1D3B283A8E@nvidia.com>
 <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[359a67b608de1ef72f65];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,linux-foundation.org,nvidia.com,sk.com,redhat.com,gourry.net,gmail.com,vger.kernel.org,kvack.org,intel.com,googlegroups.com,linux.alibaba.com,oracle.com,suse.com,infradead.org];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Level: 

+CC xfs and few more

On 7/2/25 3:41 AM, Tetsuo Handa wrote:
> On 2025/07/02 0:01, Zi Yan wrote:
>>>  __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:4972
>>>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>>>  alloc_slab_page mm/slub.c:2451 [inline]
>>>  allocate_slab+0xe2/0x3b0 mm/slub.c:2627
>>>  new_slab mm/slub.c:2673 [inline]
>>
>> new_slab() allows __GFP_NOFAIL, since GFP_RECLAIM_MASK has it.
>> In allocate_slab(), the first allocation without __GFP_NOFAIL
>> failed, the retry used __GFP_NOFAIL but kmem_cache order
>> was greater than 1, which led to the warning above.
>>
>> Maybe allocate_slab() should just fail when kmem_cache
>> order is too big and first trial fails? I am no expert,
>> so add Vlastimil for help.

Thanks Zi. Slab shouldn't fail with __GFP_NOFAIL, that would only lead
to subsystems like xfs to reintroduce their own forever retrying
wrappers again. I think it's going the best it can for the fallback
attempt by using the minimum order, so the warning will never happen due
to the calculated optimal order being too large, but only if the
kmalloc()/kmem_cache_alloc() requested/object size is too large itself.

Hm but perhaps enabling slab_debug can inflate it over the threshold, is
it the case here? I think in that rare case we could convert such
fallback allocations to large kmalloc to avoid adding the debugging
overhead - we can't easily create an individual slab page without the
debugging layout for a kmalloc cache with debugging enabled.

>> Barry, who added the nofail
>> warning is cc’d.

Barry's commit 903edea6c53f0 reorganized the warnings, but it existed
already long before.

> Indeed. In allocate_slab(struct kmem_cache *s, gfp_t flags, int node),
> 
> 	/*
> 	 * Let the initial higher-order allocation fail under memory pressure
> 	 * so we fall-back to the minimum order allocation.
> 	 */
> 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
> 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
> 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_RECLAIM;
> 
> 	slab = alloc_slab_page(alloc_gfp, node, oo);
> 	if (unlikely(!slab)) {
> 		oo = s->min;
> 		alloc_gfp = flags;
> 		/*
> 		 * Allocation may have failed due to fragmentation.
> 		 * Try a lower order alloc if possible
> 		 */
> 		slab = alloc_slab_page(alloc_gfp, node, oo);
> 
> __GFP_NOFAIL needs to be dropped unless s->min is either 0 or 1.

No, that would violate __GFP_NOFAIL semantics.

> 
> 		if (unlikely(!slab))
> 			return NULL;
> 		stat(s, ORDER_FALLBACK);
> 	}
> 
> 
> 
> By the way, why is xfs_init_fs_context() using __GFP_NOFAIL ?
> 
> 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
> 	if (!mp)
> 		return -ENOMEM;
> 
> This looks an allocation attempt which can fail safely.

Indeed. Dave Chinner's commit f078d4ea82760 ("xfs: convert kmem_alloc()
to kmalloc()") dropped the xfs wrapper. This allocation didn't use
KM_MAYFAIL so it got __GFP_NOFAIL. The commit mentions this high-order
nofail issue for another allocation site that had to use xlog_kvmalloc().

I think either this allocation really can fail as the code (return
-ENOMEM) suggests and thus can drop __GFP_NOFAIL, or it can use
kvmalloc() - I think the wrapper for that can be removed now too after
the discussion in [1] resulted in commit 46459154f997 ("mm: kvmalloc:
make kmalloc fast path real fast path").

[1] https://lore.kernel.org/all/Z_XI6vBE8v_cIhjZ@dread.disaster.area/
