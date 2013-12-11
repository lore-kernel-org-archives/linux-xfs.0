Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07C5029E23
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 07:48:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAB1C8F8066
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 05:48:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id u9mWqRA1qgaQSobH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 05:48:27 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBBDmQGH031399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:27 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBBDmPBe028643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:26 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBBDmPW9028630 for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:48:25 GMT
Message-ID: <52A86D24.8030801@oracle.com>
Date: Wed, 11 Dec 2013 21:48:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/5] xfs: use xfs_ialloc_blks_per_cluster in
	xfs_ialloc_inode_init
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

Use xfs_ialloc_blks_per_cluster() in xfs_ialloc_inode_init()

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e87719c..30018f6 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -177,20 +177,13 @@ xfs_ialloc_inode_init(
 	xfs_ino_t		ino = 0;
 
 	/*
-	 * Loop over the new block(s), filling in the inodes.
-	 * For small block sizes, manipulate the inodes in buffers
-	 * which are multiples of the blocks size.
+	 * Loop over the new block(s), filling in the inodes.  For small block
+	 * sizes, manipulate the inodes in buffers which are multiples of the
+	 * blocks size.
 	 */
-	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
-		blks_per_cluster = 1;
-		nbufs = length;
-		ninodes = mp->m_sb.sb_inopblock;
-	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
-				   mp->m_sb.sb_blocksize;
-		nbufs = length / blks_per_cluster;
-		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
-	}
+	blks_per_cluster = xfs_ialloc_blks_per_cluster(mp);
+	ninodes = blks_per_cluster << mp->m_sb.sb_inopblog;
+	nbufs = length / blks_per_cluster;
 
 	/*
 	 * Figure out what version number to use in the inodes we create.  If
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
