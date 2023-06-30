Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475A5EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jun 2023 02:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjF3CUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 22:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjF3CUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 22:20:01 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4292F30EF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 19:19:58 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QsfCt1mz5z4f41G4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2023 10:19:54 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
        by APP2 (Coremail) with SMTP id Syh0CgDHuujJO55kC4YTMw--.57787S3;
        Fri, 30 Jun 2023 10:19:54 +0800 (CST)
Message-ID: <4139563b-8918-d89a-c926-4155228a12dc@huaweicloud.com>
Date:   Fri, 30 Jun 2023 10:19:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] xfs: fix deadlock when set label online
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
 <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
 <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
 <ZJy9/9uqtTyS2fIA@dread.disaster.area>
 <4d6ee3b3-6d4b-ddb6-eb8e-e04a7e0c1ab0@huaweicloud.com>
 <ZJ4EkyxoxDYmf8rv@dread.disaster.area>
From:   yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <ZJ4EkyxoxDYmf8rv@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgDHuujJO55kC4YTMw--.57787S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFWkuFyDZrWfKr1DGFWxWFg_yoWxJw1xpr
        Z0kF13Kr4DKr4I9rn2yw1jq3Wrtw1rJr4DXr1Ygr1Fvas0vr1xKFyFgw1agF9rurs3Gw4j
        vr10v3s7Xwn8ua7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/6/30 6:24, Dave Chinner 写道:
> On Thu, Jun 29, 2023 at 07:55:10PM +0800, yangerkun wrote:
>> 在 2023/6/29 7:10, Dave Chinner 写道:
>>> On Tue, Jun 27, 2023 at 04:42:41PM +0800, yangerkun wrote:
>>>> 在 2023/6/27 5:45, Dave Chinner 写道:
>>>>> On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
>>>>>> From: yangerkun <yangerkun@huawei.com>
>>>>>>
>>>>>> Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
>>>>>> can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
>>>>>> will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
>>>>>> xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
>>>>>> sb until been wakeup by xlog_ioend_work.
>>>>>>
>>>>>> xfs_sync_sb_buf
>>>>>>      xfs_trans_getsb // lock sb buf
>>>>>>      xfs_trans_bhold // sb buf keep lock until success commit
>>>>>>      xfs_trans_commit
>>>>>>      ...
>>>>>>        xfs_log_force_seq
>>>>>>          xlog_force_lsn
>>>>>>            xlog_wait_on_iclog
>>>>>>              xlog_wait(&iclog->ic_force_wait... // shutdown happened
>>>>>>      xfs_buf_relse // unlock sb buf
>>>>>>
>>>>>> xlog_ioend_work
>>>>>>      xlog_force_shutdown
>>>>>>        xlog_state_shutdown_callbacks
>>>>>>          xlog_cil_process_committed
>>>>>>            xlog_cil_committed
>>>>>>            ...
>>>>>>            xfs_buf_item_unpin
>>>>>>              xfs_buf_lock // deadlock
>>>>>>          wake_up_all(&iclog->ic_force_wait)
>>>>>>
>>>>>> xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
>>>>>> change for sb immediately. We can simply call xfs_ail_push_all_sync to
>>>>>> do this and sametime fix the deadlock.
>>>>>
>>>>> Why is this deadlock specific to the superblock buffer?
>>>>
>>>> Hi Dave,
>>>>
>>>> Thanks a lot for your revirew! We find this problem when do some code
>>>> reading(which can help us to fix another growfs bug). And then reproduce it
>>>> easily when we set label online frequently with IO error inject at the
>>>> sametime.
>>>
>>> Right, I know how it can be triggered; that's not actually my
>>> concern...
>>>
>>>>> Can't any buffer that is held locked over a synchronous transaction
>>>>> commit deadlock during a shutdown like this?
>>>>
>>>> After check all place use xfs_buf_bhold, it seems xfs_sync_sb_buf is the
>>>> only convict that combine use xfs_trans_hold and xfs_trans_set_sync(I'm not
>>>> familiar with xfs yet, so I may have some problems with my code check)...
>>>
>>> Yes, I can also see that. But my concern is that this change only
>>> addresses the symptom, but leaves the underlying deadlock unsolved.
>>>
>>> Indeed, this isn't xfs_trans_commit() I'm worried about here; it's
>>> the call to xfs_log_force(mp, XFS_LOG_SYNC) or
>>> xfs_log_force_seq(XFS_LOG_SYNC) with a buffer held locked that I'm
>>> worried about.
>>>
>>> i.e. We have a buffer in the CIL (from a previous transaction) that
>>> we currently hold locked while we call xfs_log_force(XFS_LOG_SYNC).
>>> If a shutdown occurs while we are waiting for journal IO completion
>>> to occur, then xlog_ioend_work() will attempt to lock the buffer and
>>> deadlock, right?
>>>
>>> e.g. I'm thinking of things like busy extent flushing (hold AGF +
>>> AGFL + AG btree blocks locked when we call xfs_log_force()) could
>>> also be vulnerable to the same deadlock...
>>
>> You mean something like xfs_allocbt_alloc_block(call xfs_log_force to
>> flush busy extent which keep agf locked sametime)?
>>
>> We call xfs_log_force(mp, XFS_LOG_SYNC) after lock agf and before
>> xfs_trans_commit. It seems ok since xfs_buf_item_unpin will not call
>> xfs_buf_lock because bli_refcount still keep active(once we hold locked
>> agf, the bli_refcount will inc in _xfs_trans_bjoin, and keep it until
>> xfs_trans_commit success(clean agf item) or .iop_unpin(dirty agf item,
>> call from xlog_ioend_work) which can be called after xfs_trans_commit
>> too)...
> 
> Again, I gave an example of the class of issue I'm worried about.
> Again, you chased the one example given through, but haven't
> mentioned a thing about all the other code paths that lead to
> xfs_log_force(SYNC) that might hold buffers locked that I didn't
> mention.
> 
> I don't want to have to ask every person who proposes a fix about
> every possible code path the bug may manifest in -one at a time-.  I
> use examples to point you in the right direction for further
> analysis of the rest of the code base, not because that's the only
> thing I want checked. Please use your initiative to look at all the
> callers of xfs_log_force(SYNC) and determine if they are all safe or
> whether there are landmines lurked or even more bugs of a similar
> sort.

Hi Dave,

Thank you very much for pointing this out! I'm so sorry for the lack of
awareness of a comprehensive investigation does there any other place
can trigger the bug too...

> 
> When we learn about a new issue, this is the sort of audit work that
> is necessary to determine the scope of the issue. We need to perform
> such audits because they direct the scope of the fix necessary. We
> are not interested in slapping a band-aid fix over the symptom that
> was reported - that only leads to more band-aid fixes as the same
> issue appears in other places.

Yes, agree with you and thanks for your advise, it can really help me to
forbid a band-aid fix however leads to more band-aid fixes, so can
contribute better!

> 
> Now we know there is a lock ordering problem in this code, so before
> we attempt to fix it we need to know how widespread it is, what the
> impact is, how different code paths avoid it, etc. That requires a
> code audit to determine, and that requires looking at all the paths
> into xfs_log_force(XFS_LOG_SYNC) to determine if they are safe or
> not and documenting that.
> 
> Yes, it's more work *right now* than slapping a quick band-aid fix
> over it, but it's much less work in the long run for us and we don't
> have to keep playing whack-a-mole because we fixed it the right way
> the first time.
> 

I will try to look all paths into xfs_log_force(XFS_LOG_SYNC) or
xfs_log_force_seq(XFS_LOG_SYNC) to check if it's safe or not. Thanks
again for your advise!

Thanks,
Yang Erkun.

> -Dave.

