Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40820 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdK2Stv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:49:51 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 06/17] xfs: get directory offset when removing
 directory name
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-7-git-send-email-allison.henderson@oracle.com>
 <20171128190515.GT21412@magnolia>
Message-ID: <5db07d38-4799-ee5b-c496-8b814c9a0a73@oracle.com>
Date: Wed, 29 Nov 2017 11:49:43 -0700
MIME-Version: 1.0
In-Reply-To: <20171128190515.GT21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On 11/28/2017 12:05 PM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:34AM -0700, Allison Henderson wrote:
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
>> index a1ca460..b647bf2 100644
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
>> +	xfs_fsblock_t		*first,		/* bmap's firstblock */
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
> FWIW I complain in a review of a later patch about this label moving
> above the "if (offset)".
>
> --D
Alrighty, I'll fold it in here.  Thx!
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
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=SFido2p7wk-upxZd3F1IYBhnhTXxEhm1z0kgoez1Z1o&s=_RhetEFcGr0rO6PClQan2EquBu2KJK77rWwerDaw25c&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=SFido2p7wk-upxZd3F1IYBhnhTXxEhm1z0kgoez1Z1o&s=_RhetEFcGr0rO6PClQan2EquBu2KJK77rWwerDaw25c&e=

