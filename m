Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35594 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965714AbcIWQYz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Sep 2016 12:24:55 -0400
Subject: Re: [PATCH] xfs: quiesce the filesystem after recovery on readonly
 mount
References: <1474589500-13584-1-git-send-email-david@fromorbit.com>
 <af65b5ae-2ff8-c344-0e04-cbbef3efe197@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f693b1a2-1cdb-ed9f-caa0-af9407034927@sandeen.net>
Date: Fri, 23 Sep 2016 11:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <af65b5ae-2ff8-c344-0e04-cbbef3efe197@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>

On 9/22/16 8:39 PM, Eric Sandeen wrote:
> On 9/22/16 7:11 PM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>

...

>> To avoid this problem, we need to ensure that a read-only mount
>> always updates the log when it completes the second phase of
>> recovery. We already handle this sort of issue with rw->ro remount
>> transitions, so the solution is as simple as quiescing the
>> filesystem at the appropriate time during the mount process. This
>> results in the log being marked clean so the mount behaviour
>> recorded in the logs on repeated RO mounts will change (i.e. log
>> recovery will no longer be run on every mount until a RW mount is
>> done). This is a user visible change in behaviour, but it is
>> harmless.
> 
> Excellent idea :)
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Actually ...  after playing with this a bit ...

Should we restrict this to only when the log got
replayed, with a !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) test?

Maybe it's harmless as it is, but it seems we should restrict
it to the log-got-replayed case.

-Eric

>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/xfs_mount.c | 14 ++++++++++++++
>>  fs/xfs/xfs_super.c |  2 +-
>>  fs/xfs/xfs_super.h |  1 +
>>  3 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index faeead6..56e85a6 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -934,6 +934,20 @@ xfs_mountfs(
>>  	}
>>  
>>  	/*
>> +	 * Now the log is fully replayed, we can transition to full read-only
>> +	 * mode for read-only mounts. This will sync all the metadata and clean
>> +	 * the log so that the recovery we just performed does not have to be
>> +	 * replayed again on the next mount.
>> +	 *
>> +	 * We use the same quiesce mechanism as the rw->ro remount, as they are
>> +	 * semantically identical operations.
>> +	 */
>> +	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
>> +							XFS_MOUNT_RDONLY) {
>> +		xfs_quiesce_attr(mp);
>> +	}
>> +
>> +	/*
>>  	 * Complete the quota initialisation, post-log-replay component.
>>  	 */
>>  	if (quotamount) {
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 3409753..2d092f9 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1137,7 +1137,7 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>>   * Note: xfs_log_quiesce() stops background log work - the callers must ensure
>>   * it is started again when appropriate.
>>   */
>> -static void
>> +void
>>  xfs_quiesce_attr(
>>  	struct xfs_mount	*mp)
>>  {
>> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
>> index 529bce9..b6418ab 100644
>> --- a/fs/xfs/xfs_super.h
>> +++ b/fs/xfs/xfs_super.h
>> @@ -61,6 +61,7 @@ struct xfs_mount;
>>  struct xfs_buftarg;
>>  struct block_device;
>>  
>> +extern void xfs_quiesce_attr(struct xfs_mount *mp);
>>  extern void xfs_flush_inodes(struct xfs_mount *mp);
>>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>>  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
