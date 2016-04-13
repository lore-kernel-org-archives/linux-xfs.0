Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55E257CAF
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 00:32:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E597AC006
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:32:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	8c6E9byNKHWGb61o for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 22:32:23 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aqDPP-0003p2-Qz
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:32:11 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aqDOq-0000bi-BJ
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/11] xfs: xfs_iflush_cluster fails to abort on error
Date: Wed, 13 Apr 2016 15:31:23 +1000
Message-Id: <1460525492-1170-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1460525492-1170-1-git-send-email-david@fromorbit.com>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
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

When a failure due to an inode buffer occurs, the error handling
fails to abort the inode writeback correctly. This can result in the
inode being reclaimed whilst still in the AIL, leading to
use-after-free situations as well as filesystems that cannot be
unmounted as the inode log items left in the AIL never get removed.

Fix this by ensuring fatal errors from xfs_imap_to_bp() result in
the inode flush being aborted correctly.

cc: <stable@vger.kernel.org> # 3.10.x-
Reported-by: Shyam Kaushik <shyam@zadarastorage.com>
Diagnosed-by: Shyam Kaushik <shyam@zadarastorage.com>
Tested-by: Shyam Kaushik <shyam@zadarastorage.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f79ea59..e97ae5d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3314,7 +3314,7 @@ xfs_iflush(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_buf		*bp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_dinode	*dip;
 	int			error;
 
@@ -3356,14 +3356,22 @@ xfs_iflush(
 	}
 
 	/*
-	 * Get the buffer containing the on-disk inode.
+	 * Get the buffer containing the on-disk inode. We are doing a try-lock
+	 * operation here, so we may get  an EAGAIN error. In that case, we
+	 * simply want to return with the inode still dirty.
+	 *
+	 * If we get any other error, we effectively have a corruption situation
+	 * and we cannot flush the inode, so we treat it the same as failing
+	 * xfs_iflush_int().
 	 */
 	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
 			       0);
-	if (error || !bp) {
+	if (error == -EAGAIN) {
 		xfs_ifunlock(ip);
 		return error;
 	}
+	if (error)
+		goto corrupt_out;
 
 	/*
 	 * First flush out the inode that xfs_iflush was called with.
@@ -3391,7 +3399,8 @@ xfs_iflush(
 	return 0;
 
 corrupt_out:
-	xfs_buf_relse(bp);
+	if (bp)
+		xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 cluster_corrupt_out:
 	error = -EFSCORRUPTED;
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
