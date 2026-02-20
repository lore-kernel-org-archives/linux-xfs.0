Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AF232ED42
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771569546; cv=none; b=LOW3YKo+mp9i5CaOlQ/nQld8lxUzKuXMz/O8eqbP4QOx0SdHIUbEm2J5vElG5sEBHBj/9uxaoUKMYNlSRMJyI8Fsa3bUCDfZKybpj8rfVT20ays5hQfn7PPXzwHaMYXsWJ/+K3l0YZlZkVsekXnUGaFPeSj5GBxgQIv/v8ZG51I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771569546; c=relaxed/simple;
	bh=l7syuu2WxYhiGxuDalPPlBp/TZkeLdoa6UBndodZX3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KR+3UhzAVAW+O0Pt+3a0Qhv4RJ26fGglp1MWAvd5m3ldgjm7XI4GOZPREpcTqkyW8G+hRe2d9tTNqvFhpZrQmvY251gHfD8+TMEGbjJIMLu3p4kW13vLkrzNPMYD9YaFsXJyRyI5PuPNIhtlMEH53E/YY/+W9We9+fXs74sVZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gb3wDLHs; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gb3wDLHs"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c2a9a9b43b1so1112482a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 22:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771569545; x=1772174345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3P5rIfwmsbhJBDk3X5FkNG2GbDjGmCTI7qF0hNs15p0=;
        b=Gb3wDLHsIZvhLNuKb6WcGYSJMdSECz9ZopABh6LN86TdlLzhbhYFbzwcexsNHyn81Q
         QFku0m7uCp+Z+tfFaryIJgQpALtYqffdEWIYSDMAErG4kReqmygDFmfFww8vO9KNNOtH
         1G1AN3YdF8zE4cpKHfoyt9YZiKC5X7ldaJJ5Ynu/srTxY6tGIedhq9OWgm9NuuKxvFms
         EyRIGyu0ko78lUDFqtEBmqJkaI6CMFQcKGyx1mXKvuIf8QVOnhLH1Xpwl4Zd/FdWBINJ
         MezturdjayS1AhxX82K8Fvz3t3PLEgG5YsUD0CRSSVqInSkaAWCY3/oYdKHKTSYq9J2m
         lUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771569545; x=1772174345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3P5rIfwmsbhJBDk3X5FkNG2GbDjGmCTI7qF0hNs15p0=;
        b=a465KPK+mqxfOnDjqxzsKqVJJVWe6b5HiIFjc6CgjiI6HqgdzyUx1ejIIEHjMq5m2H
         YqwLEq8Hn4x071jp8PtD7BENMU5EqQzEzQ8tXr+6HhwcFXfwUPr19HZz56MYm/2JeArx
         QcQIxh+ArfPRa7fz97ofAENbkEx0TiuUw+2y1Lj0lx9+XVHVZBCTLdkEvTEOzeZRcIL5
         brXjyBU0bdckCLdYj+INEPw/2OxR10UK7qhVwe7CoJQcOk1W/8A07UeVxnjJ0wGq1mYA
         n+rkD1R0HAdTip0wLqBmsQFJXrz1z2ZZYE/VNiMv+bqHetJ+I+Qw2MsUadWdO8VH7tpg
         OGXg==
X-Forwarded-Encrypted: i=1; AJvYcCV774VE0ZZrF4sfES7uwZ8o7uLPx8nTk66yCmanLeJ9WhEmPG7M94l4DKo6x+5jBu7t/Bkbf1S6C2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdTZ4+V304VAriYk1MvNEx5kC1qISjoHpRcgKXncr58qe0FtOe
	jqy4GTeUTq0hE/42SVvvgYgjAa4KHphaU3KXCIbun3tTy6u0zm9qs0ih
X-Gm-Gg: AZuq6aLvel+bcKDhYKwaOkPVfCVcdC3Ygv5V9X37DV89tDCesF5F6sUWE9HsXJn06Ve
	WOTMgASBwlRl2e66BRrQ1mZJ/oWC8SmlAcs1xgI9E5OGlqP88XNlSRowZns6HznJQjZNxmEOrJO
	GRqMo1AXwZz95/ATQBX8qplpT2OyuNtXeyD5Vb4Q5iLaxoeWOGrClJyG1KUAhSpBQKpfZNT2e0A
	uLItVIt+zvN7Jtcd7nJk4HAIgALKDOtod08Oh+DabhccxjCREQH1I3eCDaFgent9hKNedrn86CY
	cHSjcxDAzy0EY6TErNu1+T84aC3dLL3H+NKDzkHdkqhUVnlqAQcszxNKH23x4RQjlDfUFowWfau
	nMi+owYR20qJebOzSM96vgqeRRXQbyo4nGD4Muz4y/e74BQ/lTD8jAFJEmpUGYFODzo26879iEw
	+1LNGQyZybA8kqEe078l2vvlNTgXeYQGTpMA==
X-Received: by 2002:a05:6a20:438e:b0:392:e5ab:3125 with SMTP id adf61e73a8af0-39483aa0c07mr19053902637.66.1771569544803;
        Thu, 19 Feb 2026 22:39:04 -0800 (PST)
Received: from [192.168.0.120] ([49.207.235.235])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e531e6c51sm17768546a12.16.2026.02.19.22.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 22:39:04 -0800 (PST)
Message-ID: <fcd359e2-571d-435e-891d-784956008a54@gmail.com>
Date: Fri, 20 Feb 2026 12:08:59 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] xfs: Add comments for usages of some macros.
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>,
 "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <ed78cfaa48058b00bc93cff93994cfbe0d4ef503.1771512159.git.nirjhar.roy.lists@gmail.com>
 <20260219155409.GG6490@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260219155409.GG6490@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 21:24, Darrick J. Wong wrote:
> On Thu, Feb 19, 2026 at 08:16:50PM +0530, Nirjhar Roy (IBM) wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/xfs_platform.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
>> index 1e59bf94d1f2..c9ce0450cf7a 100644
>> --- a/fs/xfs/xfs_platform.h
>> +++ b/fs/xfs/xfs_platform.h
>> @@ -235,6 +235,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>>   
>>   #ifdef XFS_WARN
>>   
>> +/* Please note that this ASSERT doesn't kill the kernel */
> It will if the kernel has panic_on_warn set.
>
>>   #define ASSERT(expr)	\
>>   	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
>>   
>> @@ -245,6 +246,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>>   #endif /* XFS_WARN */
>>   #endif /* DEBUG */
>>   
>> +/*
>> + * Use this to catch metadata corruptions that are not caught by the regular
> "...not caught by the block or structure verifiers."
>
>> + * verifiers. The reason is that the verifiers check corruptions only within
>> + * the block.
> "...only within the scope of the object being verified."
>
>> + */
> Other than that, I agree with this comment.

Sure, I will update the comment as per your suggestions. Thank you.

--NR

>
> --D
>
>>   #define XFS_IS_CORRUPT(mp, expr)	\
>>   	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
>>   					       NULL, 0, __FILE__, __LINE__, \
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

