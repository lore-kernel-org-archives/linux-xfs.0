Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C128F7F47
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90BE08F8059
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 10:10:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7RtD5t3TO8DQ6UUM for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 10:10:48 -0800 (PST)
Message-ID: <54B019A5.2060907@sandeen.net>
Date: Fri, 09 Jan 2015 12:10:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: make global xfsalloc workqueue per-mount
References: <54B01927.2010506@redhat.com>
In-Reply-To: <54B01927.2010506@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

The xfsalloc workquaue is the last remaining global work
queue, something we've been moving away from in general.
Make this one per-mount like every other workqueue.

This also renames it from "xfsalloc" to "xfs-alloc" to
match the naming convention.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a6fbf44..72d28d1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -36,8 +36,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 
-struct workqueue_struct *xfs_alloc_wq;
-
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
 
 #define	XFSA_FIXUP_BNO_OK	1
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d1b4b6a..39933a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -24,8 +24,6 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_trans;
 
-extern struct workqueue_struct *xfs_alloc_wq;
-
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
  */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 81cad43..a8a1369 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2574,7 +2574,7 @@ xfs_btree_split(
 	args.done = &done;
 	args.kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
-	queue_work(xfs_alloc_wq, &args.work);
+	queue_work(cur->bc_mp->m_alloc_workqueue, &args.work);
 	wait_for_completion(&done);
 	destroy_work_on_stack(&args.work);
 	return args.result;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 22ccf69..7d57a5f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -175,6 +175,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct *m_alloc_workqueue;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19cbda1..e5bdca9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -873,8 +873,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_log;
 
+	mp->m_alloc_workqueue = alloc_workqueue("xfs-alloc/%s",
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+	if (!mp->m_alloc_workqueue)
+		goto out_destroy_eofblocks;
+
 	return 0;
 
+out_destroy_eofblocks:
+	destroy_workqueue(mp->m_eofblocks_workqueue);
 out_destroy_log:
 	destroy_workqueue(mp->m_log_workqueue);
 out_destroy_reclaim:
@@ -895,6 +902,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_alloc_workqueue);
 	destroy_workqueue(mp->m_eofblocks_workqueue);
 	destroy_workqueue(mp->m_log_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
@@ -1717,29 +1725,6 @@ xfs_destroy_zones(void)
 }
 
 STATIC int __init
-xfs_init_workqueues(void)
-{
-	/*
-	 * The allocation workqueue can be used in memory reclaim situations
-	 * (writepage path), and parallelism is only limited by the number of
-	 * AGs in all the filesystems mounted. Hence use the default large
-	 * max_active value for this workqueue.
-	 */
-	xfs_alloc_wq = alloc_workqueue("xfsalloc",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0);
-	if (!xfs_alloc_wq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-STATIC void
-xfs_destroy_workqueues(void)
-{
-	destroy_workqueue(xfs_alloc_wq);
-}
-
-STATIC int __init
 init_xfs_fs(void)
 {
 	int			error;
@@ -1753,13 +1738,9 @@ init_xfs_fs(void)
 	if (error)
 		goto out;
 
-	error = xfs_init_workqueues();
-	if (error)
-		goto out_destroy_zones;
-
 	error = xfs_mru_cache_init();
 	if (error)
-		goto out_destroy_wq;
+		goto out_destroy_zones;
 
 	error = xfs_buf_init();
 	if (error)
@@ -1776,7 +1757,7 @@ init_xfs_fs(void)
 	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
 	if (!xfs_kset) {
 		error = -ENOMEM;
-		goto out_sysctl_unregister;;
+		goto out_sysctl_unregister;
 	}
 
 #ifdef DEBUG
@@ -1795,27 +1776,25 @@ init_xfs_fs(void)
 		goto out_qm_exit;
 	return 0;
 
- out_qm_exit:
+out_qm_exit:
 	xfs_qm_exit();
- out_remove_kobj:
+out_remove_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
- out_kset_unregister:
+out_kset_unregister:
 #endif
 	kset_unregister(xfs_kset);
- out_sysctl_unregister:
+out_sysctl_unregister:
 	xfs_sysctl_unregister();
- out_cleanup_procfs:
+out_cleanup_procfs:
 	xfs_cleanup_procfs();
- out_buf_terminate:
+out_buf_terminate:
 	xfs_buf_terminate();
- out_mru_cache_uninit:
+out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
- out_destroy_wq:
-	xfs_destroy_workqueues();
- out_destroy_zones:
+out_destroy_zones:
 	xfs_destroy_zones();
- out:
+out:
 	return error;
 }
 
@@ -1832,7 +1811,6 @@ exit_xfs_fs(void)
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
 	xfs_mru_cache_uninit();
-	xfs_destroy_workqueues();
 	xfs_destroy_zones();
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
