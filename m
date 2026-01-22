Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C502A36F423
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 18:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106789; cv=none; b=FqpWrTyDfHwxMHk60r3lTS5qB6/I+n9yeuC3rzT5dniibdl6zgUpT1eN9bAV+roY0thuHJj/vSPgaFKkpyEigrF2K+SD7N2jprm3q1MTDbAShzArxKA25Hifioe5zXB9LoG0cA5ufKjHfBATD7WHtaBhpp7Up0/36/egJq2I2i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106789; c=relaxed/simple;
	bh=em7ChTCz1HKG2Hfb2mq8icI4Wd5jv7VQtEacFTYUuNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUhqLMiOrRZH/Q3qiFfstUQxsaieG6+H6EfgdIU7cVRtCRysTM/It8RCYVQ3o8rRQIAgltD2OBj7+4f7U5FC5oyPmgyBAFBHgoL4JUI+W9V7LzCvrqjcmaxup/DxnLsugdfV8rA2qETUhpWUrsbSGf32oYKhKDIqh0nB8V52//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzEFI4WS; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzEFI4WS"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a0834769f0so9588835ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 10:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769106771; x=1769711571; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VV07WY1bd3rTCiL/N6ggwixa2qiCfThGbu4wHHcSIUA=;
        b=KzEFI4WSiAdNYy3CRC1iv1QL2Ae0f2037rCEoQngIKyvEtuHvYGXGz/mB6VM7489Ss
         LmrTtwFaHWuRCeoy+0MxqfLyTinUmh3hd/gO2lM4KxvjJvd8ATrsb43oe94CUWsa1NKp
         3gy9itmARelYP+cHOPIXE0/U09Unnw6CDTJpS61XjhSM2HtahuDrek6yHJyAFyKcVRsU
         OeQEIor1pmirfKT5zie9YL52k7j+oPkTpzsOIzJwMxzcXMZpQpkXkYkl/3RqrGY5CWcW
         PEiXSfeBdOcYehbUkPkA0AxNc8z+dpyAqH505W2Lm/cGtlUArRmV4Oza0I/i7/WAsjBG
         a/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106771; x=1769711571;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VV07WY1bd3rTCiL/N6ggwixa2qiCfThGbu4wHHcSIUA=;
        b=XKjMjD5QsBMfG1MKHF/c48X436W+jWACjmsQdch4F727OOMq9ryswrAIrlREt09PKp
         v8SFxhLC3+A+dYNXRbZpVPQzdgooztds/OkGBCxQx4CCrikW69S8W0BGBVV8H/yCD12X
         g5k9DElym2/VjnWhFTmtSLvuuUvE8RxMWb0NrsFwG/Mzu/bFH+yvonkgsAUDDhOTMuUh
         s0Vx9V2syzE1r3N1439oqENH6g4RnuF6m0Q9QdOMSL1vrBvGS7aFWF+N+tQ74CoO6LZj
         fizClEWLfqXLwUrQDVEwbfrmtqhJoQLqtxVl+4E9NuCHyrY9xZe5CSXL7rCSD8zxz2wk
         xvHw==
X-Gm-Message-State: AOJu0YwMytkW/hFvOilyuTskeVPXaYw9pfpkRmzKse6SJDBT41R/6NQH
	Iny7jhSPmndUBoqlesGGXeyGsxdDU00MuNmQrCXohtqob/iyVNmHG78G
X-Gm-Gg: AZuq6aIEUi3w56JLhRvlcsZJmj2lfaNtM+LafGx8V1Qt5cqpxi7l0T4wx/t0dJl5noB
	nGNBCuOvFxayQ+d9YXWhcf1kDdWBkEFUTzPu7hdj2VyaKp+Sdvso6NsARR35hd9jLAC77jEILcv
	B0KIwe/+sL9kyhkB2QuGrfu77sAi+3HTdzOC2e79UAirGHi3MiK2cgSXD8oKkprOnvuKzBaRCRn
	SbT1l/5qiy/8hqYY/o3cvhOD/epfkZdiapQX1GoDGF3xHXxQpy6cvLzDxzw8kThZJTVkThCGPcx
	n5iDEQivcAqZyFn0yKtOAQ6TPRG4a5GivxG/P8jn8AykYubFjXIru0CFwsJmnP/ZQHr0hgk4W8O
	IPo+qPXhxwsaEFqdVQ2mIxitQEmYxdhz6Vs2ymRT808RLkp9EktQVLosAB2bJ8BN/kO2r1uRiG6
	cr1p1go0iCeQwEPZ/4RjK1OA==
X-Received: by 2002:a17:902:ec90:b0:2a7:51bf:3b89 with SMTP id d9443c01a7336-2a7fe571eeamr3286975ad.19.1769106771412;
        Thu, 22 Jan 2026 10:32:51 -0800 (PST)
Received: from [192.168.0.120] ([49.207.204.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193fbf8fsm189685885ad.78.2026.01.22.10.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 10:32:51 -0800 (PST)
Message-ID: <4a99e408-baa3-4f25-85d7-0d160e19b325@gmail.com>
Date: Fri, 23 Jan 2026 00:02:47 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Move ASSERTion location in xfs_rtcopy_summary()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org
References: <044d2912a87f68f953efcb83607d5cf20b81798b.1769100528.git.nirjhar.roy.lists@gmail.com>
 <20260122181148.GE5945@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260122181148.GE5945@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/22/26 23:41, Darrick J. Wong wrote:
> On Thu, Jan 22, 2026 at 10:20:35PM +0530, Nirjhar Roy (IBM) wrote:
>> We should ASSERT on a variable before using it, so that we
>> don't end up using an illegal value.
> Assertions don't necessarily kill the kernel so ... do you want to bail
> out?
Okay, I wasn't aware of this. Thank you for pointing this out.
>
> 	if (sum < 0) {
> 		ASSERT(sum >= 0);
> 		return -EFSCORRUPTED;
> 	}

Yeah, this makes sense - this will prevent further code to get executed. 
Also, does an XFS_IS_CORRUPT() look good above, i.e,

if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {

     return -EFSCORRUPTED;

}

If not, can you please give me some guidelines as to when to use 
XFS_IS_CORRUPT()?

--NR

> 	if (sum == 0)
> 		continue;
>
> --D
>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index a12ffed12391..353a1af89f5d 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -112,6 +112,7 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>   			if (error)
>>   				goto out;
>> +			ASSERT(sum >= 0);
>>   			if (sum == 0)
>>   				continue;
>>   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>> @@ -120,7 +121,6 @@ xfs_rtcopy_summary(
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

