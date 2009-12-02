Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB26BAs1217324 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 00:11:10 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E76F412DADB1
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 22:11:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	8kb4ZmWxDv3lKEJ0 for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 22:11:39 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	9364471-1927428
	for <xfs@oss.sgi.com>; Wed, 02 Dec 2009 16:41:37 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NFiR5-0000gS-IQ
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:35 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NFiRD-0005L5-Jx
	for xfs@oss.sgi.com; Wed, 02 Dec 2009 17:11:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] [XFS] Reference count per-ag structures
Date: Wed,  2 Dec 2009 17:11:39 +1100
Message-Id: <1259734299-20306-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1259734299-20306-1-git-send-email-david@fromorbit.com>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
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

Reference count the per-ag structures to ensure that we keep get/put
pairs balanced. Assert that the reference counts are zero at unmount
time to catch leaks. In future, reference counts will enable us to
safely remove perag structures by allowing us to detect when they
are no longer in use.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h    |    4 ++--
 fs/xfs/xfs_alloc.c |    2 +-
 fs/xfs/xfs_inode.c |    5 ++++-
 fs/xfs/xfs_mount.c |    1 +
 fs/xfs/xfs_mount.h |   11 +++++++++--
 5 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index a5d54bf..b384a3c 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -182,8 +182,8 @@ typedef struct xfs_perag_busy {
 #define XFS_PAGB_NUM_SLOTS	128
 #endif
 
-typedef struct xfs_perag
-{
+typedef struct xfs_perag {
+	atomic_t	pag_ref;	/* perag reference count */
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 2d076e2..d1349b1 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2545,7 +2545,6 @@ xfs_alloc_vextent(
 			}
 			xfs_perag_put(args->pag);
 		}
-		xfs_perag_put(args->pag);
 		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
 			if (args->agno == sagno)
 				mp->m_agfrotor = (mp->m_agfrotor + 1) %
@@ -2571,6 +2570,7 @@ xfs_alloc_vextent(
 			args->len);
 #endif
 	}
+	xfs_perag_put(args->pag);
 	return 0;
 error0:
 	xfs_perag_put(args->pag);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 44a1168..e6c178e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2729,7 +2729,7 @@ xfs_iflush_cluster(
 	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
-		return 0;
+		goto out_put;
 
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
@@ -2798,6 +2798,8 @@ xfs_iflush_cluster(
 out_free:
 	read_unlock(&pag->pag_ici_lock);
 	kmem_free(ilist);
+out_put:
+	xfs_perag_put(pag);
 	return 0;
 
 
@@ -2841,6 +2843,7 @@ cluster_corrupt_out:
 	 */
 	xfs_iflush_abort(iq);
 	kmem_free(ilist);
+	xfs_perag_put(pag);
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d6de63d..21f1b29 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,6 +213,7 @@ xfs_free_perag(
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			continue;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b2aa726..225eb29 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,7 +384,7 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 /*
- * perag get/put wrappers for eventual ref counting
+ * perag get/put wrappers for ref counting
  */
 static inline xfs_perag_t *
 xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
@@ -393,6 +393,12 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 
 	spin_lock(&mp->m_perag_lock);
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		ASSERT(atomic_read(&pag->pag_ref) >= 0);
+		/* catch leaks in the positive direction during testing */
+		ASSERT(atomic_read(&pag->pag_ref) < 1000);
+		atomic_inc(&pag->pag_ref);
+	}
 	spin_unlock(&mp->m_perag_lock);
 	return pag;
 }
@@ -400,7 +406,8 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
 static inline void
 xfs_perag_put(xfs_perag_t *pag)
 {
-	/* nothing to see here, move along */
+	ASSERT(atomic_read(&pag->pag_ref) > 0);
+	atomic_dec(&pag->pag_ref);
 }
 
 /*
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
