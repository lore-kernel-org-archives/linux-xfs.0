Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB418A95A;
	Tue, 20 Aug 2024 09:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724147165; cv=none; b=N21GxM3/QfbKCi7AdK7c+nfpC7h7Fn9bFh1Vac+eTeYT+wUQVW2fTaQHUllZwdCZ9FyHx3RteoX4+f7YK9jmnqlV9H2nX/hTWR9N1jhC4dWGiVfZK3i12U5D42Lm2DOfpLiUDr3lgAvzIjkDhS+lElL3+WPQI2nmVHYm0r9THmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724147165; c=relaxed/simple;
	bh=OQdPl2NH/p6w4XWIGS6owk9Eh+ZEuVXskQUiJ0FXQRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qMDk7/xK6jy/6wiyIBbYMTGDzM/d30Fsjn/lK9TAid4OhcKuW4Zoi5cmyvQlSTw+MkNOFNuFjQkbgN7k5F0WBV4CP4Gl325C19nU1LWGti8u624qDIm8O2ie60xpAGj4bJ7PmR7pzkQ2fm5BWpXxseEB9F0AkSQ0LEbVfZdZJpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wp4JR3CwZz1HGpD;
	Tue, 20 Aug 2024 17:42:47 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 597C51401F4;
	Tue, 20 Aug 2024 17:45:58 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Aug 2024 17:45:57 +0800
Message-ID: <20b3f53e-b850-4c59-8cb1-04d63d9444ea@huawei.com>
Date: Tue, 20 Aug 2024 17:45:56 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/2] Some bugfix for xfs fsmap
To: Chandan Babu R <chandanbabu@kernel.org>
CC: <djwong@kernel.org>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <875xrvenzf.fsf@debian-BULLSEYE-live-builder-AMD64>
 <04118984-4c10-4d25-9547-0e3cd5d9fb03@huawei.com>
 <871q2jegs1.fsf@debian-BULLSEYE-live-builder-AMD64>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <871q2jegs1.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/8/20 16:27, Chandan Babu R 写道:
> On Tue, Aug 20, 2024 at 03:51:23 PM +0800, Zizhi Wo wrote:
>> 在 2024/8/20 13:53, Chandan Babu R 写道:
>>> On Mon, Aug 19, 2024 at 08:53:18 AM +0800, Zizhi Wo wrote:
>>>> Changes since V3[1]:
>>>>    - For the first patch, simply place the modification logic in the
>>>>      xfs_fsmap_owner_to_rmap() function.
>>>>    - For the second patch, more detailed comments were added and related
>>>>      changes were made to the initialization of the end_daddr field.
>>>>
>>>> This patch set contains two patches to repair fsmap. Although they are both
>>>> problems of missing query intervals, the root causes of the two are
>>>> inconsistent, so two patches are proposed.
>>>>
>>>> Patch 1: The fix addresses the interval omission issue caused by the
>>>> incorrect setting of "rm_owner" in the high_key during rmap queries. In
>>>> this scenario, fsmap finds the record on the rmapbt, but due to the
>>>> incorrect setting of the "rm_owner", the key of the record is larger than
>>>> the high_key, causing the query result to be incorrect. This issue is
>>>> resolved by fixing the "rm_owner" setup logic.
>>>>
>>>> Patch 2: The fix addresses the interval omission issue caused by bit
>>>> shifting during gap queries in fsmap. In this scenario, fsmap does not
>>>> find the record on the rmapbt, so it needs to locate it by the gap of the
>>>> info->next_daddr and high_key address. However, due to the shift, the two
>>>> are reduced to 0, so the query error is caused. The issue is resolved by
>>>> introducing the "end_daddr" field in the xfs_getfsmap_info structure to
>>>> store the high_key at the sector granularity.
>>>>
>>>> [1] https://lore.kernel.org/all/20240812011505.1414130-1-wozizhi@huawei.com/
>>>>
>>> The two patches in this series cause xfs_scrub to execute
>>> indefinitely
>>> immediately after xfs/556 is executed.
>>> The fstest configuration used is provided below,
>>> FSTYP=xfs
>>> TEST_DIR=/media/test
>>> SCRATCH_MNT=/media/scratch
>>> TEST_DEV=/dev/loop16
>>> TEST_LOGDEV=/dev/loop13
>>> TEST_RTDEV=/dev/loop12
>>> TEST_FS_MOUNT_OPTS="-o rtdev=/dev/loop12 -o logdev=/dev/loop13"
>>> SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8
>>> /dev/loop9 /dev/loop10 /dev/loop11"
>>> MKFS_OPTIONS="-f -m reflink=0,rmapbt=0, -d rtinherit=1 -lsize=1g"
>>> SCRATCH_LOGDEV=/dev/loop15
>>> SCRATCH_RTDEV=/dev/loop14
>>> USE_EXTERNAL=yes
>>>
>>
>> Sorry, running xfs/556 with this configuration was successful in my
>> environment, and my mkfs.xfs version is 6.8.0:
>>
>> xfs/556
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 fedora 6.11.0-rc3-00015-g1a9f212eb19f #42
>> SMP PREEMPT_DYNAMIC Fri Aug 16 10:19:47 CST 2024
>> VMIP          -- 192.168.240.11
>> MKFS_OPTIONS  -- -f -f -m reflink=0,rmapbt=0 -d rtinherit=1 -l size=1g
>> /dev/vde
>> MOUNT_OPTIONS -- /dev/vde /tmp/scratch
>>
>> xfs/556 4s ...  5s
>> Ran: xfs/556
>> Passed all 1 tests
>>
>> I am not sure if it is because of the specific user mode tools or other
>> environment configuration differences caused?
>>
> 
> My Linux kernel is based on v6.11-rc4. The sources can be found at
> https://github.com/chandanr/linux/commits/xfs-6.11-fixesC-without-jump-label-fixes/.
> 
> Please note that I have reverted commits modifying kernel/jump_label.c. This
> is to work around
> https://lore.kernel.org/linux-xfs/20240730033849.GH6352@frogsfrogsfrogs/.
> 
> Also, I am running xfsprogs v6.9.0. The sources can be found at
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?qt=range&q=v6.9.0
> 

Oh, I made a silly configuration mistake. I have already reproduced the
failure of this use case locally. Sorry for bothering you.

Thanks,
Zizhi Wo
