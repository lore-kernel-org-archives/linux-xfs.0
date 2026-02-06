Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5614C2BE657
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770382278; cv=none; b=OlJJPENP5oGe1y3qvWMYEyj6l+UTB4sHfJOoxhCzA6GjoQW2CNSs4KRx/DgI+mhsGxMahreeHciVCxv26wWQ05RcnxY9QjQBdGoK6t8FDrX2BA0/TJqOLOeXNwSOrcSsXB9W8N8KdnwZunz/VLNzunJMVoxr6M/f9csZlFV+wWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770382278; c=relaxed/simple;
	bh=AFUsnFGh31htw89tqvYpfxpoA7SNhlNOvapAuknlCIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jGI6M8oA1nChJO7LUdtR8iiZ2bkArsKFMXn41wzkU048qPP3t45uxE50Aj3KtQxbwuIhaVf+r+VMbUlcwXKiIC8+tZ0QNQf12+gOmsQcAtUIUipED5UReeTOMqr5f2MyqT+98+x/g9OfOALr2bGPfHOMvANPkkntJGfz8Z+Eba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A+xa0JZi; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+xa0JZi"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a102494058so15159655ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Feb 2026 04:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770382278; x=1770987078; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8tInnL6WpAAEehDaULIGXE2eXZN9AGZ6eZpW5YU+EOg=;
        b=A+xa0JZidWcIdgorPU6SArmS+0ehzz75wYYf5Pi6CSDYkn8op92Crry0hhvNieqe0s
         b8yin3yYWNZmN0aBSPPSCMxk+iYYPAzSi6VSEclxuVQQFQVSY5ox59PejRZFjqPzu/Qi
         cmMIfOffLz5HTws58YcKRb1R/nCYdVQ8B9dNnq3WI30hg5DZOXHVFpwYlTGFsaAqAz+b
         Mer+pQaIgfZ3J55A36Ynds866JzdSS3IGiYQJSq+fvPk8SV6kt6wZSC+CWHUza3SB/gp
         uFejleweFrRqCKgeGrMmhigQ3tW/AyWmRP67sr6jH9QKHYXipgw3VOt6tWxyrUHBLV9e
         iPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770382278; x=1770987078;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8tInnL6WpAAEehDaULIGXE2eXZN9AGZ6eZpW5YU+EOg=;
        b=PNWMReNAJCOu0/F3XmYZVzU25jfkxLCyxr2W/4LmrP0x914ysaqwwitD3OXTJx6aK3
         DuYCIDpj6aqgC2ZpAnng7hie8Qtk4tZxszeN8GBY7ef93sOTRG4J39CMb34uyV1zh4Zp
         niUDiFxIhbzv9/TaIWIRR6ytTjRT0Ro45vworTI/mak2ujUny+VHM+H8FYJ8cmriTxBt
         4f9FAzr4o6pUXNugYe30h+KmuVJm1cZvhcbqSbuVIcowjMTVMheA0V2LNcH4MYivA0oD
         3hlHqekzC1hROjya1NLT0gO+7hJcJisvLjq03sIyGux4M3RAjR+4xxUrjYIR/Z6QPF3k
         V+0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAkymJQJ8aFhP/ACvu3d5gdrEP6ZsO3y1CCuUzGotN2KMCb7FZQQnW5RAXO1ch9Rk42odTzcPTYiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsgLJeBUGXJskQgsbfDi/X/xvfUQZxp1O846pjvE5k2+QIKbVi
	B+KPpP8X6Hx/A3QRIdwdt1MhfAv1FiXWu+MW7NxQ0d6uVI2aHEG4GkMF
X-Gm-Gg: AZuq6aKZPZUv5X4++heCn3uyUzIaX7J5wg1ezpCBX3ZAvTDjhwX2l4Vp/89RHC3BNXi
	gHq0UG5oTghT4ysRhgj9qje1lQTpi2kHsIiEsp5mvQI/F4BFE4EL1cS7RoyFKPzytIbPRJNJG1+
	TO7I/xA2UQwf7UEiDdGGi8wLS5Aq1z49KyC3mAMc4yfLnmd5C0DRL1zNhm7pbYtZ/k1G+JFD63x
	i45g7P4fUXdscH9Ak2uXazua6bDjSDTgX4VNdATLMnrqfa0xcGupH7DguAwN+w7axJBbLA2eeLQ
	xCCPIoz31BkpmBt9DumWLWMMyYjm+YPHAFILFnhnvjybwS+iXGEA4WGTjnKhVvEaqcf6rgsGVXx
	fvcTb0yQaxrXcmfuh4MZAgU7HKMLp8IRJxN39mzW4Lrwy02rbEUEeHpSjW/tG3hQUO9qA4+aBjW
	ozrS7XIIibcr5YJMXu1aOXsg==
X-Received: by 2002:a17:903:3d0c:b0:2a0:b432:4a6 with SMTP id d9443c01a7336-2a951948829mr31867515ad.15.1770382277711;
        Fri, 06 Feb 2026 04:51:17 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521e3ed9sm25107245ad.69.2026.02.06.04.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 04:51:17 -0800 (PST)
Message-ID: <41415e6d-a749-4ccf-81a2-a4475357dbbd@gmail.com>
Date: Fri, 6 Feb 2026 18:21:12 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v4 1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in
 xfs_rtcopy_summary()
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <4b37c139595fdb9af280496f599f6bb43ae5a9b3.1770133949.git.nirjhar.roy.lists@gmail.com>
 <aYXi9okzfGzkYK_m@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aYXi9okzfGzkYK_m@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/6/26 18:18, Carlos Maiolino wrote:
> On Wed, Feb 04, 2026 at 08:36:26PM +0530, Nirjhar Roy (IBM) wrote:
>> Replace ASSERT(sum > 0) with an XFS_IS_CORRUPT() and place it just
>> after the call to xfs_rtget_summary() so that we don't end up using
>> an illegal value of sum.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Looks good to me know. Thanks for addressing the ugly ASSERT :)
>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thank you.

--NR

>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index a12ffed12391..3035e4a7e817 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -112,6 +112,10 @@ xfs_rtcopy_summary(
>>   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>>   			if (error)
>>   				goto out;
>> +			if (XFS_IS_CORRUPT(oargs->mp, sum < 0)) {
>> +				error = -EFSCORRUPTED;
>> +				goto out;
>> +			}
>>   			if (sum == 0)
>>   				continue;
>>   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
>> @@ -120,7 +124,6 @@ xfs_rtcopy_summary(
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
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

