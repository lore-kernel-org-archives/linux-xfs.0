Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GJGOMi181635 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 14:16:24 -0500
Message-ID: <502D4711.1010809@sgi.com>
Date: Thu, 16 Aug 2012 14:16:33 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfstests: _check_quota_usage needs to unmount to
	get XFS quotacheck
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-4-git-send-email-david@fromorbit.com>
	<20120726225504.GB2877@dastard>
In-Reply-To: <20120726225504.GB2877@dastard>
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

On 07/26/2012 05:55 PM, Dave Chinner wrote:
> On Thu, Jul 26, 2012 at 06:35:05PM +1000, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Remount won't run a quota check - it's only done during mount. Hence
>> all quota tests using this check function are not actually
>> validating XFS filesystems right now.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>
> FWIW, this change is exposing some problems in the new dquot code:
>
>> ---
>>   common.quota |   10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/common.quota b/common.quota
>> index 9736306..2fa784jack@suse.czb 100644
>> --- a/common.quota
>> +++ b/common.quota
>> @@ -236,6 +236,11 @@ _check_quota_usage()jack@suse.cz
>>   {
>>   	# Sync to get delalloc to disk
>>   	sync
>> +
>> +	# kill caches to guarantee removal speculative delalloc
>> +	# XXX: really need an ioctl instead of this big hammer
>> +	echo 3 > /proc/sys/vm/drop_caches
>> +
>
> Some kind of locking issue is present:
>
> [ 1871.738970] XFS (vdb): Quotacheck: Done.
> [ 1877.795774] ------------[ cut here ]------------
> [ 1877.797347] WARNING: at kernel/mutex-debug.c:78 debug_mutex_unlock+0xda/0xe0()
> [ 1877.799416] Hardware name: Bochs
> [ 1877.799416] Modules linked in:
> [ 1877.799416] Pid: 2261, comm: 232 Not tainted 3.5.0-rc5-dgc+ #313
> [ 1877.799416] Call Trace:
> [ 1877.799416]  [<ffffffff8107a83f>] warn_slowpath_common+0x7f/0xc0
> [ 1877.799416]  [<ffffffff8107a89a>] warn_slowpath_null+0x1a/0x20
> [ 1877.799416]  [<ffffffff810d022a>] debug_mutex_unlock+0xda/0xe0
> [ 1877.799416]  [<ffffffff81b4c97c>] __mutex_unlock_slowpath+0x7c/0x130
> [ 1877.799416]  [<ffffffff81b4ca3e>] mutex_unlock+0xe/0x10
> [ 1877.799416]  [<ffffffff814b12d8>] xfs_qm_dqreclaim_one+0x178/0x3d0
> [ 1877.799416]  [<ffffffff814b1620>] xfs_qm_shake+0xf0/0x170
> [ 1877.799416]  [<ffffffff81137789>] shrink_slab+0x169/0x350
> [ 1877.799416]  [<ffffffff81709b04>] ? do_raw_spin_lock+0x54/0x120
> [ 1877.799416]  [<ffffffff8118a488>] ? iput+0x48/0x210
> [ 1877.799416]  [<ffffffff8119b433>] drop_caches_sysctl_handler+0x73/0xa0
> [ 1877.799416]  [<ffffffff811de863>] proc_sys_call_handler.isra.11+0xb3/0xd0
> [ 1877.799416]  [<ffffffff811de898>] proc_sys_write+0x18/0x20
> [ 1877.799416]  [<ffffffff81170298>] vfs_write+0xa8/0x160
> [ 1877.799416]  [<ffffffff8117058a>] sys_write+0x4a/0x90
> [ 1877.799416]  [<ffffffff81b57269>] system_call_fastpath+0x16/0x1b
> [ 1877.799416] ---[ end trace 4f2a89b2cbd5e64f ]---
>
> which is:
>
> 	DEBUG_LOCKS_WARN_ON(lock->owner != current);
>
> so something other than the task that locked the mutex unlocked it,
> or we are unlocking an unlocked dquot...
>
>>   	VFS_QUOTA=0
>>   	case $FSTYP in
>>   	ext2|ext3|ext4|ext4dev|reiserfs)
>> @@ -253,8 +258,9 @@ _check_quota_usage()
>>   		quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>>   	else
>>   		# use XFS method to force quotacheck
>> -		mount -o remount,noquota $SCRATCH_DEV
>> -		mount -o remount,usrquota,grpquota $SCRATCH_DEV
>> +		xfs_quota -x -c "off -ug" $SCRATCH_MNT
>
> And this is hanging with what appears to be a reference counting bug
> when purging dquots in generic/233:
>
> # echo w > /proc/sysrq-trigger
> [53710.206100] SysRq : Show Blocked State
> [53710.207213]   task                        PC stack   pid father
> [53710.208749] xfs_quota       D ffff88003fc12880  3896 18147  17936 0x00000000
> [53710.209738]  ffff88000f3afc18 0000000000000086 ffff88001cb160c0 ffff88000f3affd8
> [53710.209738]  ffff88000f3affd8 ffff88000f3affd8 ffffffff81f9b420 ffff88001cb160c0
> [53710.209738]  ffff88000f3afc08 ffffffff821ece80 ffff88000f3afc50 0000000100cbbe68
> [53710.209738] Call Trace:
> [53710.209738]  [<ffffffff81b4dea9>] schedule+0x29/0x70
> [53710.209738]  [<ffffffff81b4bcad>] schedule_timeout+0x13d/0x2c0
> [53710.209738]  [<ffffffff81089f90>] ? usleep_range+0x50/0x50
> [53710.209738]  [<ffffffff814aea90>] ? xfs_qm_need_dqattach+0x70/0x70
> [53710.209738]  [<ffffffff81b4be4e>] schedule_timeout_uninterruptible+0x1e/0x20
> [53710.209738]  [<ffffffff814aeef3>] xfs_qm_dquot_walk+0x153/0x170
> [53710.209738]  [<ffffffff816fb81b>] ? radix_tree_lookup+0xb/0x10
> [53710.209738]  [<ffffffff8149772a>] ? xfs_perag_get+0x3a/0x120
> [53710.209738]  [<ffffffff814ace60>] ? xfs_trans_free_dqinfo+0x40/0x40
> [53710.209738]  [<ffffffff81448aef>] ? xfs_inode_ag_iterator+0x8f/0xa0
> [53710.209738]  [<ffffffff814aef93>] xfs_qm_dqpurge_all+0x83/0x90
> [53710.209738]  [<ffffffff814ae4b9>] xfs_qm_scall_quotaoff+0x139/0x350
> [53710.209738]  [<ffffffff814b2780>] xfs_fs_set_xstate+0xd0/0xf0
> [53710.209738]  [<ffffffff811d1088>] sys_quotactl+0x1f8/0x740
> [53710.209738]  [<ffffffff81174d7a>] ? sys_newstat+0x2a/0x40
> [53710.209738]  [<ffffffff81b52635>] ? do_async_page_fault+0x35/0x90
> [53710.209738]  [<ffffffff81b57269>] system_call_fastpath+0x16/0x1b
>
> It's hitting a dquot that either has the FREEING flag set of an
> elevated reference count, so is skipping it. It gets stuck in the
> loop forever retrying. That's probably related to the above lock
> issue.
>
> And generic/231 fails with a significant accounting difference:
>
> generic/231      [failed, exit status 1] - output mismatch (see tests/generic/231.out.bad)
> --- tests/generic/231.out       2012-07-26 18:42:30.000000000 +1000
> +++ results/generic/231.out.bad 2012-07-27 08:24:22.000000000 +1000
> @@ -2,15 +2,7 @@
>   === FSX Standard Mode, Memory Mapping, 1 Tasks ===
>   All operations completed A-OK!
>   Comparing user usage
> -Comparing group usage
> -=== FSX Standard Mode, Memory Mapping, 4 Tasks ===
> -All operations completed A-OK!
> -All operations completed A-OK!
> -All operations completed A-OK!
> -All operations completed A-OK!
> -Comparing user usage
> -Comparing group usage
> -=== FSX Standard Mode, Memory Mapping, 1 Tasks ===
> -All operations completed A-OK!
> -Comparing user usage
> -Comparing group usage
> +4c4
> +< #1001     --     524       0       0              3     0     0
> +---
> +> #1001     --     316       0       0              3     0     0
>
> generic/270 and generic/233 give a similar mismatch when they don't
> hang.
>
> So, yeah, we haven't been verifying the quota accounting code as
> well as we should have been for some time now....
>
> Cheers,
>
> Dave.
>
I did see the the hang some times and the accounting mismatch.  Dave do 
you want to look into this further.  Otherwise I am OK with approving 
this patch and fixing the accounting and lockup under another bug 
because this patch is the way to work around the remount issue.  I will 
leave it up to you.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
