Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C7607F55
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 01:21:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD740AC008
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 23:21:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Fo3brGQnAEAis10B for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 23:21:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFI5D-0001bR-HE
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFI5D-0008J3-Ga
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 16:21:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: XFS_MOUNT_QUOTA_ALL needed by userspace
Date: Fri, 30 Aug 2013 16:21:21 +1000
Message-Id: <1377843681-31878-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1377843681-31878-1-git-send-email-david@fromorbit.com>
References: <1377843681-31878-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

So move it to a header file shared with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_format.h | 6 ++++++
 fs/xfs/xfs_quota.h      | 7 -------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index 5b7ba98..ca7e28a 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -825,6 +825,12 @@ typedef struct xfs_qoff_logformat {
 #define XFS_ALL_QUOTA_CHKD	\
 		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
 
+#define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
+				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
+				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD|\
+				 XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD|\
+				 XFS_PQUOTA_CHKD)
+
 /*
  * Inode create log item structure
  *
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 66522da..e7d84d2 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -48,13 +48,6 @@ struct xfs_trans;
 	 (XFS_IS_PQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
-#define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD|\
-				 XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD|\
-				 XFS_PQUOTA_CHKD)
-
-
 /*
  * The structure kept inside the xfs_trans_t keep track of dquot changes
  * within a transaction and apply them later.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
