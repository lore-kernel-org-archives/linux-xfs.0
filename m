Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54567 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdFCNLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:11:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/23] xfs: use dedicated log worker wq to avoid deadlock with cil wq
Date: Sat,  3 Jun 2017 15:10:41 +0200
Message-Id: <20170603131103.23712-2-hch@lst.de>
In-Reply-To: <20170603131103.23712-1-hch@lst.de>
References: <20170603131103.23712-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 696a562072e3c14bcd13ae5acc19cdf27679e865 upstream.

The log covering background task used to be part of the xfssyncd
workqueue. That workqueue was removed as of commit 5889608df ("xfs:
syncd workqueue is no more") and the associated work item scheduled
to the xfs-log wq. The latter is used for log buffer I/O completion.

Since xfs_log_worker() can invoke a log flush, a deadlock is
possible between the xfs-log and xfs-cil workqueues. Consider the
following codepath from xfs_log_worker():

xfs_log_worker()
  xfs_log_force()
    _xfs_log_force()
      xlog_cil_force()
        xlog_cil_force_lsn()
          xlog_cil_push_now()
            flush_work()

The above is in xfs-log wq context and blocked waiting on the
completion of an xfs-cil work item. Concurrently, the cil push in
progress can end up blocked here:

xlog_cil_push_work()
  xlog_cil_push()
    xlog_write()
      xlog_state_get_iclog_space()
        xlog_wait(&log->l_flush_wait, ...)

The above is in xfs-cil context waiting on log buffer I/O
completion, which executes in xfs-log wq context. In this scenario
both workqueues are deadlocked waiting on eachother.

Add a new workqueue specifically for the high level log covering and
ail pushing worker, as was the case prior to commit 5889608df.

Diagnosed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c   | 2 +-
 fs/xfs/xfs_mount.h | 1 +
 fs/xfs/xfs_super.c | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b1469f0a91a6..bb58cd1873c9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1293,7 +1293,7 @@ void
 xfs_log_work_queue(
 	struct xfs_mount        *mp)
 {
-	queue_delayed_work(mp->m_log_workqueue, &mp->m_log->l_work,
+	queue_delayed_work(mp->m_sync_workqueue, &mp->m_log->l_work,
 				msecs_to_jiffies(xfs_syncd_centisecs * 10));
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6db6fd6b82b0..22b2185e93a0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -183,6 +183,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct	*m_sync_workqueue;
 
 	/*
 	 * Generation of the filesysyem layout.  This is incremented by each
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 685c042a120f..47d239dcf3f4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -877,8 +877,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_log;
 
+	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
+					       mp->m_fsname);
+	if (!mp->m_sync_workqueue)
+		goto out_destroy_eofb;
+
 	return 0;
 
+out_destroy_eofb:
+	destroy_workqueue(mp->m_eofblocks_workqueue);
 out_destroy_log:
 	destroy_workqueue(mp->m_log_workqueue);
 out_destroy_reclaim:
@@ -899,6 +906,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_sync_workqueue);
 	destroy_workqueue(mp->m_eofblocks_workqueue);
 	destroy_workqueue(mp->m_log_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
-- 
2.11.0

