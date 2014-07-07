Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 508C07F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 10:18:44 -0500 (CDT)
Message-ID: <53BABA4F.9030505@sgi.com>
Date: Mon, 07 Jul 2014 10:18:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: free inodes on log recovery error
References: <20140702143206.438456679@sgi.com>
	<20140702144139.894251516@sgi.com>
	<20140707143027.GB4123@laptop.bfoster>
In-Reply-To: <20140707143027.GB4123@laptop.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 07/07/14 09:30, Brian Foster wrote:
> On Wed, Jul 02, 2014 at 09:32:10AM -0500, Mark Tinguely wrote:
>> Recovery may free inodes that end up on the inode
>> reclaim RCU. If recovery fails, we leak these inodes.
>> The filesystem should be in forced shutdown at this
>> point, so a call to xfs_reclaim_inode is a fast path
>> to freeing the inodes and RCU entries.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>>   fs/xfs/xfs_log.c   |    2 ++
>>   fs/xfs/xfs_mount.c |    1 +
>>   2 files changed, 3 insertions(+)
>>
>> Index: b/fs/xfs/xfs_log.c
>> ===================================================================
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -31,6 +31,7 @@
>>   #include "xfs_log_priv.h"
>>   #include "xfs_log_recover.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_icache.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_cksum.h"
>> @@ -720,6 +721,7 @@ xfs_log_mount(
>>   	return 0;
>>
>>   out_destroy_ail:
>> +	xfs_reclaim_inodes(mp, SYNC_WAIT);
>
> So an inode in the perag cache means an xfs_iget(). I see that in
> xlog_recover_process_one_iunlink(), which is via
> xfs_log_mount_finish(). Assuming I'm following that correctly, why the
> reclaim here (and in response to failure here by the caller) as opposed
> to closer to a failure of xfs_log_mount_finish()?
>
> Brian
>
>>   	xfs_trans_ail_destroy(mp);
>>   out_free_log:
>>   	xlog_dealloc_log(mp->m_log);
>> Index: b/fs/xfs/xfs_mount.c
>> ===================================================================
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -980,6 +980,7 @@ xfs_mountfs(
>>    out_log_dealloc:
>>   	xfs_log_unmount(mp);
>>    out_fail_wait:
>> +	xfs_reclaim_inodes(mp, SYNC_WAIT);
>>   	if (mp->m_logdev_targp&&  mp->m_logdev_targp != mp->m_ddev_targp)
>>   		xfs_wait_buftarg(mp->m_logdev_targp);
>>   	xfs_wait_buftarg(mp->m_ddev_targp);
>>
>>
>> _______________________________________________

You are right, the reclaim in xfs_log_mount() is now redundant.

The xfs_reclaim_inodes call location in xfs_mount error path had changed 
when I learned that the xfs_log_unmount() left inodes in the RCU. I did 
not notice that with the new location that they were the same.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
