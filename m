Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A4BC529E1C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 07:48:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BDE5AC01B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 05:48:14 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DXjQWSvHed4pmpPi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 05:48:11 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBBDmAwY031189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:11 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBBDm9iK022565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:10 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBBDm9NY022557 for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:09 GMT
Message-ID: <52A86D11.1040504@oracle.com>
Date: Wed, 11 Dec 2013 21:48:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/5] xfs: introduce xfs_ialloc_blks_per_cluster
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Introduce a common routine xfs_ialloc_blks_per_cluster() to calculate
and return the number of blocks per inode cluster.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index a8f76a5..f4bfd32 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -37,6 +37,16 @@ struct xfs_btree_cur;
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
 #define	XFS_INODE_CLUSTER_SIZE(mp)	(mp)->m_inode_cluster_size
 
+/* Calculate and return the number of blocks per inode cluster */
+static inline int
+xfs_ialloc_blks_per_cluster(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))
+		return 1;
+	return XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
+}
+
 /*
  * Make an inode pointer out of the buffer/offset.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
