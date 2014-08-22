Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB2D57F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 20:03:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B282AC002
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 18:03:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6QrhAoZAk8lAJBCf for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 18:03:13 -0700 (PDT)
Message-ID: <53F696D7.2030906@sandeen.net>
Date: Thu, 21 Aug 2014 20:03:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs: remove rbpp check from xfs_rtmodify_summary_int
References: <53F6942B.80808@redhat.com>
In-Reply-To: <53F6942B.80808@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

rbpp is always passed into xfs_rtmodify_summary
and xfs_rtget_summary, so there is no need to
test for it in xfs_rtmodify_summary_int.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 50e3b93..7c818f1 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -460,7 +460,7 @@ xfs_rtmodify_summary_int(
 	/*
 	 * If we have an old buffer, and the block number matches, use that.
 	 */
-	if (rbpp && *rbpp && *rsb == sb)
+	if (*rbpp && *rsb == sb)
 		bp = *rbpp;
 	/*
 	 * Otherwise we have to get the buffer.
@@ -469,7 +469,7 @@ xfs_rtmodify_summary_int(
 		/*
 		 * If there was an old one, get rid of it first.
 		 */
-		if (rbpp && *rbpp)
+		if (*rbpp)
 			xfs_trans_brelse(tp, *rbpp);
 		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
 		if (error) {
@@ -478,10 +478,8 @@ xfs_rtmodify_summary_int(
 		/*
 		 * Remember this buffer and block for the next call.
 		 */
-		if (rbpp) {
-			*rbpp = bp;
-			*rsb = sb;
-		}
+		*rbpp = bp;
+		*rsb = sb;
 	}
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
@@ -493,14 +491,8 @@ xfs_rtmodify_summary_int(
 		*sp += delta;
 		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
 	}
-	if (sum) {
-		/*
-		 * Drop the buffer if we're not asked to remember it.
-		 */
-		if (!rbpp)
-			xfs_trans_brelse(tp, bp);
+	if (sum)
 		*sum = *sp;
-	}
 	return 0;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
