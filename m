Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D7D2459EA
	for <linux-xfs@vger.kernel.org>; Sun,  5 Apr 2026 01:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775353104; cv=none; b=h0dZb8aF0NHcutwWtNYTyqebAaRsQ4aftTHFKJvjhj3k+FMN1OQb1RMD1bVI5glq1Ftia3R4HVXXp/UlBbZPD6njCR9Rrwy2+1cbBpjqZRFC4DzosC+Sk2uvU89om0loc0qwgyUvz2+RIyT+8Y8mLpy/8GenLn8fbqNYlLULco4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775353104; c=relaxed/simple;
	bh=ttZ5UOvSYuV+7swKRgQ8dspfpAhsXPOH6YzDMDfJ/Yg=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=tJxIeQDIeqnO5GqGfPZ5YIkyuNRhXbwBN+dCr9O3M+rdEeeNGJRRBvq7bw78sr0B95PBwlSLwJoZNaeVd3TwkssAozu4Drxh2lKdm27ZHAbWGYj6dIXv6KXfF+Qm3V772uVdyqTkhFdihJZLkq9XGzTnOL/1zN3T2qcNxdBf5Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTzujzOt; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTzujzOt"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35da01fc0baso2014138a91.2
        for <linux-xfs@vger.kernel.org>; Sat, 04 Apr 2026 18:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775353102; x=1775957902; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A/s+fTa/nlSPGUk5KAyxJa+HAMux5I9zV9tdLw5F3NA=;
        b=XTzujzOtIREl2Riw0SAKGJDNy4IyV7bj7vRSPYS9Uj0Xsl+KjA1RvAJn0Qiy6YXD8F
         4oQE8hSQsg/n+HYlRPSksM6ST2+KsmM2nmeBDBuBQQTz7ETEIAx1aBisrTva+dcOgKd+
         QGz6lmOD4IGDYHVq3tSKQJXXm7+Twc98LTzyFgcMDWFIrXoz01faixXfR/C1VyTK0Nk6
         f2J1jl30GhBSPvsRRs5Q8HMKpgyxl9bnrf0Qjtrczo+i4WwnprBOYB716gVDIHjh2yjs
         7UXu9Jt77D5AC1z+7IgTa+AiRnLpU3x8y1oWtWJlPFnU5rjV0LV1NuYexai68uuNCp81
         5ADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775353102; x=1775957902;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A/s+fTa/nlSPGUk5KAyxJa+HAMux5I9zV9tdLw5F3NA=;
        b=sLDLiHjKoTcPFOVI1O+HztB5PZW7n2R05xOvpERbaJ7XC4D+iGdf9kNmRFWG4J3q9j
         ASNNKc+mHmidzOC07JRVhgtFoe+dqsKPagCVy1z0+imCHyVf+mnvB/QCl8uHYB8qjCaU
         3mLXlwZDUKmtLC5eYreWmzuDoI3FSNYmaepkxV2BMHz7XjCPZ4ni5qOfFd+i6WJxZITU
         yE18f9rOqP81qpW/Xo+R1ifjTaNilfpxwX+oRpzXFLM0ws2yyscyopO9z/wVIwi/2wf5
         FhcX5EfcGQ0BTPQsfq80eC+t++n+YJ3sry+C8wXip5cVKMWRSi1mdVLdm0EHPj3QO6EL
         G9cA==
X-Gm-Message-State: AOJu0Yz5Z+SchAape+9ACG8tchmulkKlBa6nVYXeAnxGcVX4XoaO8Ncm
	uCWcS921NnSj3nqJ+0zN4eoOtqrwK6VtbG+ImJKDF303D7nLpzsx/agkcaVlIw==
X-Gm-Gg: AeBDietMRvJ7HEi9hfOVjl5JAcQowAW4a8tAlmeByNdE/6REGPVPFWzMwRji22KBo8s
	nrxGnen7AZy+UAnV3mN712YLcyycYga8seDZfbRr5FjPu+y1Qshw73zfgaJ5fVxeXAZ3e2nwQOd
	NVQsZtlEbqkDorDvkV2zxRsXPVggzft/VaoZD0m7hVZ9ECrI645Rjppvd8+UKo6CZtyQFVX5p+M
	rgXNev9dSw2gTiQbTqeKEEvLDotVYljagTHpBIOQUqIMrqtgj5ZG9Qr6lBJyQFhbX5Zi3u9akam
	tvMf2cKobs5fhBqnir+zgKJ1Dhf3M6C9dlvSpA4mSanoti1BnwIipncilW/wDE/ib/MO0PSnIeb
	04U3xLzWtcRAEaiHSerlGQHBpsMy+Iz5SD4CNJsKV+LyfkzA8ezn6zRjeILeTOkwhEmH8QCJuo6
	7dMxAZzBOK+rylL+EGVBFMVHZyh/Bn0gtO
X-Received: by 2002:a17:902:c942:b0:2b2:42da:25cd with SMTP id d9443c01a7336-2b281889bbfmr94391155ad.45.1775353101998;
        Sat, 04 Apr 2026 18:38:21 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497aeffsm97930905ad.43.2026.04.04.18.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 18:38:21 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Chinner <dgc@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
In-Reply-To: <adDgYCmgNsA9ff3e@dread>
Date: Sun, 05 Apr 2026 06:33:59 +0530
Message-ID: <341amd4w.ritesh.list@gmail.com>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org> <adDgYCmgNsA9ff3e@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Dave Chinner <dgc@kernel.org> writes:

> On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
>> This is with commit 5619b098e2fb so after 7.0-rc6
>> INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
>> task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
>> Call Trace:
>>  <TASK>
>>  __schedule+0x560/0xfc0
>>  schedule+0x3e/0x140
>>  schedule_timeout+0x84/0x110
>>  ? __pfx_process_timeout+0x10/0x10
>>  io_schedule_timeout+0x5b/0x80
>>  xfs_buf_alloc+0x793/0x7d0
>
> -ENOMEM.
>
> It'll be looping here:
>
> fallback:
>         for (;;) {
>                 bp->b_addr = __vmalloc(size, gfp_mask);
>                 if (bp->b_addr)
>                         break;
>                 if (flags & XBF_READ_AHEAD)
>                         return -ENOMEM;
>                 XFS_STATS_INC(bp->b_mount, xb_page_retries);
>                 memalloc_retry_wait(gfp_mask);
>         }
>
> If it is looping here long enough to trigger the hang check timer,
> then the MM subsystem is not making progress reclaiming memory. This

Hi Dave,

If that's the case and if we expect the MM subsystem to do memory
reclaim, shouldn't we be passing the __GFP_DIRECT_RECLAIM flag to our
fallback loop? I see that we might have cleared this flag and also set
__GFP_NORETRY, in the above if condition if allocation size is >PAGE_SIZE.

So shouldn't we do?

        if (size > PAGE_SIZE) {
                if (!is_power_of_2(size))
                        goto fallback;
-               gfp_mask &= ~__GFP_DIRECT_RECLAIM;
-               gfp_mask |= __GFP_NORETRY;
+               gfp_t alloc_gfp = (gfp_mask & ~__GFP_DIRECT_RECLAIM) | __GFP_NORETRY;
+               folio = folio_alloc(alloc_gfp, get_order(size));
+       } else {
+               folio = folio_alloc(gfp_mask, get_order(size));
        }
-       folio = folio_alloc(gfp_mask, get_order(size));
        if (!folio) {
                if (size <= PAGE_SIZE)
                        return -ENOMEM;
                trace_xfs_buf_backing_fallback(bp, _RET_IP_);
                goto fallback;
        }


-ritesh

> is probably a 16kB allocation (it's an inode cluster buffer), and
> the allocation context is NOFAIL because it is within a transaction
> (this loop pre-dates __vmalloc() supporting __GFP_NOFAIL)....
>
> All the other tasks are backed up on the AGI buffer lock held ...
>
>>  xfs_buf_get_map+0x651/0xbd0
>>  ? _raw_spin_unlock+0x26/0x50
>>  xfs_trans_get_buf_map+0x141/0x300
>>  xfs_ialloc_inode_init+0x130/0x2c0
>>  xfs_ialloc_ag_alloc+0x226/0x710
>>  xfs_dialloc+0x22d/0x980
>
> ... here by the task blocked on memory allocation.
>
> This smells like a persistent ENOMEM/memory reclaim issue and XFS is
> just the messenger...
>
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
