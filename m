Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54IQq135650 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qEuyMSXHRcFn3KnY for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbA-0003ID-2G
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Paz-0003gg-SK
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 066/102] xfs: don't fill statvfs with project quota for a
	directory
Date: Thu, 23 Aug 2012 15:02:24 +1000
Message-Id: <1345698180-13612-67-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

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

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index d687329..b86c460 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1106,7 +1106,7 @@ xfs_fs_statfs(
 
 	spin_unlock(&mp->m_sb_lock);
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
+	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
