Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40080 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfDOCH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:07:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F24Rnp162493
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:54 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rusnej0tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F264Tf184871
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rv2ttwy4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:53 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3F27rTw013310
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:53 GMT
Subject: [PATCH 2/3] xfs: remove unused m_data_workqueue
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 14 Apr 2019 19:07:55 -0700
Message-ID: <155529407512.243484.4836699205659210299.stgit@magnolia>
In-Reply-To: <155529406249.243484.1307333973877627694.stgit@magnolia>
References: <155529406249.243484.1307333973877627694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we're no longer using m_data_workqueue, remove it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 -
 fs/xfs/xfs_super.c |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 110f927cf943..1d3a4b2bdc2f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -175,7 +175,6 @@ typedef struct xfs_mount {
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
-	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f093ea244849..df917f41ca46 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -838,15 +838,10 @@ xfs_init_mount_workqueues(
 	if (!mp->m_buf_workqueue)
 		goto out;
 
-	mp->m_data_workqueue = alloc_workqueue("xfs-data/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
-	if (!mp->m_data_workqueue)
-		goto out_destroy_buf;
-
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_unwritten_workqueue)
-		goto out_destroy_data_iodone_queue;
+		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
@@ -886,8 +881,6 @@ xfs_init_mount_workqueues(
 	destroy_workqueue(mp->m_cil_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
-out_destroy_data_iodone_queue:
-	destroy_workqueue(mp->m_data_workqueue);
 out_destroy_buf:
 	destroy_workqueue(mp->m_buf_workqueue);
 out:
@@ -903,7 +896,6 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_log_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
-	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
 	destroy_workqueue(mp->m_buf_workqueue);
 }
