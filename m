Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbeEHRAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:00:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48GpDFS093651
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:00:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hs4k29jjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 17:00:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w48H0VvB013668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:00:31 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w48H0V8t031426
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:00:31 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 10/21] xfs: get directory offset when replacing a
 directory name
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-11-git-send-email-allison.henderson@oracle.com>
 <20180507224523.GL11261@magnolia>
Message-ID: <f94d21fa-c2b2-9577-c318-60f7dbced135@oracle.com>
Date: Tue, 8 May 2018 10:00:29 -0700
MIME-Version: 1.0
In-Reply-To: <20180507224523.GL11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/07/2018 03:45 PM, Darrick J. Wong wrote:
> On Sun, May 06, 2018 at 10:24:43AM -0700, Allison Henderson wrote:
>> From: Mark Tinguely <tinguely@sgi.com>
>>
>> Return the directory offset information when replacing an entry to the
>> directory.
>>
>> This offset will be used as the parent pointer offset in xfs_rename.
>>
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>> 	   Changed typedefs to raw struct types]
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_dir2.c       | 16 ++++++++++------
>>   fs/xfs/libxfs/xfs_dir2.h       |  3 ++-
>>   fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>>   fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
>>   fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
>>   fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
>>   fs/xfs/xfs_inode.c             | 28 +++++++++++++---------------
>>   7 files changed, 31 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 090ab0e..a4f7bcd 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -499,13 +499,14 @@ xfs_dir_removename(
>>    */
>>   int
>>   xfs_dir_replace(
>> -	xfs_trans_t	*tp,
>> -	xfs_inode_t	*dp,
>> -	struct xfs_name	*name,		/* name of entry to replace */
>> -	xfs_ino_t	inum,		/* new inode number */
>> -	xfs_fsblock_t	*first,		/* bmap's firstblock */
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*dp,
>> +	struct xfs_name		*name,		/* name of entry to replace */
>> +	xfs_ino_t		inum,		/* new inode number */
>> +	xfs_fsblock_t		*first,		/* bmap's firstblock */
>>   	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>> -	xfs_extlen_t	total)		/* bmap's total block count */
>> +	xfs_extlen_t		total,		/* bmap's total block count */
>> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
>>   {
>>   	struct xfs_da_args *args;
>>   	int		rval;
>> @@ -555,6 +556,9 @@ xfs_dir_replace(
>>   	else
>>   		rval = xfs_dir2_node_replace(args);
>>   out_free:
>> +	if (offset)
>> +		*offset = args->offset;
> 
> Just from a outvar purity point of view, we should only set *offset if
> we're not also returning an error.  AFAICT there's no practical
> consequence for setting *offset and returning a negative number, just a
> nit to pick. :P
> 
> The rest looks ok, so:
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrightly, will update. thx!

Allison
> 
>> +
>>   	kmem_free(args);
>>   	return rval;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>> index b73bdcb..d361442 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.h
>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>> @@ -145,7 +145,8 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>   extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>>   				struct xfs_name *name, xfs_ino_t inum,
>>   				xfs_fsblock_t *first,
>> -				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>> +				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
>> +				xfs_dir2_dataptr_t *offset);
>>   extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
>>   				struct xfs_name *name);
>>   
>> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
>> index 9c1e485..77744e5 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -872,9 +872,9 @@ xfs_dir2_block_replace(
>>   	/*
>>   	 * Point to the data entry we need to change.
>>   	 */
>> +	args->offset = be32_to_cpu(blp[ent].address);
>>   	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
>> -			xfs_dir2_dataptr_to_off(args->geo,
>> -						be32_to_cpu(blp[ent].address)));
>> +			xfs_dir2_dataptr_to_off(args->geo, args->offset));
>>   	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
>>   	/*
>>   	 * Change the inode number to the new value.
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index c5595c1..6ad7741 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -1550,6 +1550,7 @@ xfs_dir2_leaf_replace(
>>   	/*
>>   	 * Point to the data entry.
>>   	 */
>> +	args->offset = be32_to_cpu(lep->address);
>>   	dep = (xfs_dir2_data_entry_t *)
>>   	      ((char *)dbp->b_addr +
>>   	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index eb8b240..ccf220a 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -2256,6 +2256,7 @@ xfs_dir2_node_replace(
>>   		hdr = state->extrablk.bp->b_addr;
>>   		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
>>   		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
>> +		args->offset = be32_to_cpu(lep->address);
>>   		dep = (xfs_dir2_data_entry_t *)
>>   		      ((char *)hdr +
>>   		       xfs_dir2_dataptr_to_off(args->geo,
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 1d0957c..73f1eef 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -1043,6 +1043,8 @@ xfs_dir2_sf_replace(
>>   				ASSERT(args->inumber != ino);
>>   				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>>   				dp->d_ops->sf_put_ftype(sfep, args->filetype);
>> +				args->offset = xfs_dir2_byte_to_dataptr(
>> +						  xfs_dir2_sf_get_offset(sfep));
>>   				break;
>>   			}
>>   		}
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 3054e9a..5c291d2 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2783,16 +2783,14 @@ xfs_cross_rename(
>>   	int		dp2_flags = 0;
>>   
>>   	/* Swap inode number for dirent in first parent */
>> -	error = xfs_dir_replace(tp, dp1, name1,
>> -				ip2->i_ino,
>> -				first_block, dfops, spaceres);
>> +	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, first_block, dfops,
>> +				spaceres, NULL);
>>   	if (error)
>>   		goto out_trans_abort;
>>   
>>   	/* Swap inode number for dirent in second parent */
>> -	error = xfs_dir_replace(tp, dp2, name2,
>> -				ip1->i_ino,
>> -				first_block, dfops, spaceres);
>> +	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, first_block, dfops,
>> +				spaceres, NULL);
>>   	if (error)
>>   		goto out_trans_abort;
>>   
>> @@ -2806,8 +2804,8 @@ xfs_cross_rename(
>>   
>>   		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
>>   			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
>> -						dp1->i_ino, first_block,
>> -						dfops, spaceres);
>> +						dp1->i_ino, first_block, dfops,
>> +						spaceres, NULL);
>>   			if (error)
>>   				goto out_trans_abort;
>>   
>> @@ -2833,8 +2831,8 @@ xfs_cross_rename(
>>   
>>   		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
>>   			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
>> -						dp2->i_ino, first_block,
>> -						dfops, spaceres);
>> +						dp2->i_ino, first_block, dfops,
>> +						spaceres, NULL);
>>   			if (error)
>>   				goto out_trans_abort;
>>   
>> @@ -3081,8 +3079,8 @@ xfs_rename(
>>   		 * name at the destination directory, remove it first.
>>   		 */
>>   		error = xfs_dir_replace(tp, target_dp, target_name,
>> -					src_ip->i_ino,
>> -					&first_block, &dfops, spaceres);
>> +					src_ip->i_ino, &first_block, &dfops,
>> +					spaceres, NULL);
>>   		if (error)
>>   			goto out_bmap_cancel;
>>   
>> @@ -3116,8 +3114,8 @@ xfs_rename(
>>   		 * directory.
>>   		 */
>>   		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
>> -					target_dp->i_ino,
>> -					&first_block, &dfops, spaceres);
>> +					target_dp->i_ino, &first_block, &dfops,
>> +					spaceres, NULL);
>>   		ASSERT(error != -EEXIST);
>>   		if (error)
>>   			goto out_bmap_cancel;
>> @@ -3156,7 +3154,7 @@ xfs_rename(
>>   	 */
>>   	if (wip) {
>>   		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
>> -					&first_block, &dfops, spaceres);
>> +					&first_block, &dfops, spaceres, NULL);
>>   	} else
>>   		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>>   					   &first_block, &dfops, spaceres,
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
