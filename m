Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9806021B1BC
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 02:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762308495; cv=none; b=F+IgxHwLsaJoF9giPnnXkhe+yptN1Iqx6WKY5hSOR5pw5OpqY3pUA8jFogdL80d9Ii8NDdYCnFmvbzvIsgRxU19K8YA2QOEE5zksVak7qk2sEtNs2oHUNHOzEmDGQjSF+ES0C/ezzkpSYCBCNTcwXi7X6vP7Yy67kkY1nH6hKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762308495; c=relaxed/simple;
	bh=aCIePvxR6b0aME6sxxADpgHuW9tgTHqfJqmmFPqOqb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hx/Z8mHBQje1bj2pSWhrSV/Na8sXxJAq90dWGrILt7dg2mfYN+Qm8n9XuXzhQPTLdR+9bV/SYt/GyV28gku+t5yrI4tID1fKaAUB6/eERIuB8gAP6GyXXjAwg0oq1Bvcw+ScrReGtjl5QcFwX9IxD+pE/s8CSWeYyb82bjOTZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOXRdKOU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOXRdKOU"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-27c369f8986so63192975ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 18:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762308493; x=1762913293; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a4yDBu3bQnhMe9kSGDJfDwWvTH191XsVU1fFztibKfQ=;
        b=AOXRdKOUWbvJa/YjPYbAkr6KmAf/lpgcXmUSDMlJy4DYU6lDrP6RkJyQnnU8PTt7ke
         2sY+RCUIJTIcQig8mGcG5B3Qu74NRGKT6e2gucYzRCyw68u3Pxc6r2DV2z4GhAvecxsc
         M9hVastkDwW3WAqenP+6idkb7Yif1hEeYLO9+Zf3Txax7je4fkY4p+Ch5NTCg2FNHrgx
         X1ALGtL14NAxGbczmqgoq/HBmD9874hXQHTZx3j3lXwqrycY1t3Pl2jwCZmxgN6vIaIy
         FFHgaA11QsAfEFUtoKWa/9nuuOomJepM+uB1M1KJ4mb6OKwJf8I/DpYIAOi9vYjMCcDu
         UI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762308493; x=1762913293;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a4yDBu3bQnhMe9kSGDJfDwWvTH191XsVU1fFztibKfQ=;
        b=fy+yxbiLKph48wkA18R/sWqW4+8aqqp3LafyiAgXz/5tHSZICI2XniIJt9ddIDJw/a
         FVbFlnmQLja1clrSjpvwQAVDIuRUz4p+NPowE/hTMC+5gmDVpCxapH5P+mSc6Cq70Ad6
         KZAqc2h4ChXT+2tEcZ9c0xRSIfbaZDX7CxMK9JFrJG/JfVYzIueI7w/6nVYADcUAmeKc
         B1lkpou+zdwUnXat9f30TQt0DVdMjV6Es7cZvvdGdjxielSVtlpOri66J89TyNbmYBiW
         avBteFWWmU6qaqxSTaKY9F9Z7U9PM5AtiLvG6RwuZAnNgiYXfQve3afPgZNkHxZUHYil
         V/UA==
X-Forwarded-Encrypted: i=1; AJvYcCVp65fcOTFnbJ4gyr86Y9NoxLSOk4OCsl2uAUUXz/5FtbkzloJ2jIif5i89qpsll8LGm1Y9xTd9L8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbURRFeDwC6Iwhbz/ZFYLmgTcVh0iWASN6pniFCfvbAzDY6nk
	dNBpI/8Gc8MJ9X88zAWgYGMsu4pOxVj7slWjWznq4353lx4X43njb9MA
X-Gm-Gg: ASbGncuXqS7AIzJ7GirfXKpcBSTdY2S0kdMZ/fbuANYNKLODPvtxRmKHKYzZqGtgAOp
	I0xwUTWgYh5Bq/WJ3p1+ZoEVJW+XRUW4w9wfd9qtSKikFg4+BNX51mw9GO/7VR+2v3Hv+/Naoo7
	GZMP4Zbi5vLWcQRk0HaKnqo45EMXO95R5t1OTC7oWjV+v/3qukaWb/WC0pZnlSl6tCalYwFpac8
	2xzr/YgmB1bdRNOGhZ2/UlxCtSAMABK+gXsosRrD0nz4rZ5QeXQTLnMNotL1wyozAiPkexChhx4
	p99LBBFaDJ3GJWiApvxJQ4RS8W6fQa8cTNtZEC7SfKySe0oNiLMsY7AgSXJHa4wY/TyY/XBgle7
	akOPj6dCl+iKb5tUbvCYDro0OBy97OQxU/yEEIfF0I+TPBHNrX75L6yanglpVc0bTjzkfhFkEUN
	MGsabtRepHSmxfhE868ub0MVI=
X-Google-Smtp-Source: AGHT+IHFEEDEwbkYMhDcYlAouSByZjRV09d05fMzqHjwPvk8mlwVG2htfWc/MvggLNSc+kqx17qoEQ==
X-Received: by 2002:a17:903:2448:b0:295:6d30:e263 with SMTP id d9443c01a7336-2962adafc02mr23971055ad.40.1762308492736;
        Tue, 04 Nov 2025 18:08:12 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601978210sm42828115ad.2.2025.11.04.18.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 18:08:12 -0800 (PST)
Message-ID: <221cdf62-f8aa-421b-9d39-d540cbe7346f@gmail.com>
Date: Wed, 5 Nov 2025 10:08:07 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] xfs: check the return value of sb_min_blocksize()
 in xfs_fs_fill_super
To: "Darrick J. Wong" <djwong@kernel.org>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo
 <sj1557.seo@samsung.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig
 <hch@infradead.org>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251103163617.151045-2-yangyongpeng.storage@gmail.com>
 <20251103163617.151045-5-yangyongpeng.storage@gmail.com>
 <20251104154209.GA196362@frogsfrogsfrogs>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <20251104154209.GA196362@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/4/25 23:42, Darrick J. Wong wrote:
> On Tue, Nov 04, 2025 at 12:36:17AM +0800, Yongpeng Yang wrote:
>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>
>> sb_min_blocksize() may return 0. Check its return value to avoid the
>> filesystem super block when sb->s_blocksize is 0.
>>
>> Cc: <stable@vger.kernel.org> # v6.15
>> Fixes: a64e5a596067bd ("bdev: add back PAGE_SIZE block size validation
>> for sb_set_blocksize()")
> 
> Odd line wrapping, does this actually work with $stablemaintainer
> scripts?
> 

Sorry for my mistake. I’ve sent v6 patch to fix this issue.

Yongpeng,

>> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> Otherwise looks fine to me
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
>> ---
>>   fs/xfs/xfs_super.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 1067ebb3b001..bc71aa9dcee8 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1693,7 +1693,10 @@ xfs_fs_fill_super(
>>   	if (error)
>>   		return error;
>>   
>> -	sb_min_blocksize(sb, BBSIZE);
>> +	if (!sb_min_blocksize(sb, BBSIZE)) {
>> +		xfs_err(mp, "unable to set blocksize");
>> +		return -EINVAL;
>> +	}
>>   	sb->s_xattr = xfs_xattr_handlers;
>>   	sb->s_export_op = &xfs_export_operations;
>>   #ifdef CONFIG_XFS_QUOTA
>> -- 
>> 2.43.0
>>
>>

