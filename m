Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDF557F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 10:15:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BE329304070
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 08:15:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O3SGzYrCHYGLWLND for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 08:15:44 -0800 (PST)
Message-ID: <52FA4E61.9040908@redhat.com>
Date: Tue, 11 Feb 2014 11:22:57 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard>
In-Reply-To: <20140211064609.GE13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/11/2014 01:46 AM, Dave Chinner wrote:
> On Tue, Feb 04, 2014 at 12:49:35PM -0500, Brian Foster wrote:
>> Create the xfs_calc_finobt_res() helper to calculate the finobt log
>> reservation for inode allocation and free. Update
>> XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
>> insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
>> reserve blocks for the potential finobt record insertion on inode
>> free (i.e., if an inode chunk was previously fully allocated).
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_inode.c       |  4 +++-
>>  fs/xfs/xfs_trans_resv.c  | 47 +++++++++++++++++++++++++++++++++++++++++++----
>>  fs/xfs/xfs_trans_space.h |  7 ++++++-
>>  3 files changed, 52 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
...
>> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
>> index 2fd59c0..32f35c1 100644
>> --- a/fs/xfs/xfs_trans_resv.c
>> +++ b/fs/xfs/xfs_trans_resv.c
>> @@ -98,6 +98,37 @@ xfs_calc_inode_res(
>>  }
>>  
>>  /*
>> + * The free inode btree is a conditional feature and the log reservation
>> + * requirements differ slightly from that of the traditional inode allocation
>> + * btree. The finobt tracks records for inode chunks with at least one free inode.
>> + * Therefore, a record can be removed from the tree for an inode allocation or
>> + * free and the associated merge reservation is unconditional. This also covers
>> + * the possibility of a split on record insertion.
> 
> Slightly wider than 80 columns here. FWIW, if you use vim, add this
> rule to have it add a red line at the textwidth you have set:
> 
> " highlight textwidth
> set cc=+1
> 
> And that will point out lines that are too long quite obviously ;)
> 

Interesting, thanks. :)

>> + *
>> + * the free inode btree: max depth * block size
>> + * the free inode btree entry: block size
>> + *
>> + * TODO: is the modify res really necessary? covered by the merge/split res?
>> + * This seems to be the pattern of ifree, but not create_resv_alloc. Why?
> 
> The modify case is for an allocation that only updates an inobt
> record (i.e. chunk already allocated, free inodes in it). Because
> we can remove a finobt record when "modifying" the last free inode
> record in a chunk, "modify" can cause a redcord removal and hence a
> tree merge. In which case it's no different of any of the other
> finobt reservations....
> 

When I made this note, I think I was curious why there was a need to add
to the reservation in the modify case. If we always made a reservation
for a btree merge, wouldn't that be enough to cover the basic modify
case? In the code, it looks like we either delete the record or modify
it. Is there something in the delete case that I'm missing, or are we
just being conservative here? Nonetheless, I modelled this after the
ifree requirements, assuming the reservation there was correct.

>> @@ -267,6 +298,7 @@ xfs_calc_remove_reservation(
>>   *    the superblock for the nlink flag: sector size
>>   *    the directory btree: (max depth + v2) * dir block size
>>   *    the directory inode's bmap btree: (max depth + v2) * block size
>> + *    the finobt
>>   */
>>  STATIC uint
>>  xfs_calc_create_resv_modify(
>> @@ -275,7 +307,8 @@ xfs_calc_create_resv_modify(
>>  	return xfs_calc_inode_res(mp, 2) +
>>  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
>>  		(uint)XFS_FSB_TO_B(mp, 1) +
>> -		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
>> +		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
>> +		xfs_calc_finobt_res(mp, 1);
>>  }
> 
> And this is where is starts to get complex. The modify operation can
> now cause a finobt merge, when means blocks will be allocated/freed.
> That means we now need to take into account:
> 
>  *    the allocation btrees: 2 trees * (max depth - 1) * block size
> 
> and anything else freeing an extent requires.
> 

So is the "allocation btrees: 2 trees ..." portion of
xfs_calc_create_resv_alloc() associated with the allocation of the
actual inode blocks or potential allocations due to inode btree
management? I had thought the former, thus didn't include reservations
for this in the finobt calculation.

>>  /*
>> @@ -285,6 +318,7 @@ xfs_calc_create_resv_modify(
>>   *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
>>   *    the inode btree: max depth * blocksize
>>   *    the allocation btrees: 2 trees * (max depth - 1) * block size
>> + *    the finobt
>>   */
>>  STATIC uint
>>  xfs_calc_create_resv_alloc(
>> @@ -295,7 +329,8 @@ xfs_calc_create_resv_alloc(
>>  		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
>>  		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
>>  		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
>> -				 XFS_FSB_TO_B(mp, 1));
>> +				 XFS_FSB_TO_B(mp, 1)) +
>> +		xfs_calc_finobt_res(mp, 0);
>>  }
> 
> This reservation is only for v4 superblocks - the icreate
> transaction reservation is used for v5 superblocks, so that's the
> only one you need to modify.
> 

Ok, thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
