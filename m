Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5MKdegh114487 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 15:39:40 -0500
Message-ID: <4FE4D807.6030902@sgi.com>
Date: Fri, 22 Jun 2012 15:39:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: force log before unmount
References: <20120621192541.630212563@sgi.com>
	<20120621192600.936441949@sgi.com> <20120621235058.GF10673@dastard>
In-Reply-To: <20120621235058.GF10673@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/21/12 18:50, Dave Chinner wrote:
> On Thu, Jun 21, 2012 at 02:25:42PM -0500, tinguely@sgi.com wrote:
>> From: Mark Tinguely<tinguely@sgi.com>
>>
>> Testing has found a few crashes of dereference of NULL in the
>> xlog_assign_tail_lsn_locked() and xlog_get_lowest_lsn() routines from
>> buf iodone callbacks. The filesystem is be shutdown. At the point of
>> the crash, the log has alreadly been freed which leads to the NULL pointer
>> dereference.
>>
>> One crash still pointed to the buffer that was going through the iodone
>> path and that buffer had XFS_SB_MAGIC in it.
>
> Which points to the problem, but you haven't quite worked out what
> the root cause of this is so the patch doesn't actually fix the
> problem, It changes the timing of IO, so it can certainly mke it
> seem like it fixed the race condition....
>
>> This patch sits on top of Ben's proposed patch to shutdown the sync worker.
>> Although it did not cause the crash I would like to be on the safe side, and
>> perform the shutdown of the sync worker to occur before the last write of the
>> superblock.
>
> The sync worker is not an actor in this race condition - where it
> was placed in xfs_log_unmount() is the correct place for it.
>
>> Then force the log to get the superblock buffer into the AIL before
>> it is pushed for the last time..
>
> The superblock is already in the AIL - otherwise we wouldn't have
> crashed trying to remove it from the AIL after the log has been torn
> down.
>
>> To the best of my searching, xfs_log_unmount_write() should not dirty the
>> superblock..
>
> It doesn't - it just writes an unmount record to the log.
>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>>   fs/xfs/xfs_log.c   |    1 -
>>   fs/xfs/xfs_mount.c |    2 ++
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: b/fs/xfs/xfs_log.c
>> ===================================================================
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -810,7 +810,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>>   void
>>   xfs_log_unmount(xfs_mount_t *mp)
>>   {
>> -	cancel_delayed_work_sync(&mp->m_sync_work);
>>   	xfs_trans_ail_destroy(mp);
>>   	xlog_dealloc_log(mp->m_log);
>>   }
>> Index: b/fs/xfs/xfs_mount.c
>> ===================================================================
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -1517,6 +1517,7 @@ xfs_unmountfs(
>>   		xfs_warn(mp, "Unable to free reserved block pool. "
>>   				"Freespace may not be correct on next mount.");
>>
>> +	cancel_delayed_work_sync(&mp->m_sync_work);
>>   	error = xfs_log_sbcount(mp);
>>   	if (error)
>>   		xfs_warn(mp, "Unable to update superblock counters. "
>> @@ -1526,6 +1527,7 @@ xfs_unmountfs(
>>   	 * At this point we might have modified the superblock again and thus
>>   	 * added an item to the AIL, thus flush it again.
>>   	 */
>> +	xfs_log_force(mp, XFS_LOG_SYNC);
>
> This is a no-op - xfs_log_sbcount() does a synchronous transaction,
> so the log has already been forced at this point and the superblock
> is not pinned in memory.
>
>>   	xfs_ail_push_all_sync(mp->m_ail);
>>   	xfs_wait_buftarg(mp->m_ddev_targp);
>
> So, what is different about the superblock buffer? It's an uncached
> buffer. What does that mean? It means that when xfs_wait_buftarg()
> walks the LRU, it never finds the superblock buffer because uncached
> buffers are never put on the LRU.
>

Thanks Dave. Just interested; are the uncached buffers kept off the
LRU with an extra b_hold reference?

> Hence, when xfs_ail_push_all_sync() triggers an async write of the
> superblock, nobody ever waits for it to complete. Hence the log and
> AIL are torn down, and when the IO completes it goes to remove it
> from the AIL (which succeeds) and then move the log tail because it
> was the only item in the AIL, it goes kaboom.
>
> So the root cause is that we are not waiting for the superblock IO
> to complete i.e. it's not at all related to the xfs_sync_worker(), log
> forces, etc. What we really need to do is after the
> xfs_log_sbcount() call is write the superblock synchronously, and we
> can do that in xfs_log_sbcount() because all the callers of
> xfs_log_sbcount() have this same problem of not waiting for the SB
> to be written correctly. i.e. add the guts of xfs_sync_fsdata() to
> xfs_log_sbcount()....
>


I did not expect the sync worker was the cause. Ben's patch is not even
in at least one of the crashes. I thought it would be good thing to have
the sync worker idle by the time we write the unmount record in the log.

Thank-you again for the lesson and insight.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
