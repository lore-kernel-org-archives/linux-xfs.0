Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GDYPij213457 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 08:34:25 -0500
Received: from mail.hq.newdream.net (mail.hq.newdream.net [66.33.206.127]) by
	cuda.sgi.com with ESMTP id Z8DGUqenCi9sqxkj for
	<xfs@oss.sgi.com>; Mon, 16 Apr 2012 06:34:24 -0700 (PDT)
Received: from mail.hq.newdream.net (localhost [127.0.0.1])
	by mail.hq.newdream.net (Postfix) with ESMTP id EC6672441F
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 06:37:17 -0700 (PDT)
Received: from [172.22.22.4] (c-71-195-31-37.hsd1.mn.comcast.net
	[71.195.31.37])
	by mail.hq.newdream.net (Postfix) with ESMTPSA id 8BA2724237
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 06:37:17 -0700 (PDT)
Message-ID: <4F8C1FDD.70600@dreamhost.com>
Date: Mon, 16 Apr 2012 08:34:21 -0500
From: Alex Elder <elder@dreamhost.com>
MIME-Version: 1.0
Subject: BUG: task blocked on waiter in xfs_trans_dqlockedjoin()
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

I am getting the following warning while running xfstests.  I haven't
started looking at it closely yet, but I wanted to report it so others
could have a look.  The XFS code in use was at commit c922bbc819,
with ad637a10f4 cherry-picked on top of it.  The tests all passed,
so now I'm going to have to narrow down which test produces the failure
(it was not near the first, nor the last test...).

Here is the source of the warning:
         DEBUG_LOCKS_WARN_ON(ti->task->blocked_on != waiter);

In this function:
void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
                          struct thread_info *ti)
{
         DEBUG_LOCKS_WARN_ON(list_empty(&waiter->list));
         DEBUG_LOCKS_WARN_ON(waiter->task != ti->task);
         DEBUG_LOCKS_WARN_ON(ti->task->blocked_on != waiter);
         ti->task->blocked_on = NULL;

         list_del_init(&waiter->list);
         waiter->task = NULL;
}

called (eventually) via xfs_dqlock2() in this function:

STATIC void
xfs_trans_dqlockedjoin(
         xfs_trans_t     *tp,
         xfs_dqtrx_t     *q)
{
         ASSERT(q[0].qt_dquot != NULL);
         if (q[1].qt_dquot == NULL) {
                 xfs_dqlock(q[0].qt_dquot);
                 xfs_trans_dqjoin(tp, q[0].qt_dquot);
         } else {
                 ASSERT(XFS_QM_TRANS_MAXDQS == 2);
                 xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
                 xfs_trans_dqjoin(tp, q[0].qt_dquot);
                 xfs_trans_dqjoin(tp, q[1].qt_dquot);
         }
}


					-Alex

------------[ cut here ]------------
WARNING: at 
/srv/autobuild-ceph/gitbuilder.git/build/kernel/mutex-debug.c:65 
mutex_remove_waiter+0x93/0x130()
Hardware name: PowerEdge R410
Modules linked in: rbd libceph aesni_intel cryptd aes_x86_64 aes_generic 
ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs 
ipmi_devintf ipmi_si ipmi_msghandler i7core_edac edac_core joydev hed 
serio_raw dcdbas lp parport usbhid hid mptsas ixgbe mptscsih mptbase dca 
mdio scsi_transport_sas bnx2 btrfs zlib_deflate crc32c libcrc32c [last 
unloaded: libceph]
Pid: 5947, comm: kworker/0:4 Not tainted 3.3.0-ceph-00067-gafede88 #1
Call Trace:
  [<ffffffff8104e42f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8104e48a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810a59f3>] mutex_remove_waiter+0x93/0x130
  [<ffffffff8161309c>] __mutex_lock_common+0x24c/0x3d0
  [<ffffffffa0293a4f>] ? xfs_trans_dqlockedjoin+0x5f/0x70 [xfs]
  [<ffffffffa0293a4f>] ? xfs_trans_dqlockedjoin+0x5f/0x70 [xfs]
  [<ffffffff81613347>] mutex_lock_nested+0x37/0x50
  [<ffffffffa0293a4f>] xfs_trans_dqlockedjoin+0x5f/0x70 [xfs]
  [<ffffffffa0293aa5>] xfs_trans_apply_dquot_deltas+0x45/0x290 [xfs]
  [<ffffffffa0287257>] xfs_trans_commit+0x67/0x270 [xfs]
  [<ffffffffa023e52b>] xfs_iomap_write_allocate+0x16b/0x380 [xfs]
  [<ffffffffa0232575>] xfs_map_blocks+0x165/0x240 [xfs]
  [<ffffffffa02327ef>] xfs_vm_writepage+0x19f/0x500 [xfs]
  [<ffffffff8112990a>] __writepage+0x1a/0x50
  [<ffffffff8112b66e>] write_cache_pages+0x24e/0x4e0
  [<ffffffff8130e01f>] ? cfq_dispatch_requests+0x18f/0xc10
  [<ffffffff811298f0>] ? set_page_dirty+0x70/0x70
  [<ffffffff8112b954>] generic_writepages+0x54/0x80
  [<ffffffffa02311bc>] xfs_vm_writepages+0x5c/0x80 [xfs]
  [<ffffffff8112b9a4>] do_writepages+0x24/0x40
  [<ffffffff81120b4b>] __filemap_fdatawrite_range+0x5b/0x60
  [<ffffffff81120e23>] filemap_fdatawrite_range+0x13/0x20
  [<ffffffffa023a818>] xfs_flush_pages+0x78/0xc0 [xfs]
  [<ffffffffa0245416>] xfs_sync_inode_data+0x86/0xb0 [xfs]
  [<ffffffffa0245a7e>] xfs_inode_ag_walk+0x20e/0x370 [xfs]
  [<ffffffffa0245b5b>] ? xfs_inode_ag_walk+0x2eb/0x370 [xfs]
  [<ffffffffa0245390>] ? xfs_sync_worker+0x90/0x90 [xfs]
  [<ffffffffa0245390>] ? xfs_sync_worker+0x90/0x90 [xfs]
  [<ffffffffa0245c25>] xfs_inode_ag_iterator+0x45/0xa0 [xfs]
  [<ffffffffa0245ca9>] xfs_sync_data+0x29/0x50 [xfs]
  [<ffffffffa0245cf2>] xfs_flush_worker+0x22/0x40 [xfs]
  [<ffffffff8106b256>] process_one_work+0x1a6/0x520
  [<ffffffff8106b1e7>] ? process_one_work+0x137/0x520
  [<ffffffffa0245cd0>] ? xfs_sync_data+0x50/0x50 [xfs]
  [<ffffffff8106d71e>] worker_thread+0x2fe/0x400
  [<ffffffff8106d420>] ? manage_workers+0x210/0x210
  [<ffffffff8107280e>] kthread+0xbe/0xd0
  [<ffffffff8161f5f4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81616134>] ? retint_restore_args+0x13/0x13
  [<ffffffff81072750>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8161f5f0>] ? gs_change+0x13/0x13
---[ end trace d27597ce9ccb8690 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
