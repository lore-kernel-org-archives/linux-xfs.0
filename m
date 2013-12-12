Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BB6529DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:30:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29CA7304077
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:30:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CEKaHqL3M1UerlWu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 01:30:23 -0800 (PST)
Message-ID: <52A98226.4020705@oracle.com>
Date: Thu, 12 Dec 2013 17:30:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] xfs: don't try to mark uncached buffers stale on
	error.
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1386826478-13846-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 12/12 2013 13:34, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> fsstress failed during a shutdown with the following assert:
Looks fsstress is always a good aid to make file system cry... :-P

I wonder if here the shutdown is simulated via xfstests/src/godown or not,
but I can trigger another hang up issue with this patch via a test case
below(80% reproducible, I also ran the test against the left patches in
this series, this problem still exists):

#!/bin/bash

mkfs.xfs -f /dev/sda7

for ((i=0;i<10;i++))
do
    mount /dev/sda7 /xfs
    fsstress -d /xfs -n 1000 -p 100 >/dev/null 2>&1 &
    sleep 10
    godown /xfs
    wait
    killall -q fsstress
    umount /xfs
done

It seems there is no such kind of test cases in xfstestes for now, I'd
write one if required.

The backtraces were shown as following:

[  365.987493] INFO: task fsstress:3215 blocked for more than 120 seconds.
[  365.987499]       Tainted: PF          O 3.13.0-rc2+ #13
[  365.987500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  365.987502] fsstress        D ffff88026f254440     0  3215   3142 0x00000000
[  365.987507]  ffff880253f19de0 0000000000000086 ffff880242071800 ffff880253f19fd8
[  365.987512]  0000000000014440 0000000000014440 ffff880242071800 ffff880073694c00
[  365.987515]  ffff880073694c80 ffff880073694c90 ffffffffffffffff 0000000000000292
[  365.987519] Call Trace:
[  365.987528]  [<ffffffff81718779>] schedule+0x29/0x70
[  365.987560]  [<ffffffffa0c2a49d>] xlog_cil_force_lsn+0x18d/0x1e0 [xfs]
[  365.987565]  [<ffffffff81097210>] ? wake_up_state+0x20/0x20
[  365.987570]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
[  365.987594]  [<ffffffffa0c28921>] _xfs_log_force+0x61/0x270 [xfs]
[  365.987599]  [<ffffffff812b0610>] ? jbd2_log_wait_commit+0x110/0x180
[  365.987603]  [<ffffffff810a83f0>] ? prepare_to_wait_event+0x100/0x100
[  365.987607]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
[  365.987629]  [<ffffffffa0c28b56>] xfs_log_force+0x26/0x80 [xfs]
[  365.987648]  [<ffffffffa0bcf35d>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[  365.987652]  [<ffffffff811e8790>] sync_fs_one_sb+0x20/0x30
[  365.987656]  [<ffffffff811bcc32>] iterate_supers+0xb2/0x110
[  365.987660]  [<ffffffff811e88c2>] sys_sync+0x62/0xa0
[  365.987665]  [<ffffffff81724ced>] system_call_fastpath+0x1a/0x1f
[  372.225302] XFS (sda7): xfs_log_force: error 5 returned.
[  402.275608] XFS (sda7): xfs_log_force: error 5 returned.
[  432.325929] XFS (sda7): xfs_log_force: error 5 returned.
[  462.376239] XFS (sda7): xfs_log_force: error 5 returned.
[  485.869059] INFO: task fsstress:3215 blocked for more than 120 seconds.
[  485.869065]       Tainted: PF          O 3.13.0-rc2+ #13
[  485.869066] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  485.869068] fsstress        D ffff88026f254440     0  3215   3142 0x00000000
[  485.869073]  ffff880253f19de0 0000000000000086 ffff880242071800 ffff880253f19fd8
[  485.869077]  0000000000014440 0000000000014440 ffff880242071800 ffff880073694c00
[  485.869081]  ffff880073694c80 ffff880073694c90 ffffffffffffffff 0000000000000292
[  485.869085] Call Trace:
[  485.869093]  [<ffffffff81718779>] schedule+0x29/0x70
[  485.869123]  [<ffffffffa0c2a49d>] xlog_cil_force_lsn+0x18d/0x1e0 [xfs]
[  485.869129]  [<ffffffff81097210>] ? wake_up_state+0x20/0x20
[  485.869135]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
[  485.869160]  [<ffffffffa0c28921>] _xfs_log_force+0x61/0x270 [xfs]
[  485.869167]  [<ffffffff812b0610>] ? jbd2_log_wait_commit+0x110/0x180
[  485.869172]  [<ffffffff810a83f0>] ? prepare_to_wait_event+0x100/0x100
[  485.869177]  [<ffffffff811e8770>] ? do_fsync+0x80/0x80
[  485.869199]  [<ffffffffa0c28b56>] xfs_log_force+0x26/0x80 [xfs]
[  485.869219]  [<ffffffffa0bcf35d>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[  485.869224]  [<ffffffff811e8790>] sync_fs_one_sb+0x20/0x30
[  485.869229]  [<ffffffff811bcc32>] iterate_supers+0xb2/0x110
[  485.869232]  [<ffffffff811e88c2>] sys_sync+0x62/0xa0
[  485.869237]  [<ffffffff81724ced>] system_call_fastpath+0x1a/0x1f
[  492.426514] XFS (sda7): xfs_log_force: error 5 returned.
[  522.476867] XFS (sda7): xfs_log_force: error 5 returned.
[  552.527131] XFS (sda7): xfs_log_force: error 5 returned.
[  582.577433] XFS (sda7): xfs_log_force: error 5 returned.


Thanks,
-Jeff
> 
> XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 143
> .....
>  xfs_buf_stale+0x3f/0xf0
>  xfs_bioerror_relse+0x2d/0x90 
>  xfsbdstrat+0x51/0xa0
>  xfs_zero_remaining_bytes+0x1d1/0x2d0
>  xfs_free_file_space+0x5d0/0x600
>  xfs_change_file_space+0x251/0x3a0
>  xfs_ioc_space+0xcc/0x130
> .....
> 
> xfs_zero_remaining_bytes() works with uncached buffers, and hence if
> we are preventing IO due to a shutdown, we should not be marking it
> stale as that is only for cached buffers. Instead, just mark it with
> an error and make sure it gets to the caller.
> 
> [ 7732.193441] XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 96
> [ 7732.195036] ------------[ cut here ]------------
> [ 7732.195890] kernel BUG at fs/xfs/xfs_message.c:107!
> [ 7732.196018] invalid opcode: 0000 [#1] SMP
> [ 7732.196018] Modules linked in:
> [ 7732.196018] CPU: 0 PID: 2899 Comm: fsstress Not tainted 3.12.0-rc7-dgc+ #47
> [ 7732.196018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 7732.196018] task: ffff88003a83ada0 ti: ffff88002c0ae000 task.ti: ffff88002c0ae000
> [ 7732.196018] RIP: 0010:[<ffffffff81488462>]  [<ffffffff81488462>] assfail+0x22/0x30
> [ 7732.196018] RSP: 0000:ffff88002c0afae8  EFLAGS: 00010292
> [ 7732.196018] RAX: 000000000000004d RBX: ffff880002e59600 RCX: 0000000000000000
> [ 7732.196018] RDX: ffff88003fc0ed68 RSI: ffff88003fc0d3f8 RDI: 0000000000000246
> [ 7732.196018] RBP: ffff88002c0afae8 R08: 0000000000000096 R09: 00000000000012ec
> [ 7732.196018] R10: 0000000000000000 R11: 00000000000012eb R12: 0000000000100002
> [ 7732.196018] R13: ffffffff81473523 R14: 0000000000009fff R15: 0000000000009fff
> [ 7732.196018] FS:  00007f8017e4a700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
> [ 7732.196018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 7732.196018] CR2: 00007ff8d020a000 CR3: 0000000009b43000 CR4: 00000000000006f0
> [ 7732.196018] Stack:
> [ 7732.196018]  ffff88002c0afb08 ffffffff8147476e ffff880002e59600 0000000000100002
> [ 7732.196018]  ffff88002c0afb28 ffffffff814762cd ffff880002e59600 ffff880002e59600
> [ 7732.196018]  ffff88002c0afb58 ffffffff81476841 0000000000009f89 ffff880002e59600
> [ 7732.196018] Call Trace:
> [ 7732.196018]  [<ffffffff8147476e>] xfs_buf_stale+0x2e/0xb0
> [ 7732.196018]  [<ffffffff814762cd>] xfs_bioerror_relse+0x2d/0x90
> [ 7732.196018]  [<ffffffff81476841>] xfsbdstrat+0x51/0x90
> [ 7732.196018]  [<ffffffff81473523>] xfs_zero_remaining_bytes+0x1d3/0x2d0
> [ 7732.196018]  [<ffffffff81473ba6>] xfs_free_file_space+0x586/0x5b0
> [ 7732.196018]  [<ffffffff81190002>] ? slabs_cpu_partial_show+0xd2/0x120
> [ 7732.196018]  [<ffffffff811b9399>] ? mntput_no_expire+0x49/0x160
> [ 7732.196018]  [<ffffffff811b8812>] ? mnt_clone_write+0x12/0x30
> [ 7732.196018]  [<ffffffff81aba3f6>] ? down_write+0x16/0x40
> [ 7732.196018]  [<ffffffff81481c14>] xfs_ioc_space+0x2d4/0x450
> [ 7732.196018]  [<ffffffff811a700b>] ? path_lookupat+0x6b/0x760
> [ 7732.196018]  [<ffffffff8148f57e>] ? xfs_trans_free+0x6e/0x80
> [ 7732.196018]  [<ffffffff81192a81>] ? kmem_cache_alloc+0x31/0x150
> [ 7732.196018]  [<ffffffff8148326b>] xfs_file_ioctl+0x48b/0xae0
> [ 7732.196018]  [<ffffffff811a60d6>] ? final_putname+0x26/0x50
> [ 7732.196018]  [<ffffffff8110b6a2>] ? from_kgid+0x12/0x20
> [ 7732.196018]  [<ffffffff8110b6be>] ? from_kgid_munged+0xe/0x20
> [ 7732.196018]  [<ffffffff8119f856>] ? cp_new_stat+0x146/0x160
> [ 7732.196018]  [<ffffffff811ace02>] do_vfs_ioctl+0x452/0x530
> [ 7732.196018]  [<ffffffff8119fd35>] ? SYSC_newfstat+0x25/0x30
> [ 7732.196018]  [<ffffffff811acf71>] SyS_ioctl+0x91/0xb0
> [ 7732.196018]  [<ffffffff81ac6029>] system_call_fastpath+0x16/0x1b
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 47 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ce01c1a..27dc152 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1076,7 +1076,14 @@ xfs_bioerror(
>  	 */
>  	XFS_BUF_UNREAD(bp);
>  	XFS_BUF_UNDONE(bp);
> -	xfs_buf_stale(bp);
> +
> +	/*
> +	 * we might be handling an uncached buffer here, in which case the
> +	 * stale buffer handling is irrelevant as is doing IO with the buffer
> +	 * locked. Hence we don't mark them stale.
> +	 */
> +	if (bp->b_pag)
> +		xfs_buf_stale(bp);
>  
>  	xfs_buf_ioend(bp, 0);
>  
> @@ -1094,25 +1101,20 @@ xfs_bioerror_relse(
>  	struct xfs_buf	*bp)
>  {
>  	int64_t		fl = bp->b_flags;
> +
>  	/*
> -	 * No need to wait until the buffer is unpinned.
> -	 * We aren't flushing it.
> -	 *
> -	 * chunkhold expects B_DONE to be set, whether
> -	 * we actually finish the I/O or not. We don't want to
> -	 * change that interface.
> +	 * No need to wait until the buffer is unpinned. We aren't flushing it.
>  	 */
>  	XFS_BUF_UNREAD(bp);
>  	XFS_BUF_DONE(bp);
>  	xfs_buf_stale(bp);
>  	bp->b_iodone = NULL;
> +
> +	/*
> +	 * There's no reason to mark error for ASYNC buffers as there is no-one
> +	 * waiting to collect the error.
> +	 */
>  	if (!(fl & XBF_ASYNC)) {
> -		/*
> -		 * Mark b_error and B_ERROR _both_.
> -		 * Lot's of chunkcache code assumes that.
> -		 * There's no reason to mark error for
> -		 * ASYNC buffers.
> -		 */
>  		xfs_buf_ioerror(bp, EIO);
>  		complete(&bp->b_iowait);
>  	} else {
> @@ -1129,14 +1131,13 @@ xfs_bdstrat_cb(
>  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
>  		trace_xfs_bdstrat_shut(bp, _RET_IP_);
>  		/*
> -		 * Metadata write that didn't get logged but
> -		 * written delayed anyway. These aren't associated
> -		 * with a transaction, and can be ignored.
> +		 * If this is a cached write, then it is likely to be a delayed
> +		 * write metadata buffer that can be ignored because the
> +		 * contents are logged.
>  		 */
>  		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
>  			return xfs_bioerror_relse(bp);
> -		else
> -			return xfs_bioerror(bp);
> +		return xfs_bioerror(bp);
>  	}
>  
>  	xfs_buf_iorequest(bp);
> @@ -1176,7 +1177,15 @@ xfsbdstrat(
>  {
>  	if (XFS_FORCED_SHUTDOWN(mp)) {
>  		trace_xfs_bdstrat_shut(bp, _RET_IP_);
> -		xfs_bioerror_relse(bp);
> +		/*
> +		 * we could be handling uncached IO here, in which case there is
> +		 * always a caller waiting to collect the error and releas the
> +		 * buffer.
> +		 */
> +		if (bp->b_pag)
> +			xfs_bioerror_relse(bp);
> +		else
> +			xfs_bioerror(bp);
>  		return;
>  	}
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
