Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0A19DFAB
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041302; cv=none; b=deEIFdAIx863BHssah0UIRP833FKpmGvSBnympJIE8tmDJzZjTcAf3vTl9ZfLZMQleN9HgKsKIa790ISGz7gzG8QQ1w7gto0PladMGe9kR3EGRgFvfilJll8ddXgQKxF/aFZdBiz9Z5LAxdXfodc29TajK94mBWr7zJk4LvU9uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041302; c=relaxed/simple;
	bh=JsHEnxzZfOJImgb3ruJ3pieGW36lOZf/AxcPFlFEDUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NkvJmFKMCZN8dGUq+2mGjMnDlBpUWS4MxsF7NsrexC+6V5C6gS8QRhiIbmyI8375k3HffFV8BbQYMNodPCLaV+DiXNFQjZif1pA89hmdO/+YmY42lAq3XmTcNtbmk2fbXoM93JNBRUx35sUQ44hPTwWHS3SaN4tw3RDlxWe85nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C37cRcZz; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C37cRcZz"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a09a3bd9c5so31601835ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 06:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770041300; x=1770646100; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTGhSF/LhzLm4AvGCBt62KIx+kqVzeQu4rl4M3jVG0c=;
        b=C37cRcZzSo0ONpEiU4XKWr3PU1UHd2B0CS9/2Ta3P5UxbMoNoP8dU3Yf18drAodTJ0
         1wB4zcuhcXCK5WIEP11VjFbxyHgcuAzVmefe3+wwxf4PbhqO5/8ji4EWPfPpo9HUNYTL
         UJ7oPElfiEtBLACeOmZM2EsO+xv6JcoO2/cktVCJTPaVuqDxzXtH5P6OwJbfSUPRUxSo
         HgpiNeckMXYV3hRCLXAcwNb6lX1nXzo7H6c1iM1pxacuvv/cCNCUplF6PO6+DXxQEOJ2
         MeeA5SuisEcLi30/EXKNpjImjFQSX9L01y0jtTevj0poNdRAvy4s/0vBPgKa5cvfU83X
         zXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770041300; x=1770646100;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTGhSF/LhzLm4AvGCBt62KIx+kqVzeQu4rl4M3jVG0c=;
        b=rcCPvLGctPKo02vz4dTTx7gHS00s5rjLwG8p9L7Y9U5KaHDdDtKsvNu9CoKWk7KPav
         Zc4o2HepENYXsAd8z0NX+V4djQIEqtn5RkwjdX0sSRREP/5fk6GiOto9QRP84mWet8oJ
         6wrC5PNIK5/of4AHwH0+TsWgWvnHvKwLC3ZCqpewUq4AL71N6Aprdp9LBmwyblkT3FiV
         z4sE1y1lUsEpQFWk8wOTe0vC0T5pArQYzeisqWJnRog4nFWtP2AY8cEk/VNZ6yvRtS3q
         MSsYKLAYxjWY5Ul2E8VNWgCqMzj522PsWPGtDVli+MvMCWLNCzrBP7UyVa4EHkCD0j7X
         9VQA==
X-Gm-Message-State: AOJu0YwEbIfvWmGVZ5CrE03mDjNafKxAYsyA/EQjcKY+YHixwMcTF4eG
	xA4YpAE9e+5kFuIxb3KN4xQPadbQFdn9XlM1htXyF6SVNxz8MjaIi8U6
X-Gm-Gg: AZuq6aKh/Ml1fyy7MiEVf0IoJA1VoHAgoCcDevtZjYDmOec/2KDtL3SWqCLuQX/noog
	+QrOGqWWFA6+Z22Ay1SwSDTQCdtEFDR8jd0plcBq5PB7f9T0fB2kjxSpgpHRfkAxBcepfMl/72j
	7mqxam1fmV3j0pTVmp3qfLdZtza1tVh3mvmfHUFJXzl/7UwcTduEmMNYjk8e+6lvPF2EIeGOwcn
	kqMZ3aTQqn2znZ4kiIuUuyKQbTILSEEIcsIttr2CDaf9Vrma9lRmgfRySHLOM/1CouO/RQ4wgko
	jObdq5kBc5OnRnRT1hGVZodUliOWGEk/m8v5Kt/v3eGD3lb/TLMZyWmt4AWKzyGiMiLPTEKxAt6
	6A/L6Mcu4b/fiVIPeVd9ssjTq3X2xe62915Cv6gibrwURpHg7rJERODdcgAv//3V6l6gKPF+44z
	1Pe9xRUd3E7BS0x22xFW41a+QLcQJIAiYo
X-Received: by 2002:a17:902:cf10:b0:29d:65ed:f481 with SMTP id d9443c01a7336-2a8d8946eabmr125914985ad.0.1770041299948;
        Mon, 02 Feb 2026 06:08:19 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a8b47f4717sm139961285ad.18.2026.02.02.06.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:08:19 -0800 (PST)
Message-ID: <04bdccfc-5eb0-4962-992a-5d2d0b0bb41c@gmail.com>
Date: Mon, 2 Feb 2026 19:38:14 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org, hch@infradead.org
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
 <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
 <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/29/26 18:59, Carlos Maiolino wrote:
> On Thu, Jan 29, 2026 at 06:04:20PM +0530, Nirjhar Roy (IBM) wrote:
>> On 1/29/26 14:27, Carlos Maiolino wrote:
>>> On Thu, Jan 29, 2026 at 09:52:02AM +0100, Carlos Maiolino wrote:
>>>> On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
>>>>> We should ASSERT on a variable before using it, so that we
>>>>> don't end up using an illegal value.
>>>>>
>>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>>> ---
>>>>>    fs/xfs/xfs_rtalloc.c | 6 +++++-
>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>>>>> index a12ffed12391..9fb975171bf8 100644
>>>>> --- a/fs/xfs/xfs_rtalloc.c
>>>>> +++ b/fs/xfs/xfs_rtalloc.c
>>>>> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>>>>>    			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>>>>    			if (error)
>>>>>    				goto out;
>>>>> +			if (sum < 0) {
>>>>> +				ASSERT(sum >= 0);
>>>>> +				error = -EFSCORRUPTED;
>>>>> +				goto out;
>>>>> +			}
>>>> What am I missing here? This looks weird...
>>>> We execute the block if sum is lower than 0, and then we assert it's
>>>> greater or equal than zero? This looks the assert will never fire as it
>>>> will only be checked when sum is always negative.
>>> Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
>>> confusing, it would be better if we just ASSERT(0) there.
>> Well, the idea (as discussed in [1] and [2]) was that we should log that sum
>> has been assigned an illegal negative value (using an ASSERT) and then bail
>> out.
>> [1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/
>>
>> [2] https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/
> I see. I honestly think this is really ugly, pointless, and confusing at
> a first glance (at least for me). The assert location is logged anyway
> when it fire.
>
> If I'm the only one who finds this confusing, then fine, otherwise I'd
> rather see ASSERT(0) in there.

Sure, Carlos. ASSERT(0); sounds okay to me. Darrick, do you have any 
hard preferences between ASSERT(0); and ASSERT(sum < 0); ? If not, then 
I can go ahead, make the change and send a revision with the suggested 
change here.

--NR

>
> Darrick, hch, thoughts?
>
>> --NR
>>
>>>> What am I missing from this patch?
>>>>
>>>>>    			if (sum == 0)
>>>>>    				continue;
>>>>>    			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>>>>> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>>>>>    			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>>>>>    			if (error)
>>>>>    				goto out;
>>>>> -			ASSERT(sum > 0);
>>>>>    		}
>>>>>    	}
>>>>>    	error = 0;
>>>>> -- 
>>>>> 2.43.5
>>>>>
>>>>>
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

