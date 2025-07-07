Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249F9288CA5
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907429; cv=none; b=uB6yaNgLUVMHsUufkP2z55rshp+7f5C8FA0juFXRG2wSCcuUKDYMvvx6aVq0zWfoaarEa8QylV7MUQR85ciSclyfbU73M94PeftLFislw8yKEWJIiIbNfpDxOKgfmM19tgFoN5pRnf0WvcmAhxu38Ui/jzEB4C85eU/ThBOdJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907429; c=relaxed/simple;
	bh=9cLQ5UXUCyMU6eb0p98HvAcMlIguDXZpjqjvli8N9wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IcfrIBWj/xneaf5ynGsWFkc32KZqllCSH2h9cvBgOZbkLZSGbG1zltV3E0inQTUQyqaFCDWLIavm6j6tmxcCv/VcHlJeBxCasTns7rmGuP4GTGU28FdZvkRSSk+zI6At11qkcTTZvCYLMZ0JIDeLe81/qeZtER+XDhzhfB6FVjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QAM0NMwf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4b8m6dlO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QAM0NMwf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4b8m6dlO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QAM0NMwf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4b8m6dlO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QAM0NMwf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4b8m6dlO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17CBE1F390;
	Mon,  7 Jul 2025 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751907426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OtDkAbABZz5aQG5gNrzlgHDcxiJ1gZVQ1X16fMHHdVE=;
	b=QAM0NMwfHAHafx5rF2SfaQZBsXAmRPMqWNzvUKVV79qRJMgC9d3bqE98BVXQuJdS4L46s8
	mpRkotW0UrdpT3rGfgynzp8nWzpmWsWrhX0QRnlc4G8NjesaByyv2sVCcAwVloAWIs+DTl
	BFnnPxtVj4HGoqhVMdOzKYt498o9ye0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751907426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OtDkAbABZz5aQG5gNrzlgHDcxiJ1gZVQ1X16fMHHdVE=;
	b=4b8m6dlOVYs4KHN2iV+J64+Mn325hQ1hWRK0BgnCYJkxeqYzBd4pG3mfxpifnaISiDexGV
	hLDrS735bfqo22Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QAM0NMwf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4b8m6dlO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1751907426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OtDkAbABZz5aQG5gNrzlgHDcxiJ1gZVQ1X16fMHHdVE=;
	b=QAM0NMwfHAHafx5rF2SfaQZBsXAmRPMqWNzvUKVV79qRJMgC9d3bqE98BVXQuJdS4L46s8
	mpRkotW0UrdpT3rGfgynzp8nWzpmWsWrhX0QRnlc4G8NjesaByyv2sVCcAwVloAWIs+DTl
	BFnnPxtVj4HGoqhVMdOzKYt498o9ye0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1751907426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OtDkAbABZz5aQG5gNrzlgHDcxiJ1gZVQ1X16fMHHdVE=;
	b=4b8m6dlOVYs4KHN2iV+J64+Mn325hQ1hWRK0BgnCYJkxeqYzBd4pG3mfxpifnaISiDexGV
	hLDrS735bfqo22Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8B8513757;
	Mon,  7 Jul 2025 16:57:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tl2NNGH8a2iXXwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 07 Jul 2025 16:57:05 +0000
Message-ID: <0ab60aa4-6832-4f0b-97fa-7fc1f6e39f55@suse.cz>
Date: Mon, 7 Jul 2025 18:57:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Zi Yan
 <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>,
 syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, Michal Hocko <mhocko@suse.com>,
 Matthew Wilcox <willy@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <DDD5FAAF-F698-4FC8-B49C-FD1D3B283A8E@nvidia.com>
 <1921ec99-7abb-42f1-a56b-d1f0f5bc1377@I-love.SAKURA.ne.jp>
 <630b4379-751a-4bf1-a249-f2e051ec77d6@suse.cz> <aGeQTWHSjpc1JvbZ@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aGeQTWHSjpc1JvbZ@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 17CBE1F390
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[22];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[i-love.sakura.ne.jp,nvidia.com,kernel.org,vger.kernel.org,fromorbit.com,syzkaller.appspotmail.com,linux-foundation.org,sk.com,redhat.com,gourry.net,gmail.com,kvack.org,intel.com,googlegroups.com,linux.alibaba.com,suse.com,infradead.org];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[359a67b608de1ef72f65];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Spam-Score: -3.01

On 7/4/25 10:26, Harry Yoo wrote:
> On Wed, Jul 02, 2025 at 09:30:30AM +0200, Vlastimil Babka wrote:
>> +CC xfs and few more
>>=20
>> On 7/2/25 3:41 AM, Tetsuo Handa wrote:
>> > On 2025/07/02 0:01, Zi Yan wrote:
>> >>>  __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:4972
>> >>>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>> >>>  alloc_slab_page mm/slub.c:2451 [inline]
>> >>>  allocate_slab+0xe2/0x3b0 mm/slub.c:2627
>> >>>  new_slab mm/slub.c:2673 [inline]
>> >>
>> >> new_slab() allows __GFP_NOFAIL, since GFP_RECLAIM_MASK has it.
>> >> In allocate_slab(), the first allocation without __GFP_NOFAIL
>> >> failed, the retry used __GFP_NOFAIL but kmem_cache order
>> >> was greater than 1, which led to the warning above.
>> >>
>> >> Maybe allocate_slab() should just fail when kmem_cache
>> >> order is too big and first trial fails? I am no expert,
>> >> so add Vlastimil for help.
>>=20
>> Thanks Zi. Slab shouldn't fail with __GFP_NOFAIL, that would only lead=

>> to subsystems like xfs to reintroduce their own forever retrying
>> wrappers again. I think it's going the best it can for the fallback
>> attempt by using the minimum order, so the warning will never happen d=
ue
>> to the calculated optimal order being too large, but only if the
>> kmalloc()/kmem_cache_alloc() requested/object size is too large itself=
=2E
>=20
> Right. The warning would trigger only if the object size is bigger
> than 8k (PAGE_SIZE * 2).
>=20
>> Hm but perhaps enabling slab_debug can inflate it over the threshold, =
is
>> it the case here?
>=20
> CONFIG_CMDLINE=3D"earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.hu=
ng_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D2=
0000 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-co=
nntrack-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_ma=
sk=3D0 rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_h=
ash_pointers page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_over=
commit_hugepages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D=
1 msr.allow_writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=
=3DttyS0 vsyscall=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_stor=
e_bypass_disable=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2=
,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,=
1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 =
rose.rose_ndevs=3D32 smp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 w=
orkqueue.watchdog_thresh=3D140 sysctl.net.core.netdev_unregister_timeout_=
secs=3D140 dummy_hcd.num=3D32 max_loop=3D32 nbds_max=3D32 panic_on_warn=3D=
1"
>=20
> CONFIG_SLUB_DEBUG=3Dy
> # CONFIG_SLUB_DEBUG_ON is not set
>=20
> It seems no slab_debug is involved here.
>=20
> I downloaded the config and built the kernel, and
> sizeof(struct xfs_mount) is 4480 bytes. It should have allocated using
> order 1?

So it should be the kmalloc-8k cache, its min order should be get_order(8=
k)
thus 1. If the object was larger than 8k it would be a large kmalloc anyw=
ay
and also trigger the __GFP_NOFAIL warning but with a different stacktrace=
=2E

> Not sure why the min order was greater than 1?
> Not sure what I'm missing...

The only sane explanation is that slab debugging is enabled but not via
CONFIG_CMDLINE but via options passed to the qemu execution? But I don't =
see
those, nor the full dmesg (that would report them) in the syzbot dashboar=
d.

Hm or actually it might be kasan_cache_create() bumping our size when cal=
led
from calculate_sizes(). KASAN seems enabled...

>> I think in that rare case we could convert such
>> fallback allocations to large kmalloc to avoid adding the debugging
>> overhead - we can't easily create an individual slab page without the
>> debugging layout for a kmalloc cache with debugging enabled.
>=20
> Yeah that can be doable when the size is exactly 8k or very close to 8k=
=2E
>=20

