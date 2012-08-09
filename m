Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79MFPxg232826 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 17:15:26 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	T9HDgGCOQK4ZpOPR for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 15:15:22 -0700 (PDT)
Date: Fri, 10 Aug 2012 08:15:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs warnings on kernel 3.2.15
Message-ID: <20120809221518.GW2877@dastard>
References: <1918987.4hlisJiio3@saturn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1918987.4hlisJiio3@saturn>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Aug 09, 2012 at 01:01:01PM +0200, Michael Monnerie wrote:
> I've noticed one of our postgresql servers having a high load, so I looked into it.
> Kernel = 3.2.15, disk space is free:
> 
> # df
> /dev/sda2              6281216    457888   5823328   8% /disks/work
> /dev/sdc1             52402180  10135176  42267004  20% /disks/pg-db
> 
> And I got these warnings since Jul 12 until today:
> 
> Jul 12 00:31:41 db24 kernel: XFS (sda2): xlog_space_left: head behind tail
> Jul 12 00:31:41 db24 kernel:  tail_cycle = 4, tail_bytes = 248320
> Jul 12 00:31:41 db24 kernel:  GH   cycle = 4, GH   bytes = 248312
> [snip]
> Aug  8 03:45:48 db24 kernel: XFS (sdc1): xlog_space_left: head behind tail
> Aug  8 03:45:48 db24 kernel:  tail_cycle = 607, tail_bytes = 21702144
> Aug  8 03:45:48 db24 kernel:  GH   cycle = 607, GH   bytes = 21701856
> 
> And this morning it changed into warnings:
> 
> Aug  9 10:34:57 db24 kernel: INFO: task vmtoolsd:1426 blocked for more than 120 seconds.
> Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug  9 10:34:57 db24 kernel: ffff880059e0fc78 0000000000000082 ffff880059af3ba0 0000000000000001
> Aug  9 10:34:57 db24 kernel: ffff880059e0e010 ffff880058ea5cc0 0000000000010940 ffff880059e0ffd8
> Aug  9 10:34:57 db24 kernel: ffff880059e0ffd8 0000000000010940 ffff880056264f80 ffff880058ea5cc0
> Aug  9 10:34:57 db24 kernel: Call Trace:
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136fb1e>] rwsem_down_failed_common+0xe4/0x116
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136fb63>] rwsem_down_write_failed+0x13/0x15
> Aug  9 10:34:57 db24 kernel: [<ffffffff811c4503>] call_rwsem_down_write_failed+0x13/0x20
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136f35c>] ? down_write+0x20/0x22
> Aug  9 10:34:57 db24 kernel: [<ffffffff810d1e44>] thaw_super+0x1c/0xae
> Aug  9 10:34:57 db24 kernel: [<ffffffff810f6b5e>] thaw_bdev+0x45/0x74
> Aug  9 10:34:57 db24 kernel: [<ffffffffa002019c>] VmSyncThawDevices+0x56/0x9e [vmsync]
> Aug  9 10:34:57 db24 kernel: [<ffffffffa0020542>] VmSyncUnlockedIoctl+0x1b4/0x208 [vmsync]
> Aug  9 10:34:57 db24 kernel: [<ffffffff81115dd1>] proc_reg_unlocked_ioctl+0x82/0xa1
> Aug  9 10:34:57 db24 kernel: [<ffffffff8102c05d>] ? pick_next_task_fair+0xfc/0x10c
> Aug  9 10:34:57 db24 kernel: [<ffffffffa002038e>] ? VmSyncAddPath+0xff/0xff [vmsync]
> Aug  9 10:34:57 db24 kernel: [<ffffffff810dcf9f>] do_vfs_ioctl+0x3f6/0x47b
> Aug  9 10:34:57 db24 kernel: [<ffffffff810dd066>] sys_ioctl+0x42/0x65
> Aug  9 10:34:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+0x16/0x1b

That's a filesystem thaw that is blocked that has com through, by
the looks of it, the VMWare kernel module. That will be completely
unrelated to the above log messages because.....

> Aug  9 10:34:57 db24 kernel: INFO: task flush-259:26214:19297 blocked for more than 120 seconds.
> Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug  9 10:34:57 db24 kernel: ffff880052039b10 0000000000000046 ffff880052039aa0 ffff880047536078
> Aug  9 10:34:57 db24 kernel: ffff880052038010 ffff880056263500 0000000000010940 ffff880052039fd8
> Aug  9 10:34:57 db24 kernel: ffff880052039fd8 0000000000010940 ffff880059620000 ffff880056263500
> Aug  9 10:34:57 db24 kernel: Call Trace:
> Aug  9 10:34:57 db24 kernel: [<ffffffff8104c605>] ? spin_unlock_irqrestore+0x9/0xb
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
> Aug  9 10:34:57 db24 kernel: [<ffffffff8118a64a>] xfs_trans_alloc+0x79/0xa7
> Aug  9 10:34:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x25
> Aug  9 10:34:57 db24 kernel: [<ffffffff8109180a>] ? generic_writepages+0x4b/0x57
> Aug  9 10:34:57 db24 kernel: [<ffffffff8115906b>] xfs_log_dirty_inode+0x2b/0x9f
> Aug  9 10:34:57 db24 kernel: [<ffffffff8115716d>] xfs_fs_write_inode+0x47/0x107
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ec01b>] writeback_single_inode+0x1b8/0x2ef
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ec705>] writeback_sb_inodes+0x168/0x201
> Aug  9 10:34:57 db24 kernel: [<ffffffff810eccfe>] __writeback_inodes_wb+0x6d/0xab
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ecea6>] wb_writeback+0xf1/0x18b
> Aug  9 10:34:57 db24 kernel: [<ffffffff8101f406>] ? default_spin_lock_flags+0x9/0xf
> Aug  9 10:34:57 db24 kernel: [<ffffffff8136fbc4>] ? _raw_spin_lock_irqsave+0x22/0x2b
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ed07f>] wb_do_writeback+0x13f/0x1a0
> Aug  9 10:34:57 db24 kernel: [<ffffffff8103fdbe>] ? del_timer+0x81/0x81
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ed170>] bdi_writeback_thread+0x90/0x164
> Aug  9 10:34:57 db24 kernel: [<ffffffff810ed0e0>] ? wb_do_writeback+0x1a0/0x1a0
> Aug  9 10:34:57 db24 kernel: [<ffffffff8104c17c>] kthread+0x7d/0x85
> Aug  9 10:34:57 db24 kernel: [<ffffffff81371eb4>] kernel_thread_helper+0x4/0x10
> Aug  9 10:34:57 db24 kernel: [<ffffffff8104c0ff>] ? kthread_worker_fn+0x153/0x153
> Aug  9 10:34:57 db24 kernel: [<ffffffff81371eb0>] ? gs_change+0x13/0x13

There's been a race in the the freeze and the writeback thread is
trying to write dirty inodes (which there shouldn't be any) and is
blocked waiting for the thaw to occur. Only problem is, the flusher
thread holds the s-umount lock in read, and the thaw is waiting for
it to be released. ABBA deadlock...

> This is a VMware VM, and I have no idea how to send SYS-T or
> similar keys to it.  I had to reset it (reboot hung), and
> everything worked again. This VM is now on kernel 3.5

The freeze/thaw deadlock is not fixed in 3.5 and i think it missed
3.6 as well so you're going to be waiting until 3.7 for this to be
fixed, I suspect....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
