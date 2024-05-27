Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC0413A241;
	Mon, 27 May 2024 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716801832; cv=none; b=rUHDx+zkuoR1IgEfmWjWJhkuIpmV2fHzosyALKSFrj+J3HEGGQHDExp8+Rb7AjUKMHo0//B+TR2Hy5gMSCwBD1dBGPVwvhK0iH/Fl2MgxMVNhm8SPe2bOVOzMazihHV5wykzRJx7S7xmIe2w29M59N8bnWji1ENRHEVGKuvIzKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716801832; c=relaxed/simple;
	bh=3OcXZCSPL67gEa8iZoXVuvDdjEjFD/HXPIObOC3Z7HE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jlgr89C4SzWZrH2P9O3GjsM5gKHtlmMr42+xT0AGgVPBkysWJXvP/kngDVpCMw9mIqQGCjhzIjP6W799/hXnQPonCN+NXQrlLkohv92ARIZXgy0UhzlIgfkoTd4ishXRbO9uSGAjIqVwu0Kttny9e6DLDLhWqcb/qq2oIPjDu+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yUahua0c; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yUahua0c"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716801827; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AjXreatmcwvB9m/vXBrgxMmdp6KXfvqWLgchc/T9yD4=;
	b=yUahua0cGX7BgY/pmnZEeOwxwlvRxcw8PAJLkN0x2GwOcfS33z/zAOojYrTmVl1t1Lcrmy8kEo5d2VRiTHf8Kuzk9HXrbp7j+7rf9oxiOMdAEh9aIphpio7VKqSOkFRkIPczcoMxl3QZfX7T0P6X7ohwD64d+BZSLkAb/kutvB4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W7HigJ3_1716801825;
Received: from 30.97.48.235(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W7HigJ3_1716801825)
          by smtp.aliyun-inc.com;
          Mon, 27 May 2024 17:23:46 +0800
Message-ID: <1b2be7fa-332d-4fab-8d36-89ef7a0d3a24@linux.alibaba.com>
Date: Mon, 27 May 2024 17:23:44 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: avoid redundant AGFL buffer invalidation
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 Chandan Babu R <chandanbabu@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20240527061006.4045908-1-hsiangkao@linux.alibaba.com>
 <ZlRLWP3Ty6uvMzjd@dread.disaster.area>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZlRLWP3Ty6uvMzjd@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

On 2024/5/27 16:59, Dave Chinner wrote:
> On Mon, May 27, 2024 at 02:10:06PM +0800, Gao Xiang wrote:
>> Currently AGFL blocks can be filled from the following three sources:
>>   - allocbt free blocks, as in xfs_allocbt_free_block();
>>   - rmapbt free blocks, as in xfs_rmapbt_free_block();
>>   - refilled from freespace btrees, as in xfs_alloc_fix_freelist().
>>
>> Originally, allocbt free blocks would be marked as stale only when they
>> put back in the general free space pool as Dave mentioned on IRC, "we
>> don't stale AGF metadata btree blocks when they are returned to the
>> AGFL .. but once they get put back in the general free space pool, we
>> have to make sure the buffers are marked stale as the next user of
>> those blocks might be user data...."
> 
> So it turns out that xfs_alloc_ag_vextent_small() does this when
> allocating from the AGFL:
> 
> 	if (args->datatype & XFS_ALLOC_USERDATA) {
>                  struct xfs_buf  *bp;
> 
>                  error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
>                                  XFS_AGB_TO_DADDR(args->mp, args->agno, fbno),
>                                  args->mp->m_bsize, 0, &bp);
>                  if (error)
>                          goto error;
>                  xfs_trans_binval(args->tp, bp);
>          }
> 
> Hence we're already invalidating any buffer over the block allocated
> from the AGFL to ensure nothing will overwrite the user data that
> will be placed in the block after the allocation is committed.
> 
> This means we can trigger the log force from this path - more
> about that below....

Thanks for your reply!

Yeah, I understand.

> 
>> However, after commit ca250b1b3d71 ("xfs: invalidate allocbt blocks
>> moved to the free list") and commit edfd9dd54921 ("xfs: move buffer
>> invalidation to xfs_btree_free_block"), even allocbt / bmapbt free
>> blocks will be invalidated immediately since they may fail to pass
>> V5 format validation on writeback even writeback to free space would be
>> safe.
> 
> *nod*
> 
>> IOWs, IMHO currently there is actually no difference of free blocks
>> between AGFL freespace pool and the general free space pool.  So let's
>> avoid extra redundant AGFL buffer invalidation, since otherwise we're
>> currently facing unnecessary xfs_log_force() due to xfs_trans_binval()
>> again on buffers already marked as stale before as below:
>>
>> [  333.507469] Call Trace:
>> [  333.507862]  xfs_buf_find+0x371/0x6a0
>> [  333.508451]  xfs_buf_get_map+0x3f/0x230
>> [  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
>> [  333.509751]  xfs_free_agfl_block+0xa1/0xd0
>> [  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
>> [  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
>> [  333.511871]  xfs_defer_finish+0xc/0xa0
>> [  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
>> [  333.513253]  xfs_inactive_truncate+0xb8/0x130
>> [  333.513930]  xfs_inactive+0x223/0x270
>>
>> And xfs_log_force() will take tens of milliseconds with AGF buffer
>> locked.  It becomes an unnecessary long latency especially on our PMEM
>> devices with FSDAX enabled.  Also fstests are passed with this patch.
> 
> Well, keep in mind the reason the log force was introduced in
> xfs_buf_lock() - commit ed3b4d6cdc81 ("xfs: Improve scalability of
> busy extent tracking") says:
> 
>      The only problem with this approach is that when a metadata buffer is
>      marked stale (e.g. a directory block is removed), then buffer remains
>      pinned and locked until the log goes to disk. The issue here is that
>      if that stale buffer is reallocated in a subsequent transaction, the
>      attempt to lock that buffer in the transaction will hang waiting
>      the log to go to disk to unlock and unpin the buffer. Hence if
>      someone tries to lock a pinned, stale, locked buffer we need to
>      push on the log to get it unlocked ASAP. Effectively we are trading
>      off a guaranteed log force for a much less common trigger for log
>      force to occur.
> 
> IOWs, this "log force on buffer lock" trigger isn't specific to AGFL
> blocks.  The log force is placed there to ensure that access latency
> to any block we rapidly reallocate is *only* a few milliseconds,
> rather than being "whenever the next log writes trigger" which could
> be tens of seconds away....

Yes, I understand, also see below:

> 
> Hence we need to be aware that removing the double invalidation on
> the AGFL blocks does not make this "log force on stale buffer"
> latency issue go away, it just changes when and where it happens
> (i.e. on reallocation).

Yes, I totally agree with you that removing the double invalidation
doesn't make this "log force on stale buffer" go away.  However,
currently with our workloads we've seen this path
("xfs_agfl_free_finish_item->take AGF lock-> xfs_trans_get_buf_map->
xfs_buf_lock on AGFL blocks") takes AGF lock for tens of milliseconds.
At the same time, other parallel operations like
"xfs_reflink_find_shared" which tend to take AGF lock will be blocked
for tens of milliseconds.

And after we remove the double invalidation, our workloads now behave
normal (AGF lock won't be bottlenecked at least in our workloads)..
Since it's unnecessary for the current codebase and it resolves our
issues, I'd like to remove this double invalidation entirely.

> 
>> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>> ---
>>   fs/xfs/libxfs/xfs_alloc.c | 18 ++----------------
>>   1 file changed, 2 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 6cb8b2ddc541..a80d2a31252a 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2432,22 +2432,8 @@ xfs_free_agfl_block(
>>   	struct xfs_buf		*agbp,
>>   	struct xfs_owner_info	*oinfo)
>>   {
>> -	int			error;
>> -	struct xfs_buf		*bp;
>> -
>> -	error = xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
>> -				   XFS_AG_RESV_AGFL);
>> -	if (error)
>> -		return error;
>> -
>> -	error = xfs_trans_get_buf(tp, tp->t_mountp->m_ddev_targp,
>> -			XFS_AGB_TO_DADDR(tp->t_mountp, agno, agbno),
>> -			tp->t_mountp->m_bsize, 0, &bp);
>> -	if (error)
>> -		return error;
>> -	xfs_trans_binval(tp, bp);
>> -
>> -	return 0;
>> +	return xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
>> +				  XFS_AG_RESV_AGFL);
>>   }
> 
> I'd just get rid of the xfs_free_agfl_block() wrapper entirely and
> call xfs_free_ag_extent() directly from xfs_agfl_free_finish_item().

Okay, let me revise a new version later.

Thanks,
Gao Xiang

> 
> -Dave.
