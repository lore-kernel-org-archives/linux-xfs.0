Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77C627F6D
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B10B8F8039
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:32:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NbAoXphqrLASHcoG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 05:32:27 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s45CWQUS019649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:27 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CWPXF006067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:26 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s45CWOMB015187 for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:25 GMT
Message-ID: <536784D4.1050405@oracle.com>
Date: Mon, 05 May 2014 20:32:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 4/6] xfsprogs: introduce xfs_icluster_size_fsb()
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

Introduce a common routine xfs_icluster_size_fsb() to calculate
and return the number of file system blocks per inode cluster.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/xfs_ialloc.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 0498f20..9dee62f 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -30,6 +30,16 @@ struct xfs_btree_cur;
  */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
 
+/* Calculate and return the number of filesystem blocks per inode cluster */
+static inline int
+xfs_icluster_size_fsb(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size)
+		return 1;
+	return mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
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
