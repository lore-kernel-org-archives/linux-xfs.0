Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949FA40DFDC
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775494071; cv=none; b=Frw/FuxohVWD/cIdcDG1zBDUT8QAyd7YcvHgokw4hHhP15rIYuqhLL7OC9mlEYdELVb5bVxFC9PzG2kdrFpF0BhAFsgE17QMTDK6ciphRDozkRzVzykQL/txChT1MPb4KnhmjxRMX7qWp3v+E49nOCm4RncWj5opcJtVWki1c5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775494071; c=relaxed/simple;
	bh=YQjtijkil8IuHS5qRJav6JiZ9AIjX9Xz5Dh89dM/9iA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=IsSh+NxgBw1Fw2SuQJ3zmgJ7V0Q/fNtzwgGezhOjaEbOJ1vXShlvQe/+5WhpnzvS4KQHerT43rAmZS+tN7FbSo2Oq78f1LO7yeJYziNpdrSB5VJcbC5KVc7mVMYwn1sPYTLXz+djT7xOhUjH9wgo92xGiLkkDeWeuMBmw3vnEgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RxdQmqu/; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RxdQmqu/"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b23f90f53aso37767275ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2026 09:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775494069; x=1776098869; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W78qkfkxPwPcnq1LIM7hcRlp/GGhRAzLsiL+edV0Ccs=;
        b=RxdQmqu/hjCrRNhyZpdEm3mBsBpAe5wSXH8oLs9fg/yrHiEKXeEX+vWElJnfGdHS8I
         Sd36NSfE6TvQkVWcS0Sf+fWvosuhzoqK/PkoS8Mc1o4Xd7dEqsapWg2vRrnb9g6agMZe
         JTF8CpYdt/YAsF/CaL2KKlW8ZOK27gL07Xd+dYrpdx552/dO6E8Gi8HztZ/CfGUwqICu
         R15nKvtyUIHZA9SkBGiOFN2Mem+Fi3IhbQdNM6GZAA0mUmu2/6jfzYoBfKUrlIWatZk2
         D4vUpYF8fHMXE7vbSQH4VxUk5eGClF7gqMKY3kWvWoTWFxC2kkeYABir2ALPe2rIj26n
         +NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775494069; x=1776098869;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W78qkfkxPwPcnq1LIM7hcRlp/GGhRAzLsiL+edV0Ccs=;
        b=PAg25GgN5C+cVYTzxl5JRsPHr/dBGrOgsO6j+HGdQmUijXcihr4f6lZyGzX1uwTgzo
         9qK5YglHFdWH37BUstcTmNxK1Ifr+EOkvVN7/QKZu503v3mK/z7W1lRT0jTlaZWGeSy/
         YInojwvbXK56aODgy6TSyCOdo5Q75hXZO7Rq3mcKYXHI3e5P+EbZjl3JFJUpvp3oasAv
         GIxMBmILa3COPZUob1Xf2ToIFymDTSl9aIZhvQa9TiASdEIy1Xj8tjG/ZCfqhFnLvQRt
         nBhz2QivHXVVZcUfdfyZ/ZiZ6u8HECPn90ZtMHEkrqvNWH64apuWuZ5OI0TyTWZf81xl
         kfPg==
X-Forwarded-Encrypted: i=1; AJvYcCXGwAbe7+P1d4focT8MAFOMyHneQ8R9yxA9g063RxdQImYhRpdI5L49R/dZAd6LR+C70f69vJ31fcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXegQgy3b0FBLMJKNFA/jlX21a2UqKF2H+lmrz1l1lhY1NJHUB
	hmBpaEAFHfp5ZnIdX4ZgqVT9xqy76H2kIPyukjEGtL36LWp0eGdyfFyP/Y2yjA==
X-Gm-Gg: AeBDievxNAcVGT8x71wQQAVUlfqH1xADG3IISt7z6tsz8Buxq6meBmSJS7Cur6n4z9r
	zNNb8IGMjK1/bv22rZZJmwC/R+crsyBtxRQXa2mmkJN6GmDKiiIkeOZk47G6Z08wialNz/gQClA
	6fd8bdPcnF/UH76sWB0SXzRzTKz/aNbkmfrzXA2dwyKhiLmPD6/O8ld+9E+rhVlLKw4HutcYWld
	AWmpg8Hpf7VQX0emUQhFMoNbw1zcCw98sgIhury03rWHe36JBMgd0OfUusKz+J77N9WHhdAGfHP
	L+r64pmoA63rOP0AVkJqCzIOG3gtlrkcqk0YTvT8QmehlB0yXNUBYNOcOo8uf2XXdplpInFA9NQ
	bIYTzSXgBpxfvqHN2Quw1sS/z9m+3Da3OcETlh5+HlnZsHCZAHWXlBeL0PHsrn+3qnHt4OHH5Ch
	g4Ske5Cm/j3wzlIHEorJUEMw==
X-Received: by 2002:a17:903:384f:b0:2ae:55eb:f82d with SMTP id d9443c01a7336-2b28167626emr142728685ad.1.1775494069194;
        Mon, 06 Apr 2026 09:47:49 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979500sm194919365ad.44.2026.04.06.09.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 09:47:48 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: Hang with xfs/285 on 2026-03-02 kernel
In-Reply-To: <adLfJwoi1lZhnbjn@dread>
Date: Mon, 06 Apr 2026 05:57:06 +0530
Message-ID: <y0j1kk6d.ritesh.list@gmail.com>
References: <ac_eUsuxqf6IYN7F@casper.infradead.org> <adDgYCmgNsA9ff3e@dread> <341amd4w.ritesh.list@gmail.com> <adLfJwoi1lZhnbjn@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>


Thanks Dave for your inputs. I have few more data points on the same.
It will be nice to know your thoughts on this.

Dave Chinner <dgc@kernel.org> writes:

> On Sun, Apr 05, 2026 at 06:33:59AM +0530, Ritesh Harjani wrote:
>> Dave Chinner <dgc@kernel.org> writes:
>> 
>> > On Fri, Apr 03, 2026 at 04:35:46PM +0100, Matthew Wilcox wrote:
>> >> This is with commit 5619b098e2fb so after 7.0-rc6
>> >> INFO: task fsstress:3762792 blocked on a semaphore likely last held by task fsstress:3762793
>> >> task:fsstress        state:D stack:0     pid:3762793 tgid:3762793 ppid:3762783 task_flags:0x440140 flags:0x00080800
>> >> Call Trace:
>> >>  <TASK>
>> >>  __schedule+0x560/0xfc0
>> >>  schedule+0x3e/0x140
>> >>  schedule_timeout+0x84/0x110
>> >>  ? __pfx_process_timeout+0x10/0x10
>> >>  io_schedule_timeout+0x5b/0x80
>> >>  xfs_buf_alloc+0x793/0x7d0
>> >
>> > -ENOMEM.
>> >
>> > It'll be looping here:
>> >
>> > fallback:
>> >         for (;;) {
>> >                 bp->b_addr = __vmalloc(size, gfp_mask);
>> >                 if (bp->b_addr)
>> >                         break;
>> >                 if (flags & XBF_READ_AHEAD)
>> >                         return -ENOMEM;
>> >                 XFS_STATS_INC(bp->b_mount, xb_page_retries);
>> >                 memalloc_retry_wait(gfp_mask);
>> >         }
>> >
>> > If it is looping here long enough to trigger the hang check timer,
>> > then the MM subsystem is not making progress reclaiming memory. This
>> 
>> Hi Dave,
>> 
>> If that's the case and if we expect the MM subsystem to do memory
>> reclaim, shouldn't we be passing the __GFP_DIRECT_RECLAIM flag to our
>> fallback loop? I see that we might have cleared this flag and also set
>> __GFP_NORETRY, in the above if condition if allocation size is >PAGE_SIZE.
>> 
>> So shouldn't we do?
>> 
>>         if (size > PAGE_SIZE) {
>>                 if (!is_power_of_2(size))
>>                         goto fallback;
>> -               gfp_mask &= ~__GFP_DIRECT_RECLAIM;
>> -               gfp_mask |= __GFP_NORETRY;
>> +               gfp_t alloc_gfp = (gfp_mask & ~__GFP_DIRECT_RECLAIM) | __GFP_NORETRY;
>> +               folio = folio_alloc(alloc_gfp, get_order(size));
>> +       } else {
>> +               folio = folio_alloc(gfp_mask, get_order(size));
>>         }
>> -       folio = folio_alloc(gfp_mask, get_order(size));
>>         if (!folio) {
>>                 if (size <= PAGE_SIZE)
>>                         return -ENOMEM;
>>                 trace_xfs_buf_backing_fallback(bp, _RET_IP_);
>>                 goto fallback;
>>         }
>
> Possibly.
>
> That said, we really don't want stuff like compaction to
> run here -ever- because of how expensive it is for hot paths when
> memory is low, and the only knob we have to control that is
> __GFP_DIRECT_RECLAIM.
>

Looking at __alloc_pages_direct_compact(), it returns immediately for
order=0 allocations.


> However, turning off direct reclaim should make no difference in
> the long run because vmalloc is only trying to allocate a batch of
> single page folios.
>
> If we are in low memory situations where no single page folios are
> not available, then even for a NORETRY/no direct reclaim allocation
> the expectation is that the failed allocation attempt would be
> kicking kswapd to perform background memory reclaim.
>
> This is especially true when the allocation is GFP_NOFS/GFP_NOIO
> even with direct reclaim turned on - if all the memory is held in
> shrinkable fs/vfs caches then direct reclaim cannot reclaim anything
> filesystem/IO related.
>

So, looking at the logs from Matthew, I think, this case might have
benefitted from __GFP_DIRECT_RECLAIM, because we have many clean
inactive file pages. So theoritically, IMO direct reclaim should be able
to use one of those clean file pages (after it gets direct-reclaimed)

      nr_zone_inactive_file 62769
      nr_zone_write_pending 0


> i.e. background reclaim making forwards progress is absolutely
> necessary for any sort of "nofail" allocation loop to succeed
> regardless of whether direct reclaim is enabled or not.
>
> Hence if background memory reclaim is making progress, this
> allocation loop should eventually succeed. If the allocation is not
> succeeding, then it implies that some critical resource in the
> allocation path is not being refilled either on allocation failure
> or by background reclaim, and hence the allocation failure persists
> because nothing alleviates the resource shortage that is triggering
> the ENOMEM issue.

I agree, background memory reclaim / kswapd thread should have made
forward progress. 

I am not sure why in this case, we are we hitting hung tasks issues then.
Could be because of multiple fsstress threads running in parallel (from
ps -eax output), and maybe some other process ends up using the pages
reclaimed by background kswapd (just a theory). 

>
> So the question is: where in the __vmalloc allocation path is the
> ENOMEM error being generated from, and is it the same place every
> time?
>

Although I can't say for sure, but in this case after looking at the
code, and knowing that we are not passing __GFP_DIRECT_RECLAIM, it might
be returning from here (after get_page_from_freelist() couldn't get a
free page).

__alloc_pages_slowpath() {
    ...
	/* Caller is not willing to reclaim, we can't balance anything */
	if (!can_direct_reclaim)
		goto nopage;


So, with the above data, I think,
In this case, passing __GFP_DIRECT_RECLAIM in vmalloc fallback path
might help. And either ways, until we have a page allocated, we anyway
do an infinite retry, so we may as well pass __GFP_DIRECT_RECLAIM flag
to it, right?

fallback:
	for (;;) {
		bp->b_addr = __vmalloc(size, gfp_mask);
		if (bp->b_addr)
			break;
		if (flags & XBF_READ_AHEAD)
			return -ENOMEM;
		XFS_STATS_INC(bp->b_mount, xb_page_retries);
		memalloc_retry_wait(gfp_mask);
	}

Thoughts?

I am not sure how easily this issue is reproducible at Matthew's end.
But let me also keep a kvm guest with the same kernel version to see if
I can replicate this at my end in an overnight run of xfs/285 in a loop.


-ritesh
