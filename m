Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B961B1C84CB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212542; cv=none; b=uwcAhnizAC3FZ52/QpWVnYLFAPwPPqVR6WsZxR4lrc9Ly+V2Gl5eRkS6Pb0XOW6ypBpoEaW4GuDLsg0vM3HHIkpPwfHjtW8ZwQT2UOGtKV3LPzPvnX1PDxVJxHR1V3fZhWZgm4qaZdG8ZzloEpifQGSS9Wj02tauPZ6XWNa1u5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212542; c=relaxed/simple;
	bh=kf3m4Vhzc64W5S1GeSsKzylXlERWwwp/eug8+HORW+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qcxbx7V795e4jQJiPp8Bb8xR5Jh29oojE5HVTrewtb3fwuKFL0LGKUTEgmzxXyWOUBM4KrhwMSkZL24Yh8J6XLuhyUvLIGfaQlBbvl64pPnSPXBRcVmV7awfXGgJI9KgFYQs+8SSkT+eEUzg22xXjuY7flPx2dBl0bq22rtjwDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPUTW2Eu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPUTW2Eu"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09d981507so38242005ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 02:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768212541; x=1768817341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vOfsd9AvZgUAG7w54rHWVGSNpWUTgf5LN50zEqoCi04=;
        b=NPUTW2Eu1g0rew/Rsd1taX6A6HdlDyVuhRUv46mRhi2uzERT5I0IB3wlbfjl7nc6zI
         Z2abluMu08T54svAd2wP5WGLjCwUAJzM4PhR+SeUzlGunRZsOeWr1ML3EidNGFNNSQ/J
         q35F+amK9tY9JYTG0cpUxqrbNxabBlCLFvRSLL09z7AgNH8PQ3rJ7S8MtOHQChWRfpaN
         qtxdLc4S6xH6cdoOsZlkkxzKcNJtWTdEwygqP8Cc9AgQ8zfNxwqQrVSqKzfdVl9YHyRi
         JARoheXpiPbS97LqApm66sLnGCt+KZUvBfz8IKtOLIR3VZUWYfAhA3TD8vkjIQ8MojKF
         Q5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768212541; x=1768817341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vOfsd9AvZgUAG7w54rHWVGSNpWUTgf5LN50zEqoCi04=;
        b=nl4rSm8WN9atvboFdYqclJt1vuCI+mHaqyjjB+0Me4g5MNyG8Q3novfWqgnnCGj6fU
         XpK6YvmOjAqYpfynf4v2fRKMS2+gedTZ39H0G7u2cPs6cHcohj1nqPhdvi2UyQ13c8w5
         jr9TBlSbs0SSqC8PS5v1rNvot9pcbNEOYqS3CY1PcRKfmuF/zQd7T0GoHRsGcwo478E3
         zbmsANElpFZwy9iumSTO/ORj13D2s1S1Y0PT3jPt56l2wxP0GP8h9wd5rj7EIWC4+gzI
         Ru4x/3vZGh1ShKHfWoAaH6Y2ayMS/Px9CN8aYEDmfdHMNYC4bwdgn3SKEqlBbxw4BNB1
         6PiA==
X-Gm-Message-State: AOJu0YxWyjPVypG11ejTvoM4HjNNuAqSEjCAGyRioYjJG6fWDyYVaCnB
	k0gpKR48838yE636/F/E2H374U1LQJSDstWRQvPAj+g17PAmjKsEKVXvR5SBXA==
X-Gm-Gg: AY/fxX4LNDAjlgxZjP0OcveL6Psw2mw5ZbC1BOqhle+aGY8g2p4rgQ8t/FcIpZd0aYO
	fOR2nL2hdZSK4neJYfuucvFv+8L4Oh+XdHSRHnpkRTTmXuFBl8bPMy7hdeYk/b4Iejtdv8o+1y3
	Pivl6H5pkggpgPTR/6ZhoLKC4imKU0BLd1WGWvAU4qibg+oP7/5C1VbD/3ccE2EXVvivW/XGD6E
	3oWF3USwzQMOw/OzJfydX/nG4POGKAbpW5HGBEbtVk+0g9iMhr4aWpX5W2r5H4E5IvfSXDpHeNK
	xgtR4JxIlFMjcJVNjjs1fYRGo5HXCVHNRgRLDWMBPq2AuCisLF6gKMGMtcy+rARJ95Gr5NYaebj
	1PXXIg4hN7LDMiPrJGomVwZunmPeWEgUvduxxhzqYynnuyPt6Ac5ITXzIjXnEgvJij24n/XujQb
	ICngiePFxjGDrvYjTGskVh1g==
X-Google-Smtp-Source: AGHT+IF3fIGXrWih5VrSoPtbzlUPLGn/tMkvgt96lqVCPfeajj5tZtBKtlHYZKM9bdyVKGs6x7LfCA==
X-Received: by 2002:a17:903:3508:b0:2a0:a33d:1385 with SMTP id d9443c01a7336-2a3e39d7c25mr211132755ad.17.1768212540905;
        Mon, 12 Jan 2026 02:09:00 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fa93ee7sm17051577a91.7.2026.01.12.02.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 02:09:00 -0800 (PST)
Message-ID: <fb44169f-52e7-4a1b-bc3b-db1b06dd239e@gmail.com>
Date: Mon, 12 Jan 2026 15:38:57 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
 <aUONoL924Sw_su9J@infradead.org>
 <d9cc2f24-6c06-41ab-835e-453a4856fd0b@gmail.com>
 <aWSryrkF2_6oxU9f@nidhogg.toxiclabs.cc>
 <8316699b-5ba4-402c-a0c0-17cdd0838347@gmail.com>
 <aWTFORPaMx0tjbmj@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aWTFORPaMx0tjbmj@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/12/26 15:26, Carlos Maiolino wrote:
> On Mon, Jan 12, 2026 at 02:10:01PM +0530, Nirjhar Roy (IBM) wrote:
>> On 1/12/26 13:40, Carlos Maiolino wrote:
>>> On Mon, Jan 12, 2026 at 11:43:53AM +0530, Nirjhar Roy (IBM) wrote:
>>>> On 12/18/25 10:44, Christoph Hellwig wrote:
>>>>> On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
>>>>>> xfs_rtcopy_summary() should return the appropriate error code
>>>>>> instead of always returning 0. The caller of this function which is
>>>>>> xfs_growfs_rt_bmblock() is already handling the error.
>>>>>>
>>>>>> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
>>>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>>>> Cc: <stable@vger.kernel.org> # v6.7
>>>>> Looks good:
>>>>>
>>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Hi Carlos,
>>>>
>>>> Are this and [1] getting picked up?
>>>>
>>>> [1] https://lore.kernel.org/all/aTFWJrOYXEeFX1kY@infradead.org/
>>> Hello.
>>>
>>> I can't find a new version on my mbox. Christoph asked you to fix the
>>> commit log on the patch you mentioned.
>>>
>>> If you sent a new version and I missed it, please let me know.
>> Sorry, I have re-sent it now [1]. Anything about [2]?
> I think think it slipped through the cracks, could you please re-send
> it? I'll pick both this week.

Sure, no problem. I have re-sent both [1] and [2].

[1] 
https://lore.kernel.org/all/587bff140dc86fec629cd41db0af8c00fb9623d0.1768212233.git.nirjhar.roy.lists@gmail.com/

[2] 
https://lore.kernel.org/all/9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com/

--NR

>
> Carlos
>
>> [1] https://lore.kernel.org/all/9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com/
>>
>> [2] https://lore.kernel.org/all/aUONoL924Sw_su9J@infradead.org/
>>
>> --NR
>>
>>> Carlos
>>>> --NR
>>>>
>>>> -- 
>>>> Nirjhar Roy
>>>> Linux Kernel Developer
>>>> IBM, Bangalore
>>>>
>>>>
>> -- 
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

