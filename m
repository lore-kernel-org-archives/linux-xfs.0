Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D5221D87
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 08:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751964635; cv=none; b=rd2mvxP5CzRtFb12Dn/eCQJOdVjSMfIRQFa8p9g10kFTOWaNdSJsuiCQOVjq9idLbnFHzSOu9pDYe7qifXfIcfhmz5bt4QAC65kXrH7gMaaMz9I0jzn5k1PPjjbLhDyb/wFfcgcenf01+tEUm4PZSDU9e2YnAv4HPQe4g1I0LI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751964635; c=relaxed/simple;
	bh=rU5S56Tjywba/GATBHNOl3N9qJOjs9GN3IxgTVFIRZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaeZtFBsSiXG07zmPVP/+pwUiK18sQeDyar/bA/b471Pr6UySg5FZB8Sb2Jv3+pC4JhtYGhazzOJUpuUoRkW7eEVcEYfVdMJWAIO9B4mYq9PiXeOaDb53JGUPcDvfpctRJgESC3d4n0hAbw/J2wBGSSzAejgs8lWxccyz+q+fXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yb8kEekc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RMaswhTs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yb8kEekc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RMaswhTs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yb8kEekc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RMaswhTs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yb8kEekc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RMaswhTs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9AFF721163;
	Tue,  8 Jul 2025 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751964631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gMCFCpkthoPDnqZLoQ6eE0mOo4CJZy8pXcbBxUNA1GI=;
	b=yb8kEekcx7VMwrl0kqiIlutBxj+2f6qt2heMp3G+HTTBlPjhI7hgFURWUFp3jX1p/4WsWa
	EbEtKf8ufIgG/2WJ2HL33urHp4Lb/uam8/G8xt1LrLs4KDAK8oVdi0YxkneuDW5FoOtA6E
	aC8U+sYARX+3VdTjUJfBOwO4+uGvzL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751964631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gMCFCpkthoPDnqZLoQ6eE0mOo4CJZy8pXcbBxUNA1GI=;
	b=RMaswhTsn4A2xOxws0wkKpz7lfGLUzzijcRjr4bjXQWPfWfRzlowgKApTqz5EdWoAH4sVL
	j0GNxqZGAAQBM7Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751964631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gMCFCpkthoPDnqZLoQ6eE0mOo4CJZy8pXcbBxUNA1GI=;
	b=yb8kEekcx7VMwrl0kqiIlutBxj+2f6qt2heMp3G+HTTBlPjhI7hgFURWUFp3jX1p/4WsWa
	EbEtKf8ufIgG/2WJ2HL33urHp4Lb/uam8/G8xt1LrLs4KDAK8oVdi0YxkneuDW5FoOtA6E
	aC8U+sYARX+3VdTjUJfBOwO4+uGvzL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751964631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gMCFCpkthoPDnqZLoQ6eE0mOo4CJZy8pXcbBxUNA1GI=;
	b=RMaswhTsn4A2xOxws0wkKpz7lfGLUzzijcRjr4bjXQWPfWfRzlowgKApTqz5EdWoAH4sVL
	j0GNxqZGAAQBM7Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 64C4C13A68;
	Tue,  8 Jul 2025 08:50:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tNGDF9fbbGgXXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 08 Jul 2025 08:50:31 +0000
Message-ID: <5397779c-9a89-4dd3-9937-208fefb58f78@suse.cz>
Date: Tue, 8 Jul 2025 10:50:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Zi Yan
 <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, Harry Yoo <harry.yoo@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <DDD5FAAF-F698-4FC8-B49C-FD1D3B283A8E@nvidia.com>
 <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
 <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz>
 <aGxF7NqHNK7Vtd1_@dread.disaster.area>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aGxF7NqHNK7Vtd1_@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[359a67b608de1ef72f65];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[i-love.sakura.ne.jp,nvidia.com,kernel.org,vger.kernel.org,syzkaller.appspotmail.com,linux-foundation.org,sk.com,redhat.com,gourry.net,gmail.com,kvack.org,intel.com,googlegroups.com,linux.alibaba.com,oracle.com,suse.com,infradead.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

On 7/8/25 00:10, Dave Chinner wrote:
> On Wed, Jul 02, 2025 at 09:30:30AM +0200, Vlastimil Babka wrote:
>> On 7/2/25 3:41 AM, Tetsuo Handa wrote:
>> > By the way, why is xfs_init_fs_context() using __GFP_NOFAIL ?
>> > 
>> > 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
>> > 	if (!mp)
>> > 		return -ENOMEM;
>> > 
>> > This looks an allocation attempt which can fail safely.
> 
> It's irrelevant - it shouldn't fail regardless of __GFP_NOFAIL being
> specified.

If you mean the "too small to fail" behavior then it's generally true,
except in some corner cases like being an oom victim, in which case the
allocation can fail - the userspace process is doomed anyway. But a (small)
kernel allocation not handling NULL would still need __GFP_NOFAIL to prevent
that corner case.

>> Indeed. Dave Chinner's commit f078d4ea82760 ("xfs: convert kmem_alloc()
>> to kmalloc()") dropped the xfs wrapper. This allocation didn't use
>> KM_MAYFAIL so it got __GFP_NOFAIL. The commit mentions this high-order
>> nofail issue for another allocation site that had to use xlog_kvmalloc().
> 
> I don't see how high-order allocation behaviour is relevant here.
> 
> Pahole says the struct xfs_mount is 4224 bytes in length. It is an
> order-1 allocation and if we've fragmented memory so badly that slab
> can't allocate an order-1 page then *lots* of other stuff is going
> to be stalling. (e.g. slab pages for inodes are typically order-3,
> same as the kmalloc-8kk slab).

Elsewhere in this thread we figured it out since I wrote the quoted reply.
4224 bytes means kmalloc-8k where the fallback allocation (the one that
passes on the __GFP_NOFAIL) order is 1 normally. But due to KASAN enabled
its metadata means the per-object size goes above 8k and thus the fallback
order will be 2. It's a corner case that wasn't anticipated and existed for
years without known reports. We'll need to deal with it somehow.

> Note that the size of the structure is largely because of the
> embedded cpumask for inodegc:
> 
> 	struct cpumask             m_inodegc_cpumask;    /*  3104  1024 */
> 
> This should probably be pulled out into a dynamically allocated
> inodegc specific structure. Then the struct xfs_mount is only a
> order-0 allocation and should never fail, regardless of
> __GFP_NOFAIL being specified or not.
> 
>> I think either this allocation really can fail as the code (return
>> -ENOMEM) suggests and thus can drop __GFP_NOFAIL, or it can use
>> kvmalloc() - I think the wrapper for that can be removed now too after
>> the discussion in [1] resulted in commit 46459154f997 ("mm: kvmalloc:
>> make kmalloc fast path real fast path").
> 
> I know about that - I have patches that I'm testing that replace
> xlog_kvmalloc() with kvmalloc calls.

Great, thanks!

> -Dave.

