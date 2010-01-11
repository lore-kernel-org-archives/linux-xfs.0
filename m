Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBpMrF137853 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:51:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72E65135828D
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:52:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	zOz1eStNNYOerKFE for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:52:16 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11243209-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:22:15 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIof-0003f7-Eb
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:52:13 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIkT-0006GH-Ay
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:47:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] xfs: handle ENOMEM correctly during initialisation of
	perag structures
Date: Mon, 11 Jan 2010 22:47:48 +1100
Message-Id: <1263210469-22171-10-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_mount.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 049dbc7..be643e5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -432,11 +432,13 @@ xfs_initialize_perag(
 	xfs_agnumber_t	*maxagi)
 {
 	xfs_agnumber_t	index, max_metadata;
+	xfs_agnumber_t	first_initialised = 0;
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
 	xfs_ino_t	ino;
 	xfs_sb_t	*sbp = &mp->m_sb;
 	xfs_ino_t	max_inum = XFS_MAXINUMBER_32;
+	int		error = -ENOMEM;
 
 	/* Check to see if the filesystem can overflow 32 bit inodes */
 	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
@@ -453,17 +455,20 @@ xfs_initialize_perag(
 			xfs_perag_put(pag);
 			continue;
 		}
+		if (!first_initialised)
+			first_initialised = index;
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
 		if (!pag)
-			return -ENOMEM;
+			goto out_unwind;
 		if (radix_tree_preload(GFP_NOFS))
-			return -ENOMEM;
+			goto out_unwind;
 		spin_lock(&mp->m_perag_lock);
 		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
 			BUG();
 			spin_unlock(&mp->m_perag_lock);
-			kmem_free(pag);
-			return -EEXIST;
+			radix_tree_preload_end();
+			error = -EEXIST;
+			goto out_unwind;
 		}
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
@@ -523,6 +528,14 @@ xfs_initialize_perag(
 	if (maxagi)
 		*maxagi = index;
 	return 0;
+
+out_unwind:
+	kmem_free(pag);
+	for (; index > first_initialised; index--) {
+		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		kmem_free(pag);
+	}
+	return error;
 }
 
 void
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
