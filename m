Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbfHMJDJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 05:03:09 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] xfs: Rename __xfs_buf_submit to xfs_buf_submit
Date: Tue, 13 Aug 2019 12:03:05 +0300
Message-Id: <20190813090306.31278-3-nborisov@suse.com>
In-Reply-To: <20190813090306.31278-1-nborisov@suse.com>
References: <20190813090306.31278-1-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

Since xfs_buf_submit no longer has any callers just rename its __
prefixed counterpart.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_buf.c         | 10 +++++-----
 fs/xfs/xfs_buf.h         |  7 +------
 fs/xfs/xfs_buf_item.c    |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a75d05e49a98..99c66f80d7cc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -759,7 +759,7 @@ _xfs_buf_read(
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
-	return __xfs_buf_submit(bp, wait);
+	return xfs_buf_submit(bp, wait);
 }
 
 /*
@@ -885,7 +885,7 @@ xfs_buf_read_uncached(
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
 
-	__xfs_buf_submit(bp, true);
+	xfs_buf_submit(bp, true);
 	if (bp->b_error) {
 		int	error = bp->b_error;
 		xfs_buf_relse(bp);
@@ -1216,7 +1216,7 @@ xfs_bwrite(
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
 			 XBF_WRITE_FAIL | XBF_DONE);
 
-	error = __xfs_buf_submit(bp, true);
+	error = xfs_buf_submit(bp, true);
 	if (error)
 		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	return error;
@@ -1427,7 +1427,7 @@ xfs_buf_iowait(
  * holds an additional reference itself.
  */
 int
-__xfs_buf_submit(
+xfs_buf_submit(
 	struct xfs_buf	*bp,
 	bool		wait)
 {
@@ -1929,7 +1929,7 @@ xfs_buf_delwri_submit_buffers(
 			bp->b_flags |= XBF_ASYNC;
 			list_del_init(&bp->b_list);
 		}
-		__xfs_buf_submit(bp, false);
+		xfs_buf_submit(bp, false);
 	}
 	blk_finish_plug(&plug);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c6e57a3f409e..ec7037284d62 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -262,12 +262,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
 
-extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
-static inline int xfs_buf_submit(struct xfs_buf *bp)
-{
-	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
-	return __xfs_buf_submit(bp, wait);
-}
+extern int xfs_buf_submit(struct xfs_buf *bp, bool);
 
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fef08980dd21..93f38fdceb80 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1123,7 +1123,7 @@ xfs_buf_iodone_callback_error(
 			bp->b_first_retry_time = jiffies;
 
 		xfs_buf_ioerror(bp, 0);
-		__xfs_buf_submit(bp, false);
+		xfs_buf_submit(bp, false);
 		return true;
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 64e315f80147..9b7822638f83 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5610,7 +5610,7 @@ xlog_do_recover(
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = &xfs_sb_buf_ops;
 
-	error = __xfs_buf_submit(bp, true);
+	error = xfs_buf_submit(bp, true);
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_buf_ioerror_alert(bp, __func__);
-- 
2.17.1
