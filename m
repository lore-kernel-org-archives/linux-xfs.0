Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039035FF42
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765989516; cv=none; b=njZP3/GqC9aZotFVx9myyTuRAv/GXDKibi+hyZ9yZeVpZFcUPRjV5xUs2xP9AXEJsy4cixGmSGCiZjY0dEg3fEKSi5TxmHb/x8QEeaWIrRBSWHEaDdShU0eL2EanBQ9IPpX0waiWlhNXfl0wzOtc4Q9TtwJMMoCmGT7058wV724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765989516; c=relaxed/simple;
	bh=bAGn9stXp03ogyDf0Yrd1R2EtqbejrgfwJTS4VFpZqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pmwAm/6A4P4maGet28Pn5h5Ttu3u9ejbXixdY8+atVxxUtfu9+E0pK4y3GAV+05iYhVBg3XeWHyjjuJUFyfGvnjN7KGzoLmDQOAq/GnDHXNsTZEaut+N8cLnSD6lOh6UG+SFM6aRrq+G78x2GqQYUxdlaCYv7sVRGjreSn7D7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xf1ArI1O; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf1ArI1O"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c868b197eso3902761a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 08:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765989514; x=1766594314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9pgAKWtzfD88hXZUfcb6AsO1tl7aNQtWTX/IEkwASSo=;
        b=Xf1ArI1OR2M4Ap//9SVoRQE2bMgoDkqSr254hIiZkiFdHKkbhRF8dNmSg7edhyb2a4
         H8Wyqjb/XIa6wSjQpbTvMjDcaKORAzRwMGg+lHDnpCAVckYcHQkB+f1BuySAEv/61OAV
         ey4kdKIMzPUly9PqO8cloGqUXuBKKyLbsnVCakHsgyD+XThrcuyBDwbqMcO4NsejaCjt
         6225uuOklJYMILr6rkuP1Q6hmkCkCqMWCF8kkkwatw4a3hlsweaqG861xee9Tpfp3po0
         zIJzge1LhYOlh9XRtozuJcOrBGaZF46jBXz0Etel+U4I/9oag+ngvfr60VR5bJpSzKaY
         AGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765989514; x=1766594314;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pgAKWtzfD88hXZUfcb6AsO1tl7aNQtWTX/IEkwASSo=;
        b=GxyvFPdw4XyOUgUH365dFDUOwqrNdegrU8LYIL/RwjYLHAwmHf9bH0iWNOi1ph+O+j
         osYSEqJgVViMKkK6ZUw81t06yjXdqsdqL+rWGEZlWYXYhiZ7sxYy68OHXhm3/VM9+Ded
         REhGJtokzG+i+Thfg9o7cosFoT7YesYeu82LqlMFjjuwR73/SqlMTyaasAYIdiMPT/f+
         3tNXx+A/lao74xNpzO1R7xzrXTcShW4OKeD0N8X/FLnBjIVD6KOVw6D1I2lPIRzMtw1s
         XdOVkTjVsk7YOU9JdA5zoEF9ySeJ20WrDivXyJ0v0JuhLy0nx1pnSo69WWKhlXShH84k
         endw==
X-Gm-Message-State: AOJu0Yyz3m+5KFd4gu400tmgNCyo5O8WBsG6IBNjAZ0let8/lCyO2x9a
	6Sv0/AdAvcQVwPBhW2POraWIdcZpWndCjYcaALfe+8yo8XPEairKG7e/
X-Gm-Gg: AY/fxX4Dys6Z6uE65gA7XkPipdseyKpoeaWmzTS9YPVMWOCe/mK8NPOuzUkpphSD7oG
	PbvYmc4lUc58QABrGViZ/JMthZrLsdZWUmbW0H+D/cNboRF+TtZ9fdPUKWmRLmwI8k7DHreAku7
	vijpcZC1Yzk7VBRmOHdzAJiW+9LK+dB62dd7CSc4/oHG66cyxpCwB2177/uWoAHUCm4+EtBXMqp
	yDIlS6UB4ZeJ7eG80zARNbAyYxKWfIcgVtW7mv3WC5CMKaBpT69pK4hc83Igv0LAsZMQvO/hg0w
	JgkOSfvldyQzlcYTq9VjX86hYEuO5FCfJMppG8U6/QfPYk7meiwrHrjKrC4LoSt0vnQ8+KBLC/9
	3bY9B4PhH2pZm4p2NztE4U8ujKJY848Hh5fB386VNDTZz1R9NhnT18reqKugA/W8hDEbV5VlXRp
	5LUfRdCOecESVn0/FG3R5N/w==
X-Google-Smtp-Source: AGHT+IH44Gk3BCfsa/Z2Fihw1ezs+qjFgjaShglmldiGUnYVrXtkjYdPcVhdw4et4LH4JBqsjiPl4Q==
X-Received: by 2002:a17:90b:35c5:b0:34c:2db6:57d6 with SMTP id 98e67ed59e1d1-34c2db65c15mr14832292a91.19.1765989514457;
        Wed, 17 Dec 2025 08:38:34 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70ddf58dsm70795a91.17.2025.12.17.08.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 08:38:34 -0800 (PST)
Message-ID: <aeae0024-e0da-4489-aeb9-ea95d02cbf9b@gmail.com>
Date: Wed, 17 Dec 2025 22:08:30 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: Fix the return value of xfs_rtcopy_summary()
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org
References: <c6b04ec9ae584af62317d4c1bcf3f84dfab74be0.1765982438.git.nirjhar.roy.lists@gmail.com>
 <20251217162758.GV7725@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251217162758.GV7725@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/17/25 21:57, Darrick J. Wong wrote:
> On Wed, Dec 17, 2025 at 08:11:33PM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtcopy_summary() should return the appropriate error code
>> instead of always returning 0. The caller of this function which is
>> xfs_growfs_rt_bmblock() is already handling the error.
>>
> Please add
> Cc: <stable@vger.kernel.org> # v6.7
>
> so this can be autobackported

Okay, thank you. Resent it with the Cc tag.

--NR

>
> --D
>
>> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index 6907e871fa15..bc88b965e909 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -126,7 +126,7 @@ xfs_rtcopy_summary(
>>   	error = 0;
>>   out:
>>   	xfs_rtbuf_cache_relse(oargs);
>> -	return 0;
>> +	return error;
>>   }
>>   /*
>>    * Mark an extent specified by start and len allocated.
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

