Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q6O6WP048376 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 01:24:06 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 025D3122B60
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 23:25:22 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 9zqFnPT1WKgSZDG6
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 23:25:22 -0700 (PDT)
Message-ID: <4CC67450.9020602@profihost.ag>
Date: Tue, 26 Oct 2010 08:25:20 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
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
To: xfs@oss.sgi.com

Hi,

from time to time i'm getting a lot of strange errors like these:
[1217894.093015]
[1217894.150529] Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
[1217894.169930] Call Trace:
[1217894.189392]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.209515]  [<ffffffff8117bcb7>] ? xfs_da_do_buf+0x557/0x620
[1217894.229591]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.249969]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.269840]  [<ffffffff8117f43c>] ? 
xfs_dir2_block_lookup_int+0x45/0x197
[1217894.289755]  [<ffffffff8117f43c>] ? 
xfs_dir2_block_lookup_int+0x45/0x197
[1217894.309385]  [<ffffffff813755ed>] ? tcp_write_xmit+0x883/0x96c
[1217894.328966]  [<ffffffff8117f9c2>] ? xfs_dir2_block_lookup+0x18/0xb0
[1217894.348653]  [<ffffffff8117e71c>] ? xfs_dir_lookup+0xd5/0x147
[1217894.368696]  [<ffffffff811a11bd>] ? xfs_lookup+0x47/0xa3
[1217894.388523]  [<ffffffff811a90d1>] ? xfs_vn_lookup+0x3c/0x7b
[1217894.408019]  [<ffffffff810c1de7>] ? __lookup_hash+0xfa/0x11e
[1217894.427418]  [<ffffffff810c51a8>] ? do_filp_open+0x208/0x934
[1217894.446855]  [<ffffffff810c7242>] ? 
poll_select_copy_remaining+0xd0/0xf3
[1217894.466545]  [<ffffffff810cd62a>] ? alloc_fd+0x67/0x10b
[1217894.486469]  [<ffffffff810b8a60>] ? do_sys_open+0x55/0x103
[1217894.506529]  [<ffffffff8100ae6b>] ? system_call_fastpath+0x16/0x1b
[1217894.526534] ffff8803104df000: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00  ................
[1217894.546783] Filesystem "sdc3": XFS internal error xfs_da_do_buf(2) 
at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8117bdea
[1217894.546785]
[1217894.606014] Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
[1217894.626163] Call Trace:
[1217894.645625]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.665465]  [<ffffffff8117bcb7>] ? xfs_da_do_buf+0x557/0x620
[1217894.685302]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.705135]  [<ffffffff810c7442>] ? poll_freewait+0x3d/0x8a
[1217894.725179]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
[1217894.745439]  [<ffffffff8117f43c>] ? 
xfs_dir2_block_lookup_int+0x45/0x197
[1217894.765485]  [<ffffffff8117f43c>] ? 
xfs_dir2_block_lookup_int+0x45/0x197
[1217894.785179]  [<ffffffff8117f9c2>] ? xfs_dir2_block_lookup+0x18/0xb0
[1217894.805010]  [<ffffffff8117e71c>] ? xfs_dir_lookup+0xd5/0x147
[1217894.824879]  [<ffffffff811a11bd>] ? xfs_lookup+0x47/0xa3
[1217894.844689]  [<ffffffff811a90d1>] ? xfs_vn_lookup+0x3c/0x7b
[1217894.864661]  [<ffffffff810c1c0f>] ? do_lookup+0xd5/0x1b3
[1217894.884555]  [<ffffffff810c3d04>] ? __link_path_walk+0x8f5/0xda2
[1217894.904367]  [<ffffffff813368e3>] ? sock_aio_write+0xd6/0xe1
[1217894.924229]  [<ffffffff810c43df>] ? path_walk+0x66/0xcb
[1217894.944091]  [<ffffffff810c4512>] ? do_path_lookup+0x20/0x41
[1217894.963992]  [<ffffffff810c4e39>] ? user_path_at+0x48/0x7f
[1217894.984002]  [<ffffffff81053986>] ? autoremove_wake_function+0x0/0x2e
[1217895.004471]  [<ffffffff81059edd>] ? ktime_get_ts+0x68/0xb2
[1217895.024155]  [<ffffffff810bd518>] ? vfs_fstatat+0x2c/0x58
[1217895.042995]  [<ffffffff810bd6a8>] ? sys_newlstat+0x11/0x30
[1217895.061008]  [<ffffffff810baa7e>] ? vfs_write+0x134/0x169
[1217895.079137]  [<ffffffff810bab6f>] ? sys_write+0x45/0x6e
[1217895.096929]  [<ffffffff8100ae6b>] ? system_call_fastpath+0x16/0x1b
[1217895.115018] ffff8803104df000: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00  ................
[1217895.133667] Filesystem "sdc3": XFS internal error xfs_da_do_buf(2) 
at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8117bdea

I've already repaired the filesystem twice but i'm still getting these 
errors again.

Kernel: Vanilla 2.6.32.22

XFS Progs Debian Lenny: xfs_repair -V
xfs_repair version 2.9.8

Stfean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
