Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3E197F5D
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4944304062
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uexpTYpNsBDPU123 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHTRC018946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSSx025876
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 14/18] xfs: randomly do sparse inode allocations in DEBUG
	mode
Date: Thu, 12 Feb 2015 13:17:21 -0500
Message-Id: <1423765045-15791-15-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
References: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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

Sparse inode allocations generally only occur when full inode chunk
allocation fails. This requires some level of filesystem space usage and
fragmentation.

For filesystems formatted with sparse inode chunks enabled, do random
sparse inode chunk allocs when compiled in DEBUG mode to increase test
coverage.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1c81f08..d96c5e1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -609,9 +609,18 @@ xfs_ialloc_ag_alloc(
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_perag *pag;
 
+	int		do_sparse = 0;
+
+#ifdef DEBUG
+	/* randomly do sparse inode allocations */
+	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb))
+		do_sparse = prandom_u32() & 1;
+#endif
+
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
+	args.fsbno = NULLFSBLOCK;
 
 	/*
 	 * Locking will ensure that we don't have two callers in here
@@ -632,6 +641,8 @@ xfs_ialloc_ag_alloc(
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 		     args.mp->m_ialloc_blks;
+	if (do_sparse)
+		goto sparse_alloc;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
@@ -670,8 +681,7 @@ xfs_ialloc_ag_alloc(
 		 * subsequent requests.
 		 */
 		args.minalignslop = 0;
-	} else
-		args.fsbno = NULLFSBLOCK;
+	}
 
 	if (unlikely(args.fsbno == NULLFSBLOCK)) {
 		/*
@@ -729,6 +739,7 @@ xfs_ialloc_ag_alloc(
 	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
+sparse_alloc:
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
