Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C6937C
	for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2024 02:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713495003; cv=none; b=G6BzKOTT6CvRqkI0ltKesehbLGHZQEnAMw/LecPBuTI2PQQNNV6hh6dVIQAeKo91Q/0kSDTlcfX7i5pIh7IX8vJdLrA+QgGXDwhKSkWbOPKVToFHt9au3oVr8arEB8Ea2ft/eCWF/25qOPSO/etrReGhbFU6eo+QRznnX/XJ+t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713495003; c=relaxed/simple;
	bh=TW92Di9/k1NMxTp1kvBtWHNPsYWEu5/Uotbx6yUZ8/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TwDhgqvHR21xgb7sEzUJEthSlm4gIZEZNZ6NQjMXTs1X/k1fXTu0JGOfM5Sm60DFBS0K4spdIfFeF8HGBbfQaW6cXLYL+BqSjl1hDKMbNcIDIIi1lBsCX4ZYpN5uwP2JOghISXFLvXtG7zMZYGDb91uvP2Y46hzupk99g8pMm9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ndj2hQgI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ndj2hQgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713494999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d1Tjr14BdvOl8V5MxjQ4hi2dx9l67KXMdwhIGgoSO6c=;
	b=Ndj2hQgIjOVkjO3/7hxYjOOOhl7SEGE9wwyh/lMfQuccdwuWUdXxtOKUUJS4MwvdLLD3uK
	13ES30vL+Nq0ovQPTMaYG69nQYJgD7S/LnIS2ujvuGiw7tldRA7CY4QWneZuHidvwepOHw
	K0J1xJIOxxm2ZMn6CSmOmrsO+/S4dEE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-3negfWTMOwuvZQx4vmLoOA-1; Thu, 18 Apr 2024 22:49:58 -0400
X-MC-Unique: 3negfWTMOwuvZQx4vmLoOA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1e8d6480f77so1853465ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 19:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713494997; x=1714099797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1Tjr14BdvOl8V5MxjQ4hi2dx9l67KXMdwhIGgoSO6c=;
        b=BnjDW26VraGA3j8QbIqwY+ia3ekcJDAwi7FKL0lUdSEH04ffHdmZ2l0b0198IHtihw
         3ssYkdZRohLAk+Mhws7hU0+fKwcyzorO7t8rzUTCbjfEiJkO5nm6us67vcN38PA9sYe7
         Ya6YkgdHcIPTb5IZP78vBdcmeKVVHLCsZ9tK2oEm4G9SFtPUEE3vSYcKGzGSGtLT95il
         zVWW6Cuq0E+J8EdN0gU5dUxgTRa3XKIDlwz8K0fJXu4DiSz/ZrGd23zBDI3+4DJh+uiX
         CkmLAJFzYlr8KMIk/+IFO3Ksf/rn2sLc2IL7V7LoHHb76TNgQbIXaAPE3cetBmixx+R5
         0IVA==
X-Forwarded-Encrypted: i=1; AJvYcCUEnf+ZWWVsfBQzCPLoK2/NGDyb9KgQOEIyldc1dMWa2d+ms1bcC+a6rxtY/nGZBF2LrdJD1whhCcmBp23F4LHnKjfCIOw7wgTd
X-Gm-Message-State: AOJu0YxNZnfdhyBBjH0kzMoQ0QXTL5nbOAbUUW7GwQ454m1KX9J97UE6
	K19y/1ki1EnJcnfjFg5C5gl/nZpwXFKOKfjDczc2wa+FLPZJaHAi9COcQ6NtWIMaYRT1ZYSJD0y
	l6tqccd1eW8k/4/QuT1hHhqBYJs0HZP2Xv3dX9qewkgCrwzbClWpgii61mA==
X-Received: by 2002:a17:903:244b:b0:1e5:5041:b18a with SMTP id l11-20020a170903244b00b001e55041b18amr1069299pls.40.1713494997557;
        Thu, 18 Apr 2024 19:49:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2MpyW3nsb4sdD6Wu3AhWxU/RviU5a4SetHiZbGtRYzusJJGxDUdOk4GAVJ6rp1G+MZ5LL1g==
X-Received: by 2002:a17:903:244b:b0:1e5:5041:b18a with SMTP id l11-20020a170903244b00b001e55041b18amr1069285pls.40.1713494997171;
        Thu, 18 Apr 2024 19:49:57 -0700 (PDT)
Received: from [10.72.116.35] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001e668c1060bsm2239799plh.122.2024.04.18.19.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Apr 2024 19:49:56 -0700 (PDT)
Message-ID: <54b997a0-a04b-44a0-9d40-205267f949c2@redhat.com>
Date: Fri, 19 Apr 2024 10:49:52 +0800
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

Thanks Andrey,

I will test it soon.

- Xiubo

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

