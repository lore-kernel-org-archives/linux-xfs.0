Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D52C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Oct 2022 11:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJGLd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Oct 2022 07:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJGLd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2022 07:33:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A30D0CD7
        for <linux-xfs@vger.kernel.org>; Fri,  7 Oct 2022 04:33:56 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MkR2J745qzpSxV;
        Fri,  7 Oct 2022 19:30:48 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 19:33:54 +0800
Message-ID: <0373f977-7198-0c0e-df2c-43889afcd344@huawei.com>
Date:   Fri, 7 Oct 2022 19:33:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH v4] xfs: fix exception caused by unexpected illegal
 bestcount in leaf dir
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <david@fromorbit.com>, <dchinner@redhat.com>,
        <chandan.babu@oracle.com>, <houtao1@huawei.com>,
        <jack.qiu@huawei.com>, <linux-xfs@vger.kernel.org>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
References: <20220912013154.GB3600936@dread.disaster.area>
 <20220929085155.475484-1-guoxuenan@huawei.com> <YzYFFINMSAlLWQDu@magnolia>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <YzYFFINMSAlLWQDu@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2022/9/30 4:50, Darrick J. Wong wrote:
> On Thu, Sep 29, 2022 at 04:51:55PM +0800, Guo Xuenan wrote:
>> For leaf dir, In most cases, there should be as many bestfree slots
>> as the dir data blocks that can fit under i_size (except for [1]).
>>
>> Root cause is we don't examin the number bestfree slots, when the slots
>> number less than dir data blocks, if we need to allocate new dir data
>> block and update the bestfree array, we will use the dir block number as
>> index to assign bestfree array, while we did not check the leaf buf
>> boundary which may cause UAF or other memory access problem. This issue
>> can also triggered with test cases xfs/473 from fstests.
>>
>> According to Dave Chinner & Darrick's suggestion, adding buffer verifier
>> to detect this abnormal situation in time.
>> Simplify the testcase for fstest xfs/554 [1]
>>
>> The error log is shown as follows:
>> ==================================================================
>> BUG: KASAN: use-after-free in xfs_dir2_leaf_addname+0x1995/0x1ac0
>> Write of size 2 at addr ffff88810168b000 by task touch/1552
>> CPU: 5 PID: 1552 Comm: touch Not tainted 6.0.0-rc3+ #101
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x4d/0x66
>>   print_report.cold+0xf6/0x691
>>   kasan_report+0xa8/0x120
>>   xfs_dir2_leaf_addname+0x1995/0x1ac0
>>   xfs_dir_createname+0x58c/0x7f0
>>   xfs_create+0x7af/0x1010
>>   xfs_generic_create+0x270/0x5e0
>>   path_openat+0x270b/0x3450
>>   do_filp_open+0x1cf/0x2b0
>>   do_sys_openat2+0x46b/0x7a0
>>   do_sys_open+0xb7/0x130
>>   do_syscall_64+0x35/0x80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fe4d9e9312b
>> Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
>> 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
>> f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
>> RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
>> RDX: 0000000000000941 RSI: 00007ffda4c17f33 RDI: 00000000ffffff9c
>> RBP: 00007ffda4c17f33 R08: 0000000000000000 R09: 0000000000000000
>> R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
>> R13: 00007fe4d9f631a4 R14: 00007ffda4c17f33 R15: 0000000000000000
>>   </TASK>
>>
>> The buggy address belongs to the physical page:
>> page:ffffea000405a2c0 refcount:0 mapcount:0 mapping:0000000000000000
>> index:0x0 pfn:0x10168b
>> flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
>> raw: 002fffff80000000 ffffea0004057788 ffffea000402dbc8 0000000000000000
>> raw: 0000000000000000 0000000000170000 00000000ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff88810168af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>   ffff88810168af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> ffff88810168b000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>                     ^
>>   ffff88810168b080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>   ffff88810168b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ==================================================================
>> Disabling lock debugging due to kernel taint
>> 00000000: 58 44 44 33 5b 53 35 c2 00 00 00 00 00 00 00 78
>> XDD3[S5........x
>> XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200 of file
>> fs/xfs/libxfs/xfs_dir2_data.c.  Caller
>> xfs_dir2_data_use_free+0x28a/0xeb0
>> CPU: 5 PID: 1552 Comm: touch Tainted: G    B              6.0.0-rc3+
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x4d/0x66
>>   xfs_corruption_error+0x132/0x150
>>   xfs_dir2_data_use_free+0x198/0xeb0
>>   xfs_dir2_leaf_addname+0xa59/0x1ac0
>>   xfs_dir_createname+0x58c/0x7f0
>>   xfs_create+0x7af/0x1010
>>   xfs_generic_create+0x270/0x5e0
>>   path_openat+0x270b/0x3450
>>   do_filp_open+0x1cf/0x2b0
>>   do_sys_openat2+0x46b/0x7a0
>>   do_sys_open+0xb7/0x130
>>   do_syscall_64+0x35/0x80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fe4d9e9312b
>> Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
>> 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
>> f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
>> RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
>> RDX: 0000000000000941 RSI: 00007ffda4c17f46 RDI: 00000000ffffff9c
>> RBP: 00007ffda4c17f46 R08: 0000000000000000 R09: 0000000000000001
>> R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
>> R13: 00007fe4d9f631a4 R14: 00007ffda4c17f46 R15: 0000000000000000
>>   </TASK>
>> XFS (sdb): Corruption detected. Unmount and run xfs_repair
>>
>> [1] https://lore.kernel.org/all/20220928095355.2074025-1-guoxuenan@huawei.com/
>> Reviewed-by: Hou Tao <houtao1@huawei.com>
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_dir2_leaf.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index d9b66306a9a7..bf4633b228cd 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -146,6 +146,7 @@ xfs_dir3_leaf_check_int(
>>   	xfs_dir2_leaf_tail_t		*ltp;
>>   	int				stale;
>>   	int				i;
>> +	xfs_dir2_db_t			db;
>>   
>>   	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
>>   
>> @@ -175,6 +176,9 @@ xfs_dir3_leaf_check_int(
>>   		}
>>   		if (hdr->ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>>   			stale++;
>> +		db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(hdr->ents[i].address));
>> +		if (db >= be32_to_cpu(ltp->bestcount))
>> +			return __this_address;
> What about LEAFN blocks?  Those don't have a bests[] array or a
> bestcount because the free space info is in the third directory
> partition, so there's nothing to check here.  IIUC, only LEAF1 blocks
> can compare bestcount to the entry addresses, right?
Hi, Darrick:

Sorry for the late reply, I was on vacation last week.I have confirmed 
it, you're right,may we
need add an additional restriction, compare only LEAF1 block.

According to the problem you pointed out, amend as below. Looking 
forward for your valuable suggestions :)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d9b66306a9a7..cd9ff1322445 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -175,6 +175,12 @@ xfs_dir3_leaf_check_int(
                 }
                 if (hdr->ents[i].address == 
cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
                         stale++;
+               if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
+                       hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
+                       xfs_dir2_dataptr_to_db(geo,
+ be32_to_cpu(hdr->ents[i].address))
+                                       >= be32_to_cpu(ltp->bestcount))
+                       return __this_address;
         }
         if (hdr->stale != stale)
                 return __this_address;



Thanks
Xuenan
> --D
>
>>   	}
>>   	if (hdr->stale != stale)
>>   		return __this_address;
>> -- 
>> 2.25.1
>>
> .

-- 
Guo Xuenan
-----------------------------
Email: guoxuenan@huawei.com

