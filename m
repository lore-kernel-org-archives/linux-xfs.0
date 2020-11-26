Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAA1C63798
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 03:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 874EC21534
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Nov 2020 03:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732797AbgKZDFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 22:05:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7990 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732425AbgKZDFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 22:05:10 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ChN0N5WKmzhYKZ;
        Thu, 26 Nov 2020 11:04:52 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 11:05:04 +0800
Subject: Re: [PATCH] xfs: check the return value of krealloc() in
 xfs_uuid_mount
To:     Gao Xiang <hsiangkao@redhat.com>
CC:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201125065036.154312-1-miaoqinglang@huawei.com>
 <365b952c-7fea-3bc2-55ea-3f6b1c9f9142@sandeen.net>
 <9f998a9d-0684-6b45-009e-acf2e0ac4c85@huawei.com>
 <20201126021622.GA336866@xiangao.remote.csb>
From:   Qinglang Miao <miaoqinglang@huawei.com>
Message-ID: <5d6b6f6f-4bc3-2821-d5b1-569afba0221a@huawei.com>
Date:   Thu, 26 Nov 2020 11:05:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20201126021622.GA336866@xiangao.remote.csb>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2020/11/26 10:16, Gao Xiang 写道:
> Hi Qinglang,
> 
> On Thu, Nov 26, 2020 at 09:21:11AM +0800, Qinglang Miao wrote:
>>
>>
>> 在 2020/11/25 23:55, Eric Sandeen 写道:
>>> On 11/25/20 12:50 AM, Qinglang Miao wrote:
>>>> krealloc() may fail to expand the memory space.
>>>
>>> Even with __GFP_NOFAIL?
>>>
>>>     * ``GFP_KERNEL | __GFP_NOFAIL`` - overrides the default allocator behavior
>>>       and all allocation requests will loop endlessly until they succeed.
>>>       This might be really dangerous especially for larger orders.
>>>
>>>> Add sanity checks to it,
>>>> and WARN() if that really happened.
>>>
>>> As aside, there is no WARN added in this patch for a memory failure.
>>>
>>>> Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
>>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>>>> ---
>>>>    fs/xfs/xfs_mount.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>>>> index 150ee5cb8..c07f48c32 100644
>>>> --- a/fs/xfs/xfs_mount.c
>>>> +++ b/fs/xfs/xfs_mount.c
>>>> @@ -80,9 +80,13 @@ xfs_uuid_mount(
>>>>    	}
>>>>    	if (hole < 0) {
>>>> -		xfs_uuid_table = krealloc(xfs_uuid_table,
>>>> +		uuid_t *if_xfs_uuid_table;
>>>> +		if_xfs_uuid_table = krealloc(xfs_uuid_table,
>>>>    			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
>>>>    			GFP_KERNEL | __GFP_NOFAIL);
>>>> +		if (!if_xfs_uuid_table)
>>>> +			goto out_duplicate;
>>>
>>> And this would emit "Filesystem has duplicate UUID" which is not correct.
>>>
>>> But anyway, the __GFP_NOFAIL in the call makes this all moot AFAICT.
>>>
>>> -Eric
>> Hi Eric,
>>
>> Sorry for neglecting __GFP_NOFAIL symbol, and I would add a WARN in memory
>> failure next time.
> 
> Sorry about my limited knowledge, but why it needs a WARN here since
> I think it will never fail if __GFP_NOFAIL is added (no ?).
'next time' means next time when I send patches related to memory 
failure, not on this one. Sorry for making confusing to you.
> 
> I'm not sure if Hulk CI is completely broken or not on this, also if
> such CI can now generate trivial patch (?) since the subject, commit
> message and even the variable name is quite similiar to
> https://lore.kernel.org/linux-xfs/20201124104531.561-2-thunder.leizhen@huawei.com
> in a day.
> 
> And it'd be better to look into the code before sending patches...
Yeah..  I should pay more attension.
> 
> Thanks,
> Gao Xiang >
Thanks for your advice~
>>
>> Thanks for your advice！
>>
> 
> .
> 
