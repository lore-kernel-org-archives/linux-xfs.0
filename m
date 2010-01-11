Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBpWfO137949 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:51:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F1FE158866
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:52:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	vtNztBQNqAbWr94O for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:52:25 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11377753-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:22:24 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIok-0003fe-Jz
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:52:18 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIkT-0006GN-Ci
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:47:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: embed the pagb_list array in the perag structure
Date: Mon, 11 Jan 2010 22:47:49 +1100
Message-Id: <1263210469-22171-11-git-send-email-david@fromorbit.com>
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

Now that the perag structure is allocated memory rather than held in
an array, we don't need to have the busy extent array external to
the structure. Embed it into the perag structure to avoid needing an
extra allocation when setting up.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_ag.h    |   10 ++--------
 fs/xfs/xfs_alloc.c |    4 ++--
 fs/xfs/xfs_mount.c |    3 +--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 963bc27..b1a5a1f 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -187,14 +187,8 @@ typedef struct xfs_perag_busy {
 /*
  * Per-ag incore structure, copies of information in agf and agi,
  * to improve the performance of allocation group selection.
- *
- * pick sizes which fit in allocation buckets well
  */
-#if (BITS_PER_LONG == 32)
-#define XFS_PAGB_NUM_SLOTS	84
-#elif (BITS_PER_LONG == 64)
 #define XFS_PAGB_NUM_SLOTS	128
-#endif
 
 typedef struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
@@ -212,8 +206,6 @@ typedef struct xfs_perag {
 	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
-	int		pagb_count;	/* pagb slots in use */
-	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 
 	/*
 	 * Inode allocation search lookup optimisation.
@@ -232,6 +224,8 @@ typedef struct xfs_perag {
 	rwlock_t	pag_ici_lock;	/* incore inode lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
 #endif
+	int		pagb_count;	/* pagb slots in use */
+	xfs_perag_busy_t pagb_list[XFS_PAGB_NUM_SLOTS];	/* unstable blocks */
 } xfs_perag_t;
 
 /*
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 4d66bb7..8aa181d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2200,8 +2200,8 @@ xfs_alloc_read_agf(
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_list = kmem_zalloc(XFS_PAGB_NUM_SLOTS *
-					sizeof(xfs_perag_busy_t), KM_SLEEP);
+		pag->pagb_count = 0;
+		memset(pag->pagb_list, 0, sizeof(pag->pagb_list));
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index be643e5..0df5045 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -247,10 +247,9 @@ xfs_free_perag(
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
+		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		spin_unlock(&mp->m_perag_lock);
-		ASSERT(pag);
-		kmem_free(pag->pagb_list);
 		kmem_free(pag);
 	}
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
