Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1304DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 06:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiCQGGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiCQGG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 02:06:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 434A5132E91
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:39:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D1A9310E4A84
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 16:39:09 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUiqr-006QoM-16
        for linux-xfs@vger.kernel.org; Thu, 17 Mar 2022 16:39:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nUiqq-000giG-W9
        for linux-xfs@vger.kernel.org;
        Thu, 17 Mar 2022 16:39:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: log worker needs to start before intent/unlink recovery
Date:   Thu, 17 Mar 2022 16:39:01 +1100
Message-Id: <20220317053907.164160-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317053907.164160-1-david@fromorbit.com>
References: <20220317053907.164160-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6232c97e
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=9zfcJeoDbhBuSCwZ9u8A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

After 963 iterations of generic/530, it deadlocked during recovery
on a pinned inode cluster buffer like so:

XFS (pmem1): Starting recovery (logdev: internal)
INFO: task kworker/8:0:306037 blocked for more than 122 seconds.
      Not tainted 5.17.0-rc6-dgc+ #975
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/8:0     state:D stack:13024 pid:306037 ppid:     2 flags:0x00004000
Workqueue: xfs-inodegc/pmem1 xfs_inodegc_worker
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 schedule_timeout+0x114/0x160
 __down+0x99/0xf0
 down+0x5e/0x70
 xfs_buf_lock+0x36/0xf0
 xfs_buf_find+0x418/0x850
 xfs_buf_get_map+0x47/0x380
 xfs_buf_read_map+0x54/0x240
 xfs_trans_read_buf_map+0x1bd/0x490
 xfs_imap_to_bp+0x4f/0x70
 xfs_iunlink_map_ino+0x66/0xd0
 xfs_iunlink_map_prev.constprop.0+0x148/0x2f0
 xfs_iunlink_remove_inode+0xf2/0x1d0
 xfs_inactive_ifree+0x1a3/0x900
 xfs_inode_unlink+0xcc/0x210
 xfs_inodegc_worker+0x1ac/0x2f0
 process_one_work+0x1ac/0x390
 worker_thread+0x56/0x3c0
 kthread+0xf6/0x120
 ret_from_fork+0x1f/0x30
 </TASK>
task:mount           state:D stack:13248 pid:324509 ppid:324233 flags:0x00004000
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 schedule_timeout+0x114/0x160
 __down+0x99/0xf0
 down+0x5e/0x70
 xfs_buf_lock+0x36/0xf0
 xfs_buf_find+0x418/0x850
 xfs_buf_get_map+0x47/0x380
 xfs_buf_read_map+0x54/0x240
 xfs_trans_read_buf_map+0x1bd/0x490
 xfs_imap_to_bp+0x4f/0x70
 xfs_iget+0x300/0xb40
 xlog_recover_process_one_iunlink+0x4c/0x170
 xlog_recover_process_iunlinks.isra.0+0xee/0x130
 xlog_recover_finish+0x57/0x110
 xfs_log_mount_finish+0xfc/0x1e0
 xfs_mountfs+0x540/0x910
 xfs_fs_fill_super+0x495/0x850
 get_tree_bdev+0x171/0x270
 xfs_fs_get_tree+0x15/0x20
 vfs_get_tree+0x24/0xc0
 path_mount+0x304/0xba0
 __x64_sys_mount+0x108/0x140
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>
task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 io_schedule+0x4b/0x80
 xfs_buf_wait_unpin+0x9e/0xf0
 __xfs_buf_submit+0x14a/0x230
 xfs_buf_delwri_submit_buffers+0x107/0x280
 xfs_buf_delwri_submit_nowait+0x10/0x20
 xfsaild+0x27e/0x9d0
 kthread+0xf6/0x120
 ret_from_fork+0x1f/0x30

We have the mount process waiting on an inode cluster buffer read,
inodegc doing unlink waiting on the same inode cluster buffer, and
the AIL push thread blocked in writeback waiting for the inode
cluster buffer to become unpinned.

What has happened here is that the AIL push thread has raced with
the inodegc process modifying, committing and pinning the inode
cluster buffer here in xfs_buf_delwri_submit_buffers() here:

	blk_start_plug(&plug);
	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
		if (!wait_list) {
			if (xfs_buf_ispinned(bp)) {
				pinned++;
				continue;
			}
Here >>>>>>
			if (!xfs_buf_trylock(bp))
				continue;

Basically, the AIL has found the buffer wasn't pinned and got the
lock without blocking, but then the buffer was pinned. This implies
the processing here was pre-empted between the pin check and the
lock, because the pin count can only be increased while holding the
buffer locked. Hence when it has gone to submit the IO, it has
blocked waiting for the buffer to be unpinned.

With all executing threads now waiting on the buffer to be unpinned,
we normally get out of situations like this via the background log
worker issuing a log force which will unpinned stuck buffers like
this. But at this point in recovery, we haven't started the log
worker. In fact, the first thing we do after processing intents and
unlinked inodes is *start the log worker*. IOWs, we start it too
late to have it break deadlocks like this.

Avoid this and any other similar deadlock vectors in intent and
unlinked inode recovery by starting the log worker before we recover
intents and unlinked inodes. This part of recovery runs as though
the filesystem is fully active, so we really should have the same
infrastructure running as we normally do at runtime.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 40419e8fedad..627179e6a0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -798,10 +798,9 @@ xfs_log_mount_finish(
 	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= SB_ACTIVE;
+	xfs_log_work_queue(mp);
 	if (xlog_recovery_needed(log))
 		error = xlog_recover_finish(log);
-	if (!error)
-		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~SB_ACTIVE;
 	evict_inodes(mp->m_super);
 
-- 
2.35.1

