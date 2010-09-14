Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuEBP121185 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B738E11E4F86
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 04:08:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	bB3ISwN8SqQsjoQ1 for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 04:08:46 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38985531-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:00 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBx-0004Of-7d
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:49 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBa-0000Py-Rz
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/18] xfs: lockless per-ag lookups
Date: Tue, 14 Sep 2010 20:56:03 +1000
Message-Id: <1284461777-1496-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When we start taking a reference to the per-ag for every cached
buffer in the system, kernel lockstat profiling on an 8-way create
workload shows the mp->m_perag_lock has higher acquisition rates
than the inode lock and has significantly more contention. That is,
it becomes the highest contended lock in the system.

The perag lookup is trivial to convert to lock-less RCU lookups
because perag structures never go away. Hence the only thing we need
to protect against is tree structure changes during a grow. THis can
be done simply by replacing the locking in xfs_perag_get() with RCU
read locking. This removes the mp->m_perag_lock completely from this
path.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h    |    3 +++
 fs/xfs/xfs_mount.c |   25 +++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 4917d4e..51c42c2 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -230,6 +230,9 @@ typedef struct xfs_perag {
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
+
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
 #endif
 	int		pagb_count;	/* pagb slots in use */
 } xfs_perag_t;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 00c7a87..14fc6e9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -199,6 +199,8 @@ xfs_uuid_unmount(
 
 /*
  * Reference counting access wrappers to the perag structures.
+ * Because we never free per-ag structures, the only thing we
+ * have to protect against changes is the tree structure itself.
  */
 struct xfs_perag *
 xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
@@ -206,13 +208,13 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 	struct xfs_perag	*pag;
 	int			ref = 0;
 
-	spin_lock(&mp->m_perag_lock);
+	rcu_read_lock();
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
 		ref = atomic_inc_return(&pag->pag_ref);
 	}
-	spin_unlock(&mp->m_perag_lock);
+	rcu_read_unlock();
 	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
 	return pag;
 }
@@ -227,10 +229,18 @@ xfs_perag_put(struct xfs_perag *pag)
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
+STATIC void
+__xfs_free_perag(
+	struct rcu_head	*head)
+{
+	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
+
+	ASSERT(atomic_read(&pag->pag_ref) == 0);
+	kmem_free(pag);
+}
+
 /*
- * Free up the resources associated with a mount structure.  Assume that
- * the structure was initially zeroed, so we can tell which fields got
- * initialized.
+ * Free up the per-ag resources associated with the mount structure.
  */
 STATIC void
 xfs_free_perag(
@@ -242,10 +252,9 @@ xfs_free_perag(
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		spin_unlock(&mp->m_perag_lock);
-		kmem_free(pag);
+		ASSERT(pag);
+		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
