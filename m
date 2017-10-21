Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41740 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJUBLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:11:25 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/17] xfs: get directory offset when removing directory
 name
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-7-git-send-email-allison.henderson@oracle.com>
 <20171019191735.GF4755@magnolia>
Message-ID: <b8888501-267f-cbf4-54b7-b526d9a5e85b@oracle.com>
Date: Fri, 20 Oct 2017 18:11:15 -0700
MIME-Version: 1.0
In-Reply-To: <20171019191735.GF4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 10/19/2017 12:17 PM, Darrick J. Wong wrote:
> On Wed, Oct 18, 2017 at 03:55:22PM -0700, Allison Henderson wrote:
>> From: Mark Tinguely<tinguely@sgi.com>
>>
>> Return the directory offset information when removing an entry to the
>> directory.
>>
>> This offset will be used as the parent pointer offset in xfs_remove.
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
>>   fs/xfs/libxfs/xfs_dir2.c       | 15 +++++++++------
>>   fs/xfs/libxfs/xfs_dir2.h       |  4 +++-
>>   fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>>   fs/xfs/libxfs/xfs_dir2_leaf.c  |  5 +++--
>>   fs/xfs/libxfs/xfs_dir2_node.c  |  5 +++--
>>   fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
>>   fs/xfs/xfs_inode.c             |  7 ++++---
>>   7 files changed, 26 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index a1ca460..0511eb9 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -443,13 +443,14 @@ xfs_dir_lookup(
>>    */
>>   int
>>   xfs_dir_removename(
>> -	xfs_trans_t	*tp,
>> -	xfs_inode_t	*dp,
>> -	struct xfs_name	*name,
>> -	xfs_ino_t	ino,
>> -	xfs_fsblock_t	*first,		/* bmap's firstblock */
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*dp,
>> +	struct xfs_name		*name,
>> +	xfs_ino_t		ino,
>> +	xfs_fsblock_t	*first,			/* bmap's firstblock */
> Indentation problem?
>
> --D
Ok, will fix.  It looked right in the editor, maybe my tabs are not set 
quite right.
>>   	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>> -	xfs_extlen_t	total)		/* bmap's total block count */
>> +	xfs_extlen_t		total,		/* bmap's total block count */
>> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
>>   {
>>   	struct xfs_da_args *args;
>>   	int		rval;
>> @@ -495,6 +496,8 @@ xfs_dir_removename(
>>   		rval = xfs_dir2_leaf_removename(args);
>>   	else
>>   		rval = xfs_dir2_node_removename(args);
>> +	if (offset)
>> +		*offset = args->offset;
>>   out_free:
>>   	kmem_free(args);
>>   	return rval;
>> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
>> index e349900..e1bd05d 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.h
>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>> @@ -139,7 +139,9 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>>   extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>   				struct xfs_name *name, xfs_ino_t ino,
>>   				xfs_fsblock_t *first,
>> -				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>> +				struct xfs_defer_ops *dfops,
>> +				xfs_extlen_t tot,
>> +				xfs_dir2_dataptr_t *offset);
>>   extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>>   				struct xfs_name *name, xfs_ino_t inum,
>>   				xfs_fsblock_t *first,
>> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
>> index 79684d5..4dbe2fc 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_block.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
>> @@ -791,9 +791,9 @@ xfs_dir2_block_removename(
>>   	/*
>>   	 * Point to the data entry using the leaf entry.
>>   	 */
>> +	args->offset = be32_to_cpu(blp[ent].address);
>>   	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
>> -			xfs_dir2_dataptr_to_off(args->geo,
>> -						be32_to_cpu(blp[ent].address)));
>> +			xfs_dir2_dataptr_to_off(args->geo, args->offset));
>>   	/*
>>   	 * Mark the data entry's space free.
>>   	 */
>> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> index 2ac7a7e..197e627 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
>> @@ -1383,9 +1383,10 @@ xfs_dir2_leaf_removename(
>>   	 * Point to the leaf entry, use that to point to the data entry.
>>   	 */
>>   	lep = &ents[index];
>> -	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
>> +	args->offset = be32_to_cpu(lep->address);
>> +	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
>>   	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
>> -		xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
>> +		xfs_dir2_dataptr_to_off(args->geo, args->offset));
>>   	needscan = needlog = 0;
>>   	oldbest = be16_to_cpu(bf[0].length);
>>   	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
>> index 8bc91f8..13d5244 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_node.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
>> @@ -1238,9 +1238,10 @@ xfs_dir2_leafn_remove(
>>   	/*
>>   	 * Extract the data block and offset from the entry.
>>   	 */
>> -	db = xfs_dir2_dataptr_to_db(args->geo, be32_to_cpu(lep->address));
>> +	args->offset = be32_to_cpu(lep->address);
>> +	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
>>   	ASSERT(dblk->blkno == db);
>> -	off = xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address));
>> +	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
>>   	ASSERT(dblk->index == off);
>>   
>>   	/*
>> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
>> index 489bdef..9e90c22 100644
>> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
>> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
>> @@ -919,6 +919,8 @@ xfs_dir2_sf_removename(
>>   								XFS_CMP_EXACT) {
>>   			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
>>   			       args->inumber);
>> +			args->offset = xfs_dir2_byte_to_dataptr(
>> +						xfs_dir2_sf_get_offset(sfep));
>>   			break;
>>   		}
>>   	}
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 3abcb17..358a98a 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2639,8 +2639,8 @@ xfs_remove(
>>   		goto out_trans_cancel;
>>   
>>   	xfs_defer_init(&dfops, &first_block);
>> -	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
>> -					&first_block, &dfops, resblks);
>> +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
>> +				   &dfops, resblks, NULL);
>>   	if (error) {
>>   		ASSERT(error != -ENOENT);
>>   		goto out_bmap_cancel;
>> @@ -3150,7 +3150,8 @@ xfs_rename(
>>   					&first_block, &dfops, spaceres);
>>   	} else
>>   		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>> -					   &first_block, &dfops, spaceres);
>> +					   &first_block, &dfops, spaceres,
>> +					   NULL);
>>   	if (error)
>>   		goto out_bmap_cancel;
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

