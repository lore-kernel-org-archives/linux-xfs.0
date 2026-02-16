Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B7527F00A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260234; cv=none; b=hbbKrD7RxFIWv2/+GPdkax4BRijjcoFg/s5/eYrFGCoXodLRtpzegJFBiVT4OagMUc5pBwsFm41wm9Us7MZG0bPDnLwkxIWORdA8FpiXB0gA0fJ199uVST+/3OMUF/7+dOjPvrySOM76WL7bq/2AsAs8gCAHqPkplx5Cy4lK6Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260234; c=relaxed/simple;
	bh=T4hRVsr6j2G/z0y4e2KIZzQM7ZwKSRV+FzQIIIT2T/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nc0i47jH5MEL6P+2dY1V7XIjI72EYmVdVNZPlgaRZHVKVva46tqVgFTlyh8FYIj7yw0XEZXkP6XTjvj8A4lgZ8pfw0Ty1kuKl8eCfJ9a0Uv305iitwHrva2CzXNngyNn6BxgANxwVo+UwP6xTZx+VfRziLVo7Z0KRXJ2BNX45wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CC5Esb2x; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CC5Esb2x"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a963f49234so12783965ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Feb 2026 08:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260233; x=1771865033; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pxy++dyREXcmhPzatwihaWgjmu0oTKlUJO9o6d7hHLw=;
        b=CC5Esb2xAil3rA7J6L1RZ3lqQ/eSYm7j7u5QHntBTW5e2q1I5rKuUhP2u+PmFvOES8
         CC7XnSfAqmVh1hn9RIN/K9PsfxmLhClLf1GxQm6TQ87DJyj2sQSWoPd8tmcHzQpbZJnT
         4mYPbcrDKqApgeVUU8zCt8raFhd7unXxQaIAQDiDGkaVkXVYsJqZETol2A6slqK0/cdv
         ZDkFexSa0zo7Afg/vSh2U7Xa5yJxhzm84JIsFjijSSYx6+GgROs3m956NIioZwfrSBuW
         +TbAmT3TuA6unGEU93jkAntH74Rh95+UpUB66rlVJ0W8hXZsvdSlJqoJMA//wFjEvkwC
         7efA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260233; x=1771865033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pxy++dyREXcmhPzatwihaWgjmu0oTKlUJO9o6d7hHLw=;
        b=DJBFYVOmSg7qanGMpfTuSUKrx4UeJLo7kE/+2wmBtrnPslvN13EDA9a6tdzIQtXD4L
         dQyU8NOimYwhperUty7k3JKkx98vB6yTMPSw5kCon1Z9t789HeWIhS3BjOnrIiA+1iyb
         /c2b7hoylvSEyNU8xWBCUTwtIosBmcWzk73n7jF6QSykYylgdrVkGk4Mhg7O8jCMrB3F
         Pmz3IMXsufstKyRyZjypoA9socVcIkR6iIJMn0QOMOB5t6lNJPPxzphnD/BmvGxvY4Ap
         3Q+7BakYFHCiNOGfSq2i1/LF7ZwPYZpI401DJrJ///5rjX3gl0JmYTjawwS8gQ6VqttW
         X0wA==
X-Gm-Message-State: AOJu0YwhVWWtYfNn4rZggufgvqZuRQlGIdvkp7MJXnkzpteWGZjgfMPN
	UFPLjRiWt2U68OlAoEDJVIV86/UppRyK9dp5LEA5xLIX9KQpinxtK6qZ
X-Gm-Gg: AZuq6aI1wXTCXRm8CsW5tu72vcu8cA4429dMUwGEmsqp2TyKB4xop2t8eYgV0gibKln
	UyVxpDWIIkAQDwi5rKWZNiG27kWXEuoUimcd5tr7PliMGQFnJmhLCBeq1ArTSaTsQK79T0H0XJE
	F6mvCOmMooRNyMki7YKcA7m5As996gUjWe4+KB11NUDB3+XwAtdEFARvp59rjjR7gOsmj8ZDLHl
	o0Mmr8fY9fHjAwjsy6SnkebtxJ7bIRY+thZv8Nf5d2to0caxa4nLD5fPzPG0tR6rNmV+IWhBaLb
	DqSk6mgafzz41X8kOTkluuJ17BZwhLtxBSGFUPz4CEnDsV7ioDhm20ZToyvFxDf7PeTXCwD+6a4
	bym/LOHnDWFev0zUCwLGnd+k/hdTMO4f51n7V1drLM+XavE46PkNM+tSc+CaDiL2WdWdALQNH+d
	eKbQ/l4McPSDRIKJoiutLLcS7Z78GlUSmf18Ulug==
X-Received: by 2002:a17:903:2f8f:b0:29f:2b8a:d3d with SMTP id d9443c01a7336-2ab50525225mr105427105ad.4.1771260232661;
        Mon, 16 Feb 2026 08:43:52 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d5bbcsm75264985ad.56.2026.02.16.08.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 08:43:52 -0800 (PST)
Message-ID: <37035b08-0cb5-451d-aaba-dafc008b6ae5@gmail.com>
Date: Mon, 16 Feb 2026 22:13:47 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v4 0/2] Misc fixes in XFS realtime
To: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org, hch@infradead.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <177126014478.263147.12010029044009202804.b4-ty@kernel.org>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <177126014478.263147.12010029044009202804.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/16/26 22:12, Carlos Maiolino wrote:
> On Wed, 04 Feb 2026 20:36:25 +0530, Nirjhar Roy (IBM) wrote:
>> This patchset has 2 fixes in some XFS realtime code. Details are
>> in the commit messages.
>>
>> [v3] -> v4
>>
>> 1.Patch 1/2 -> Replaced the ASSERT with an XFS_IS_CORRUPT
>> 2.Patch 2/2 -> Removed an extra line between tags

Thank you.

--NR

>>
>> [...]
> Applied to for-next, thanks!
>
> [1/2] xfs: Replace ASSERT with XFS_IS_CORRUPT in xfs_rtcopy_summary()
>        commit: ce95c72c7f95b820ca124e4a2b0d2b84224d6971
> [2/2] xfs: Fix in xfs_rtalloc_query_range()
>        commit: 60cb35d383aa5d185685e301e27346b51bf48026
>
> Best regards,

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

