Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C57171C9;
	Mon,  1 Jul 2024 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719802198; cv=none; b=pHrDSrSfb02CCGE2C/wmxSamszUGsIBjEyIzjj4qf61nXFG5Sn+9BYPVUPYhv9VawvI/fLVQfIFTBZaBFa397HwYYbVGI79VLH4lc3IQa0IYT/hCFxh/ypcZ1TW1gJDVmjSDj+ZKtSy4Z84RLf5tZFRfOxoNkfLoWtU3Dgv3oQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719802198; c=relaxed/simple;
	bh=n+oAJrMiKU/m7GwdMOLXLJIDRyS/D/sRQp8DT/+cx0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DVB7jiJckyINmX7KVSRUZ8CI/HSgh6MDt9vS1ukUzSksGuCe5UtwM21yEHr7XXFy02WATnhmjkEvQkuxfxl9K4X8iROf3hpcHGfSRMjdGqe245Ro//Ooc8WZelYHSdWK9zG+Z4Ns/vwkUmh3584XccEqshD+yYlKJqtHY/9zAJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WC9QD3QP1z1j62j;
	Mon,  1 Jul 2024 10:45:40 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D6FB1A016C;
	Mon,  1 Jul 2024 10:49:44 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Jul 2024 10:49:43 +0800
Message-ID: <3f2edec7-5be9-4bf4-bc34-f64072a61336@huawei.com>
Date: Mon, 1 Jul 2024 10:49:42 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] xfs: Avoid races with cnt_btree lastrec updates
To: Dave Chinner <david@fromorbit.com>
CC: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240625014651.382485-1-wozizhi@huawei.com>
 <ZoIUrmB2Jc1KK9Tv@dread.disaster.area>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <ZoIUrmB2Jc1KK9Tv@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/7/1 10:30, Dave Chinner 写道:
> On Tue, Jun 25, 2024 at 09:46:51AM +0800, Zizhi Wo wrote:
>> A concurrent file creation and little writing could unexpectedly return
>> -ENOSPC error since there is a race window that the allocator could get
>> the wrong agf->agf_longest.
>>
>> Write file process steps:
>> 1) Find the entry that best meets the conditions, then calculate the start
>>     address and length of the remaining part of the entry after allocation.
>> 2) Delete this entry and update the -current- agf->agf_longest.
>> 3) Insert the remaining unused parts of this entry based on the
>>     calculations in 1), and update the agf->agf_longest again if necessary.
>>
>> Create file process steps:
>> 1) Check whether there are free inodes in the inode chunk.
>> 2) If there is no free inode, check whether there has space for creating
>>     inode chunks, perform the no-lock judgment first.
>> 3) If the judgment succeeds, the judgment is performed again with agf lock
>>     held. Otherwire, an error is returned directly.
>>
>> If the write process is in step 2) but not go to 3) yet, the create file
>> process goes to 2) at this time, it may be mistaken for no space,
>> resulting in the file system still has space but the file creation fails.
>>
>> We have sent two different commits to the community in order to fix this
>> problem[1][2]. Unfortunately, both solutions have flaws. In [2], I
>> discussed with Dave and Darrick, realized that a better solution to this
>> problem requires the "last cnt record tracking" to be ripped out of the
>> generic btree code. And surprisingly, Dave directly provided his fix code.
>> This patch includes appropriate modifications based on his tmp-code to
>> address this issue.
>>
>> The entire fix can be roughly divided into two parts:
>> 1) Delete the code related to lastrec-update in the generic btree code.
>> 2) Place the process of updating longest freespace with cntbt separately
>>     to the end of the cntbt modifications. Move the cursor to the rightmost
>>     firstly, and update the longest free extent based on the record.
>>
>> Note that we can not update the longest with xfs_alloc_get_rec() after
>> find the longest record, as xfs_verify_agbno() may not pass because
>> pag->block_count is updated on the outside. Therefore, use
>> xfs_btree_get_rec() as a replacement.
>>
>> [1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
>> [2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com
>>
>> Reported by: Ye Bin <yebin10@huawei.com>
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c       | 115 ++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_alloc_btree.c |  64 ------------------
>>   fs/xfs/libxfs/xfs_btree.c       |  51 --------------
>>   fs/xfs/libxfs/xfs_btree.h       |  16 +----
>>   4 files changed, 116 insertions(+), 130 deletions(-)
> 
> Mostly looks good. One small thing to fix, though.
> 
>> +/*
>> + * Find the rightmost record of the cntbt, and return the longest free space
>> + * recorded in it. Simply set both the block number and the length to their
>> + * maximum values before searching.
>> + */
>> +static int
>> +xfs_cntbt_longest(
>> +	struct xfs_btree_cur	*cnt_cur,
>> +	xfs_extlen_t		*longest)
>> +{
>> +	struct xfs_alloc_rec_incore irec;
>> +	union xfs_btree_rec	    *rec;
>> +	int			    stat = 0;
>> +	int			    error;
>> +
>> +	memset(&cnt_cur->bc_rec, 0xFF, sizeof(cnt_cur->bc_rec));
>> +	error = xfs_btree_lookup(cnt_cur, XFS_LOOKUP_LE, &stat);
>> +	if (error)
>> +		return error;
>> +	if (!stat) {
>> +		/* totally empty tree */
>> +		*longest = 0;
>> +		return 0;
>> +	}
>> +
>> +	error = xfs_btree_get_rec(cnt_cur, &rec, &stat);
>> +	if (error)
>> +		return error;
>> +	if (!stat) {
>> +		ASSERT(0);
>> +		*longest = 0;
>> +		return 0;
> 
> If we don't find a record, some kind of btree corruption has been
> encountered. Rather than "ASSERT(0)" here, this should fail in
> production systems in a way that admins and online repair will
> notice:
> 
> 	if (XFS_IS_CORRUPT(mp, stat != 0)) {
> 		xfs_btree_mark_sick(cnt_cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> -Dave.

Yes, that seems more reasonable. I will send the V4 patch.

Thanks,
Zizhi Wo
