Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n788cfJG189578 for <xfs@oss.sgi.com>; Sat, 8 Aug 2009 03:38:41 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D7A81B1617A
	for <xfs@oss.sgi.com>; Sat,  8 Aug 2009 01:39:32 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id DwxAtK788Uj0dwgo for
	<xfs@oss.sgi.com>; Sat, 08 Aug 2009 01:39:32 -0700 (PDT)
Date: Sat, 8 Aug 2009 04:39:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Kernel 2.6.30.4 XFS(..?) regression
Message-ID: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

After a period of read/writes to several drives, all processes that 
try to write to the drives (all XFS) enter D-state and the system becomes 
unresponsive, the load shoots up to > 100, etc.

This problem did not occur with 2.6.29.1.

Here is a part of the sysrq-w:

[72037.131620] sh            D 00000006     0 13772  13771
[72037.131620]  00000000 00000086 c811f4c0 00000006 c94c9011 c3606da0 c1433e88 cf596ab4
[72037.131620]  ca6a9524 ca6a9524 c1433e70 c02750f0 c03e72e5 c03e85fd ca6a9528 c811f4c0
[72037.131620]  c94c9018 ca6a9524 00000000 c4d70a20 c02750f0 c03e873a ca6a9528 ccccbe70
[72037.131620] Call Trace:
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e72e5>] ? schedule+0x5/0x20
[72037.131620]  [<c03e85fd>] ? rwsem_down_failed_common+0x7d/0x170
[72037.131620]  [<c02750f0>] ? xfs_dir_open+0x0/0x70
[72037.131620]  [<c03e873a>] ? rwsem_down_read_failed+0x1a/0x24
[72037.131620]  [<c03e874b>] ? call_rwsem_down_read_failed+0x7/0xc
[72037.131620]  [<c03e7d29>] ? down_read+0x9/0x10
[72037.131620]  [<c0250e36>] ? xfs_ilock_map_shared+0x16/0x40
[72037.131620]  [<c027512d>] ? xfs_dir_open+0x3d/0x70
[72037.131620]  [<c0162289>] ? __dentry_open+0x89/0x240
[72037.131620]  [<c0162533>] ? nameidata_to_filp+0x53/0x70
[72037.131620]  [<c016e605>] ? do_filp_open+0x245/0x830
[72037.131620]  [<c0151ed1>] ? __do_fault+0x2b1/0x3d0
[72037.131620]  [<c016208b>] ? do_sys_open+0x5b/0x110
[72037.131620]  [<c01621bc>] ? sys_open+0x2c/0x40
[72037.131620]  [<c0102c48>] ? sysenter_do_call+0x12/0x26

Here is a part of the sysrq-t: (after dmesg > dmesg.txt)

[72119.690410] dmesg         D c769c720     0 13832  13824
[72119.690410]  00000000 00000086 c4d0e7c0 c769c720 c3237260 cc6ad2a0 cfa47200 c017cb26
[72119.690410]  00000286 044805f1 c5d6bd18 0448058d c03e72e5 c03e74a0 00004000 c053f2e0
[72119.690410]  c14c3d18 c6457d18 044805f1 c0124de0 c4d0e7c0 c053c7c0 c049f170 00000064
[72119.690410] Call Trace:
[72119.690410]  [<c017cb26>] ? __writeback_single_inode+0x126/0x380
[72119.690410]  [<c03e72e5>] ? schedule+0x5/0x20
[72119.690410]  [<c03e74a0>] ? schedule_timeout+0xb0/0x110
[72119.690410]  [<c0124de0>] ? process_timeout+0x0/0x10
[72119.690410]  [<c03e6d71>] ? io_schedule_timeout+0x11/0x20
[72119.690410]  [<c0150b83>] ? congestion_wait+0x53/0x70
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0147c10>] ? balance_dirty_pages_ratelimited_nr+0xb0/0x1e0
[72119.690410]  [<c0142021>] ? generic_file_buffered_write+0x1a1/0x300
[72119.690410]  [<c02791ea>] ? xfs_write+0x77a/0x860
[72119.690410]  [<c0134e54>] ? getnstimeofday+0x54/0x110
[72119.690410]  [<c0275361>] ? xfs_file_aio_write+0x61/0x70
[72119.690410]  [<c0163c15>] ? do_sync_write+0xd5/0x120
[72119.690410]  [<c0117958>] ? task_tick_fair+0x18/0x90
[72119.690410]  [<c013815f>] ? tick_handle_periodic+0xf/0x80
[72119.690410]  [<c012dbe0>] ? autoremove_wake_function+0x0/0x50
[72119.690410]  [<c0163b40>] ? do_sync_write+0x0/0x120
[72119.690410]  [<c0164750>] ? vfs_write+0xa0/0x140
[72119.690410]  [<c01648c1>] ? sys_write+0x41/0x80
[72119.690410]  [<c0102c48>] ? sysenter_do_call+0x12/0x26

Kernel .config:
http://home.comcast.net/~jpiszcz/20090808/config-2.6.30.4.txt

The only way to bring the host back is to reboot the system b to 
sysrq-trigger or hard reboot.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
