Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6GFkdVi001049 for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 10:46:39 -0500
Received: from e35.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 964B416802BD
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2011 08:46:37 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id 4IXiqgbnETN8enI7 for
	<xfs@oss.sgi.com>; Sat, 16 Jul 2011 08:46:37 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G137f1024771
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:03:07 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1Ls3P135894 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:21:54 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6FJLQBr009719
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 13:21:26 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:53 -0700
Message-Id: <20110716012153.6629.13580.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_log.c           |    5 +++--
 fs/xfs/xfs_log_recover.c   |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index e426219..7149c07 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -275,7 +275,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_FSPRIVATE2(bp, type)		((type)(bp)->b_fspriv2)
 #define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
 
-#define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
 #define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 23158a5..cb86754 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1405,8 +1405,9 @@ xlog_sync(xlog_t		*log,
 							(unsigned long)1);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
-					    (__psint_t)count), split);
+		xfs_buf_associate_memory(bp,
+				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
+				    (__psint_t)count), split);
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
 		bp->b_flags &=
 			~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 01b5417..15e3bc0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -219,14 +219,14 @@ xlog_bread_offset(
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
