Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8130B29DFC
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:24:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70ADB8F8033
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:24:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0OtimBxyigVf8CY5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 11:24:05 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sADJO3qW009817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:04 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sADJO3CO019118
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:24:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/2] xfs: replace global xfslogd wq with per-mount wq
Date: Thu, 13 Nov 2014 14:24:00 -0500
Message-Id: <1415906641-43587-2-git-send-email-bfoster@redhat.com>
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

The xfslogd workqueue is a global, single-job workqueue for buffer ioend
processing. This means we allow for a single work item at a time for all
possible XFS mounts on a system. fsstress testing in loopback XFS over
XFS configurations has reproduced xfslogd deadlocks due to the single
threaded nature of the queue and dependencies introduced between the
separate XFS instances by online discard (-o discard).

Discard over a loopback device converts the discard request to a hole
punch (fallocate) on the underlying file. Online discard requests are
issued synchronously and from xfslogd context in XFS, hence the xfslogd
workqueue is blocked in the upper fs waiting on a hole punch request to
be servied in the lower fs. If the lower fs issues I/O that depends on
xfslogd to complete, both filesystems end up hung indefinitely. This is
reproduced reliabily by generic/013 on XFS->loop->XFS test devices with
the '-o discard' mount option.

Further, docker implementations appear to use this kind of configuration
for container instance filesystems by default (container fs->dm->
loop->base fs) and therefore are subject to this deadlock when running
on XFS.

Replace the global xfslogd workqueue with a per-mount variant. This
guarantees each mount access to a single worker and prevents deadlocks
due to inter-fs dependencies introduced by discard. Since the queue is
only responsible for buffer iodone processing at this point in time,
rename xfslogd to xfs-buf.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c   | 12 +-----------
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 11 ++++++++++-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 24b4ebe..c06d790 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -44,8 +44,6 @@
 
 static kmem_zone_t *xfs_buf_zone;
 
-static struct workqueue_struct *xfslogd_workqueue;
-
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
 # define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
@@ -1053,7 +1051,7 @@ xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
 	INIT_WORK(&bp->b_iodone_work, xfs_buf_ioend_work);
-	queue_work(xfslogd_workqueue, &bp->b_iodone_work);
+	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_iodone_work);
 }
 
 void
@@ -1882,15 +1880,8 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out;
 
-	xfslogd_workqueue = alloc_workqueue("xfslogd",
-				WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_FREEZABLE, 1);
-	if (!xfslogd_workqueue)
-		goto out_free_buf_zone;
-
 	return 0;
 
- out_free_buf_zone:
-	kmem_zone_destroy(xfs_buf_zone);
  out:
 	return -ENOMEM;
 }
@@ -1898,6 +1889,5 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..394bc71 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -168,6 +168,7 @@ typedef struct xfs_mount {
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 
+	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9f622fe..03e3cc2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -842,10 +842,16 @@ STATIC int
 xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
+			WQ_MEM_RECLAIM|WQ_HIGHPRI|WQ_FREEZABLE, 1,
+			mp->m_fsname);
+	if (!mp->m_buf_workqueue)
+		goto out;
+
 	mp->m_data_workqueue = alloc_workqueue("xfs-data/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_data_workqueue)
-		goto out;
+		goto out_destroy_buf;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
@@ -884,6 +890,8 @@ out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_data_iodone_queue:
 	destroy_workqueue(mp->m_data_workqueue);
+out_destroy_buf:
+	destroy_workqueue(mp->m_buf_workqueue);
 out:
 	return -ENOMEM;
 }
@@ -898,6 +906,7 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
+	destroy_workqueue(mp->m_buf_workqueue);
 }
 
 /*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
