Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3B22253B5
	for <linux-xfs@vger.kernel.org>; Mon,  2 Jun 2025 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748887478; cv=none; b=hvEqS+jUnXsBxPfk0kwXpF1dR5pSV9OkVxebQAlkntQBlfc5Lxbz4GWiTCx/xGsq7f9JNVW9mweur/JhbylMkaRM919UKM1Wr75he1E6RPNdGQTgf7O/Rf3Gz5JXZp1iZXlwVjsHHaq5hXSTzsAzAjgEO8XXFr7T6PK26uVRYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748887478; c=relaxed/simple;
	bh=3CJjS80Cg63APHzqm3TcB3seDIDNnG48N+eGu9+Azyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sm/VZ5/NoXWUE01aHPAMfZVZHHlKXp8/0IV5VgaLNQ+eEr8+6vU/GrmvOxqcmqIIz9zUcND2th3pxENpH9juTB4UsiO7fZPPNGKw83eD1jeSZtfFARRBQ0Ih4s8vDpYQh/ZVHAsOfKh+d6vNAwK8zjaCdnVTQOV8gJROII6NKOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NHUO0B06; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NHUO0B06"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-872886ed65aso108619739f.1
        for <linux-xfs@vger.kernel.org>; Mon, 02 Jun 2025 11:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748887474; x=1749492274; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKwd89/t66lNmck+SxyQUCtkTRq8WXDQ7GkPW/MfPpo=;
        b=NHUO0B06QsHZrSTaWdqLCRWs5cVK9iohquTAQTiJsyCsOqwp6ZAmy0OlbVRzS0I3OG
         oQYL6KVBuDz5D4lC2HsbK0OL1zv4QEMOAzTq9MMNYYbD3NvlL/a10KiGpLS//WDYBaz4
         hrucwjs7MSFqNCW+li55iVF85WIl9GNHj3NLIICA9KWE8WnmjeZqjZsJDzKcKtbqlYJZ
         viyDlE1KM8tGjMrWlb/+Dd9NY/w0QMxhV4BcjSVhzClk1CUYmDrKgn88acKnO2DnW02J
         c8IZ2bnQXoSdJjHV0cGLKbiAYGYvk/NK+Fz+x1HmCfGq1P3XeL/Sf7+UqgXKSpABFhat
         LQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748887474; x=1749492274;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VKwd89/t66lNmck+SxyQUCtkTRq8WXDQ7GkPW/MfPpo=;
        b=ndY/7p45tgJ1K9XHMnS4WA82KvEHfKP/1JrLwSHFy0PIVdXw6HBMBG/FTZQChUhshd
         7jVUVgBVa4x4Zl2L5zMWy1QQ7TfOCd5AQn934yo6WAfgHYxhOMY9QOZuVqxsz2uJ3/P8
         FFSq0ZC6yRE9dF9TNw875Z2aeDZqVBEVMYaLaeDkZu8n1DOVyb70rrc3xryyHq0JaJ+c
         FHQGPgQ7XuspyZ2MfdPh5BJHV2PqVkmFnQNOQiLy3K8tPL58EVU6iKlkA5g5lXGPVdjh
         XB66fzKyY+ToNLlnB/5XIvyv5EsU3zvCTiGZS7+voK6Jvi0gVpTMPF55jG0oVAUjjVMf
         hF6g==
X-Gm-Message-State: AOJu0YwOWRqJuDc3y3kH4j4dov8ArSeZ9gZ2aGAtj6xfib1yMq9NQlet
	+l52i4sD+0FyGqJQd643H7sRCf44Sy7IGqBjFgGx2HY+peuUKkmIk0m5K2yKVkJ2EXP9o3G+eGN
	9SA44
X-Gm-Gg: ASbGncsgj98tmy7xGpMHnB07Bkq5Q0PH/K+UZHK5XSr60nbt4aXq9oSTJ047Y1Ff21P
	kr2WBhdNSCJnNMT6YpGTGaeuYvSJJQcTybmTo4ySAMc/S1LJFUnfU0qKnbnH9DauOHLXy2ZTE81
	bv0RvYEdSqzGIkTVfrrSTYAt2Uvr/WUZDE3ZSgPa9oHyu2jDPJ1oBGvWXSKvTHp/k7kF9yY8jf8
	aXzx3AJ492sEZYXblD8IclIHKJ4qgnN926JZ/VHS2x5/mfcBEVGXSLGoq/7NV1P79DPJVVSkOmS
	4UT3MbKnhkQupJOJLXxKOgrPVxyvVnd/cKb32GGMlSal39g=
X-Google-Smtp-Source: AGHT+IFYMSUOV856qCdDvEMTrOFAhOd5lpP/DWo7HiyRLMyNi9rGf9ChHOfczI6T5irgbZ2/Kfx/aw==
X-Received: by 2002:a05:6602:4a02:b0:86c:f893:99da with SMTP id ca18e2360f4ac-86cfffdd29cmr1771440539f.0.1748887474505;
        Mon, 02 Jun 2025 11:04:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79524sm185274739f.13.2025.06.02.11.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 11:04:33 -0700 (PDT)
Message-ID: <1a2bea7a-71d0-44b4-a376-9f13c0e28381@kernel.dk>
Date: Mon, 2 Jun 2025 12:04:33 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: don't lose folio dropbehind state for overwrites
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
References: <a61432ad-fa05-4547-ab82-8d2f74d84038@kernel.dk>
 <878qma9guf.fsf@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <878qma9guf.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/2/25 11:46 AM, Ritesh Harjani (IBM) wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> DONTCACHE I/O must have the completion punted to a workqueue, just like
>> what is done for unwritten extents, as the completion needs task context
>> to perform the invalidation of the folio(s). However, if writeback is
>> started off filemap_fdatawrite_range() off generic_sync() and it's an
>> overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
>> don't look at the folio being added and no further state is passed down
>> to help it know that this is a dropbehind/DONTCACHE write.
>>
>> Check if the folio being added is marked as dropbehind, and set
>> IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
>> the decision making of completion context in xfs_submit_ioend().
>> Additionally include this ioend flag in the NOMERGE flags, to avoid
>> mixing it with unrelated IO.
>>
>> This fixes extra page cache being instantiated when the write performed
>> is an overwrite, rather than newly instantiated blocks.
>>
>> Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Found this one while testing the unrelated issue of invalidation being a
>> bit broken before 6.15 release. We need this to ensure that overwrites
>> also prune correctly, just like unwritten extents currently do.
> 
> I guess I did report this to you a while ago when I was adding support
> for uncahed buffered-io to xfs_io. But I never heard back from you :( 
> 
> https://lore.kernel.org/all/87h649trof.fsf@gmail.com/
> 
> No worries, good that we finally have this fixed.

Sorry not sure how I missed that, to be fair there were a lot of emails
in various threads on this topic back at that time. Not trying to make
excuses... Yes, at least the "would otherwise have been !task context"
issue is resolved.

-- 
Jens Axboe

