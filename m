Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbeEHQ6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 12:58:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48GpCm6003970
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:21 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hs426hmdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 16:58:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w48GwK2p031229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:20 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48GwKQG022104
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 16:58:20 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 18/21] xfs: Add parent pointers to rename
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-19-git-send-email-allison.henderson@oracle.com>
 <20180507215220.GD11261@magnolia>
Message-ID: <04a229c3-ecde-e3c4-bec4-c5f2eb811756@oracle.com>
Date: Tue, 8 May 2018 09:58:19 -0700
MIME-Version: 1.0
In-Reply-To: <20180507215220.GD11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 05/07/2018 02:52 PM, Darrick J. Wong wrote:
> On Sun, May 06, 2018 at 10:24:51AM -0700, Allison Henderson wrote:
>> This patch removes the old parent pointer attribute during the
>> rename operation, and re-adds the updated parent pointer
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_inode.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 52 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index b18b20c..7fd1479 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -3004,6 +3004,8 @@ xfs_rename(
>>   	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>>   	int			spaceres;
>>   	int			error;
>> +	xfs_dir2_dataptr_t	new_diroffset;
>> +	xfs_dir2_dataptr_t	old_diroffset;
>>   
>>   	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>>   
>> @@ -3058,14 +3060,14 @@ xfs_rename(
>>   	 * we can rely on either trans_commit or trans_cancel to unlock
>>   	 * them.
>>   	 */
>> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, src_dp, 0);
>>   	if (new_parent)
>> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
>> -	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
>> +		xfs_trans_ijoin(tp, target_dp, 0);
>> +	xfs_trans_ijoin(tp, src_ip, 0);
>>   	if (target_ip)
>> -		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
>> +		xfs_trans_ijoin(tp, target_ip, 0);
>>   	if (wip)
>> -		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
>> +		xfs_trans_ijoin(tp, wip, 0);
>>   
>>   	/*
>>   	 * If we are using project inheritance, we only allow renames
>> @@ -3075,17 +3077,18 @@ xfs_rename(
>>   	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
>>   		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
>>   		error = -EXDEV;
>> -		goto out_trans_cancel;
>> +		goto out_unlock;
>>   	}
>>   
>>   	xfs_defer_init(&dfops, &first_block);
>>   
>>   	/* RENAME_EXCHANGE is unique from here on. */
>> -	if (flags & RENAME_EXCHANGE)
>> -		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
>> +	if (flags & RENAME_EXCHANGE) {
>> +		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>>   					target_dp, target_name, target_ip,
>>   					&dfops, &first_block, spaceres);
>> -
>> +		goto out;
>> +	}
>>   	/*
>>   	 * Set up the target.
>>   	 */
>> @@ -3097,7 +3100,7 @@ xfs_rename(
>>   		if (!spaceres) {
>>   			error = xfs_dir_canenter(tp, target_dp, target_name);
>>   			if (error)
>> -				goto out_trans_cancel;
>> +				goto out_unlock;
>>   		}
>>   		/*
>>   		 * If target does not exist and the rename crosses
>> @@ -3106,7 +3109,7 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_createname(tp, target_dp, target_name,
>>   					   src_ip->i_ino, &first_block, &dfops,
>> -					   spaceres, NULL);
>> +					   spaceres, &new_diroffset);
>>   		if (error)
>>   			goto out_bmap_cancel;
>>   
>> @@ -3131,7 +3134,7 @@ xfs_rename(
>>   			if (!(xfs_dir_isempty(target_ip)) ||
>>   			    (VFS_I(target_ip)->i_nlink > 2)) {
>>   				error = -EEXIST;
>> -				goto out_trans_cancel;
>> +				goto out_unlock;
>>   			}
>>   		}
>>   
>> @@ -3146,7 +3149,7 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_replace(tp, target_dp, target_name,
>>   					src_ip->i_ino, &first_block, &dfops,
>> -					spaceres, NULL);
>> +					spaceres, &new_diroffset);
>>   		if (error)
>>   			goto out_bmap_cancel;
>>   
>> @@ -3181,7 +3184,7 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
>>   					target_dp->i_ino, &first_block, &dfops,
>> -					spaceres, NULL);
>> +					spaceres, &new_diroffset);
>>   		ASSERT(error != -EEXIST);
>>   		if (error)
>>   			goto out_bmap_cancel;
>> @@ -3220,11 +3223,12 @@ xfs_rename(
>>   	 */
>>   	if (wip) {
>>   		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
>> -					&first_block, &dfops, spaceres, NULL);
>> +					&first_block, &dfops, spaceres,
>> +					&old_diroffset);
>>   	} else
>>   		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>>   					   &first_block, &dfops, spaceres,
>> -					   NULL);
>> +					   &old_diroffset);
>>   	if (error)
>>   		goto out_bmap_cancel;
>>   
>> @@ -3254,6 +3258,18 @@ xfs_rename(
>>   		VFS_I(wip)->i_state &= ~I_LINKABLE;
>>   	}
>>   
>> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +		error = xfs_parent_add_deferred(target_dp, src_ip, target_name,
>> +				       new_diroffset, &dfops);
> 
> Only two indents needed for the second line:
> 
> 		error = xfs_parent_add_deferred(target_dp, src_ip, target_name,
> 				new_diroffset, &dfops);
> 		if (error)
> 			goto out_bmap_cancel;
> 
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +
>> +		error = xfs_parent_remove_deferred(src_dp, src_ip,
>> +						   old_diroffset, &dfops);
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +	}
>> +
>>   	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>>   	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>>   	if (new_parent)
>> @@ -3262,10 +3278,30 @@ xfs_rename(
>>   	error = xfs_finish_rename(tp, &dfops);
>>   	if (wip)
>>   		IRELE(wip);
>> +out:
>> +	if (wip)
>> +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
> 
> IRELE = iput = release inode, which means that you have to unlock the
> wip inode before you can release it.
> 
> --D
> 
Ok, I'll move that down and fix indents.  Thx!

Allison


>> +	if (target_ip)
>> +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
>> +	if (new_parent)
>> +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
>> +
>>   	return error;
>>   
>>   out_bmap_cancel:
>>   	xfs_defer_cancel(&dfops);
>> +out_unlock:
>> +	if (wip)
>> +		xfs_iunlock(wip, XFS_ILOCK_EXCL);
>> +	if (target_ip)
>> +		xfs_iunlock(target_ip, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(src_ip, XFS_ILOCK_EXCL);
>> +	if (new_parent)
>> +		xfs_iunlock(target_dp, XFS_ILOCK_EXCL);
>> +	xfs_iunlock(src_dp, XFS_ILOCK_EXCL);
>> +
>>   out_trans_cancel:
>>   	xfs_trans_cancel(tp);
>>   out_release_wip:
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
