Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D8C029DFC
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 06:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D6678F804B
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 04:47:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rwM0uD49TT2VcFp9 for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 04:47:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGp5B-0003VZ-1Z
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGp5B-0005MQ-0s
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: aborted buf items can be in the AIL.
Date: Tue,  3 Sep 2013 21:47:37 +1000
Message-Id: <1378208858-20557-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378208858-20557-1-git-send-email-david@fromorbit.com>
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
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

Saw this on generic/270 after a DQALLOC transaction overrun
shutdown:

XFS: Assertion failed: !(bip->bli_item.li_flags & XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 952
.....
 xfs_buf_item_relse+0x4f/0xd0
 xfs_buf_item_unlock+0x1b4/0x1e0
 xfs_trans_free_items+0x7d/0xb0
 xfs_trans_cancel+0x13c/0x1b0
 xfs_symlink+0x37e/0xa60
....

When a transaction abort occured.

If we are aborting a transaction and trigger this code path, then
the item may be dirty. If the item is dirty, then it may be in the
AIL. Hence if we are aborting, we need to check if the item is in
the AIL and remove it before freeing it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3a944b1..88c5ea7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -613,13 +613,27 @@ xfs_buf_item_unlock(
 			}
 		}
 	}
-	if (clean || aborted) {
-		if (atomic_dec_and_test(&bip->bli_refcount)) {
-			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
+
+	/*
+	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
+	 * buffers may be dirty and hence in the AIL. Therefore if we are
+	 * aborting a buffer and we've just taken the last refernce away, we
+	 * have to check if it is in the AIL before freeing it. We need to free
+	 * it in this case, because an aborted transaction has already shut the
+	 * filesystem down and this is the last chance we will have to do so.
+	 */
+	if (atomic_dec_and_test(&bip->bli_refcount)) {
+		if (clean)
+			xfs_buf_item_relse(bp);
+		else if (aborted) {
+			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+			if (lip->li_flags & XFS_LI_IN_AIL) {
+				xfs_trans_ail_delete(lip->li_ailp, lip,
+						     SHUTDOWN_LOG_IO_ERROR);
+			}
 			xfs_buf_item_relse(bp);
 		}
-	} else
-		atomic_dec(&bip->bli_refcount);
+	}
 
 	if (!(flags & XFS_BLI_HOLD))
 		xfs_buf_relse(bp);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
