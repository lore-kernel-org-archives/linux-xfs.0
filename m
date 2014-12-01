Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61F997F59
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 22:21:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 480F78F8037
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 20:21:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XvzsTB3AZHwSEXOH for <xfs@oss.sgi.com>;
	Sun, 30 Nov 2014 20:21:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XvIT5-0001d9-2Y
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XvIT5-00026z-1H
	for xfs@oss.sgi.com; Mon, 01 Dec 2014 15:20:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: cleanup xfs_bmse_merge returns
Date: Mon,  1 Dec 2014 15:20:08 +1100
Message-Id: <1417407608-8016-3-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>

xfs_bmse_merge() has a jump label for return that just returns the
error value. Convert all the code to just return the error directly
and use XFS_WANT_CORRUPTED_RETURN. This also allows the final call
to xfs_bmbt_update() to return directly.

Noticed while reviewing coccinelle return cleanup patches and
wondering why the same return pattern as in xfs_bmse_shift_one()
wasn't picked up by the checker pattern...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0628a67..5a42e2b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5489,32 +5489,25 @@ xfs_bmse_merge(
 	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
 				   got.br_blockcount, &i);
 	if (error)
-		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
-		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left.br_startoff, left.br_startblock,
 				   left.br_blockcount, &i);
 	if (error)
-		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(i == 1);
 
 	left.br_blockcount = blockcount;
 
-	error = xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
-				left.br_blockcount, left.br_state);
-	if (error)
-		goto out_error;
-
-	return 0;
-
-out_error:
-	return error;
+	return xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
+			       left.br_blockcount, left.br_state);
 }
 
 /*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
