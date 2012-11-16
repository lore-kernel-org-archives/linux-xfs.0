Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6hfWh067248 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:43:41 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5pSSKAzoW56Nallu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:45:47 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6jklL020107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:47 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6jkhN022859
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:46 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6jkrV010989 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:46 -0600
Message-ID: <50A5E115.6040704@oracle.com>
Date: Fri, 16 Nov 2012 14:45:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 06/15] xfs: Introduce a new transaction type for inode swapping
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

This is a new transaction type which would be used for the coming inode
swapping ioctl(2).

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 14f897d..33aafda 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -108,7 +108,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
 #define XFS_TRANS_SET_AGSTATE		43
-#define	XFS_TRANS_TYPE_MAX		43
+#define XFS_TRANS_SWAPINO		44
+#define	XFS_TRANS_TYPE_MAX		44
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -154,7 +155,8 @@ typedef struct xfs_trans_header {
 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }, \
-	{ XFS_TRANS_SET_AGSTATE,	"SET_AGSTATE" }
+	{ XFS_TRANS_SET_AGSTATE,	"SET_AGSTATE" }, \
+	{ XFS_TRANS_SWAPINO,		"SWAPINO" }
 
 /*
  * This structure is used to track log items associated with
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
