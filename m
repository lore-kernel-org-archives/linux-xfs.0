Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0748192B73;
	Thu,  7 Nov 2024 09:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730971323; cv=none; b=nErA+MgFb3Z3JbJ4tHShO0i88m+PzflDKWvUn6/xyWHXHaYqA0CLOZfnlJqQyzYUtHWBSNyc3a/U0g0O3VPkccTdV+YLB0v0QSBNZ+1DgcaknJlzwxNBPG1rzLh+ONYvRJw5n+lPBr/jAN6Y15h9jrDhKB4FRwUPNhLzdwmCzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730971323; c=relaxed/simple;
	bh=LsslkvjZfX6CE/ZrarIfhb3LVXQYS/MBsLg4+1MVRt4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=FXLDiGj9OomUiLCVv9WEXwbC4ZIcTxgECJ6zJFTjqwcKYXxoR8DFNQ+v5VPW2Wm92OcS73MGb9w9RC170dv0FI6rfkNS8kvOeQC2YeXF9Y0ohz0yeWZO9tWTIYXbNz+TY/OdeOwKw+X+i38ce3xd9ZoxooHACJ7jeRUvK1myQV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xkc3s0f9Vz10V9n;
	Thu,  7 Nov 2024 17:20:09 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id C2D271401F3;
	Thu,  7 Nov 2024 17:21:56 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Nov 2024 17:21:55 +0800
Message-ID: <725e972f-2014-405b-a056-611c13e95f20@huawei.com>
Date: Thu, 7 Nov 2024 17:21:55 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
From: Zizhi Wo <wozizhi@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>
 <20240902190828.GA6224@frogsfrogsfrogs>
 <9ab7ee3d-cf97-47b0-91dd-c5451911b455@huawei.com>
In-Reply-To: <9ab7ee3d-cf97-47b0-91dd-c5451911b455@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/10/9 21:01, Zizhi Wo 写道:
> Hi!
> 
> Here are two patches that address fsmap statistics errors. I sent out
> this version in August, and I hope someone can take some time to review
> them. So friendly ping. Thanks in advance!

friendly ping again（￣。。￣）

> 
> 
> 在 2024/9/3 3:08, Darrick J. Wong 写道:
>> On Thu, Aug 29, 2024 at 07:24:55PM +0800, Zizhi Wo wrote:
>>> friendly ping
>>
>> Sorry, I'm not going to get to this until late September.
>>
>> --D
>>
>>> 在 2024/8/26 11:10, Zizhi Wo 写道:
>>>> Prior to this, I had already sent out a patchset related to xfs fsmap
>>>> bugfix, which mainly introduced "info->end_daddr" to fix omitted 
>>>> extents[1]
>>>> and Darrick had already sent out a patchbomb for merging into 
>>>> stable[2],
>>>> which included my previous patches.
>>>>
>>>> However, I recently discovered two new fsmap problems...What follows 
>>>> is a
>>>> brief description of them:
>>>>
>>>> Patch 1: In this scenario, fsmap lost one block count. The root 
>>>> cause is
>>>> that during the calculation of highkey, the calculation of 
>>>> start_block is
>>>> missing an increment by one, which leads to the last query missing one
>>>> This problem is resolved by adding a sentinel node.
>>>>
>>>> Patch 2: In this scenario, the fsmap query for realtime deivce may 
>>>> display
>>>> extra intervals. This is due to an extra increase in "end_rtb". The 
>>>> issue
>>>> is resolved by adjusting the relevant calculations. And this patch 
>>>> depends
>>>> on the previous patch that introduced "info->end_daddr".
>>>>
>>>> [1] 
>>>> https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
>>>> [2] 
>>>> https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/
>>>>
>>>> Zizhi Wo (2):
>>>>     xfs: Fix missing block calculations in xfs datadev fsmap
>>>>     xfs: Fix incorrect parameter calculation in rt fsmap
>>>>
>>>>    fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
>>>>    fs/xfs/xfs_fsmap.c           | 39 
>>>> +++++++++++++++++++++++++++++++-----
>>>>    2 files changed, 35 insertions(+), 8 deletions(-)
>>>>
>>>
>>
> 
> 
