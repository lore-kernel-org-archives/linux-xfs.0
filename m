Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAF926BD92
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 02:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739241792; cv=none; b=KqUXAGdB3NOevrPmI8abPLerJHl9Upii5FQZE4OQMKRRjq5WVh5nvBSvlom9Sdv3zTflNX2IkijsAUh2vTJuH8yvHWZS93YRg0QwUwvn5SpaLY/ufhzcfW3WglaRn5ij80NZP751q30b2BF2pUnSLtiGJazaRp0/MbI94YXON1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739241792; c=relaxed/simple;
	bh=SnrILxBvVbQ0cRNiroVouG4W+Eu+lgpyCFoKaXn2Nck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FErpSRAZIh+VLfNbPM758DV0r9ibItdR1YGhicsHruwWkBNagoX5G9o677CfK9Z6LnClVKmm3ed+vVbGq+MD+mkCWB3H5VJRGhYLR7pLzUz0WCNIcIS81F538dNKJg0pX+Ddd6J4F2EswezY/sbW8XeZdY9V+EAlqwEFhEihnx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NnIqdFut; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NnIqdFut"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21f6022c2c3so46840845ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 18:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1739241790; x=1739846590; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nKziBAtg1HbGc0JeoxKdx+SKqD36Jtb1BCQ3ewTgytY=;
        b=NnIqdFutHYTXD/ZSYT262ogBJR2LVzqI1BOyB8mymKwwjaKldgosFH4t+MiM7QPQlY
         p5PYmiXXCzce8waZIDAx/StIC3ki2rQUXkKZG5oImXjLbf3qH63iat/ZMF/jEHkZANm+
         8Uo448CYDS7h6Ie44xmc9R9YkWaMIXFN/zUlTDYTIgzIZljDDhQBQyZs2kWloXBU/R8/
         E1qSUIu/PG6ZwHA7u4bjsxuSjYWumopj1RMuD6i+c/0WFPNYu3nJPIejZlNfa4g8FQzC
         SP34lUw2USXAyEXsxoD5FtCcHONFxH2PRE/OOXj28f/i7GJptN7rswErbsS5jWCSaY9s
         H51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739241790; x=1739846590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKziBAtg1HbGc0JeoxKdx+SKqD36Jtb1BCQ3ewTgytY=;
        b=qj0afdCnuhv8vo4rZmj+TFcJcUE9fWeMJoVlfEZYUwsyRZjCpP2MVS1NDwdzOKvrN+
         QczxdCcgHvUBJhKgy8IML7MqpHMF3SbkXVLcXvWg/I+9tWOwn75sY0d0y7UcSYekacmC
         oErwIkrSYg1xTG6oegD5cL4DJoAPVRuz7NFkBKZq5GtxPkr2lC40B+iKdU+rvYpTPx1Z
         27642XUVoBg3nQGjok2RyOu4jWnczD3OsyP+ZUlORkJnAO/XE5efVdZso4CX1ep1+2LV
         C/T7XJ8TIIggpKbkCmW1dP9fF3HTjhprL5/L0X/JbVjR814dLd44b2AFUMHsolaA0Yfy
         aU0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9pWqwHQ3v8nn6OyUV2kXhkUVNXSF1TgMIuMsVKe9b0ztctlw79yv09ORqWKj4WICTe7Q0uOcW4Ts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrQrfrFmfEBd9wFrOYLGcu5NqeAOFQCQncrISFJAAqmD9QEPdf
	VfOqPlRYL9ue/VmWjZgtRWVvA+8KzbnnHNm29dbSGgNzSSukFkihDqzm6oobi94=
X-Gm-Gg: ASbGncs44W7AklnwcikH2w9l6oVvP8lAcU53gkH/EyLuLSam14E19LApelH0tkZHgep
	RCmZchkXCx6PImRdG4QO7xw/mN1MSSQ7hVqZjfTe5TsLY8F7zLQlfQl/1Lnq9nqRmBHxoCE2n2m
	CYJUmwl2mIeufE+91U4sW6IUOgRJ0RNTPHcCIOPLEuvK4CbW9GWrI9DcK1TTOSk9Or1U29vaGZ1
	rabLNTY9QkOSY9FgYzdlDo/netypHb5fkmaMeLimTcf6MoXs3XLy1hD2v6+ojQDc0QWbTn9BMhH
	ixrX++dJJvWjGKR/CgVn+cy2prapYmeP+L0MSPpqFQ==
X-Google-Smtp-Source: AGHT+IFlEAc+CgziEvPOi9yauHYGiTs+Qr4sD978MXRUIfJA2SzIAo/wb3fB3Fzd3ri1y7dsaJ0SWA==
X-Received: by 2002:a05:6a20:430b:b0:1e1:9e9f:ae4 with SMTP id adf61e73a8af0-1ee4b6eb26dmr2442064637.13.1739241790209;
        Mon, 10 Feb 2025 18:43:10 -0800 (PST)
Received: from [10.84.150.121] ([203.208.167.150])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73089afd0cdsm3307414b3a.134.2025.02.10.18.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 18:43:09 -0800 (PST)
Message-ID: <7bc425c1-2b4a-4221-afa5-5c7230e85a0a@bytedance.com>
Date: Tue, 11 Feb 2025 10:43:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs/folio splat with v6.14-rc1
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, David Hildenbrand
 <david@redhat.com>, Jann Horn <jannh@google.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, "Darrick J . Wong" <djwong@kernel.org>,
 Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20250207-anbot-bankfilialen-acce9d79a2c7@brauner>
 <20250207-handel-unbehagen-fce1c4c0dd2a@brauner>
 <Z6aGaYkeoveytgo_@casper.infradead.org>
 <2766D04E-5A04-4BF6-A2A3-5683A3054973@nvidia.com>
 <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
 <dda6b378-c344-4de6-9a55-8571df3149a7@bytedance.com>
 <CD159586-D306-478B-8E73-AEDA90088619@nvidia.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <CD159586-D306-478B-8E73-AEDA90088619@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/2/10 22:12, Zi Yan wrote:
> On 10 Feb 2025, at 3:18, Qi Zheng wrote:
> 
>> Hi all,
>>
>> On 2025/2/10 12:02, Qi Zheng wrote:
>>> Hi Zi,
>>>
>>> On 2025/2/10 11:35, Zi Yan wrote:
>>>> On 7 Feb 2025, at 17:17, Matthew Wilcox wrote:
>>>>
>>>>> On Fri, Feb 07, 2025 at 04:29:36PM +0100, Christian Brauner wrote:
>>>>>> while true; do ./xfs.run.sh "generic/437"; done
>>>>>>
>>>>>> allows me to reproduce this fairly quickly.
>>>>>
>>>>> on holiday, back monday
>>>>
>>>> git bisect points to commit
>>>> 4817f70c25b6 ("x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64").
>>>> Qi is cc'd.
>>>>
>>>> After deselect PT_RECLAIM on v6.14-rc1, the issue is gone.
>>>> At least, no splat after running for more than 300s,
>>>> whereas the splat is usually triggered after ~20s with
>>>> PT_RECLAIM set.
>>>
>>> The PT_RECLAIM mainly made the following two changes:
>>>
>>> 1) try to reclaim page table pages during madvise(MADV_DONTNEED)
>>> 2) Unconditionally select MMU_GATHER_RCU_TABLE_FREE
>>>
>>> Will ./xfs.run.sh "generic/437" perform the madvise(MADV_DONTNEED)?
>>>
>>> Anyway, I will try to reproduce it locally and troubleshoot it.
>>
>> I reproduced it locally and it was indeed caused by PT_RECLAIM.
>>
>> The root cause is that the pte lock may be released midway in
>> zap_pte_range() and then retried. In this case, the originally none pte
>> entry may be refilled with physical pages.
>>
>> So we should recheck all pte entries in this case:
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index a8196ae72e9ae..ca1b133a288b5 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1721,7 +1721,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>          pmd_t pmdval;
>>          unsigned long start = addr;
>>          bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
>> -       bool direct_reclaim = false;
>> +       bool direct_reclaim = true;
>>          int nr;
>>
>>   retry:
>> @@ -1736,8 +1736,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>          do {
>>                  bool any_skipped = false;
>>
>> -               if (need_resched())
>> +               if (need_resched()) {
>> +                       direct_reclaim = false;
>>                          break;
>> +               }
>>
>>                  nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
>>                                        &force_flush, &force_break, &any_skipped);
>> @@ -1745,11 +1747,12 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>                          can_reclaim_pt = false;
>>                  if (unlikely(force_break)) {
>>                          addr += nr * PAGE_SIZE;
>> +                       direct_reclaim = false;
>>                          break;
>>                  }
>>          } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>
>> -       if (can_reclaim_pt && addr == end)
>> +       if (can_reclaim_pt && direct_reclaim && addr == end)
>>                  direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
>>
>>          add_mm_rss_vec(mm, rss);
>>
>> I tested the above code and no bugs were reported for a while. Does it
>> work for you?
> 
> It also fixed the issue I see on xfs as well.

Got it. And my local test reported no more issues overnight.

> 
> Tested-by: Zi Yan <ziy@nvidia.com>

Thanks! Will send a formal fix patch.

> 
> --
> Best Regards,
> Yan, Zi
