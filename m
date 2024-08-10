Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B5171CD;
	Sat, 10 Aug 2024 00:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723249603; cv=none; b=MGk0KbgkTLntp9n07QKlwPZz6lSFtx30LeI1A/f02YFw7lt8u8dmggzQ6TD7P3080/68+ss0lEWXu9RTdjl2NGo2uKjIXluamgeWNPcEpXB+K7a5hL9BFa2IoIcKgbwQIyRQ2mSxH+x6WhqQxdK6prlJ2l11/HGq+KTNWEgw5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723249603; c=relaxed/simple;
	bh=isGV8iowZzgdKsFvP7qT+20blQTVUSCQh9csow6FWdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Hfo9AJ4ovw1sCg9kx2JKQsVzjmdIDjM1hWRWxiqoGkXlqAwV3OPjC5xvmHgvEM6veFFgj4ET8Zgos9IGA+rwWjJTvyTBsZzwzwD+98skhEh4HqH++m6u5ILSb6hd0+kPyhSYRdEiKji7VDg/yC1QUEgr7tBDfE8X+ilVNaxmuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WghKq1vvlz1j6NS;
	Sat, 10 Aug 2024 08:21:51 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D0B3140137;
	Sat, 10 Aug 2024 08:26:37 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Aug 2024 08:26:36 +0800
Message-ID: <ddaab6d5-08f3-4a54-a8bc-9ebda7773ec0@huawei.com>
Date: Sat, 10 Aug 2024 08:26:35 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] xfs: Make the fsmap more precise
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240808144759.1330237-1-wozizhi@huawei.com>
 <20240809162226.GW6051@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240809162226.GW6051@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/8/10 0:22, Darrick J. Wong 写道:
> On Thu, Aug 08, 2024 at 10:47:59PM +0800, Zizhi Wo wrote:
>> In commit 63ef7a35912d ("xfs: fix interval filtering in multi-step fsmap
>> queries"), Darrick has solved a fsmap bug about incorrect filter condition.
>> But I still notice two problems in fsmap:
>>
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>>   EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
>>     0: 253:32 [0..7]:               static fs metadata                  0  (0..7)                    8
>>     1: 253:32 [8..23]:              per-AG metadata                     0  (8..23)                  16
>>     2: 253:32 [24..39]:             inode btree                         0  (24..39)                 16
>>     ......
>>
>> Bug 1:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 3 7' /mnt
>> [root@fedora ~]#
>> Normally, we should be able to get [3, 7), but we got nothing.
> 
> Hmm, yes, that's a bug.
> 
>> Bug 2:
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 15 20' /mnt
>>   EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>>     0: 253:32 [8..23]:         per-AG metadata                   0  (8..23)             16
>> Normally, we should be able to get [15, 20), but we obtained a whole
>> segment of extent.
> 
> Both filesystems implementing GETFSMAP (ext4 and xfs) can return larger
> mapping than what was requested.  Userspace can decide to trim the
> mappings before using them, which is why the kernel doesn't do that on
> its own.
> 

Oh, I see. I noticed that querying the missing_owner range could be
precise, but querying the non-missing_owner range only displayed the
whole thing. I found this inconsistent, so I fixed the issue myself...

>> The first problem is caused by shifting. When the query interval is before
>> the first extent which can be find in btree, no records can meet the
>> requirement. And the gap will be obtained in the last query. However,
>> rec_daddr is calculated based on the start_block recorded in key[1], which
>> is converted by calling XFS_BB_TO_FSBT. Then if rec_daddr does not exceed
>> info->next_daddr, which means keys[1].fmr_physical >> (mp)->m_blkbb_log
>> <= info->next_daddr, no records will be displayed. In the above example,
>> 3 >> (mp)->m_blkbb_log = 0 and 7 >> (mp)->m_blkbb_log = 0, so the two are
>> reduced to 0 and the gap is ignored:
>>
>> before calculate ----------------> after shifting
>>   3(st)    7(ed)                       0(st/ed)
>>    |---------|                            |
>>    sector size                        block size
>>
>> Resolve this issue by introducing the "tail_daddr" field in
>> xfs_getfsmap_info. This records |key[1].fmr_physical + key[1].length| at
>> the granularity of sector. If the current query is the last, the rec_daddr
>> is tail_daddr to prevent missing interval problems caused by shifting. We
>> only need to focus on the last query, because xfs disks are internally
>> aligned with disk blocksize that are powers of two and minimum 512, so
>> there is no problem with shifting in previous queries.
> 
> Not sure what "tail_daddr" is; the patch adds {start,end}_daddr.  I
> agree that fsmap -vvvv -d 3 7 ought to return "static fs metadata"
> instead of nothing, however.
> 
> Can you send a separate fix for "Bug 1", please?
> 
> --D

I'm very sorry, I mistakenly referred to "end_daddr" as "tail_daddr"!
"end_daddr" is mainly used to fix the first bug, where the last range
wasn't calculated with sector granularity, causing query issues. The
second bug fix relies on both "start_daddr" and "end_daddr". But as
discussed above, the second one isn't really an issue? So I'll only fix
the first bug in the next patch version.

Thanks,
Zizhi Wo

> 
>> The second problem is that the resulting range is not truncated precisely
>> according to the boundary. Currently, the query display mechanism for owner
>> and missing_owner is different. The query of missing_owner (e.g. freespace
>> in rmapbt/ unknown space in bnobt) is obtained by subtraction (gap), which
>> can accurately lock the range. In the query of owner which almostly finded
>> by btree, as long as certain conditions met, the entire interval is
>> recorded, regardless of the starting address of the key[0] and key[1]
>> incoming from the user state. Focus on the following scenario:
>>
>>                      a       b
>>                      |-------|
>> 	              query
>>                   c             d
>> |----------------|-------------|----------------|
>>    missing owner1      owner      missing owner2
>>
>> Currently query is directly displayed as [c, d), the correct display should
>> be [a, b). This problem is solved by calculating max(a, c) and min(b, d) to
>> identify the head and tail of the range. To be able to determine the bounds
>> of the low key, "start_daddr" is introduced in xfs_getfsmap_info. Although
>> in some scenarios, similar results can be achieved without introducing
>> "start_daddr" and relying solely on info->next_daddr (e.g. in bnobt), it is
>> ineffective for overlapping scenarios in rmapbt.
>>
>> After applying this patch, both of the above issues have been fixed (the
>> same applies to boundary queries for the log device and realtime device):
>> 1)
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 3 7' /mnt
>>   EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
>>     0: 253:32 [3..6]:          static fs metadata                  0  (3..6)               4
>> 2)
>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 15 20' /mnt
>>   EXT: DEV    BLOCK-RANGE      OWNER            FILE-OFFSET      AG AG-OFFSET        TOTAL
>>     0: 253:32 [15..19]:        per-AG metadata                   0  (15..19)             5
>>
>> Note that due to the current query range being more precise, high.rm_owner
>> needs to be handled carefully. When it is 0, set it to the maximum value to
>> prevent missing intervals in rmapbt.
>>
>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>> ---
>>   fs/xfs/xfs_fsmap.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 40 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>> index 85dbb46452ca..e7bb21497e5c 100644
>> --- a/fs/xfs/xfs_fsmap.c
>> +++ b/fs/xfs/xfs_fsmap.c
>> @@ -162,6 +162,8 @@ struct xfs_getfsmap_info {
>>   	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>>   	/* daddr of low fsmap key when we're using the rtbitmap */
>>   	xfs_daddr_t		low_daddr;
>> +	xfs_daddr_t		start_daddr;	/* daddr of low fsmap key */
>> +	xfs_daddr_t		end_daddr;	/* daddr of high fsmap key */
>>   	u64			missing_owner;	/* owner of holes */
>>   	u32			dev;		/* device id */
>>   	/*
>> @@ -276,6 +278,7 @@ xfs_getfsmap_helper(
>>   	struct xfs_mount		*mp = tp->t_mountp;
>>   	bool				shared;
>>   	int				error;
>> +	int				trunc_len;
>>   
>>   	if (fatal_signal_pending(current))
>>   		return -EINTR;
>> @@ -283,6 +286,13 @@ xfs_getfsmap_helper(
>>   	if (len_daddr == 0)
>>   		len_daddr = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
>>   
>> +	/*
>> +	 * Determine the maximum boundary of the query to prepare for
>> +	 * subsequent truncation.
>> +	 */
>> +	if (info->last && info->end_daddr)
>> +		rec_daddr = info->end_daddr;
>> +
>>   	/*
>>   	 * Filter out records that start before our startpoint, if the
>>   	 * caller requested that.
>> @@ -348,6 +358,21 @@ xfs_getfsmap_helper(
>>   		return error;
>>   	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
>>   	fmr.fmr_length = len_daddr;
>> +	/*  If the start address of the record is before the low key, truncate left. */
>> +	if (info->start_daddr > rec_daddr) {
>> +		trunc_len = info->start_daddr - rec_daddr;
>> +		fmr.fmr_physical += trunc_len;
>> +		fmr.fmr_length -= trunc_len;
>> +		/* need to update the offset in rmapbt. */
>> +		if (info->missing_owner == XFS_FMR_OWN_FREE)
>> +			fmr.fmr_offset += trunc_len;
>> +	}
>> +	/* If the end address of the record exceeds the high key, truncate right. */
>> +	if (info->end_daddr) {
>> +		fmr.fmr_length = umin(fmr.fmr_length, info->end_daddr - fmr.fmr_physical);
>> +		if (fmr.fmr_length == 0)
>> +			goto out;
>> +	}
>>   	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
>>   		fmr.fmr_flags |= FMR_OF_PREALLOC;
>>   	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
>> @@ -364,7 +389,7 @@ xfs_getfsmap_helper(
>>   
>>   	xfs_getfsmap_format(mp, &fmr, info);
>>   out:
>> -	rec_daddr += len_daddr;
>> +	rec_daddr = fmr.fmr_physical + fmr.fmr_length;
>>   	if (info->next_daddr < rec_daddr)
>>   		info->next_daddr = rec_daddr;
>>   	return 0;
>> @@ -655,6 +680,13 @@ __xfs_getfsmap_datadev(
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
>>   			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
>>   		}
>>   
>> @@ -946,6 +978,9 @@ xfs_getfsmap(
>>   
>>   	info.next_daddr = head->fmh_keys[0].fmr_physical +
>>   			  head->fmh_keys[0].fmr_length;
>> +	/* Assignment is performed only for the first time. */
>> +	if (head->fmh_keys[0].fmr_length == 0)
>> +		info.start_daddr = info.next_daddr;
>>   	info.fsmap_recs = fsmap_recs;
>>   	info.head = head;
>>   
>> @@ -966,8 +1001,10 @@ xfs_getfsmap(
>>   		 * low key, zero out the low key so that we get
>>   		 * everything from the beginning.
>>   		 */
>> -		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
>> +		if (handlers[i].dev == head->fmh_keys[1].fmr_device) {
>>   			dkeys[1] = head->fmh_keys[1];
>> +			info.end_daddr = dkeys[1].fmr_physical + dkeys[1].fmr_length;
>> +		}
>>   		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
>>   			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
>>   
>> @@ -991,6 +1028,7 @@ xfs_getfsmap(
>>   		xfs_trans_cancel(tp);
>>   		tp = NULL;
>>   		info.next_daddr = 0;
>> +		info.start_daddr = 0;
>>   	}
>>   
>>   	if (tp)
>> -- 
>> 2.39.2
>>
>>
