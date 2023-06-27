Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673B8EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 08:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjF0InC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjF0Im6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 04:42:58 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2112B1718
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 01:42:46 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qqyrx5szSz4f3pG1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 16:42:41 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
        by APP4 (Coremail) with SMTP id gCh0CgD3mp4BoZpkaU6SMg--.64134S3;
        Tue, 27 Jun 2023 16:42:42 +0800 (CST)
Message-ID: <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
Date:   Tue, 27 Jun 2023 16:42:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] xfs: fix deadlock when set label online
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
 <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
From:   yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3mp4BoZpkaU6SMg--.64134S3
X-Coremail-Antispam: 1UD129KBjvJXoW7trW7CFyruFWfJF1ftr4UCFg_yoW8Zr4Upr
        ZYkr9rGrnxXrZa9rn2yr42qa4FyF15Ja18Grs8KrnY9a45ur1SgFWaqFWagF9rCrs7Gr4q
        y34jvas5Cw15Ca7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/6/27 5:45, Dave Chinner 写道:
> On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
>> From: yangerkun <yangerkun@huawei.com>
>>
>> Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
>> can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
>> will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
>> xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
>> sb until been wakeup by xlog_ioend_work.
>>
>> xfs_sync_sb_buf
>>    xfs_trans_getsb // lock sb buf
>>    xfs_trans_bhold // sb buf keep lock until success commit
>>    xfs_trans_commit
>>    ...
>>      xfs_log_force_seq
>>        xlog_force_lsn
>>          xlog_wait_on_iclog
>>            xlog_wait(&iclog->ic_force_wait... // shutdown happened
>>    xfs_buf_relse // unlock sb buf
>>
>> xlog_ioend_work
>>    xlog_force_shutdown
>>      xlog_state_shutdown_callbacks
>>        xlog_cil_process_committed
>>          xlog_cil_committed
>>          ...
>>          xfs_buf_item_unpin
>>            xfs_buf_lock // deadlock
>>        wake_up_all(&iclog->ic_force_wait)
>>
>> xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
>> change for sb immediately. We can simply call xfs_ail_push_all_sync to
>> do this and sametime fix the deadlock.
> 
> Why is this deadlock specific to the superblock buffer?

Hi Dave,

Thanks a lot for your revirew! We find this problem when do some code 
reading(which can help us to fix another growfs bug). And then reproduce 
it easily when we set label online frequently with IO error inject at 
the sametime.

> 
> Can't any buffer that is held locked over a synchronous transaction
> commit deadlock during a shutdown like this?

After check all place use xfs_buf_bhold, it seems xfs_sync_sb_buf is the 
only convict that combine use xfs_trans_hold and xfs_trans_set_sync(I'm 
not familiar with xfs yet, so I may have some problems with my code 
check)...

Thanks,
Yang Erkun.
> 
> Cheers,
> 
> Dave.

