Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318BCC56202
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 01:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C487D20770
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 01:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgKZBVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:21:18 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8589 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730762AbgKZBVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 20:21:18 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ChKhH5ZwGzLvWM;
        Thu, 26 Nov 2020 09:20:47 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 09:21:11 +0800
Subject: Re: [PATCH] xfs: check the return value of krealloc() in
 xfs_uuid_mount
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <20201125065036.154312-1-miaoqinglang@huawei.com>
 <365b952c-7fea-3bc2-55ea-3f6b1c9f9142@sandeen.net>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <9f998a9d-0684-6b45-009e-acf2e0ac4c85@huawei.com>
Date:   Thu, 26 Nov 2020 09:21:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <365b952c-7fea-3bc2-55ea-3f6b1c9f9142@sandeen.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2020/11/25 23:55, Eric Sandeen 写道:
> On 11/25/20 12:50 AM, Qinglang Miao wrote:
>> krealloc() may fail to expand the memory space.
> 
> Even with __GFP_NOFAIL?
> 
>    * ``GFP_KERNEL | __GFP_NOFAIL`` - overrides the default allocator behavior
>      and all allocation requests will loop endlessly until they succeed.
>      This might be really dangerous especially for larger orders.
> 
>> Add sanity checks to it,
>> and WARN() if that really happened.
> 
> As aside, there is no WARN added in this patch for a memory failure.
> 
>> Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>> ---
>>   fs/xfs/xfs_mount.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index 150ee5cb8..c07f48c32 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -80,9 +80,13 @@ xfs_uuid_mount(
>>   	}
>>   
>>   	if (hole < 0) {
>> -		xfs_uuid_table = krealloc(xfs_uuid_table,
>> +		uuid_t *if_xfs_uuid_table;
>> +		if_xfs_uuid_table = krealloc(xfs_uuid_table,
>>   			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
>>   			GFP_KERNEL | __GFP_NOFAIL);
>> +		if (!if_xfs_uuid_table)
>> +			goto out_duplicate;
> 
> And this would emit "Filesystem has duplicate UUID" which is not correct.
> 
> But anyway, the __GFP_NOFAIL in the call makes this all moot AFAICT.
> 
> -Eric
Hi Eric,

Sorry for neglecting __GFP_NOFAIL symbol, and I would add a WARN in 
memory failure next time.

Thanks for your advice！
> 
>> +		xfs_uuid_table = if_xfs_uuid_table;
>>   		hole = xfs_uuid_table_size++;
>>   	}
>>   	xfs_uuid_table[hole] = *uuid;
>>
> .
> 
