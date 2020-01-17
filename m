Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E4C33CB6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 03:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 601212087E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 03:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732818AbgAQDKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:10:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9183 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbgAQDKy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 22:10:54 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3586B95E7C1401982016;
        Fri, 17 Jan 2020 11:10:53 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 11:10:46 +0800
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
From:   "yukuai (C)" <yukuai3@huawei.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <jbacik@fusionio.com>,
        <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
References: <20200108092758.41363-1-yukuai3@huawei.com>
 <20200108162227.GD5552@magnolia>
 <3c7e9497-e0ed-23e4-ff9c-4b1c1a77c9fa@huawei.com>
 <20200109164615.GA8247@magnolia>
 <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
 <20200116160323.GC2149943@magnolia>
 <bc9afd0d-91e5-ef0a-94cb-599b8a57b136@huawei.com>
Message-ID: <da1c7dd8-b036-73fb-3a55-d2800f3f650e@huawei.com>
Date:   Fri, 17 Jan 2020 11:10:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bc9afd0d-91e5-ef0a-94cb-599b8a57b136@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/17 10:20, yukuai (C) wrote:
> After adding "-o 4", I tested over 200 times, and blocktrash never 
> failed to corrupt xattr anymore.

Unfortunately, test failed with more attempts:

_check_dmesg: something found in dmesg (see 
/root/xfstests-dev/results//xfs/126.dmesg)

[ 4597.649086] BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
[ 4597.649709] turning off the locking correctness validator.
[ 4597.650363] CPU: 4 PID: 377 Comm: kworker/4:1H Not tainted 5.5.0-rc6 #197
[ 4597.651027] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20180531_142017-buildhw-08.phx2.fedoraproject.org-1.fc28 04/01/2014
[ 4597.652276] Workqueue: xfs-log/sdb xlog_ioend_work
[ 4597.652803] Call Trace:
[ 4597.653109]  dump_stack+0xdd/0x13f
[ 4597.653573]  __lock_acquire.cold.46+0x7a/0x409
[ 4597.654000]  lock_acquire+0xf6/0x270
[ 4597.654487]  ? xlog_state_do_callback+0x1eb/0x4e0
[ 4597.654921]  _raw_spin_lock+0x45/0x70
[ 4597.655250]  ? xlog_state_do_callback+0x1eb/0x4e0
[ 4597.655666]  xlog_state_do_callback+0x1eb/0x4e0
[ 4597.656123]  xlog_state_done_syncing+0x8b/0x110
[ 4597.656727]  xlog_ioend_work+0x94/0x150
[ 4597.657210]  process_one_work+0x346/0x910
[ 4597.657714]  worker_thread+0x284/0x6d0
[ 4597.658125]  ? rescuer_thread+0x550/0x550
[ 4597.658647]  kthread+0x168/0x1a0
[ 4597.658931]  ? kthread_unpark+0xb0/0xb0
[ 4597.659470]  ret_from_fork+0x24/0x30

I wonder, could we increase the number of "-o 4" to fix this?

Thanks!
Yu Kuai

