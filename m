Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8011EC77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 03:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbjDUDtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 23:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjDUDsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 23:48:40 -0400
X-Greylist: delayed 972 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Apr 2023 20:48:20 PDT
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CDA44A1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 20:48:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2fwS55w2z9xFGZ
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 11:22:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwC35oCgA0JkJLD+BQ--.17472S3;
        Fri, 21 Apr 2023 03:31:52 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH 1/3] xfs: fix leak memory when xfs_attr_inactive fails
Date:   Fri, 21 Apr 2023 11:31:40 +0800
Message-Id: <20230421033142.1656296-2-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421033142.1656296-1-guoxuenan@huawei.com>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwC35oCgA0JkJLD+BQ--.17472S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFyxJFyUKrW7Xw1xuFW5trb_yoWxCFWDpr
        9rGr1DKr4ktryjkr48Aw1jgw18tF4xCa1UJr1xZr1xA3WUCw1xtryktr48JryUJr40v3sF
        gr4DJw4IqwsxJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUH0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
        JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6x
        kF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxAIw28I
        cVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85DG5UUUUU==
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I observed the following evidence of a leak while xfs_inactive failed.
Especially in Debug mode, when xfs_attr_inactive failed, current exception
path handling rudely clear inode attr fork, and if the inode is recycled
then assertion will accur, if not, which may also lead to memory leak.

Since xfs_attr_inactive is supposed to clean up the attribute fork when
the inode is being freed. While it removes the in-memory attribute fork
even in the event of truncate attribute fork extents failure, then some
attr data may left in memory and never be released. By avoiding this kind
of clean up and readding the inode to the gclist, this type of problems can
be solved to some extent.

The following script reliably replays the bug described above.
```
#!/bin/bash
DISK=vdb
MP=/mnt/$DISK
DEV=/dev/$DISK
nfiles=10
xattr_val="this is xattr value."
## prepare and mount
while true
do
	pidof fsstress | xargs kill -9
	umount $MP
	df | grep $MP || break
	sleep 2
done

mkdir -p ${MP} && mkfs.xfs -f $DEV && mount $DEV $MP
echo 0 > /sys/fs/xfs/$DISK/errortag/bmapifmt

## create files, setxattr, remove files
cd $MP; touch $(seq 1 $nfiles); cd $OLDPWD
for n in `seq 1 $nfiles`; do
	for j in `seq 1 20`; do
		setfattr -n user.${j} -v "$xattr_val" $MP/$n
	done
done
## inject fault & trigger fails
fsstress -d $MP -z -f bulkstat=200 -S c -l 1000 -p 8 &
/usr/bin/rm $MP/*
echo 3 > /sys/fs/xfs/$DISK/errortag/bmapifmt
```

Assertion in the kernel log as follows:

XFS (vdb): Mounting V5 Filesystem bd1b6c38-599a-43b3-8194-a584bebec4ca
XFS (vdb): Ending clean mount
xfs filesystem being mounted at /mnt/vdb supports timestamps until 2038 (0x7fffffff)
XFS (vdb): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "vdb"
XFS: Assertion failed: ip->i_nblocks == 0, file: fs/xfs/xfs_inode.c, line: 2277
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 3 PID: 74 Comm: kworker/3:1 Not tainted 6.3.0-rc6-00127-g71deb8a5658c #569
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
Workqueue: xfs-inodegc/vdb xfs_inodegc_worker
RIP: 0010:assfail+0x8c/0x90
Code: 80 3d 37 27 3b 0a 00 75 1c e8 a0 b0 20 ff 0f 0b 5b 5d 41 5c 41 5d c3
48 c7 c7 30 25 64 8c e8 fb d8 66 ff eb db e8 84 b0 20 ff <0f> 0b 66 90 0f
1f 44 00 00 55 48 89 fd 53 48 63 de e8 6e b0 20 ff
RSP: 0018:ffff888101b17b20 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff8444eea0 RCX: 0000000000000000
RDX: ffff888101b08040 RSI: ffffffff8228fe1c RDI: ffffffff844510c0
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff888101b177ff
R10: ffffed1020362eff R11: 0000000000000001 R12: ffffffff8444f720
R13: 00000000000008e5 R14: ffff888155279800 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8883edd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001612e18 CR3: 000000017bab5005 CR4: 0000000000770ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 xfs_ifree+0xea6/0x1310
 xfs_inactive_ifree.isra.0+0x1ab/0x460
 xfs_inactive+0x41f/0x710
 xfs_inodegc_worker+0x22e/0x500
 process_one_work+0x6d1/0xfe0
 worker_thread+0x5b9/0xf60
 kthread+0x287/0x330
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:assfail+0x8c/0x90
Code: 80 3d 37 27 3b 0a 00 75 1c e8 a0 b0 20 ff 0f 0b 5b 5d 41 5c 41 5d c3
48 c7 c7 30 25 64 8c e8 fb d8 66 ff eb db e8 84 b0 20 ff <0f> 0b 66 90 0f
1f 44 00 00 55 48 89 fd 53 48 63 de e8 6e b0 20 ff
RSP: 0018:ffff888101b17b20 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff8444eea0 RCX: 0000000000000000
RDX: ffff888101b08040 RSI: ffffffff8228fe1c RDI: ffffffff844510c0
RBP: 0000000000000000 R08: 0000000000000001 R09: ffff888101b177ff
R10: ffffed1020362eff R11: 0000000000000001 R12: ffffffff8444f720
R13: 00000000000008e5 R14: ffff888155279800 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8883edd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001612e18 CR3: 000000017bab5005 CR4: 0000000000770ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554

Fixes: 6dfe5a049f2d ("xfs: xfs_attr_inactive leaves inconsistent attr fork state behind")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/xfs_attr_inactive.c | 16 +++++++++-------
 fs/xfs/xfs_icache.c        |  6 +++++-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5db87b34fb6e..a7379beb355a 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -336,21 +336,25 @@ xfs_attr_inactive(
 	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
 	xfs_ilock(dp, lock_mode);
-	if (!xfs_inode_has_attr_fork(dp))
-		goto out_destroy_fork;
+	if (!xfs_inode_has_attr_fork(dp)) {
+		xfs_ifork_zap_attr(dp);
+		goto out_unlock;
+	}
 	xfs_iunlock(dp, lock_mode);
 
 	lock_mode = 0;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrinval, 0, 0, 0, &trans);
 	if (error)
-		goto out_destroy_fork;
+		goto out_unlock;
 
 	lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(dp, lock_mode);
 
-	if (!xfs_inode_has_attr_fork(dp))
+	if (!xfs_inode_has_attr_fork(dp)) {
+		xfs_ifork_zap_attr(dp);
 		goto out_cancel;
+	}
 
 	/*
 	 * No need to make quota reservations here. We expect to release some
@@ -383,9 +387,7 @@ xfs_attr_inactive(
 
 out_cancel:
 	xfs_trans_cancel(trans);
-out_destroy_fork:
-	/* kill the in-core attr fork before we drop the inode lock */
-	xfs_ifork_zap_attr(dp);
+out_unlock:
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
 	return error;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 351849fc18ff..4afa7fec4a2f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -48,6 +48,7 @@ static int xfs_icwalk(struct xfs_mount *mp,
 		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
 		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
+static void xfs_inodegc_queue(struct xfs_inode	*ip);
 
 /*
  * Private inode cache walk flags for struct xfs_icwalk.  Must not
@@ -1843,7 +1844,10 @@ xfs_inodegc_inactivate(
 {
 	trace_xfs_inode_inactivating(ip);
 	xfs_inactive(ip);
-	xfs_inodegc_set_reclaimable(ip);
+	if (VFS_I(ip)->i_mode != 0)
+		xfs_inodegc_queue(ip);
+	else
+		xfs_inodegc_set_reclaimable(ip);
 }
 
 void
-- 
2.31.1

