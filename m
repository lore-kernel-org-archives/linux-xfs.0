Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CHdde216048 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:17:39 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Z1q7Qm2jSVmLHaMF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:20:04 -0800 (PST)
Message-ID: <50C1DEEC.6040606@oracle.com>
Date: Fri, 07 Dec 2012 20:19:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: Make repair transaction reservation aware of
	xfs_buf_log_overhead()
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

Make the transaction reservation of repair works with the new xfs_buf_log_overhead().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index cbe0b35..f6b0250 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -711,11 +711,12 @@ mk_rsumino(xfs_mount_t *mp)
 	xfs_bmap_init(&flist, &first);
 
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	if ((error = libxfs_trans_reserve(tp,
-				  mp->m_sb.sb_rbmblocks +
-				      (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
-				  BBTOB(128), 0, XFS_TRANS_PERM_LOG_RES,
-				  XFS_DEFAULT_PERM_LOG_COUNT)))
+	error = libxfs_trans_reserve(tp, mp->m_sb.sb_rbmblocks +
+				     (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
+				     BBTOB(xfs_buf_log_overhead()), 0,
+				     XFS_TRANS_PERM_LOG_RES,
+				     XFS_DEFAULT_PERM_LOG_COUNT);
+	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
