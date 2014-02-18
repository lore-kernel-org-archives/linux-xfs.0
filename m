Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DE557FE6
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 11:10:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 74CA58F8052
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 09:10:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id atNrW6o2JfCrr7wS for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 09:10:20 -0800 (PST)
Message-ID: <530393F8.4070106@redhat.com>
Date: Tue, 18 Feb 2014 12:10:16 -0500
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
>> index 001aa89..57c77ed 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1730,7 +1730,9 @@ xfs_inactive_ifree(
>>  	int			error;
>>  
>>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>> -	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
>> +	tp->t_flags |= XFS_TRANS_RESERVE;
>> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
>> +				  XFS_IFREE_SPACE_RES(mp), 0);
> 
> Can you add a comment explaining why the XFS_TRANS_RESERVE flag is
> used here, and why it's use won't lead to accelerated reserve pool
> depletion?
> 

So this aspect of things appears to be a bit more interesting than I
originally anticipated. I "reserve enabled" this transaction to
facilitate the ability to free up inodes under ENOSPC conditions.
Without this, the problem of failing out of xfs_inactive_ifree() (and
leaving an inode chained on the unlinked list) is easily reproducible
with generic/083.

The basic argument for why this is reasonable is that releasing an inode
releases used space (i.e., file blocks and potentially directory blocks
and inode chunks over time). That said, I can manufacture situations
where this is not the case. E.g., allocate a bunch of 0-sized files,
consume remaining free space in some separate file, start removing
inodes in a manner that removes a single inode per chunk or so. This
creates a scenario where the inobt can be very large and the finobt very
small (likely a single record). Removing the inodes in this manner
reduces the likelihood of freeing up any space and thus rapidly grows
the finobt towards the size of the inobt without any free space
available. This might or might not qualify as sane use of the fs, but I
don't think the failure scenario is acceptable as things currently stand.

I think there are several ways this can go from here. A couple ideas
that have crossed my mind:

- Find a way to variably reserve the number of blocks that would be
required to grow the finobt to the finobt, based on current state. This
would require the total number of blocks (not just enough for a split),
so this could get complex and somewhat overbearing (i.e., a lot of space
could be quietly reserved, current tracking might not be sufficient and
the allocation paths could get hairy).

- Work to push the ifree transaction allocation and reservation to the
unlink codepath rather than the eviction codepath. Under normal
circumstances, chain the tp to the xfs_inode such that the eviction code
path can grab it and run. This prevents us going into the state where an
inode is unlinked without having enough space to free up. On the flip
side, ENOSPC on unlink isn't very forgiving behavior to the user.

I think the former approach is probably overkill for something that
might be a pathological situation. The latter approach is more simple,
but it feels like a bit of a hack. I've experimented with it a bit, but
I'm not quite sure yet if it introduces any transaction issues by
allocating the unlink and ifree transactions at the same time.

Perhaps another argument could be made that it's rather unlikely we run
into an fs with as many 0-sized (or sub-inode chunk sized) files as
required to deplete the reserve pool without freeing any space, and we
should just touch up the failure handling. E.g.,

1.) Continue to reserve enable the ifree transaction. Consider expanding
the reserve pool on finobt-enabled fs' if appropriate. Note that this is
not guaranteed to provide enough resources to populate the finobt to the
level of the inobt without freeing up more space.
2.) Attempt a !XFS_TRANS_RESERVE tp reservation in xfs_inactive_ifree().
If fails, xfs_warn()/notice() and enable XFS_TRANS_RESERVE.
3.) Attempt XFS_TRANS_RESERVE reservation. If fails, xfs_notice() and
shutdown.

And this could probably be made more intelligent to bail out sooner if
we repeat XFS_TRANS_RESERVE reservations without freeing up any space,
etc. Before going too far in one direction... thoughts?

Brian

>>  	if (error) {
>>  		ASSERT(XFS_FORCED_SHUTDOWN(mp));
>>  		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
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
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
