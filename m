Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B2C17F59
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 20:44:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2966DAC004
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:44:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8lO0dmwYIwResCMT for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 18:44:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VLkLB-00069k-Nf
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VLkLB-0007pB-N4
	for xfs@oss.sgi.com; Tue, 17 Sep 2013 11:44:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: lock the AIL before removing the buffer item
Date: Tue, 17 Sep 2013 11:44:30 +1000
Message-Id: <1379382271-29907-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1379382271-29907-1-git-send-email-david@fromorbit.com>
References: <1379382271-29907-1-git-send-email-david@fromorbit.com>
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

Regression introduced by commit 46f9d2e ("xfs: aborted buf items can
be in the AIL") which fails to lock the AIL before removing the
item. Spinlock debugging throws a warning about this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 88c5ea7..f1d85cf 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -628,6 +628,7 @@ xfs_buf_item_unlock(
 		else if (aborted) {
 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
 			if (lip->li_flags & XFS_LI_IN_AIL) {
+				spin_lock(&lip->li_ailp->xa_lock);
 				xfs_trans_ail_delete(lip->li_ailp, lip,
 						     SHUTDOWN_LOG_IO_ERROR);
 			}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
