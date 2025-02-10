Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901B1B87F1
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 08:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739175540; cv=none; b=TUN50hjxo96nF34s/kDq4Dv+AWycHie430y8DmlXR2wGFTT1K/j61Bnwkn/ajpGyd5V2adEw1Bx8qWToKtIVuqey57UdsqVC64dEhx6KOqgo7+O4exHVQGy9vduyG6B4BDVQLlufq7QhOBC1gADiPdvaLrQNzDGLJxvrvALO+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739175540; c=relaxed/simple;
	bh=xjDv1UUzXLOKq832TK3V+MVR9jLqacIFqE39KvWITxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sO9xcBhm2Za2nvQ0anp4xxKe0s7o2i5AW6WFPR2V7+K2KVUUol/fveAFFopBKPR8WbhfhFH8o23+C7ffpL3GwQ4qh/9mKqeccP9ksrmPDnHZqDpIHa9rQ0DWhV5NNe/9taYS2r08bORdaQ66l7SNQsJpI4gpjD3Iuu7+MRIEZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UEAzNKeY; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UEAzNKeY"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21c2f1b610dso100032595ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 00:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1739175538; x=1739780338; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mlSIxA3x+/euQkQ5cMVnr4CskFs/HEnUsf/M1/H81gc=;
        b=UEAzNKeYkK+Y9pP37iNUWfbft4fxbDXdmZydVJu9L/SMfcNtDaL/doFxU3JI/UZ6tb
         KPtu0LsWXZ0+Qqa+/s3Nupdb4hO2M75Dk5rl/i9960RKOxu9N+uy5V+uo4AD1lFGOH2c
         yGovwjWgXPsYsrZMRYajYeCecrLUFiIc+kuuhVIzIaIUOoueNV8S+LwBmDDeB9QAkRng
         i78KBhB3fdxcOejaPLyyi3HLv0GFZr49Q7fzDFRYs4XNVvgUoNGwiXPVwNKLi+cajtgX
         NTRqVxN6kGiJK/cgV0WHmvDsuzVPct827oekHkMOpJb0KdYGF1tWqZ7OG3bYf/cSG13a
         3/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739175538; x=1739780338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mlSIxA3x+/euQkQ5cMVnr4CskFs/HEnUsf/M1/H81gc=;
        b=cS19XztJn6mmGgPodGCX2ngqSyQ5UpJyhAxjJPKvZgODVcssyO5EiQ9Gg9qwN+/K9v
         wLC1L+3tyWNVT5WwW41UM9k82uMtBGukFrImA6z1YvlKQfG5DcPUVdoez/ZzDUwaPC1P
         5HeIYcvCCDbkuudhcuRhGCya5l9a4WjuwtsT2fbkVEyQGucSd2QoXq/ZOa46yKgZah9O
         ZFyc2uzAkXxd6XYL60n8fPDuX+5k7KW3XJb/if2URugc2Mq7VCQhoCnvN/Bl4HZr17zW
         LjeUfbdumZGdayV0mhp3M4RRvmXSX92Wrlbl1fbLk7X0oMFIRpI1Aoy+U79Rpss8yjkv
         dP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2cvH6mZslI5W12yWUjo7+oFTRtzmE/CSfryL2C+tdGo2KxXTkeMZvFfHGu45C93Mz5I2XRnMtKac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1a4SBML582Nqcr65E5lVWhp7GfM5US6I6oiwVceLBNER67zKG
	7BxGxQW7iyytm6/p6YmQGM1BQYT3xX20ggjDGux7vX4L8m5cHKHQ5mnpLZcCyHzIdVpH/xkXzDx
	9
X-Gm-Gg: ASbGncse+MVZDpPMpNwTPpo7bt9cfg8CoCD6aOyxdU/d0JuT1+iwtTjObSkluTF8l49
	uKZIksQDTeHjeyRcUQp4frKNJq6jxyFv5UZUQAO6hx0xBVMRQBO2ewcR4j06ml6pimsLgP0YUlJ
	0AJUj2VO9dmIHvE09OFdIHhimNOGFtk1KElwrT8R0G+0UD2F0/lB+pRmspd63zh2wVfij/h4Fow
	UFhCJS/OoBhBqZ1v64vdEjgX/nltByECcSfNdGDNgWMlGMT8PPeTW21mRONI0xnX7SWV5afMqrP
	TFIBwHFEEyWu6nUm4qTjlxRZziGiXvF6SFt4Li+/Jw==
X-Google-Smtp-Source: AGHT+IFaNzeBUa5ZixxrEObq3W7T+7+9t1pZmG28SJnli2MJ7RMleh58aXR8J2XSsJ2EMGhM3ttALw==
X-Received: by 2002:a17:902:db0b:b0:21b:bc95:e8d4 with SMTP id d9443c01a7336-21f4e7989e1mr257615955ad.35.1739175537911;
        Mon, 10 Feb 2025 00:18:57 -0800 (PST)
Received: from [10.84.150.121] ([203.208.167.149])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f74ff1d45sm33072575ad.227.2025.02.10.00.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 00:18:57 -0800 (PST)
Message-ID: <dda6b378-c344-4de6-9a55-8571df3149a7@bytedance.com>
Date: Mon, 10 Feb 2025 16:18:51 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs/folio splat with v6.14-rc1
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, David Hildenbrand
 <david@redhat.com>, Jann Horn <jannh@google.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner
 <david@fromorbit.com>, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250207-anbot-bankfilialen-acce9d79a2c7@brauner>
 <20250207-handel-unbehagen-fce1c4c0dd2a@brauner>
 <Z6aGaYkeoveytgo_@casper.infradead.org>
 <2766D04E-5A04-4BF6-A2A3-5683A3054973@nvidia.com>
 <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

On 2025/2/10 12:02, Qi Zheng wrote:
> Hi Zi,
> 
> On 2025/2/10 11:35, Zi Yan wrote:
>> On 7 Feb 2025, at 17:17, Matthew Wilcox wrote:
>>
>>> On Fri, Feb 07, 2025 at 04:29:36PM +0100, Christian Brauner wrote:
>>>> while true; do ./xfs.run.sh "generic/437"; done
>>>>
>>>> allows me to reproduce this fairly quickly.
>>>
>>> on holiday, back monday
>>
>> git bisect points to commit
>> 4817f70c25b6 ("x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64").
>> Qi is cc'd.
>>
>> After deselect PT_RECLAIM on v6.14-rc1, the issue is gone.
>> At least, no splat after running for more than 300s,
>> whereas the splat is usually triggered after ~20s with
>> PT_RECLAIM set.
> 
> The PT_RECLAIM mainly made the following two changes:
> 
> 1) try to reclaim page table pages during madvise(MADV_DONTNEED)
> 2) Unconditionally select MMU_GATHER_RCU_TABLE_FREE
> 
> Will ./xfs.run.sh "generic/437" perform the madvise(MADV_DONTNEED)?
> 
> Anyway, I will try to reproduce it locally and troubleshoot it.

I reproduced it locally and it was indeed caused by PT_RECLAIM.

The root cause is that the pte lock may be released midway in
zap_pte_range() and then retried. In this case, the originally none pte
entry may be refilled with physical pages.

So we should recheck all pte entries in this case:

diff --git a/mm/memory.c b/mm/memory.c
index a8196ae72e9ae..ca1b133a288b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1721,7 +1721,7 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
         pmd_t pmdval;
         unsigned long start = addr;
         bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
-       bool direct_reclaim = false;
+       bool direct_reclaim = true;
         int nr;

  retry:
@@ -1736,8 +1736,10 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
         do {
                 bool any_skipped = false;

-               if (need_resched())
+               if (need_resched()) {
+                       direct_reclaim = false;
                         break;
+               }

                 nr = do_zap_pte_range(tlb, vma, pte, addr, end, 
details, rss,
                                       &force_flush, &force_break, 
&any_skipped);
@@ -1745,11 +1747,12 @@ static unsigned long zap_pte_range(struct 
mmu_gather *tlb,
                         can_reclaim_pt = false;
                 if (unlikely(force_break)) {
                         addr += nr * PAGE_SIZE;
+                       direct_reclaim = false;
                         break;
                 }
         } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);

-       if (can_reclaim_pt && addr == end)
+       if (can_reclaim_pt && direct_reclaim && addr == end)
                 direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);

         add_mm_rss_vec(mm, rss);

I tested the above code and no bugs were reported for a while. Does it
work for you?

Thanks,
Qi

> 
> Thanks!
> 
>>
>> -- 
>> Best Regards,
>> Yan, Zi
