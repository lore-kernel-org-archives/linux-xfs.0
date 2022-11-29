Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1ECC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 04:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiK2EKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 23:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiK2EKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 23:10:01 -0500
X-Greylist: delayed 999 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 20:09:58 PST
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD0643AE7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 20:09:58 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4NLpDS3N4dz9v7Jk
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 11:46:48 +0800 (CST)
Received: from [10.174.177.238] (unknown [10.174.177.238])
        by APP2 (Coremail) with SMTP id BqC_BwD36GEagoVjG_prAQ--.37877S2;
        Tue, 29 Nov 2022 03:53:04 +0000 (GMT)
Message-ID: <aea89526-7bd0-2ed8-be8c-0a2ddc7571bd@huaweicloud.com>
Date:   Tue, 29 Nov 2022 11:52:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, houtao1@huawei.com, jack.qiu@huawei.com,
        fangwei1@huawei.com, yi.zhang@huawei.com, zhengbin13@huawei.com,
        leo.lilong@huawei.com, zengheng4@huawei.com
References: <20221103113709.251669-1-guoxuenan@huawei.com>
 <Y2k5NTjTRdsDAuhN@magnolia> <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
 <6ad3b4b0-f25b-1609-e79b-82204bc5577a@redhat.com> <Y3aGas1bc7IMTS/h@magnolia>
From:   Guo Xuenan <guoxuenan@huaweicloud.com>
In-Reply-To: <Y3aGas1bc7IMTS/h@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwD36GEagoVjG_prAQ--.37877S2
X-Coremail-Antispam: 1UD129KBjvJXoW3urWUur1fKr4xWr45Cw1rZwb_yoWDAF4UpF
        WfJa1Ykrs5tr18ArsFyF1jq34UAw47Aa1UXr97Xr1Sq3W5C3W7tr1Skr4UGa4DGr4Fvw1a
        qFnxX3yIqw1DAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU1zuWJUUUUU==
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick，

I asked my colleagues about email-sending problems.
I am not the only one with the problem :( so,my reply of you question here
also sent faild. With my colleague's advice, I change a new email address.
Hope from now on, my email can be received by mailing list :)
On 2022/11/18 3:07, Darrick J. Wong wrote:
> On Thu, Nov 17, 2022 at 10:13:46AM -0600, Eric Sandeen wrote:
>> On 11/7/22 7:50 PM, Guo Xuenan wrote:
>>> On 2022/11/8 0:58, Darrick J. Wong wrote:
>>>> On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
>>>>> xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
>>>>> it is a fault injection tag, better not use it in the macro ASSERT.
>>>>>
>>>>> Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
>>>>>> /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
>>>>> It's confusing and strange.
>>>> Please be more specific about how this is confusing or strange.
>>> I meant in current code, the ASSERT will alway happen,when we
>>> `echo 1 > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
>>> xfs_btree_islastblock
>>>    ->ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
>>>      ->xfs_btree_check_{l/s}block
>>>        ->XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_{S,L}BLOCK)
>>> we can use error injection to trigger this ASSERT.
>> Hmmm...
>>
>>> I think ASERRT macro and error injection are to find some effective problems,
>>> not to create some kernel panic.
>> You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig, or
>> at runtime by setting fs.xfs.bug_on_assert to 0, but ...
>>
>>> So, putting the error injection function in
>>> ASSERT is a little strange.
>> Ok, so I think the argument is that in the default config, setting this error
>> injection tag will immediately result in a system panic, which probably isn't
>> what we want.  Is my understanding correct?
Yes, Eric, you are right, that's just what i mean.
>> But in the bigger picture, isn't this:
>>
>> ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
>>
>> putting a disk corruption check into an ASSERT? That in itself seems a bit
>> suspect.  However, the ASSERT was all introduced in:
>>
>> commit 27d9ee577dccec94fb0fc1a14728de64db342f86
>> Author: Darrick J. Wong <darrick.wong@oracle.com>
>> Date:   Wed Nov 6 08:47:09 2019 -0800
>>
>>      xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock
>>      
>>      Coverity points out that xfs_btree_islastblock doesn't check the return
>>      value of xfs_btree_check_block.  Since the question "Does the cursor
>>      point to the last block in this level?" only makes sense if the caller
>>      previously performed a lookup or seek operation, the block should
>>      already have been checked.
>>      
>>      Therefore, check the return value in an ASSERT and turn the whole thing
>>      into a static inline predicate.
>>      
>>      Coverity-id: 114069
>>      Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>      Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> which seems to imply that we really should not get here with a corrupt block during
>> normal operation.
It did, xfs_alloc_ag_vextent_near->xfs_btree_islastblock, see below for 
more details.
>> Perhaps the error tag can get set after the block "should already have been checked"
>> but before this test in the ASSERT?
> What I want to know here is *how* do we get to the point of tripping
> this assertion via debugknob?  Won't the lookup or seek operation have
> already checked the block and failed with EFSCORRUPTED?  And shouldn't
> that be enough to stop whatever code calls xfs_btree_islastblock?  If
> not, how do we get there?
>
> Seriously, I don't want to burn more time discussing where and how to
> fail on debugging knobs when there are all these other **far more
> serious** corruption and deadlock problems that people are trying to get
> merged.
>
> Tell me specifically how to make the system fail.  "It's confusing and
> strange" is not good enough.
Sorry,It's my fault. I didn't explain it clearly enough,and I don't think
this is a serious problem either. The background of the matter is we have
some testcases to test xfs, some of them are fault inject cases,and make
our testcase failed.

As Eric pointed out "You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig"
It's just a little strange to me,and always make our testcase failed.
I just report it and if you are not interested in this patch,I am not strongly request
this to make it merged.

Here is the *how*, show you the test code and call trace.

*This is the test case:*
function do_test()
{
	echo "--- in do_test ---"
	_mount "$mount_options" $disk $mountpoint
	_check_fsstress $mountpoint # just do: fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null
	echo 1 > /sys/fs/xfs/sda/errortag/btree_chk_sblk
	sleep $ERROR_TEST_RUN_TIME
}

round=0
do_pre
while [ $round -lt $round_max ]
do
	echo "******* round $round ********"
	do_test
	round=$(($round+1))
done

*This is the call trace:*
XFS (sda): fsstress should use fallocate; XFS_IOC_{ALLOC,FREE}SP ioctl 
unsupported
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS (sda): Corruption of in-memory data (0x8) detected at 
xfs_defer_finish_noroll+0x100c/0x19e0 (fs/xfs/libxfs/xfs_defer.c:573).  
Shutting down filesystem.
XFS (sda): Please unmount the filesystem and rectify the problem(s)
xfs filesystem being mounted at /mnt/test supports timestamps until 2038 
(0x7fffffff)
xfs filesystem being mounted at /mnt/test supports timestamps until 2038 
(0x7fffffff)
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
XFS: Assertion failed: block && xfs_btree_check_block(cur, block, level, 
bp) == 0, file: fs/xfs/libxfs/xfs_btree.h, line: 559
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
CPU: 0 PID: 30 Comm: kworker/u4:2 Not tainted 
6.1.0-rc4-01347-geab06d36b0ac #510
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.14.0-4.fc34 04/01/2014
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:assfail+0x7a/0x8a
Code: 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 0c 48 c7 c7 b0 72 03 
8c e8 3d 45 d5 fd 80 3d f6 ab 4e 08 00 74 07 e8 df e4 91 fd <0f> 0b e8 
d8 e4 91 fd 0f 0b 5b 5d 41 5c 41 5d c3 e8 ca e4 91 fd 48
RSP: 0018:ffff888010ab6ab8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff84427ce0 RCX: 0000000000000000
RDX: ffff888010aa8040 RSI: ffffffff83b4c6c1 RDI: ffffed1002156d46
RBP: 0000000000000000 R08: 000000000000007d R09: ffff888010ab6777
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
R10: ffffed1002156cee R11: 0000000000000001 R12: ffffffff84427d20
R13: 000000000000022f R14: ffff888010ab6b88 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88805a400000(0000) knlGS:0000000000000000
XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, 
line 243, on filesystem "sda"
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
XFS (sda): xfs_inactive_ifree: xfs_ifree returned error -117
CR2: 0000000001d192b8 CR3: 0000000017d0e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <TASK>
  xfs_alloc_ag_vextent_near.constprop.0+0x945/0x13b0
  xfs_alloc_ag_vextent+0x7a6/0xdd0
  xfs_alloc_vextent+0x13d2/0x1cd0
  xfs_bmap_btalloc+0x778/0x1450
  xfs_bmapi_allocate+0x348/0x1260
  xfs_bmapi_convert_delalloc+0x669/0xd50
  xfs_map_blocks+0x4f7/0xc50
  iomap_do_writepage+0x785/0x1ed0
  write_cache_pages+0x39e/0xd60
  iomap_writepages+0x50/0xb0
  xfs_vm_writepages+0x128/0x1b0
  do_writepages+0x196/0x640
  __writeback_single_inode+0xae/0x8d0
  writeback_sb_inodes+0x4b8/0xc00
  __writeback_inodes_wb+0xc1/0x220
  wb_writeback+0x590/0x730
  wb_workfn+0x7a4/0xca0
  process_one_work+0x6d1/0xf40
  worker_thread+0x5b9/0xf60
  kthread+0x287/0x330
  ret_from_fork+0x1f/0x30
  </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x7a/0x8a
Code: 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 0c 48 c7 c7 b0 72 03 
8c e8 3d 45 d5 fd 80 3d f6 ab 4e 08 00 74 07 e8 df e4 91 fd <0f> 0b e8 
d8 e4 91 fd 0f 0b 5b 5d 41 5c 41 5d c3 e8 ca e4 91 fd 48
RSP: 0018:ffff888010ab6ab8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff84427ce0 RCX: 0000000000000000
RDX: ffff888010aa8040 RSI: ffffffff83b4c6c1 RDI: ffffed1002156d46
RBP: 0000000000000000 R08: 000000000000007d R09: ffff888010ab6777
R10: ffffed1002156cee R11: 0000000000000001 R12: ffffffff84427d20
R13: 000000000000022f R14: ffff888010ab6b88 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88805a400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001d192b8 CR3: 0000000017d0e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled

---[ end Kernel panic - not syncing: Fatal exception ]---

Best wishes,
Xuenan
> --D
>
>> -Eric
>>

