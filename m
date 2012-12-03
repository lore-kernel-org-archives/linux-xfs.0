Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NefHN067637 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:41 -0600
Message-Id: <20121203144309.930913286@sgi.com>
Date: Mon, 03 Dec 2012 17:42:20 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 12/36] xfs: dont fill statvfs with project quota
	for a directory
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=066
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Jie Liu <jeff.liu@oracle.com>

Upstream commit: da5bf95e3cdca348327c82568c2860229c0daaa2
 if it was not enabled.

Check if the project quota is running or not before performing
xfs_qm_statvfs(), just return if not.  Otherwise the ASSERT
XFS_IS_QUOTA_RUNNING in xfs_qm_dqget will be popped.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1091,7 +1091,7 @@ xfs_fs_statfs(
 
 	spin_unlock(&mp->m_sb_lock);
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
