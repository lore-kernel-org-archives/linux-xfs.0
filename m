Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F23242AA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769619658; cv=none; b=RX1ycsspmqlaaAW961txOThWHexGp1wzLUn75PKmj9syGvM4tDL3cr9NeX5faSkF60mmZgWPDBA++Qy2xTJMXC/ucltDCyrntgieyUnIFbs55qbl4KKenofNPKOZHFzofQUPhwX6ycqGAw4YBydQ5hXll6RMGhSU3mMDghjDWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769619658; c=relaxed/simple;
	bh=Tlb52YHNrDj99LsdsTBfFl+S50u6R5KH2CYpLX9J7yM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkaVrzrPtxqQzKkesttr/jWZXeMblNNliMgOuPD5vW+QWJT2P5+Dc+KrP2p1EfV4dBCQaTuVn35bdT22PipB7X3mjF+1HrwY42QenM6mQUzBtD5npgovZMqEo7hMIMRHil3Ob+ZcTiLJ/n9sgTY9+v1nQ6M1gybXVeJl4Ebx2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmdA56Ie; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmdA56Ie"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-81f47610542so22267b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 09:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769619656; x=1770224456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ar4opeTIWzI6jKb4ZtfUSo/2Bh2d2vZYjlngqPaI3Ow=;
        b=hmdA56IeMenWU1OATdSZb3GPBgj0AD1YJWjYHvY0OnQQdlhwqTsUpo/HeLr6xScG/m
         jaVgZ/xlIC/m+cyj4HfPwWrnv0C1vS5tXxFW+9GX3bnjCBt2ktH1zFbhC46It0hAVOjg
         8vjhuLQL6siDx8xK61G5KtqVrRfmBiy3iWILdctIQWtKRWu6OgFkAXzRfGWY7cx+WHVI
         KZWbhcnjoCfr7oL6uaDmkLtlZjN05laUWgY2tYBUcxhq1wSZiU81HbZ3XeBMEBg2njJj
         j3fK7JCHZW4TI8YktAEbhKB/bgmycgdxwey1TOCPT8dLVm3rkpbmfPPRRdCb7XyQxwmQ
         f+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769619656; x=1770224456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ar4opeTIWzI6jKb4ZtfUSo/2Bh2d2vZYjlngqPaI3Ow=;
        b=LxltMvO2lrXVH4tY+IABRv1LbbbUhygzHS36qsWQxNIviApRWG9PUBvhYiCdKM1nrN
         S8adRaH7Yyr3hrmVdgpg2JUlM5LfLv56oPpTmoDyWXU3YgbMV7Zk4ez9qN9n0NHyeQmm
         gTZbkL6+eFfI7E/1P7tacmn5Ixss8JuNtDChe7ZLeRX18lqsqofaC/aHDPXnAtkpapR+
         ViKjPsYm2KHfjd6FaVZqSw8ghcSmCAxSovg8XmjhvVlL2ZOr44+GmHAZc/QB2parLCzn
         K7fT+1iGi4Ez0wxNkZeSuShAJ0s557SfIvwrAsZLRcpxuinkk4cbcAs2xDQdQvYobj7l
         AYZA==
X-Gm-Message-State: AOJu0Yw2UzbQ2XG7szMDYNBCMC7gEDZTGTPttHt3Dx79eqQm/c3hPFJi
	wzTPOdUHyutyq5Cy0ECdb1YrgmW8+N1W3dfwpzw2QORVkuIuoOer7LmVIsUWi/pv
X-Gm-Gg: AZuq6aJhULRgkW2GuqSi0E9jKhRgO5ZZbE9z/P1iYjnUkAOBoa2ZgDdrPe0YM38xC15
	mgjKtqOKtRuAt1FVdqtMNRL7R/Szd5kfBddpxku94/neheg651SEskPhNDwiOfDqWWM/NG2S0xk
	ekcLs38sv65CiXi1GPP8LmSCyw/+tJRs/2y8/ffQqgcW3BRHCZt1RCoXIAUr79y2dtyD01Yaf0n
	qXiH4ehlEb2tacXb//QkanyN+k7dhG1XAsk1jn1RA+MHd0gcxVopXRPaZbGKw0x/i0B90q6WrUz
	Pv6llXOHrf8JVeptapUDb4g1PoOq9nQDaFStBs7b5IW4L/7v64brw09gbjvpEUIDTMnsznE8pXd
	V26luF1UV3Kiz7/dsNyKkbIjTPIvhsBd9GlGR3OPgQhRwX+e/zgsyrzUhwmJ3196wzz/9bIhUcX
	RPiL6dM54ij1YC9IZG/OdSxss1kuFeFGJF
X-Received: by 2002:a17:90b:384e:b0:34a:4a8d:2e2e with SMTP id 98e67ed59e1d1-353fed7f348mr6029521a91.17.1769619656138;
        Wed, 28 Jan 2026 09:00:56 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3541110e2e4sm144716a91.13.2026.01.28.09.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 09:00:55 -0800 (PST)
Message-ID: <94c5e9cc-5f60-4c74-a344-2dd868844352@gmail.com>
Date: Wed, 28 Jan 2026 22:30:50 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org, Carlos Maiolino <cem@kernel.org>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
 <20260128161324.GU5945@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260128161324.GU5945@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/28/26 21:43, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 08:44:34PM +0530, Nirjhar Roy (IBM) wrote:
>> We should ASSERT on a variable before using it, so that we
>> don't end up using an illegal value.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index a12ffed12391..9fb975171bf8 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>   			if (error)
>>   				goto out;
>> +			if (sum < 0) {
>> +				ASSERT(sum >= 0);
>> +				error = -EFSCORRUPTED;
>> +				goto out;
> Thanks for making this a bailout case,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you for your suggestion.

--NR

>
> --D
>
>> +			}
>>   			if (sum == 0)
>>   				continue;
>>   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>>   			if (error)
>>   				goto out;
>> -			ASSERT(sum > 0);
>>   		}
>>   	}
>>   	error = 0;
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

