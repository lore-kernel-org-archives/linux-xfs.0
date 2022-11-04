Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8CBC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 07:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiKDHvK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 03:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDHvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 03:51:10 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7593227FF9
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 00:50:48 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N3Xm62gxhzJnTR;
        Fri,  4 Nov 2022 15:47:50 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 15:50:45 +0800
Message-ID: <2a37079d-58c4-594a-b40b-53a28f782764@huawei.com>
Date:   Fri, 4 Nov 2022 15:50:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH 1/2] xfs: wait xlog ioend workqueue drained before tearing
 down AIL
To:     Dave Chinner <david@fromorbit.com>
CC:     <djwong@kernel.org>, <dchinner@redhat.com>,
        <linux-xfs@vger.kernel.org>, <houtao1@huawei.com>,
        <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
References: <20221103083632.150458-1-guoxuenan@huawei.com>
 <20221103083632.150458-2-guoxuenan@huawei.com>
 <20221103211651.GH3600936@dread.disaster.area>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <20221103211651.GH3600936@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi，Dave：
On 2022/11/4 5:16, Dave Chinner wrote:
> On Thu, Nov 03, 2022 at 04:36:31PM +0800, Guo Xuenan wrote:
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
> So we are still processing an iclog at this point and have it
> locked (iclog->ic_sema is held). These aren't cycled to wait for
> all processing to complete until xlog_dealloc_log() before they are
> freed.
>
> If we cycle through the iclog->ic_sema locks when we quiesce the log
> (as we should be doing before attempting to write an unmount record)
> this UAF problem goes away, right?
Yes，:) right！According to the method you said, we can also solve this 
problem.
The key to sloving this problem is to make sure that all log IO is done 
before
tearing down AIL.
>
>> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
>> index f51df7d94ef7..1054adb29907 100644
>> --- a/fs/xfs/xfs_trans_ail.c
>> +++ b/fs/xfs/xfs_trans_ail.c
>> @@ -929,6 +929,9 @@ xfs_trans_ail_destroy(
>>   {
>>   	struct xfs_ail	*ailp = mp->m_ail;
>>   
>> +	drain_workqueue(mp->m_log->l_ioend_workqueue);
>> +	xfs_ail_push_all_sync(ailp);
> This isn't the place to be draining the AIL and waiting for IO to
> complete. As per above, that should have been done long before we
> get here...
I'm agree with your opinion,but, I have verified that it can indeed 
solve the UAF.
And, I also verify the way you suggested, it is equally effective.
But, I have no better idea where to place this check, hope for your 
better suggestions.
Here I provide a way for reference,would you kindly consider the 
following modifications,
thanks in advance :)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f02a0dd522b3..4e48cc3ba6da 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1094,8 +1094,22 @@ void
  xfs_log_clean(
         struct xfs_mount        *mp)
  {
+       struct xlog     *log = mp->m_log;
+       xlog_in_core_t  *iclog = log->l_iclog;
+       int             i;
+
         xfs_log_quiesce(mp);
         xfs_log_unmount_write(mp);
+
+       /*
+        * Cycle all the iclogbuf locks to make sure all log IO completion
+        * is done before we tear down AIL.
+        */
+       for (i = 0; i < log->l_iclog_bufs; i++) {
+               down(&iclog->ic_sema);
+               up(&iclog->ic_sema);
+               iclog = iclog->ic_next;
+       }
  }

Best regards
Xuenan
> -Dave.

-- 
Guo Xuenan [OS Kernel Lab]
-----------------------------
Email: guoxuenan@huawei.com

