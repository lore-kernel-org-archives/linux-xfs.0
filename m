Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C9263F4A
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 18:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770316413; cv=none; b=a6hVAA9Mcisr8tde1Bsr5QLWP5PALpEtF4ZoLOIH6CBAla4JDfHd1eXMC+ruwcsQDtFwRUcId8VNwQrnwGNhyv2Fg2IMU32EsYBpzaRoqp2n9fYrP+v5+xHP3pSfWgH78HXmTydfEY66s9QwBa2OK56Lvk3kUPHgQWlC/WQBwVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770316413; c=relaxed/simple;
	bh=krmct5/2gB9NC8+4Y8cZ2odnH/AaG1DYcSrZCesyMrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsTrQ5JgdsHFsQd1/EV/zq5r4knwEiWua8Gzhxqpi5qfijhlySnMxW/pZ4QYA0UqnwiK0Ma9bDmNjW0+vhqHan484CieZ4IU1v3xk9v7EM8UcGXwXN6zsgiFVFGuAeo+E51x07mPn9ok+jKNZKVuvdtfbX4fVvZT5Lag8/CroXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/Ss8iPL; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/Ss8iPL"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so709260b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 10:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770316412; x=1770921212; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fBDlyxKzWWXckCw7HRsZ1rb9+yJ1upJlMZa3IDCU5FA=;
        b=b/Ss8iPLSf67WIk6g7uDPsvCZ+5AT07JVeQMDLNivSIEJoLvnPRH9C2Nh47quQuC52
         TI2che0UYr6KgqJgDDdAB3ga/ZH51s7GfhAw1dzDObAAQ30YbLo5vVWuFbPGcuDp82vt
         fnCwR9heW9KDSiCgQKH/gflbn/VbQB3zTWbzt0ruajV0nRtPPQv8mJFbui9onOp3Ojz7
         KdA5u/JOPyqBbXjGv7gxZXfnSkrhYaOkvoQugnDlSh1kAN/BGAh1055NupWQU+DZNGjj
         nzzj1dISFHOdu5XhHi223PzTFZBcdX6iulo6nNDdiZXPCxxdadGtwUkJusk1gSQRX5dy
         F7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770316412; x=1770921212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fBDlyxKzWWXckCw7HRsZ1rb9+yJ1upJlMZa3IDCU5FA=;
        b=RMwGEHBsgRDMQ6S+UkhEuG90ePkvxXVsQVLbfYdFZE381OBtxiHNK3QZivopMNufdc
         sZ2pl1OFjvyHuxD5Emb1EleBgAVaTYG+N73GaTeDLnDeIYwzjwvPsGS2HThkF1F1v8xd
         ObdUJqM5TcO8huaRfyII1cT2CugP3arlmPCXdCzEspuPJpl3cxMxHKP0m7sqWo/wxaoU
         z1a0xg6dD+Do9FVQzEzLLcXoi9rZj1gARg5XX0+jFFysSbvcodVh2O3pqvXE5U6O6ccv
         Q1bQ2uApXanxI2HzBfpD8TgLuBcRmoMelziswCZPDCx7OJ1NmkEiUXuK4kf4UpJppTkB
         2iKA==
X-Forwarded-Encrypted: i=1; AJvYcCWvveNRXhRZDrxmUdC30Ij6nV/DS2CRyO9ZJzjRR2Ynx1Xl7fQXzda0/M48UEbg4F90uCa3Ugv3Iac=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIII9Kie0nOHnNaSKQplFzREMjgv6AK0VontrP5RrkDCbWs4mX
	8DX7tScH+PdTntMaX5ViSL6aUI314eoXIZbYDQ5zjIm3uW8A8znXtuJxQjY5u+6R9vI=
X-Gm-Gg: AZuq6aJSc+7nqB8b9+FBYvgzP4i+rcY4QPsZbz5PtcSy3h8c0tOS17GySPxv8LGGQna
	bRPtt5CJljOXWaUIjk7Bo8kYP2bchEcMI+tGLnyUAEVav4nw0LtHwqdMWxlBWi53Bzs4DS5tDz3
	ihUxDIOYvxhMfQ+WcGfIqBGW17FEuM4QD8KQ3cQy9FbLQKCk1Ye4zfDl7+TThDJ2uhtScc2dzo0
	17M+fTvd1ziTTfQHk04Zh9CM2oK6ji6gSQY8urZApliZMui0dDgSsE7W1sIPJiOjLDScvOjrEYF
	40ZAK3N+4y/EPRQBbfPW06QClLRrTi71D6DAWkwOoiyRjVSuCPeTGtCA4yipqn7vYH1ouPMQ83g
	1Kw/YOmIrwdM1FLzVzKnw7fRsscEzDOOjSH00MNJbxRnH7P7eZAQlGB5TgtTj/ntqO/MsecKDNa
	8+K6iTUPQBm0IMkdIxaknQGg==
X-Received: by 2002:a17:90b:1c04:b0:353:2e1:95f2 with SMTP id 98e67ed59e1d1-354870db415mr6134416a91.8.1770316412108;
        Thu, 05 Feb 2026 10:33:32 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c09ff2fsm3215851a91.2.2026.02.05.10.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:33:31 -0800 (PST)
Message-ID: <e2fb579c-d7cf-4075-9cc1-41cfa9bfb689@gmail.com>
Date: Fri, 6 Feb 2026 00:03:11 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v4 1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in
 xfs_rtcopy_summary()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <4b37c139595fdb9af280496f599f6bb43ae5a9b3.1770133949.git.nirjhar.roy.lists@gmail.com>
 <20260205162100.GO7712@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260205162100.GO7712@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/5/26 21:51, Darrick J. Wong wrote:
> On Wed, Feb 04, 2026 at 08:36:26PM +0530, Nirjhar Roy (IBM) wrote:
>> Replace ASSERT(sum > 0) with an XFS_IS_CORRUPT() and place it just
>> after the call to xfs_rtget_summary() so that we don't end up using
>> an illegal value of sum.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Looks good to me now, thanks for your persistence!
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you for your review comments.

--NR

>
> --D
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
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

