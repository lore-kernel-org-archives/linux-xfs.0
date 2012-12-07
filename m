Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CAxVA215451 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:10:59 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RmVRYhO3FQG81XMg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:13:24 -0800 (PST)
Message-ID: <50C1DD5C.7070004@oracle.com>
Date: Fri, 07 Dec 2012 20:13:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/4] Make super block unit change related transactions aware
	of this change
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

Make xfs_mount related transaction reservation works with this new wapper.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b2bd3a0..81e67d9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1056,8 +1056,9 @@ xfs_mount_reset_sbqflags(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
-				      XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, 0,
+				  mp->m_sb.sb_sectsize + xfs_buf_log_overhead(),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_alert(mp, "%s: Superblock update failed!", __func__);
@@ -1550,8 +1551,9 @@ xfs_log_sbcount(xfs_mount_t *mp)
 		return 0;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
-					XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, 0,
+				  mp->m_sb.sb_sectsize + xfs_buf_log_overhead(),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
@@ -1912,8 +1914,9 @@ xfs_mount_log_sb(
 			 XFS_SB_VERSIONNUM));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
-	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
-				XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, 0,
+				  mp->m_sb.sb_sectsize + xfs_buf_log_overhead(),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
