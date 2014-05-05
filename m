Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 227FD7F81
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:32:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE7D18F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:32:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id w7UZYOSlHZtzTq51 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 05:32:31 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s45CWUa6019689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:30 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CWTeQ009803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:29 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CWTfc000903 for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:29 GMT
Message-ID: <536784D9.1030502@oracle.com>
Date: Mon, 05 May 2014 20:32:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 5/6] xfsprogs: use xfs_icluster_size_fsb in
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

Use xfs_icluster_size_fsb() in xfs_ialloc_inode_init(), rename variable
ninodes to inodes_per_cluster as the latter is more  meaningful.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 libxfs/xfs_ialloc.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index a3a1c75..7d2ae8d 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -146,7 +146,7 @@ xfs_ialloc_inode_init(
 {
 	struct xfs_buf		*fbuf;
 	struct xfs_dinode	*free;
-	int			blks_per_cluster, nbufs, ninodes;
+	int			nbufs, blks_per_cluster, inodes_per_cluster;
 	int			version;
 	int			i, j;
 	xfs_daddr_t		d;
@@ -157,16 +157,9 @@ xfs_ialloc_inode_init(
 	 * For small block sizes, manipulate the inodes in buffers
 	 * which are multiples of the blocks size.
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
@@ -222,7 +215,7 @@ xfs_ialloc_inode_init(
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
