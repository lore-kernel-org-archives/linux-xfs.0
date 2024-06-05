Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0446A1946BE;
	Wed,  5 Jun 2024 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717577208; cv=none; b=JTt9yaFgXpuo6PSquh+vgCnKzGsUzY0eWwEHmzsxj6myGnrDSbAgTsO6udW4nK0WIUniKo+8A3AnJ7mF9KzeM7bLTBe8rqLTTsLKBmXsTg/PM92sObWHieCeB5lNfhxBfRz1kYpEBLXW7ATUHTVzyOUY90K+O0oprOUoAGYqR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717577208; c=relaxed/simple;
	bh=j1eVpJRBA9lmFHiWEcZhRmdO05Q6wWL54KVNcMBLTKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=M5TNrk4Mjpj3cbdWRZOZMPWf+ffmDTs9OPDUTsP9ToQrbtPzb3N7F2wRYgCSuhtB557CdUZzucwWO6NXBlpplv42LuA++L3loZFeXpkqUrDtyIwRjqMbENmauPyvKw8YnviCB8Kqg33GpB5YjthtFB9th+XA5eGHrwK1xzxRukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VvLdB18fbzclgV;
	Wed,  5 Jun 2024 16:45:18 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F05C180085;
	Wed,  5 Jun 2024 16:46:42 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Jun 2024 16:46:25 +0800
Message-ID: <73320749-1a9c-40a1-a7d5-c386f1453664@huawei.com>
Date: Wed, 5 Jun 2024 16:46:25 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Fix file creation failure
To: Dave Chinner <david@fromorbit.com>
CC: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240604071121.3981686-1-wozizhi@huawei.com>
 <Zl+cjKxrncOKbas7@dread.disaster.area>
 <ba3cb00b-1d05-4ac9-b14e-e73e65cc4017@huawei.com>
 <ZmAIWOZmUKBNI8ZZ@dread.disaster.area>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <ZmAIWOZmUKBNI8ZZ@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)



在 2024/6/5 14:40, Dave Chinner 写道:
> On Wed, Jun 05, 2024 at 10:51:31AM +0800, Zizhi Wo wrote:
>> 在 2024/6/5 7:00, Dave Chinner 写道:
>>> On Tue, Jun 04, 2024 at 03:11:21PM +0800, Zizhi Wo wrote:
>>>> We have an xfs image that contains only 2 AGs, the first AG is full and
>>>> the second AG is empty, then a concurrent file creation and little writing
>>>> could unexpectedly return -ENOSPC error since there is a race window that
>>>> the allocator could get the wrong agf->agf_longest.
> .....

Yeah...I know it is amazing...

>>>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>>>> index 6c55a6e88eba..86ba873d57a8 100644
>>>> --- a/fs/xfs/libxfs/xfs_alloc.c
>>>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>>>> @@ -577,6 +577,13 @@ xfs_alloc_fixup_trees(
>>>>    		nfbno2 = rbno + rlen;
>>>>    		nflen2 = (fbno + flen) - nfbno2;
>>>>    	}
>>>> +
>>>> +	/*
>>>> +	 * Record the potential maximum free length in advance.
>>>> +	 */
>>>> +	if (nfbno1 != NULLAGBLOCK || nfbno2 != NULLAGBLOCK)
>>>> +		cnt_cur->bc_ag.bc_free_longest = XFS_EXTLEN_MAX(nflen1, nflen2);
>>>> +
>>>
>>> Why do we store the length of a random extent being freed here?
>>> nflen1/2 almost always have nothing to do with the longest free
>>> space extent in the tree, they are just the new free space extents
>>> we are insering into a random location in the free space tree.
>>>
>>
>> First of all, there may be ambiguity in the name of the bc_free_longest
>> field. I'm sorry for that. Its only role is to give the longest non-0 in
>> a particular scenario.
>>
>> Yes, nflen1/2 can't determine the subsequent operation, but they are
>> used to update the longest record only if the numrec in cntbt is zero,
>> the last has been deleted and a new record will be added soon (that is,
>> there is still space left on the file system), and that is their only
>> function. So at this time nflen1/2 are not random extent, they indicate
>> the maximum value to be inserted later. If cntbt does not need to be
>> updated longest or the numrec is not zero, then bc_free_longest will not
>> be used to update the longest.
> 
> That's the comment you should have put in the code.
> 
> Comments need to explain -why- the code exists, not tell us -what-
> the code does. We know the latter from reading the code, we cannot
> know the former from reading the code...
> 

I am sorry for the trouble caused by my comments. I have indeed left out
a lot of details, and I will correct it next time. /(ㄒoㄒ)/~~

>>>>    	/*
>>>>    	 * Delete the entry from the by-size btree.
>>>>    	 */
>>>> @@ -2044,6 +2051,13 @@ xfs_free_ag_extent(
>>>>    	 * Now allocate and initialize a cursor for the by-size tree.
>>>>    	 */
>>>>    	cnt_cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
>>>> +	/*
>>>> +	 * Record the potential maximum free length in advance.
>>>> +	 */
>>>> +	if (haveleft)
>>>> +		cnt_cur->bc_ag.bc_free_longest = ltlen;
>>>> +	if (haveright)
>>>> +		cnt_cur->bc_ag.bc_free_longest = gtlen;
>>>
>>> That doesn't look correct. At this point in the code, ltlen/gtlen
>>> are the sizes of the physically adjacent freespace extents that we
>>> are going to merge the newly freed extent with. i.e. the new
>>> freespace extent is going to have one of 4 possible values:
>>>
>>> 	no merge: len
>>> 	left merge: ltlen + len
>>> 	right merge: gtlen + len
>>> 	both merge: ltlen + gtlen + len
>>>
>>> So regardless of anything else, this code isn't setting the longest
>>> freespace extent in teh AGF to the lenght of the longest freespace
>>> extent in the filesystem.
>>
>>> Which leads me to ask: how did you test this code? This bug should
>>> have been triggering verifier, repair and scrub failures quite
>>> quickly with fstests....
>>>
>>
>> The logic I'm considering here is that the record is less than or equal
>> to the maximum value that will be updated soon, as I wrote "potentially"
>> in the comment. And consider the following two scenarios:
>> 1) If it is no merge, then haveleft == 0 && haveright == 0, and
>> bc_free_longest will not be assigned, and is no need to worry about the
>> longest update at this time.
>> 2) If it is in merge scenario, only updating the original values here,
>> and the actual updates are put into the subsequent xfs_btree_insert().
>> There is no need to worry about atomicity, both are carried out in the
>> same transaction. All we have to do is the longest non-0. As long as the
>> fast path judgment without locking passes, the longest must be updated
>> to the correct value during the second lock judgment.
> 
> And therein lies the problem. We've learnt the had way not to do
> partial state updates that might end up on disk even within
> transactions. At some point in the future, we'll change the way the
> code works, not realising that there's an inconsistent transient
> state being logged, and some time after that we'll have occasional
> reports of weird failures with values on disk or in the journal we
> cannot explain.
> 
>> I tested this part of the code, passed xfstests, and local validation
>> found no problems.
> 
> yeah, fstests won't expose the inconsistent state *right now*; the
> problem is that we've just left a landmine for future developers to
> step on.
> 
> It's also really difficult to follow - you've added non-obvious
> coupling between the free space btree updates and the AGF updates
> via a field held in a btree cursor. This essentially means that all
> this stuff has to occur within the context of a single btree cursor,
> and that btree cursor cannot be re-used for further operations
> because this field is not reset by things like new lookups.
> 
> Then there is the question of what happens if we have duplicated the
> cursor for a specific btree record operation, and the field is set
> in the duplicated cursor. The core btree operations do this in
> several places because they want to retain a cursor to the original
> poistion, but the specific operation that needs to be performed will
> change the cursor position (e.g. shifts, splits, merges, etc). Hence
> there's no guarantee that a single cursor is used for all the
> operations in a single btree modification, and hence storing
> information in cursors that is supposed to persist until some other
> btree modification method is run is asking for trouble.
> 
> Hence, IMO, coupling allocation btree coherency operations via the
> btree cursor is something we should avoid at all costs. That's why I
> keep saying the last record update for the by-count/AGF longest
> needs to be moved outside the generic btree code itself. The
> coherency and coupling needs to be directly controlled by the high
> level alloc code, not by trying to punch special data holes through
> the generic btree abstractions.
> 

Oh, I did not consider the problems you pointed out above, and the
previous revision should be avoided. I fully agree with your opinion.

>>>>    	/*
>>>>    	 * Have both left and right contiguous neighbors.
>>>>    	 * Merge all three into a single free block.
>>>> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
>>>> index 6ef5ddd89600..8e7d1e0f1a63 100644
>>>> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
>>>> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
>>>> @@ -161,7 +161,14 @@ xfs_allocbt_update_lastrec(
>>>>    			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
>>>>    			len = rrp->ar_blockcount;
>>>>    		} else {
>>>> -			len = 0;
>>>> +			/*
>>>> +			 * Update in advance to prevent file creation failure
>>>> +			 * for concurrent processes even though there is no
>>>> +			 * numrec currently.
>>>> +			 * And there's no need to worry as the value that no
>>>> +			 * less than bc_free_longest will be inserted later.
>>>> +			 */
>>>> +			len = cpu_to_be32(cur->bc_ag.bc_free_longest);
>>>>    		}
>>>
>>> So this is in the LASTREC_DELREC case when the last record is
>>> removed from the btree. This is what causes the transient state
>>> as we do this when deleting a record to trim it and then re-insert
>>> the remainder back into the by-count btree.
>>>
>>> Writing some random transient value into the AGF *and journalling
>>> it* means we creating a transient on-disk format structure
>>> corruption and potentially writing it to persistent storage (i.e.
>>> the journal). The structure is, at least, not consistent in memory
>>> because the free space tree is empty at this point in time, whilst
>>> the agf->longest field says it has a free space available. This
>>> could trip verifiers, be flagged as corruption by xfs_scrub/repair,
>>> etc.
>>>
>>
>> I'm sorry, but I didn't find the problem during my own screening. In my
>> opinion, because the trigger scenario for the current problem is only to
>> delete the last node and be updated shortly, and bc_free_longest is used
>> only in the following two scenarios:
>> 1) cntbt has only one extent and remains after being used, so nflen 1/2
>> will be inserted later.
>> 2) cntbt has only one extent and the released extent is adjacent to this
>> record. This unique record will be deleted firstly, and then the two
>> extents are merged and inserted.
> 
> Yes, I understand what you've done.
> 
> But I don't think it is the right way to fix the issue for the
> reasons I've given.
> 
> I've attached a quick hack (not even compile tested!) to
> demonstrate the way I've been suggesting this issue should be fixed
> by the removal of the lastrec update code from the generic
> btree implementation. It updates pag->pagf_longest and
> agf->longest directly from the high level allocation code once the
> free space btree manipulations have been completed. We do this in a
> context where we control AGF, the perag and the btree cursors
> directly, and there is no need to temporarily store anything in the
> btree cursors at all.
> 
> Feel free to use this code as the basis of future patches to address
> this issue.
> 
> -Dave.

That's amazing! Thanks!! I will read the code carefully and submit the
correct fix for this issue again soon.

Thanks,
Zizhi Wo

