Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23A7E7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 01:51:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6971304089
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 23:51:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 54mx01xPltDpCK1X (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 23:51:44 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9P6phXj021235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:51:44 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9P6pgfx025450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:51:43 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9P6pgGn025441 for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 06:51:42 GMT
Message-ID: <526A153C.2090408@oracle.com>
Date: Fri, 25 Oct 2013 14:52:44 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: fix the extent count when allocating an new
	indirection array entry
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

At xfs_iext_add(), if extent(s) are being appended to the last page in
the indirection array and the new extent(s) don't fit in the page, the
number of extents(erp->er_extcount) in a new allocated entry should be
the minimum value between count and XFS_LINEAR_EXTS, instead of count.

For now, there is no existing test case can demonstrates a problem with
the er_extcount being set incorrectly here, but it obviously like a bug.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
v2: * Declare count to uint as it will be decreased to 0 and XFS_LINEAR_EXTS
      can be uint because of a case in the macro.
    * Convert MIN() to min().
    * Revise the commits log to indicate there is no existing test case can
      reflect this issue for future tracking up.

 fs/xfs/xfs_inode_fork.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 22c9837..cfee14a 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1021,15 +1021,14 @@ xfs_iext_add(
 		 * the next index needed in the indirection array.
 		 */
 		else {
-			int	count = ext_diff;
+			uint	count = ext_diff;
 
 			while (count) {
 				erp = xfs_iext_irec_new(ifp, erp_idx);
-				erp->er_extcount = count;
-				count -= MIN(count, (int)XFS_LINEAR_EXTS);
-				if (count) {
+				erp->er_extcount = min(count, XFS_LINEAR_EXTS);
+				count -= erp->er_extcount;
+				if (count)
 					erp_idx++;
-				}
 			}
 		}
 	}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
