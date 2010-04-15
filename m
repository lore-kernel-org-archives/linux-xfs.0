Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3FIFjM6183284 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 13:15:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 880A7AC017
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 11:17:41 -0700 (PDT)
Subject: [PATCH 5/5] xfs: kill off l_sectbb_mask
From: Alex Elder <aelder@sgi.com>
Date: Thu, 15 Apr 2010 13:17:40 -0500
Message-ID: <1271355460.2680.94.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There remains only one user of the l_sectbb_mask field in the log
structure.  Just kill it off and compute the mask where needed
from the power-of-2 sector size.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log.c         |    1 -
 fs/xfs/xfs_log_priv.h    |    4 +---
 fs/xfs/xfs_log_recover.c |   14 +++++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1089,7 +1089,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		}
 	}
 	log->l_sectsize = 1 << size;
-	log->l_sectbb_mask = log->l_sectsize - 1;
 
 	xlog_get_iclog_buffer_size(mp, log);
 
Index: b/fs/xfs/xfs_log_priv.h
===================================================================
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -396,9 +396,7 @@ typedef struct log {
 	struct xfs_buf_cancel	**l_buf_cancel_table;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
-	uint			l_sectsize;     /* sector size in BBs */
-	uint			l_sectbb_mask;  /* sector size (in BBs)
-						 * alignment mask */
+	uint			l_sectsize;     /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_size_log; /* log power size of log */
 	int			l_iclog_bufs;	/* number of iclog buffers */
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -121,6 +121,10 @@ xlog_put_bp(
 	xfs_buf_free(bp);
 }
 
+/*
+ * Return the address of the start of the given block number's data
+ * in a log buffer.  The buffer covers a log sector-aligned region.
+ */
 STATIC xfs_caddr_t
 xlog_align(
 	xlog_t		*log,
@@ -128,14 +132,14 @@ xlog_align(
 	int		nbblks,
 	xfs_buf_t	*bp)
 {
+	xfs_daddr_t	offset;
 	xfs_caddr_t	ptr;
 
-	if (log->l_sectsize == 1)
-		return XFS_BUF_PTR(bp);
+	offset = blk_no & ((xfs_daddr_t) log->l_sectsize - 1);
+	ptr = XFS_BUF_PTR(bp) + BBTOB(offset);
+
+	ASSERT(ptr + BBTOB(nbblks) <= XFS_BUF_PTR(bp) + XFS_BUF_SIZE(bp));
 
-	ptr = XFS_BUF_PTR(bp) + BBTOB((int)blk_no & log->l_sectbb_mask);
-	ASSERT(XFS_BUF_SIZE(bp) >=
-		BBTOB(nbblks + (blk_no & log->l_sectbb_mask)));
 	return ptr;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
