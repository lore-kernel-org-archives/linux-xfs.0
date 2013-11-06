Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A56BF7F94
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 02:58:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37D84AC007
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 00:58:35 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2IZOav6cq59AdDcu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 00:58:34 -0800 (PST)
From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] Btrfs: fix lockdep error in async commit
Date: Wed,  6 Nov 2013 16:57:55 +0800
Message-Id: <1383728275-28832-1-git-send-email-bo.li.liu@oracle.com>
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
To: linux-btrfs@vger.kernel.org
Cc: majianpeng@gmail.com, Miao Xie <miaox@cn.fujitsu.com>, xfs@oss.sgi.com

Lockdep complains about btrfs's async commit:

[ 2372.462171] [ BUG: bad unlock balance detected! ]
[ 2372.462191] 3.12.0+ #32 Tainted: G        W
[ 2372.462209] -------------------------------------
[ 2372.462228] ceph-osd/14048 is trying to release lock (sb_internal) at:
[ 2372.462275] [<ffffffffa022cb10>] btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462305] but there are no more locks to release!
[ 2372.462324]
[ 2372.462324] other info that might help us debug this:
[ 2372.462349] no locks held by ceph-osd/14048.
[ 2372.462367]
[ 2372.462367] stack backtrace:
[ 2372.462386] CPU: 2 PID: 14048 Comm: ceph-osd Tainted: G        W    3.12.0+ #32
[ 2372.462414] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
[ 2372.462455]  ffffffffa022cb10 ffff88007490fd28 ffffffff816f094a ffff8800378aa320
[ 2372.462491]  ffff88007490fd50 ffffffff810adf4c ffff8800378aa320 ffff88009af97650
[ 2372.462526]  ffffffffa022cb10 ffff88007490fd88 ffffffff810b01ee ffff8800898c0000
[ 2372.462562] Call Trace:
[ 2372.462584]  [<ffffffffa022cb10>] ? btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462619]  [<ffffffff816f094a>] dump_stack+0x45/0x56
[ 2372.462642]  [<ffffffff810adf4c>] print_unlock_imbalance_bug+0xec/0x100
[ 2372.462677]  [<ffffffffa022cb10>] ? btrfs_commit_transaction_async+0x1b0/0x2a0 [btrfs]
[ 2372.462710]  [<ffffffff810b01ee>] lock_release+0x18e/0x210
[ 2372.462742]  [<ffffffffa022cb36>] btrfs_commit_transaction_async+0x1d6/0x2a0 [btrfs]
[ 2372.462783]  [<ffffffffa025a7ce>] btrfs_ioctl_start_sync+0x3e/0xc0 [btrfs]
[ 2372.462822]  [<ffffffffa025f1d3>] btrfs_ioctl+0x4c3/0x1f70 [btrfs]
[ 2372.462849]  [<ffffffff812c0321>] ? avc_has_perm+0x121/0x1b0
[ 2372.462873]  [<ffffffff812c0224>] ? avc_has_perm+0x24/0x1b0
[ 2372.462897]  [<ffffffff8107ecc8>] ? sched_clock_cpu+0xa8/0x100
[ 2372.462922]  [<ffffffff8117b145>] do_vfs_ioctl+0x2e5/0x4e0
[ 2372.462946]  [<ffffffff812c19e6>] ? file_has_perm+0x86/0xa0
[ 2372.462969]  [<ffffffff8117b3c1>] SyS_ioctl+0x81/0xa0
[ 2372.462991]  [<ffffffff817045a4>] tracesys+0xdd/0xe2
====================================================

It's because that we don't do the right thing when checking if it's ok to
tell lockdep that we're trying to release the rwsem.

If the trans handle's type is TRANS_ATTACH, we won't acquire the freeze rwsem, but
as TRANS_ATTACH fits the check (trans < TRANS_JOIN_NOLOCK), we'll release the freeze
rwsem, which makes lockdep complains a lot.

Reported-by: Ma Jianpeng <majianpeng@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8c81bdc..c094f08 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1453,7 +1453,7 @@ static void do_async_commit(struct work_struct *work)
 	 * We've got freeze protection passed with the transaction.
 	 * Tell lockdep about it.
 	 */
-	if (ac->newtrans->type < TRANS_JOIN_NOLOCK)
+	if (ac->newtrans->type & __TRANS_FREEZABLE)
 		rwsem_acquire_read(
 		     &ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 		     0, 1, _THIS_IP_);
@@ -1494,7 +1494,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	 * Tell lockdep we've released the freeze rwsem, since the
 	 * async commit thread will be the one to unlock it.
 	 */
-	if (trans->type < TRANS_JOIN_NOLOCK)
+	if (ac->newtrans->type & __TRANS_FREEZABLE)
 		rwsem_release(
 			&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 			1, _THIS_IP_);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
