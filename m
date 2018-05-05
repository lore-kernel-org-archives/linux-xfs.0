Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34926 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbeEEFPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 May 2018 01:15:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w455BLKV132405
        for <linux-xfs@vger.kernel.org>; Sat, 5 May 2018 05:15:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24s86f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 05 May 2018 05:15:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w455FBCa025917
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 5 May 2018 05:15:11 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w455FBms032589
        for <linux-xfs@vger.kernel.org>; Sat, 5 May 2018 05:15:11 GMT
Subject: Re: [PATCH 02/18] xfs: Add attibute set and remove helper functions
References: <1524089486-22922-1-git-send-email-allison.henderson@oracle.com>
 <1524089486-22922-3-git-send-email-allison.henderson@oracle.com>
 <20180504223626.GW26569@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1ca035e3-3481-a57b-9435-1b2083822b7d@oracle.com>
Date: Fri, 4 May 2018 22:15:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180504223626.GW26569@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/04/2018 03:36 PM, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 03:11:10PM -0700, Allison Henderson wrote:
>> This patch adds xfs_attr_set_args, xfs_attr_remove_args and
>> xfs_bmap_set_attrforkoff. These sub-routines set or remove the
>> attributes specified in @args. We will use this later for setting
>> parent pointers as a deferred attribute operation.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 359 +++++++++++++++++++++++++++++------------------
>>   fs/xfs/libxfs/xfs_attr.h |   3 +
>>   fs/xfs/libxfs/xfs_bmap.c |  49 ++++---
>>   fs/xfs/libxfs/xfs_bmap.h |   1 +
>>   4 files changed, 259 insertions(+), 153 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ce4a34a..e81d13b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -168,6 +168,223 @@ xfs_attr_get(
>>   }
>>   
>>   /*
>> + * Set the attribute specified in @args. In the case of the parent attribute
>> + * being set, we do not want to roll the transaction on shortform-to-leaf
>> + * conversion, as the attribute must be added in the same transaction as the
>> + * parent directory modifications. Hence @roll_trans needs to be set
>> + * appropriately to control whether the transaction is committed during this
>> + * function.
>> + */
>> +int
>> +xfs_attr_set_args(
>> +	struct xfs_da_args	*args,
>> +	int			flags,
>> +	struct xfs_buf          *leaf_bp,
>> +	bool			roll_trans)
> The transaction roll wasn't optional in the deleted code.  Could you
> please split this into two patches, one to hoist
> xfs_attr_{set,remove}_args, and another to add new functionality?
> This makes it much easier to see the behavioral changes needed for pptrs
> vs. the refactorings done to make code less gross.
>
> --D

Sure, will do.  In a nutshell, normal set attr operations turn the roll 
on, and execute a similar code path that they do now. Delayed ops turn 
the roll off. Because we cant be rolling the transaction until the whole 
operation is done.

I've done a lot of stabilizing since I sent this set out, and found 
quiet a few more areas where we need to do this, so there will be quite 
a bit of change to this patch.  So please do not stress too much about 
it at this point in time.  I will try to get the next version out asap.  
Thank you for the review!

Allison

>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount        *mp = dp->i_mount;
>> +	struct xfs_trans_res    tres;
>> +	int			rsvd = 0;
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +	int			sf_size;
>> +
>> +	/*
>> +	 * New inodes setting the parent pointer attr will
>> +	 * not have an attribute fork yet. So set the attribute
>> +	 * fork appropriately
>> +	 */
>> +	if (XFS_IFORK_Q((args->dp)) == 0) {
>> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> +	}
>> +
>> +	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +			 M_RES(mp)->tr_attrsetrt.tr_logres * args->total;
>> +	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +
>> +	/*
>> +	 * Root fork attributes can use reserved data blocks for this
>> +	 * operation if necessary
>> +	 */
>> +	error = xfs_trans_alloc(mp, &tres, args->total, 0,
>> +				rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
>> +	if (error)
>> +		goto out;
>> +
>> +	error = xfs_trans_reserve_quota_nblks(args->trans, dp, args->total, 0,
>> +					      rsvd ? XFS_QMOPT_RES_REGBLKS |
>> +						     XFS_QMOPT_FORCE_RES :
>> +						     XFS_QMOPT_RES_REGBLKS);
>> +	if (error)
>> +		goto out;
>> +
>> +	xfs_trans_ijoin(args->trans, dp, 0);
>> +	/*
>> +	 * If the attribute list is non-existent or a shortform list,
>> +	 * upgrade it to a single-leaf-block attribute list.
>> +	 */
>> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +	     dp->i_d.di_anextents == 0)) {
>> +
>> +		/*
>> +		 * Build initial attribute list (if required).
>> +		 */
>> +		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> +			xfs_attr_shortform_create(args);
>> +
>> +		/*
>> +		 * Try to add the attr to the attribute list in the inode.
>> +		 */
>> +		error = xfs_attr_shortform_addname(args);
>> +		if (error != -ENOSPC) {
>> +			/*
>> +			 * Commit the shortform mods, and we're done.
>> +			 * NOTE: this is also the error path (EEXIST, etc).
>> +			 */
>> +			ASSERT(args->trans != NULL);
>> +
>> +			/*
>> +			 * If this is a synchronous mount, make sure that
>> +			 * the transaction goes to disk before returning
>> +			 * to the user.
>> +			 */
>> +			if (mp->m_flags & XFS_MOUNT_WSYNC)
>> +				xfs_trans_set_sync(args->trans);
>> +
>> +			if (!error && (flags & ATTR_KERNOTIME) == 0)
>> +				xfs_trans_ichgtime(args->trans, dp,
>> +						   XFS_ICHGTIME_CHG);
>> +
>> +			err2 = xfs_trans_commit(args->trans);
>> +			error = error ? error : err2;
>> +
>> +			goto out;
>> +		}
>> +
>> +		/*
>> +		 * It won't fit in the shortform, transform to a leaf block.
>> +		 * GROT: another possible req'mt for a double-split btree op.
>> +		 */
>> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		if (error)
>> +			goto out;
>> +		/*
>> +		 * Prevent the leaf buffer from being unlocked so that a
>> +		 * concurrent AIL push cannot grab the half-baked leaf
>> +		 * buffer and run into problems with the write verifier.
>> +		 */
>> +		xfs_trans_bhold(args->trans, leaf_bp);
>> +		xfs_defer_bjoin(args->dfops, leaf_bp);
>> +		xfs_defer_ijoin(args->dfops, dp);
>> +		if (roll_trans) {
>> +			error = xfs_defer_finish(&args->trans, args->dfops);
>> +			if (error) {
>> +				args->trans = NULL;
>> +				goto out;
>> +			}
>> +
>> +			/*
>> +			 * Commit the leaf transformation.  We'll need another
>> +			 * (linked) transaction to add the new attribute to the
>> +			 * leaf.
>> +			 */
>> +			error = xfs_trans_roll_inode(&args->trans, dp);
>> +			if (error)
>> +				goto out;
>> +			xfs_trans_bjoin(args->trans, leaf_bp);
>> +				leaf_bp = NULL;
>> +		}
>> +	}
>> +
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_leaf_addname(args);
>> +	else
>> +		error = xfs_attr_node_addname(args);
>> +	if (error)
>> +		goto out;
>> +
>> +	if ((flags & ATTR_KERNOTIME) == 0)
>> +		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>> +
>> +	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + */
>> +int
>> +xfs_attr_remove_args(
>> +	struct xfs_da_args      *args,
>> +	int			flags)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	int			error;
>> +	int                     rsvd = 0;
>> +
>> +	/*
>> +	 * Root fork attributes can use reserved data blocks for this
>> +	 * operation if necessary
>> +	 */
>> +	if (flags & ATTR_ROOT)
>> +		rsvd = XFS_TRANS_RESERVE;
>> +
>> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
>> +		XFS_ATTRRM_SPACE_RES(mp), 0, rsvd, &args->trans);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * No need to make quota reservations here. We expect to release some
>> +	 * blocks not allocate in the common case.
>> +	 */
>> +	xfs_trans_ijoin(args->trans, dp, 0);
>> +
>> +	if (!xfs_inode_hasattr(dp)) {
>> +		error = -ENOATTR;
>> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		error = xfs_attr_shortform_remove(args);
>> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_removename(args);
>> +	} else {
>> +		error = xfs_attr_node_removename(args);
>> +	}
>> +
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * If this is a synchronous mount, make sure that the
>> +	 * transaction goes to disk before returning to the user.
>> +	 */
>> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
>> +		xfs_trans_set_sync(args->trans);
>> +
>> +	if ((flags & ATTR_KERNOTIME) == 0)
>> +		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>> +
>> +	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
>> +
>> +	return error;
>> +
>> +out:
>> +	if (args->trans)
>> +		xfs_trans_cancel(args->trans);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>>   STATIC int
>> @@ -215,10 +432,9 @@ xfs_attr_set(
>>   	struct xfs_buf		*leaf_bp = NULL;
>>   	struct xfs_da_args	args;
>>   	struct xfs_defer_ops	dfops;
>> -	struct xfs_trans_res	tres;
>>   	xfs_fsblock_t		firstblock;
>>   	int			rsvd = (flags & ATTR_ROOT) != 0;
>> -	int			error, err2, local;
>> +	int			error, local;
>>   
>>   	XFS_STATS_INC(mp, xs_attr_set);
>>   
>> @@ -253,114 +469,13 @@ xfs_attr_set(
>>   			return error;
>>   	}
>>   
>> -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
>> -	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> -	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> -
>> -	/*
>> -	 * Root fork attributes can use reserved data blocks for this
>> -	 * operation if necessary
>> -	 */
>> -	error = xfs_trans_alloc(mp, &tres, args.total, 0,
>> -			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>> -	if (error)
>> -		return error;
>> -
>>   	xfs_ilock(dp, XFS_ILOCK_EXCL);
>> -	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
>> -				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
>> -				       XFS_QMOPT_RES_REGBLKS);
>> -	if (error) {
>> -		xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> -		xfs_trans_cancel(args.trans);
>> -		return error;
>> -	}
>>   
>> -	xfs_trans_ijoin(args.trans, dp, 0);
>> +	xfs_defer_init(args.dfops, args.firstblock);
>> +	error = xfs_attr_set_args(&args, flags, leaf_bp, true);
>>   
>> -	/*
>> -	 * If the attribute list is non-existent or a shortform list,
>> -	 * upgrade it to a single-leaf-block attribute list.
>> -	 */
>> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -	     dp->i_d.di_anextents == 0)) {
>> -
>> -		/*
>> -		 * Build initial attribute list (if required).
>> -		 */
>> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> -			xfs_attr_shortform_create(&args);
>> -
>> -		/*
>> -		 * Try to add the attr to the attribute list in
>> -		 * the inode.
>> -		 */
>> -		error = xfs_attr_shortform_addname(&args);
>> -		if (error != -ENOSPC) {
>> -			/*
>> -			 * Commit the shortform mods, and we're done.
>> -			 * NOTE: this is also the error path (EEXIST, etc).
>> -			 */
>> -			ASSERT(args.trans != NULL);
>> -
>> -			/*
>> -			 * If this is a synchronous mount, make sure that
>> -			 * the transaction goes to disk before returning
>> -			 * to the user.
>> -			 */
>> -			if (mp->m_flags & XFS_MOUNT_WSYNC)
>> -				xfs_trans_set_sync(args.trans);
>> -
>> -			if (!error && (flags & ATTR_KERNOTIME) == 0) {
>> -				xfs_trans_ichgtime(args.trans, dp,
>> -							XFS_ICHGTIME_CHG);
>> -			}
>> -			err2 = xfs_trans_commit(args.trans);
>> -			xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> -
>> -			return error ? error : err2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		xfs_defer_init(args.dfops, args.firstblock);
>> -		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>> -		if (error)
>> -			goto out_defer_cancel;
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args.trans, leaf_bp);
>> -		xfs_defer_bjoin(args.dfops, leaf_bp);
>> -		xfs_defer_ijoin(args.dfops, dp);
>> -		error = xfs_defer_finish(&args.trans, args.dfops);
>> -		if (error)
>> -			goto out_defer_cancel;
>> -
>> -		/*
>> -		 * Commit the leaf transformation.  We'll need another (linked)
>> -		 * transaction to add the new attribute to the leaf, which
>> -		 * means that we have to hold & join the leaf buffer here too.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args.trans, dp);
>> -		if (error)
>> -			goto out;
>> -		xfs_trans_bjoin(args.trans, leaf_bp);
>> -		leaf_bp = NULL;
>> -	}
>> -
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_leaf_addname(&args);
>> -	else
>> -		error = xfs_attr_node_addname(&args);
>>   	if (error)
>> -		goto out;
>> +		goto out_defer_cancel;
>>   
>>   	/*
>>   	 * If this is a synchronous mount, make sure that the
>> @@ -369,9 +484,6 @@ xfs_attr_set(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args.trans);
>>   
>> -	if ((flags & ATTR_KERNOTIME) == 0)
>> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>> -
>>   	/*
>>   	 * Commit the last in the sequence of transactions.
>>   	 */
>> @@ -383,7 +495,6 @@ xfs_attr_set(
>>   
>>   out_defer_cancel:
>>   	xfs_defer_cancel(&dfops);
>> -out:
>>   	if (leaf_bp)
>>   		xfs_trans_brelse(args.trans, leaf_bp);
>>   	if (args.trans)
>> @@ -431,34 +542,15 @@ xfs_attr_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	/*
>> -	 * Root fork attributes can use reserved data blocks for this
>> -	 * operation if necessary
>> -	 */
>> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
>> -			XFS_ATTRRM_SPACE_RES(mp), 0,
>> -			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
>> -			&args.trans);
>> -	if (error)
>> -		return error;
>> -
>>   	xfs_ilock(dp, XFS_ILOCK_EXCL);
>>   	/*
>>   	 * No need to make quota reservations here. We expect to release some
>>   	 * blocks not allocate in the common case.
>>   	 */
>>   	xfs_trans_ijoin(args.trans, dp, 0);
>> +	xfs_defer_init(args.dfops, args.firstblock);
>>   
>> -	if (!xfs_inode_hasattr(dp)) {
>> -		error = -ENOATTR;
>> -	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -		error = xfs_attr_shortform_remove(&args);
>> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(&args);
>> -	} else {
>> -		error = xfs_attr_node_removename(&args);
>> -	}
>> +	error = xfs_attr_remove_args(&args, flags);
>>   
>>   	if (error)
>>   		goto out;
>> @@ -470,9 +562,6 @@ xfs_attr_remove(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args.trans);
>>   
>> -	if ((flags & ATTR_KERNOTIME) == 0)
>> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>> -
>>   	/*
>>   	 * Commit the last in the sequence of transactions.
>>   	 */
>> @@ -483,6 +572,8 @@ xfs_attr_remove(
>>   	return error;
>>   
>>   out:
>> +	xfs_defer_cancel(&dfops);
>> +
>>   	if (args.trans)
>>   		xfs_trans_cancel(args.trans);
>>   	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index d07bf27..e774325 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -152,7 +152,10 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>>   		 unsigned char *value, int *valuelenp, int flags);
>>   int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>>   		 unsigned char *value, int valuelen, int flags);
>> +int xfs_attr_set_args(struct xfs_da_args *args, int flags,
>> +			struct xfs_buf *leaf_bp, bool roll_trans);
>>   int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
>> +int xfs_attr_remove_args(struct xfs_da_args *args, int flags);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>>   
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 6a7c2f0..4e16a5d 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -1031,6 +1031,34 @@ xfs_bmap_add_attrfork_local(
>>   	return -EFSCORRUPTED;
>>   }
>>   
>> +/* Set an inode attr fork off based on the format */
>> +int
>> +xfs_bmap_set_attrforkoff(
>> +	struct xfs_inode	*ip,
>> +	int			size,
>> +	int			*version)
>> +{
>> +	switch (ip->i_d.di_format) {
>> +	case XFS_DINODE_FMT_DEV:
>> +		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
>> +		break;
>> +	case XFS_DINODE_FMT_LOCAL:
>> +	case XFS_DINODE_FMT_EXTENTS:
>> +	case XFS_DINODE_FMT_BTREE:
>> +		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>> +		if (!ip->i_d.di_forkoff)
>> +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
>> +		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
>> +			*version = 2;
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Convert inode from non-attributed to attributed.
>>    * Must not be in a transaction, ip must not be locked.
>> @@ -1084,26 +1112,9 @@ xfs_bmap_add_attrfork(
>>   
>>   	xfs_trans_ijoin(tp, ip, 0);
>>   	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> -
>> -	switch (ip->i_d.di_format) {
>> -	case XFS_DINODE_FMT_DEV:
>> -		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
>> -		break;
>> -	case XFS_DINODE_FMT_LOCAL:
>> -	case XFS_DINODE_FMT_EXTENTS:
>> -	case XFS_DINODE_FMT_BTREE:
>> -		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>> -		if (!ip->i_d.di_forkoff)
>> -			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
>> -		else if (mp->m_flags & XFS_MOUNT_ATTR2)
>> -			version = 2;
>> -		break;
>> -	default:
>> -		ASSERT(0);
>> -		error = -EINVAL;
>> +	error = xfs_bmap_set_attrforkoff(ip, size, &version);
>> +	if (error)
>>   		goto trans_cancel;
>> -	}
>> -
>>   	ASSERT(ip->i_afp == NULL);
>>   	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>>   	ip->i_afp->if_flags = XFS_IFEXTENTS;
>> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
>> index 2b766b3..50e9115 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.h
>> +++ b/fs/xfs/libxfs/xfs_bmap.h
>> @@ -191,6 +191,7 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>>   		xfs_filblks_t len);
>>   void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
>>   int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>> +int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
>>   void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
>>   void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>>   			  xfs_fsblock_t bno, xfs_filblks_t len,
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=hQ9qFBx47sm-ybmTtpgxWCgs-u7z02Z42nRcEcVegR4&s=EFC1CLEB64lXwT0f_B1lzxRaYz5t4PoLDnmugeYvSlo&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=hQ9qFBx47sm-ybmTtpgxWCgs-u7z02Z42nRcEcVegR4&s=EFC1CLEB64lXwT0f_B1lzxRaYz5t4PoLDnmugeYvSlo&e=

