Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A966D7F6B
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9952F304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:54 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xV7D3KXD9NCZFys2 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YH-N9
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00064l-Lw
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 50/50] xfs: use reference counts to
	free clean buffer items
Date: Mon, 12 Aug 2013 20:50:11 +1000
Message-Id: <1376304611-22994-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

When a transaction is cancelled and the buffer log item is clean in
the transaction, the buffer log item is unconditionally freed. If
the log item is in the AIL, however, this leads to a use after free
condition as the item still has other users.

In this case, xfs_buf_item_relse() should only be called on clean
buffer items if the reference count has dropped to zero. This
ensures only the last user frees the item.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9358504..3a944b1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -613,11 +613,9 @@ xfs_buf_item_unlock(
 			}
 		}
 	}
-	if (clean)
-		xfs_buf_item_relse(bp);
-	else if (aborted) {
+	if (clean || aborted) {
 		if (atomic_dec_and_test(&bip->bli_refcount)) {
-			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
+			ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
 			xfs_buf_item_relse(bp);
 		}
 	} else
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
