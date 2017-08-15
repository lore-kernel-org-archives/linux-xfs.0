Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50322 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdHODyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 23:54:36 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7F3sZOh007408
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:54:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7F3sZhN015008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:54:35 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7F3sZeX019447
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:54:35 GMT
Subject: Re: [RFC PATCH 02/13] xfs: get directory offset when removing
 directory name
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
 <1502329293-4091-3-git-send-email-allison.henderson@oracle.com>
 <20170814235653.GQ4796@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <71c12380-dd86-5149-97f4-62a1b62dc5c0@oracle.com>
Date: Mon, 14 Aug 2017 20:54:16 -0700
MIME-Version: 1.0
In-Reply-To: <20170814235653.GQ4796@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 08/14/2017 04:56 PM, Darrick J. Wong wrote:

> On Wed, Aug 09, 2017 at 06:41:22PM -0700, Allison Henderson wrote:
>> From: Mark Tinguely <tinguely@sgi.com>
>>
>> Return the directory offset information when removing an entry to the
>> directory.
>>
>> This offset will be used as the parent pointer offset in xfs_remove.
>>
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>> :100644 100644 a1ca460... a34956e... M	fs/xfs/libxfs/xfs_dir2.c
>> :100644 100644 e349900... ee98b2a... M	fs/xfs/libxfs/xfs_dir2.h
>> :100644 100644 79684d5... 4dbe2fc... M	fs/xfs/libxfs/xfs_dir2_block.c
>> :100644 100644 2ac7a7e... 197e627... M	fs/xfs/libxfs/xfs_dir2_leaf.c
>> :100644 100644 8bc91f8... 13d5244... M	fs/xfs/libxfs/xfs_dir2_node.c
>> :100644 100644 489bdef... 9e90c22... M	fs/xfs/libxfs/xfs_dir2_sf.c
>> :100644 100644 cea1c56... f58f62a... M	fs/xfs/xfs_inode.c
>>   fs/xfs/libxfs/xfs_dir2.c       | 15 +++++++++------
>>   fs/xfs/libxfs/xfs_dir2.h       |  3 ++-
>>   fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>>   fs/xfs/libxfs/xfs_dir2_leaf.c  |  5 +++--
>>   fs/xfs/libxfs/xfs_dir2_node.c  |  5 +++--
>>   fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
>>   fs/xfs/xfs_inode.c             |  7 ++++---
>>   7 files changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index a1ca460..a34956e 100644
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
>> +	xfs_trans_t		*tp,
> If you change a line containing a struct tyepdef type, please convert it
> back to the raw struct type.
>
> 	struct xfs_trans	*tp,
>
> etc.  Some day we'll have managed to remove them all! :D
Ok, will do
>
>> +	xfs_inode_t		*dp,
>> +	struct xfs_name		*name,
>> +	xfs_ino_t		ino,
>> +	xfs_fsblock_t		*first,		/* bmap's firstblock */
>>   	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
>> -	xfs_extlen_t	total)		/* bmap's total block count */
>> +	xfs_extlen_t		total,		/* bmap's total block count */
>> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
> Hmm.  We /also/ pass a defer_ops into _dir_removename.  I wasn't going
> to say this until later in the patchset, but it's apropos now.
>
> The biggest complaint I have about this patch series is that we end up
> using separate transactions for each phase of the link/unlink
> operations.  There's no guarantee that once we start the process of
> expand-dir, add-name-to-dir, log-inode-cores, expand-attr,
> add-pptr-to-attrs that we actually get all the way to the end of that
> process, particularly if we crash in the middle and have to recover the
> log coming back up.
>
> Obviously, back in 2014 when Dave started on these patches there was no
> defer_ops, so a lot of effort goes into passing parameters up and down
> the stack and fiddling with the transaction reservation type
> declarations in order to guarantee that we can shove everything into a
> single transaction.  Now that we have a more general mechanism to split
> complex updates into a chain of smaller updates (and make log recovery
> pick up where we left off) it's time to figure out how to make attr (and
> maybe dir) updates a deferrable operation.
>
> This adds complexity to the log because we have to define an "attr add
> KEY:VALUE" and a "attr delete KEY" deferred op that hooks into the
> existing attr code.  For parent pointers it's not a big deal to log
> values since they're not big, but for the general case this idea needs
> more thought, or a decision that we'll just keep doing things the same
> way.
>
> Anyway, assuming the existence of a "attr delete KEY" log intent item we
> no longer have to pass the offsets around everywhere because instead
> _dir_removename attaches the defer item to the defer_ops and
> _defer_finish takes care of rolling through the updates.
>
> Thoughts?
>
> --D
It sounds like what you're describing would make sense in the greater 
scheme of things. If folks agree, I could dig in the log code and see 
how much surgery it would need.  I'm generally on board with the idea of 
restructuring things sooner rather than later when there's more code to 
patch up.

Allison
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
>> index e349900..ee98b2a 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.h
>> +++ b/fs/xfs/libxfs/xfs_dir2.h
>> @@ -139,7 +139,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>>   extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>>   				struct xfs_name *name, xfs_ino_t ino,
>>   				xfs_fsblock_t *first,
>> -				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
>> +				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
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
>> index cea1c56..f58f62a 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2621,8 +2621,8 @@ xfs_remove(
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
>> @@ -3132,7 +3132,8 @@ xfs_rename(
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
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

