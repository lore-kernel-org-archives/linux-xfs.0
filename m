Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDA4688
	for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2024 07:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713511333; cv=none; b=US9kwH+Ws+7XcyC+1hlTxGIGzkm8ASQ6e1/H3ZeLs7OWZrRNWClUkpJhwURZxOK8PJU0nhXceTlNBcr1ZAM6uofjpNUKQHQosska2grYI/sa5QJZ7abPC9zGM1q8mJfQTsOrN9jAedowVh0K7UhDBcVnBJ1utWklpRbXzorjh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713511333; c=relaxed/simple;
	bh=DVLF7Y2qa92OEOgVJRhNa69ve+DmBH2CTOGM7T8UCxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXl1cNb8QL+lkuxN9POgSjc8bJ1ViVv843u06lrZmb4fnNiGp17mVBM0HP+ILfZ+Jq2Rngs0Lc3I4buOyi7vgpP8CCnyBSwTsrJMDi+s3HBbUuh6pFI5kSpyQWpVNtT9hc3zOt5ZjtuOSoiuU4TelmX6ll5vyowVSH3lsKvbjoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3MZmOQC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3MZmOQC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713511329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ufghlX9X/YZxYGKjwh33+ZH4tDDTY460s6418shg9c=;
	b=P3MZmOQChPSeUFl8l7y+N0pKNyXuTZzQD247z9iYNUODToaNUH5q8mNcIrqATG6dzuZ5N5
	IFEfFh5ivHB1GCyTt4ZUdxbXbmbDKNyqCqKoPvc01IjIeIsvGH1jFK+c0zytCjLuxXJU/A
	C3GV2XMgkQi1V6leCTmvDm0ARnMOmsc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-e8AZh_pXMR2WFLfu6EVAyA-1; Fri, 19 Apr 2024 03:22:07 -0400
X-MC-Unique: e8AZh_pXMR2WFLfu6EVAyA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6ee089eedb7so2688187b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2024 00:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713511326; x=1714116126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ufghlX9X/YZxYGKjwh33+ZH4tDDTY460s6418shg9c=;
        b=UxYEIPBLle+24AUrR/X+f7c6tWmiA3amjd1nq7bJY+sYJ2ctOlLpVXr2WkgYxd9nhG
         N6y1tqmsgXcrvZFwu6t3XyaYENHkzka48Wa59g6OlMRAM0YUN87qrvYZqsEScXyhnz4X
         moStBaU2kcjIsbYzbqehhbPqA7/CzU4c69xxgR3EessKKUCPdiL1XmOFK3Zaol8gVuH5
         WviAokbiVIPrFZ7r1vhpR61Ozou0sPPs7V6oLnI0twXuQJgz9pnWXn2ZZmUmOjxMfTzn
         qoGKwqCRh87/C+K8E0ZSck0viclgyqJIkx2axzhE6xqiU4BKExGoxbOTbYuS1mqfyZ7O
         wseA==
X-Forwarded-Encrypted: i=1; AJvYcCXnAGjUbbpomKY6/zVaNeuR8jHE/16xd11jHaQgIny0kW4eD1pNvNxi7WiNJ8nVdWPoCFkSgvthWL41n1d/kH2e+GtDGMIp57NE
X-Gm-Message-State: AOJu0Yyt8f5O+J+MtmVAOmXdkCZ/b1QVFBUdkGjqeibY6Dd4B91+wPPO
	RC7zwf1pf6ZR2mNQMaJMbhE6CkStNx/cmT/FxWOYUMF5VAjzr5wX9YMUallezL6SdwsiEl2jKnR
	pLkND6y/joIvV0q+etA1reDZZr7xUmwUbdCvQ2K7Tw+tR74ON9RMaDrnABA==
X-Received: by 2002:a05:6a00:2d87:b0:6ec:eacb:ecd2 with SMTP id fb7-20020a056a002d8700b006eceacbecd2mr1350372pfb.33.1713511326072;
        Fri, 19 Apr 2024 00:22:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPsCyhIGDpvJlyIVCC+q0i/x4NfWtUYABDJ7g8PTdGst75EDTJ5dCscUyA7lsCqjSASFuqrw==
X-Received: by 2002:a05:6a00:2d87:b0:6ec:eacb:ecd2 with SMTP id fb7-20020a056a002d8700b006eceacbecd2mr1350355pfb.33.1713511325662;
        Fri, 19 Apr 2024 00:22:05 -0700 (PDT)
Received: from [10.72.116.75] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k124-20020a633d82000000b005f7d61ec8afsm957338pga.91.2024.04.19.00.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 00:22:05 -0700 (PDT)
Message-ID: <3ddfc8e2-8404-4a50-861d-a51cab5cd457@redhat.com>
Date: Fri, 19 Apr 2024 15:21:59 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] stackdepot: respect __GFP_NOLOCKDEP allocation flag
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
 kasan-dev@googlegroups.com, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <a0caa289-ca02-48eb-9bf2-d86fd47b71f4@redhat.com>
 <20240418141133.22950-1-ryabinin.a.a@gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240418141133.22950-1-ryabinin.a.a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/18/24 22:11, Andrey Ryabinin wrote:
> If stack_depot_save_flags() allocates memory it always drops
> __GFP_NOLOCKDEP flag. So when KASAN tries to track __GFP_NOLOCKDEP
> allocation we may end up with lockdep splat like bellow:
>
> ======================================================
>   WARNING: possible circular locking dependency detected
>   6.9.0-rc3+ #49 Not tainted
>   ------------------------------------------------------
>   kswapd0/149 is trying to acquire lock:
>   ffff88811346a920
> (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reclaim_inode+0x3ac/0x590
> [xfs]
>
>   but task is already holding lock:
>   ffffffff8bb33100 (fs_reclaim){+.+.}-{0:0}, at:
> balance_pgdat+0x5d9/0xad0
>
>   which lock already depends on the new lock.
>
>   the existing dependency chain (in reverse order) is:
>   -> #1 (fs_reclaim){+.+.}-{0:0}:
>          __lock_acquire+0x7da/0x1030
>          lock_acquire+0x15d/0x400
>          fs_reclaim_acquire+0xb5/0x100
>   prepare_alloc_pages.constprop.0+0xc5/0x230
>          __alloc_pages+0x12a/0x3f0
>          alloc_pages_mpol+0x175/0x340
>          stack_depot_save_flags+0x4c5/0x510
>          kasan_save_stack+0x30/0x40
>          kasan_save_track+0x10/0x30
>          __kasan_slab_alloc+0x83/0x90
>          kmem_cache_alloc+0x15e/0x4a0
>          __alloc_object+0x35/0x370
>          __create_object+0x22/0x90
>   __kmalloc_node_track_caller+0x477/0x5b0
>          krealloc+0x5f/0x110
>          xfs_iext_insert_raw+0x4b2/0x6e0 [xfs]
>          xfs_iext_insert+0x2e/0x130 [xfs]
>          xfs_iread_bmbt_block+0x1a9/0x4d0 [xfs]
>          xfs_btree_visit_block+0xfb/0x290 [xfs]
>          xfs_btree_visit_blocks+0x215/0x2c0 [xfs]
>          xfs_iread_extents+0x1a2/0x2e0 [xfs]
>   xfs_buffered_write_iomap_begin+0x376/0x10a0 [xfs]
>          iomap_iter+0x1d1/0x2d0
>   iomap_file_buffered_write+0x120/0x1a0
>          xfs_file_buffered_write+0x128/0x4b0 [xfs]
>          vfs_write+0x675/0x890
>          ksys_write+0xc3/0x160
>          do_syscall_64+0x94/0x170
>   entry_SYSCALL_64_after_hwframe+0x71/0x79
>
> Always preserve __GFP_NOLOCKDEP to fix this.
>
> Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
> Reported-by: Xiubo Li <xiubli@redhat.com>
> Closes: https://lore.kernel.org/all/a0caa289-ca02-48eb-9bf2-d86fd47b71f4@redhat.com/
> Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Closes: https://lore.kernel.org/all/f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com/
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>   lib/stackdepot.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 68c97387aa54..cd8f23455285 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -627,10 +627,10 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>   		/*
>   		 * Zero out zone modifiers, as we don't have specific zone
>   		 * requirements. Keep the flags related to allocation in atomic
> -		 * contexts and I/O.
> +		 * contexts, I/O, nolockdep.
>   		 */
>   		alloc_flags &= ~GFP_ZONEMASK;
> -		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
> +		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
>   		alloc_flags |= __GFP_NOWARN;
>   		page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
>   		if (page)

Tested it and this patch worked well for me.

Thanks

- Xiubo



