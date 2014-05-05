Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CEAE37F8E
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:32:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B650E30405F
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:32:37 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PrKXAZS3TXWM3pa7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 05:32:37 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s45CWZEu019758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:36 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s45CWZfr015603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:35 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CWY1s001133 for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:34 GMT
Message-ID: <536784DF.5040509@oracle.com>
Date: Mon, 05 May 2014 20:32:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 6/6] use xfs_icluster_size_fsb in xfs_imap
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

Use xfs_icluster_size_fsb() in xfs_imap().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 libxfs/xfs_ialloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 7d2ae8d..c8967db 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1353,7 +1353,7 @@ xfs_imap(
 		return XFS_ERROR(EINVAL);
 	}
 
-	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
 
 	/*
 	 * For bulkstat and handle lookups, we have an untrusted inode number
@@ -1374,7 +1374,7 @@ xfs_imap(
 	 * If the inode cluster size is the same as the blocksize or
 	 * smaller we get to the buffer by simple arithmetics.
 	 */
-	if (mp->m_inode_cluster_size <= mp->m_sb.sb_blocksize) {
+	if (blks_per_cluster == 1) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
