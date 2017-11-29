Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17363 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdK2Snb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:43:31 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATIhUDM026125
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:43:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vATIhUC3013608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:43:30 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vATIhT7P031163
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:43:30 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 15/17] Add parent pointers to rename
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-16-git-send-email-allison.henderson@oracle.com>
 <20171128182040.GJ21412@magnolia>
Message-ID: <58e89a7c-9cc7-73f7-5d3b-389ba951c75a@oracle.com>
Date: Wed, 29 Nov 2017 11:43:29 -0700
MIME-Version: 1.0
In-Reply-To: <20171128182040.GJ21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/2017 11:20 AM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:43AM -0700, Allison Henderson wrote:
>> This patch removes the old parent pointer attribute during the
>> rename operation, and re-adds the updated parent pointer
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_dir2.c |  6 ++++--
>>   fs/xfs/xfs_inode.c       | 26 ++++++++++++++++++++------
>>   2 files changed, 24 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 25b370b..ed25203 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -324,10 +324,11 @@ xfs_dir_createname(
>>   	else
>>   		rval = xfs_dir2_node_addname(args);
>>   
>> +out_free:
>>   	/* return the location that this entry was place in the parent inode */
>>   	if (offset)
>>   		*offset = args->offset;
>> -out_free:
>> +
>>   	kmem_free(args);
>>   	return rval;
>>   }
>> @@ -496,9 +497,10 @@ xfs_dir_removename(
>>   		rval = xfs_dir2_leaf_removename(args);
>>   	else
>>   		rval = xfs_dir2_node_removename(args);
>> +out_free:
>>   	if (offset)
>>   		*offset = args->offset;
>> -out_free:
>> +
> Why do these labels need to be moved here?  The *offset = ... lines are
> new, so why not put them in their final place in the patch that adds
> those lines?
Ok, if I recall correctly, I think I had found a bug where the offset 
was not getting set when it should have, and fixed it when I added the 
rename patch to the original set.  I will fold these down into their 
respective patches.
>>   	kmem_free(args);
>>   	return rval;
>>   }
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index a289a40..da5c761 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2984,6 +2984,8 @@ xfs_rename(
>>   	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>>   	int			spaceres;
>>   	int			error;
>> +	xfs_dir2_dataptr_t	new_diroffset;
>> +	xfs_dir2_dataptr_t	old_diroffset;
>>   
>>   	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>>   
>> @@ -3086,13 +3088,12 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_createname(tp, target_dp, target_name,
>>   					   src_ip->i_ino, &first_block, &dfops,
>> -					   spaceres, NULL);
>> +					   spaceres, &new_diroffset);
>>   		if (error)
>>   			goto out_bmap_cancel;
>>   
>>   		xfs_trans_ichgtime(tp, target_dp,
>>   					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>> -
> Huh?
>
Sorry, will fix
>>   		if (new_parent && src_is_directory) {
>>   			error = xfs_bumplink(tp, target_dp);
>>   			if (error)
>> @@ -3126,7 +3127,7 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_replace(tp, target_dp, target_name,
>>   					src_ip->i_ino, &first_block, &dfops,
>> -					spaceres, NULL);
>> +					spaceres, &new_diroffset);
>>   		if (error)
>>   			goto out_bmap_cancel;
>>   
>> @@ -3161,7 +3162,7 @@ xfs_rename(
>>   		 */
>>   		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
>>   					target_dp->i_ino, &first_block, &dfops,
>> -					spaceres, NULL);
>> +					spaceres, &new_diroffset);
>>   		ASSERT(error != -EEXIST);
>>   		if (error)
>>   			goto out_bmap_cancel;
>> @@ -3200,11 +3201,12 @@ xfs_rename(
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
>> @@ -3234,6 +3236,18 @@ xfs_rename(
>>   		VFS_I(wip)->i_state &= ~I_LINKABLE;
>>   	}
>>   
>> +	if (new_parent && xfs_sb_version_hasparent(&mp->m_sb)) {
> I'm confused about checking new_parent -- does this cause us to forget
> to update the pptr for a rename within a directory?
>
> I'm assuming that all of these directory operations will get their own
> xfstests in time... (create a file, check pptr; hardlink a file, check
> both pptrs; delete one of the links, check pptrs; check pptr after a
> rename within a dir; check pptr after a rename between dirs; etc.)
>
> --D
Oh, initially I had added this with the thought that we update parent 
pointers when we get new parents, but I think you're right. We'll need 
to update if the name changes too.  I will take out the new_parent 
check.  Thx!
>> +		error = xfs_parent_add(tp, target_dp, src_ip, target_name,
>> +				       new_diroffset, &dfops, &first_block);
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +
>> +		error = xfs_parent_remove(tp, src_dp, src_ip,
>> +					  old_diroffset, &dfops, &first_block);
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +	}
>> +
>>   	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>>   	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>>   	if (new_parent)
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

