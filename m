Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7F52AE95
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 04:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739162129; cv=none; b=fk17v1i6hLBtKYAbslP16/v6ebvYHouw2k5WFlUFRxtoEtAqxH9Mw3o2D/xXizWGuNy0ru0h+OKtMtxuKOKDsUii8SnljZuhvN1AIfq6Xp7AeS65CQV5blhO3wqiW6oAzodcufknuwzYr42HPJB3oIVK8I7iMjAAgWcOGDekHo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739162129; c=relaxed/simple;
	bh=6zXA2nICixTsXvoRh3y3rP4oz/t/6aD2ARbIp7m6vcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9zErWSzJrPO/NQ4bWNaJsybukf/Cf17KqDnOgHl7v/Pvi7u3fdfUhmO3/oMFwaAo3oGv5guHH84AWdJKcgiwPBAWMZwL0oEXGm7L1JRXKwfSagugb7HOofSCPdaED1LH7C5EZOVfdrtQykk7lpJB25+/9yYd7MPFUBvvPRiK8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=FlO6h95I; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="FlO6h95I"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-219f8263ae0so69620285ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2025 20:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1739162127; x=1739766927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4k+2eKN7MR4K/4ZDf+BKX5koeLl+w9WZxMDBzA9nIzw=;
        b=FlO6h95I1GNztOB7Z9zC4m1Z6CRmobMdOC3/q4Ow/U+INCHRcbM0ZkLNIO3/+PE70E
         RFZn5vs5gckTteD3haoj2LK2CMKAb3X8FiJIKP2ARPv52U+yDcI6Q+KFn9QSf6p0+Lka
         5SgpVESsNC++riACMMY0Rckw79I/fBJ5uFpgdTMlTakspdCpa8lorfriGCq1f8dfr0DF
         TaW2gLsr+iruUdpxbkXTG0aCiXHeFWAzWUvVv2udSlpYrIyuORliVQOO2iKXIGOq5ywE
         A3NOneflnOvQ2hC1sNHyrE8jcoW7uC+P74opSskKTtkNyClemAubLYjKIYG9tSwGqa7k
         5OKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739162127; x=1739766927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4k+2eKN7MR4K/4ZDf+BKX5koeLl+w9WZxMDBzA9nIzw=;
        b=HlJTVxpPtnCFsCUPFVH3UvHcecJMqX21B0iFbHfyIDCfawcQEVJZEoTTOZ1sNHW5M1
         kVnTO+JbWwLwDOVH0pEybHjYTLB1RStTOklOUVBth1C5j95HhsKG9jdZNO7nqTqboPMD
         3uj20kCNMcvBayyBDUnIZvkBBhbSXWiGPSjxpSUgQCANTFb0EOf9cATMGSgTCV2rF+WU
         OmxNjyktGKI2jE9vMHxxUJEDTkIJbFpE0Gjwqro7kqSXaKkABExl9C8LoiOmncvfMDD+
         l/kR0l2AI/UYwxeDZqLFgaVpjvTPl2WI/CRiKI5MxnbbSn66sRUTmXmWmDbZS/brUZ7k
         /nzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkHx9aDqfVSgJAWAsBUmcrCJMXsCTeygR9edirPebm8961kK5gg4Da+wygF78VVtYebZH8BUmzMZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzNutAzLJ5LblBM1p0/rP5tJD977teYne1Xlc8hZrULkaPqfom
	G9OU98/FAi1RTTHnUUSAlqVwXPpWfpgVd1LxDPhqnsG9VYHdqjVHPY8shRDFS0I=
X-Gm-Gg: ASbGncuSTZP6Dx2hAVfgIEdbohtTwXup2y97RQOlFTWyJMC5/L8JdXYJgN9xmn1qinq
	uDqThcSEkOy2UlmHdayn4rcHY7tRj6J24Yv8uqlnl/2DnWM0bjbGq8CPsfileIAdkHIa8EIkcxP
	6Wo8CVZoW4wlLDzu5vrH981yo2xyJo9SDraXo45WdshPoxIn9p3c1BjMlAJe/2vQ7x7VcgHfrz5
	WosGaH0YJb4s2VyCieKnciagS1kRQDtxSH/TVtMKPcOLSKtApMZjy1EKboXVLJVNJAV6pAlHntn
	v9pXkgyg/p6ApbCpnR/2L/j448ZBurJj3UYhi57FLA==
X-Google-Smtp-Source: AGHT+IGj0Tsny1gbgtf4jJeZ3T2wO3uBzl26/s92Vc6vCYy4nk+04NyXUv1q0+u2fRpURAl3hdxpPg==
X-Received: by 2002:a17:902:f687:b0:21f:9c7:2d2e with SMTP id d9443c01a7336-21f4e72dcb3mr192643605ad.40.1739162127353;
        Sun, 09 Feb 2025 20:35:27 -0800 (PST)
Received: from [10.84.150.121] ([203.208.167.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f36551885sm67619525ad.88.2025.02.09.20.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2025 20:35:26 -0800 (PST)
Message-ID: <42ee133a-870c-4d7b-afc5-f551d259db9c@bytedance.com>
Date: Mon, 10 Feb 2025 12:35:23 +0800
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
 Christian Brauner <brauner@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Jann Horn <jannh@google.com>, David Hildenbrand <david@redhat.com>
References: <20250207-anbot-bankfilialen-acce9d79a2c7@brauner>
 <20250207-handel-unbehagen-fce1c4c0dd2a@brauner>
 <Z6aGaYkeoveytgo_@casper.infradead.org>
 <2766D04E-5A04-4BF6-A2A3-5683A3054973@nvidia.com>
 <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
 <AD32F66E-777A-43D4-8DFB-F2D5402AD3F4@nvidia.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <AD32F66E-777A-43D4-8DFB-F2D5402AD3F4@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/2/10 12:18, Zi Yan wrote:
> On 9 Feb 2025, at 23:02, Qi Zheng wrote:
> 
>> Hi Zi,
>>
>> On 2025/2/10 11:35, Zi Yan wrote:
>>> On 7 Feb 2025, at 17:17, Matthew Wilcox wrote:
>>>
>>>> On Fri, Feb 07, 2025 at 04:29:36PM +0100, Christian Brauner wrote:
>>>>> while true; do ./xfs.run.sh "generic/437"; done
>>>>>
>>>>> allows me to reproduce this fairly quickly.
>>>>
>>>> on holiday, back monday
>>>
>>> git bisect points to commit
>>> 4817f70c25b6 ("x86: select ARCH_SUPPORTS_PT_RECLAIM if X86_64").
>>> Qi is cc'd.
>>>
>>> After deselect PT_RECLAIM on v6.14-rc1, the issue is gone.
>>> At least, no splat after running for more than 300s,
>>> whereas the splat is usually triggered after ~20s with
>>> PT_RECLAIM set.
>>
>> The PT_RECLAIM mainly made the following two changes:
>>
>> 1) try to reclaim page table pages during madvise(MADV_DONTNEED)
>> 2) Unconditionally select MMU_GATHER_RCU_TABLE_FREE
>>
>> Will ./xfs.run.sh "generic/437" perform the madvise(MADV_DONTNEED)?
> 
> Yes. See: https://github.com/kdave/xfstests/blob/master/src/t_mmap_cow_race.c#L34

Got it.

> 
>>
>> Anyway, I will try to reproduce it locally and troubleshoot it.
> 
> You will need xfstests and run "while true; do sudo ./check "generic/437"; done".
> 
> The local.config for xfstests is at:
> https://lore.kernel.org/linux-mm/20250207-anbot-bankfilialen-acce9d79a2c7@brauner/

OK, will do. Thanks!

> 
> 
> --
> Best Regards,
> Yan, Zi
