Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p732IaxL128018 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 21:18:37 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5053B6745
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 19:18:36 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id lUIf8c9Sv6fzgQIi for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2011 19:18:36 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7325Zsg001740
	for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 22:05:35 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p732IZTq078324 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 22:18:35 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p72MINVV004058 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 19:18:23 -0300
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 02 Aug 2011 19:18:34 -0700
Message-Id: <20110803021834.29700.40199.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 2/2] xfs: replace xfs_buf_geterror() with bp->b_error
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

Since we just checked bp for NULL, it is ok to replace xfs_buf_geterror()
with bp->b_error in these places.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_vnodeops.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8478532..a9df667 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2133,7 +2133,7 @@ xlog_recover_buffer_pass2(
 			  buf_flags);
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
-	error = xfs_buf_geterror(bp);
+	error = bp->b_error;
 	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
 				  bp, buf_f->blf_blkno);
@@ -2228,7 +2228,7 @@ xlog_recover_inode_pass2(
 		error = ENOMEM;
 		goto error;
 	}
-	error = xfs_buf_geterror(bp);
+	error = bp->b_error;
 	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
 				  bp, in_f->ilf_blkno);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 64a5835..d465c94 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -85,7 +85,7 @@ xfs_readlink_bmap(
 				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
-		error = xfs_buf_geterror(bp);
+		error = bp->b_error;
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",
 				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
