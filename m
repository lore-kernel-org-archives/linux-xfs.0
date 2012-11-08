Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA85bjG3219465 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 23:37:45 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ElvOjbV9GoeaBJK3 for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 21:39:42 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWKq0-0003NC-4x
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWKq0-0004vF-1X
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: make growfs initialise the AGFL header
Date: Thu,  8 Nov 2012 16:39:33 +1100
Message-Id: <1352353173-18820-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1352353173-18820-1-git-send-email-david@fromorbit.com>
References: <1352353173-18820-1-git-send-email-david@fromorbit.com>
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

For verification purposes, AGFLs need to be initialised to a known
set of values. For upcoming CRC changes, the are also headers that
need to be initialised. Currently, growfs does neither for the AGFLs
- it ignores them completely. Add initialisation of the AGFL to be
full of invalid block numbers (NULLAGBLOCK) to put the
infrastructure in place needed for CRC support.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    2 +-
 fs/xfs/xfs_alloc.h |    1 +
 fs/xfs/xfs_fsops.c |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 8517e69..5b2357e 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -479,7 +479,7 @@ xfs_agfl_read_verify(
 	xfs_agfl_verify(bp);
 }
 
-static const struct xfs_buf_ops xfs_agfl_buf_ops = {
+const struct xfs_buf_ops xfs_agfl_buf_ops = {
 	.verify_read = xfs_agfl_read_verify,
 	.verify_write = xfs_agfl_write_verify,
 };
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 786e1b8..a197b3c 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -239,5 +239,6 @@ xfs_alloc_freespace_map(
 	u64			length);
 
 extern const struct xfs_buf_ops xfs_agf_buf_ops;
+extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 717b803..2f7d11e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -140,6 +140,7 @@ xfs_growfs_data_private(
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
 	xfs_agf_t		*agf;
+	struct xfs_agfl		*agfl;
 	xfs_agi_t		*agi;
 	xfs_agnumber_t		agno;
 	xfs_extlen_t		agsize;
@@ -249,6 +250,26 @@ xfs_growfs_data_private(
 			goto error0;
 
 		/*
+		 * AGFL header block
+		 */
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
+
+		agfl = XFS_BUF_TO_AGFL(bp);
+		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
+			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
+
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		if (error)
+			goto error0;
+
+		/*
 		 * AG inode header block
 		 */
 		bp = xfs_growfs_get_hdr_buf(mp,
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
