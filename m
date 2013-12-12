Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 72A5B7F53
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:38:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C3D9AC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:38:55 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id z9H75jhwwrhCG5VT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:38:54 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7cquB021028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:53 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cq6o021055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:52 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cqje021047 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:52 GMT
Message-ID: <52A96809.9020702@oracle.com>
Date: Thu, 12 Dec 2013 15:38:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 6/8] xfs: use xfs_icluster_size_fsb in xfs_ialloc_inode_init
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

Use xfs_icluster_size_fsb() in xfs_ialloc_inode_init(), rename variable
ninodes to inodes_per_cluster, the later is more meaningful.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5acba64..492ac88 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -170,27 +170,20 @@ xfs_ialloc_inode_init(
 {
 	struct xfs_buf		*fbuf;
 	struct xfs_dinode	*free;
-	int			blks_per_cluster, nbufs, ninodes;
+	int			nbufs, blks_per_cluster, inodes_per_cluster;
 	int			version;
 	int			i, j;
 	xfs_daddr_t		d;
 	xfs_ino_t		ino = 0;
 
 	/*
-	 * Loop over the new block(s), filling in the inodes.
-	 * For small block sizes, manipulate the inodes in buffers
-	 * which are multiples of the blocks size.
+	 * Loop over the new block(s), filling in the inodes.  For small block
+	 * sizes, manipulate the inodes in buffers  which are multiples of the
+	 * blocks size.
 	 */
-	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
-		blks_per_cluster = 1;
-		nbufs = length;
-		ninodes = mp->m_sb.sb_inopblock;
-	} else {
-		blks_per_cluster = mp->m_inode_cluster_size /
-				   mp->m_sb.sb_blocksize;
-		nbufs = length / blks_per_cluster;
-		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
-	}
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+	nbufs = length / blks_per_cluster;
 
 	/*
 	 * Figure out what version number to use in the inodes we create.  If
@@ -246,7 +239,7 @@ xfs_ialloc_inode_init(
 		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
-		for (i = 0; i < ninodes; i++) {
+		for (i = 0; i < inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
 			uint	isize = xfs_dinode_size(version);
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
