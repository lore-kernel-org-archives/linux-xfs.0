Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EED8C06;
	Fri, 16 Aug 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770180; cv=none; b=PnZ0o6VPta/D8TcxPzBaI1GK7yJYVCw6az3fDUGftC3srmejmvfCNWdQJTqJSDHZnp303OjABelVWDihz6yzMzQhRk9aQitghUNEJh9rHboga40In1ABmillI2TJ1ed8CSiAnOjlbh1NWklQ0TVkV1gXO9dbPqJ8Eku+fe1/zBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770180; c=relaxed/simple;
	bh=nzV45XKOjoz91TgEgbGY3nPmsXDXmEnGJgS3I2hLOnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RIwwBBGpBxqNzm/LXaZD94bFhEI9qXubyo4fzZW10JtS5A+K8FN+5hvByFwZOSWwelEjSxqirJxw3r8g1hNz+cO4FVc86fuT2l0OAzx7BnxtDYj14nsUE7bPBu2JWp9v4eH6DTqEayx+0KcVoNCmSYhaY0QBLj/mU5C9IEP99jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WlNs55hv1zQpx5;
	Fri, 16 Aug 2024 08:58:17 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id E9CA31400E3;
	Fri, 16 Aug 2024 09:02:53 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Aug 2024 09:02:53 +0800
Message-ID: <768dd909-c77c-4655-af01-5aa064ea9477@huawei.com>
Date: Fri, 16 Aug 2024 09:02:52 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] xfs: Fix the owner setting issue for rmap query in
 xfs fsmap
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240812011505.1414130-1-wozizhi@huawei.com>
 <20240812011505.1414130-2-wozizhi@huawei.com>
 <20240815163634.GH865349@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240815163634.GH865349@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/8/16 0:36, Darrick J. Wong 写道:
> On Mon, Aug 12, 2024 at 09:15:04AM +0800, Zizhi Wo wrote:
>> I notice a rmap query bug in xfs_io fsmap:
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
>> Bug:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
>> [root@fedora ~]#
>> Normally, we should be able to get one record, but we got nothing.
>>
>> The root cause of this problem lies in the incorrect setting of rm_owner in
>> the rmap query. In the case of the initial query where the owner is not
>> set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
>> This is done to prevent any omissions when comparing rmap items. However,
>> if the current ag is detected to be the last one, the function sets info's
>> high_irec based on the provided key. If high->rm_owner is not specified, it
>> should continue to be set to ULLONG_MAX; otherwise, there will be issues
>> with interval omissions. For example, consider "start" and "end" within the
>> same block. If high->rm_owner == 0, it will be smaller than the founded
>> record in rmapbt, resulting in a query with no records. The main call stack
>> is as follows:
>>
>> xfs_ioc_getfsmap
>>    xfs_getfsmap
>>      xfs_getfsmap_datadev_rmapbt
>>        __xfs_getfsmap_datadev
>>          info->high.rm_owner = ULLONG_MAX
>>          if (pag->pag_agno == end_ag)
>> 	  xfs_fsmap_owner_to_rmap
>> 	    // set info->high.rm_owner = 0 because fmr_owner == 0
>> 	    dest->rm_owner = 0
>> 	// get nothing
>> 	xfs_getfsmap_datadev_rmapbt_query
>>
>> The problem can be resolved by setting the rm_owner of high to ULLONG_MAX
>> again under certain conditions.
>>
>> After applying this patch, the above problem have been solved:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
>>   EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
>>     0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8
>>
>> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/xfs_fsmap.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>> index 85dbb46452ca..d346acff7725 100644
>> --- a/fs/xfs/xfs_fsmap.c
>> +++ b/fs/xfs/xfs_fsmap.c
>> @@ -655,6 +655,13 @@ __xfs_getfsmap_datadev(
>>   			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
>>   			if (error)
>>   				break;
>> +			/*
>> +			 * Set the owner of high_key to the maximum again to
>> +			 * prevent missing intervals during the query.
>> +			 */
>> +			if (info->high.rm_owner == 0 &&
>> +			    info->missing_owner == XFS_FMR_OWN_FREE)
>> +			    info->high.rm_owner = ULLONG_MAX;
> 
> Shouldn't this be in xfs_fsmap_owner_to_rmap?
> 
> And, looking at that function, isn't this the solution:
> 
> 	switch (src->fmr_owner) {
> 	case 0:			/* "lowest owner id possible" */
> 	case -1ULL:		/* "highest owner id possible" */
> 		dest->rm_owner = src->fmr_owner;
> 		break;
> 

Yes, the simple modification logic in the xfs_fsmap_owner_to_rmap
function makes more sense.

Thanks,
Zizhi Wo

> instead of this special-casing outside the setter function?
> 
> --D
> 
>>   			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
>>   		}
>>   
>> -- 
>> 2.39.2
>>
>>
> 
