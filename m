Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9827E7E6
	for <linux-xfs@vger.kernel.org>; Tue, 20 May 2025 11:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747742252; cv=none; b=nbVcUvBi3v/Pywz5BOnttYFlSt0OnN0EAUFzaDL/d7ucYafh0NEvPlAMhr/N94pHgCAMYOo0VbmysJhXY7NgWG8Vk+UDn1e2r9Z3LnVRaf9GjlHzBkw33wTU9PDVjrMh53rlp5ICK07uXJkjnWwrB0KLuznLQTKAwCpGB7IeIKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747742252; c=relaxed/simple;
	bh=ZIDzFPtbcbLnIxLpLWuPoUiPxyqNrSGs6DdeP0vSdZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qfuQT1v6/2TT7Drw039LWzXLPuQbwEG51dVzjJeQAKObO85Nc7eba/POKsAeCnmcy+ik5DbFPmxRlB7Wj3JdBl9HoNGTXt2HFYDto6RxFTfGALqXcFeUdAnUx2hkd2XLau/EVEIq5K4Isn0K4JewCTDKFql9b/3cs8+hXT52OZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4b1tLj1D6Zz1f1lY;
	Tue, 20 May 2025 19:56:29 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D98B14011F;
	Tue, 20 May 2025 19:57:21 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 May 2025 19:57:20 +0800
Message-ID: <fc9a4b4d-9209-4346-a652-cd1661e583cb@huawei.com>
Date: Tue, 20 May 2025 19:57:19 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
To: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
CC: <dchinner@redhat.com>, <osandov@fb.com>, <john.g.garry@oracle.com>,
	<linux-xfs@vger.kernel.org>, <yangerkun@huawei.com>, <leo.lilong@huawei.com>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
 <9_MWuMXnaWk3qXgpyYhQa-60ELGmTr8hBsB3E4comBf1_9Mx-ZtDqy3cQKCTkNa9aVG4zLeTHVvnaepX2jweEA==@protonmail.internalid>
 <20250519150854.GB9705@frogsfrogsfrogs>
 <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <kzgijlgzweykmeni664npughps5jkgf34l7ndyj3zzwgq2wrbi@zbwrkf6xcmzh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2025/5/20 18:38, Carlos Maiolino 写道:
> On Mon, May 19, 2025 at 08:08:54AM -0700, Darrick J. Wong wrote:
>> On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
>>> From: Zizhi Wo <wozizhi@huaweicloud.com>
>>>
>>> In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
>>> to check the result of query_fn(), because there won't be another iteration
>>> of the loop anyway. Also, both before and after the change, info->group
>>> will eventually be set to NULL and the reference count of xfs_group will
>>> also be decremented before exiting the iteration.
>>>
>>> The same logic applies to other similar functions as well, so related
>>> cleanup operations are performed together.
>>>
>>> Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
>>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>>> ---
>>>   fs/xfs/xfs_fsmap.c | 6 ------
>>>   1 file changed, 6 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>>> index 414b27a86458..792282aa8a29 100644
>>> --- a/fs/xfs/xfs_fsmap.c
>>> +++ b/fs/xfs/xfs_fsmap.c
>>> @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
>>>   		if (pag_agno(pag) == end_ag) {
>>>   			info->last = true;
>>>   			error = query_fn(tp, info, &bt_cur, priv);
>>> -			if (error)
>>> -				break;
>>
>> Removing these statements make the error path harder to follow.  Before,
>> it was explicit that an error breaks out of the loop body.  Now you have
>> to look upwards to the while loop conditional and reason about what
>> xfs_perag_next_range does when pag-> agno == end_ag to determine that
>> the loop terminates.
>>
>> This also leaves a tripping point for anyone who wants to add another
>> statement into this here if body because now they have to recognize that
>> they need to re-add the "if (error) break;" statements that you're now
>> taking out.
>>
>> You also don't claim any reduction in generated machine code size or
>> execution speed, which means all the programmers end up having to
>> perform extra reasoning when reading this code for ... what?  Zero gain?
>>
>> Please stop sending overly narrowly focused "optimizations" that make
>> life harder for all of us.
> 
> I do agree with Darrick. What's the point of this patch other than making code
> harder to understand? This gets rid of less than 10 machine instructions at the
> final module, and such cod is not even a hot path. making these extra instructions
> virtually negligible IMO (looking at x86 architecture). The checks are unneeded
> logically, but make the code easier to read, which is also important.
> Did you actually see any improvement on anything by applying this patch? Or was
> it crafted merely as a result of code inspection? Where are the results that make
> this change worth the extra complexity while reading it?
> 

Yes, I was simply thinking about this while looking at the fsmap-related
code. Since the current for loop always exits after iterating to the
last AG, I thought off the top of my head that the error check for
last_ag might be unnecessary. As you and Darrick mentioned, though,
removing it would increase the difficulty of reading the code and could
also affect future developers.:(

If doing so could bring significant performance benefits, then it might
be worth considering — perhaps with some added comments to clarify? But
in this case, the performance gain is indeed negligible, I admit. Thank
you for pointing that out.

Thanks,
Zizhi Wo

> Cheers,
> Carlos
> 
>>
>> NAK.
>>
>> --D
>>
>>>   		}
>>>   		info->group = NULL;
>>>   	}
>>> @@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
>>>   			info->last = true;
>>>   			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
>>>   					&ahigh, info);
>>> -			if (error)
>>> -				break;
>>>   		}
>>>
>>>   		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
>>> @@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
>>>   			info->last = true;
>>>   			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
>>>   					&info->high, info);
>>> -			if (error)
>>> -				break;
>>>   		}
>>>   		info->group = NULL;
>>>   	}
>>> --
>>> 2.39.2
>>>
>>>
>>
> 
> 
