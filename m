Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRClF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2aHnm042139
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2hdrxp0jyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2f4rA011371
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:04 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2f4hf025703
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:04 GMT
Subject: Re: [PATCH 1/1] xfs: fix a null pointer dereference in
 xfs_bmap_extents_to_btree
References: <1524017385-6671-1-git-send-email-shan.hai@oracle.com>
 <9fbccc81-103f-5b21-af3c-e32b82eba24b@oracle.com>
 <20180418022426.GL24738@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <49bd78f6-8c4d-c51a-6fa1-02529f0da7ca@oracle.com>
Date: Wed, 18 Apr 2018 10:41:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180418022426.GL24738@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年04月18日 10:24, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 10:13:22AM +0800, Shan Hai wrote:
>>
>> On 2018年04月18日 10:09, Shan Hai wrote:
>>> Fuzzing tool reports a write to null pointer error in the
>>> xfs_bmap_extents_to_btree, fix it by bailing out on encountering
>>> a null pointer.
>>>
>>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> This one supposed to be applied on top of below:
>>
>> https://www.spinics.net/lists/linux-xfs/msg17254.html
>> [PATCH] xfs: set format back to extents if xfs_bmap_extents_to_btree fails
>>
>> Thanks
>> Shan Hai
>>> ---
>>>   fs/xfs/libxfs/xfs_bmap.c | 24 ++++++++++++++++--------
>>>   1 file changed, 16 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>>> index 040eeda..90b743d 100644
>>> --- a/fs/xfs/libxfs/xfs_bmap.c
>>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>>> @@ -724,19 +724,14 @@ xfs_bmap_extents_to_btree(
>>>   	args.wasdel = wasdel;
>>>   	*logflagsp = 0;
>>>   	if ((error = xfs_alloc_vextent(&args))) {
>>> -		xfs_iroot_realloc(ip, -1, whichfork);
>>>   		ASSERT(ifp->if_broot == NULL);
>>> -		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
>>> -		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>>> -		return error;
>>> +		goto err1;
>>>   	}
>>>   	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>>> -		xfs_iroot_realloc(ip, -1, whichfork);
>>>   		ASSERT(ifp->if_broot == NULL);
>>> -		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
>>> -		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>>> -		return -ENOSPC;
>>> +		error = -ENOSPC;
>>> +		goto err1;
>>>   	}
>>>   	/*
>>>   	 * Allocation can't fail, the space was reserved.
>>> @@ -748,6 +743,10 @@ xfs_bmap_extents_to_btree(
>>>   	ip->i_d.di_nblocks++;
>>>   	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
>>>   	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
>>> +	if (!abp) {
> When does this happen?  We got args.fsbno from the allocator, so we're
> not out of space.  Or are you saying that something fuzzed the free
> space btree, therefore the allocator gave back a nonsense block number
> (say pointing past the end of the fs), and therefore the _get_bufl call
> returned NULL?

Seems the memory  page allocation fails and the xfs_btree_get_bufl
returns NULL, but I have no reliable reproducer, sorry.

Thanks
Shan Hai
> If so, maybe we need to change that WARN_ON_ONCE thing above to:
>
> if (WARN_ON_ONCE(...) || !xfs_verify_fsbno(..., args.fsbno)) {
> 	/* undo state and return */
> }
>
> --D
>
>>> +		error = -ENOSPC;
>>> +		goto err2;
>>> +	}
>>>   	/*
>>>   	 * Fill in the child block.
>>>   	 */
>>> @@ -787,6 +786,15 @@ xfs_bmap_extents_to_btree(
>>>   	*curp = cur;
>>>   	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
>>>   	return 0;
>>> +
>>> +err2:
>>> +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>>> +err1:
>>> +	xfs_iroot_realloc(ip, -1, whichfork);
>>> +	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
>>> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>>> +
>>> +	return error;
>>>   }
>>>   /*
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

