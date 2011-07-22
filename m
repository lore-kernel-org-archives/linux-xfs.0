Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MNeOLY117669 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:40:24 -0500
Received: from e35.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36E5E8F9E3
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:23 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id 9w1viB0a4VhW3enr for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:40:23 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MNLObj020938
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:21:24 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MNeNGE206794 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:40:23 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MHeMZE025168
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:40:22 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 22 Jul 2011 16:40:22 -0700
Message-Id: <20110722234021.14612.46023.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 08/12 v3] xfs: Remove the macro XFS_BUF_SET_PTR
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
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log.c           |    4 ++--
 fs/xfs/xfs_log_recover.c   |    4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

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
index 99680d3..923f84a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1395,8 +1395,8 @@ xlog_sync(xlog_t		*log,
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
-					    (__psint_t)count), split);
+		xfs_buf_associate_memory(bp,
+				(void *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
 		XFS_BUF_ASYNC(bp);
 		bp->b_flags |= XBF_SYNCIO;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c37c1ea..d1fdef9 100644
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
