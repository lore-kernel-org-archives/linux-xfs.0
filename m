Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42016 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdJUBOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:14:11 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L1EAdD003568
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:14:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9L1EAhX031984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:14:10 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9L1EAO6003330
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:14:10 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/17] Add helper functions xfs_attr_set_args and
 xfs_attr_remove_args
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-2-git-send-email-allison.henderson@oracle.com>
 <20171019200311.GL4755@magnolia>
Message-ID: <fcb3a1db-5cd9-ff0b-6444-8969f85c3700@oracle.com>
Date: Fri, 20 Oct 2017 18:14:06 -0700
MIME-Version: 1.0
In-Reply-To: <20171019200311.GL4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 10/19/2017 01:03 PM, Darrick J. Wong wrote:

> On Wed, Oct 18, 2017 at 03:55:17PM -0700, Allison Henderson wrote:
>> These sub-routines set or remove the attributes specified in
>> @args. We will use this later for setting parent pointers as a
>> deferred attribute operation.
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 322 +++++++++++++++++++++++++++--------------------
>>   fs/xfs/xfs_attr.h        |   2 +
>>   2 files changed, 189 insertions(+), 135 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 6249c92..b00ec1f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -203,6 +203,185 @@ xfs_attr_calc_size(
>>   	return nblks;
>>   }
>>   
>> +/*
>> + * set the attribute specified in @args. In the case of the parent attribute
>> + * being set, we do not want to roll the transaction on shortform-to-leaf
>> + * conversion, as the attribute must be added in the same transaction as the
>> + * parent directory modifications. Hence @roll_trans needs to be set
>> + * appropriately to control whether the transaction is committed during this
>> + * function.
> Hmm... shouldn't the deferred attribute set code take care of all the
> conversions/attr fork expansions/whatever is necessary to cram in the
> parent pointer?  So in theory all the parent pointer updates should look
> like this:
>
> xfs_defer_init(&dfops...);
> xfs_some_name_creating_operation(tp, ...);
>
> if (hasparent) {
> 	xfs_parent_set(tp, ip);
> }
> xfs_defer_finish(&tp, &dfops);
> xfs_trans_commit(tp);
>
> xfs_parent_set() would then be:
>
> if (fits in inode) {
> 	xfs_attr_set_sf(ip, key, value);
> 	xfs_log_attr_area();
> 	return;
> }
>
> xfs_attr_do_conversions_if_needed(dfops);
> xfs_attr_set(dfops);
>
> ...and if there's a really good reason to try to cram things in, we can
> add those later?  As I scanned the series, that was what kept coming up
> in my head -- just tell the xfs_parent.c code to set a parent pointer;
> it can figure out if there's sufficient space to put it directly into
> the inode and log that, or we need something else that actually requires
> the deferred ops mechanism then do that.
>
> (Maybe I'm just fixating on xfs_parent_create...)

Ok, I think may have caused some confusion by not revising the comments
for these functions.  xfs_attr_remove_args and xfs_attr_set_args are
sort of subsets of code that came out of xfs_attr_remove and xfs_attr_set.
In the first revision of the set, the link/unlink/rename operations called
them directly to set up the parent pointers.  Now these two functions
are called through xfs_trans_attr.

But you've still made very good points because I forgot that xfs_create
path uses xfs_parent_create not xfs_parent_add.  So I think the pseudo
code you are proposing makes sense.  I will see if I can revise the
create path a bit.  Thanks for the catch!
> Higher level questions about robustness: if we try to set a parent
> ptr and the attr name already exists, do we error out?  If we try to
> remove a parent ptr and there's no attr name, do we error out?
Erroring out seems logical sense these these would not be normal
conditions?

> I think
> you've enough here to start thinking what changes need to be made to
> xfs_repair to validate & fix the parent pointers, and what test cases
> (and possibly ioctls) will need to be constructed to verify that we
> actually get the parent pointers we want.
>
> --D
Right, I will put together some basic add/remove/rename tests to
add to xfstests.

Thank you for the very thorough review!!

>> + */
>> +int
>> +xfs_attr_set_args(
>> +	struct xfs_da_args	*args,
>> +	int			flags,
>> +	bool			roll_trans)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount        *mp = dp->i_mount;
>> +	struct xfs_trans_res    tres;
>> +	int			rsvd = 0;
>> +	int			error = 0;
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
>> +			ASSERT(args->trans);
>> +			if (!error && (flags & ATTR_KERNOTIME) == 0)
>> +				xfs_trans_ichgtime(args->trans, dp,
>> +						   XFS_ICHGTIME_CHG);
>> +			goto out;
>> +		}
>> +
>> +		/*
>> +		 * It won't fit in the shortform, transform to a leaf block.
>> +		 * GROT: another possible req'mt for a double-split btree op.
>> +		 */
>> +		error = xfs_attr_shortform_to_leaf(args);
>> +		if (error)
>> +			goto out;
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
>> +	error = xfs_qm_dqattach_locked(dp, 0);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Root fork attributes can use reserved data blocks for this
>> +	 * operation if necessary
>> +	 */
>> +	if (flags & ATTR_ROOT)
>> +		rsvd = XFS_TRANS_RESERVE;
>> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
>> +		XFS_ATTRRM_SPACE_RES(mp), 0, rsvd, &args->trans);
>> +
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
>>   int
>>   xfs_attr_set(
>>   	struct xfs_inode	*dp,
>> @@ -214,10 +393,9 @@ xfs_attr_set(
>>   	struct xfs_mount	*mp = dp->i_mount;
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
>> @@ -252,106 +430,11 @@ xfs_attr_set(
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
>> -
>> -	xfs_trans_ijoin(args.trans, dp, 0);
>> -
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
>> -		error = xfs_attr_shortform_to_leaf(&args);
>> -		if (error)
>> -			goto out_defer_cancel;
>> -		xfs_defer_ijoin(args.dfops, dp);
>> -		error = xfs_defer_finish(&args.trans, args.dfops);
>> -		if (error)
>> -			goto out_defer_cancel;
>> -
>> -		/*
>> -		 * Commit the leaf transformation.  We'll need another (linked)
>> -		 * transaction to add the new attribute to the leaf.
>> -		 */
>> -
>> -		error = xfs_trans_roll_inode(&args.trans, dp);
>> -		if (error)
>> -			goto out;
>> -
>> -	}
>> -
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_leaf_addname(&args);
>> -	else
>> -		error = xfs_attr_node_addname(&args);
>> +	xfs_defer_init(args.dfops, args.firstblock);
>> +	error = xfs_attr_set_args(&args, flags, true);
>>   	if (error)
>> -		goto out;
>> +		goto out_defer_cancel;
>>   
>>   	/*
>>   	 * If this is a synchronous mount, make sure that the
>> @@ -360,9 +443,6 @@ xfs_attr_set(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args.trans);
>>   
>> -	if ((flags & ATTR_KERNOTIME) == 0)
>> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>> -
>>   	/*
>>   	 * Commit the last in the sequence of transactions.
>>   	 */
>> @@ -374,10 +454,6 @@ xfs_attr_set(
>>   
>>   out_defer_cancel:
>>   	xfs_defer_cancel(&dfops);
>> -	args.trans = NULL;
>> -out:
>> -	if (args.trans)
>> -		xfs_trans_cancel(args.trans);
>>   	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>   	return error;
>>   }
>> @@ -417,38 +493,15 @@ xfs_attr_remove(
>>   	 */
>>   	args.op_flags = XFS_DA_OP_OKNOENT;
>>   
>> -	error = xfs_qm_dqattach(dp, 0);
>> -	if (error)
>> -		return error;
>> -
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
>> @@ -460,9 +513,6 @@ xfs_attr_remove(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args.trans);
>>   
>> -	if ((flags & ATTR_KERNOTIME) == 0)
>> -		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
>> -
>>   	/*
>>   	 * Commit the last in the sequence of transactions.
>>   	 */
>> @@ -473,6 +523,8 @@ xfs_attr_remove(
>>   	return error;
>>   
>>   out:
>> +	xfs_defer_cancel(&dfops);
>> +
>>   	if (args.trans)
>>   		xfs_trans_cancel(args.trans);
>>   	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index 5d5a5e2..8542606 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -149,7 +149,9 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>>   		 unsigned char *value, int *valuelenp, int flags);
>>   int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>>   		 unsigned char *value, int valuelen, int flags);
>> +int xfs_attr_set_args(struct xfs_da_args *args, int flags, bool roll_trans);
>>   int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
>> +int xfs_attr_remove_args(struct xfs_da_args *args, int flags);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=XFp4B05bcXkJ0dhYaFjd3F8telP01COkBp9cI7mKLb4&m=aicitOc3doix8VyB_l-FSSD7nPvIu7TIiw0VVfKnBhc&s=JKZ0ozAg9jwyNpJK-9-53aT_kpKIedFceJDGJpDQh3U&e=  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=XFp4B05bcXkJ0dhYaFjd3F8telP01COkBp9cI7mKLb4&m=aicitOc3doix8VyB_l-FSSD7nPvIu7TIiw0VVfKnBhc&s=JKZ0ozAg9jwyNpJK-9-53aT_kpKIedFceJDGJpDQh3U&e=  

