Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B65C46467
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 14:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjAKOma (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 09:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbjAKOlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 09:41:52 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2E10D6
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 06:41:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VZNZS.M_1673448104;
Received: from 30.25.206.70(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VZNZS.M_1673448104)
          by smtp.aliyun-inc.com;
          Wed, 11 Jan 2023 22:41:45 +0800
Message-ID: <5287e7e6-adea-e865-5818-9cc34400cd0b@linux.alibaba.com>
Date:   Wed, 11 Jan 2023 22:41:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia> <20210223123106.GB946926@bfoster>
 <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2022/5/26 19:34, Amir Goldstein wrote:
> On Tue, Feb 23, 2021 at 2:35 PM Brian Foster <bfoster@redhat.com> wrote:
>>
>> On Mon, Feb 22, 2021 at 10:27:45AM -0800, Darrick J. Wong wrote:
>>> On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
>>>> Freed extents are marked busy from the point the freeing transaction
>>>> commits until the associated CIL context is checkpointed to the log.
>>>> This prevents reuse and overwrite of recently freed blocks before
>>>> the changes are committed to disk, which can lead to corruption
>>>> after a crash. The exception to this rule is that metadata
>>>> allocation is allowed to reuse busy extents because metadata changes
>>>> are also logged.
>>>>
>>>> As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
>>>> has allowed modification or complete invalidation of outstanding
>>>> busy extents for metadata allocations. This implementation assumes
>>>> that use of the associated extent is imminent, which is not always
>>>> the case. For example, the trimmed extent might not satisfy the
>>>> minimum length of the allocation request, or the allocation
>>>> algorithm might be involved in a search for the optimal result based
>>>> on locality.
>>>>
>>>> generic/019 reproduces a corruption caused by this scenario. First,
>>>> a metadata block (usually a bmbt or symlink block) is freed from an
>>>> inode. A subsequent bmbt split on an unrelated inode attempts a near
>>>> mode allocation request that invalidates the busy block during the
>>>> search, but does not ultimately allocate it. Due to the busy state
>>>> invalidation, the block is no longer considered busy to subsequent
>>>> allocation. A direct I/O write request immediately allocates the
>>>> block and writes to it.
>>>

...

>>
> 
> Hi Brian,
> 
> This patch was one of my selected fixes to backport for v5.10.y.
> It has a very scary looking commit message and the change seems
> to be independent of any infrastructure changes(?).
> 
> The problem is that applying this patch to v5.10.y reliably reproduces
> this buffer corruption assertion [*] with test xfs/076.
> 
> This happens on the kdevops system that is using loop devices over
> sparse files inside qemu images. It does not reproduce on my small
> VM at home.
> 
> Normally, I would just drop this patch from the stable candidates queue
> and move on, but I thought you might be interested to investigate this
> reliable reproducer, because maybe this system exercises an error
> that is otherwise rare to hit.
> 
> It seemed weird to me that NOT reusing the extent would result in
> data corruption, but it could indicate that reusing the extent was masking
> the assertion and hiding another bug(?).
> 
> Can you think of another reason to explain the regression this fix
> introduces to 5.10.y?
> 
> Do you care to investigate this failure or shall I just move on?
> 
> Thanks,
> Amir.
> 
> [*]
> : XFS (loop5): Internal error xfs_trans_cancel at line 954 of file
> fs/xfs/xfs_trans.c.  Caller xfs_create+0x22f/0x590 [xfs]
> : CPU: 3 PID: 25481 Comm: touch Kdump: loaded Tainted: G            E
>     5.10.109-xfs-2 #8
> : Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
> : Call Trace:
> :  dump_stack+0x6d/0x88
> :  xfs_trans_cancel+0x17b/0x1a0 [xfs]
> :  xfs_create+0x22f/0x590 [xfs]
> :  xfs_generic_create+0x245/0x310 [xfs]
> :  ? d_splice_alias+0x13a/0x3c0
> :  path_openat+0xe3f/0x1080
> :  do_filp_open+0x93/0x100
> :  ? handle_mm_fault+0x148e/0x1690
> :  ? __check_object_size+0x162/0x180
> :  do_sys_openat2+0x228/0x2d0
> :  do_sys_open+0x4b/0x80
> :  do_syscall_64+0x33/0x80
> :  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> : RIP: 0033:0x7f36b02eff1e
> : Code: 25 00 00 41 00 3d 00 00 41 00 74 48 48 8d 05 e9 57 0d 00 8b 00
> 85 c0 75 69 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d
> 00 f0 ff ff 0
> : RSP: 002b:00007ffe7ef6ca10 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> : RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f36b02eff1e
> : RDX: 0000000000000941 RSI: 00007ffe7ef6ebfa RDI: 00000000ffffff9c
> : RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> : R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
> : R13: 00007ffe7ef6ebfa R14: 0000000000000001 R15: 0000000000000001
> : XFS (loop5): xfs_do_force_shutdown(0x8) called from line 955 of file
> fs/xfs/xfs_trans.c. Return address = ffffffffc08f5764
> : XFS (loop5): Corruption of in-memory data detected.  Shutting down filesystem
> : XFS (loop5): Please unmount the filesystem and rectify the problem(s)
> 

(...just for the record) We also encountered this issue but without commit
  xfs: don't reuse busy extents on extent trim
applied in our 5.10 codebase...

Need to find some time to look into that...

[  413.283300] XFS (loop1): Internal error xfs_trans_cancel at line 950 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x219/0x590 [xfs]
[  413.284295] CPU: 0 PID: 27484 Comm: touch Tainted: G            E     5.10.134-13.an8.x86_64 #1
[  413.284296] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 449e491 04/01/2014
[  413.284297] Call Trace:
[  413.284314]  dump_stack+0x57/0x6e
[  413.284373]  xfs_trans_cancel+0xa3/0x110 [xfs]
[  413.284412]  xfs_create+0x219/0x590 [xfs]
[  413.284458]  xfs_generic_create+0x21f/0x2d0 [xfs]
[  413.284462]  path_openat+0xdee/0x1020
[  413.284464]  do_filp_open+0x80/0xd0
[  413.284467]  ? __check_object_size+0x16a/0x180
[  413.284469]  do_sys_openat2+0x207/0x2c0
[  413.284471]  do_sys_open+0x3b/0x60
[  413.284475]  do_syscall_64+0x33/0x40
[  413.284478]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[  413.284481] RIP: 0033:0x7fe623920252
[  413.284482] Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 55 43 2a 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
[  413.284483] RSP: 002b:00007ffd7a38ca70 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[  413.284485] RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007fe623920252
[  413.284486] RDX: 0000000000000941 RSI: 00007ffd7a38d79d RDI: 00000000ffffff9c
[  413.284487] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[  413.284488] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000001
[  413.284488] R13: 0000000000000001 R14: 00007ffd7a38d79d R15: 00007fe623bbf374
[  413.289856] XFS (loop1): xfs_do_force_shutdown(0x8) called from line 951 of file fs/xfs/xfs_trans.c. Return address = 000000003fe0b8ba
[  413.289858] XFS (loop1): Corruption of in-memory data detected.  Shutting down filesystem
[  413.290573] XFS (loop1): Please unmount the filesystem and rectify the problem(s)

Thanks,
Gao Xiang
