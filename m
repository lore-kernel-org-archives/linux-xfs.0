Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7292207A;
	Wed,  5 Jun 2024 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558707; cv=none; b=d9fBOL9w15dsDO3R+vuF7SdjcuoeOKWm2IP3y4Gsjvz2leKedScSGigsneMcIysuNnI1G3jVmRBfuSLsSXdkArrM54XnxeJrK/qKJxT+k/ZLNBRLWxA2kRB5301heuTligEI+rSoaJXeJlOhrGBXGZne1aVRsyO1orU3wHCtDqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558707; c=relaxed/simple;
	bh=Kh/BhKlMN69BHMHjF2WDbTITZdz1qKhM7c02xREeMeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=abvlqgaPFBqRzjlr337PBqlJ5B1xlEyde18Zw4o6DI8T9HB6lcHtslphE72m/LpoExw0ftucAq/eCCSvb1PDzGVw6OJiCs6DwKEFabB0/z5JabznD3tPRy32tE+INqrUlwvnzw7/oHJ30QKHjUjwW0gsVymqHBvH4GvN/ko2Jhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VvCnM29byzclbT;
	Wed,  5 Jun 2024 11:36:55 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 40D40180085;
	Wed,  5 Jun 2024 11:38:19 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Jun 2024 11:38:18 +0800
Message-ID: <f42d35b8-7c04-4d69-b6fe-07b9e149d262@huawei.com>
Date: Wed, 5 Jun 2024 11:38:18 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Fix file creation failure
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240604071121.3981686-1-wozizhi@huawei.com>
 <20240604155648.GF52987@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240604155648.GF52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)



在 2024/6/4 23:56, Darrick J. Wong 写道:
> On Tue, Jun 04, 2024 at 03:11:21PM +0800, Zizhi Wo wrote:
>> We have an xfs image that contains only 2 AGs, the first AG is full and
>> the second AG is empty, then a concurrent file creation and little writing
>> could unexpectedly return -ENOSPC error since there is a race window that
>> the allocator could get the wrong agf->agf_longest.
>>
>> Write file process steps:
>> 1) Find the entry that best meets the conditions, then calculate the start
>> address and length of the remaining part of the entry after allocation.
>> 2) Delete this entry. Because the second AG is empty, the btree in its agf
>> has only one record, and agf->agf_longest will be set to 0 after deletion.
>> 3) Insert the remaining unused parts of this entry based on the
>> calculations in 1), and update the agf->agf_longest.
>>
>> Create file process steps:
>> 1) Check whether there are free inodes in the inode chunk.
>> 2) If there is no free inode, check whether there has space for creating
>> inode chunks, perform the no-lock judgment first.
>> 3) If the judgment succeeds, the judgment is performed again with agf lock
>> held. Otherwire, an error is returned directly.
>>
>> If the write process is in step 2) but not go to 3) yet, the create file
>> process goes to 2) at this time, it will be mistaken for no space,
>> resulting in the file system still has space but the file creation fails.
>>
>> 	Direct write				Create file
>> xfs_file_write_iter
>>   ...
>>   xfs_direct_write_iomap_begin
>>    xfs_iomap_write_direct
>>     ...
>>     xfs_alloc_ag_vextent_near
>>      xfs_alloc_cur_finish
>>       xfs_alloc_fixup_trees
>>        xfs_btree_delete
>>         xfs_btree_delrec
>> 	xfs_allocbt_update_lastrec
>> 	// longest = 0 because numrec == 0.
>> 	 agf->agf_longest = len = 0
>> 					   xfs_create
>> 					    ...
>> 					     xfs_dialloc
>> 					      ...
>> 					      xfs_alloc_fix_freelist
>> 					       xfs_alloc_space_available
>> 					-> as longest=0, it will return
>> 					false, no space for inode alloc.
>>
>> Fix this issue by adding the bc_free_longest field to the xfs_btree_cur_t
>> structure to store the potential longest count that will be updated. The
>> assignment is done in xfs_alloc_fixup_trees() and xfs_free_ag_extent().
> 
> This is going to be a reverse-order review due to the way that diff
> ordered the chunks, which means that the bulk of my questions are at the
> end.
> 
>> Reported by: Ye Bin <yebin10@huawei.com>
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c       | 14 ++++++++++++++
>>   fs/xfs/libxfs/xfs_alloc_btree.c |  9 ++++++++-
>>   fs/xfs/libxfs/xfs_btree.h       |  1 +
>>   3 files changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 6c55a6e88eba..86ba873d57a8 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
>>   		nfbno2 = rbno + rlen;
>>   		nflen2 = (fbno + flen) - nfbno2;
>>   	}
>> +
>> +	/*
>> +	 * Record the potential maximum free length in advance.
>> +	 */
>> +	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
>> +		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);
> 
> Ok, so if we're allocating space then this sets bc_free_longest to the
> longer of the two remaining sections, if any.  But if we just allocated
> the entirety of the longest extent in the cntbt, then we don't set
> bc_free_longest, which means its zero, right?  I guess that's ok because
> that implies there's zero space left in the AG, so the longest freespace
> is indeed zero.
> 
> If we just allocated the entirety of a non-longest extent in the cntbt
> then we don't call ->lastrec_update so the value of bc_free_longest
> doesn't matter?

Yes, absolutely right! Thank you!φ(゜▽゜*)♪

> 
>> +
>>   	/*
>>   	 * Delete the entry from the by-size btree.
>>   	 */
>> @@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
>>   	 * Now allocate and initialize a cursor for the by-size tree.
>>   	 */
>>   	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
>> +	/*
>> +	 * Record the potential maximum free length in advance.
>> +	 */
>> +	if (haveleft)
>> +		cnt_cur->bc_ag.bc_free_longest = ltlen;
>> +	if (haveright)
>> +		cnt_cur->bc_ag.bc_free_longest = gtlen;
> 
> What happens in the haveleft && haveright case?  Shouldn't
> bc_free_longest be set to ltlen + len + gtlen?  You could just push the
> setting of bc_free_longest into the haveleft/haveright code below.

Oh, as I wrote to Dave, the logic I considered here is that the record
is less than or equal to the maximum value. And no need to worry about
that because it will soon be updated in xfs_btree_insert in the problem
triggering scenario.

> 
>>   	/*
>>   	 * Have both left and right contiguous neighbors.
>>   	 * Merge all three into a single free block.
>> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
>> index 6ef5ddd89600..8e7d1e0f1a63 100644
>> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
>> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
>> @@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
>>   			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
>>   			len = rrp->ar_blockcount;
>>   		} else {
>> -			len = 0;
>> +			/*
>> +			 * Update in advance to prevent file creation failure
>> +			 * for concurrent processes even though there is no
>> +			 * numrec currently.
>> +			 * And there's no need to worry as the value that no
>> +			 * less than bc_free_longest will be inserted later.
>> +			 */
>> +			len = cpu_to_be32(cur->bc_ag.bc_free_longest);
> 
> Humm.  In this case, we've called ->update_lastrec on the cntbt cursor
> having deleted all the records in this record block.  Presumably that
> means that we're going to add rec->alloc.ar_blockcount blocks to the
> rightmost record in the left sibling of @block?  Or already have?
> 

In normal delete operations, cntbt will have a balancing process, moving
data from other nodes or merging to ensure that numrecs >= get_minrecs.
In this scenario, the cntbt is already an -empty- tree, and is in a
temporary state, new values will be inserted later.

> Ahh, right, the pagf_longest checks are done without holding AGF lock.
> The concurrent creat call sees this intermediate state (DELREC sets
> pagf_longest to zero, a moment later INSREC/UPDATE set it to the correct
> nonzero value) and decides to ENOSPC because "nobody" has sufficient
> free space.
> 
> I think this phony zero never gets written to disk because although
> we're logging zero into the ondisk and incore agf_longest here, the next
> btree operation will reset it to the correct value.  Right?

Yes, this phony zero will not be recorded to disk. It is just a
temporary condition.

> 
> Would it be simpler to handle this case by duplicating the cntbt cursor
> and walking one record leftward in the tree to find the longest extent,
> rather than using this "bc_free_longest" variable?
> 

In my opinion, this does not solve the problem. As mentioned above, at
this point the cntbt is an -empty- tree with no records.

>>   		}
>>   
>>   		break;
>> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
>> index f93374278aa1..985b1885a643 100644
>> --- a/fs/xfs/libxfs/xfs_btree.h
>> +++ b/fs/xfs/libxfs/xfs_btree.h
>> @@ -281,6 +281,7 @@ struct xfs_btree_cur
>>   			struct xfs_perag	*pag;
>>   			struct xfs_buf		*agbp;
>>   			struct xbtree_afakeroot	*afake;	/* for staging cursor */
>> +			xfs_extlen_t		bc_free_longest; /* potential longest free space */
> 
> This is only used for bnobt/cntbt trees, put it in the per-format
> private data area, please.
> 

OK, I will modify it. More specifically, it is only used for cntbt,
because currently only cntbt can set the XFS_BTGEO_LASTREC_UPDATE flag,
and can call ->update_lastrec.

> If the answer to the question about duplicating the btree cursor is "no"
> then I think this deserves a much longer comment that captures the fact
> that the variable exists to avoid setting pagf_longest to zero for
> benefit of the code that does unlocked scanning of AGs for free space.
> 
> I also wonder if the unlocked ag scan should just note that it observed
> a zero pagf_longest and if no space can be found across all the AGs, to
> try again with locks?
> 
> --D

Currently xfs checks the space using the "check-lock-check again"
algorithm, which I understand to be more efficient. If there are a large
number of AG's and there is no free space in front of them, the
performance may be affected by checking the lock again. So I think
targeting specific AG might be more effective. Although the current code
process has a retry mechanism (in xfs_dialloc), it still can't
completely solve the problem: for example, there is no space for the
first scan, and the second scan has space but the longest is 0 in the
temporary state and return -ENOSPC, etc...

Thanks,
Zizhi Wo

> 
>>   		} bc_ag;
>>   		struct {
>>   			struct xfbtree		*xfbtree;
>> -- 
>> 2.39.2
>>
>>
