Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B6218B468;
	Tue, 20 Aug 2024 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724145813; cv=none; b=oSzM0Jdwj4xsO9bvjQYOXu5mQRJ1Si6DUUUi3gwCo07ZKDvuZwqS1S/ShaKhsq24SXRYD96o6xug/c9WRoIDMLcsNC59lrvuVMqiWPIJmPyAEDuGboIc2G2VH70OQWGgJc6u0Vmm1pq6nC2hyYZsJkmfmv+QjzcRGSoHvYHRvUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724145813; c=relaxed/simple;
	bh=G7ZgOWdruX5aHmZd5xkeb8whK51X54ptM22wTDCFRbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=D9Y2KsOKK9JvTTh6zzycSFste7EltH0yAdey2FzW5gZktaX+y9QPaL10NKXxsQWbau5nKZtDAwLP8floSGwSzRHeXMG4+NEyBGzQrYGtwDGte48bvEfItCQtnqwwC59to0qWS6L/mOrhJMyVxEFGvKQDVUY6dWgkeXyO3dX1RGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Wp3qx0snPz1xvcm;
	Tue, 20 Aug 2024 17:21:33 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 292EF18001B;
	Tue, 20 Aug 2024 17:23:27 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Aug 2024 17:23:26 +0800
Message-ID: <06289b8b-7623-4691-afad-34724742176c@huawei.com>
Date: Tue, 20 Aug 2024 17:23:25 +0800
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
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Hello! I upgraded xfsprogs to 6.9.0, and tested the latest code
(reverted jump_label.c related code), but still no problems with the
test, maybe there is a problem with my other environment configuration?
Here is my configuration:

export FSTYP=xfs
export TEST_DEV=/dev/vdb
export TEST_DIR=/tmp/test
mkdir /tmp/test -p
export SCRATCH_DEV=/dev/vde
export SCRATCH_MNT=/tmp/scratch
mkdir /tmp/scratch -p
export TEST_LOGDEV=/dev/vdc
export TEST_RTDEV=/dev/vdd
export TEST_FS_MOUNT_OPTS="-o rtdev=/dev/vdd -o logdev=/dev/vdc"
export MKFS_OPTIONS="-f -m reflink=0,rmapbt=0 -d rtinherit=1 -l size=1g"
export USE_EXTERNAL=yes
echo xfs/556
./check xfs/556


However, this patch is not the final version, and I found another
statistical issue with fsmap locally. In addition, Darrick also found a
boundary-case bug in the patch, which may be responsible for the scrub 
indefinitely? I'm not sure. Anyway, I'll fix it again and test it, and
hopefully pass the test next time.

Thanks,
Zizhi Wo

