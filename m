Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49E4729DF8
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 02:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0E34AC001
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 00:41:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id u8KtIokNCDKFjHKh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 May 2013 00:41:27 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r437fP8A021333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 3 May 2013 07:41:26 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r437fOHw010657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 3 May 2013 07:41:25 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r437fOJj002312 for <xfs@oss.sgi.com>; Fri, 3 May 2013 07:41:24 GMT
Message-ID: <51836A1F.2020804@oracle.com>
Date: Fri, 03 May 2013 15:41:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove two dead transaction log reservaion macros
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

Upstream commit 5b292ae3a951a58e32119d73c7ac8f5bec7395a3
	xfs: make use of xfs_calc_buf_res() in xfs_trans.c

Beginning from above commit, neither XFS_ALLOCFREE_LOG_RES() nor
XFS_DIROP_LOG_RES() is used by those routines for calculating
transaction space reservations, so it's safe to remove them now.

Also, with a slightly update for the relevant comments to reflect
the ideas of why those log count numbers should be.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cd29f61..0b4db9b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -210,23 +210,18 @@ struct xfs_log_item_desc {
 /*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
- * 2 trees * (2 blocks/level * max depth - 1) * block size
+ * 2 trees * (2 blocks/level * max depth - 1)
  */
-#define	XFS_ALLOCFREE_LOG_RES(mp,nx) \
-	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * XFS_AG_MAXLEVELS(mp) - 1)))
 #define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
 	((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
 
 /*
  * Per-directory log reservation for any directory change.
- * dir blocks: (1 btree block per level + data block + free block) * dblock size
- * bmap btree: (levels + 2) * max depth * block size
+ * dir blocks: (1 btree block per level + data block + free block)
+ * bmap btree: (levels + 2) * max depth
  * v2 directory blocks can be fragmented below the dirblksize down to the fsb
  * size, so account for that in the DAENTER macros.
  */
-#define	XFS_DIROP_LOG_RES(mp)	\
-	(XFS_FSB_TO_B(mp, XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK)) + \
-	 (XFS_FSB_TO_B(mp, XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)))
 #define	XFS_DIROP_LOG_COUNT(mp)	\
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
