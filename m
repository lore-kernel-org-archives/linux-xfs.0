Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95E4E7FBF
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:40:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64C5A8F8054
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 16:40:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V0M7WFaZHy2FvwqP for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 16:40:47 -0800 (PST)
Date: Wed, 11 Dec 2013 11:40:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS umount with IO errors seems to lead to memory corruption
Message-ID: <20131211004039.GE10988@dastard>
References: <CAOcd+r3i0mDK2vAnZ-0s6VGnSsJwWxnEB2uMrcz+WSJAxx2bmA@mail.gmail.com>
	<20131121220713.GB6502@dastard>
	<CAOcd+r24UpR6F709SSJ-StWk8QYXC-w68diKvvKaRUkvdC1Vfg@mail.gmail.com>
	<1E31497CEB304DB68E5EFCF4814F9A27@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1E31497CEB304DB68E5EFCF4814F9A27@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

[ Sorry, Alex, I missed your last email. Thanks for pinging me to
remind me to look at it. ]

On Tue, Dec 10, 2013 at 09:36:11AM +0200, Alex Lyakas wrote:
> Hi Dave,
> any insight on this issue? At least on the simpler reproduction with
> "error" DeviceMapper?

Yes, it does point to the problem.


> -----Original Message----- From: Alex Lyakas
> Sent: 24 November, 2013 12:27 PM
> To: Dave Chinner ; xfs@oss.sgi.com
> Cc: linux-xfs@vger.kernel.org
> Subject: Re: XFS umount with IO errors seems to lead to memory corruption
> 
> Hi Dave,
> thank you for your comments.
> 
> The test that I am doing is unmounting the XFS, while its underlying
> block device returns intermittent IO errors. The block device in
> question is a custom DeviceMapper target. It returns -ECANCELED in
> this case. Should I return some other errno instead?
> The same exact test works alright with ext4. It's unmount finishes,
> system seems to continue functioning normally and kmemleak is also
> happy.
> 
> When doing a simpler reproductoin with "error" Device-Mapper, umount
> gets stuck and never returns, while kernel keeps printing:
> XFS (dm-0): metadata I/O error: block 0x0 ("xfs_buf_iodone_callbacks") error 5 numblks 1

It's trying to write the superblock - it's and async, background
metadata write, and it's failing.

        /*
         * If the write was asynchronous then no one will be looking for the
         * error.  Clear the error state and write the buffer out again.
         *
         * XXX: This helps against transient write errors, but we need to find
         * a way to shut the filesystem down if the writes keep failing.
         *
         * In practice we'll shut the filesystem down soon as non-transient
         * erorrs tend to affect the whole device and a failing log write
         * will make us give up.  But we really ought to do better here.
         */
        if (XFS_BUF_ISASYNC(bp)) {
                ASSERT(bp->b_iodone != NULL);

                trace_xfs_buf_item_iodone_async(bp, _RET_IP_);

                xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */

                if (!XFS_BUF_ISSTALE(bp)) {
                        bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
                        xfs_buf_iorequest(bp);
                } else {
                        xfs_buf_relse(bp);
                }

                return;
        }

There's the problem code - it just keeps resubmitting the failed IO
and so never unlocks it and it never completes.


> this never returns and /proc shows:
> root@vc-00-00-1075-dev:~# cat /proc/2684/stack
> [<ffffffffa033ac6a>] xfs_ail_push_all_sync+0x9a/0xd0 [xfs]
> [<ffffffffa0330123>] xfs_unmountfs+0x63/0x160 [xfs]
> [<ffffffffa02ee265>] xfs_fs_put_super+0x25/0x60 [xfs]
> [<ffffffff8118fd12>] generic_shutdown_super+0x62/0xf0
> [<ffffffff8118fdd0>] kill_block_super+0x30/0x80
> [<ffffffff811903dc>] deactivate_locked_super+0x3c/0x90
> [<ffffffff81190d7e>] deactivate_super+0x4e/0x70
> [<ffffffff811ad086>] mntput_no_expire+0x106/0x160
> [<ffffffff811ae760>] sys_umount+0xa0/0xe0
> [<ffffffff816ab919>] system_call_fastpath+0x16/0x1b
> [<FFFfffffffffffff>] 0xffffffffffffffff

That's waiting for the superblock to be marked clean.

> And after some time, hung task warning shows:
> INFO: task kworker/2:1:39 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/2:1     D ffffffff8180cf00     0    39      2 0x00000000
> ffff88007c54db38 0000000000000046 000000027d003700 ffff88007fd03fc0
> ffff88007c54dfd8 ffff88007c54dfd8 ffff88007c54dfd8 0000000000013e40
> ffff88007c9e9710 ffff88007c4bdc40 00000000000000b8 7fffffffffffffff
> Call Trace:
> [<ffffffff816a1b99>] schedule+0x29/0x70
> [<ffffffff816a02d5>] schedule_timeout+0x1e5/0x250
> [<ffffffffa02f3987>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
> [<ffffffff816798e6>] ? kmemleak_alloc+0x26/0x50
> [<ffffffff816a0f1b>] __down_common+0xa0/0xf0
> [<ffffffffa032f37c>] ? xfs_getsb+0x3c/0x70 [xfs]
> [<ffffffff816a0fde>] __down+0x1d/0x1f
> [<ffffffff81084591>] down+0x41/0x50
> [<ffffffffa02dcd44>] xfs_buf_lock+0x44/0x110 [xfs]
> [<ffffffffa032f37c>] xfs_getsb+0x3c/0x70 [xfs]
> [<ffffffffa033b4bc>] xfs_trans_getsb+0x4c/0x140 [xfs]
> [<ffffffffa032f06e>] xfs_mod_sb+0x4e/0xc0 [xfs]
> [<ffffffffa02e3b24>] xfs_fs_log_dummy+0x54/0x90 [xfs]
> [<ffffffffa0335bf8>] xfs_log_worker+0x48/0x50 [xfs]
> [<ffffffff81077a11>] process_one_work+0x141/0x4a0
> [<ffffffff810789e8>] worker_thread+0x168/0x410
> [<ffffffff81078880>] ? manage_workers+0x120/0x120
> [<ffffffff8107df10>] kthread+0xc0/0xd0
> [<ffffffff813a3ea4>] ? acpi_get_child+0x47/0x4d
> [<ffffffff813a3fb7>] ? acpi_platform_notify.part.0+0xbb/0xda
> [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0
> [<ffffffff816ab86c>] ret_from_fork+0x7c/0xb0
> [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0

And that's blocked on the superblock buffer because it hasn't been
unlocked due to the failing write not completing.

I'll have a think about how to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
