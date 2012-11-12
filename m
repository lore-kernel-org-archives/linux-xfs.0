Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBqmIu217604 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:52:48 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VCCnaHiJ0C7CFHAv for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:54:49 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsbI-00053k-7H
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:48 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsbI-00012E-3v
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/32] xfs: make growfs initialise the AGFL header
Date: Mon, 12 Nov 2012 22:54:00 +1100
Message-Id: <1352721264-3700-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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
set of values. For upcoming CRC changes, they are also headers that
need to be initialised. Currently, growfs does neither for the AGFLs
- it ignores them completely. Add initialisation of the AGFL to be
full of invalid block numbers (NULLAGBLOCK) to put the
infrastructure in place needed for CRC support.

Includes a comment clarification from Jeff Liu.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2196830..bd9cb7f 100644
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
@@ -207,7 +208,7 @@ xfs_growfs_data_private(
 	nfree = 0;
 	for (agno = nagcount - 1; agno >= oagcount; agno--, new -= agsize) {
 		/*
-		 * AG freelist header block
+		 * AG freespace header block
 		 */
 		bp = xfs_growfs_get_hdr_buf(mp,
 				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
@@ -244,6 +245,26 @@ xfs_growfs_data_private(
 			goto error0;
 
 		/*
+		 * AG freelist header block
+		 */
+		bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1), 0);
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
