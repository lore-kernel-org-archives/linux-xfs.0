Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D35F4F5;
	Wed,  5 Jun 2024 02:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717555940; cv=none; b=KLjAy+BmpHiBFWIMs8B/dmal8eAAf5YK+MPagQa4iVKDhv4INyl0UWWqGpIwONa/abXt7LinxEyYwuRzVT6CTRoVAU7ngu28D1tBloWXVsixxIrLxQXg5sSIqlldaDbokzQ2k9S3OxpHqKviddoQfHLVMuCye4X6+UIeJ+Eo/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717555940; c=relaxed/simple;
	bh=wXKxS3UPolIUVUt+HRGtpBp5s+0V5rWlPEcP7qkoA88=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hHuNXmxzzsSkiBnBnWQkICqPAPukYp/d0g1qxQBS4h8CzhEjic8eU1tWVfKI4hkewq1JWDt+HrriPUw3HJEdyanLovW3XPJWi6+4rFLq+nteasZFG1xcXadcI2P4lCAQ/BhcXA3DHQSLbuc8qpyw7CtkdsGnfGid1pvmpn9bGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VvBjF3tBnz1S9Tl;
	Wed,  5 Jun 2024 10:48:17 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 9429F18007E;
	Wed,  5 Jun 2024 10:52:13 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Jun 2024 10:51:32 +0800
Message-ID: <ba3cb00b-1d05-4ac9-b14e-e73e65cc4017@huawei.com>
Date: Wed, 5 Jun 2024 10:51:31 +0800
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
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <Zl+cjKxrncOKbas7@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)



在 2024/6/5 7:00, Dave Chinner 写道:
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
> 
> Ok, so this is a another attempt to address the problem Ye Bin
> attempted to fix here:
> 
> https://lore.kernel.org/linux-xfs/20240419061848.1032366-1-yebin10@huawei.com/
> 
>> Fix this issue by adding the bc_free_longest field to the xfs_btree_cur_t
>> structure to store the potential longest count that will be updated. The
>> assignment is done in xfs_alloc_fixup_trees() and xfs_free_ag_extent().
> 
> I outlined how this should be fixed in the above thread:
> 
> https://lore.kernel.org/linux-xfs/ZiWgRGWVG4aK1165@dread.disaster.area/
> 
> This is what I said:
> 
> | What we actually want is for pag->pagf_longest not to change
> | transiently to zero in xfs_alloc_fixup_trees(). If the delrec that
> | zeroes the pagf_longest field is going to follow it up with an
> | insrec that will set it back to a valid value, we really should not
> | be doing the zeroing in the first place.
> |
> | Further, the only btree that tracks the right edge of the btree is
> | the by-count allocbt. This isn't "generic" functionality, even
> | though it is implemented through the generic btree code. If we lift
> | ->update_lastrec from the generic code and do it directly in
> | xfs_alloc.c whenever we are finished with a by-count tree update
> | and the cursor points to a record in the right-most leaf of the
> | tree, then we run the lastrec update directly at that point.
> | By decoupling the lastrec updates from the individual record
> | manipulations, we can make the transients disappear completely.
> 
> I'm not sure if this patch is an attempt to implement this - there
> is no reference in the commit description to this previous attempt
> to fix the issue, nor is the any discussion of why this particular
> solution was chosen.
> 
> In future, when you are trying to fix an issue that has previously
> been discussed/presented on the list, please reference it and
> provide a link to the previous discussions in the changelog for the
> new version of the patchset fixing the issue.

Oh, I'm sorry for the confusion I caused you. And I will reference it
next time.

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
>> +
> 
> Why do we store the length of a random extent being freed here?
> nflen1/2 almost always have nothing to do with the longest free
> space extent in the tree, they are just the new free space extents
> we are insering into a random location in the free space tree.
> 

First of all, there may be ambiguity in the name of the bc_free_longest
field. I'm sorry for that. Its only role is to give the longest non-0 in
a particular scenario.

Yes, nflen1/2 can't determine the subsequent operation, but they are
used to update the longest record only if the numrec in cntbt is zero,
the last has been deleted and a new record will be added soon (that is,
there is still space left on the file system), and that is their only
function. So at this time nflen1/2 are not random extent, they indicate
the maximum value to be inserted later. If cntbt does not need to be
updated longest or the numrec is not zero, then bc_free_longest will not
be used to update the longest.

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
> That doesn't look correct. At this point in the code, ltlen/gtlen
> are the sizes of the physically adjacent freespace extents that we
> are going to merge the newly freed extent with. i.e. the new
> freespace extent is going to have one of 4 possible values:
> 
> 	no merge: len
> 	left merge: ltlen + len
> 	right merge: gtlen + len
> 	both merge: ltlen + gtlen + len
> 
> So regardless of anything else, this code isn't setting the longest
> freespace extent in teh AGF to the lenght of the longest freespace
> extent in the filesystem.

> Which leads me to ask: how did you test this code? This bug should
> have been triggering verifier, repair and scrub failures quite
> quickly with fstests....
> 

The logic I'm considering here is that the record is less than or equal
to the maximum value that will be updated soon, as I wrote "potentially"
in the comment. And consider the following two scenarios:
1) If it is no merge, then haveleft == 0 && haveright == 0, and
bc_free_longest will not be assigned, and is no need to worry about the
longest update at this time.
2) If it is in merge scenario, only updating the original values here,
and the actual updates are put into the subsequent xfs_btree_insert().
There is no need to worry about atomicity, both are carried out in the
same transaction. All we have to do is the longest non-0. As long as the
fast path judgment without locking passes, the longest must be updated
to the correct value during the second lock judgment.

I tested this part of the code, passed xfstests, and local validation
found no problems.

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
>>   		}
> 
> So this is in the LASTREC_DELREC case when the last record is
> removed from the btree. This is what causes the transient state
> as we do this when deleting a record to trim it and then re-insert
> the remainder back into the by-count btree.
> 
> Writing some random transient value into the AGF *and journalling
> it* means we creating a transient on-disk format structure
> corruption and potentially writing it to persistent storage (i.e.
> the journal). The structure is, at least, not consistent in memory
> because the free space tree is empty at this point in time, whilst
> the agf->longest field says it has a free space available. This
> could trip verifiers, be flagged as corruption by xfs_scrub/repair,
> etc.
> 

I'm sorry, but I didn't find the problem during my own screening. In my 
opinion, because the trigger scenario for the current problem is only to 
delete the last node and be updated shortly, and bc_free_longest is used
only in the following two scenarios:
1) cntbt has only one extent and remains after being used, so nflen 1/2
will be inserted later.
2) cntbt has only one extent and the released extent is adjacent to this
record. This unique record will be deleted firstly, and then the two
extents are merged and inserted.

The above two scenarios are both within the same transaction, and both
are guaranteed by a xfs_buf lock. When run xfs_trans_commit, code have
gone through the delete and insert process, or merge and update process.
So the longest value written to the disk is already the correct value
and matches the cntbt state at this time. In other scenarios, the numrec
of cntbt cannot be 0, so the longest cannot be updated through
bc_free_longest.

Thanks,
Zizhi Wo

> Now, this *might be safe* because we *may* clean it up later in the
> transaction, but if this really is the last extent being removed
> from the btree and a cursor has previously been used to do other
> insert and free operations that set this field, then we trip over
> this stale inforamtion and write a corrupt structure to disk. That's
> not good.
> 
> As I said above, this "last record tracking" needs to be ripped out
> of the generic btree code because only the by-count btree uses it.
> Then it can be updated at the end of the by-count btree update
> process in the allocation code (i.e. after all record manipulations
> are done in the transaction) and that avoids this transient caused
> by updating the last record on every btree record update that is
> done.
> 
> Cheers,
> 
> Dave.
