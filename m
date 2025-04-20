Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A11339A4;
	Sun, 20 Apr 2025 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745176418; cv=none; b=ZE4xj/b2dSNtADqZtHFRlKizpNLYTUY8NyuYildlTWdDUZT6WqPL0RD665PANS5KmwCKo3LI88fWOtIauO5QJhFNA54eQHmVNvHWTijBOWWdzR3Ah1mL5y2lImQgRHbk8kWtQmv4xxPOuw/zOoRbZ9/eaf2yXYL2NnPGWWmihKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745176418; c=relaxed/simple;
	bh=X59xWyT/2QbDYKXuHX0SkqVkNTn7Ewn0C2l+CiGhRlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N702W5SJ1HbQ7l7V3GK6dsjqk1+BaTbDffgcPSvaCcV/z5gOIY+Fxa1E58egDLVCMBpNWMoYaXolOZX0X+LH5McL7EA5Oma/KfV0GdbP5HzeEw9pX5UspMcHC4yQfHgy8zwxd4GUMCRFz0wrXHrI+0/hpC+dmtt39il5/qI/2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJFvyRl8; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJFvyRl8"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-227a8cdd241so39457355ad.3;
        Sun, 20 Apr 2025 12:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745176416; x=1745781216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=PNtyNtmvqoYh9yIpyUA84n2PvEa0SO3qvGnA2RahKBU=;
        b=fJFvyRl87ORoEuuxiy81LYNdxkMJzEUc/iNJseWc26045gfsSGWRlNpVaxBPcMCHvc
         kJROs9o10Q3KRExH6tE1OK/Rl3x+OyL0OddXVVDmj0c9lnYb1wgUwdp86xhwbV1HQHmx
         9KzoB8kQpY0THVVuoTFLwsVztuM0xY1Jcz4KQ++/va+GhIboEe+7L+xKBwiLj2s7Npbi
         4yulug2iWJlMLrt7/j5TBkJ3KNsVvBZtIF4Uy8cHn+38sMPYAPPXH1+/l0ryhf8aPToT
         Qvt98m93PslzH9f1V0X8SYdMteKr9ELN88c+QV6biqLE6htYUZTM1JHYRU2Z7WzmO3jY
         oTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745176416; x=1745781216;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNtyNtmvqoYh9yIpyUA84n2PvEa0SO3qvGnA2RahKBU=;
        b=UxV3cZX0bcbOdrn88wMpNAaSOSvFZytyEGof0c+GtzuZON79Eg+VbOIL9UnPhKR8uh
         4SDvM4NR8wmCGtxeMQthELpHsbb/VvoVxVORYfLbm7C11O7WXL5f+NZd+60ylp2vXInu
         DQyzg3Vcfu78GcgwRNPyXN22k+4i+3Uwc4nwnCxyYe5+77iKOWoleau2yAdAU85F+R5N
         etSmGwhQdXP8EK/augDTmAJKma9v60MF2oveb0pgaUO07HTW2jWDxg0CDkWcdAZSe+Bl
         jw2JtuYOS9r6u+zfrFCGgpkRZcxYg9aInxyu/hC/6s/HbRhVQo+4paRiWVcRPDHJsyUg
         VfUw==
X-Forwarded-Encrypted: i=1; AJvYcCUtVjP8VWQsqDK060zORG9Nb8gHruqivtFmhI3zvXmSrFrC5dYS4XnNVJg3m5sIkPz8Jcbn5VAyyXm6Tqg=@vger.kernel.org, AJvYcCWXPu0yH6Sl5GRDcwwrWVSkyNMG9yioK8kYuaxHP/DrxOGoeaAOBuEGA2hPY1LhzMeR0SPf8MHE3uwJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo+tQRYDkOb5Fe6tZZJLUhGZv8cgwMMvFcTEc5bzkTgfYJPeV1
	kcSOcj6NIvT3+EWjChQmsFHA1NP517OxZOl6zrU5tkjdHLlXDBVK
X-Gm-Gg: ASbGncsWTzuEYSt/HAjzB5d5l9WNyo9LbGw1FgubKGf+zg3a0IWx1t/Y14mVlYUPxfU
	x15SX0HzsK6/uhLpZ6ulTlcyEkIK0Hx5UMwmUPVbeuzkHRcQMFA++1ErP1RmeeC1mbBBi55mUXh
	WH/W7fnV12ns+m6qr7uGNsOV3n0fpPOjuCHnfx+mypVoL8nDyUhUlN/tOrpbT9cpLKTO0y9MCrf
	ueDM/MBG4PouWoLeNav+9IkMrfgCVA38yW8qa3OA9E415UxmuuF4bEIyF2WV16Hz5N84yuClTEl
	8nyR6hf88D2TKOdES4IsnSj5iP+64w+17j7T2SpuvwBVR5Xe/lZ7OA1PnZPUqM5idOGehBUS6Xf
	bPC3dWpgRMr6wqg==
X-Google-Smtp-Source: AGHT+IHbOdWVxK5XXjXKzZV7sUIFOdfyWAO7/8gqdRhaaDbg5NYpY+ZEjpaZzYsfbq6f0RTAecu5Kg==
X-Received: by 2002:a17:902:e5cf:b0:220:d078:eb33 with SMTP id d9443c01a7336-22c536195bdmr139634715ad.36.1745176416253;
        Sun, 20 Apr 2025 12:13:36 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fdba54sm51032705ad.233.2025.04.20.12.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 12:13:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <67c0a5f9-3349-4910-85f9-a017b6499dd3@roeck-us.net>
Date: Sun, 20 Apr 2025 12:13:34 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Dave Chinner
 <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>,
 hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
 <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
 <CGBuRmwlHYtQLQhMGGNldfbkiOB6TFkyzyKlWXmQIED91j9O6JH1391_9nwxfIiZibfKL2vK6r25kNZcS4RdAQ==@protonmail.internalid>
 <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net>
 <wpblwpuv6fbfqndbxi7y352axtykhevyqpg67d4q2eepogon7j@2hjqvzrzzknb>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <wpblwpuv6fbfqndbxi7y352axtykhevyqpg67d4q2eepogon7j@2hjqvzrzzknb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/25 11:07, Carlos Maiolino wrote:
...
>>
>> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
>> index 8c541ca71872..6dde2a680e75 100644
>> --- a/fs/xfs/xfs_zone_gc.c
>> +++ b/fs/xfs/xfs_zone_gc.c
>> @@ -170,7 +170,7 @@ bool
>>    xfs_zoned_need_gc(
>>           struct xfs_mount        *mp)
>>    {
>> -       s64                     available, free;
>> +       u64                     available, free, rem;
>>
>>           if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
>>                   return false;
>> @@ -183,7 +183,12 @@ xfs_zoned_need_gc(
>>                   return true;
>>
>>           free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
>> -       if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
>> +
>> +       rem = do_div(free, 100);
>> +       free = free * mp->m_zonegc_low_space +
>> +               div_u64(rem * mp->m_zonegc_low_space, 100);
>> +
>> +       if (available < free)
>>                   return true;
> 
> You're essentially open coding mult_frac(), if we can get mult_frac() to work
> on 64-bit too (or add a 64-bit version), that seems a better generic solution.
> 

Yes, I know. Problem is that getting more than one maintainer involved tends to make
it exponentially more difficult to get anything accepted. With that in mind, I prefer
open coded solutions like the one I suggested above. A generic solution is then still
possible, but it is disconnected from solving the immediate problem.

Guenter

