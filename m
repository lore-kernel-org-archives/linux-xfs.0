Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17758 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdK2So0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:44:26 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 14/17] xfs: remove parent pointers in unlink
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-15-git-send-email-allison.henderson@oracle.com>
 <20171128182424.GK21412@magnolia>
Message-ID: <6b334478-9633-7de0-a087-be3d561c55ef@oracle.com>
Date: Wed, 29 Nov 2017 11:44:22 -0700
MIME-Version: 1.0
In-Reply-To: <20171128182424.GK21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 11/28/2017 11:24 AM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:42AM -0700, Allison Henderson wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> This patch removes the parent pointer attribute during unlink
>>
>> [bfoster: rebase, use VFS inode generation]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
>> 	   implemented xfs_attr_remove_parent]
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_parent.c | 20 ++++++++++++++++++++
>>   fs/xfs/xfs_attr.h          |  4 ++++
>>   fs/xfs/xfs_inode.c         | 10 +++++++++-
>>   3 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
>> index 5eec0ab..9278c89 100644
>> --- a/fs/xfs/libxfs/xfs_parent.c
>> +++ b/fs/xfs/libxfs/xfs_parent.c
>> @@ -91,3 +91,23 @@ xfs_parent_add(
>>   		(void *)child_name->name, child_name->len, ATTR_PARENT);
>>   }
>>   
>> +/*
>> + * Remove a parent record from a child inode.
>> + */
>> +int
>> +xfs_parent_remove(
>> +        struct xfs_trans        *tp,
> Unused parameter.
>
>> +        struct xfs_inode        *parent,
>> +        struct xfs_inode        *child,
>> +        xfs_dir2_dataptr_t      diroffset,
>> +	struct xfs_defer_ops    *dfops,
> Inconsistent indenting here.
>
>> +	xfs_fsblock_t           *firstblock)
> Unused parameter.
>
>> +{
>> +	struct xfs_parent_name_rec rec;
>> +
>> +	xfs_init_parent_name_rec(&rec, parent->i_ino,
>> +		VFS_I(parent)->i_generation, diroffset);
> Two tabs, please...
>
>> +
>> +	return xfs_attr_remove_deferred(child, dfops, &rec, sizeof(rec),
>> +					ATTR_PARENT);
> ...or this indentation style.
>
>> +}
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index 09ef747..0829687 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -198,4 +198,8 @@ int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
>>   		struct xfs_inode *child, struct xfs_name *child_name,
>>   		xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
>>   		xfs_fsblock_t *firstblock);
>> +int xfs_parent_remove(struct xfs_trans *tp, struct xfs_inode *parent,
>> +		      struct xfs_inode *child, xfs_dir2_dataptr_t diroffset,
>> +		      struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
>> +
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 0ad843d..a289a40 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2607,6 +2607,7 @@ xfs_remove(
>>   	struct xfs_defer_ops	dfops;
>>   	xfs_fsblock_t           first_block;
>>   	uint			resblks;
>> +	uint32_t		dir_offset;
> xfs_dir2_dataptr_t	dir_offset; ?
>
> --D
>
Alrighty, I'll fold all these in.  Thx!
>>   
>>   	trace_xfs_remove(dp, name);
>>   
>> @@ -2687,12 +2688,19 @@ xfs_remove(
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
>> +		error = xfs_parent_remove(tp, dp, ip, dir_offset, &dfops,
>> +					  &first_block);
>> +		if (error)
>> +			goto out_bmap_cancel;
>> +	}
>> +
>>   	/*
>>   	 * If this is a synchronous mount, make sure that the
>>   	 * remove transaction goes to disk before returning to
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

