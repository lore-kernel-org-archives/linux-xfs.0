Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC22C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 07:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjEHHsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 03:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjEHHse (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 03:48:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD68171F
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 00:48:32 -0700 (PDT)
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QFCzN079QzsRGW;
        Mon,  8 May 2023 15:46:39 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 15:48:29 +0800
Message-ID: <6427e6e1-26e5-18b9-f1f5-bbb0765be340@huawei.com>
Date:   Mon, 8 May 2023 15:48:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] xfs: fix xfs_buf use-after-free in xfs_buf_item_unpin
To:     Dave Chinner <david@fromorbit.com>,
        yangerkun <yangerkun@huaweicloud.com>
CC:     <djwong@kernel.org>, <bfoster@redhat.com>,
        <linux-xfs@vger.kernel.org>
References: <20230420033550.339934-1-yangerkun@huaweicloud.com>
 <20230508033406.GQ3223426@dread.disaster.area>
From:   yangerkun <yangerkun@huawei.com>
In-Reply-To: <20230508033406.GQ3223426@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500022.china.huawei.com (7.221.188.64)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/5/8 11:34, Dave Chinner 写道:
> Hi yangerkun,
> 
> Sorry to take so long to get to this, I've been busy with other
> stuff and I needed to do some thinking on it first.
> 
> On Thu, Apr 20, 2023 at 11:35:50AM +0800, yangerkun wrote:
>> From: yangerkun <yangerkun@huawei.com>
>>
>> commit 84d8949e7707 ("xfs: hold buffer across unpin and potential
>> shutdown processing") describle a use-after-free bug show as follow.
>> Call xfs_buf_hold before dec b_pin_count can forbid the problem.
>>
>>     +-----------------------------+--------------------------------+
>>       xlog_ioend_work             | xfsaild
>>       ...                         |  xfs_buf_delwri_submit_buffers
>>        xfs_buf_item_unpin         |
>>         dec &bip->bli_refcount    |
>>         dec &bp->b_pin_count      |
>>                                   |  // check unpin and go on
>>                                   |  __xfs_buf_submit
>>                                   |  xfs_buf_ioend_fail // shutdown
>>                                   |  xfs_buf_ioend
>>                                   |  xfs_buf_relse
>>                                   |  xfs_buf_free(bp)
>>         xfs_buf_lock(bp) // UAF   |
>>
>> However with the patch, we still get a UAF with shutdown:
>>
>>     +-----------------------------+--------------------------------+
>>       xlog_ioend_work             |  xlog_cil_push_work // now shutdown
>>       ...                         |   xlog_cil_committed
>>        xfs_buf_item_unpin         |    ...
>>        // bli_refcount = 2        |
>>        dec bli_refcount // 1      |    xfs_buf_item_unpin
>>                                   |    dec bli_refcount // 0,will free
>>                                   |    xfs_buf_ioend_fail // free bp
>>        dec b_pin_count // UAF     |
> 
> Ok, so the race condition here is that we have two callers racing to
> run xlog_cil_committed(). We have xlog_ioend_work() doing the
> shutdown callbacks for checkpoint contexts that have been aborted
> after submission, and xlog_cil_push_work aborting a checkpoint
> context before it has been submitted.
> 
>> xlog_cil_push_work will call xlog_cil_committed once we meet some error
>> like shutdown, and then call xfs_buf_item_unpin with 'remove' equals 1.
>> xlog_ioend_work can happened same time which trigger xfs_buf_item_unpin
>> too, and then bli_refcount will down to zero which trigger
>> xfs_buf_ioend_fail that free the xfs_buf, so the UAF can trigger.
>>
>> Fix it by call xfs_buf_hold before dec bli_refcount, and release the
>> hold once we actually do not need it.
> 
> Ok, that works.
> 
> However, adding an unconditional buffer reference to each unpin call
> so that we can safely reference the buffer after we're released the
> BLI indicates that the BLI buffer reference is not guaranteeing
> buffer existence once the bli reference for the current pin the bli
> holds.
> 
> Which means that we need a buffer reference per pin count that is
> added. We can then hold that buffer reference in the unpin
> processing until we don't need it anymore, and we cover all the
> known cases (and any unknown cases) without needing special case
> code?
> 
> Say, something like the (untested) patch I've attached below?

Hi Dave,

This solution looks great to me! I will run the testcase trigger the uaf 
with your patch!

Thanks,
yangerkun.

> 
> Cheers,
> 
> Dave.
