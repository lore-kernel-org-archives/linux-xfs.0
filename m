Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03472372;
	Fri, 16 Aug 2024 01:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723772249; cv=none; b=lZsSvKGpt2EsKBtLSFLkyc1HUbHzbxghcpm60dIaQUcNb7zdoe0XkwkNP3shBqQtjihP+vddNnRISEM0J+nC4bzvBWO8Rbwln6YfxjbicZJJiaHctVj/xMaUhRNE7nOSEXig/M7Vq+NXGfPsR3EEfnJ8EwisuXPrIBQrJciNLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723772249; c=relaxed/simple;
	bh=z+lsAwsip94Z2fFceHUQZ/+28SOZl6Dhef5zkAGCVBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GAvfbuMhloRygLxDuaC8CC+FBcFwJfGJ//9oRz/aYeSDGi9RIN3V1FINOk9dyuS3NbK83huYPCOjZLYqH+X6TDDcy2KGUcwekmNHJVk5lT8V4V6mpbY0J1xwJvNT0/y3898SKzmmh7mcQtPp3r36u9vFrJTGxNFHb+lClHyg/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WlPcS1Vmzz1j6Sb;
	Fri, 16 Aug 2024 09:32:24 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B7D41A0188;
	Fri, 16 Aug 2024 09:37:18 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Aug 2024 09:37:17 +0800
Message-ID: <35611fba-98b7-4fa3-8108-ee0785d29cef@huawei.com>
Date: Fri, 16 Aug 2024 09:37:16 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] xfs: Fix missing interval for missing_owner in xfs
 fsmap
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240812011505.1414130-1-wozizhi@huawei.com>
 <20240812011505.1414130-3-wozizhi@huawei.com>
 <20240815174229.GI865349@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240815174229.GI865349@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/8/16 1:42, Darrick J. Wong 写道:
> On Mon, Aug 12, 2024 at 09:15:05AM +0800, Zizhi Wo wrote:
>> In the fsmap query of xfs, there is an interval missing problem:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>>   EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
>>     0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
>>     1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
>>     2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
>>     3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
>>     4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
>>     5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
>>     6: 253:16 [104..127]:           free space                          0  (104..127)               24
>>     ......
>>
>> BUG:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
>> [root@fedora ~]#
>> Normally, we should be able to get [104, 107), but we got nothing.
>>
>> The problem is caused by shifting. The query for the problem-triggered
>> scenario is for the missing_owner interval (e.g. freespace in rmapbt/
>> unknown space in bnobt), which is obtained by subtraction (gap). For this
>> scenario, the interval is obtained by info->last. However, rec_daddr is
>> calculated based on the start_block recorded in key[1], which is converted
>> by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
>> info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
>> <= info->next_daddr, no records will be displayed. In the above example,
>> 104 >> (mp)->m_blkbb_log = 12 and 107 >> (mp)->m_blkbb_log = 12, so the two
>> are reduced to 0 and the gap is ignored:
>>
>>   before calculate ----------------> after shifting
>>   104(st)  107(ed)		      12(st/ed)
>>    |---------|				  |
>>    sector size			      block size
>>
>> Resolve this issue by introducing the "end_daddr" field in
>> xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
>> the granularity of sector. If the current query is the last, the rec_daddr
>> is end_daddr to prevent missing interval problems caused by shifting. We
>> only need to focus on the last query, because xfs disks are internally
>> aligned with disk blocksize that are powers of two and minimum 512, so
>> there is no problem with shifting in previous queries.
>>
>> After applying this patch, the above problem have been solved:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 104 107' /mnt
>>   EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>>     0: 253:16 [104..106]:      free space                        0  (104..106)           3
>>
>> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/xfs_fsmap.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>> index d346acff7725..4ae273b54129 100644
>> --- a/fs/xfs/xfs_fsmap.c
>> +++ b/fs/xfs/xfs_fsmap.c
>> @@ -162,6 +162,7 @@ struct xfs_getfsmap_info {
>>   	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>>   	/* daddr of low fsmap key when we're using the rtbitmap */
>>   	xfs_daddr_t		low_daddr;
>> +	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
> 
> This ought to be initialized to an obviously impossible value (e.g.
> -1ULL) in xfs_getfsmap before we start walking btrees.
> 

This really makes the semantics clearer. So the assignment condition for
rec_daddr = info->end_daddr also needs to be changed.

>>   	u64			missing_owner;	/* owner of holes */
>>   	u32			dev;		/* device id */
>>   	/*
>> @@ -294,6 +295,13 @@ xfs_getfsmap_helper(
>>   		return 0;
>>   	}
>>   
>> +	/*
>> +	 * To prevent missing intervals in the last query, consider using
>> +	 * sectors as the granularity.
>> +	 */
>> +	if (info->last && info->end_daddr)
>> +		rec_daddr = info->end_daddr;
> 
> I think this needs a better comment.  How about:
> 
> 	/*
> 	 * For an info->last query, we're looking for a gap between the
> 	 * last mapping emitted and the high key specified by userspace.
> 	 * If the user's query spans less than 1 fsblock, then
> 	 * info->high and info->low will have the same rm_startblock,
> 	 * which causes rec_daddr and next_daddr to be the same.
> 	 * Therefore, use the end_daddr that we calculated from
> 	 * userspace's high key to synthesize the record.  Note that if
> 	 * the btree query found a mapping, there won't be a gap.
> 	 */
> 

A more detailed explanation, indeed. As for my previous description, I
simply explained that it would be missed, but did not say the specific
reason. I will adopt it in the next patch, thanks.

>> +
>>   	/* Are we just counting mappings? */
>>   	if (info->head->fmh_count == 0) {
>>   		if (info->head->fmh_entries == UINT_MAX)
>> @@ -973,8 +981,10 @@ xfs_getfsmap(
>>   		 * low key, zero out the low key so that we get
>>   		 * everything from the beginning.
>>   		 */
>> -		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
>> +		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
>>   			dkeys[1] = head->fmh_keys[1];
>> +			info.end_daddr = dkeys[1].fmr_physical + dkeys[1].fmr_length;
> 
> dkeys[1].fmr_length is never used by anything in the fsmap code --
> __xfs_getfsmap_datadev sets end_fsb using only dkeys[1].fmr_physical.
> You shouldn't add it to end_daddr here because then they won't be
> describing the same thing.
> 

I actually have a question here. We set info->low.rm_blockcount with
keys[0].fmr_length to indicate if this is the first fsmap query. But I'm
not sure what keys[1].fmr_length does. When fsmap is invoked in user
mode, keys[1].fmr_physical is only set. In view of this, I hope to get
your answer.

Anyway, I will send the next patch as soon as possible, thanks for your
comments.

Thanks,
Zizhi Wo

> Anyway I'll figure out a reproducer for fstests and send the whole pile
> back to the mailing list once it passes QA.  Thanks for finding the bug
> and attempting a fix. :)
> 
> --D
> 
>> +		}
>>   		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
>>   			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
>>   
>> -- 
>> 2.39.2
>>
>>
