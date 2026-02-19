Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78603128CF
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483617; cv=none; b=uu36LRKWWyxaQopL3iQg1kCYgAH+DBQ5E9sx1+Nv6ZFViSrzdjzSrBLeOGotKrqDMgkVRH87jaxh2MhelchHy1R5w1eQ42XhlsEjzMYOANgWkoF3yq1AwVqBLl2mYM8nqFtx3x4/AOMA6djaNZny/5KvYRKhdLvhVvIpKtAXPDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483617; c=relaxed/simple;
	bh=BrHYzycTAgtGegjOl0kQrp6CJLMznCCaHjnQtsVYnB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/Ax4ecvJphy0burY0Op3VpwjkEyaWhd/L29O4XTtQeHs0cEymdogZYXQBbuN8IWQDxLNmTdG+BgH+Pui8qPYfeCIUsy4eBzIqr8XckQ8+C3qcOfsxP70wlmoBvSLbh1A9KoDeoT090Lb0Fub30w1eTYk4S0pHOR5iy6nG3xdHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbDSlV6o; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbDSlV6o"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c6e191c4b8fso229267a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 22:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771483616; x=1772088416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFMm4Uve5iNDWgHzQLy0BaujSNhM5YbXbxmrVvwSgFM=;
        b=HbDSlV6oo9khOzPIqt/XYdQUPvQXjsioruEtpNbUKcJMLV/vOspK6sQzL9oFLcehjg
         y6iMH11tf+p2GK+TuXpCBjtAFhKSTAizs5leg5WnaVRorq4qAkgpdZFxT8ZNhAZ+oaE8
         KvGJHFC3TiB6TZrJLczxCyR2+pVayCKONi2ZW0BUUOx9pwgnYE30CBc16aGwwx/JP4u/
         6q4Qi+USVva7Y4kDwIG+6DEpTQm6Lza7XNkpL4eqPJGhU6gVnodBp/m18lY4lAQF2pr5
         iX/bPmuk7yKQvuiRaQcWrFc5zhVBnAfY8MAOXzKZEeyri96PdxJUJuGUKOO4NBOrDFHm
         V3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771483616; x=1772088416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tFMm4Uve5iNDWgHzQLy0BaujSNhM5YbXbxmrVvwSgFM=;
        b=Szh6UhOsboUyl50tUU63wI9Xxd/UHo1KdctVGxHIwASYZiNFt56Fu1Cq8VlPnIZrjP
         +maUymW3odKDtq+Mz7Ahi8MZ2iI54QKThqmGSlfsY8rxMpmAGkmxVXU69Be3GDxXkdA6
         21kHYANdzYmTaMnP/ZPcCOdGdGziFMfkXdhSEvAohIv7IEEI+CRDqrtZd3GhOcYXh9uC
         JsEKq5optDwPx7JlS35QPPcWtWR/HSBLe7wJlPSVwJfrD1pokSU3R1N0Y55MFXDe3d0k
         goU9d1F4gfkAk8k0zrDVFyC0fAitjiODz7ruvCGqvLCPBrTKK/mn4mCCGm0ylRNiopjN
         dhoA==
X-Forwarded-Encrypted: i=1; AJvYcCURwcBfI9qbrWX8KX36XDrwOttx8mHsxU4YGy4Y9Kuywjr0/nwPxd4IPX5HPJJVTpNfn5CoGOyPyz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEhuvipEg2S5gl5ClK2LulXbBvRKTRPlz+NazDpRYsBVsPOngP
	ltutOCST8jt9VIwZuqsW8x/mSgxrC8Ez9HsPQLhDscno3HTqSxVTdl0b
X-Gm-Gg: AZuq6aIPvT+OpCCQpC0DlEAXknuKvUTuYnZwpHZFi1y7jlEJ5WV2cvUG1qbSlJJZ0Tj
	e4huiE+i8NO6GOvLxcXytN/GztkoAZwVZbAB0MB4MYdvGDXCQiTCEh0S71JeOED0U57z6zEdZVZ
	DMPAYqzlFWlNNnqjmuXCWBpc5HN8BZXsKHAGwxGFygoGpuLWhiLR5HUqigoKGJaoNFwPLbeZS2G
	kRthZ++il0nY67Qogi1ptLF1Acpysi/qjMnFaDsy/WLL81uJknEmTJD68k7vJnuAHoJTr9UkvQm
	+a7I5XYVyhbYrhjZ5UoowOzPfw/HuZRitMCl1/wxPkLNoP43o8M39SuaZwzE2ZAKLvbHJ6+HaBK
	riyMqpl4VprQkgSb7bu3UVBQXou3I3zjpIo3ziUikNpok6l8VqjB5L4uB8kRoE7H+maoTluqt+/
	+16lCGjCs0mR46a3t+dCHjmcARF/PV2G/xigQgbQ==
X-Received: by 2002:a05:6a21:6487:b0:38e:9e38:5977 with SMTP id adf61e73a8af0-394838e412amr14633517637.30.1771483616161;
        Wed, 18 Feb 2026 22:46:56 -0800 (PST)
Received: from [192.168.0.120] ([49.207.232.214])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358970484aesm561166a91.4.2026.02.18.22.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 22:46:55 -0800 (PST)
Message-ID: <fd8be071-55ce-484d-872b-aaf5eeab1138@gmail.com>
Date: Thu, 19 Feb 2026 12:16:51 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUEKzVBn5re9JG@infradead.org>
 <91050faaf76fc895bbda97689fd7446ad8d4f278.camel@gmail.com>
 <aZav-QE1L87CKq5L@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZav-QE1L87CKq5L@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/19/26 12:08, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 02:19:21PM +0530, Nirjhar Roy (IBM) wrote:
>> So I just moved the comment and the updation of sb_frextents from
>> outside of "if (xfs_has_lazysbcount(mp)) {" to inside of it since
>> sb_frextents is a also a lazy counter like the sb_fdblocks, sb_ifree.
>> The comment talks about using the positive version of freecounter i.e,
>> xfs_sum_freecounter(). Do you mean to say that the updation/sync of the sb_frextents should be
>> outside "if (xfs_has_lazysbcount(mp)) {" i.e, done irrespective of whether lazy count is set or not?
>> Please let me know if my understanding is wrong.
> rtgroup support requires lazy counters.  So we don't really need that
> clause, and the extra indentation makes the code harder to read (
> to the point that I mised that you actually kept the correct check).

Okay got it. So what you are saying is that, for rtgroup support, lazy 
counter is ALWAYS enabled and xfs_has_lazysbcount(mp) will always be 
true - so there is no need to keep the updation of sb_frextents inside 
the if() block. Right?

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

