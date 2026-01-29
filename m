Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E703387352
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769690067; cv=none; b=LfvhA7vGVFRG9FX6YoieO5uKu0MjMYzb1JNLEphddbwMDctWfyyacvDrhN1JhF3oQhHojx545iwvgnCtgEoAyoOeWjpji0ZwCVVaPGASseMlSnkY5Jh47SNBJuARy3VvItO1sCawxb3RTgUhttWGvlOwHy88sK7LDQwSdCNhCyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769690067; c=relaxed/simple;
	bh=Km/ic/rm6pj80xC/TW7rrb0PYCoxd/N1AXCoNjHDQdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1W+kS2cbnpPHSMeiLPkIocMD9pmuGdCUC1zs43efcr3P3SdEHvebpy1RBfjAuGUY4IYhpQMN8/rQmVj+tKcmwoUZM2X1pBhWO2SbALcDeT84Zfd+6kxPH4HZgiJhyzEcg+lwJJaplLvc9SHUt1zditclm4uTW29CWQwA8Xtd3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VCFKd1fd; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCFKd1fd"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so8401585ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 04:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769690066; x=1770294866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r+VzjEvlY7ACyLMSQprMF0YzMyqpKEJRjR69AQbRhA0=;
        b=VCFKd1fdqlbDml9OX1o9blfD5lyIWJ2r7tjrN7aVhCynTEVZTpIh0GU3m8nsUBTyYx
         XZFHpa2kg+p81Mh2xaYYYPMt+SMEZ9UQP5lOdO1qw8sriJmO5FwklFWEdZfn5s/s3iRl
         nn4c6+VlTVe0038TGGWHWZtqwd8/9nwbMyM6Pt1JNEUqageNm+OfWM3GtbXmuxBm1lqy
         NbDUIM40WZ0XGBSpXPa6idyNWI4PgXc6nuGXcfUfqGdYGKNJhPwLXOdnGPBFkRgcozqB
         puEFFg5t00j9REGkoBdXfeC0fNjWFMjYtcoQr/DMICrBVEUFKZLYV5bMBpSGH+zxtVBb
         abwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769690066; x=1770294866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+VzjEvlY7ACyLMSQprMF0YzMyqpKEJRjR69AQbRhA0=;
        b=eS47QjFaSXFFNKKaQSTD1556v3HZ7aRxvOcOC8zt+z6hJ+fAtgfewy8SbupqY6dgx1
         cM4CK+3UrVdhpd00BQcgJ88CQOIZw6g564s1MPw+WNiPYvAOHLKyDdhIMHKX/81rvdkE
         FD/FOHFBvsSrk0YCezyWayIb1ICdWEGxwCgkUZ02ZjCFwl2AINcGewe59dXslxJnzeG8
         3rsnOZZulCrTDlmTVF/6SQCYI9KHc7FHhyPu9As2DNRl7H/3nWveALuix2ruzLGYMgZD
         NADiQpbDE08yndQltKrEwj+qJzJui2u4+BIJ3BwPJh474CeiZJKtGWwsUPBBqEP3TnpN
         eiGw==
X-Gm-Message-State: AOJu0Yx6eOajthxpOtJBFjcWP55xiyRK3f//yWMSM98M6bYRlnL7WqLY
	4AdsVO0xyJmoz9gnfeytXwa4CFkX2R0vF11lLscS4uGM96Crl+Sq7Fa9
X-Gm-Gg: AZuq6aJfMU8dS3vdBDyVxmo/H3wQYtwFjbCHTbSTcaHR3LvNXDIZZtXJT0acKAyMxbu
	oId4UVPHzaw5WUGNxtdkhfNUopS/k8aTDhz/fqzbLM4n7a1AW70pdS0EIuFXOIDkIDok9YJavgQ
	q80uqImiimxRWMoqU6XWjabJ0GCd6A5pqKeot/wnKGEF8IYw9oPKysXxK78qPCp2yo7UKZ2lNpA
	ospH+MB/dvJLNCgCbhxNqwLxfK0JA/WtwoUls02E7FDsZLhd7Jwdxk0oCL6kxO4XRr6Tp1XG3t9
	uqvrYdHI3cQTi07o8bp9eQfcaqvutVcyperTW4cDPDzbGWOF7rxlIJm6tm/rjGlnet5SuTuXRnl
	+nbL+nDUsbHxFNZabi5yTdi2SRtZMPcuqMJJj3ccY6xW51X+qX5H+H8NZSECcyU5Nk5hN4EOoGi
	tfczm3oKPetwDf1b1CJZawiw==
X-Received: by 2002:a17:902:daca:b0:2a0:d4e3:7188 with SMTP id d9443c01a7336-2a870da0e9fmr83279135ad.13.1769690065864;
        Thu, 29 Jan 2026 04:34:25 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b414071sm48998285ad.29.2026.01.29.04.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 04:34:25 -0800 (PST)
Message-ID: <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
Date: Thu, 29 Jan 2026 18:04:20 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org, hch@infradead.org
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/29/26 14:27, Carlos Maiolino wrote:
> On Thu, Jan 29, 2026 at 09:52:02AM +0100, Carlos Maiolino wrote:
>> On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
>>> We should ASSERT on a variable before using it, so that we
>>> don't end up using an illegal value.
>>>
>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>> ---
>>>   fs/xfs/xfs_rtalloc.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>>> index a12ffed12391..9fb975171bf8 100644
>>> --- a/fs/xfs/xfs_rtalloc.c
>>> +++ b/fs/xfs/xfs_rtalloc.c
>>> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>>>   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>>   			if (error)
>>>   				goto out;
>>> +			if (sum < 0) {
>>> +				ASSERT(sum >= 0);
>>> +				error = -EFSCORRUPTED;
>>> +				goto out;
>>> +			}
>> What am I missing here? This looks weird...
>> We execute the block if sum is lower than 0, and then we assert it's
>> greater or equal than zero? This looks the assert will never fire as it
>> will only be checked when sum is always negative.
> Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
> confusing, it would be better if we just ASSERT(0) there.

Well, the idea (as discussed in [1] and [2]) was that we should log that 
sum has been assigned an illegal negative value (using an ASSERT) and 
then bail out.

[1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/

[2] https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/

--NR

>
>> What am I missing from this patch?
>>
>>>   			if (sum == 0)
>>>   				continue;
>>>   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>>> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>>>   			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>>>   			if (error)
>>>   				goto out;
>>> -			ASSERT(sum > 0);
>>>   		}
>>>   	}
>>>   	error = 0;
>>> -- 
>>> 2.43.5
>>>
>>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

