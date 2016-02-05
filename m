Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D612629E00
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5E2E30405F
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xoeSmTHVR6TNqdiW for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rk-AE
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005Mc-9R
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: remove XBF_READ flag wrapper macros
Date: Fri,  5 Feb 2016 11:38:00 +1100
Message-Id: <1454632683-20543-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1454632683-20543-1-git-send-email-david@fromorbit.com>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
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

They only set/clear/check a flag, no need for obfuscating this
with a macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h         | 4 ----
 fs/xfs/xfs_log_recover.c | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2a28d1c..329e612 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -321,10 +321,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
-#define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
-#define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
-#define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
-
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b34337d..81c525a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -190,7 +190,7 @@ xlog_bread_noalign(
 	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_READ(bp);
+	bp->b_flags |= XBF_READ;
 	bp->b_io_length = nbblks;
 	bp->b_error = 0;
 
@@ -4928,7 +4928,7 @@ xlog_do_recover(
 	bp = xfs_getsb(log->l_mp, 0);
 	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
-	XFS_BUF_READ(bp);
+	bp->b_flags |= XBF_READ;
 	bp->b_ops = &xfs_sb_buf_ops;
 
 	error = xfs_buf_submit_wait(bp);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
