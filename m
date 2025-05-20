Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE22E22F758
	for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 13:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746919; cv=none; b=YMBvhDsdq/1EvMB9m4XP3bkAs4eabIJVgyUZBOAhdKwvTfiIU28XAm/13euvwh5I5vKMcZIonxcvqhDFKMLu7Mx/abIbGH7eeObYNzQsCudMtAjeVNmFIoaaMFQeHIK6rWyERjkpzg3z7LuvLo33cMapCiWR1cVjqJ/QCxu5kug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746919; c=relaxed/simple;
	bh=jW+hJnPo+T9S3qN0wjn4geIiAr++wqMNzNDkH/vhvZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TYhyHXVHJRtSETFVcg5kGd9Ni3uKhPq8sz7zUtVyIqf8QUYgUzqZHgeaD1auJ9wSk/p7CQR5IWkYt7qgGdupf2xCPqO1yBx63SaNC1Fg866KHAZ3/Wjo0XwlKWsN9zEmjBg8JWBtfgv5rYPHKa3g7glWM7BBOX7M1pOX+BIsDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4b1w451R2Gznfj8;
	Tue, 20 May 2025 21:13:57 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id EDD86140121;
	Tue, 20 May 2025 21:15:12 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 May 2025 21:15:12 +0800
Message-ID: <ccc2913e-36ed-4e95-af17-452a06dc670c@huawei.com>
Date: Tue, 20 May 2025 21:15:11 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
To: Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<yangerkun@huawei.com>, <leo.lilong@huawei.com>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
 <9_MWuMXnaWk3qXgpyYhQa-60ELGmTr8hBsB3E4comBf1_9Mx-ZtDqy3cQKCTkNa9aVG4zLeTHVvnaepX2jweEA==@protonmail.internalid>
 <20250519150854.GB9705@frogsfrogsfrogs>
 <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
 <QW9YI98DcQqphE8-s07KFEcBLpkLhiozJvfGBPPOrtYNXx81V8ynWQUT0ojRyiC2EocVMPpxcpgyUvsrGkAIrA==@protonmail.internalid>
 <fc9a4b4d-9209-4346-a652-cd1661e583cb@huawei.com>
 <le2sd5pz32vvwt6l7t6wgzmtdewdn5o77t5656kbf4l4545iul@2ppxdylrnzjg>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <le2sd5pz32vvwt6l7t6wgzmtdewdn5o77t5656kbf4l4545iul@2ppxdylrnzjg>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2025/5/20 20:47, Carlos Maiolino 写道:
> On Tue, May 20, 2025 at 07:57:19PM +0800, Zizhi Wo wrote:
>>
>>
>> 在 2025/5/20 18:38, Carlos Maiolino 写道:
>>> On Mon, May 19, 2025 at 08:08:54AM -0700, Darrick J. Wong wrote:
>>>> On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
>>>>> From: Zizhi Wo <wozizhi@huaweicloud.com>
>>>>>
>>>>> In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
>>>>> to check the result of query_fn(), because there won't be another iteration
>>>>> of the loop anyway. Also, both before and after the change, info->group
>>>>> will eventually be set to NULL and the reference count of xfs_group will
>>>>> also be decremented before exiting the iteration.
>>>>>
>>>>> The same logic applies to other similar functions as well, so related
>>>>> cleanup operations are performed together.
>>>>>
>>>>> Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
>>>>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>>>>> ---
>>>>>    fs/xfs/xfs_fsmap.c | 6 ------
>>>>>    1 file changed, 6 deletions(-)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>>>>> index 414b27a86458..792282aa8a29 100644
>>>>> --- a/fs/xfs/xfs_fsmap.c
>>>>> +++ b/fs/xfs/xfs_fsmap.c
>>>>> @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
>>>>>    		if (pag_agno(pag) == end_ag) {
>>>>>    			info->last = true;
>>>>>    			error = query_fn(tp, info, &bt_cur, priv);
>>>>> -			if (error)
>>>>> -				break;
>>>>
>>>> Removing these statements make the error path harder to follow.  Before,
>>>> it was explicit that an error breaks out of the loop body.  Now you have
>>>> to look upwards to the while loop conditional and reason about what
>>>> xfs_perag_next_range does when pag-> agno == end_ag to determine that
>>>> the loop terminates.
>>>>
>>>> This also leaves a tripping point for anyone who wants to add another
>>>> statement into this here if body because now they have to recognize that
>>>> they need to re-add the "if (error) break;" statements that you're now
>>>> taking out.
>>>>
>>>> You also don't claim any reduction in generated machine code size or
>>>> execution speed, which means all the programmers end up having to
>>>> perform extra reasoning when reading this code for ... what?  Zero gain?
>>>>
>>>> Please stop sending overly narrowly focused "optimizations" that make
>>>> life harder for all of us.
>>>
>>> I do agree with Darrick. What's the point of this patch other than making code
>>> harder to understand? This gets rid of less than 10 machine instructions at the
>>> final module, and such cod is not even a hot path. making these extra instructions
>>> virtually negligible IMO (looking at x86 architecture). The checks are unneeded
>>> logically, but make the code easier to read, which is also important.
>>> Did you actually see any improvement on anything by applying this patch? Or was
>>> it crafted merely as a result of code inspection? Where are the results that make
>>> this change worth the extra complexity while reading it?
>>>
>>
>> Yes, I was simply thinking about this while looking at the fsmap-related
>> code. Since the current for loop always exits after iterating to the
>> last AG, I thought off the top of my head that the error check for
>> last_ag might be unnecessary. As you and Darrick mentioned, though,
>> removing it would increase the difficulty of reading the code and could
>> also affect future developers.:(
>>
>> If doing so could bring significant performance benefits, then it might
>> be worth considering — perhaps with some added comments to clarify? But
>> in this case, the performance gain is indeed negligible, I admit. Thank
>> you for pointing that out.
> 
> As anything, it's always a trade-off.
> The key thing to take away here is your patch make the whole code it touches
> harder to understand without bringing any real benefit. Even if you could
> prove this adds small performance gain to the fsmap interface, perhaps it
> would still not be worth the performance gain in lieu of poor code reliability,
> giving the interface you changed. So, it's always about discussing the
> change's trade-off between complexity and performance. In your case, there
> seems to be no real trade-off.
> 

Yes, unfortunately, the change I made here isn't substantial enough to
warrant any serious consideration or trade-off... Anyway, It was a good
learning experience for me as well.

