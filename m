Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE31D7F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 01:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C367304039
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 23:31:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IGM0lXT3A7DXU2Xy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 23:31:18 -0700 (PDT)
Message-ID: <513D7A26.3030401@oracle.com>
Date: Mon, 11 Mar 2013 14:31:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove obsoleted m_inode_shrink from xfs_mount structure
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
Cc: dchinner@redhat.com

Looks the old m_inode_shrink is obsoleted as we perform inodes reclaim per AG via
m_reclaim_workqueue, this patch remove it from the xfs_mount structure if so.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bc90706..687c171 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -207,7 +207,6 @@ typedef struct xfs_mount {
 						     trimming */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
-	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
