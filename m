Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47401 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJUBMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:12:23 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L1CMZj025167
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:12:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L1CLHe030643
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:12:22 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L1CLpm021883
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:12:21 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 13/17] xfs: add parent attributes to link
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-14-git-send-email-allison.henderson@oracle.com>
 <20171019194015.GH4755@magnolia>
Message-ID: <f3fad097-0d0a-f454-f443-fa2aba9419a6@oracle.com>
Date: Fri, 20 Oct 2017 18:12:17 -0700
MIME-Version: 1.0
In-Reply-To: <20171019194015.GH4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 10/19/2017 12:40 PM, Darrick J. Wong wrote:

> On Wed, Oct 18, 2017 at 03:55:29PM -0700, Allison Henderson wrote:
>> From: Dave Chinner<dchinner@redhat.com>
> Needs a description of what w're doing and maybe why...
>
Sure, I think initially these had quick one line descriptions that
got formatted into the subject line when I created the patch set

>> [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>> 	   fixed null pointer bugs]
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c   | 20 +++++++++++++-
>>   fs/xfs/libxfs/xfs_parent.c | 43 ++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr.h          | 10 +++++++
>>   fs/xfs/xfs_inode.c         | 66 ++++++++++++++++++++++++++++++++++++----------
>>   4 files changed, 124 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 8aad242..e7692ef 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -35,6 +35,7 @@
>>   #include "xfs_bmap_util.h"
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_attr.h"
>> +#include "xfs_attr_sf.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_error.h"
>> @@ -266,6 +267,23 @@ xfs_attr_set_first_parent(
>>   	return error;
>>   }
>>   
>> +int
>> +xfs_attr_set_parent(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*ip,
>> +	struct xfs_parent_name_rec *rec,
>> +	int			reclen,
>> +	const char		*value,
>> +	int			valuelen,
>> +	struct xfs_defer_ops	*dfops,
>> +	xfs_fsblock_t		*firstblock)
>> +{
>> +	int                     flags = ATTR_PARENT;
>> +
>> +	return xfs_attr_set_deferred(ip, dfops, (char *)rec, reclen,
>> +				    (char *)value, valuelen, flags);
>> +}
>> +
>>   /*
>>    * set the attribute specified in @args. In the case of the parent attribute
>>    * being set, we do not want to roll the transaction on shortform-to-leaf
>> @@ -512,8 +530,8 @@ xfs_attr_set(
>>   	 */
>>   	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
>>   	error = xfs_trans_commit(args.trans);
>> -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>   
>> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>   	return error;
>>   
>>   out_defer_cancel:
>> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
>> index 88f7edc..0707336 100644
>> --- a/fs/xfs/libxfs/xfs_parent.c
>> +++ b/fs/xfs/libxfs/xfs_parent.c
>> @@ -96,3 +96,46 @@ xfs_parent_create(
>>   
>>   	return xfs_parent_create_nrec(tp, child, &nrec, dfops, firstblock);
>>   }
>> +
>> +static int
>> +xfs_parent_add_nrec(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*child,
>> +	struct xfs_parent_name_irec *nrec,
>> +	struct xfs_defer_ops	*dfops,
>> +	xfs_fsblock_t		*firstblock)
>> +{
>> +	struct xfs_parent_name_rec rec;
>> +
>> +	rec.p_ino = cpu_to_be64(nrec->p_ino);
>> +	rec.p_gen = cpu_to_be32(nrec->p_gen);
>> +	rec.p_diroffset = cpu_to_be32(nrec->p_diroffset);
>> +
>> +	return xfs_attr_set_parent(tp, child, &rec, sizeof(rec),
>> +				   nrec->p_name, nrec->p_namelen,
>> +				   dfops, firstblock);
>> +}
>> +
>> +/*
>> + * Add a parent record to an inode with existing parent records.
>> + */
>> +int
>> +xfs_parent_add(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*parent,
>> +	struct xfs_inode	*child,
>> +	struct xfs_name		*child_name,
>> +	uint32_t		diroffset,
>> +	struct xfs_defer_ops	*dfops,
>> +	xfs_fsblock_t		*firstblock)
>> +{
>> +	struct xfs_parent_name_irec nrec;
>> +
>> +	nrec.p_ino = parent->i_ino;
>> +	nrec.p_gen = VFS_I(parent)->i_generation;
>> +	nrec.p_diroffset = diroffset;
>> +	nrec.p_name = child_name->name;
>> +	nrec.p_namelen = child_name->len;
>> +
>> +	return xfs_parent_add_nrec(tp, child, &nrec, dfops, firstblock);
>> +}
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index b48e31b..acb6157 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -197,4 +197,14 @@ int xfs_attr_set_first_parent(struct xfs_trans *tp, struct xfs_inode *ip,
>>   			      const char *value, int valuelen,
>>   			      struct xfs_defer_ops *dfops,
>>   			      xfs_fsblock_t *firstblock);
>> +
>> +int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
>> +		   struct xfs_inode *child, struct xfs_name *child_name,
>> +		   xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
>> +		   xfs_fsblock_t *firstblock);
>> +int xfs_attr_set_parent(struct xfs_trans *tp, struct xfs_inode *ip,
>> +			struct xfs_parent_name_rec *rec, int reclen,
>> +			const char *value, int valuelen,
>> +			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
>> +
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 4396561..51b623b 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1451,6 +1451,8 @@ xfs_link(
>>   	struct xfs_defer_ops	dfops;
>>   	xfs_fsblock_t           first_block;
>>   	int			resblks;
>> +	uint32_t		diroffset;
>> +	bool			first_parent = false;
>>   
>>   	trace_xfs_link(tdp, target_name);
>>   
>> @@ -1467,6 +1469,25 @@ xfs_link(
>>   	if (error)
>>   		goto std_return;
>>   
>> +	/*
>> +	 * If we have parent pointers and there is no attribute fork (i.e. we
>> +	 * are linking in a O_TMPFILE created inode) we need to add the
>> +	 * attribute fork to the inode. Because we may have an existing data
>> +	 * fork, we do this before we start the link transaction as adding an
>> +	 * attribute fork requires it's own transaction.
> Ok, so an inode that isn't pointed to by any directory will have zero
> parent link attributes and possibly not even an attr fork.  Got it.
>
> --D
>
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
>> +	}
>> +
>>   	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
>>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
>>   	if (error == -ENOSPC) {
>> @@ -1498,8 +1519,6 @@ xfs_link(
>>   			goto error_return;
>>   	}
>>   
>> -	xfs_defer_init(&dfops, &first_block);
>> -
>>   	/*
>>   	 * Handle initial link state of O_TMPFILE inode
>>   	 */
>> @@ -1509,36 +1528,55 @@ xfs_link(
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
>>   
>>   	/*
>> -	 * If this is a synchronous mount, make sure that the
>> -	 * link transaction goes to disk before returning to
>> -	 * the user.
>> +	 * If we have parent pointers, we now need to add the parent record to
>> +	 * the attribute fork of the inode. If this is the initial parent
>> +	 * atribute, we need to create it correctly, otherwise we can just add
>> +	 * the parent to the inode.
>> +	 */
>> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
>> +		if (first_parent)
>> +			error = xfs_parent_create(tp, tdp, sip, target_name,
>> +						  diroffset, &dfops,
>> +						  &first_block);
>> +		else
>> +			error = xfs_parent_add(tp, tdp, sip, target_name,
>> +					       diroffset, &dfops,
>> +					       &first_block);
>> +		if (error)
>> +			goto out_defer_cancel;
>> +	}
>> +
>> +	/*
>> +	 * If this is a synchronous mount, make sure that the link transaction
>> +	 * goes to disk before returning to the user.
>>   	 */
>>   	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
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
>>   	return xfs_trans_commit(tp);
>>   
>> - error_return:
>> +out_defer_cancel:
>> +	xfs_defer_cancel(&dfops);
>> +error_return:
>>   	xfs_trans_cancel(tp);
>> - std_return:
>> +std_return:
>>   	return error;
>>   }
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

