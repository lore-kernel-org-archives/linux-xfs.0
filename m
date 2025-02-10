Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8C81B808
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739162073; cv=none; b=DWVZ8Hzp6eTO02X42Ankkt/LCjwJkU9QB1vijPmXFtpdsEx/vl0xymOqOVyfjhdiqP1CHWbAywXEIR+IjafH6lk4okT7C/RYROJ6JqyAEf0CKs4w6u/40QKgm0Vk3uEtzR70fk8pCdkk4Rw61h3L1kuq65FJdudVP/V61xTIMdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739162073; c=relaxed/simple;
	bh=jEVFVa1mWt/HOPUsfN5scnrP6Yp/bl3whdCLzIKmiwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGrPGTewSCX2PzfhOj1zp0Wa6no9KS5Wya1iaovYjoJfRFxfEtImgZ32yL2B1yHaqWcpb5NEeO/YeNQR2taphigIrLvn/Rj3TazUKqcV4xZFtisbz9FUwVQ261J0kLwnW9rq6N/1YSTPRrcJG1Y/FkgCu7/YZ3HwyOC7f0/f3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=J0uHXeht; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="J0uHXeht"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21f6d264221so15715405ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 09 Feb 2025 20:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1739162071; x=1739766871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=raxSdDazhhEyHWThB2+vYMcLJ8i3+o9U+R+FxXyxu9c=;
        b=J0uHXehtiZtGYfrpSfsWXAi0cyq+sPimYF2cDphaJLwoH7uKl28Mt/mLNdJU1Sdv+F
         BM7qMByYpsXh4+bvdcC6hsiO2+QrWZ9+X0+B9K2RW6WuddM7/JMWZOgn1wfszporSk76
         +LZUEZF/pJSYZGVT/GRtwwZXuhnp6ykIMKtVNhna0Nnghsb8/9sQonZQl9p9NW4zyB/D
         mlCdWEj3NrPk7/JdTbn1SgW+hb0DXctse8bie7USSSg0ygX8Hw9IFFbF/k3QUj2zI/C1
         3ODp5f5KXyZDhFnlR8im/cWsujwh2+e/PTcWZm/DDNvJBzmm+tqwkOPolE3kgonmrsXu
         sw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739162071; x=1739766871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raxSdDazhhEyHWThB2+vYMcLJ8i3+o9U+R+FxXyxu9c=;
        b=XcKogVsluN5K4XKDrDEvZHjvhcOe2e4K5qrT2OZDFatnCWDkofh+4MiFEjNHzieTO6
         3+EjAmtzZkFn26+iJWIoUrtSWe3mP3hMxm997GYAaKzqvpj14sZgbQx38dzQsXgQAwLI
         u2vJk8ss2Msgir35+qIfwUKL9xs8njC/QeZMIF6z8Gqul9wXNxviEjmSYq3nCHd21+CQ
         mlRdevrvXcz1zsKPO5m338HVS+PwmgFC6mopDN1P/Ikb2Yji/nNVOsQi3W/lEQD2UuYj
         ltooNzRCnaP2F0JbEskmvpoCU6zFfL/0Ia4+ZviAM80jA/ISje1EUsft5s1/ZjAeBgoe
         cWqA==
X-Forwarded-Encrypted: i=1; AJvYcCVTFb/fSGHGi0LZHxc3Qcx6XcyTQH9/eqKrZcPjMJd9P4RalS2umCKxQzmFCpSeSfLB5fQy5Spv808=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCm6VOcEVkbA0XmdO4LexSAaxQ7npk/ZTBSZNkU3yWKUnNs32x
	6DY/Vrd+xhcOLQ0Z+CpaAY6wO7CuKqxNylaB9ReNdKVOkWJcz9s+vjz0EXC8Zq4=
X-Gm-Gg: ASbGnct+B+Cm6V0+d4yZ0GMPn1wThBxuHfU/ZHKMghTp/2hA7bcmfqOqL5qYqpoZoX1
	anmQs6VevJJKYhTEWszBAk/octR6Lz/CdINNUFMqCY9KwvjUHhbJo7CvZIe3KLgf4Uch8D1QAou
	PtvkiOX6xTGGVmxoVYmyX5YxsnkQvBlJCdc6ghl8qA61RZSYuL2L/wseOdDPyppR9ceiwfInRG0
	R2NII7MSaEXY33/XeHiOPWBpaEm9D5glUKcYm4mbTpmFJe6JZsfUaO8aiylCAPK+O/ViOHy4Zyz
	rZn/uOafRycYWds5iYHkAyJsXNipEmHIEgD0kBCJCQ==
X-Google-Smtp-Source: AGHT+IFhIYkanlmjZEUGQBLuakswjvEBNjy472tGiWULSQ/0Ylesq5QggYO1n92Z/03s386e7gQruw==
X-Received: by 2002:a17:902:cccb:b0:215:7446:2151 with SMTP id d9443c01a7336-21f4e1ce6cemr241510135ad.4.1739162071660;
        Sun, 09 Feb 2025 20:34:31 -0800 (PST)
Received: from [10.84.150.121] ([203.208.167.150])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f36551885sm67619525ad.88.2025.02.09.20.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2025 20:34:31 -0800 (PST)
Message-ID: <92808b9b-61b4-4efc-86cc-c77b11e8585a@bytedance.com>
Date: Mon, 10 Feb 2025 12:33:10 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs/folio splat with v6.14-rc1
Content-Language: en-US
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Jann Horn <jannh@google.com>, David Hildenbrand <david@redhat.com>
References: <20250207-anbot-bankfilialen-acce9d79a2c7@brauner>
 <20250207-handel-unbehagen-fce1c4c0dd2a@brauner>
 <Z6aGaYkeoveytgo_@casper.infradead.org>
 <2766D04E-5A04-4BF6-A2A3-5683A3054973@nvidia.com>
 <8c71f41e-3733-4100-ab55-1176998ced29@bytedance.com>
 <718cb1e0-c21e-41d5-a928-cf1fbf2edc57@gmx.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <718cb1e0-c21e-41d5-a928-cf1fbf2edc57@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2025/2/10 12:16, Qu Wenruo wrote:
> 
> 
> 在 2025/2/10 14:32, Qi Zheng 写道:
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
>>
>> Anyway, I will try to reproduce it locally and troubleshoot it.
> 
> BTW, btrfs is also able to reproduce the same problem on x86_64, all
> default mount option.
> Normally less than 32 runs of generic/437 (done by "./check -I 32
> generic/437" of fstests) is enough to trigger it.
> In my case, I go 128 runs to be extra sure.
> 
> And no more reproduce after deselect CONFIG_PT_RECLAIM option, thus it
> really looks like 4817f70c25b6 ("x86: select ARCH_SUPPORTS_PT_RECLAIM if
> X86_64") is the cause.

Thank you for your information, I will try to reproduce it locally and
troubleshoot it.

> 
> And for aarch64 64K page size and 4K fs block size, no reproduce at all.

Now, the PT_RECLAIM is only supported on x86_64.

Thanks,
Qi

> 
> Thanks,
> Qu
>>
>> Thanks!
>>
>>>
>>> -- 
>>> Best Regards,
>>> Yan, Zi
>>
>>
> 
