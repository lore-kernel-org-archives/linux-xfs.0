Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43098 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754506AbeEHQ6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:58:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48GpEbf167874
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:40 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24shqhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 16:58:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w48Gwd5J032000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:39 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48GwdTC013363
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:39 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 16/21] xfs: add parent attributes to link
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-17-git-send-email-allison.henderson@oracle.com>
 <20180507221202.GF11261@magnolia>
Message-ID: <9fcf4e1b-6e48-e1eb-1b91-d696c91058c8@oracle.com>
Date: Tue, 8 May 2018 09:58:38 -0700
MIME-Version: 1.0
In-Reply-To: <20180507221202.GF11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 05/07/2018 03:12 PM, Darrick J. Wong wrote:
> On Sun, May 06, 2018 at 10:24:49AM -0700, Allison Henderson wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> This patch modifies xfs_link to add a parent pointer to the inode.
>> xfs_link will also need to create an attribute fork if the inode does
>> not already have one.
>>
>> [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>> 	   fixed null pointer bugs]
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_inode.c | 66 ++++++++++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 52 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index a515f11..3a68e72 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1421,6 +1421,8 @@ xfs_link(
>>   	struct xfs_defer_ops	dfops;
>>   	xfs_fsblock_t           first_block;
>>   	int			resblks;
>> +	xfs_dir2_dataptr_t	diroffset;
>> +	bool			first_parent = false;
>>   
>>   	trace_xfs_link(tdp, target_name);
>>   
>> @@ -1437,6 +1439,25 @@ xfs_link(
>>   	if (error)
>>   		goto std_return;
>>   
>> +	/*
>> +	 * If we have parent pointers and there is no attribute fork (i.e. we
>> +	 * are linking in a O_TMPFILE created inode) we need to add the
>> +	 * attribute fork to the inode. Because we may have an existing data
>> +	 * fork, we do this before we start the link transaction as adding an
>> +	 * attribute fork requires it's own transaction.
>> +	 */
>> +	if (xfs_sb_version_hasparent(&mp->m_sb) && !xfs_inode_hasattr(sip)) {
>> +		int sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +				XFS_ATTR_SF_ENTSIZE_BYNAME(
>> +					sizeof(struct xfs_parent_name_rec),
>> +					target_name->len);
>> +		ASSERT(VFS_I(sip)->i_nlink == 0);
>> +		error = xfs_bmap_add_attrfork(sip, sf_size, 0);
>> +		if (error)
>> +			goto std_return;
>> +		first_parent = true;
> 
> Can adding the attribute fork ought to be made part of the finish step
> for deferred xattr setting?  xfs_attr_finish_item() could do something
> like:
> 
> 	if (!xfs_inode_hasattr(ip)) {
> 		sf_size = sizeof(...) + free->xattri_name_len;
> 		error = xfs_bmap_add_attrfork(free->xattri_ip, sf_size, 0);
> 		if (error)
> 			goto out_free;
> 		return -EAGAIN;
> 	}
> 
> 	error = xfs_trans_attr(...existing stuff...);
> 	kmem_free(free);
> out_free:
> 	return error;
> 
> The 'return -EAGAIN' tells the log item code that it needs to roll the
> transaction and then call us back to add the attr.
> 
> --D
> 
Sure, I will see if I can get it moved over there then.  Thx!

Allison

>> +	}
>> +
>>   	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
>>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
>>   	if (error == -ENOSPC) {
>> @@ -1448,8 +1469,8 @@ xfs_link(
>>   
>>   	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
>>   
>> -	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>> -	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, sip, 0);
>> +	xfs_trans_ijoin(tp, tdp, 0);
>>   
>>   	/*
>>   	 * If we are using project inheritance, we only allow hard link
>> @@ -1468,8 +1489,6 @@ xfs_link(
>>   			goto error_return;
>>   	}
>>   
>> -	xfs_defer_init(&dfops, &first_block);
>> -
>>   	/*
>>   	 * Handle initial link state of O_TMPFILE inode
>>   	 */
>> @@ -1479,16 +1498,30 @@ xfs_link(
>>   			goto error_return;
>>   	}
>>   
>> +	xfs_defer_init(&dfops, &first_block);
>>   	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
>> -				   &first_block, &dfops, resblks, NULL);
>> +				   &first_block, &dfops, resblks, &diroffset);
>>   	if (error)
>> -		goto error_return;
>> +		goto out_defer_cancel;
>>   	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>>   	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
>>   
>>   	error = xfs_bumplink(tp, sip);
>>   	if (error)
>> -		goto error_return;
>> +		goto out_defer_cancel;
>> +
>> +	/*
>> +	 * If we have parent pointers, we now need to add the parent record to
>> +	 * the attribute fork of the inode. If this is the initial parent
>> +	 * attribute, we need to create it correctly, otherwise we can just add
>> +	 * the parent to the inode.
>> +	 */
>> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +		error = xfs_parent_add_deferred(tdp, sip, target_name,
>> +				       diroffset, &dfops);
>> +		if (error)
>> +			goto out_defer_cancel;
>> +	}
>>   
>>   	/*
>>   	 * If this is a synchronous mount, make sure that the
>> @@ -1499,16 +1532,21 @@ xfs_link(
>>   		xfs_trans_set_sync(tp);
>>   
>>   	error = xfs_defer_finish(&tp, &dfops);
>> -	if (error) {
>> -		xfs_defer_cancel(&dfops);
>> -		goto error_return;
>> -	}
>> +	if (error)
>> +		goto out_defer_cancel;
>>   
>> -	return xfs_trans_commit(tp);
>> +	error = xfs_trans_commit(tp);
>> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>> +	return error;
>>   
>> - error_return:
>> +out_defer_cancel:
>> +	xfs_defer_cancel(&dfops);
>> +error_return:
>>   	xfs_trans_cancel(tp);
>> - std_return:
>> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>> +std_return:
>>   	return error;
>>   }
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
