Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB531C7618E
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Apr 2023 01:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjDWBpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Apr 2023 21:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDWBpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Apr 2023 21:45:12 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD0D170A
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 18:45:10 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q3rS51cG5z9v7QZ
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2023 09:35:33 +0800 (CST)
Received: from [10.174.177.238] (unknown [10.174.177.238])
        by APP2 (Coremail) with SMTP id BqC_BwA3a4WSjURk3rMWBg--.29803S2;
        Sun, 23 Apr 2023 01:44:55 +0000 (GMT)
Message-ID: <c8594f76-75c5-086c-989b-d8ec7e13c679@huaweicloud.com>
Date:   Sun, 23 Apr 2023 09:44:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 2/2] xfs: clean up some unnecessary xfs_stack_trace
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
References: <20230421113716.1890274-1-guoxuenan@huawei.com>
 <20230421113716.1890274-3-guoxuenan@huawei.com>
 <20230422035720.GN360889@frogsfrogsfrogs>
From:   Guo Xuenan <guoxuenan@huaweicloud.com>
In-Reply-To: <20230422035720.GN360889@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: BqC_BwA3a4WSjURk3rMWBg--.29803S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr18Gw4DWrWfWw1rAr4Dtwb_yoW5ArWkpF
        n7A3Z0kr4vyryYkry7Jr1Iq3Z8tryvkr10krn5AF1Sqw1DtrnFyFy0yw10g3srCr4vvw4S
        qF1kZw17Ww4rXa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
        6r4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r1j6r
        4UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
        r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUU
        U==
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,
On 2023/4/22 11:57, Darrick J. Wong wrote:
> On Fri, Apr 21, 2023 at 07:37:16PM +0800, Guo Xuenan wrote:
>> With xfs print level parsing correctly, these duplicate dump
>> information can be removed.
>>
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_ialloc.c | 1 -
>>   fs/xfs/xfs_error.c         | 9 ---------
>>   fs/xfs/xfs_fsops.c         | 2 --
>>   fs/xfs/xfs_log.c           | 2 --
>>   4 files changed, 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
>> index a16d5de16933..df4e4eb19f14 100644
>> --- a/fs/xfs/libxfs/xfs_ialloc.c
>> +++ b/fs/xfs/libxfs/xfs_ialloc.c
>> @@ -2329,7 +2329,6 @@ xfs_imap(
>>   				__func__, ino,
>>   				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
>>   		}
>> -		xfs_stack_trace();
> Hmm, this one was unconditional, wasn't it?  That looks like an omission
> to me, so I'm calling it out in case anyone had hard opinions about it.
> Otherwise,
It is unnecessary, since there are xfs_alert to report failure here.
if really need to get stack information, set error_level is enough, because
both of conditional branch have xfs_alert. To avoid repetition, in my 
opinion,
it's better to be removed.

Thanks
Xuenan
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> --D
>
>>   #endif /* DEBUG */
>>   		return error;
>>   	}
>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>> index b2cbbba3e15a..7c8e1f3b69a6 100644
>> --- a/fs/xfs/xfs_error.c
>> +++ b/fs/xfs/xfs_error.c
>> @@ -421,9 +421,6 @@ xfs_buf_corruption_error(
>>   		  fa, bp->b_ops->name, xfs_buf_daddr(bp));
>>   
>>   	xfs_alert(mp, "Unmount and run xfs_repair");
>> -
>> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
>> -		xfs_stack_trace();
>>   }
>>   
>>   /*
>> @@ -459,9 +456,6 @@ xfs_buf_verifier_error(
>>   				sz);
>>   		xfs_hex_dump(buf, sz);
>>   	}
>> -
>> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
>> -		xfs_stack_trace();
>>   }
>>   
>>   /*
>> @@ -509,7 +503,4 @@ xfs_inode_verifier_error(
>>   				sz);
>>   		xfs_hex_dump(buf, sz);
>>   	}
>> -
>> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
>> -		xfs_stack_trace();
>>   }
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 13851c0d640b..e08b1ce109d9 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -546,8 +546,6 @@ xfs_do_force_shutdown(
>>   			why, flags, __return_address, fname, lnnum);
>>   	xfs_alert(mp,
>>   		"Please unmount the filesystem and rectify the problem(s)");
>> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
>> -		xfs_stack_trace();
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index fc61cc024023..e4e4da33281d 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -3808,8 +3808,6 @@ xlog_force_shutdown(
>>   				shutdown_flags);
>>   		xfs_alert(log->l_mp,
>>   "Please unmount the filesystem and rectify the problem(s).");
>> -		if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
>> -			xfs_stack_trace();
>>   	}
>>   
>>   	/*
>> -- 
>> 2.31.1
>>

