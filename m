Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D8097F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:59:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09F97304093
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 06:59:45 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id mQxkmJioXaGl0b1y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 06:59:44 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Thu, 25 Jul 2013 07:38:20 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 0F134C4000F
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 07:32:50 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6PDcBil347388 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 07:38:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6PDcBtn005251
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 07:38:11 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH] xfs: fix an assertion failure
Date: Thu, 25 Jul 2013 21:38:44 +0800
Message-Id: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  When running the compilebench, one assertion failure was found.
This related line of code was introduced by commit 5f6bed76c0.

commit 5f6bed76c0c85cb4d04885a5de00b629deee550b
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:52 2013 +1000

    xfs: Introduce an ordered buffer item

[  500.464036] XFS: Assertion failed: !(bip->bli_item.li_flags & XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 942
[  500.465602] ------------[ cut here ]------------
[  500.466258] kernel BUG at fs/xfs/xfs_message.c:108!
[  500.466440] invalid opcode: 0000 [#1] SMP
[  500.466440] Modules linked in:
[  500.466440] CPU: 0 PID: 40 Comm: kworker/u2:1 Not tainted 3.11.0-rc2+ #955
[  500.466440] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  500.466440] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
[  500.466440] task: ffff880292260000 ti: ffff880292250000 task.ti: ffff880292250000
[  500.466440] RIP: 0010:[<ffffffff812dc6f2>]  [<ffffffff812dc6f2>] assfail+0x22/0x30
[  500.466440] RSP: 0018:ffff8802922515f8  EFLAGS: 00010292
[  500.466440] RAX: 0000000000000068 RBX: ffff880289b4a570 RCX: 0000000000000006
[  500.466440] RDX: 0000000000000006 RSI: ffff880292260788 RDI: ffff880292260000
[  500.466440] RBP: ffff8802922515f8 R08: 0000000000000000 R09: 0000000000000001
[  500.466440] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880291828000
[  500.466440] R13: ffff880289b4a570 R14: ffffffff81342aeb R15: ffff88025f344220
[  500.466440] FS:  0000000000000000(0000) GS:ffff88029fc00000(0000) knlGS:0000000000000000
[  500.466440] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  500.466440] CR2: 0000000009b01008 CR3: 0000000291874000 CR4: 00000000000006f0
[  500.466440] Stack:
[  500.466440]  ffff880292251628 ffffffff813428df ffff880289b4a570 0000000000000002
[  500.466440]  ffff880291828000 0000000000000001 ffff880292251668 ffffffff81342aeb
[  500.466440]  0000000000000000 ffff880289b4a570 ffff8802762070a0 ffffffffffffffff
[  500.466440] Call Trace:
[  500.466440]  [<ffffffff813428df>] xfs_buf_item_relse+0x4f/0xd0
[  500.466440]  [<ffffffff81342aeb>] xfs_buf_item_unlock+0x18b/0x1e0
[  500.466440]  [<ffffffff8133ac3d>] xfs_trans_free_items+0x7d/0xb0
[  500.466440]  [<ffffffff8133b35c>] xfs_trans_cancel+0x13c/0x1b0
[  500.466440]  [<ffffffff812d8d89>] xfs_iomap_write_allocate+0x249/0x350
[  500.466440]  [<ffffffff812c6af2>] xfs_map_blocks+0x2e2/0x350
[  500.466440]  [<ffffffff812c7a76>] xfs_vm_writepage+0x236/0x5e0
[  500.466440]  [<ffffffff8115174a>] __writepage+0x1a/0x50
[  500.466440]  [<ffffffff81152065>] write_cache_pages+0x225/0x4a0
[  500.466440]  [<ffffffff81151730>] ? mapping_tagged+0x20/0x20
[  500.466440]  [<ffffffff812c5e45>] ? xfs_vm_writepages+0x35/0x70
[  500.466440]  [<ffffffff8115232d>] generic_writepages+0x4d/0x70
[  500.466440]  [<ffffffff812c5e60>] xfs_vm_writepages+0x50/0x70
[  500.466440]  [<ffffffff81153cb1>] do_writepages+0x21/0x50
[  500.466440]  [<ffffffff811d4050>] __writeback_single_inode+0x40/0x230
[  500.466440]  [<ffffffff811d52b1>] writeback_sb_inodes+0x291/0x460
[  500.466440]  [<ffffffff811d551f>] __writeback_inodes_wb+0x9f/0xd0
[  500.466440]  [<ffffffff811d579b>] wb_writeback+0x24b/0x2e0
[  500.466440]  [<ffffffff8115185a>] ? global_dirtyable_memory+0x1a/0x60
[  500.466440]  [<ffffffff811d7386>] bdi_writeback_workfn+0x1d6/0x3d0
[  500.466440]  [<ffffffff8107734b>] process_one_work+0x1eb/0x4f0
[  500.466440]  [<ffffffff810772e9>] ? process_one_work+0x189/0x4f0
[  500.466440]  [<ffffffff81077adb>] worker_thread+0x11b/0x370
[  500.466440]  [<ffffffff810779c0>] ? rescuer_thread+0x330/0x330
[  500.466440]  [<ffffffff8107ff8a>] kthread+0xea/0xf0
[  500.466440]  [<ffffffff8107fea0>] ? flush_kthread_work+0x1b0/0x1b0
[  500.466440]  [<ffffffff818b6c5c>] ret_from_fork+0x7c/0xb0
[  500.466440]  [<ffffffff8107fea0>] ? flush_kthread_work+0x1b0/0x1b0
[  500.466440] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 48 b7 c7 81 48 89 fa 31 c0 48 89 e5 31 ff e8 de fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[  500.466440] RIP  [<ffffffff812dc6f2>] assfail+0x22/0x30
[  500.466440]  RSP <ffff8802922515f8>
[  500.510159] ---[ end trace 48b882d5f764ca11 ]---

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_buf_item.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index bfc4e0c..b4d42ae 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -939,7 +939,6 @@ xfs_buf_item_relse(
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 
 	bp->b_fspriv = bip->bli_item.li_bio_list;
 	if (bp->b_fspriv == NULL)
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
