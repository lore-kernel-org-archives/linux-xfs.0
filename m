Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827861DFEF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705494540; cv=none; b=IlYsmGgQL02VimK3Xm50wbP3UNeqvT41LpmQahYfOUts6n9Xc6+4Uv5Pex3JKzewBLbBvDHNgqc42STg1JuQWwo6bvqRkHSPsUWC8xle5rRd/Lwg9a6Pkc4bVNtUzYxsR31WjFyI9CD5X+1nwanuNS+kh0o5W/Ou5y/KPowsfkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705494540; c=relaxed/simple;
	bh=35nW1seTagmK2KmWgXhi6RB6udoMX962KCFpuO5ck+I=;
	h=Received:Received:Received:From:To:CC:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Originating-IP:X-ClientProxiedBy; b=cAqtPBHY1SVK9M3m4MCVgmcSKjJXkVlXENl4pqyYFm7UXMbI1ajIIjfk5I5BQewcL0S/Llqk/O6yl084MP1Wzwlm1qs14fjZs9X5t6CMNc3Vm1NE1TWjJkpvSYh33mRg9rNCRZknUXlRp6XagoddMjOcPcmhqGXYj25df6upnaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TFQCP1MP4zGpyg;
	Wed, 17 Jan 2024 20:28:33 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0EBD71800BF;
	Wed, 17 Jan 2024 20:28:53 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 20:28:52 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2] xfs: ensure submit buffers on LSN boundaries in error handlers
Date: Wed, 17 Jan 2024 20:31:26 +0800
Message-ID: <20240117123126.2019059-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)

While performing the IO fault injection test, I caught the following data
corruption report:

 XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
 CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
 Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  xfs_free_ag_extent+0x7d3/0x1130
  __xfs_free_extent+0x201/0x3c0
  xfs_trans_free_extent+0x29b/0xa10
  xfs_extent_free_finish_item+0x2a/0xb0
  xfs_defer_finish_noroll+0x8d1/0x1b40
  xfs_defer_finish+0x21/0x200
  xfs_itruncate_extents_flags+0x1cb/0x650
  xfs_free_eofblocks+0x18f/0x250
  xfs_inactive+0x485/0x570
  xfs_inodegc_worker+0x207/0x530
  process_scheduled_works+0x24a/0xe10
  worker_thread+0x5ac/0xc60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x4a/0x80
  ret_from_fork_asm+0x11/0x20
  </TASK>
 XFS (dm-0): Corruption detected. Unmount and run xfs_repair

After analyzing the disk image, it was found that the corruption was
triggered by the fact that extent was recorded in both inode datafork
and AGF btree blocks. After a long time of reproduction and analysis,
we found that the reason of free sapce btree corruption was that the
AGF btree was not recovered correctly.

Consider the following situation, Checkpoint A and Checkpoint B are in
the same record and share the same start LSN1, buf items of same object
(AGF btree block) is included in both Checkpoint A and Checkpoint B. If
the buf item in Checkpoint A has been recovered and updates metadata LSN
permanently, then the buf item in Checkpoint B cannot be recovered,
because log recovery skips items with a metadata LSN >= the current LSN
of the recovery item. If there is still an inode item in Checkpoint B
that records the Extent X, the Extent X will be recorded in both inode
datafork and AGF btree block after Checkpoint B is recovered. Such
transaction can be seen when allocing enxtent for inode bmap, it record
both the addition of extent to the inode extent list and the removing
extent from the AGF.

  |------------Record (LSN1)------------------|---Record (LSN2)---|
  |-------Checkpoint A----------|----------Checkpoint B-----------|
  |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
  |     Extent X is freed       |     Extent X is allocated       |

After commit 12818d24db8a ("xfs: rework log recovery to submit buffers
on LSN boundaries") was introduced, we submit buffers on lsn boundaries
during log recovery. The above problem can be avoided under normal paths,
but it's not guaranteed under abnormal paths. Consider the following
process, if an error was encountered after recover buf item in Checkpoint
A and before recover buf item in Checkpoint B, buffers that have been
added to the buffer_list will still be submitted, this violates the
submits rule on lsn boundaries. So buf item in Checkpoint B cannot be
recovered on the next mount due to current lsn of transaction equal to
metadata lsn on disk. The detailed process of the problem is as follows.

First Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint A */
              xlog_recover_buf_commit_pass2
                xlog_recover_do_reg_buffer
                /* add buffer of agf btree block to buffer_list */
                xfs_buf_delwri_queue(bp, buffer_list)
            ...
            ==> Encounter read IO error and return
    /* submit buffers regardless of error */
    if (!list_empty(&buffer_list))
      xfs_buf_delwri_submit(&buffer_list);

    <buf items of agf btree block in Checkpoint A recovery success>

Second Mount:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              /* recover buf item in Checkpoint B */
              xlog_recover_buf_commit_pass2
                /* buffer of agf btree block wouldn't added to
                   buffer_list due to lsn equal to current_lsn */
                if (XFS_LSN_CMP(lsn, current_lsn) >= 0)
                  goto out_release

    <buf items of agf btree block in Checkpoint B wouldn't recovery>

In order to make sure that submits buffers on lsn boundaries in the
abnormal paths, we need to check error status before submit buffers that
have been added from the last record processed. If error status exist,
buffers in the bufffer_list should not be writen to disk.

Canceling the buffers in the buffer_list directly isn't correct, unlike
any other place where write list was canceled, these buffers has been
initialized by xfs_buf_item_init() during recovery and held by buf item,
buf items will not be released in xfs_buf_delwri_cancel(), it's not easy
to solve.

If the filesystem has been shut down, then delwri list submission will
error out all buffers on the list via IO submission/completion and do
all the correct cleanup automatically. So shutting down the filesystem
could prevents buffers in the bufffer_list from being written to disk.

Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v2:
 - rewrite the part of commit message
 - use shutdown solution to prevent buffer_list from writing to disk
 fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1251c81e55f9..9625cf62b038 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3204,11 +3204,28 @@ xlog_do_recovery_pass(
 	kmem_free(hbp);
 
 	/*
-	 * Submit buffers that have been added from the last record processed,
-	 * regardless of error status.
+	 * Submit buffers that have been dirtied by the last record recovered.
 	 */
-	if (!list_empty(&buffer_list))
+	if (!list_empty(&buffer_list)) {
+		if (error) {
+			/*
+			 * If there has been an item recovery error then we
+			 * cannot allow partial checkpoint writeback to
+			 * occur.  We might have multiple checkpoints with the
+			 * same start LSN in this buffer list, and partial
+			 * writeback of a checkpoint in this situation can
+			 * prevent future recovery of all the changes in the
+			 * checkpoints at this start LSN.
+			 *
+			 * Note: Shutting down the filesystem will result in the
+			 * delwri submission marking all the buffers stale,
+			 * completing them and cleaning up _XBF_LOGRECOVERY
+			 * state without doing any IO.
+			 */
+			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		}
 		error2 = xfs_buf_delwri_submit(&buffer_list);
+	}
 
 	if (error && first_bad)
 		*first_bad = rhead_blk;
-- 
2.31.1

