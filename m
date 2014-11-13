Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4047B29DFB
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:24:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1F8CAC00E
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:24:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id znpZaeDhpFarVe0u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 11:24:05 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sADJO3Ms012272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:04 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sADJO3eZ002303
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC v3 2/2] xfs: split metadata and log buffer completion to
	separate workqueues
Date: Thu, 13 Nov 2014 14:24:01 -0500
Message-Id: <1415906641-43587-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415906641-43587-1-git-send-email-bfoster@redhat.com>
References: <1415906641-43587-1-git-send-email-bfoster@redhat.com>
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

XFS traditionally sends all buffer I/O completion work to a single
queue. This includes metadata buffer completion and log buffer
completion. The log buffer completion requires a high priority queue to
prevent stalls due to log forces getting stuck behind other queued work.

Rather than continue to prioritize all buffer I/O completion due to the
needs of log completion, split log buffer completion off to
m_log_workqueue and move the high priority flag from m_buf_workqueue to
m_log_workqueue.

[XXX: Use of XBF_SYNCIO is purely for demonstration. Define a new flag.]

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c   | 9 ++++++++-
 fs/xfs/xfs_super.c | 5 ++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c06d790..58d729c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1050,8 +1050,15 @@ void
 xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
+	struct workqueue_struct *wq;
+
+	if (bp->b_flags & XBF_SYNCIO)
+		wq = bp->b_target->bt_mount->m_log_workqueue;
+	else
+		wq = bp->b_target->bt_mount->m_buf_workqueue;
+
 	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
-	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_iodone_work);
+	queue_work(wq, &bp->b_iodone_work);
 }
 
 void
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 03e3cc2..4b8cd37 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -843,8 +843,7 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_HIGHPRI|WQ_FREEZABLE, 1,
-			mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
@@ -869,7 +868,7 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
