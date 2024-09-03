Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D121A4E97;
	Tue,  3 Sep 2024 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355126; cv=none; b=uPNTikgCCW8YRvHq74cDzu7YR+eJho9+S1nfRu8nJuQUDaC+tPI7YsGW7FkoUh8b/xGSOpgchCVBxLpXf2tV0R6QWhtZG66yrxoXzdYXKPuRej4sPBvaiP9FX1qRY5ddVuHBAGMzdlrVSmPUsZeDcUKzTps37YcgFrkC4ttydFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355126; c=relaxed/simple;
	bh=NtX+6yB97NtVGALvaPIfDfrFsr7PAI8spCIrDJGjcOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KlSS/gNH6xz37EZldxbICUy0nXZITeLmNrikVIqNmA1/BNEQNREA7PUakUfEz8AMYSg2Efvo9nwmIOKLrNbQPximt2cWsHIb9J2t3nLBuP5MmxXotaDxC80SOe7oa/0IXR0tlXbuFdnBsf768t3eQqtI59WBgLAoroqubeYs6Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wyg3k6gCzzgYpm;
	Tue,  3 Sep 2024 17:16:34 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id A29351800FE;
	Tue,  3 Sep 2024 17:18:41 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Sep 2024 17:18:40 +0800
Message-ID: <2437d861-af70-42b1-b517-aad0a66351cd@huawei.com>
Date: Tue, 3 Sep 2024 17:18:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>
 <20240902190828.GA6224@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240902190828.GA6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/9/3 3:08, Darrick J. Wong 写道:
> On Thu, Aug 29, 2024 at 07:24:55PM +0800, Zizhi Wo wrote:
>> friendly ping
> 
> Sorry, I'm not going to get to this until late September.
> 
> --D

OK, I've got it. Have a nice holiday😀

Thanks,
Zizhi Wo

> 
>> 在 2024/8/26 11:10, Zizhi Wo 写道:
>>> Prior to this, I had already sent out a patchset related to xfs fsmap
>>> bugfix, which mainly introduced "info->end_daddr" to fix omitted extents[1]
>>> and Darrick had already sent out a patchbomb for merging into stable[2],
>>> which included my previous patches.
>>>
>>> However, I recently discovered two new fsmap problems...What follows is a
>>> brief description of them:
>>>
>>> Patch 1: In this scenario, fsmap lost one block count. The root cause is
>>> that during the calculation of highkey, the calculation of start_block is
>>> missing an increment by one, which leads to the last query missing one
>>> This problem is resolved by adding a sentinel node.
>>>
>>> Patch 2: In this scenario, the fsmap query for realtime deivce may display
>>> extra intervals. This is due to an extra increase in "end_rtb". The issue
>>> is resolved by adjusting the relevant calculations. And this patch depends
>>> on the previous patch that introduced "info->end_daddr".
>>>
>>> [1] https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
>>> [2] https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/
>>>
>>> Zizhi Wo (2):
>>>     xfs: Fix missing block calculations in xfs datadev fsmap
>>>     xfs: Fix incorrect parameter calculation in rt fsmap
>>>
>>>    fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
>>>    fs/xfs/xfs_fsmap.c           | 39 +++++++++++++++++++++++++++++++-----
>>>    2 files changed, 35 insertions(+), 8 deletions(-)
>>>
>>
> 
