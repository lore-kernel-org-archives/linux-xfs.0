Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACE587F3F
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 09:40:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C9B88F8084
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 07:40:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5iyiCu520FfIyAjB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Sep 2013 07:40:38 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r8KEebiW025323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:40:38 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8KEeaqW015847
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:40:37 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8KEeaDQ006102 for <xfs@oss.sgi.com>; Fri, 20 Sep 2013 14:40:36 GMT
Message-ID: <523C5E92.8000406@oracle.com>
Date: Fri, 20 Sep 2013 22:41:22 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: improve xfs_iext_destroy() by freeing extent indirection
	array directly
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

To free the incore file extents stores at the indirection array, we
call the common routine xfs_iext_irec_remove() to remove a record
from the array one at a time in reverse order, which will resize an
extent indirection array repeatedly according to the array size.

This is not often the case to make a file with thousands extent records
stores at an indirection array, but above operation is inefficient and
could result in memory fragments.

This patch refine xfs_iext_destroy() by freeing the extent records from
the indirection array directly in this case.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_inode_fork.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 02f1083..ba70f98 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1525,9 +1525,12 @@ xfs_iext_destroy(
 		int	nlists;
 
 		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-		for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
-			xfs_iext_irec_remove(ifp, erp_idx);
+		for (erp_idx = 0; erp_idx < nlists; erp_idx++) {
+			xfs_ext_irec_t	*erp = &ifp->if_u1.if_ext_irec[erp_idx];
+			if (erp->er_extbuf)
+				kmem_free(erp->er_extbuf);
 		}
+		kmem_free(ifp->if_u1.if_ext_irec);
 		ifp->if_flags &= ~XFS_IFEXTIREC;
 	} else if (ifp->if_real_bytes) {
 		kmem_free(ifp->if_u1.if_extents);
-- 1.7.9.5 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
