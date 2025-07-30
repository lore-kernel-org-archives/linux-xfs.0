Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8793F1482F2
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 06:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753856077; cv=none; b=ejWChoyw1tElZQTg6mil3U9J1oZ9GgZhzxm3v2M7IkM77X98U+WIHN7KMMoE0zb3D+XcZF2iqHY2dajbfJa1B9o5tp5LRKC+jL5ZyuxJHpL1QEIbRLzzMK4+JV8B736EJKmLaev3rDFttHix0I+y/ghy+rJ5CfdHDE/ZSxQYSvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753856077; c=relaxed/simple;
	bh=2WdkvECKlLfDpx+0Wk+qFCzEWgqY/wVHAHd9A1zr3Uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8l312qF5j1jZj5TcNkzyg0xlbzWH6m2+B724LEHY7BaiCtu3J+9jZzJTU2jrGpFz+jG9/YOobDGysZv9khGwxPUlO+QyDhM/QwIGIVeQcmhAnvkpaXJchxBYIHQsdpDX+4O/okHCzfDtRiDYZK0wOlb3n0DrcsxFGg/jbJtuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrGVWKtX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrGVWKtX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2402bbb4bf3so37655475ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 23:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753856076; x=1754460876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DQyNW3gWDVYC8dZvhng50mcU+bwxYkd7uWIhGDgQC/8=;
        b=jrGVWKtXi017hDj9ccJwxAl12549fSbkmxuvBw+KkEfQ6wtYUTECHC0dcgmSPqA3Vi
         zC2ruPWrujTeH4z2JGGuGsBBUI8hEqWB/xb820LJ06KLr7Kf9xc5n2WngcrIj3CR5fQo
         KeBhEjOPAdnmZjNrS10qKGXhnE5JfezqBAD099JNM7+NQ/+WAwUDNAwQu4EhRmAEbZD8
         my9QV8osEYGGloB1TylSja1WW0j1o1ioRc1v8kFjeDS9nfF4uDLcHWrfgUjihPe/ihVH
         sfZZtZczTQmNjKSkm4E7bSGr3X6h9XQACYg4bDXIwQolB+sa9oQp1b4UrQCQLG8XfK5h
         15jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753856076; x=1754460876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQyNW3gWDVYC8dZvhng50mcU+bwxYkd7uWIhGDgQC/8=;
        b=lgh/tmUXMjV01RR9l1QtBYSu2t0FFLATTMCc4F4XKjFGY/MFlNG+gm6zeiNUrthmb5
         XnZoKJ9w5EOIyoSll0f/PPe+fwv7nkLY4Osq0Zc9KncHDrFihfrRpmD8w5gbd6GEbJlB
         mP1c1hRYXBeDuJMLiUVSggd7YsYZxGO5QXQ3oBxgCOsaGwMHrNejnUGhsbJjL9gdZwLB
         TQgqCJUBi3VpSXLXsY8ce2dn2VxBpTw+W274YVY3Md8czS+5PVAI66VzuE5nE2HrajHT
         44Rtrw2EcDEXYqIwLiEM0m1Lu6VIgvv9APXPWGJgMBymHjWFgQmg0iJduk4wfSL8XDyB
         5Okg==
X-Gm-Message-State: AOJu0YxCB+/A4YV9ERXJByWT/hojLgseuMuhzcKtZygv3gl1zCwdp89b
	74wZUsL4vGdqkXxHrn0p1xkK1gb2z9ytrAqI3jesccEbeuS04TEpekMr
X-Gm-Gg: ASbGncvkr1QPChKUL8OtKRRllzM9d5Dmv2gvLlou5DvqOI/llFjEnjkzu5rROOrMX99
	myIsBnk8yXxu2snGfdWQFFrjaUHqba+NtdoOyl87EK3vICc0Ol6/NjaM7IfV/A+YqySsDR25bUT
	1XQ1UbtD0IW9F/vu+g17Z46VeHKyDAzW3HEE4zpDoVRdweAXlgoEwQAU9JjcbVfFgjlsqnJ4iT+
	NVtcWbEBW2WUGGPwrsGcXtfc09gt3730VdK2gfFgyvhL+CzfvgBgA1MChYpdauquvJFm2uIfUME
	fdW8iMZQTQfzj8WqR1Gj4oIMueWWN/q3PofnbEqLdSlGAdOV/pftOyPglaIYxDRHqnfMjpyL6t8
	AUWI1JtCqeuDPdyKGH1JdWxBci4cOQXCGYQ==
X-Google-Smtp-Source: AGHT+IFzMVGQXumowj5nsiFtdfFdkpMM51R96watHXFMbK23R/hiT6W4cOiH/A/WItP719mS+zB+nw==
X-Received: by 2002:a17:902:ef09:b0:240:79d5:8dc7 with SMTP id d9443c01a7336-24096baa585mr32337385ad.46.1753856075630;
        Tue, 29 Jul 2025 23:14:35 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.206.154])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8208sm981296a91.2.2025.07.29.23.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 23:14:35 -0700 (PDT)
Message-ID: <76efb6ae-0679-4fe1-9e89-05b19e19b26b@gmail.com>
Date: Wed, 30 Jul 2025 11:44:31 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/3] xfs: Re-introduce xg_active_wq field in struct
 xfs_group
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
 <70c065f02299e09b1569c3bc45ff493c9ac55fda.1752746805.git.nirjhar.roy.lists@gmail.com>
 <20250729202632.GF2672049@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20250729202632.GF2672049@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/30/25 01:56, Darrick J. Wong wrote:
> On Thu, Jul 17, 2025 at 04:00:43PM +0530, Nirjhar Roy (IBM) wrote:
>> pag_active_wq was removed in
>> commit 9943b4573290
>> 	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
>> because it was not waited upon. Re-introducing this in struct xfs_group.
>> This patch also replaces atomic_dec() in xfs_group_rele() with
>>
>> if (atomic_dec_and_test(&xg->xg_active_ref))
>> 	wake_up(&xg->xg_active_wq);
>>
>> The reason for this change is that the online shrink code will wait
>> for all the active references to come down to zero before actually
>> starting the shrink process (only if the number of blocks that
>> we are trying to remove is worth 1 or more AGs).
> ...and I guess this is the start of being able to remove live rtgroups
> too?
I haven't looked into the mechanisms for the rtgroups yet. I can take 
that up as my next work item once this patch series is done.
>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_group.c | 4 +++-
>>   fs/xfs/libxfs/xfs_group.h | 1 +
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
>> index e9d76bcdc820..1fe5319de338 100644
>> --- a/fs/xfs/libxfs/xfs_group.c
>> +++ b/fs/xfs/libxfs/xfs_group.c
>> @@ -147,7 +147,8 @@ xfs_group_rele(
>>   	struct xfs_group	*xg)
>>   {
>>   	trace_xfs_group_rele(xg, _RET_IP_);
>> -	atomic_dec(&xg->xg_active_ref);
>> +	if (atomic_dec_and_test(&xg->xg_active_ref))
>> +		wake_up(&xg->xg_active_wq);
>>   }
>>   
>>   void
>> @@ -198,6 +199,7 @@ xfs_group_insert(
>>   	xfs_defer_drain_init(&xg->xg_intents_drain);
>>   
>>   	/* Active ref owned by mount indicates group is online. */
>> +	init_waitqueue_head(&xg->xg_active_wq);
>>   	atomic_set(&xg->xg_active_ref, 1);
>>   
>>   	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
>> diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
>> index 4423932a2313..dbef389ef838 100644
>> --- a/fs/xfs/libxfs/xfs_group.h
>> +++ b/fs/xfs/libxfs/xfs_group.h
>> @@ -11,6 +11,7 @@ struct xfs_group {
>>   	enum xfs_group_type	xg_type;
>>   	atomic_t		xg_ref;		/* passive reference count */
>>   	atomic_t		xg_active_ref;	/* active reference count */
>> +	wait_queue_head_t xg_active_wq; /* woken active_ref falls to zero */
> Nit: tab between the     ^ variable and its type.
Noted.
>
> With that fixed,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Thank you.
>
> --D
>
>>   
>>   	/* Precalculated geometry info */
>>   	uint32_t		xg_block_count;	/* max usable gbno */
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

