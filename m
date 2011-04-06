Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p366GfGA019753 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 01:16:41 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16D6014874BD
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2011 23:19:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	POBgetv9jx582RWZ for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2011 23:19:32 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7M5H-00040b-3M
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:19 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7M5I-0004WV-Tm
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: catch bad block numbers freeing extents.
Date: Wed,  6 Apr 2011 16:19:17 +1000
Message-Id: <1302070758-17312-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1302070758-17312-1-git-send-email-david@fromorbit.com>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_alloc.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 4bc3c64..c71e21a 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2395,17 +2395,38 @@ xfs_free_extent(
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
+	if (!args.agbp) {
+		error = EFSCORRUPTED;
+		goto error0;
+	}
+
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
