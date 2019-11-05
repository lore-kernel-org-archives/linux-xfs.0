Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FC5CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41AE420818
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 03:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfKED0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 22:26:44 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:41724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728910AbfKED0o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 22:26:44 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D9A1CBC211F550606EFA;
        Tue,  5 Nov 2019 11:26:41 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 5 Nov 2019
 11:26:32 +0800
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
To:     Dave Chinner <david@fromorbit.com>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
Date:   Tue, 5 Nov 2019 11:26:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20191104204909.GB4614@dread.disaster.area>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 2019/11/5 4:49, Dave Chinner wrote:
> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
>> From: Yang Guo <guoyang2@huawei.com>
>>
>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
>> whether the counter less than 0 and it is a expensive function.
>> let's check it only when delta < 0, it will be good for xfs's performance.
> 
> Hmmm. I don't recall this as being expensive.
> 

Sorry about the misunderstanding information in commit message.

> How did you find this? Can you please always document how you found

If user creates million of files and the delete them, We found that the
__percpu_counter_compare costed 5.78% CPU usage, you are right that itself
is not expensive, but it calls __percpu_counter_sum which will use
spin_lock and read other cpu's count. perf record -g is used to profile it:

- 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
   - 5.86% xfs_mod_ifree
      - 5.78% __percpu_counter_compare
           5.61% __percpu_counter_sum

> the problem being addressed in the commit message so that we don't
> then have to ask how the problem being fixed is reproduced.
> 
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Signed-off-by: Yang Guo <guoyang2@huawei.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>>  fs/xfs/xfs_mount.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index ba5b6f3b2b88..5e8314e6565e 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -1174,6 +1174,9 @@ xfs_mod_icount(
>>  	int64_t			delta)
>>  {
>>  	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
>> +	if (delta > 0)
>> +		return 0;
>> +
>>  	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
>>  		ASSERT(0);
>>  		percpu_counter_add(&mp->m_icount, -delta);
> 
> I struggle to see how this is expensive when you have more than
> num_online_cpus() * XFS_ICOUNT_BATCH inodes allocated.
> __percpu_counter_compare() will always take the fast path so ends up
> being very little code at all.
> 
>> @@ -1188,6 +1191,9 @@ xfs_mod_ifree(
>>  	int64_t			delta)
>>  {
>>  	percpu_counter_add(&mp->m_ifree, delta);
>> +	if (delta > 0)
>> +		return 0;
>> +
>>  	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
>>  		ASSERT(0);
>>  		percpu_counter_add(&mp->m_ifree, -delta);
> 
> This one might have some overhead because the count is often at or
> around zero, but I haven't noticed it being expensive in kernel
> profiles when creating/freeing hundreds of thousands of inodes every
> second.
> 
> IOWs, we typically measure the overhead of such functions by kernel
> profile.  Creating ~200,000 inodes a second, so hammering the icount
> and ifree counters, I see:
> 
>       0.16%  [kernel]  [k] percpu_counter_add_batch
>       0.03%  [kernel]  [k] __percpu_counter_compare
> 

0.03% is just __percpu_counter_compare's usage.

> Almost nothing - it's way down the long tail of noise in the
> profile.
> 
> IOWs, the CPU consumed by percpu_counter_compare() is low that
> optimisation isn't going to produce any measurable performance
> improvement. Hence it's not really something we've concerned
> ourselves about.  The profile is pretty much identical for removing
> hundreds of thousands of files a second, too, so there really isn't
> any performance gain to be had here.
> 
> If you want to optimise code to make it faster and show a noticable
> performance improvement, start by running kernel profiles while your
> performance critical workload is running. Then look at what the
> functions and call chains that consume the most CPU and work out how
> to do them better. Those are the places that optimisation will
> result in measurable performance gains....

Hmm, I have done it and I didn't describe this problem clearly, with this
patch, 5.78%(__percpu_counter_compare) will disappear. I will follow
your method and reduce unnecessary noise.

Thanks,
Shaokun

> 
> Cheers,
> 
> Dave.
> 

