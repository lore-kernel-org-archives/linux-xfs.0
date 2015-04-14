Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AF8B7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 02:27:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D8248F804B
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 00:27:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DMFYoX5sGP2lVsO1 for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 00:27:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YhvFE-0000qZ-SV
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YhvFE-0000VU-Rn
	for xfs@oss.sgi.com; Tue, 14 Apr 2015 17:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: factor DIO write mapping from get_blocks
Date: Tue, 14 Apr 2015 17:26:44 +1000
Message-Id: <1428996411-1507-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1428996411-1507-1-git-send-email-david@fromorbit.com>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
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

Clarify and separate the buffer mapping logic so that the direct IO mapping is
not tangled up in propagating the extent status to teh mapping buffer. This
makes it easier to extend the direct IO mapping to use an ioend in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a9b7a1..5f7ddd5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1233,6 +1233,22 @@ xfs_vm_releasepage(
 	return try_to_free_buffers(page);
 }
 
+/*
+ * do all the direct IO specific mapping buffer manipulation here.
+ */
+static void
+xfs_map_direct(
+	struct inode		*inode,
+	struct buffer_head	*bh_result,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	if (ISUNWRITTEN(imap)) {
+		bh_result->b_private = inode;
+		set_buffer_defer_completion(bh_result);
+	}
+}
+
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1332,20 +1348,14 @@ __xfs_get_blocks(
 	}
 
 	if (imap.br_startblock != HOLESTARTBLOCK &&
-	    imap.br_startblock != DELAYSTARTBLOCK) {
-		/*
-		 * For unwritten extents do not report a disk address on
-		 * the read case (treat as if we're reading into a hole).
-		 */
-		if (create || !ISUNWRITTEN(&imap))
-			xfs_map_buffer(inode, bh_result, &imap, offset);
-		if (create && ISUNWRITTEN(&imap)) {
-			if (direct) {
-				bh_result->b_private = inode;
-				set_buffer_defer_completion(bh_result);
-			}
+	    imap.br_startblock != DELAYSTARTBLOCK &&
+	    (create || !ISUNWRITTEN(&imap))) {
+		xfs_map_buffer(inode, bh_result, &imap, offset);
+		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
-		}
+		/* direct IO needs special help */
+		if (create && direct)
+			xfs_map_direct(inode, bh_result, &imap, offset);
 	}
 
 	/*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
