Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42990 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754812AbeEHQ61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:58:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48GpW43168304
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hs24shqgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 16:58:27 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w48GwQn7004116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:26 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48GwP36013297
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:25 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 17/21] xfs: remove parent pointers in unlink
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-18-git-send-email-allison.henderson@oracle.com>
 <20180507215942.GE11261@magnolia>
Message-ID: <ad9d6fc6-e30d-b267-97d7-f56937854c77@oracle.com>
Date: Tue, 8 May 2018 09:58:24 -0700
MIME-Version: 1.0
In-Reply-To: <20180507215942.GE11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 05/07/2018 02:59 PM, Darrick J. Wong wrote:
> On Sun, May 06, 2018 at 10:24:50AM -0700, Allison Henderson wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> This patch removes the parent pointer attribute during unlink
>>
>> [bfoster: rebase, use VFS inode generation]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
>> 	   implemented xfs_attr_remove_parent]
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_inode.c        | 21 ++++++++++++++++-----
>>   fs/xfs/xfs_parent_utils.c | 19 +++++++++++++++++++
>>   fs/xfs/xfs_parent_utils.h |  4 ++++
>>   3 files changed, 39 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 3a68e72..b18b20c 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2624,6 +2624,7 @@ xfs_remove(
>>   	struct xfs_defer_ops	dfops;
>>   	xfs_fsblock_t           first_block;
>>   	uint			resblks;
>> +	xfs_dir2_dataptr_t	dir_offset;
>>   
>>   	trace_xfs_remove(dp, name);
>>   
>> @@ -2661,8 +2662,8 @@ xfs_remove(
>>   
>>   	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
>>   
>> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, dp, 0);
>> +	xfs_trans_ijoin(tp, ip, 0);
>>   
>>   	/*
>>   	 * If we're removing a directory perform some additional validation.
>> @@ -2704,12 +2705,18 @@ xfs_remove(
>>   
>>   	xfs_defer_init(&dfops, &first_block);
>>   	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
>> -				   &dfops, resblks, NULL);
>> +				   &dfops, resblks, &dir_offset);
>>   	if (error) {
>>   		ASSERT(error != -ENOENT);
>>   		goto out_bmap_cancel;
>>   	}
>>   
>> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +		error = xfs_parent_remove_deferred(dp, ip, dir_offset, &dfops);
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +	}
>> +
>>   	/*
>>   	 * If this is a synchronous mount, make sure that the
>>   	 * remove transaction goes to disk before returning to
>> @@ -2724,17 +2731,21 @@ xfs_remove(
>>   
>>   	error = xfs_trans_commit(tp);
>>   	if (error)
>> -		goto std_return;
>> +		goto out_unlock;
>>   
>>   	if (is_dir && xfs_inode_is_filestream(ip))
>>   		xfs_filestream_deassociate(ip);
>>   
>> -	return 0;
>> +	error = 0;
>> +	goto out_unlock;
> 
> I'd unlock the two inodes directly here instead of mixing the sucess
> return path with the error paths.

Sure, will fix.  Thx!

Allison
> 
>>   
>>    out_bmap_cancel:
>>   	xfs_defer_cancel(&dfops);
>>    out_trans_cancel:
>>   	xfs_trans_cancel(tp);
>> +out_unlock:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>    std_return:
>>   	return error;
>>   }
>> diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
>> index cf4a7e2..0fd48b8 100644
>> --- a/fs/xfs/xfs_parent_utils.c
>> +++ b/fs/xfs/xfs_parent_utils.c
>> @@ -49,3 +49,22 @@ xfs_parent_add_deferred(
>>   		(void *)child_name->name, child_name->len, ATTR_PARENT);
>>   }
>>   
>> +/*
>> + * Remove a parent record from a child inode.
>> + */
>> +int
>> +xfs_parent_remove_deferred(
>> +	struct xfs_inode	*parent,
>> +	struct xfs_inode	*child,
>> +	xfs_dir2_dataptr_t	diroffset,
>> +	struct xfs_defer_ops	*dfops)
>> +{
>> +	struct xfs_parent_name_rec rec;
>> +
>> +	xfs_init_parent_name_rec(&rec, parent->i_ino,
>> +				 VFS_I(parent)->i_generation, diroffset);
>> +
>> +	return xfs_attr_remove_deferred(child, dfops, &rec, sizeof(rec),
>> +					ATTR_PARENT);
> 
> Two indents, no need to align these with the left paren.
> 
> --D
> 
>> +}
>> +
>> diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
>> index a667d1d..9e0ac13 100644
>> --- a/fs/xfs/xfs_parent_utils.h
>> +++ b/fs/xfs/xfs_parent_utils.h
>> @@ -23,4 +23,8 @@
>>   int xfs_parent_add_deferred(struct xfs_inode *parent, struct xfs_inode *child,
>>   	       struct xfs_name *child_name, uint32_t diroffset,
>>   	       struct xfs_defer_ops *dfops);
>> +int xfs_parent_remove_deferred(struct xfs_inode *parent,
>> +			       struct xfs_inode *child,
>> +			       xfs_dir2_dataptr_t diroffset,
>> +			       struct xfs_defer_ops *dfops);
>>   #endif	/* __XFS_PARENT_UTILS_H__ */
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=KflT8_xtU5yMnGOwd0ZPCW2pBFzUSMyjcHn0gtvVEEs&s=KWZgWUtvv6RGSfjy5GjFPxiTq-ep3IqjgXLV5P52qX0&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=KflT8_xtU5yMnGOwd0ZPCW2pBFzUSMyjcHn0gtvVEEs&s=KWZgWUtvv6RGSfjy5GjFPxiTq-ep3IqjgXLV5P52qX0&e=
> 
