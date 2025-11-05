Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C824E4C4
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 07:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762329418; cv=none; b=R670LHrsWTS2N3C7f8DOcXic9RViT56/pLb8NcEwBd1lyGJFTUfY2wThuC6BDGWgOK4jjt2etN0vYAB0kEd+Iw71yxYALtvhYPx97jmD25tMVYoWtjlGTVdTQFXd9fNjNX4v7v442Of3Q12ZweT4pzn6t1EUauSZrdsAtWJwIXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762329418; c=relaxed/simple;
	bh=M6zEEz2Dj6r43CBJP0p4D1cCbWj+py5YfT8Eltbr2Bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IAuS0IsfFIZpfIX9FRAG4AOE+mA2eQrjP4BpT6DbGQ9eWVwe4j++3wd/x9b+jvC5apsR/xIhR2YMSISPbJyOX28gjJJrWoNuU7RYRTN7bFnKpRAVJNr7Tn6Z1gT39O+w6SDh3gwdf/USMLDu4wOIglQ+viqFVU3GeRAlK6PkPvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVQPSQMJ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVQPSQMJ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d3540a43fso64567575ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 23:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762329416; x=1762934216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dY/Ga3EWz8X7JBZT/JqFOQYYM/u7PzuYg2OmKTY584I=;
        b=XVQPSQMJLgYqA+kKW3++iGRzbnEOCkORqWAWk1jhQM2xznNzdYJae1KiEHBmnZeeb9
         bV/0kntZHT0kgtKLkFEngN0/UVejyGxwzcuIClm620i9B69qEsJs3rv520jJf/ZWqAhT
         bATjROIMiKZJlaRZAtq4pNVrMyytOloASnD18962XuBTAVerfaHoFlOzJEyPK1t2JctE
         RKgIO3VwuXOUFbg48yER5/De1bGV1PC3ab7V/GAs2QnVNnVA1cy/QxQkCXonaClt3neW
         +jsSqw2QYrmp6uepd8RAlESvsw3ql0UOs3ODGRU02sJQczbb1G4MCOTTAdcQs6xWdBOx
         AxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762329416; x=1762934216;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dY/Ga3EWz8X7JBZT/JqFOQYYM/u7PzuYg2OmKTY584I=;
        b=WnGRdDRXqCP3WDgvlGg/WLcfDNEN6OHMNJbdc+iSirB5jZarzak34fdcVYPfZhPvGw
         tZQ+ucBkH65UaOGxYDWrxEKiBmymzH5Rn52ZSO2zjrYg3zQlth0Ua/7M1rTZmjhfwaAR
         iUWSx0/uETMl7ZKJi0lBhPA8sN7VQj/XhHKbznJiEKGOvSptg16pCwXmC20YLtPfwwvy
         sddK88wxsW1qu3OD2nZolln2DLMyi8ke1YxBr5WY/Vb4jB29pJ6qE3Upwyhs1PlQZv1q
         Oo1p9S41gUgzj7F385bS36Bs3RU/2UuqiO3i4R5Wed4/zR5NPsFqeOCLQxy7oLULYoH8
         EJZA==
X-Gm-Message-State: AOJu0YwvPpRuesAenCRl3KCckwut2YDrJJa9u0Uzt2cpPOVALAUVuxHI
	aTmJjPzq3eHlvICKoIHz35xWngFpq3/N7LJr0uMuKqrwXTIcgcBsq9Dp
X-Gm-Gg: ASbGncsF13Qh19tyRK0q1a80VQ8MglNxhN5fbUY4xavhU6mI9B3/x/UcMzO6So5KXek
	Z/oxCHi0vG1ieCQRtOggW0fhD3AzVlmai6dZ6fnRNlAaXEqxRtTx75TKmmJd6MCCLiPMUGLxjHt
	Z1Y9pm0r3qXbFS26dvpR/OpxQJGMs9avxwkgq8X0iqU6pOw5j0aTwkTX7i0BVcudpV36/iqulux
	tlO/UgfU+OYcB/1DwkHuO18liDfqTJTxS23Y1c5nv9HD7Z/axwni1LlMFSt9+MiYw7Kz4q95Gff
	el/F8iIaDeu8Z/L4AA6PVhe2MZKGSbeoJEiOdke+JB5Ab9wg+3hCq1jfwb1Cw89d4rsAolG8LHg
	cJQ/psLbAikDOZU9EJbaGlcBdVwpYiLLsi6lEYA+0tusDoMsFavzBQY3tiNC+Y5uSMQI/LvofKP
	tiZ19XUyPN
X-Google-Smtp-Source: AGHT+IEMwrIpaMwYgqgC8EIcAOphKQn/3pOUOYYZiyNwx1HjbyJYLabywZp5+jVJQGvE0+euDZMDPQ==
X-Received: by 2002:a17:902:d586:b0:295:5805:b380 with SMTP id d9443c01a7336-2962adcfe00mr34871015ad.49.1762329416096;
        Tue, 04 Nov 2025 23:56:56 -0800 (PST)
Received: from [192.168.0.120] ([49.207.234.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2960e892c4csm42432335ad.13.2025.11.04.23.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 23:56:55 -0800 (PST)
Message-ID: <24f9b4c3-1210-4fb2-a400-ffaa30bafddb@gmail.com>
Date: Wed, 5 Nov 2025 13:26:50 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org> <20251022160532.GM3356773@frogsfrogsfrogs>
 <aPnMk_2YNHLJU5wm@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aPnMk_2YNHLJU5wm@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/23/25 12:04, Christoph Hellwig wrote:
> On Wed, Oct 22, 2025 at 09:05:32AM -0700, Darrick J. Wong wrote:
>>> I'm still missing what the overall plan is here.  For "normal" XFS
>>> setups you'll always have inodes that we can't migrate.  Do you plan
>>> to use this with inode32 only?
>> ...or resurrect xfs_reno?
> That only brings up some vague memories.  But anything in userspace
> would not be transactional safe anyway.
>
>> Data/attr extent migration might not be too hard if we can repurpose
>> xfs_zonegc for relocations.
> The zonegc code is very heavily dependent on not having to deal with
> freespace fragmentation for writes, so I don't think the code is
> directly reusable.  But the overall idea applies, yes.
>
>> I think moving inodes is going to be very
>> very difficult because there's no way to atomically update all the
>> parents.
>>
>> (Not to mention whatever happens when the inumber abruptly changes)
> Yes.  That's my big issues with all the shrink plans, what are we
> going to do about inodes?
Hi Christoph and Darrick,

Sorry for the delayed response. So, my initial plan was to get the the 
shrink work only for empty AGs for now (since we already have the last 
AG partial shrink merged). Do you think this will be helpful for users? 
Regarding the data/inode movement, can you please give me some 
ideas/pointers as to how can we move the inodes. I can in parallel start 
exploring those areas and work incrementally.

--NR

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

