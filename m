Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 665837F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 18:00:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 525F48F8035
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 16:00:42 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id hjhcF0wBV8gN5ndg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 16:00:41 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 17:00:41 -0600
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5DAA238C804D
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:00:37 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6AN0cTL373284 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:00:38 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r6AN0bWZ019036 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:00:37 -0400
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6AN0b7H019017 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 19:00:37 -0400
Subject: [PATCH] xfs: Fix the logic check for all quotas being turned off
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 10 Jul 2013 18:00:36 -0500
Message-ID: <1373497236.6020.36.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>


During the review of seperate pquota inode patches, David noticed
that the test to detect all quotas being turned off was
incorrect, and hence the block was not freeing all the quota
information.

The check made sense in Irix, but in Linux, quota is turned off
one at a time, which makes the test invalid for Linux.

This problem existed since XFS was ported to Linux.

David suggested to fix the problem by detecting when all quotas are
turned off by checking m_qflags.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm_syscalls.c |    5 ++---
 fs/xfs/xfs_quota.h       |    8 --------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index a08801a..09a45af 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -198,10 +198,9 @@ xfs_qm_scall_quotaoff(
 	}
 
 	/*
-	 * If quotas is completely disabled, close shop.
+	 * If all quotas are completely turned off, close shop.
 	 */
-	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
-	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
+	if (mp->m_qflags == 0) {
 		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
 		return (0);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 40d508b..69e3edf 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -301,14 +301,6 @@ typedef struct xfs_qoff_logformat {
 	 (XFS_IS_PQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
-#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
-
 #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
 				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD|\
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
