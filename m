Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53676 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbfAACSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:18:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EQQh168536
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pnxedxar4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:18:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012HxW5006097
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:59 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012HxJM026261
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:59 GMT
Subject: [PATCH 11/12] xfs: parallelize inode inactivation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:58 -0800
Message-ID: <154630907854.16693.4725531341067128379.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split the inode inactivation work into per-AG work items so that we can
take advantage of parallelization.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |  108 ++++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_mount.c  |    3 +
 fs/xfs/xfs_mount.h  |    4 +-
 fs/xfs/xfs_super.c  |    3 -
 4 files changed, 95 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2386a2f3e1d0..e1210beb9d0b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -228,12 +228,12 @@ xfs_reclaim_work_queue(
 /* Queue a new inode inactivation pass if there are reclaimable inodes. */
 static void
 xfs_inactive_work_queue(
-	struct xfs_mount        *mp)
+	struct xfs_perag	*pag)
 {
 	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG))
-		queue_delayed_work(mp->m_inactive_workqueue,
-				&mp->m_inactive_work,
+	if (pag->pag_ici_inactive)
+		queue_delayed_work(pag->pag_mount->m_inactive_workqueue,
+				&pag->pag_inactive_work,
 				msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	rcu_read_unlock();
 }
@@ -316,7 +316,7 @@ xfs_perag_set_inactive_tag(
 	 * idea of when it ought to force inactivation, and in the mean time
 	 * we prefer batching.
 	 */
-	xfs_inactive_work_queue(mp);
+	xfs_inactive_work_queue(pag);
 
 	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
 }
@@ -1693,6 +1693,37 @@ xfs_inactive_inode(
 	return 0;
 }
 
+/*
+ * Inactivate the inodes in an AG. Even if the filesystem is corrupted, we
+ * still need to clear the INACTIVE iflag so that we can move on to reclaiming
+ * the inode.
+ */
+int
+xfs_inactive_inodes_ag(
+	struct xfs_perag	*pag,
+	struct xfs_eofblocks	*eofb)
+{
+	int			nr_to_scan = INT_MAX;
+	bool			done = false;
+
+	return xfs_walk_ag_reclaim_inos(pag, eofb, 0, xfs_inactive_inode_grab,
+			xfs_inactive_inode, &nr_to_scan, &done);
+}
+
+/* Does this pag have inactive inodes? */
+static inline bool
+xfs_pag_has_inactive(
+	struct xfs_perag	*pag)
+{
+	unsigned int		inactive;
+
+	spin_lock(&pag->pag_ici_lock);
+	inactive = pag->pag_ici_inactive;
+	spin_unlock(&pag->pag_ici_lock);
+
+	return inactive > 0;
+}
+
 /*
  * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
  * corrupted, we still need to clear the INACTIVE iflag so that we can move
@@ -1722,15 +1753,12 @@ xfs_inactive_inodes(
 
 	agno = 0;
 	while ((pag = xfs_perag_get_tag(mp, agno, XFS_ICI_RECLAIM_TAG))) {
-		int		nr_to_scan = INT_MAX;
-		bool		done = false;
-
 		agno = pag->pag_agno + 1;
-		error = xfs_walk_ag_reclaim_inos(pag, eofb, 0,
-				xfs_inactive_inode_grab, xfs_inactive_inode,
-				&nr_to_scan, &done);
-		if (error && last_error != -EFSCORRUPTED)
-			last_error = error;
+		if (xfs_pag_has_inactive(pag)) {
+			error = xfs_inactive_inodes_ag(pag, eofb);
+			if (error && last_error != -EFSCORRUPTED)
+				last_error = error;
+		}
 		xfs_perag_put(pag);
 	}
 
@@ -1743,14 +1771,29 @@ void
 xfs_inactive_worker(
 	struct work_struct	*work)
 {
-	struct xfs_mount	*mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_inactive_work);
+	struct xfs_perag	*pag = container_of(to_delayed_work(work),
+					struct xfs_perag, pag_inactive_work);
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	error = xfs_inactive_inodes(mp, NULL);
+	/*
+	 * We want to skip inode inactivation while the filesystem is frozen
+	 * because we don't want the inactivation thread to block while taking
+	 * sb_intwrite.  Therefore, we try to take sb_write for the duration
+	 * of the inactive scan -- a freeze attempt will block until we're
+	 * done here, and if the fs is past stage 1 freeze we'll bounce out
+	 * until things unfreeze.  If the fs goes down while frozen we'll
+	 * still have log recovery to clean up after us.
+	 */
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+
+	error = xfs_inactive_inodes_ag(pag, NULL);
 	if (error && error != -EAGAIN)
 		xfs_err(mp, "inode inactivation failed, error %d", error);
-	xfs_inactive_work_queue(mp);
+
+	sb_end_write(mp->m_super);
+	xfs_inactive_work_queue(pag);
 }
 
 /* Flush all inode inactivation work that might be queued. */
@@ -1758,8 +1801,25 @@ void
 xfs_inactive_force(
 	struct xfs_mount	*mp)
 {
-	queue_delayed_work(mp->m_inactive_workqueue, &mp->m_inactive_work, 0);
-	flush_delayed_work(&mp->m_inactive_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	agno = 0;
+	while ((pag = xfs_perag_get_tag(mp, agno, XFS_ICI_RECLAIM_TAG))) {
+		agno = pag->pag_agno + 1;
+		if (xfs_pag_has_inactive(pag))
+			queue_delayed_work(mp->m_inactive_workqueue,
+					&pag->pag_inactive_work, 0);
+		xfs_perag_put(pag);
+	}
+
+	agno = 0;
+	while ((pag = xfs_perag_get_tag(mp, agno, XFS_ICI_RECLAIM_TAG))) {
+		agno = pag->pag_agno + 1;
+		if (xfs_pag_has_inactive(pag))
+			flush_delayed_work(&pag->pag_inactive_work);
+		xfs_perag_put(pag);
+	}
 }
 
 /*
@@ -1770,7 +1830,15 @@ void
 xfs_inactive_deactivate(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_inactive_work);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = 0;
+
+	while ((pag = xfs_perag_get_tag(mp, agno, XFS_ICI_RECLAIM_TAG))) {
+		agno = pag->pag_agno + 1;
+		cancel_delayed_work_sync(&pag->pag_inactive_work);
+		xfs_perag_put(pag);
+	}
+
 	flush_workqueue(mp->m_inactive_workqueue);
 	xfs_inactive_inodes(mp, NULL);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6d629e1379a0..0bcab017b12b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -129,6 +129,7 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
+	ASSERT(!delayed_work_pending(&pag->pag_inactive_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -149,6 +150,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		cancel_delayed_work_sync(&pag->pag_inactive_work);
 		xfs_buf_hash_destroy(pag);
 		mutex_destroy(&pag->pag_ici_reclaim_lock);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
@@ -203,6 +205,7 @@ xfs_initialize_perag(
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
+		INIT_DELAYED_WORK(&pag->pag_inactive_work, xfs_inactive_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 91391fd43e87..1096ea61a427 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -153,7 +153,6 @@ typedef struct xfs_mount {
 						     trimming */
 	struct delayed_work	m_cowblocks_work; /* background cow blocks
 						     trimming */
-	struct delayed_work	m_inactive_work; /* background inode inactive */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
@@ -392,6 +391,9 @@ typedef struct xfs_perag {
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
+	/* background inode inactivation */
+	struct delayed_work	pag_inactive_work;
+
 	/* reference count */
 	uint8_t			pagf_refcount_level;
 } xfs_perag_t;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aa10df744a2a..b7f37a87f187 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -875,7 +875,7 @@ xfs_init_mount_workqueues(
 		goto out_destroy_eofb;
 
 	mp->m_inactive_workqueue = alloc_workqueue("xfs-inactive/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_inactive_workqueue)
 		goto out_destroy_sync;
 
@@ -1679,7 +1679,6 @@ xfs_mount_alloc(
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_inactive_work, xfs_inactive_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	return mp;
 }
