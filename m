Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE997C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Nov 2022 02:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiKRCNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 21:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiKRCNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 21:13:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321453C6F1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 18:13:44 -0800 (PST)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ND0gf0H3vzmVsg;
        Fri, 18 Nov 2022 10:13:18 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 10:13:41 +0800
Message-ID: <e712fce7-fda2-b4a6-4ccb-75d25d0fa07c@huawei.com>
Date:   Fri, 18 Nov 2022 10:13:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH v4 1/2] xfs: wait xlog ioend workqueue drained before
 tearing down AIL
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <dchinner@redhat.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
References: <20221117145030.5089-1-guoxuenan@huawei.com>
 <20221117145030.5089-2-guoxuenan@huawei.com> <Y3aJaXsR3ElSNEuS@magnolia>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <Y3aJaXsR3ElSNEuS@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/18 3:20, Darrick J. Wong wrote:
> On Thu, Nov 17, 2022 at 10:50:29PM +0800, Guo Xuenan wrote:
>> Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
>> In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
>> xlog_state_shutdown_callbacks") changed the order of running callbacks
>> and wait for iclog completion to avoid unmount path untimely destroy AIL.
>> But which seems not enough to ensue this, adding mdelay in
>> `xfs_buf_item_unpin` can prove that.
>>
>> The reproduction is as follows. To ensure destroy AIL safely,
>> we should wait all xlog ioend workers done and sync the AIL.
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in xfs_trans_ail_delete+0x240/0x2a0
>> Read of size 8 at addr ffff888023169400 by task kworker/1:1H/43
>>
>> CPU: 1 PID: 43 Comm: kworker/1:1H Tainted: G        W
>> 6.1.0-rc1-00002-gc28266863c4a #137
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.13.0-1ubuntu1.1 04/01/2014
>> Workqueue: xfs-log/sda xlog_ioend_work
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x4d/0x66
>>   print_report+0x171/0x4a6
>>   kasan_report+0xb3/0x130
>>   xfs_trans_ail_delete+0x240/0x2a0
>>   xfs_buf_item_done+0x7b/0xa0
>>   xfs_buf_ioend+0x1e9/0x11f0
>>   xfs_buf_item_unpin+0x4c8/0x860
>>   xfs_trans_committed_bulk+0x4c2/0x7c0
>>   xlog_cil_committed+0xab6/0xfb0
>>   xlog_cil_process_committed+0x117/0x1e0
>>   xlog_state_shutdown_callbacks+0x208/0x440
>>   xlog_force_shutdown+0x1b3/0x3a0
>>   xlog_ioend_work+0xef/0x1d0
>>   process_one_work+0x6f9/0xf70
>>   worker_thread+0x578/0xf30
>>   kthread+0x28c/0x330
>>   ret_from_fork+0x1f/0x30
>>   </TASK>
>>
>> Allocated by task 9606:
>>   kasan_save_stack+0x1e/0x40
>>   kasan_set_track+0x21/0x30
>>   __kasan_kmalloc+0x7a/0x90
>>   __kmalloc+0x59/0x140
>>   kmem_alloc+0xb2/0x2f0
>>   xfs_trans_ail_init+0x20/0x320
>>   xfs_log_mount+0x37e/0x690
>>   xfs_mountfs+0xe36/0x1b40
>>   xfs_fs_fill_super+0xc5c/0x1a70
>>   get_tree_bdev+0x3c5/0x6c0
>>   vfs_get_tree+0x85/0x250
>>   path_mount+0xec3/0x1830
>>   do_mount+0xef/0x110
>>   __x64_sys_mount+0x150/0x1f0
>>   do_syscall_64+0x35/0x80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> Freed by task 9662:
>>   kasan_save_stack+0x1e/0x40
>>   kasan_set_track+0x21/0x30
>>   kasan_save_free_info+0x2a/0x40
>>   __kasan_slab_free+0x105/0x1a0
>>   __kmem_cache_free+0x99/0x2d0
>>   kvfree+0x3a/0x40
>>   xfs_log_unmount+0x60/0xf0
>>   xfs_unmountfs+0xf3/0x1d0
>>   xfs_fs_put_super+0x78/0x300
>>   generic_shutdown_super+0x151/0x400
>>   kill_block_super+0x9a/0xe0
>>   deactivate_locked_super+0x82/0xe0
>>   deactivate_super+0x91/0xb0
>>   cleanup_mnt+0x32a/0x4a0
>>   task_work_run+0x15f/0x240
>>   exit_to_user_mode_prepare+0x188/0x190
>>   syscall_exit_to_user_mode+0x12/0x30
>>   do_syscall_64+0x42/0x80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> The buggy address belongs to the object at ffff888023169400
>>   which belongs to the cache kmalloc-128 of size 128
>> The buggy address is located 0 bytes inside of
>>   128-byte region [ffff888023169400, ffff888023169480)
>>
>> The buggy address belongs to the physical page:
>> page:ffffea00008c5a00 refcount:1 mapcount:0 mapping:0000000000000000
>> index:0xffff888023168f80 pfn:0x23168
>> head:ffffea00008c5a00 order:1 compound_mapcount:0 compound_pincount:0
>> flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
>> raw: 001fffff80010200 ffffea00006b3988 ffffea0000577a88 ffff88800f842ac0
>> raw: ffff888023168f80 0000000000150007 00000001ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff888023169300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>   ffff888023169380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff888023169400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                     ^
>>   ffff888023169480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>   ffff888023169500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
>> Disabling lock debugging due to kernel taint
>>
>> Fixes: cd6f79d1fb32 ("xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks")
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/xfs/xfs_log.c | 39 ++++++++++++++++++++++++++++-----------
>>   1 file changed, 28 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 0141d9907d31..a8dbd4caea51 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -82,6 +82,9 @@ STATIC int
>>   xlog_iclogs_empty(
>>   	struct xlog		*log);
>>   
>> +static void
>> +xfs_iclog_iodone_wait(struct xlog *log);
>> +
> Static functions used once don't need forward declarations.
OK,get it.
>>   static int
>>   xfs_log_cover(struct xfs_mount *);
>>   
>> @@ -888,6 +891,23 @@ xlog_force_iclog(
>>   	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
>>   }
>>   
>> +/*
>> + * Cycle all the iclogbuf locks to make sure all log IO completion
>> + * is done before we tear down these buffers.
>> + */
>> +static void
>> +xfs_iclog_iodone_wait(struct xlog *log)
> Hmm, if this is a function acting on a struct xlog (and not a struct
> xfs_mount) then this ought to be xlog_, right?
right, it will be named xlog_wait_iclog_completion.
> static inline void
> xlog_wait_iclog_completion(
> 	struct xlog		*log)
> {
> 	struct xlog_in_core	*iclog = log->l_iclog;
> 	int			i;
>
>
>> +{
>> +	int		i;
>> +	xlog_in_core_t	*iclog = log->l_iclog;
> Same "Don't add to the struct typedef usage" comment I've had since the
> start of this thread.
sorry,will fix it.
>> +
>> +	for (i = 0; i < log->l_iclog_bufs; i++) {
>> +		down(&iclog->ic_sema);
>> +		up(&iclog->ic_sema);
>> +		iclog = iclog->ic_next;
>> +	}
>> +}
>> +
>>   /*
>>    * Wait for the iclog and all prior iclogs to be written disk as required by the
>>    * log force state machine. Waiting on ic_force_wait ensures iclog completions
>> @@ -1113,6 +1133,14 @@ xfs_log_unmount(
>>   {
>>   	xfs_log_clean(mp);
>>   
>> +	/*
>> +	 * If shutdown has come from iclog IO context, the log
>> +	 * cleaning will have been skipped and so we need to wait
>> +	 * for ithe iclog to complete shutdown processing before we
>> +	 * tear anything down.
> Good comment though.
Yes, Dave deserve all the credit,copy from Dave's review comments. :)
> --D
>
>> +	 */
>> +	xfs_iclog_iodone_wait(mp->m_log);
>> +
>>   	xfs_buftarg_drain(mp->m_ddev_targp);
>>   
>>   	xfs_trans_ail_destroy(mp);
>> @@ -2115,17 +2143,6 @@ xlog_dealloc_log(
>>   	xlog_in_core_t	*iclog, *next_iclog;
>>   	int		i;
>>   
>> -	/*
>> -	 * Cycle all the iclogbuf locks to make sure all log IO completion
>> -	 * is done before we tear down these buffers.
>> -	 */
>> -	iclog = log->l_iclog;
>> -	for (i = 0; i < log->l_iclog_bufs; i++) {
>> -		down(&iclog->ic_sema);
>> -		up(&iclog->ic_sema);
>> -		iclog = iclog->ic_next;
>> -	}
>> -
>>   	/*
>>   	 * Destroy the CIL after waiting for iclog IO completion because an
>>   	 * iclog EIO error will try to shut down the log, which accesses the
>> -- 
>> 2.31.1
>>
> .

-- 
Guo Xuenan [OS Kernel Lab]
-----------------------------
Email: guoxuenan@huawei.com

