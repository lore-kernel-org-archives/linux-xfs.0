Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 335617F61
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 22:21:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04AA88F8035
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 20:21:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WtFPzfOdxPcMDWVj for <xfs@oss.sgi.com>;
	Sun, 30 Nov 2014 20:21:00 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvIT5-0001d8-1h
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvIT5-00026u-0m
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: cleanup xfs_bmse_shift_one goto mess
Date: Mon,  1 Dec 2014 15:20:07 +1100
Message-Id: <1417407608-8016-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1417407608-8016-1-git-send-email-david@fromorbit.com>
References: <1417407608-8016-1-git-send-email-david@fromorbit.com>
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

xfs_bmse_shift_one() jumps around determining whether to shift or
merge, making the code flow difficult to follow. Clean it up and
use direct error returns (including XFS_WANT_CORRUPTED_RETURN) to
make the code flow better and be easier to read.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 20d2e96..0628a67 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5544,35 +5544,29 @@ xfs_bmse_shift_one(
 	startoff = got.br_startoff - offset_shift_fsb;
 
 	/* delalloc extents should be prevented by caller */
-	XFS_WANT_CORRUPTED_GOTO(!isnullstartblock(got.br_startblock),
-				out_error);
+	XFS_WANT_CORRUPTED_RETURN(!isnullstartblock(got.br_startblock));
 
 	/*
-	 * If this is the first extent in the file, make sure there's enough
-	 * room at the start of the file and jump right to the shift as there's
-	 * no left extent to merge.
+	 * Check for merge if we've got an extent to the left, otherwise make
+	 * sure there's enough room at the start of the file for the shift.
 	 */
-	if (*current_ext == 0) {
-		if (got.br_startoff < offset_shift_fsb)
-			return -EINVAL;
-		goto shift_extent;
-	}
+	if (*current_ext) {
+		/* grab the left extent and check for a large enough hole */
+		leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
+		xfs_bmbt_get_all(leftp, &left);
 
-	/* grab the left extent and check for a large enough hole */
-	leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
-	xfs_bmbt_get_all(leftp, &left);
+		if (startoff < left.br_startoff + left.br_blockcount)
+			return -EINVAL;
 
-	if (startoff < left.br_startoff + left.br_blockcount)
+		/* check whether to merge the extent or shift it down */
+		if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
+			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
+					      *current_ext, gotp, leftp, cur,
+					      logflags);
+		}
+	} else if (got.br_startoff < offset_shift_fsb)
 		return -EINVAL;
 
-	/* check whether to merge the extent or shift it down */
-	if (!xfs_bmse_can_merge(&left, &got, offset_shift_fsb))
-		goto shift_extent;
-
-	return xfs_bmse_merge(ip, whichfork, offset_shift_fsb, *current_ext,
-			      gotp, leftp, cur, logflags);
-
-shift_extent:
 	/*
 	 * Increment the extent index for the next iteration, update the start
 	 * offset of the in-core extent and update the btree if applicable.
@@ -5589,14 +5583,11 @@ shift_extent:
 				   got.br_blockcount, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
 
 	got.br_startoff = startoff;
 	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
 				got.br_blockcount, got.br_state);
-
-out_error:
-	return error;
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
