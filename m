Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E247C155739;
	Tue,  3 Sep 2024 09:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725354985; cv=none; b=Y9zoiGeVRtHZknYiBuiKicEmJI1CmibKiceiKFy/FLQzxfMEhGvtkaiOUDgPXCS/gLzs33P6vp6rX49VE+ixYUBycGqM/sCIsxUcAbjVxroTo75vM3PHSUoA0MJFMG9VTIScFu4x9U9edMlfvaQ7SJUTXWd0yaRVJnfpjbloV/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725354985; c=relaxed/simple;
	bh=zi07A8yLuXDioAyg1eZKp4PdkL9BIr9M4XEwfHUGAGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DBbUb15rAAdek2TiwVbroTqZ64P1emF1kb/EcKIs9aeufcj5tr9jFh9bSjsZWn9OUkH3Qa8poD2vO4tebHEDYFv3h8/JpZgAXUhkENNwmc2xsCzf1J9SlQBHTeuckjqlI7uszfMmW6eZzsl9jW/+bJziMPlbrX+2njMEK0uq2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wyg2k2kqQzyRQv;
	Tue,  3 Sep 2024 17:15:42 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 4193A1800FE;
	Tue,  3 Sep 2024 17:16:19 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Sep 2024 17:16:18 +0800
Message-ID: <df1a565a-7de7-4b13-9137-0ec10f4dabc7@huawei.com>
Date: Tue, 3 Sep 2024 17:16:17 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [xfs] ca6448aed4: xfstests.xfs.556.fail
To: kernel test robot <oliver.sang@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>, "Darrick J. Wong"
	<djwong@kernel.org>, <linux-xfs@vger.kernel.org>
References: <202409031358.2c34ad37-oliver.sang@intel.com>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <202409031358.2c34ad37-oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf100017.china.huawei.com (7.202.181.16)

Hi

在 2024/9/3 13:18, kernel test robot 写道:
> 
> 
> Hello,
> 
> kernel test robot noticed "xfstests.xfs.556.fail" on:
> 
> commit: ca6448aed4f10ad88eba79055f181eb9a589a7b3 ("xfs: Fix missing interval for missing_owner in xfs fsmap")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on linus/master      431c1646e1f86b949fa3685efc50b660a364c2b6]
> [test failed on linux-next/master 985bf40edf4343dcb04c33f58b40b4a85c1776d4]
> 
> in testcase: xfstests
> version: xfstests-x86_64-d9423fec-1_20240826
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: xfs
> 	test: xfs-556
> 
> 
> 
> compiler: gcc-12
> test machine: 4 threads Intel(R) Xeon(R) CPU E3-1225 v5 @ 3.30GHz (Skylake) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202409031358.2c34ad37-oliver.sang@intel.com
> 
> 2024-09-01 09:27:55 export TEST_DIR=/fs/sda1
> 2024-09-01 09:27:55 export TEST_DEV=/dev/sda1
> 2024-09-01 09:27:55 export FSTYP=xfs
> 2024-09-01 09:27:55 export SCRATCH_MNT=/fs/scratch
> 2024-09-01 09:27:55 mkdir /fs/scratch -p
> 2024-09-01 09:27:55 export SCRATCH_DEV=/dev/sda4
> 2024-09-01 09:27:55 export SCRATCH_LOGDEV=/dev/sda2
> 2024-09-01 09:27:55 export SCRATCH_XFS_LIST_METADATA_FIELDS=u3.sfdir3.hdr.parent.i4
> 2024-09-01 09:27:55 export SCRATCH_XFS_LIST_FUZZ_VERBS=random
> 2024-09-01 09:27:55 echo xfs/556
> 2024-09-01 09:27:55 ./check xfs/556
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 lkp-skl-d06 6.11.0-rc5-00007-gca6448aed4f1 #1 SMP PREEMPT_DYNAMIC Sun Sep  1 16:52:26 CST 2024
> MKFS_OPTIONS  -- -f /dev/sda4
> MOUNT_OPTIONS -- /dev/sda4 /fs/scratch
> 
> xfs/556       - output mismatch (see /lkp/benchmarks/xfstests/results//xfs/556.out.bad)
>      --- tests/xfs/556.out	2024-08-26 19:09:50.000000000 +0000
>      +++ /lkp/benchmarks/xfstests/results//xfs/556.out.bad	2024-09-01 09:28:17.532120817 +0000
>      @@ -1,12 +1,21 @@
>       QA output created by 556
>       Scrub for injected media error (single threaded)
>      +Corruption: disk offset 106496: media error in unknown owner. (phase6.c line 400)
>       Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
>       SCRATCH_MNT: unfixable errors found: 1
>      +SCRATCH_MNT: corruptions found: 1
>      +SCRATCH_MNT: Unmount and run xfs_repair.
>      ...
>      (Run 'diff -u /lkp/benchmarks/xfstests/tests/xfs/556.out /lkp/benchmarks/xfstests/results//xfs/556.out.bad'  to see the entire diff)
> Ran: xfs/556
> Failures: xfs/556
> Failed 1 of 1 tests
> 
> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20240903/202409031358.2c34ad37-oliver.sang@intel.com
> 
> 

I attempted to reproduce the issue using the script provided in this
link: 
https://download.01.org/0day-ci/archive/20240903/202409031358.2c34ad37-oliver.sang@intel.com/repro-script.
but I discovered that it might not be related to my patch. After I
reverted my own fsmap-related patches locally and ran the test case
using this script, it still failed.

I'm not sure if it's due to an issue with my own environment or if there
are other factors I haven't considered.

However, I still found the current problems of fsmap, and I am not sure
whether it is related to these two.[1][2]

[1] 
https://lore.kernel.org/all/550c038b-d931-4d00-9ebd-5c903e5ddf07@huawei.com/
[2] https://lore.kernel.org/all/20240826031005.2493150-1-wozizhi@huawei.com/

Thanks,
Zizhi Wo

> 
