Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AAA17C22F;
	Thu, 10 Oct 2024 09:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728552168; cv=none; b=hQj67QX2kjGif766tppqRNbbdmICEf0qXn7pGhwAyotGP3/6I1yFfHH3kLsL3u5JXNbuDSxY66iUE+nvmJkozkUTYPUkpwiSVYy/pFvAAUUXUhLoense0oxgnK3hn9jCfmnjSG0RcVP5W6XZrpB8aPj2J39Jmm8cv1sY/eBMSm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728552168; c=relaxed/simple;
	bh=OKVUD5pQ8K5rzajDUHl4Uc/nZWbMTC5CIfO3E51a058=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qkJwWnfjqToSFroCSsHcwCBdd2BbL5cItSwI0C+bi1cUfyis8HCM/mZ4sMgjvoQltqcJyCv9C6kvo0dBWDQXXZs+ih7gADZ4XVmspM0V/tbB2+BFpeoMS3APCjSYUwsj3F1dSM7Nj+G2U2x8hQ3T7tp6bLHnW0TuLprEwGg0FJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XPPRV3R8Pz4f3m86;
	Thu, 10 Oct 2024 17:22:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 45FE51A0359;
	Thu, 10 Oct 2024 17:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sbgnAdntDrIDg--.34168S4;
	Thu, 10 Oct 2024 17:22:42 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	dchinner@redhat.com
Cc: linux-kernel@vger.kernel.org,
	yebin10@huawei.com,
	zhangxiaoxu5@huawei.com
Subject: [PATCH] xfs: fix use-after-free in xfs_cui_release()
Date: Thu, 10 Oct 2024 17:37:15 +0800
Message-Id: <20241010093715.1505534-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sbgnAdntDrIDg--.34168S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGFW5XF48Ar45Kr18Cw1DAwb_yoWrGFW7pr
	97ArWxCr1kCFy0kFsakF45tFy8JFWYvwnFvrnagF13Xas8tr4jgFy3t3W0gryUWF40va1j
	vFn7Jr98Xw1Ygw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF
	7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's issue as follows when do IO fault injection:
 XFS (loop0): Filesystem has been shut down due to log error (0x2).
 XFS (loop0): Please unmount the filesystem and rectify the problem(s).
 XFS (loop0): Failed to recover intents
 XFS (loop0): log mount finish failed
 ==================================================================
 BUG: KASAN: slab-use-after-free in xfs_cui_release+0x20/0xe0
 Read of size 4 at addr ffff88826d204098 by task kworker/u18:4/252

 CPU: 7 PID: 252 Comm: kworker/u18:4 Not tainted 6.3.0-next #446
 Workqueue: xfs-cil/loop0 xlog_cil_push_work
 Call Trace:
  <TASK>
  dump_stack_lvl+0xd9/0x150
  print_report+0xc1/0x5e0
  kasan_report+0x96/0xc0
  kasan_check_range+0x13f/0x1a0
  xfs_cui_release+0x20/0xe0
  xfs_cud_item_release+0x37/0x80
  xfs_trans_committed_bulk+0x337/0x8f0
  xlog_cil_committed+0xc08/0x1010
  xlog_cil_push_work+0x1cb4/0x25f0
  process_one_work+0x9cf/0x1610
  worker_thread+0x63a/0x10a0
  kthread+0x343/0x440
  ret_from_fork+0x1f/0x30
  </TASK>

 Allocated by task 8537:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  __kasan_slab_alloc+0x7f/0x90
  slab_post_alloc_hook+0x65/0x560
  kmem_cache_alloc+0x1cf/0x440
  xfs_cui_init+0x1a8/0x1e0
  xlog_recover_cui_commit_pass2+0x137/0x440
  xlog_recover_items_pass2+0xd8/0x310
  xlog_recover_commit_trans+0x958/0xb20
  xlog_recovery_process_trans+0x13a/0x1e0
  xlog_recover_process_ophdr+0x1e9/0x410
  xlog_recover_process_data+0x19c/0x400
  xlog_recover_process+0x257/0x2e0
  xlog_do_recovery_pass+0x70c/0xf90
  xlog_do_log_recovery+0x9e/0x100
  xlog_do_recover+0xdf/0x5a0
  xlog_recover+0x2a8/0x500
  xfs_log_mount+0x36e/0x790
  xfs_mountfs+0x133a/0x2220
  xfs_fs_fill_super+0x1376/0x1f10
  get_tree_bdev+0x44a/0x770
  vfs_get_tree+0x8d/0x350
  path_mount+0x1228/0x1cc0
  do_mount+0xf7/0x110
  __x64_sys_mount+0x193/0x230
  do_syscall_64+0x39/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

 Freed by task 8537:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  kasan_save_free_info+0x2e/0x40
  __kasan_slab_free+0x11f/0x1b0
  kmem_cache_free+0xf2/0x670
  xfs_cui_item_free+0xa4/0xc0
  xfs_cui_release+0xa0/0xe0
  xlog_recover_cancel_intents.isra.0+0xf4/0x200
  xlog_recover_finish+0x87f/0xa20
  xfs_log_mount_finish+0x325/0x570
  xfs_mountfs+0x16ba/0x2220
  xfs_fs_fill_super+0x1376/0x1f10
  get_tree_bdev+0x44a/0x770
  vfs_get_tree+0x8d/0x350
  path_mount+0x1228/0x1cc0
  do_mount+0xf7/0x110
  __x64_sys_mount+0x193/0x230
  do_syscall_64+0x39/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

As xlog_recover_process_intents() failed will trigger LOG shutdown will not
push CIL. Then xlog_recover_finish() will remove log item from AIL list and
release log item. However xlog_cil_push_work() perhaps concurrent
processing this log item, then trigger UAF.
To solve above issue, there's need to make sure all CIL is pushed before
cancel intent item.

Fixes: deb4cd8ba87f ("xfs: transfer recovered intent item ownership in ->iop_recover")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1997981827fb..54faa0608958 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3521,6 +3521,7 @@ xlog_recover_finish(
 		 * (inode reclaim does this) before we get around to
 		 * xfs_log_mount_cancel.
 		 */
+		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 		xlog_recover_cancel_intents(log);
 		xfs_alert(log->l_mp, "Failed to recover intents");
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-- 
2.31.1

