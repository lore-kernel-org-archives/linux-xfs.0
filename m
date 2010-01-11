Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBpOEa137895 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:51:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49387158863
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:52:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	5cAUnRN6m2K2wsGV for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:52:18 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11367106-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:22:15 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIof-0003fI-3B
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:52:13 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIkS-0006G7-T2
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:47:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] XFS: Reference count per-ag structures
Date: Mon, 11 Jan 2010 22:47:45 +1100
Message-Id: <1263210469-22171-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1263210469-22171-1-git-send-email-david@fromorbit.com>
References: <1263210469-22171-1-git-send-email-david@fromorbit.com>
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
index 6702bd8..18ae43f 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -196,8 +196,8 @@ typedef struct xfs_perag_busy {
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
index c04dd83..f241fec 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -215,6 +215,7 @@ xfs_free_perag(
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
