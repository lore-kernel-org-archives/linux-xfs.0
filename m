Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78A43596FC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 10:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765968557; cv=none; b=YeJHke6gRvmu+ab4C1aya0LHW0JP9ly2HAMq7TqUdtzWcNpk74k4JbaLcgIZdQvFbz5NAsBYzLK8elURfxw+Jvba4OxJfqpQPvSxKW8WXF2q7RVdww8mnRRf3Pafaymw5r40iBbYjdRJw8sgz1hn06L+BDkzt9uNP+74DSRuxog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765968557; c=relaxed/simple;
	bh=TJsmgrNKCp3mOAfDQSATdQkVVrKng36NCfwYBU5/fQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+eJe6rtrjRaDsc/Jcy2Jp8DXwOzOSPp0yW+l8KVgt4rJXl2FBc/SE0D6LbD/UmOasAPdzY0ADthTWDhywHwiwMzRNEbA8z9VjzdacAsusI1YmH90ixlB/OFKZGu8t899l8Nc+NlOIZlJRaVDFxf/jU5eMrq7avjZ9//JL7DA7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWn0BG5P; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWn0BG5P"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0c09bb78cso3327865ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 02:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765968555; x=1766573355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vLqnSS6gtLB3nL6UnV05h1/DvCy9WcKXVda4tImQ7Xs=;
        b=MWn0BG5POJ/j+R+r7Dea/j+wH+9A2X3xy+tuRmTBxjgBhZeEKCvc+cAAS0SbZX7wTz
         R15a3z7Gv0uS0UF2WxUTBoWe13AVbdIiYOWMiu0JSGMBzht0IHIZxEL8pvKvQxCj2QGJ
         0F5oXB5AXspPCCQTV2uEwoC8eRXcHkpEopEXH4Dcss81voRoY2MqubKKeYaFS3hpqR7B
         /L/q3I8eqZLthEekwXRIjuXHiV2WM/XF5gcdzAZ5AmHTJELmoT9nsqa6h/i/yr0gHsj/
         K4aNPeVm31ln7DJZD8wenDLXDax/fGYbxYBy85TBmCuLkuvA/ODMBx7wDD3J7GZEXSJa
         XW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765968555; x=1766573355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vLqnSS6gtLB3nL6UnV05h1/DvCy9WcKXVda4tImQ7Xs=;
        b=njSZKr0orYiZBhoYFEJ+dn1HWLz9pQpxLUv3SxCFe4Z39j9jbK7i1/3X9BiLBaR7Vq
         Fyz/aXyptL/19YNSfxlEq6jdgnRHSWXYX7fWgBBHWPmg5xB/InbqlL9YiMyJaz9Sy8fH
         lkzxvU2rLnzzSgKpvRQczdXUDis20tmuK4dYZ1T7XBXtsCqk5WNRSLU+59IGXGfomQ/n
         M9GaHfGYN7aMS/EJ3wcfyg8WIe6nAp+oqTd7guQN4hk7H/GqQbcUUkID/b0ybQpPZUwt
         gJkGY1QvDvQ2+0/7BendIzjUqvQixGeyN5Znzl2riHoMys/aZHA/VjmpfISTGK5SbmPD
         EMXg==
X-Gm-Message-State: AOJu0Ywnu0QwfYc0LEGVDZ3bMDFrywQJSDfllO3/SkFU5n5NIeQFY2Vw
	+2UIv+dwC2G81sV9zDXFQcaOOHfXRGwJrTPteSvtI6hoc9ZHGViohDV3
X-Gm-Gg: AY/fxX6JF2T9xNYBXy741xyLcUPFMzCOQMmHwVU8q70+qB6whVgjgWVxlKTpRqwFaLz
	5asHpTxZEhZi/l/gwSSDNniuN3giVdy1yPwwEut8Isk7tKC26SJkZMeMXoIKxwWJLZMY5znI/ek
	n1KC2/IQy7ExVE4pGZ7pe82ZKUuvyDc+pyvym8ibNFM4TbPY0qw4L00uM5Vj7vRIPC25j0zb7Ex
	Rx4u3teby6WR+/uU69HS34hQpxyoRqtosrSGSRSQIHSPD7RPBxq946LhT7HcinFPmUCXFn7saBu
	KM32SHaYpNBH7mAFg1QeTo6fq57L8O08QFRm60wau5R+VDiRv+ibGtClKb7Au1XFDg8/3OvHlla
	afqn6uwqDhAQZagrU90MkMfcK0st3dhh+UUAS542zYYyxSV/pNd9+PyxauyPhxAtAtd6yrTr959
	B86jy1bMVXAOGJeLGPdga6fl8oIbefMNs8
X-Google-Smtp-Source: AGHT+IEo7PYVcwyr+PwZYdWLkyvB1XQ/83TJfMGa5mNmB04X2YQ4PElCABT8jeq6uAlV7LpDCk6bRw==
X-Received: by 2002:a17:903:3804:b0:29e:e642:95dc with SMTP id d9443c01a7336-29eeea041bamr219846535ad.12.1765968555009;
        Wed, 17 Dec 2025 02:49:15 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a08cae24d4sm137186665ad.15.2025.12.17.02.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 02:49:14 -0800 (PST)
Message-ID: <95693000-79b9-4c9f-a304-e4a18bd3a880@gmail.com>
Date: Wed, 17 Dec 2025 16:19:10 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix the return value of xfs_rtcopy_summary()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org
References: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>
 <aUKFFyGAOEIclGTs@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aUKFFyGAOEIclGTs@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/17/25 15:55, Christoph Hellwig wrote:
> On Wed, Dec 17, 2025 at 11:07:42AM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtcopy_summary() should return the appropriate error code
>> instead of always returning 0. The caller of this function which is
>> xfs_growfs_rt_bmblock() is already handling the error.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Fixes tag?

Fixes e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")

I will send a v2 with the fixes tag and Darrick's RB. Thank you for 
pointing this out.

--NR


>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

