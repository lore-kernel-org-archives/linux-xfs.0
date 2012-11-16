Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6h7Xn067174 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:43:07 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UNLXWBS4I3eJkGGm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:45:12 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6jBsq003235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:12 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6jAxx029852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:10 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6jA9X010660 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:10 -0600
Message-ID: <50A5E0F2.5030209@oracle.com>
Date: Fri, 16 Nov 2012 14:45:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 02/15] xfs: Introduce new structure members ag_state/agf_state
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

Introduce new members ag_state && agf_state to struct
xfs_perag and struct xfs_agf separately.

It would be used for two purpose for now:
- get/set state upon a given AG with coming new ioctl(2).
- check whether a given a.g. can be selected for block/inode allocation or not.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ag.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 44d65c1..fd578e6 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -69,6 +69,10 @@ typedef struct xfs_agf {
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	/*
+	 * A.G state for freespace allocation(allow/deny)
+	 */
+	__be32		agf_state;	/* persistent a.g. state */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,7 +87,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define XFS_AGF_STATE		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
@@ -98,7 +103,8 @@ typedef struct xfs_agf {
 	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
 	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
 	{ XFS_AGF_LONGEST,	"LONGEST" }, \
-	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
+	{ XFS_AGF_STATE,	"STATE" }
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
@@ -159,7 +165,7 @@ typedef struct xfs_agi {
 #define	XFS_BUF_TO_AGI(bp)	((xfs_agi_t *)((bp)->b_addr))
 
 extern int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
-				xfs_agnumber_t agno, struct xfs_buf **bpp);
+			xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 /*
  * The third a.g. block contains the a.g. freelist, an array
@@ -225,6 +231,7 @@ typedef struct xfs_perag {
 	struct rcu_head	rcu_head;
 #endif
 	int		pagb_count;	/* pagb slots in use */
+	__uint32_t	pag_state;	/* persistent a.g. state */
 } xfs_perag_t;
 
 /*
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
