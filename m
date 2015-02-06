Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A5938050
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BAAF7AC00C
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ceevfx6SpS7K1OeR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:08 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr7CH020998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr7jr022356
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 11/18] xfs: randomly do sparse inode allocations in DEBUG
	mode
Date: Fri,  6 Feb 2015 14:52:58 -0500
Message-Id: <1423252385-3063-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 090d114..3e5d3eb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -652,9 +652,18 @@ xfs_ialloc_ag_alloc(
 
 	struct xfs_perag *pag;
 
+#ifdef DEBUG
+	int		do_sparse = 0;
+
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
@@ -675,6 +684,10 @@ xfs_ialloc_ag_alloc(
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
 		     args.mp->m_ialloc_blks;
+#ifdef DEBUG
+	if (do_sparse)
+		goto sparse_alloc;
+#endif
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
@@ -713,8 +726,7 @@ xfs_ialloc_ag_alloc(
 		 * subsequent requests.
 		 */
 		args.minalignslop = 0;
-	} else
-		args.fsbno = NULLFSBLOCK;
+	}
 
 	if (unlikely(args.fsbno == NULLFSBLOCK)) {
 		/*
@@ -769,6 +781,9 @@ xfs_ialloc_ag_alloc(
 	 * Finally, try a sparse allocation if the filesystem supports it and
 	 * the sparse allocation length is smaller than a full chunk.
 	 */
+#ifdef DEBUG
+sparse_alloc:
+#endif
 	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
