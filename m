Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p732IZZ3128008 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 21:18:35 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9239B6742
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 19:18:34 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id yOxpDC6LFSFO7Cda for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2011 19:18:34 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p732FNGw029906
	for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 20:15:23 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p732ITTS191102 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 20:18:29 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p72KISF2022461
	for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 14:18:28 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 02 Aug 2011 19:18:29 -0700
Message-Id: <20110803021829.29700.98205.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 1/2] xfs: Check the return value of xfs_buf_read() for NULL
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

Check the return value of xfs_buf_read() for NULL and return ENOMEM if it is NULL.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_log_recover.c |    6 ++++++
 fs/xfs/xfs_rw.c          |    2 +-
 fs/xfs/xfs_vnodeops.c    |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 93786e5..8478532 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2131,6 +2131,8 @@ xlog_recover_buffer_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags);
+	if (!bp)
+		return XFS_ERROR(ENOMEM);
 	error = xfs_buf_geterror(bp);
 	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
@@ -2222,6 +2224,10 @@ xlog_recover_inode_pass2(
 
 	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
 			  XBF_LOCK);
+	if (!bp) {
+		error = ENOMEM;
+		goto error;
+	}
 	error = xfs_buf_geterror(bp);
 	if (error) {
 		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index c96a8a0..ecaa60e 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -136,7 +136,7 @@ xfs_read_buf(
 
 	bp = xfs_buf_read(target, blkno, len, flags);
 	if (!bp)
-		return XFS_ERROR(EIO);
+		return (flags & XBF_TRYLOCK) ?  0 : XFS_ERROR(EIO);
 	error = bp->b_error;
 	if (!error && !XFS_FORCED_SHUTDOWN(mp)) {
 		*bpp = bp;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 3ee5f8a..64a5835 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -83,6 +83,8 @@ xfs_readlink_bmap(
 
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
 				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
+		if (!bp)
+			return XFS_ERROR(ENOMEM);
 		error = xfs_buf_geterror(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
