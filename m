Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbcKPMlz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:41:55 -0500
Date: Wed, 16 Nov 2016 07:41:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs hangup
Message-ID: <20161116124151.GA22991@bfoster.bfoster>
References: <80971623-820b-b53d-abdf-01ddbb742498@coreos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80971623-820b-b53d-abdf-01ddbb742498@coreos.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kyle Brown <kyle.brown@coreos.com>
Cc: linux-xfs@vger.kernel.org, luis.pabon@coreos.com

On Tue, Nov 15, 2016 at 05:01:15PM -0800, Kyle Brown wrote:
> Hello, 
> 
> Reaching out for advice as I am running into a problem where glusterfsd gets blocked due to an xfs hang up while writing to the underneath block device. The system often ends up with high load averages causing high latencies at the client side. Power cycling the node causes the filesystem to start recovery from journal.  Here is the stacktrace: 
> 

Log recovery is expected behavior if the power cycle is an unclean
shutdown of the fs. You will probably lose data, but the idea is that
the fs should remain consistent.

> ```
> [404917.204050] INFO: task glusterfsd:50485 blocked for more than 120 seconds.
> [404917.212111]       Not tainted 4.2.2-coreos-r2 #2

Custom kernel?

> [404917.217638] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [404917.226940] glusterfsd      D ffff88103f755340     0 50485  45406 0x00000080
> [404917.235222]  ffff881ce933bcf8 0000000000000086 ffff882038bd8000 ffff881f7d4fd640
> [404917.244098]  ffff881ce933bce8 ffff881ce933c000 ffff880c81c20b80 ffff880fcfb231c0
> [404917.253018]  0000000000020acc 0000000000000000 ffff881ce933bd18 ffffffff81527c87
> [404917.261986] Call Trace:
> [404917.265060]  [<ffffffff81527c87>] schedule+0x37/0x80
> [404917.270953]  [<ffffffffa051dda2>] uuid_equal+0x452/0x1690 [xfs]
> [404917.277943]  [<ffffffffa051df15>] uuid_equal+0x5c5/0x1690 [xfs]
> [404917.284922]  [<ffffffffa0521572>] xfs_log_reserve+0xb2/0x180 [xfs]
> [404917.292230]  [<ffffffffa051c413>] xfs_trans_reserve+0x173/0x1d0 [xfs]
> [404917.299818]  [<ffffffffa051c1fa>] ? _xfs_trans_alloc+0x3a/0xa0 [xfs]
> [404917.307283]  [<ffffffffa050ef75>] xfs_iomap_write_unwritten+0x545/0x10b0 [xfs]
> [404917.315995]  [<ffffffff811d9a78>] touch_atime+0x88/0xa0
> [404917.322193]  [<ffffffff811c333c>] SyS_readlink+0xdc/0x100
> [404917.328606]  [<ffffffff81021e93>] ? syscall_trace_leave+0x93/0xf0
> [404917.335810]  [<ffffffff8152bbae>] entry_SYSCALL_64_fastpath+0x12/0x71
> [404917.343347] INFO: task glusterfsd:71708 blocked for more than 120 seconds.
> [404917.351381]       Not tainted 4.2.2-coreos-r2 #2
> [404917.356905] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [404917.366264] glusterfsd      D ffff88203f075340     0 71708  45406 0x00000080
> [404917.374572]  ffff88001b36bbf8 0000000000000086 ffff88203801d640 ffff881ddae51cc0
> [404917.383484]  ffffffff00000000 ffff88001b36c000 ffff8810187f4170 ffff880fcfb231c0
> [404917.392381]  00000000000ed174 0000000000000034 ffff88001b36bc18 ffffffff81527c87
> [404917.401283] Call Trace:
> [404917.404337]  [<ffffffff81527c87>] schedule+0x37/0x80
> [404917.410265]  [<ffffffffa051dda2>] uuid_equal+0x452/0x1690 [xfs]
> [404917.417232]  [<ffffffffa051df15>] uuid_equal+0x5c5/0x1690 [xfs]
> [404917.424204]  [<ffffffffa0521572>] xfs_log_reserve+0xb2/0x180 [xfs]
> [404917.431463]  [<ffffffffa051c413>] xfs_trans_reserve+0x173/0x1d0 [xfs]
> [404917.439059]  [<ffffffffa051c1fa>] ? _xfs_trans_alloc+0x3a/0xa0 [xfs]
> [404917.446595]  [<ffffffffa0512a5c>] xfs_create+0x15c/0x5d0 [xfs]
> [404917.453493]  [<ffffffff81217fa9>] ? posix_acl_create+0x119/0x160
> [404917.460582]  [<ffffffffa050f89d>] xfs_iomap_write_unwritten+0xe6d/0x10b0 [xfs]
> [404917.469245]  [<ffffffffa050fa94>] xfs_iomap_write_unwritten+0x1064/0x10b0 [xfs]
> [404917.477996]  [<ffffffffa050fab6>] xfs_iomap_write_unwritten+0x1086/0x10b0 [xfs]
> [404917.486830]  [<ffffffff811c936b>] vfs_mkdir+0xbb/0x150
> [404917.492975]  [<ffffffff811ce47b>] SyS_mkdir+0x6b/0xc0
> [404917.498981]  [<ffffffff81021e93>] ? syscall_trace_leave+0x93/0xf0
> [404917.506130]  [<ffffffff8152bbae>] entry_SYSCALL_64_fastpath+0x12/0x71
> ```
> 

Both of these stacks look bogus. xfs_iomap_write_unwritten() implements
unwritten extent conversion, which has nothing to do with mkdir or
readlink operations. I'm also not sure where the uuid_equal() calls are
coming from. Perhaps you need to enable frame pointer
(CONFIG_FRAME_POINTER) support in your kernel config?

I'd suggest to resolve that first and foremost. If we take the top of
each stack at face value, both of these threads are waiting for log
reservation. The log is circular and thus a limited resource. Every
active transaction in the fs holds a reservation of some amount of space
in the log as it runs, and this space is either used to log the changes
being made (and thus released once those logged metadata items cycle
through the log infrastructure) or released back to the log for
subsequent transactions. The behavior you see here simply means that the
log is fully consumed and these threads are waiting for log space to
free up before they can proceed. The reason for the log space
consumption is not clear (high load? waiting on locks? slow I/O? etc.)
from the information provided. I'd suggest to take a look at the
following, particularly the bits about describing the workload in
question:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> 
> The hardware is a direct attached device with RAID level 0. The virtual device is built through hardware raid controller. HBA type is DELL PERC 317 mini. The command used to create the file system was: 
> 
> ```
> mkfs.xfs -i size=512 -n size=8192 -d su=64k,sw=4 /dev/sdb1
> ```
> 

See above. You'll want to include xfs_info for the filesystem as the
characteristics of the fs may differ depending on the version of mkfs
used to create the filesystem.

Brian

> 
> Kernel version is 4.2.2. No kernel tuning has been attempted at this time. Any suggestions to tune or provide additional details to debug xfs would be greatly appreciated. 
> 
> 
> 
> Cheers,
> 
> Kyle Brown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
