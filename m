Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDE21E1A3D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736277217; cv=none; b=A5Ndd13jMscVCPGofcz0x73kjvKmoGHU5OtFVeVa3Bjs36ZY2N9jG5noyIEsAjFFwtkQ0ISfo3AGd8XA7yDU65N5bZiLOoqjwPEBVXEr9oWYg84xvzkbFzMxijver5ErZL8UXKQx56eCm6B7JGTgGuXVFYu86YPH0wsV+RtY0qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736277217; c=relaxed/simple;
	bh=lHBGhRMpS+isXUIBTM4nlyaSvsRtx1oRlOrTrjFswyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCPQftP19e/H/nLc8zBMKmvs+9TCkFro6SC2FuhoVVkpc8oB7suk2Wevkw7gZVv/QdyKv06uGQUk0sGcsirvpPqkvMqwdgEFgCHOxyCMJiN5py0cBS9nnTU8soi2Np8YW07FKhX6y0BJ+rw/ngDutrmdi2dbuo/lYWeDsdGQJN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GagWqBqR; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GagWqBqR"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21628b3fe7dso227916715ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jan 2025 11:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1736277213; x=1736882013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tgtv/Tp1dGLGJarfn/muhJBWcmF/t5adXwF20vmQ79E=;
        b=GagWqBqRp1IHMSb8bnLTnSXjPe32sFjCYwEDSPO/jo7xNxJe+qTaJjHbTNT5C64E+o
         xhPk+Kpzrc5CONpXFsUzP65icO+nPYXXRJAfeiJUG5Opdlv0n8AZ5Y5wjX3Zh6nTYA4w
         bRpCzjeGrOyRS53SARa3Yu+IYumUm3Ko7QNSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736277213; x=1736882013;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgtv/Tp1dGLGJarfn/muhJBWcmF/t5adXwF20vmQ79E=;
        b=BSk8p/Wm76nhl4eK2jGxWyEeDWnsJFQqjaFw8BdVns09vSOCBbZwW1wYn2Jiv16K7S
         XhqcdCKs92misIHCAd/6v2/V02E1EF+n/IgRs3uz6UgJwfe2CzaBAzE2DaMT5FHH3WxA
         Mk0TYa+T9wb/PLZh4plUkP74AOtbe54VBUcNWCBP1305W3j5Z1UpsQzUrN+pR6yoXNBq
         Rl9BH58/h6/zlnsTiJZBV2vn5An1Rir+czRHzsJo1FF7GHXW5ekqiRkyZoItqkoYW+tr
         +g0IRu7NsK4RJ2AKOsa+ao7g1Jg2dX7oWVbjowFOJN2ebpi4KwtqfMEW1LGzPh4BwIb/
         f7sQ==
X-Gm-Message-State: AOJu0YwNG1dmmRC/pTTvaXZ0pzRu6GjYe2aCF83D+5YIAt0a124zibnW
	8wYdZjwxATcopbZPQnNweQ9821PIs82u494/ZxllOklvJKlpn4ma8CPKirSsWQ==
X-Gm-Gg: ASbGnctzaTIzPPF5KUnaKOM0knokMWPASQIWeChUvcPT63TNa0u+RrZ+eXyAueCez6F
	93orLU12ksgUay2kAeCBdavmGCHVOw+peGgaJpJeB522STow/z+NaCYLjE4L0p2ZOCLRhIQcAnu
	rvfwE2SPvVR97JiITvNJGZuwOd9BdEQmiyF1cotZPZ2gWEUYAST5D0gcZE40afpXIv/QDvK3wid
	EKdvltBq88SM3NkiVOAjtRMnugxUaTbhJTZkrzVccGiDOVxfdxBppDlNiiYw/AkhlkRqj9tFF3y
	82h0QVlAYRo0OnRNG9xx
X-Google-Smtp-Source: AGHT+IE1U58cdDJ73v9VNMZZHPQbJ6TBlmY6khSs7OWgj/TLk0Wb72U2tK98leSfoV162r0vCm31sA==
X-Received: by 2002:a05:6a00:2c86:b0:726:41e:b313 with SMTP id d2e1a72fcca58-72d21fc659dmr90518b3a.16.1736277213660;
        Tue, 07 Jan 2025 11:13:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842aba72f71sm31317662a12.9.2025.01.07.11.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 11:13:32 -0800 (PST)
Message-ID: <2f2d4e9d-f4ce-46ff-ad0c-779234c070a2@broadcom.com>
Date: Tue, 7 Jan 2025 11:13:31 -0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_io: Avoid using __kernel_rwf_t for older kernels
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, mmayer@broadcom.com, justin.chen@broadcom.com,
 catherine.hoang@oracle.com
References: <20241125222618.1276708-1-florian.fainelli@broadcom.com>
 <20241126012224.GJ9438@frogsfrogsfrogs>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <20241126012224.GJ9438@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 17:22, Darrick J. Wong wrote:
> On Mon, Nov 25, 2024 at 02:26:18PM -0800, Florian Fainelli wrote:
>> __kernel_rwf_t was defined with upstream Linux commit
>> ddef7ed2b5cbafae692d1d580bb5a07808926a9c ("annotate RWF_... flags")
>> which has been included in Linux v4.14 and newer. When building xfsprogs
> 
> /methinks you should upgrade your kernel, 4.14 is quite dead now, and
> you're not even running something /that/ new.

No disagreement here, we provide a toolchain whose kernel headers are 
intentional set to 4.9.x to maximize the compatibility with what our 
customers would be using at the time and that is how we caught that 
build failure. In general though, we should not be intentionally 
breaking the build against older kernel headers IMHO, especially when it 
is possible to do so.

The intent in the commit in the Fixes tag clearly had taken into account 
that RWF_ATOMIC might not have been defined.

> 
>> against older kernel headers, this type is not defined, leading to the
>> following build error:
>>
>> pwrite.c: In function 'pwrite_f':
>> ../include/xfs/linux.h:236:22: error: '__kernel_rwf_t' undeclared (first use in this function); did you mean '__kernel_off_t'?
>>   #define RWF_ATOMIC ((__kernel_rwf_t)0x00000040)
>>                        ^~~~~~~~~~~~~~
>> pwrite.c:329:22: note: in expansion of macro 'RWF_ATOMIC'
>>      pwritev2_flags |= RWF_ATOMIC;
>>
>> Fixes: ee6c5941352a ("xfs_io: add RWF_ATOMIC support to pwrite")
>> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> That said, if this doesn't break anything with a ~2020s distro then I
> don't have any objections to this, so:
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks, any chance this can be applied?
-- 
Florian
