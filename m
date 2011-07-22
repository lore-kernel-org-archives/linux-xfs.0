Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0Yt4H051589 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:34:55 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B582D1D8A85E
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:34:54 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id xgEewNOSdHJb99N9 for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:34:54 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M02Ztg003154
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:02:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0Xcrc159408 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:33:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6M0XbjN003715 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:33:37 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:33 -0700
Message-Id: <20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Remove the definition and usages of the macro XFS_BUF_SET_PTR.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log.c           |    5 +++--
 fs/xfs/xfs_log_recover.c   |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6ae7bde..7b1f484 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -261,7 +261,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 #define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
 
-#define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
 #define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4255a1c..21e770f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1395,8 +1395,9 @@ xlog_sync(xlog_t		*log,
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
-					    (__psint_t)count), split);
+		xfs_buf_associate_memory(bp,
+				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
+				    (__psint_t)count), split);
 		bp->b_fspriv = iclog;
 		bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
 		XFS_BUF_ASYNC(bp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11ff19c..3f77077 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -223,14 +223,14 @@ xlog_bread_offset(
 	int		orig_len = bp->b_buffer_length;
 	int		error, error2;
 
-	error = XFS_BUF_SET_PTR(bp, offset, BBTOB(nbblks));
+	error = xfs_buf_associate_memory(bp, offset, BBTOB(nbblks));
 	if (error)
 		return error;
 
 	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
 
 	/* must reset buffer pointer even on error */
-	error2 = XFS_BUF_SET_PTR(bp, orig_offset, orig_len);
+	error2 = xfs_buf_associate_memory(bp, orig_offset, orig_len);
 	if (error)
 		return error;
 	return error2;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
