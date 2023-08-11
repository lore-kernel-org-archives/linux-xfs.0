Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC0BEB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Aug 2023 06:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjHKGVX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 02:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjHKGVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2023 02:21:22 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FA32D48
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 23:21:19 -0700 (PDT)
Received: from kwepemi500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RMYYZ4dhRzkX3M;
        Fri, 11 Aug 2023 14:20:02 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemi500022.china.huawei.com (7.221.188.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 14:21:16 +0800
Message-ID: <ebfee92e-c8fa-c9bc-6093-7d8a06e48c88@huawei.com>
Date:   Fri, 11 Aug 2023 14:21:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] xfs: fix deadlock when set label online
To:     yangerkun <yangerkun@huaweicloud.com>,
        Dave Chinner <david@fromorbit.com>
CC:     <djwong@kernel.org>, <dchinner@redhat.com>, <sandeen@redhat.com>,
        <linux-xfs@vger.kernel.org>, <yukuai3@huawei.com>
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
 <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
 <c4f2edcd-efe2-2a96-316b-40f7ac95e6ce@huaweicloud.com>
 <ZJy9/9uqtTyS2fIA@dread.disaster.area>
 <4d6ee3b3-6d4b-ddb6-eb8e-e04a7e0c1ab0@huaweicloud.com>
 <ZJ4EkyxoxDYmf8rv@dread.disaster.area>
 <4139563b-8918-d89a-c926-4155228a12dc@huaweicloud.com>
From:   yangerkun <yangerkun@huawei.com>
In-Reply-To: <4139563b-8918-d89a-c926-4155228a12dc@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500022.china.huawei.com (7.221.188.64)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/6/30 10:19, yangerkun 写道:
> 
> 
> 在 2023/6/30 6:24, Dave Chinner 写道:
>> On Thu, Jun 29, 2023 at 07:55:10PM +0800, yangerkun wrote:
>>> 在 2023/6/29 7:10, Dave Chinner 写道:
>>>> On Tue, Jun 27, 2023 at 04:42:41PM +0800, yangerkun wrote:
>>>>> 在 2023/6/27 5:45, Dave Chinner 写道:
>>>>>> On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
>>>>>>> From: yangerkun <yangerkun@huawei.com>
>>>>>>>
>>>>>>> Combine use of xfs_trans_hold and xfs_trans_set_sync in 
>>>>>>> xfs_sync_sb_buf
>>>>>>> can trigger a deadlock once shutdown happened concurrently. 
>>>>>>> xlog_ioend_work
>>>>>>> will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
>>>>>>> xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to 
>>>>>>> unlock
>>>>>>> sb until been wakeup by xlog_ioend_work.
>>>>>>>
>>>>>>> xfs_sync_sb_buf
>>>>>>>      xfs_trans_getsb // lock sb buf
>>>>>>>      xfs_trans_bhold // sb buf keep lock until success commit
>>>>>>>      xfs_trans_commit
>>>>>>>      ...
>>>>>>>        xfs_log_force_seq
>>>>>>>          xlog_force_lsn
>>>>>>>            xlog_wait_on_iclog
>>>>>>>              xlog_wait(&iclog->ic_force_wait... // shutdown happened
>>>>>>>      xfs_buf_relse // unlock sb buf
>>>>>>>
>>>>>>> xlog_ioend_work
>>>>>>>      xlog_force_shutdown
>>>>>>>        xlog_state_shutdown_callbacks
>>>>>>>          xlog_cil_process_committed
>>>>>>>            xlog_cil_committed
>>>>>>>            ...
>>>>>>>            xfs_buf_item_unpin
>>>>>>>              xfs_buf_lock // deadlock
>>>>>>>          wake_up_all(&iclog->ic_force_wait)
>>>>>>>
>>>>>>> xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will 
>>>>>>> see the
>>>>>>> change for sb immediately. We can simply call 
>>>>>>> xfs_ail_push_all_sync to
>>>>>>> do this and sametime fix the deadlock.
>>>>>>
>>>>>> Why is this deadlock specific to the superblock buffer?
>>>>>
>>>>> Hi Dave,
>>>>>
>>>>> Thanks a lot for your revirew! We find this problem when do some code
>>>>> reading(which can help us to fix another growfs bug). And then 
>>>>> reproduce it
>>>>> easily when we set label online frequently with IO error inject at the
>>>>> sametime.
>>>>
>>>> Right, I know how it can be triggered; that's not actually my
>>>> concern...
>>>>
>>>>>> Can't any buffer that is held locked over a synchronous transaction
>>>>>> commit deadlock during a shutdown like this?
>>>>>
>>>>> After check all place use xfs_buf_bhold, it seems xfs_sync_sb_buf 
>>>>> is the
>>>>> only convict that combine use xfs_trans_hold and 
>>>>> xfs_trans_set_sync(I'm not
>>>>> familiar with xfs yet, so I may have some problems with my code 
>>>>> check)...
>>>>
>>>> Yes, I can also see that. But my concern is that this change only
>>>> addresses the symptom, but leaves the underlying deadlock unsolved.
>>>>
>>>> Indeed, this isn't xfs_trans_commit() I'm worried about here; it's
>>>> the call to xfs_log_force(mp, XFS_LOG_SYNC) or
>>>> xfs_log_force_seq(XFS_LOG_SYNC) with a buffer held locked that I'm
>>>> worried about.
>>>>
>>>> i.e. We have a buffer in the CIL (from a previous transaction) that
>>>> we currently hold locked while we call xfs_log_force(XFS_LOG_SYNC).
>>>> If a shutdown occurs while we are waiting for journal IO completion
>>>> to occur, then xlog_ioend_work() will attempt to lock the buffer and
>>>> deadlock, right?
>>>>
>>>> e.g. I'm thinking of things like busy extent flushing (hold AGF +
>>>> AGFL + AG btree blocks locked when we call xfs_log_force()) could
>>>> also be vulnerable to the same deadlock...
>>>
>>> You mean something like xfs_allocbt_alloc_block(call xfs_log_force to
>>> flush busy extent which keep agf locked sametime)?
>>>
>>> We call xfs_log_force(mp, XFS_LOG_SYNC) after lock agf and before
>>> xfs_trans_commit. It seems ok since xfs_buf_item_unpin will not call
>>> xfs_buf_lock because bli_refcount still keep active(once we hold locked
>>> agf, the bli_refcount will inc in _xfs_trans_bjoin, and keep it until
>>> xfs_trans_commit success(clean agf item) or .iop_unpin(dirty agf item,
>>> call from xlog_ioend_work) which can be called after xfs_trans_commit
>>> too)...
>>
>> Again, I gave an example of the class of issue I'm worried about.
>> Again, you chased the one example given through, but haven't
>> mentioned a thing about all the other code paths that lead to
>> xfs_log_force(SYNC) that might hold buffers locked that I didn't
>> mention.
>>
>> I don't want to have to ask every person who proposes a fix about
>> every possible code path the bug may manifest in -one at a time-.  I
>> use examples to point you in the right direction for further
>> analysis of the rest of the code base, not because that's the only
>> thing I want checked. Please use your initiative to look at all the
>> callers of xfs_log_force(SYNC) and determine if they are all safe or
>> whether there are landmines lurked or even more bugs of a similar
>> sort.
> 
> Hi Dave,
> 
> Thank you very much for pointing this out! I'm so sorry for the lack of
> awareness of a comprehensive investigation does there any other place
> can trigger the bug too...
> 
>>
>> When we learn about a new issue, this is the sort of audit work that
>> is necessary to determine the scope of the issue. We need to perform
>> such audits because they direct the scope of the fix necessary. We
>> are not interested in slapping a band-aid fix over the symptom that
>> was reported - that only leads to more band-aid fixes as the same
>> issue appears in other places.
> 
> Yes, agree with you and thanks for your advise, it can really help me to
> forbid a band-aid fix however leads to more band-aid fixes, so can
> contribute better!
> 
>>
>> Now we know there is a lock ordering problem in this code, so before
>> we attempt to fix it we need to know how widespread it is, what the
>> impact is, how different code paths avoid it, etc. That requires a
>> code audit to determine, and that requires looking at all the paths
>> into xfs_log_force(XFS_LOG_SYNC) to determine if they are safe or
>> not and documenting that.
>>
>> Yes, it's more work *right now* than slapping a quick band-aid fix
>> over it, but it's much less work in the long run for us and we don't
>> have to keep playing whack-a-mole because we fixed it the right way
>> the first time.
>>
> 
> I will try to look all paths into xfs_log_force(XFS_LOG_SYNC) or
> xfs_log_force_seq(XFS_LOG_SYNC) to check if it's safe or not. Thanks
> again for your advise!
> 
> Thanks,
> Yang Erkun.
> 
>> -Dave.
> 

Hi, Dave,

Sorry for the late reply, I was quiet busy last month and it also took 
me long time to check does all the callers of 
xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) was safe. I'm not familiar 
with xfs yet, so if there's anything wrong with the description below, 
please point it out!

The logic I choose was to check will we call 
xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) between 
xfs_buf_lock/xfs_buf_trylock and xfs_buf_unlock at the same thread 
context(I have check other item's .iop_unpin, it seems only xfs_buf item 
can trigger the problem since it will try to lock the buf in 
xfs_buf_item_unpin; besides, different thread context call for 
xfs_buf_lock&xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) and 
xfs_buf_unlock is safe too since this unlock will not wait until 
xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) success return), and once it 
happend, will we trigger the bug too?

I divide the logic of calling xfs_buf_lock/xfs_buf_trylock into two 
categories:

1. Later the xfs_buf will join the tp(xfs_trans_bjoin will inc 
.bli_refcount)

a. xfs_trans_bjoin will inc .bli_refcount
b. xfs_buf_item_pin will inc .bli_refcount when the item of xfs_buf was 
dirty
c. xfs_buf_item_committing will dec .bli_refcount no matter the item was 
dirty or not, and normally it will unlock the xfs_buf, or keep the 
xfs_buf locked when we see XFS_BLI_HOLD
d. xfs_buf_item_unpin will dec .bli_refcount, and it won't call 
xfs_buf_lock when another .bli_refcount exist

xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) can happend before we commit 
the tp(like xfs_create, it will first read&lock agi buf, then call 
xfs_dir_createname, which may trigger agfl fixup, the block allocation 
may see the busy extent and call xfs_log_force(SYNC) to flush the busy 
extent journal). It won't trigger the problem since xfs_trans_bjoin will 
keep another .bli_refcount.

xfs_log_force_seq(SYNC) can happend when we commit the tp since we see 
XFS_TRANS_SYNC(see __xfs_trans_commit), the only case we can trigger the 
deadlock was that we have combine called xfs_trans_bhold, or we will 
unlock xfs_buf in xfs_buf_item_committing. The case which this patch try 
to fix was the only case combine call for xfs_trans_bhold and set 
XFS_TRANS_SYNC.

After commit tp, xfs_buf will only keep locked because of 
xfs_trans_bhold, and once there is a XFS_TRANS_PERM_LOG_RES tp, we may 
trigger another commit, then xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) 
can happend too. But it is safe too since we will first rejoin xfs_buf 
to tp which help protect us.

2. The xfs_buf won't join the tp

xfs_buf_readahead_map
xfs_buf_read
xfs_buf_get
xfs_buf_incore
xfs_buf_delwri_cancel
xfs_buf_delwri_submit_buffers
xfs_buf_delwri_pushbuf
xfs_buf_item_unpin
xfs_iflush_shutdown_abort
xfs_log_quiesce
xlog_do_recover
xfs_freesb
xfs_add_incompat_log_feature
xfs_clear_incompat_log_features

Most case above was io, for xfs_buf_unlock called from another thread 
context, it is safe; for xfs_buf_unlock called from same thread context, 
it is safe too since we won't trigger 
xfs_log_force(SYNC)/xfs_log_force_seq(SYNC) between xfs_buf_lock and 
xfs_buf_unlock.


 From above, it seems only xfs_sync_sb_buf can trigger this deadlock... 
And I prefer to add some comments to xfs_trans_bhold to notice that 
there is a bug when combine use xfs_trans_bhold and 
xfs_log_force(SYNC)/xfs_log_force_seq(SYNC)...


Dave, sorry again for the late reply, and look forward to your reply!

Thanks,
Yang Erkun.
