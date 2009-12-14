Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBENBF3v185778 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 17:11:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE5A7F57EE
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 15:11:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	E3ScvlGD9HBJ5KGx for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 15:11:52 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10160051-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 09:41:48 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NKK4w-0001Is-3O
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:11:46 +1100
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <dave@disturbed.disaster>) id 1NKK4b-0003sf-SP
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 10:11:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] XFS: Reference count per-ag structures
Date: Tue, 15 Dec 2009 10:11:10 +1100
Message-Id: <1260832270-14762-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1260832270-14762-1-git-send-email-david@fromorbit.com>
References: <1260832270-14762-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_mount.c |    1 +
 fs/xfs/xfs_mount.h |   11 +++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

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
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1ab9495..0203a6a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -213,6 +213,7 @@ xfs_free_perag(
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		kmem_free(pag->pagb_list);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cfa7a5d..16b2212 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,7 +384,7 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 /*
- * perag get/put wrappers for eventual ref counting
+ * perag get/put wrappers for ref counting
  */
 static inline struct xfs_perag *
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
 xfs_perag_put(struct xfs_perag *pag)
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
