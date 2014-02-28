Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBB7A7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 00:26:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2A45304070
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 22:26:26 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sHLi0PXhwwKSE1Jk for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 22:26:25 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WJGsv-0002RA-0k
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:25 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WJGsv-0000NX-05
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 17:25:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] metadump: contiguous metadata object need to be split
Date: Fri, 28 Feb 2014 17:25:21 +1100
Message-Id: <1393568723-982-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1393568723-982-1-git-send-email-david@fromorbit.com>
References: <1393568723-982-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

On crc enabled filesystems with obfuscation enabled we need to be
able to recalculate the CRCs on individual buffers.
process_single_fsb_objects() reads a contiguous range of single
block objects as a singel buffer, and hence we cannot correctly
recalculate the CRCs on them.

Split the loop up into individual buffer reads, processing and
writes rather than a single read, multiple block processing and a
single write.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 5baf83d..14902a7 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1331,29 +1331,27 @@ process_single_fsb_objects(
 	int		ret = 0;
 	int		i;
 
-	push_cur();
-	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
-			DB_RING_IGN, NULL);
+	for (i = 0; i < c; i++) {
+		push_cur();
+		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), blkbb,
+				DB_RING_IGN, NULL);
 
-	if (!iocur_top->data) {
-		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
-		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
+		if (!iocur_top->data) {
+			xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
+			xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
 
-		print_warning("cannot read %s block %u/%u (%llu)",
-				typtab[btype].name, agno, agbno, s);
-		if (stop_on_read_error)
-			ret = -EIO;
-		goto out_pop;
+			print_warning("cannot read %s block %u/%u (%llu)",
+					typtab[btype].name, agno, agbno, s);
+			if (stop_on_read_error)
+				ret = -EIO;
+			goto out_pop;
 
-	}
+		}
 
-	if (dont_obfuscate) {
-		ret = write_buf(iocur_top);
-		goto out_pop;
-	}
+		if (dont_obfuscate)
+			goto write;
 
-	dp = iocur_top->data;
-	for (i = 0; i < c; i++) {
+		dp = iocur_top->data;
 		switch (btype) {
 		case TYP_DIR2:
 			if (o >= mp->m_dirleafblk)
@@ -1371,13 +1369,17 @@ process_single_fsb_objects(
 		default:
 			break;
 		}
+
+write:
+		ret = write_buf(iocur_top);
+out_pop:
+		pop_cur();
+		if (ret)
+			break;
 		o++;
-		dp += mp->m_sb.sb_blocksize;
+		s++;
 	}
-	ret = write_buf(iocur_top);
 
-out_pop:
-	pop_cur();
 	return ret;
 }
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
