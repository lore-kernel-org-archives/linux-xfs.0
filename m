Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20299 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbdK2St0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:49:26 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 07/17] xfs: get directory offset when replacing a
 directory name
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-8-git-send-email-allison.henderson@oracle.com>
 <20171128190412.GS21412@magnolia>
Message-ID: <e6677fe9-3844-261d-036a-ab6eb72b8ed6@oracle.com>
Date: Wed, 29 Nov 2017 11:49:19 -0700
MIME-Version: 1.0
In-Reply-To: <20171128190412.GS21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On 11/28/2017 12:04 PM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:35AM -0700, Allison Henderson wrote:
>> From: Mark Tinguely<tinguely@sgi.com>
>>
>> Return the directory offset information when replacing an entry to the
>> directory.
>>
>> This offset will be used as the parent pointer offset in xfs_rename.
>>
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>> v2: Changed typedefs to raw struct types
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
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
>> index b647bf2..25b370b 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -508,13 +508,14 @@ xfs_dir_removename(
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
>> @@ -563,6 +564,9 @@ xfs_dir_replace(
>>   		rval = xfs_dir2_leaf_replace(args);
>>   	else
>>   		rval = xfs_dir2_node_replace(args);
>> +
>> +	if (offset)
>> +		*offset = args->offset;
>>   out_free:
> FWIW I complained in the review for a subsequent patch about the out_free
> label moving to above the "if (offset)" hunk.
>
> --D
Ok, I'll get it folded in here
>>   	kmem_free(args);
>>   	return rval;
>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>> index e1bd05d..5cc0b3f 100644
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
>> index 4dbe2fc..69dfe64 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -865,9 +865,9 @@ xfs_dir2_block_replace(
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
>> index 197e627..770b93f 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
>>   	/*
>>   	 * Point to the data entry.
>>   	 */
>> +	args->offset = be32_to_cpu(lep->address);
>>   	dep = (xfs_dir2_data_entry_t *)
>>   	      ((char *)dbp->b_addr +
>>   	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index 13d5244..860a612 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -2237,6 +2237,7 @@ xfs_dir2_node_replace(
>>   		hdr = state->extrablk.bp->b_addr;
>>   		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
>>   		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
>> +		args->offset = be32_to_cpu(lep->address);
>>   		dep = (xfs_dir2_data_entry_t *)
>>   		      ((char *)hdr +
>>   		       xfs_dir2_dataptr_to_off(args->geo,
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 9e90c22..295458f 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -1045,6 +1045,8 @@ xfs_dir2_sf_replace(
>>   				ASSERT(args->inumber != ino);
>>   				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
>>   				dp->d_ops->sf_put_ftype(sfep, args->filetype);
>> +				args->offset = xfs_dir2_byte_to_dataptr(
>> +						  xfs_dir2_sf_get_offset(sfep));
>>   				break;
>>   			}
>>   		}
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 358a98a..f7986d8 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2774,16 +2774,14 @@ xfs_cross_rename(
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
>> @@ -2797,8 +2795,8 @@ xfs_cross_rename(
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
>> @@ -2824,8 +2822,8 @@ xfs_cross_rename(
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
>> @@ -3072,8 +3070,8 @@ xfs_rename(
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
>> @@ -3107,8 +3105,8 @@ xfs_rename(
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
>> @@ -3147,7 +3145,7 @@ xfs_rename(
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
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=OmnRnl5PP77MyfzpnPKFHs1VduH0GTb1IP9D8bssMT0&s=qI6-Zzze17jYSFlCUyua2MRuhxSgMoUvrV4u3VMMkko&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=OmnRnl5PP77MyfzpnPKFHs1VduH0GTb1IP9D8bssMT0&s=qI6-Zzze17jYSFlCUyua2MRuhxSgMoUvrV4u3VMMkko&e=

