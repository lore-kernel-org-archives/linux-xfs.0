Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p371skSI067210 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 20:54:47 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E7FCB91AA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 18:58:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uQFWJ7XgSmgjxC0E for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 18:58:02 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7eTY-00063g-3g
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:36 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7eTa-00079z-OM
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: catch bad block numbers freeing extents.
Date: Thu,  7 Apr 2011 11:57:24 +1000
Message-Id: <1302141445-27457-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1302141445-27457-1-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
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

A fuzzed filesystem crashed a kernel when freeing an extent with a
block number beyond the end of the filesystem. Convert all the debug
asserts in xfs_free_extent() to active checks so that we catch bad
extents and return that the filesytsem is corrupted rather than
crashing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_alloc.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 4bc3c64..27d64d7 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2395,17 +2395,33 @@ xfs_free_extent(
 	memset(&args, 0, sizeof(xfs_alloc_arg_t));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
+
+	/*
+	 * validate that the block number is legal - the enables us to detect
+	 * and handle a silent filesystem corruption rather than crashing.
+	 */
 	args.agno = XFS_FSB_TO_AGNO(args.mp, bno);
-	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
+	if (args.agno >= args.mp->m_sb.sb_agcount)
+		return EFSCORRUPTED;
+
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
+	if (args.agbno >= args.mp->m_sb.sb_agblocks)
+		return EFSCORRUPTED;
+
 	args.pag = xfs_perag_get(args.mp, args.agno);
-	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
 		goto error0;
-#ifdef DEBUG
-	ASSERT(args.agbp != NULL);
-	ASSERT((args.agbno + len) <=
-		be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length));
-#endif
+
+	/* validate the extent size is legal now we have the agf locked */
+	if (args.agbno + len >
+			be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length)) {
+		error = EFSCORRUPTED;
+		goto error0;
+	}
+
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 error0:
 	xfs_perag_put(args.pag);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
